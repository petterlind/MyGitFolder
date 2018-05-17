clear all
close all

% --------------------------------
% 1) Input
% --------------------------------
% inputfile_trusses
% inputfile_YounChoi
% inputfile_Madsen
% inputfile_Cheng

 inputfile_Cheng10_det
% inputfile_Cheng3_det
% inputfile_TANA

%dp_plot = nan(nx,100);
%dp_color = nan(nx,100);
%fignr = 1;
%fignr_old = fignr;
%non_fesible = nan(nx,1);

% Globals
global Gnum
Gnum = 0;

% Set the Roc_dist
RBDO_s.roc_dist = Update_RoC(RBDO_s, Opt_set, pdata);

% --------------------------------
% 2) Main Loop
% --------------------------------
while Opt_set.outer_conv

    if Opt_set.k > RBDO_s.max_k || Opt_set.l > RBDO_s.max_l
        fprintf('k= %d, l= %d, BREAK \n', Opt_set.k, Opt_set.l)
        break
    end

    %Update counters and inner conv flag.
    Opt_set.k = Opt_set.k + 1;
    Opt_set.l = 0;
    Opt_set.inner_conv = 1;

    % Update mean values
    pdata.marg(:,2) = Opt_set.dp_x;

    % Update stdv.
    if RBDO_s.f_COV
        pdata.marg(:,3) = pdata.marg(:,2) * pdata.cov;
        Opt_set.dp_u = zeros(size(pdata.marg(:,3)));
    end

    % Update the MPP search point. If pdata.marg(:,3) == 0 nothing changes.
    for ii = 1:numel(LS)
        LS(ii).nominal_x_old = LS(ii).nominal_x;
        
        if RBDO_s.f_RoC
            LS(ii).nominal_x = RoC(RBDO_s, pdata, Opt_set, Opt_set.dp_x + LS(ii).beta_v, Opt_set.dp_x,Opt_set.lb,[]);
        else
            LS(ii).nominal_x = Opt_set.dp_x + LS(ii).beta_v;
        end
        
        if ~sum(pdata.marg(:,1)) == 0 % If probabilistic variables!
            LS(ii).nominal_u = U_space(LS(ii).nominal_x, pdata.marg(:,2), pdata.marg(:,3), pdata.marg(:,1)); % LS object
        end     
    end

    % Update objective-gradient direction, doe, alpha
    obj.nominal_u = Opt_set.dp_u; % Objective is from nominal point!
    obj.nominal_x = Opt_set.dp_x;
    obj = Grad(obj, pdata, Opt_set, RBDO_s, 'variables');

    for ii = 1:numel(LS) %For all active constraints
        if LS(ii).active == true
            if pdata.np > 0
                % Update MPP-estimate in probabilistic space
                LS(ii) = Grad(LS(ii), pdata, Opt_set, RBDO_s, 'parameters');
            end

            % FORM estimate of limit states
            LS(ii) = Grad(LS(ii), pdata, Opt_set, RBDO_s, 'variables');
        end

         LS(ii).active = obj.alpha_x' * LS(ii).alpha_x  >  cosd(135);
    end

   % -----------------------
   % Inner loop - one step
   % -----------------------
    while Opt_set.inner_conv

        if Opt_set.l>20
            break
        end
        
        
            for ii = 1:length(LS)
                if LS(ii).active
                    LS(ii).Mpp_x_old = LS(ii).Mpp_x; % Save old value

                    if RBDO_s.f_probe
                        % New probe point and Mpp estimate
                        
                       LS(ii) = do_probe(LS(ii), pdata, Opt_set, RBDO_s);
                    end
                end
                
            end
        

        % save previous value
        Opt_set.dpl_x_old = Opt_set.dpl_x;

        
        if RBDO_s.f_linprog
            
            % Set up optimization
            f = -obj.alpha_x; % x-space
            active = [LS.active] & ~[LS.no_cross] ;
            A = [LS(active).alpha_x]';
            xs = [LS(active).Mpp_x]; % Add some shifted xs!?!!

            if pdata.nx > 0
               xs_new = [LS(active).Mpp_x] - [LS(active).beta_v];
                 b = diag(A*xs_new);
            elseif pdata.nx == 0 && pdata.nd ~=0
               b = diag(A*xs);
            else
               error('Add the last option in b')
            end



            % Optimizer
            options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
            [ Opt_set.dpl_x, fval, RBDO_s.f_linprog, output] = linprog(f, A, b, [],[], Opt_set.lb, Opt_set.ub',options);
        
        elseif RBDO_s.f_penal
           
                  % Update lambda for the limit states
                  list = 1:100;
                  act_con = list(LS.active);

                  if ~isempty([LS.alpha_x_old])
                      list = 1:100;
                      act_con = list([LS.active]);
                      for ii = 1:sum([LS.active])
                            
                          % lambda
                          A0 = LS(act_con(ii)).nominal_x - LS(act_con(ii)).nominal_x_old  ;
                          LS(act_con(ii)).lambda = (A0 - A0'*LS(act_con(ii)).alpha_x_old *LS(act_con(ii)).alpha_x_old) / norm(A0 - A0'*LS(act_con(ii)).alpha_x_old*LS(act_con(ii)).alpha_x_old);
                          
                          %c
                          LS(act_con(ii)).c = (LS(act_con(ii)).nominal_val - LS(act_con(ii)).nominal_val_old) / ((LS(act_con(ii)).lambda' * (LS(act_con(ii)).nominal_x - LS(act_con(ii)).nominal_x_old)) )^2;        
                      end
                  end
                    
                  options = optimoptions('fmincon','Display','notify','StepTolerance',1e-10,'Algorithm','sqp','MaxFunctionEvaluations',1000);
                  OFUN = @(x) -obj.alpha_x'*x;
                  Opt_set.dpl_x = fmincon(OFUN,Opt_set.dp_x,[],[],[],[],Opt_set.lb, Opt_set.ub', @(x) penalfun(x, LS), options);

        end
        

        
        % RoC
        if RBDO_s.f_RoC
            
                    % Feasible step
        FUN = @(X1) norm( X1 - Opt_set.dp_x)^2;
        %options = optimoptions('fmincon','Display','notify','StepTolerance',1e-10,'Algorithm','sqp','MaxFunctionEvaluations',3000);
        feas_x = fmincon(FUN, Opt_set.dp_x, A, b,[],[],Opt_set.lb, Opt_set.ub');
        %feas_x = fmincon(FUN,Opt_set.dp_x,[],[],[],[],Opt_set.lb, Opt_set.ub', @(x) penalfun(x, LS), options);
            RoC_p = RoC(RBDO_s, pdata, Opt_set, feas_x, Opt_set.dp_x, Opt_set.lb, []);
            
            if RoC_p == feas_x %feasible was inside Roc, go towards optimum value!
                RoC_p = RoC(RBDO_s, pdata, Opt_set, Opt_set.dpl_x, feas_x, Opt_set.lb, feas_x-Opt_set.dp_x);
            end
            
            if RoC_p ~= Opt_set.dpl_x
                fprintf('RoC-move \n')    
                Opt_set.dpl_x = RoC_p;
            end
            
            
        elseif RBDO_s.f_RoC_step
            step = Opt_set.dpl_x- Opt_set.dp_x;
            norm_s = norm(step);
            if norm_s > RBDO_s.RoC_d %step is larger then allowed.
                
                Opt_set.dpl_x = Opt_set.dp_x + RBDO_s.RoC_d*step/norm_s;
                fprintf('Stepsize %d, With Roc %d \n',norm_s, RBDO_s.RoC_d);  
            end
        end
        
         % Corrector_step
        if RBDO_s.f_corrector
            
            % Den med lägst värde förra vändan
           [~,In_cor] = min([LS([LS.active]).nominal_val]); % Min of active
           LSA = LS([LS.active]);
           %In_cor = 1
           G_plus = gvalue_fem('variables', Opt_set.dpl_x, pdata, Opt_set, RBDO_s, LSA(In_cor), 1,0);
           
           %if G_plus < 0 
                
               A0 = (Opt_set.dpl_x - LS(In_cor).nominal_x);
               lambda = (A0 - A0'*LSA(In_cor).alpha_x *LSA(In_cor).alpha_x) / norm(A0 - A0'*LSA(In_cor).alpha_x*LSA(In_cor).alpha_x);
               %lambda =  (Opt_set.dpl_x- LSA(In_cor).probe_x_pos ) / norm(Opt_set.dpl_x - LSA(In_cor).probe_x_pos);
           
               %G_pp = ;    
               OFUN = @(x) -obj.alpha_x'*x;
               Opt_set.dpl_xc = fmincon(OFUN,Opt_set.dp_x,A,b,[],[],Opt_set.lb, Opt_set.ub', @(x)G_ppFUN(x, LSA, In_cor, lambda, Opt_set, G_plus));
               
               % Update
               Corr.lambda = lambda;
               Corr.In_cor = In_cor;
               Corr.G_plus = G_plus;
               
               %test 
               %G_test1 = gvalue_fem('variables', Opt_set.dpl_xc, pdata, Opt_set, RBDO_s, LS(In_cor), 1,0);
                       % RoC
                       if RBDO_s.f_RoC
                           RoC_p = RoC(RBDO_s, pdata, Opt_set, Opt_set.dpl_xc, Opt_set.dpl_x, Opt_set.lb, []);
                           if RoC_p ~= Opt_set.dpl_xc
                               fprintf('RoC-move in corrector \n')    
                               Opt_set.dpl_x = RoC_p;
                           end
                       else
                           Opt_set.dpl_x = Opt_set.dpl_xc;
                       end
                       
                        %test 
               %G_test2 = gvalue_fem('variables', Opt_set.dpl_x, pdata, Opt_set, RBDO_s, LS(In_cor), 1,0);
           %end
        end
        
       % if RBDO_s.f_linprog == 1 % linprog converged to a solution X

           % ------------------------
           % plot the iteration
           % ------------------------
           LS = plotiter(pdata, Opt_set, RBDO_s, LS, Corr);

            if RBDO_s.f_one_probe == 1
                % One probe, then stop.
                Opt_set.inner_conv = 0;

                if RBDO_s.f_debug == 1
                    fprintf('One probe \n')
                end

            elseif sum(active_l_conv) == 0
                % Loop converge until no active set, small change of nominal design or outside RoC
                RBDO_s.inner_conv = 0;
                if RBDO_s.f_debug == 1
                    fprintf('%d Inner steps, all constraints converged \n', l)
                end
            else
                % No convergence in first attempt, linprog did converge!
                Opt_set.l = Opt_set.l+1;
            end

        %else
            %linprog does not converge in first attempt
            %dp_l = dp_l_old;
            Opt_set.l = Opt_set.l+1;
            %error('linprog exited without converging')
       %end
    end

    % Update objective value and dp
    Opt_set.ob_val_old = Opt_set.ob_val;
    Opt_set.ob_val = ObjectiveFunction(Opt_set, obj, pdata);
    

    % Convergence check outer loop
    if ~isempty(Opt_set.ob_val_old)
        v_diff = abs(Opt_set.dp_x_old- Opt_set.dp_x); 
        if abs(Opt_set.ob_val - Opt_set.ob_val_old)/ Opt_set.ob_val_old < RBDO_s.tol && max(v_diff)< RBDO_s.tol
           %Opt_set.outer_conv = 0; 
           disp('NEVER CONVERGE!!!')
        end
    end
    
    % vector move
    Opt_set.delta_old = Opt_set.delta;
    Opt_set.delta = Opt_set.dpl_x - Opt_set.dp_x;
    
    % Update DP, old and new for the outer loop
    Opt_set.dp_x_old = Opt_set.dp_x;
    Opt_set.dp_u_old = Opt_set.dp_u;
    Opt_set.dp_x = Opt_set.dpl_x;
    
    % Update side length based on last and second last move!
    if RBDO_s.f_SRoC && (Opt_set.k > 1)
         RBDO_s.roc_dist = Update_RoC(RBDO_s, Opt_set, pdata);
    end

    if ~sum(pdata.marg(:,1)) == 0 % If probabilistic variables!
        Opt_set.dp_u = U_space(Opt_set.dpl_x, pdata.marg(:,2),pdata.marg(:,3),pdata.marg(:,1));
    end

    if RBDO_s.f_debug == 1
        fprintf('---------------------------------------')
        fprintf(' \n Iteration Nr: %d \n', Opt_set.k)
        fprintf('---------------------------------------')
        fprintf(' \n Objectivefunction value: %1.7f \n', Opt_set.ob_val)
        fprintf(' \n The maximum difference in u since last step is (componentwise): %1.7f \n', Opt_set.dp_x - Opt_set.dp_x_old)
    end
    
    counter = counter + 1;
    if counter == 10
        fprintf('-')
        counter = 0;
    end
        

end
% Display the result
fprintf('\n Number of function evaluation %d', Gnum)
fprintf('\n with value of objective function, %1.4f', Opt_set.ob_val)
fprintf('\n dp = %f ',Opt_set.dp_x)
fprintf('\n DONE! \n')

% And plot the last step
Opt_set.k = Opt_set.k + 1;
plotiter(pdata, Opt_set, RBDO_s, LS)
