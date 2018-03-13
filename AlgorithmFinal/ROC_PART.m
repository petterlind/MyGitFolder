if strcmp(gfundata.type,'TRUSS')
            
            fun = @(x) norm(x-dp);
            feasible_dp = fmincon(fun,dp,A,b,[],[],lb,ub*2);
            
            %funopt = @(x) ObjectiveFunction(x, rbdo_fundata, gfundata)
            %optimum_point = fmincon(funopt,dp,A,b[],[],lb,ub*1.1)
            RBDO_s.linprog = 1; 
            options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
            
            % Run optimization and check the convergence
            [ optimum_dp, fval, RBDO_s.linprog, output] = linprog(f, A, b, [],[], lb_opt, ub_opt*2,options);

            % Roc - hypersphere.
            if norm(feasible_dp-dp) > RBDO_settings.Roc  % feasible utanför RoC
                dp_l = dp + RBDO_settings.Roc*(feasible_dp-dp)/norm(feasible_dp-dp);
                
            elseif norm(feasible_dp-dp) < RBDO_settings.Roc % feasible innanför RoC
                
                if ~isempty(optimum_dp)
                    if norm(optimum_dp-dp) < RBDO_settings.Roc % Optimum innanför Roc
                        dp_l = optimum_dp;
                    elseif norm(optimum_dp-dp) > RBDO_settings.Roc %Optimum utanför max_step,

                        syms beta clear 
                        syms beta 'positive'

                        % From feasible towards optimum until it reaches
                        % RoC
                        V1 = ( (optimum_dp-feasible_dp) / norm(optimum_dp-feasible_dp) ) * beta + feasible_dp;

                        % Distance from current DP is RoC
                        beta_num = double( solve(norm(V1-dp) == RBDO_settings.Roc ));

                        dp_l =  double(subs(V1,beta,beta_num));
                    end
                end
            end
        else
            
            options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
            [ dp_l, fval, RBDO_s.linprog, output] = linprog(f, A, b, [],[], lb_opt, ub_opt*2,options); 
        end

        % no more steps for limit state j if last step was small enough!
        if l>0  
           if strcmp(gfundata.type,'TRUSS') || strcmp(gfundata.type,'Madsen') 
                active_l_conv = Check_step( active_l_conv, alpha_inner, x_values, dp, RBDO_s.no_cross, 1e-4);  % 1e-6
           
           elseif strcmp(gfundata.type,'YounChoi')
               active_l_conv = Check_step( active_l_conv, alpha_inner, x_s, x_values(: ,:,:), RBDO_s.no_cross, RBDO_settings.convl);
           end
           
        end
        
        if strcmp(gfundata.type, 'Madsen') && active_l_conv(1) == 1
            MPP_real = [ 2.615; -0.831; -1.866; -0.790; 0.037; -0.019; -0.056 ];
            MPP_first = 3.3204*alpha_x_new;
            Dist_Mpp_real = norm( x_s_new - MPP_real);
            Dist_Mpp_first = norm( 3.3204*alpha_x_new - MPP_real);
            xnum = 1:7;
            
            fprintf( 'Distance between final guess and first guess;  %1.4f \n', Dist_Mpp_first )
            
            fprintf( 'Probes = %d (extra), beta = %1.3f, Dist to real MPP = %1.3f, \n', l, norm(x_s_new),Dist_Mpp_real)
            
            fprintf( '\n MPP:\n')
            fprintf( '%1.5f \n', x_s_new)
        end