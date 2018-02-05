clear all 
close all

% --------------------------------
% 1) Input 
% --------------------------------
 nr_of_trusses = 10;
% inputfile_trusses,
% inputfile_YounChoi
inputfile_Madsen

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
flag.debug = 1;
flag.RoC = 1;
flag.max_step = 1;

% Globals
global Gnum
Gnum = 0;

% algorithm settings

RBDO_settings.tol_non_linear = 0.5; %0.1 was too low?!
RBDO_settings.tol = 1e-3;
% RBDO_settings.default_max_step_t = 10;
% RBDO_settings.scale_RoC = 100;
% RBDO_settings.Roc = 7e-3;
% max_step = 	10e-3; %8e-3; %3e-3;

dp_old = rbdo_parameters.design_point + [rbdo_parameters.design_point(1)+RBDO_settings.doe_scale; rbdo_parameters.design_point(2:end)];
% --------------------------------
% 2) Main Loop
% --------------------------------

update = logical(ones(1,nc)); % FIX
while flag.outer_conv

    if k > 10 || l >20
        flag.not_conv = 1;
        break
    end

    k = k + 1;
    l = 0;
    flag.inner_conv = 1;
    test_lnf1 = 0;

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
    
%     RBDO_settings.doe_scale = min( norm(dp-dp_old) , RBDO_settings.doe_scale );
%     
%     if RBDO_settings.doe_scale < 5e-4
%         RBDO_settings.doe_scale = 5e-4;
%     end
    
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
    if strcmp(gfundata.type,'Trusses') || strcmp(gfundata.type,'YounChoi')
        update = alpha_c_new' * alpha_inner  > 0; % KKT !?
    
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
        plot_YounChoi(probdata, dp, x_s)
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
            else
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

                figure(fignr)
                pnr = mod( nr, 5);
                if pnr == 0
                    pnr = 5;
                end

               % subplot( 5, 1, pnr);
                pplot(mysqueeze(x_values(nr,:,:)), limit_values(nr,:), slope_values(nr,:), dp, alpha_inner(:,nr), mysqueeze(x_s(nr,:,:)), nr, probdata,rbdo_parameters,gfundata, no_cross, p_lim, flag.exit)
                ylabel(sprintf('%d,flag=%d',nr, flag.exit))
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
        
        if strcmp(gfundata.type,'Trusses')
            
            fun = @(x) norm(x-dp);
            feasible_dp = fmincon(fun,dp,A,b,[],[],lb,ub*1.5);
            flag.linprog = 1; 
            options = optimoptions('linprog','Algorithm','dual-simplex','OptimalityTolerance', 1e-10,'ConstraintTolerance',1e-3);
            
            % Run optimization and check the convergence
            [ optimum_dp, fval, flag.linprog, output] = linprog(f, A, b, [],[], lb_opt, ub_opt*1.5,options);

            % Roc - hypersphere.
            if norm(feasible_dp-dp) > RBDO_settings.Roc  % feasible utanf�r RoC
                dp_l = dp+ RBDO_settings.Roc*(feasible_dp-dp)/norm(feasible_dp-dp);
            elseif norm(feasible_dp-dp) < RBDO_settings.Roc % feasible innanf�r RoC

                if norm(optimum_dp-dp) < RBDO_settings.Roc % Optimum innanf�r Roc
                    dp_l = optimum_dp;
                elseif norm(optimum_dp-dp) > RBDO_settings.Roc %Optimum utanf�r max_step,

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
           
           elseif strcmp(gfundata.type,'TRUSS') % Youn and choi
               active_l_conv = Check_step( active_l_conv, alpha_inner, x_s, x_values(: ,:,:), flag.no_cross, 2);
           end
           
        end
        
        if strcmp(gfundata.type, 'Madsen') && active_l_conv(1) == 1
            MPP_real = [ 2.615; -0.831; -1.866; -0.790; 0.037; -0.019; -0.056 ];
            Dist_Mpp_real = norm( x_s_new - MPP_real);
            xnum = 1:7;
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

