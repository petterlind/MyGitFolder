clear all 
close all

% --------------------------------
% 1) Input 
% --------------------------------
% nr_of_trusses = 15;
% inputfile_trusses,
%inputfile_YounChoi
% inputfile_Madsen
inputfile_Cheng

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
    
    % Update objective-gradient direction, doe, alpha
    obj = Grad(obj, pdata, RBDO_s, 'variables');

    for ii = 1:numel(LS) %For all active constraints
        if LS(ii).active == true
            
            if pdata.np > 0
                
                
                
              LS(ii).MPPx = Grad(LS(ii), pdata, RBDO_s, 'variables')
                
%                 p_star = X_space( alpha_p_new * target_beta, probdata.marg(:,2), probdata.marg(:,3));
% 
%                 probdata.p_star(:,nr) = p_star;
%                 alpha_p_old = alpha_p_new;
            end
        
            % FORM estimate of limit states
            LS(ii) = Grad(LS(ii), pdata, RBDO_s, 'variables');
        end
        
         LS(ii).active = obj.alpha_x' * LS(ii).alpha_x  >  cosd(135);
    end
    
    
   % ------------------------
   % plot the iteration - youn choi.
   % ------------------------
   plotiter(pdata, Opt_set, LS)
   
   % -----------------------
   % Inner loop - one step
   % -----------------------
    while Opt_set.inner_conv

        if Opt_set.l>20
            break
        end
        
        for ii = 1:length(LS)
            if LS(ii).active

                % New probe point and Mpp estimate
                LS(ii) = do_probe(LS(ii), pdata, RBDO_s);
            end
        end

        % save previous value
        Opt_set.dpl_x_old = Opt_set.dpl_x; 
        
        % Set up optimization
        f = -obj.alpha_x;
        active = [LS.active];
        A = [LS(active).alpha_x]';
        xs = [LS(active).Mpp_x];
        b = diag(A*xs) - target_beta.*pdata.marg(:,3); %only for the probabalistic dv. Otherwise without target_beta..
        
        % Optimizer
        options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
        [ Opt_set.dpl_x, fval, RBDO_s.f_linprog, output] = linprog(f, A, b, [],[], Opt_set.lb, Opt_set.ub,options); 
        
        if RBDO_s.f_linprog == 1 % linprog converged to a solution X
            
            if RBDO_s.f_one_probe == 1
                % One probe, then stop.
                Opt_set.inner_conv = 0;
                
                if RBDO_s.f_debug == 1
                    fprintf('One_probe \n')
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
        
    % Update optimal coordinates, old and new for the outer loop
    Opt_set.dp_x_old = Opt_set.dp_x;
    Opt_set.dp_u_old = Opt_set.dp_u;
    Opt_set.dp_x = Opt_set.dpl_x;
    Opt_set.dp_u = U_space(Opt_set.dpl_x, pdata.marg(:,2),pdata.marg(:,3));

    % Update objective value and dp
    Opt_set.ob_val_old = Opt_set.ob_val;
    Opt_set.ob_val = ObjectiveFunction(Opt_set, obj, pdata);
    v_diff = abs(Opt_set.ob_val-Opt_set.ob_val_old); % Difference in variable x-space %TRANSFORM TO X_SPACE
    
    % Convergence check outer loop
    if ~isempty(Opt_set.ob_val_old)
        if abs(Opt_set.ob_val - Opt_set.ob_val_old)/ Opt_set.ob_val_old < RBDO_s.tol %&& max(v_diff)< RBDO_s.tol
           Opt_set.outer_conv = 0;
        end
    end

    if RBDO_s.f_debug == 1
        fprintf('---------------------------------------')
        fprintf(' \n Iteration Nr: %d \n', Opt_set.k)
        fprintf('---------------------------------------')
        fprintf(' \n Objectivefunction value: %1.7f \n', Opt_set.ob_val)
        fprintf(' \n The maximum difference in u since last step is (componentwise): %1.7f \n', Opt_set.dp_x - Opt_set.dp_x_old)
    end
    
    % Update all the values?!
    for ii = 1:numel(LS)
        LS(ii).nominal_x = Opt_set.dp_x+ LS(ii).alpha_x*target_beta.*pdata.marg(:,3); % If Mpp search is done from some nominal point. 
        LS(ii).nominal_u = U_space(LS(ii).nominal_x, pdata.marg(:,2), pdata.marg(:,3));
    end
    
end

% Display the result
fprintf('\n Number of function evaluation %d', Gnum)
fprintf('\n with value of objective function, %1.4f', Opt_set.ob_val)
fprintf('\n dp = %f ',Opt_set.dp_x)
fprintf('\n DONE! \n')

% And plot the last step
Opt_set.k = Opt_set.k +1;
plotiter(pdata, Opt_set, LS)






