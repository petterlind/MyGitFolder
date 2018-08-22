clear all
close all

% --------------------------------
% 1) Input
% --------------------------------
 %inputfile_trusses
 inputfile_YounChoi
% inputfile_Jeong_Park
% inputfile_Madsen
% inputfile_Cheng
% inputfile_Cheng3_prob
% inputfile_TANA

set_parameters

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

    % Update mean values
    pdata.marg(:,2) = Opt_set.dp_x; % mean of equivalent normal dist?

    % Update the MPP search point. If pdata.marg(:,3) == 0 nothing changes.
    for ii = 1:numel(LS)
        LS(ii).nominal_x_old = LS(ii).nominal_x;
        
        if RBDO_s.f_RoC
             % LS(ii).nominal_x = RoC(RBDO_s, pdata, Opt_set, Opt_set.dp_x + LS(ii).beta_v.* RBDO_s.kappa_n, Opt_set.dp_x, Opt_set.lb);
             LS(ii).nominal_x = RoC(RBDO_s, pdata, Opt_set,  Opt_set.dp_x + (LS(ii).Mpp_x - LS(ii).Mpp_sx).* RBDO_s.kappa_n, Opt_set.dp_x, Opt_set.lb);
        else
            LS(ii).nominal_x = Opt_set.dp_x + (LS(ii).Mpp_x - Opt_set.dp_x).* RBDO_s.kappa_n;
        end
        
        if ~sum(pdata.marg(:,1)) == 0 % If probabilistic variables!
           % pdata.marg(:,2:3) =  Eq_dist( LS(ii).nominal_x, pdata.marg(:,5), pdata.marg(:,6), pdata.marg(:,1));
            
          %  LS(ii).nominal_u = U_space(LS(ii).nominal_x, pdata.marg(:,2), pdata.marg(:,3));%, pdata.marg(:,1)); % LS object
        end     
    end
    
    obj = Grad(obj, pdata, Opt_set, RBDO_s, 'variables', false);

    for ii = 1:numel(LS) %For all active constraints
        if LS(ii).active == true
            if pdata.np > 0
                % Update MPP-estimate in probabilistic space
                LS(ii) = Grad(LS(ii), pdata, Opt_set, RBDO_s, 'parameters', true);
            end

            % FORM estimate of limit states
            LS(ii) = Grad(LS(ii), pdata, Opt_set, RBDO_s, 'variables', true);
            LS(ii).active = obj.alpha_x' * LS(ii).lambda  >  cosd(135);
            
        end
    end
    
   % -----------------------
   % Probe
   % -----------------------
   for ii = 1:length(LS)
        if LS(ii).active
            LS(ii).Mpp_x_old = LS(ii).Mpp_x; % Save old value

            if RBDO_s.f_probe
                % New probe point and Mpp estimate

               LS(ii) = do_probe(LS(ii), pdata, Opt_set, RBDO_s);
            end
        elseif ~LS(ii).active
        LS(ii).Mpp_ud = [];
        end
    end

% save previous value
Opt_set.dpl_x_old = Opt_set.dpl_x;

