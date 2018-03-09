clear all 
close all

% --------------------------------
% 1) Input 
% --------------------------------
% nr_of_trusses = 10;
% inputfile_trusses,
 inputfile_YounChoi
% inputfile_Madsen

% From different start points.

rbdo_fundata.constraint = {   -5/0.3                   % Deterministic constraints: [lower xi, upper xi]
                              -5/0.3
                              5/0.3
                              5/0.3
                          }; % in u-space!

u_div = 175;
%u_div = 3;
u1_vec =linspace(-10,4,u_div);
u2_vec =linspace(-10,2,u_div);
Loop_res = nan(u_div,u_div);
Loop_obj = nan(u_div,u_div);
Loop_final1 = nan(u_div,u_div);
Loop_final2 = nan(u_div,u_div);

h = waitbar(0,'Please wait...');
non_ui = [];
non_uj = [];

for  ui = 1:u_div
    for uj = 1:u_div
         waitbar(ui / u_div)
        %try
            
        rbdo_parameters.design_point = [u1_vec(ui);u2_vec(uj)];
        % Preprocessing, defining parameters for the algorithm from the inputs
        nx = rbdo_parameters.nx;   
        nc = rbdo_parameters.nc;
        np = rbdo_parameters.np;
        nca = nc;

        stdv = probdata.stdv;                   % standard deviation (assumed constant)
        stdv_p = probdata.marg(:,3);
        dp_k = rbdo_parameters.design_point;

        dp = rbdo_parameters.design_point;
        target_beta = rbdo_parameters.target_beta;
        bounds = cell2mat(rbdo_fundata.constraint);
        bounds_physical = cell2mat(rbdo_fundata.mpp_constraint);lb = bounds_physical(1:nx);ub = bounds_physical(nx+1:end);
        lb_opt = bounds(1:nx);
        ub_opt = bounds(nx+1:end);

        Lnumber = 1000; %for allocating matrices
        lst = 1:Lnumber;

        % Dummys, start value for some variables
        probdata.p_star = nan(np, nc) ;
        x_values = nan(nc,Lnumber,nx); % Not more than 10000 experiments are expected
        x_s = nan(nc,Lnumber,nx);
        limit_values = nan(nc,Lnumber);
        obj_values = nan(Lnumber,1);

        alpha_values_x = nan(nc, 100, nx);
        slope_values =  nan(nc, Lnumber);
        alpha_values_c = nan(100, nx);
        alpha_values_p = nan(nc, 100, np);
        alpha_p_new = nan(np,1);
        alpha_p_old = zeros(np,1);
        dp_plot = nan(nx,100);
        dp_color = nan(nx,100);
        alpha_inner = nan;
        flag.not_conv = nan;
        l = nan;

        active = ones(1,nc) == 1;
        fignr = 1;
        fignr_old = fignr;
        k = 0;
        savenr = 0;

        non_fesible = nan(nx,1);
        test_lnf3 = 0;
        test_lnf2 = 0;
        ps_min = nan;

        % Flags
        flag.bigger = 0; % for probe settings, does not allow the probe point to have a bigger value than gm
        flag.no_cross = nan(nc,Lnumber); % nececcary?
        flag.outer_conv = 1;             % outer loop conv flag
        flag.debug = 0;
        flag.RoC = 1;
        flag.max_step = 1;

        % Globals
        global Gnum
        Gnum = 0;

        % algorithm settings
        RBDO_settings.tol_non_linear = 0.5; %0.1 was too low?!
        RBDO_settings.tol = 1e-3;

        dp_old = rbdo_parameters.design_point + [rbdo_parameters.design_point(1)+RBDO_settings.doe_scale; rbdo_parameters.design_point(2:end)];
        update = logical(ones(1,nc)); % FIX

        % --------------------------------
        % 2) Main Loop
        % --------------------------------
        while flag.outer_conv

            if k > 10 || l >20
                flag.not_conv = 1;
                break
            end

            k = k + 1;
            l = 0;
            flag.inner_conv = 1;
            test_lnf1 = 0;
            
            if k== 2
                disp('brake')
            end
            
            % Update objective-gradient direction
            [alpha_c_new, ~, obj_new, ~,~,~] = Grad_comp(dp, probdata, rbdo_fundata, gfundata, 1, RBDO_settings, lb, 'cost', x_s, rbdo_parameters, alpha_values_x(:, k, :));

            % save the values
            obj_values(k, 1) = obj_new(1);
            alpha_values_c(k, :) = alpha_c_new';

            active = update;
            % Set the indexing for the loop
            number = lst(active);
            nca = sum(active);

            active_fix = ones(nca,1);
            gfundata.limitstates = nan(nx,1);

            if strcmp(gfundata.type,'TRUSS')
            RBDO_settings.doe_scale = min( norm(dp-dp_old) , RBDO_settings.doe_scale );

                if RBDO_settings.doe_scale < 1e-3
                    RBDO_settings.doe_scale = 1e-3;
                end

                %RBDO_settings.scale_RoC = 5*RBDO_settings.doe_scale;
                RBDO_settings.Roc = 2.5*RBDO_settings.doe_scale;
            end

            for ii = 1:nca %For all active constraints
                nr = number(ii);

                if np > 0 
                    % Update gradient for all probabilistic parameters
                    [alpha_p_new, ~, ~, ~, ~, limitstate] = Grad_comp(dp, probdata, rbdo_fundata, gfundata, nr, RBDO_settings, lb, 'p_star', x_s(ii,:,:),rbdo_parameters, alpha_values_x(nr, 1:k, :)); 
                    gfundata.limitstates(nr,1 ) = limitstate;

                    p_star = X_space( alpha_p_new * target_beta, probdata.marg(:,2), probdata.marg(:,3));

                    probdata.p_star(:,nr) = p_star;
                    alpha_p_old = alpha_p_new;

                    % save the vector (why?)
                    alpha_values_p(nr, k, :) =  alpha_p_new;
                end

                % FORM estimate of limit states
                [alpha_x_new, x_new, limit_new, slope_x_new, active_i, ~] = Grad_comp(dp, probdata, rbdo_fundata, gfundata, nr, RBDO_settings, lb_opt, 'limitstate', x_s(ii,:,:), rbdo_parameters, alpha_values_x(nr, 1:k , :));

                % For madsen!
                if strcmp(gfundata.type,'Madsen')
                    % Towards Mpp.
                    % alpha_x_final = [0.766; -0.244; -0.547; -0.232; 0.011; -0.006; -0.016]/ norm([0.766; -0.244; -0.547; -0.232; 0.011; -0.006; -0.016]);

                    % Towards alpha_1
                   % alpha_x_new = [ 2.401; -0.977; -1.843; -0.921; 0.055; -0.028; -0.083] / norm([ 2.401; -0.977; -1.843; -0.921; 0.055; -0.028; -0.083]);

                   % ANALYTICAL
                     alpha_x_new = [ -0.7241    0.2946    0.5625    0.2679   -0.0133    0.0067    0.0200];
        %             c_theta = (alpha_x_new'*alpha_x_final)/( norm(alpha_x_new)*norm(alpha_x_final));
        %             ThetaInDegrees = acosd(c_theta);

                end
                    active_fix(nr,1) = active_i;
                    non_fesible(nr) = sign(limit_new);

                % Save the values
                index_x = min(lst(isnan(x_values(nr,:,1))));
                x_values( nr, index_x:index_x, : ) = x_new;     % only nominal value added!
                limit_values(nr, index_x:index_x) = limit_new;  % only nominal value added!

                alpha_values_x(nr, k, :) = alpha_x_new;
                slope_values(nr, index_x:index_x) = slope_x_new; % only one value!
            end

            active_old = active;
            alpha_inner_old = alpha_inner;
            alpha_inner = mysqueeze(alpha_values_x(:, k, :))'; % used to be without transpose!

            % Update active set based on direction
            if strcmp(gfundata.type,'TRUSS') || strcmp(gfundata.type,'YounChoi')
                update = alpha_c_new' * alpha_inner  > cosd(135) ; 

            elseif  strcmp(gfundata.type,'Madsen')

                % All are active...
                update = 1;
                alpha_inner = alpha_inner';
            end


            %active = active*0;
            %active(number(update)) = 1;
            %active = logical(active);

        %     fprintf('All active! \n')
        %     active = ones(1,nc) == 1;

            % Setup before inner loop
            dp_l = dp;
            %active_l = logical(active_fix)' & update; %& update ; %fix

            active_l = update;
            %active_l = update; %fix
            active_l_conv = active_l;
            fignr = 1;
            %close all
            %figure(1)
            %clf
            %figure(2)
            %clf 
            % hold off
            %b = nan(nx,1);

           % ------------------------
           % plot the iteration
           % ------------------------
           if flag.debug == 1 && ( nx == 5 || nx == 10 || nx == 15) %Trusses

            a = nan(nx,1);
            for ii = 1:nx
                [a(ii), ~] = gvalue_fem('variables', dp, probdata, rbdo_parameters, gfundata, ii,0,0);
            end

            dp_plot(:,k) = dp;
            dp_color(:,k) =sign(a);

            plot_trusses(dp, probdata, rbdo_parameters, gfundata, flag, nx, k, dp_plot, dp_color)
           elseif flag.debug == 1 && ( nx == 2 ) %Trusses 
                plot_YounChoi(probdata, dp, x_s, k)
           end

           % -----------------------
           % Inner loop
           % -----------------------
            while flag.inner_conv

                if l>20
                    break
                end

                % Set the indexing for the loop
                number = lst(active_l_conv);
                nca = sum(active_l_conv);
                fignr = 1;
                for ii = 1:nca
                    nr = number(ii);

                    % New probe point
                    if strcmp(gfundata.type,'TRUSS') || k < 2
                        [x_new, limit_new, slope_new, x_s_new, no_cross, flag.exit, p_lim, active_l_nr, ps] = probe(mysqueeze(x_values(nr,:,:)), limit_values(nr,:), alpha_inner(:,nr), slope_values(nr,:), dp, RBDO_settings, probdata, rbdo_parameters, gfundata, nr, l,k, lb, flag);
                    else %WHY?
                        [x_new, limit_new, slope_new, x_s_new, no_cross, flag.exit, p_lim, active_l_nr, ps] = probe(mysqueeze(x_values(nr,:,:)), limit_values(nr,:), alpha_inner(:,nr), slope_values(nr,:), x_values(nr,:,:), RBDO_settings, probdata, rbdo_parameters, gfundata, nr, l,k, lb, flag);
                    end
                    % Save the values
                    index_x = min(lst(isnan(x_values(nr,:,1))));
                    index_f = min(lst(isnan(flag.no_cross(nr,:))));
                    index_xs = min(lst(isnan(x_s(nr,:,1))));

                    flag.no_cross(nr ,index_f) =  no_cross;
                    x_values(nr, index_x:index_x + length(limit_new) -1 , : ) = x_new;
                    x_s(nr, index_xs, : ) = x_s_new;
                    limit_values(nr, index_x:index_x + length(limit_new) -1) = limit_new;
                    slope_values(nr, index_x) = slope_new;
                    active_l(nr) = active_l_nr;

                    % fix
                    if no_cross == 1
                        active_l(nr) = 0;
                    end

                    % plot spline in p-space
                    if flag.debug == 1 
                        if nr/(5*fignr) > 1
                            fignr = fignr +1;
                            hold off
                        end


                        %figure(fignr)
                        pnr = mod( nr, 5);
                        if pnr == 0
                            pnr = 5;
                        end
                       % figure(10)
                       % subplot( 5, 1, pnr);
                       % pplot(mysqueeze(x_values(nr,:,:)), limit_values(nr,:), slope_values(nr,:), dp, alpha_inner(:,nr), mysqueeze(x_s(nr,:,:)), nr, probdata,rbdo_parameters,gfundata, no_cross, p_lim, flag.exit)
                        %ylabel(sprintf('%d,flag=%d',nr, flag.exit))
                        shg
                    end
                end

                % save previous value
                dp_l_old = dp_l; 

                % Set up optimization - only the active values are to be used here!
                f = -alpha_c_new;
                A_raw = alpha_inner(:,active_l);
                A = A_raw';

                index_lst_lprog = lst(active_l);
                nc_lprog = sum(active_l);
                b = nan(nc_lprog,1);

                for ii = 1:nc_lprog 
                    nr_lprog = index_lst_lprog(ii);
                    index_xs = max(lst(~isnan(x_s(nr_lprog,:,1))));
                    if rbdo_parameters.variable == 0
                        b(ii,1 ) = A(ii,:)* (mysqueeze(x_s(nr_lprog, index_xs , : )));

                    elseif rbdo_parameters.variable == 1
                        b(ii,1 ) = A(ii,:)* (mysqueeze(x_s(nr_lprog, index_xs , : ))) - target_beta;
                    end
                end 

                if strcmp(gfundata.type,'TRUSS')

                    fun = @(x) norm(x-dp);
                    feasible_dp = fmincon(fun,dp,A,b,[],[],lb,ub*1.5);
                    flag.linprog = 1; 
                    options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);

                    % Run optimization and check the convergence
                    [ optimum_dp, fval, flag.linprog, output] = linprog(f, A, b, [],[], lb_opt, ub_opt*1.5,options);

                    % Roc - hypersphere.
                    if norm(feasible_dp-dp) > RBDO_settings.Roc  % feasible utanför RoC
                        dp_l = dp + RBDO_settings.Roc*(feasible_dp-dp)/norm(feasible_dp-dp);

                    elseif norm(feasible_dp-dp) < RBDO_settings.Roc % feasible innanför RoC

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
                else

                    options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
                    [ dp_l, fval, flag.linprog, output] = linprog(f, A, b, [],[], lb_opt, ub_opt*1.5,options); 
                end

                % no more steps for limit state j if last step was small enough!
                if l>0  
                   if strcmp(gfundata.type,'TRUSS') || strcmp(gfundata.type,'Madsen') 
                        active_l_conv = Check_step( active_l_conv, alpha_inner, x_values, dp, flag.no_cross, 1e-4);  % 1e-6

                   elseif strcmp(gfundata.type,'YounChoi')
                       active_l_conv = Check_step( active_l_conv, alpha_inner, x_s, dp, flag.no_cross, RBDO_settings.convl);
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

                if flag.linprog == 1
                    % Loop converge until no active set, small change of nominal design or outside RoC
                      if sum(active_l_conv) == 0
                          if flag.debug == 1
                              fprintf('%d Inner steps, all constraints converged \n', l)
                          end
                          flag.inner_conv = 0;
                      end

                else
                    dp_l = dp_l_old;

                end
                 l = l+1; 
            end       

            if strcmp(gfundata.type, 'Madsen')
                xnum = 1:7;
                fprintf( ' CONVERGED ')
                fprintf( 'Probes = %d (extra), beta = %1.3f \n', l, norm(x_s_new))
                fprintf( '%1.5f \n', x_s_new)

                fprintf( '\n Ignore the official result below.... \n')
                break
            end

                %plot_YounChoi(probdata, dp, x_s)

                 dp_old = dp;
                dp = dp_l;

                % Update objective value and dp
                obj_old = obj_new(1);
                if strcmp(gfundata.type,'TRUSS')
                    rbdo_parameters.design_point = dp;
                    obj_new = ObjectiveFunction(dp, rbdo_fundata, gfundata);
                    variable_diff = abs(dp-dp_old);
                else
                    obj_new = ObjectiveFunction(X_space(dp, probdata.marg(:,2),probdata.marg(:,3)), rbdo_fundata, gfundata);
                    variable_diff = abs( X_space(dp_old,probdata.marg(:,2),probdata.marg(:,3)) - X_space(dp, probdata.marg(:,2),probdata.marg(:,3)));
                end

            % Do a convergence check in the outer loop
            if abs(obj_old - obj_new)/ obj_old < RBDO_settings.tol && max(variable_diff)< 1e-3
                flag.outer_conv = 0;
            end

            if flag.debug == 1
                fprintf('---------------------------------------')
                fprintf(' \n Iteration Nr: %d \n', k)
                fprintf('---------------------------------------')
                fprintf(' \n Objectivefunction value: %1.7f \n', obj_new)
                fprintf(' \n The maximum difference in u since last step is (componentwise): %1.7f \n', dp-dp_old)
                %fprintf(' \n The maximum difference in beta since last step is: %1.7f', max(abs(dbeta-old_dbeta)))
            end

        end

        if strcmp(gfundata.type,'TRUSS')
            dp_x = dp;
        else
            dp_x = X_space(dp, probdata.marg(:,2),probdata.marg(:,3));
        end
        
        % Save the result for each inner loop.
        Loop_res(ui,uj) = Gnum;
        Loop_obj(ui,uj) = obj_new;
        Loop_final1(ui,uj) = dp(1);
        Loop_final2(ui,uj) = dp(2);
