clear all
close all

% --------------------------------
% 1) Input
% --------------------------------
% nr_of_trusses = 15;
% inputfile_trusses,
inputfile_YounChoi
% inputfile_Madsen
% inputfile_Cheng
% inputfile_Cheng10
% inputfile_Cheng10_det
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
        %LS(ii).nominal_x = Opt_set.dp_x + LS(ii).beta_v;
        LS(ii).nominal_x = RoC(RBDO_s, pdata, Opt_set, Opt_set.dp_x + LS(ii).beta_v, Opt_set.dp_x,[],Opt_set.lb);
        LS(ii).nominal_u = U_space(LS(ii).nominal_x, pdata.marg(:,2), pdata.marg(:,3)); % LS object
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

        % Set up optimization
        f = -obj.alpha_x; % x-space
        active = [LS.active];
        A = [LS(active).alpha_x]';
        xs = [LS(active).Mpp_x]; % Add some shifted xs!?!!


        if pdata.nx > 0
           xs_new = [LS(active).Mpp_x] - [LS(active).beta_v];
             
            %only for the probabalistic dv. Otherwise without target_beta..
            % b = diag(A*xs) - target_beta.*pdata.marg(:,3); % OLD STYLE,
            % worked with Youn Choi!
             b = diag(A*xs_new);
        elseif pdata.nx == 0 && pdata.nd ~=0
           b = diag(A*xs);
        else
           error('Add the last option in b')
        end

        % Optimizer
        options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
        [ Opt_set.dpl_x, fval, RBDO_s.f_linprog, output] = linprog(f, A, b, [],[], Opt_set.lb, Opt_set.ub',options);

        % Feasible step
        FUN = @(X1) norm(X1-Opt_set.dp_x);
        feas_x = fmincon(FUN,Opt_set.dp_x,A,b,[],[],Opt_set.lb, Opt_set.ub');
        
        % Step length
        if RBDO_s.f_RoC
            RoC_p = RoC(RBDO_s, pdata, Opt_set, Opt_set.dpl_x, Opt_set.dp_x, feas_x,Opt_set.lb);
            Opt_set.dpl_x = RoC_p;
            
        elseif RBDO_s.f_RoC_step
            step = Opt_set.dpl_x- Opt_set.dp_x;
            norm_s = norm(step);
            if norm_s > RBDO_s.RoC_d %step is larger then allowed.
                
                Opt_set.dpl_x = Opt_set.dp_x + RBDO_s.RoC_d*step/norm_s;
                fprintf('Stepsize %d, With Roc %d \n',norm_s, RBDO_s.RoC_d);
                
            end
        end

        % Enforce UB:
        % too_large = Opt_set.dpl_x > Opt_set.ub';
        % Opt_set.dpl_x(too_large) = Opt_set.ub(1);

        if RBDO_s.f_linprog == 1 % linprog converged to a solution X

           % ------------------------
           % plot the iteration
           % ------------------------
           LS = plotiter(pdata, Opt_set, RBDO_s, LS);

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

        else
            %linprog does not converge in first attempt
            %dp_l = dp_l_old;
            Opt_set.l = Opt_set.l+1;
            %error('linprog exited without converging')
        end
    end

    % Update objective value and dp
    Opt_set.ob_val_old = Opt_set.ob_val;
    Opt_set.ob_val = ObjectiveFunction(Opt_set, obj, pdata);
    

    % Convergence check outer loop
    if ~isempty(Opt_set.ob_val_old)
        v_diff = abs(Opt_set.dp_x_old- Opt_set.dp_x); 
        if abs(Opt_set.ob_val - Opt_set.ob_val_old)/ Opt_set.ob_val_old < RBDO_s.tol && max(v_diff)< RBDO_s.tol
           Opt_set.outer_conv = 0; 
           %disp('NEVER CONVERGE!!!')
        end
    end
    
    % Update optimal coordinates, old and new for the outer loop
    Opt_set.dp_x_old = Opt_set.dp_x;
    Opt_set.dp_u_old = Opt_set.dp_u;
    Opt_set.dp_x = Opt_set.dpl_x;
    Opt_set.dp_u = U_space(Opt_set.dpl_x, pdata.marg(:,2),pdata.marg(:,3));

    if RBDO_s.f_debug == 1
        fprintf('---------------------------------------')
        fprintf(' \n Iteration Nr: %d \n', Opt_set.k)
        fprintf('---------------------------------------')
        fprintf(' \n Objectivefunction value: %1.7f \n', Opt_set.ob_val)
        fprintf(' \n The maximum difference in u since last step is (componentwise): %1.7f \n', Opt_set.dp_x - Opt_set.dp_x_old)
    end
    
%     counter = counter + 1;
%     if counter == 10
%         fprintf('-')
%         counter = 0;
%         LS(1).G_p_old
%     end
        

end
% Display the result
fprintf('\n Number of function evaluation %d', Gnum)
fprintf('\n with value of objective function, %1.4f', Opt_set.ob_val)
fprintf('\n dp = %f ',Opt_set.dp_x)
fprintf('\n DONE! \n')

% And plot the last step
Opt_set.k = Opt_set.k + 1;
plotiter(pdata, Opt_set, RBDO_s, LS)