if RBDO_s.f_linprog

    % Set up optimization
    f = -obj.alpha_x; % x-space
    active = [LS.active] & ~[LS.no_cross] ;
    %A = [LS(active).alpha_x]';
    A = [LS(active).lambda]';
    xs = [LS(active).Mpp_x];

    if pdata.nx > 0
       xs_new = [LS(active).Mpp_sx];
         b = diag(A*(xs_new));
    elseif pdata.nx == 0 && pdata.nd ~=0
       b = diag(A*xs);
    else
       error('Add the last option in b')
    end

    % Uppdatera Move Limits
    lb = max([ Opt_set.lb'; (Opt_set.dp_x' - Opt_set.roc_dist')]);
    ub = min([ Opt_set.ub'; (Opt_set.dp_x' + Opt_set.roc_dist')]);
        
    options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
    [ Opt_set.dpl_x, fval, RBDO_s.f_linprog, output] = linprog(f, A, b, [],[], lb, ub,options);
    
    if RBDO_s.f_linprog ~= 1
        % Optimizer, towards feasible
        FUN = @(X1) norm( X1 - Opt_set.dp_x)^2;
        options = optimoptions('fmincon','Display','notify','StepTolerance',1e-10,'Algorithm','sqp','MaxFunctionEvaluations',3000,'ConstraintTolerance',1e-10);
        Opt_set.dpl_x = fmincon(FUN, Opt_set.dp_x, A, b,[],[],lb, ub);
    end
end

   % ------------------------
   % plot the iteration
   % ------------------------
   [LS, theta] = plotiter(pdata, Opt_set, RBDO_s, LS, theta);
   
   %%% debug
   hold on
   figure(1)
   plot(Opt_set.dpl_x(1), Opt_set.dpl_x(2),'mo')

    % Update objective value and dp
    Opt_set.ob_val_old = Opt_set.ob_val;
    Opt_set.ob_val = ObjectiveFunction(Opt_set, obj, pdata);
    Objective_v(Opt_set.k) = Opt_set.ob_val;
    
    % Convergence check outer loop
    if ~isempty(Opt_set.ob_val_old)

        if abs((Opt_set.ob_val - Opt_set.ob_val_old)/ Opt_set.ob_val_old) < RBDO_s.tol  && Results.v_conv == false
            Results.v_conv = true; 
            Results.v_nr = Gnum;
            Results.v_iter = Opt_set.k;
            Results.v_obj = Opt_set.ob_val;
           if RBDO_s.f_MC
              Results.MC = Monte_Carlo(SMTH);
           end
        end
        
        v_diff = abs(Opt_set.dp_x_old- Opt_set.dp_x);
        if max(v_diff)< RBDO_s.tol &&  Results.s_conv == false
            Results.s_conv = true; 
            Results.s_nr = Gnum;
            Results.s_iter = Opt_set.k;
            Results.s_obj = Opt_set.ob_val;
            
            if RBDO_s.f_MC
              Results.MC = Monte_Carlo(SMTH);
           end
        end
        
        try
        if max(abs(([LS.Mpp_ud]-[LS.Mpp_ud_old])./[LS.Mpp_ud_old]))< RBDO_s.tol &&  Results.c_conv == false
            Results.c_conv = true; 
            Results.c_nr = Gnum;
            Results.c_iter = Opt_set.k;
            Results.c_obj = Opt_set.ob_val;
        end
        
        catch
            disp('error')
        end
        
        if Results.s_conv && Results.v_conv && Results.c_conv
            % All convergence criterias met. stop iteration.
            Opt_set.outer_conv = 0; 
            %disp('NEVER CONV!')
        end
        
    end
    
    % vector move
    Opt_set.delta_old = Opt_set.delta;
    Opt_set.delta = Opt_set.dpl_x - Opt_set.dp_x;
    
    % Update DP, old and new for the outer loop
    Opt_set.dp_x_old = Opt_set.dp_x;
    Opt_set.dp_x = Opt_set.dpl_x;
    obj.nominal_x = Opt_set.dp_x;
    pdata.marg(:,2) = Opt_set.dp_x;
    
    % Update side length based on last and second last move!
    if RBDO_s.f_SRoC && (Opt_set.k > 1)
         [Opt_set.roc_dist, ~, RBDO_s.kappa_n] = Update_RoC(RBDO_s, Opt_set);
    end

    %if ~sum(pdata.marg(:,1)) == 0 % If probabilistic variables!
     %   [pdata.marg(:,5), pdata.marg(:,6)] = Update_dist(Opt_set.dp_x, pdata.marg(:,7), pdata.marg(:,1)); % Update distributions!
    %end

    if RBDO_s.f_debug == 1
        fprintf('---------------------------------------')
        fprintf(' \n Iteration Nr: %d \n', Opt_set.k)
        fprintf('---------------------------------------')
        fprintf(' \n Objectivefunction value: %1.7f \n', Opt_set.ob_val)
        fprintf(' \n The maximum difference in u since last step is (componentwise): %1.7f \n', Opt_set.dp_x - Opt_set.dp_x_old)
    end
    
    counter = counter + 1;
    if counter == 50
        fprintf(' BRAKE AFTER %d iter', counter)
        Results.Max_iterations = true;
        counter = 0;
        Opt_set.outer_conv = 0;
    end
end
% Display the result
fprintf('\n Number of function evaluation %d', Gnum)
fprintf('\n with value of objective function, %1.4f', Opt_set.ob_val)
fprintf('\n dp = %f ',Opt_set.dp_x)
fprintf('\n DONE! \n')

% And plot the last step
Opt_set.k = Opt_set.k + 1;
[LS, theta] = plotiter(pdata, Opt_set, RBDO_s, LS, theta);
Objective_v(Opt_set.k) = ObjectiveFunction(Opt_set, obj, pdata);

% extra_plot