%         catch
%             non_ui = [non_ui, ui];
%             non_uj = [non_uj, uj];
%         end
        
    end
end

%Save the result
save('LoopYounChoiRes5','Loop_res','Loop_obj','u1_vec','u2_vec','u_div','Loop_final1','Loop_final2')

close(h) 

% Display the result
fprintf('\n Number of function evaluation %d', Gnum)
fprintf('\n with value of objective function, %1.4f', ObjectiveFunction(dp_x, rbdo_fundata, gfundata))
fprintf('\n dp = %f ',dp_x)
fprintf('\n DONE! \n')

% Gval = gvalue_fem('variables', dp, probdata, rbdo_parameters, gfundata, gnum,1)

if flag.debug == 1
    for ii = 1:nx
        [a, ~] = gvalue_fem('variables', dp, probdata, rbdo_parameters, gfundata, ii,0,0);
        fprintf(' \n g%d: %1.7f \n', ii, a )
    end
end


% Plot last step
k=k+1;
if flag.debug == 1 && ( nx == 5 || nx == 10 || nx == 15) %Trusses
       
    a = nan(nx,1);
    for ii = 1:nx
        [a(ii), ~] = gvalue_fem('variables', dp, probdata, rbdo_parameters, gfundata, ii,0,0);
    end

    dp_plot(:,k) = dp;
    dp_color(:,k) =sign(a);

    plot_trusses(dp, probdata, rbdo_parameters, gfundata, flag, nx, k, dp_plot, dp_color)