%               elseif  abs(norm(dp_l-dp_l_old)/norm(dp_l_old)) < RBDO_settings.tol 
% 
%                   if flag.debug == 1
%                       fprintf('%d Inner steps, Small relative change of dv \n', l+1)
%                   end
%                   flag.inner_conv = 0;
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
        dp_test = dp;
        dp_l_test = dp_l;
        index_max = abs(dp_l-dp) > RBDO_settings.Roc ;
        dp_l( index_max ) = dp(index_max )+ RBDO_settings.Roc .*sign(dp_l(index_max) - dp(index_max)); % updated design proposal

        if norm(dp-dp_l) > max_step
            dp = (max_step * (dp_l-dp)) / norm(dp-dp_l) + dp;
            fprintf('max_step \n')
        else 
            dp = dp_l;
        end
        
        % Update objective value and dp
        obj_old = obj_new(1);
        if strcmp(gfundata.type,'TRUSS')
            rbdo_parameters.design_point = dp;
            obj_new = ObjectiveFunction(dp, rbdo_fundata, gfundata);
            variable_diff = abs(dp-dp_old);
        else
            %rbdo_paramters.design_point = dp; % Not used...
            %probdata.marg(:,2) = X_space(dp,probdata.marg(:,2),probdata.marg(:,3));
            obj_new = ObjectiveFunction(X_space(dp, probdata.marg(:,2),probdata.marg(:,3)), rbdo_fundata, gfundata);
            variable_diff = abs( X_space(dp_old,probdata.marg(:,2),probdata.marg(:,3)) - X_space(dp, probdata.marg(:,2),probdata.marg(:,3)));
        end
            
     disp(Gnum)
    % Do a convergence check in the outer loop
    if abs(obj_old - obj_new)/ obj_old < RBDO_settings.tol %&& max(variable_diff)< 1e-3
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
       plot_YounChoi(probdata, dp, x_s)
end


% Monte Carlo simulations. A7
flag.MC = 0;
% Lista lite optimala parametrar h�r f�r framtiden...
if flag.MC == 1

   
     dp_5bar = [ 0.002255721021462
   0.002826060651946
   0.000078540000000
   0.000496818850370
   0.003421232939500];

    pf_5bar = [0.080000000000000   0.080000000000000                   0   0.400000000000000   0.080000000000000]; % 1e5

    pf_5bar2 = [0.100000000000000   0.106000000000000                   0   0.441000000000000   0.108000000000000];
    %1e6 runs
    pf_5bar3 = [0.101200000000000   0.104400000000000                   0   0.415200000000000   0.099900000000000]; % 1e7


    dp_10bar = [      0.000255849570713
   0.000680991427883
   0.005094838762924
   0.000078540000000
   0.002323937323810
   0.000283547451143
   0.003013940169451
   0.000078540000000
   0.001093001470922
   0.005654361923694];
    
   pf_10bar1 = [0.114500000000000                   0   0.000130000000000   0.139280000000000   0.000100000000000   0.114980000000000   0.000100000000000                   0   0.000380000000000   0.000090000000000];
   
   % Med nominella gr�nsv�rdet enbart
   pf_10bar2 = [0.000080000000000   0.011260000000000   0.000110000000000                   0   0.000100000000000   0.000080000000000   0.000060000000000                   0   0.000080000000000   0.000080000000000];
    
   dp_15bar = [0.000321954989616
   0.001503567602741
   0.005427947132356
   0.000078540000000
   0.002503792521622
   0.001258938593470
   0.000405550823638
   0.007637839137717
   0.000078540000000
   0.004235288865696
   0.001319079725518
   0.003199828106611
   0.000078540000000
   0.001838229746550
   0.008333635338384];

   pf_15bar1 =[0.110000000000000
                   0
   0.200000000000000
   0.250000000000000
   0.060000000000000
   0.110000000000000
   0.130000000000000
   0.100000000000000
   0.140000000000000
   0.040000000000000
   0.110000000000000
   0.010000000000000
                   0
   0.100000000000000
   0.060000000000000];

    nr_MC = 1e5;
    % Plocka v�rden p� p b�rja med 1000 st
    
    g_values = nan(nr_MC,length(dp));

    p_star_mc = probdata.marg(:,2) + probdata.marg(:,3).*randn(4,nr_MC);

    h = waitbar(0,'Soon...');
    for ii = 1:nr_MC

        probdata.p_star = p_star_mc(:,ii);

        % G�r funktionsanrop till G, A7
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
end