elseif flag.debug == 1 && ( nx == 2 ) %Trusses 
       plot_YounChoi(probdata, dp, x_s, k)
end


% Monte Carlo simulations.
flag.MC = 0;

if flag.MC == 1
    nr_MC = 1e6;
    % Plocka värden på p börja med 1000 st

    
    p_star_mc = probdata.marg(:,2) + probdata.marg(:,3).*randn(numel(probdata.marg(:,3)),nr_MC);
    h = waitbar(0,'Soon...');

    if strcmp(gfundata.type,'TRUSS')
        g_values = nan(nr_MC,length(dp));
        
    for ii = 1:nr_MC

        probdata.p_star = p_star_mc(:,ii);
        % Gör funktionsanrop till G, A7
        g_vec = gvalue_fem_mc('variables', dp, probdata, rbdo_parameters, gfundata, 0,0);
        g_values(ii,:) = g_vec';

        if mod(ii, (0.1*nr_MC)) == 0
         waitbar(ii / nr_MC)
         shg
        end
    end

    % Results
    fails = g_values < 0;
    pf_mc = sum(fails)/nr_MC;

    % Plot the data
    for ij = 1:nx
       fprintf('figure(7+%d)',ij)
        fprintf('histogram(g_values(:,%d),100,''Normalization'',''probability'')',ij)
        title(sprintf('G%d',ij))
        xlabel('Limit state value [Pa]')
        fprintf('ylabel(''Probability for each data group based on 10^%d simulations'')', log10(nr_MC))
        grid on
    end
        
elseif strcmp(gfundata.type,'Madsen') %Copy paste this block directly into window.
    
    g_values = nan(nr_MC,1);
    for ii = 1:nr_MC
        % Gör funktionsanrop till G,
        g_vec = gvalue_fem('variables', p_star_mc(:,ii), probdata, rbdo_parameters, gfundata, 1, 0,0);
        g_values(ii,:) = g_vec';

        if mod(ii, (0.1*nr_MC)) == 0
         waitbar(ii / nr_MC)
         shg
        end
    end

    % Results
    fails = g_values < 0;
    pf_mc = sum(fails)/nr_MC;

    % Plot the data
    figure
    histogram(g_values, 100, 'Normalization', 'probability')
    xlabel('Limit state value [Nm]')
    eval(sprintf('ylabel(''Probability for each data group based on 10^%d simulations'')', log10(nr_MC)))
    grid on
   

    end
end







