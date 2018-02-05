
function [alpha, x_s, doe_scale, value_fun] = FitSurrogate(type, x_s, gfundata, rbdo_fundata, probdata, rbdo_parameters, doe_scale, update_flag_g, alpha)

% function that compute surrogate model given values around which to do DoE
% (u) and type "limitstate" or "cost, which changes the function calls
% within the function and also the number of surrogates models. Hence, only
% one model for the objective but several for the limit states. 

design_point = rbdo_parameters.design_point;
limits = cell2mat(rbdo_fundata.mpp_constraint);
lower_limits = limits(1:length(limits)/2);

doe_min = 1e-10;


switch type 
    
    case 'limitstate'
        
        nx          = length(design_point);   % Nr of DV 
        nc          = nx;  % Nr of constraints
        
        model = 'trend_point';              % Typ av model, linear or trend_point
        %model = 'linear';
        fit = 'spline';                          % b, b_and_gamma, all_constants, linear
        flag_plot_Doe = 0;
        flag_plot_p = 1;
        flag_max_p_s = 1;
        flag_max_trend = 1;
        flag_p_zero = 1;
        
        scale_para = 2; %2 worked well for 5-bar and 20
        
        %max_p_trend  = max_p_s/2;
        %max_p_trend = norm(doe_scale)/2;
        %max_p_s = 2e-3;
        %max_p_s = max_p_trend *2;
        flag_scale_DoE = 0;

        
    case 'cost'
         nc          = 1; % only one objective function
         nx          = length(design_point);   % Nr of DV 
         model = 'linear';
         flag_plot_Doe = 0;
         flag_plot_p = 0;
         
    case 'p_star'
        nc = length(design_point); % Nr of constraints ( in this case(!))
        nx          = numel(probdata.name);   % Nr of probibablistic parameters 

        model = 'linear';
        flag_plot_Doe = 0;
        flag_plot_p = 0;
        mu_vec = probdata.marg(:,2);
        stdv_vec = probdata.marg(:,3);
    otherwise
        warning('Unknown type in FitSurrogate')
        
end

% Allocating
r_0_vec = nan(nc,1);
a_vec = nan(nc,1);
%alpha = nan(nx,nc);

%normal_plane_vec = circshift(eye(nx),-1,2);
normal_plane_vec = eye(nx);
sgn = nan;
value_fun = nan(nc,1);

% Gör grejjerna i x-space

fprintf('experiments are done at DP! \n')
for ii = 1:nc
    
    flag_active_scale = 1;
    max_p_trend = norm(doe_scale(:,ii))*20;
    max_p_s = max_p_trend*4;
    p_s = nan;
    
    if update_flag_g(ii) == 1

        switch type

            case 'limitstate'
                
                  % If x_s is outside physical boundaries, move it inside!

%                 for ik = 1:length(x_s) 
%                     if x_s(ik,ii) < lower_limits(ik)
%                         [intersec,check] = plane_line_intersect(normal_plane_vec(:,ik),lower_limits,design_point,x_s(:,ii));
%                         if check == 1
%                             x_s(:,ii) = intersec;
%                              fprintf('Moved x_s nr: %d, to boundary \n',ii)
%                         elseif check == 0
%                             x_s(:,ii) = doe_x(:,ii);
%                             warning('Trend point can be outside the physical boundaries!')
%                         else
%                             warning('smth of with Mpp adjustment wrt phys boundaries.')
%                          end
%                         break;
%                     end
%                 end
                
                
                doe_x = Experiment(x_s(:,ii), doe_scale(:,ii));%, alpha(:,ii),ii,probdata, rbdo_parameters, gfundata);
                fun_val = nan(length(doe_x),1);  % Allocating fun value vector.                
                % Compute g(x)_j
                for ij = 1:length(doe_x)
                    fun_val(ij,1)= gvalue_fem('variables',doe_x(:,ij), probdata, rbdo_parameters, gfundata, ii, 1);
                end

            case 'cost'
                doe_x = Experiment(design_point, doe_scale(:,ii));%,nan, nan, nan, nan, nan);
                fun_val = nan(length(doe_x),1);  % Allocating fun value vector.
                % Compute c(x) in every point
                for ij = 1:length(doe_x)
                    fun_val(ij,1) = ObjectiveFunction(doe_x(:,ij), rbdo_fundata, gfundata);          
                end
                
            case 'p_star' 
                doe_u = U_space(x_s(:,ii), mu_vec, stdv_vec); % TRANSLATION TO U-SPACE!
                doe_x = Experiment(doe_u, doe_scale(:,ii));%,nan, nan, nan, nan, nan);
                fun_val = nan(length(doe_x),1);  % Allocating fun value vector.                
                % Compute g(x)_j
                
                for ij = 1:length(doe_x)
                    fun_val(ij,1)= gvalue_fem('parameters', X_space( doe_x(:,ij), mu_vec, stdv_vec), probdata, rbdo_parameters, gfundata, ii, 1);
                end
        end
        % save the first function value
        value_fun(ii) = fun_val(1);
        
        % Fit hyperplane to data
        A = [ ones(length(doe_x),1) (doe_x-doe_x(:,1))'];

        const_plane = A\fun_val;
        gradient(:,1) = const_plane(2:end);

        alpha(:,ii) = - gradient ./ norm( gradient );
        a = alpha(:,ii)' * gradient;
        
        % Point closest to origo
        p_s_plane = -(const_plane(1) ) / ( a );
        x_s_plane = doe_x(:,1)+ alpha(:,ii)*p_s_plane ;
       
        r_0_plane = - p_s_plane * ( alpha(:,ii)' * gradient );
        

        switch model

            case 'linear'
                %Saving the values
                r_0_vec(ii,1) = r_0_plane; 
                a_vec(ii,1) = a ; %slope in alpha-direction)
                x_s (:,ii) = x_s_plane;
                
                % For plotting purposes
                u_val_full = doe_x;
                fun_val_full = fun_val;
                linear_model = @(p) const_plane(1) + alpha(:,ii)' * gradient*p;

            case 'trend_point'
                
                % ---------------------------------------------------------
                % First trend point
                % ---------------------------------------------------------
                
                % Use the Mpp-estimate from the plane as default.
                x_values_extra = x_s_plane;
                
                if flag_max_trend == 1
                    p_trend = alpha(:,ii)' * (x_values_extra - doe_x(:,1));
                    if abs(p_trend) > max_p_trend && fun_val(1) > 0
                        x_values_extra = alpha(:,ii)*max_p_trend*sign(p_trend)+doe_x(:,1);
                        fprintf('max p_trend Nr: %d \n', ii)
                    elseif abs(p_trend) > max_p_trend && fun_val(1) < 0
                        x_values_extra = alpha(:,ii)*max_p_trend*sign(p_trend)+doe_x(:,1);
                        fprintf('min p_trend Nr: %d \n', ii)
                    end
                end

                % Do one extra Experiment at the trend point
                fun_val_extra = gvalue_fem('variables', x_values_extra, probdata, rbdo_parameters, gfundata, ii,1);

                % Add new values to the DoE_matrix
                u_val_full = [doe_x , x_values_extra];
                fun_val_full = [fun_val ; fun_val_extra];

                % From the plane, used in all cases
                p_values = alpha(:,ii)' * (u_val_full - doe_x(:,1).* ones(size(u_val_full))); 
                
     
                if flag_p_zero == 1
                    I = 1; % first value!
                elseif sign (p_values(end)) == 1
                    [~,I] = max(p_values(1:end-1)); % All but the last are included
                elseif sign (p_values(end)) == -1
                    fprintf('limitstate %d is on wrong side\n', ii)
                    [~,I] = min(p_values(1:end-1)); % All but the last are included
                end

                
                    switch fit

                        case 'linear'
                            a_l = [ 1 p_values(I)
                                        1 p_values(end)];

                            b_l = [fun_val_full(I); fun_val_full(end)];
                            const_linear_augumented = a_l \ b_l;

                            r_0 = const_linear_augumented(1);
                            a_trend = const_linear_augumented(2);
                            
                            p_s = -r_0/a_trend;

                        case 'spline'
                            
                            [r_0_spline, a_trend, p_s, spline_const] = spline_fun(p_values(1), fun_val_full(1), p_values(end), fun_val_full(end), a);
                            spline_curve = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
   
                    end
                    
                % ---------------------------------------------------------
                % Extra trend point
                % ---------------------------------------------------------
                
                diff = 0.5;
                trend = p_values(end);
                extra_spline = 0;
                
                %if abs((p_s -  p_s_plane) / p_s_plane) > diff || sign(a_trend) ~= sign(a)
                if abs((a_trend -  a) / a) > diff || sign(a_trend) ~= sign(a)
                    
                    conv = 1;
                    while conv

                        % saving function expression of older spline
                        spline_curve = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
                    
                        % New trendpoint
                        new_trend = trend/2; % Half distance
                        
                        % New experiment
                        fun_new = gvalue_fem('variables', alpha(:,ii)* new_trend + doe_x(:,1), probdata, rbdo_parameters,gfundata,ii, 1);

                        % spline to new trendpoint
                        [r_0_new, a_new, p_s_new, spline_const] = spline_fun(p_values(1), fun_val_full(1), new_trend, fun_new, a);
                        spline_curve_new = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
                        
                        % Compare relative values
                        if abs((spline_curve_new(new_trend) - spline_curve(new_trend)) / spline_curve(new_trend)) < diff
                            conv = 0;
                            
                            % Make spline from last values
                            [r_0, a, p_s, spline_const] = spline_fun(new_trend, fun_new, trend, spline_curve(trend), a_new);
                            spline_curve = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
                            extra_spline = 1;
                            
                            % OM FORTFARANDE BAKÅT - ta bort denna från
                            % optimeringen, 
                            
                            % OM fortfarande för långt fram ?
                             
                        else
                            trend = new_trend;
                        end
                    end
                    
                elseif abs(p_s) > max_p_s
                    
                    % Extra trendpoint @ twice the distance
                    new_trend = 2*trend;
                    fun_new = gvalue_fem('variables', alpha(:,ii)*new_trend  + doe_x(:,1), probdata, rbdo_parameters,gfundata,ii, 1);
                    
                    % Make spline from last values
                    [r_0_spline, a_trend, p_s, spline_const] = spline_fun(trend, spline_curve(trend), new_trend, fun_new, a_trend);
                    spline_curve = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
                    
                    extra_spline = 1;
                    % Om för olinjär?
                end

                     
%                  %MAX p_s;
%                 if flag_max_p_s == 1 
%                     if abs(p_s) > max_p_s && fun_val(1) > 0
%                         p_s = sign(p_s)*max_p_s;
%                         fprintf('max p_s Nr: %d \n', ii)
%                         flag_active_scale = 0;
%                         
%                     elseif abs(p_s) > max_p_s && fun_val(1) < 0
%                         p_s = sign(p_s)*max_p_s; %
%                         fprintf('min p_s Nr: %d \n', ii)
%                         flag_active_scale = 0;
%                     end
%                 end
                    
                    
                % Save for all nc cases
                r_0_vec(ii,1) = r_0_spline;
                a_vec(ii,1) = a_trend;

                % update the parameters in the anonymous functions.
                surrogate_line = @(p) r_0_spline + a_trend * p; % + b*(p-p_mpp)^2;

                
                % Compute x_s
                x_s(:,ii) = doe_x(:,1) + alpha(:,ii) * p_s;
                
%                 % If x_s is outside physical boundaries, move it inside!
%                 if flag_zero_grad ~= 1
%                     for ik = 1:length(x_s) 
%                         if x_s(ik,ii) < lower_limits(ik)
% 
%                             [intersec,check] = plane_line_intersect(normal_plane_vec(:,ik),lower_limits,doe_x(:,1),x_s(:,ii));
%                             if check == 1
%                                 x_s(:,ii) = intersec;
%                                  fprintf('Moved x_s nr: %d, to boundary \n',ii)
%                             elseif check == 0
%                                 x_s(:,ii) = doe_x(:,ii);
%                                 warning('Trend point can be outside the physical boundaries!')
%                             else
%                                 warning('smth of with Mpp adjustment wrt phys boundaries.')
%                              end
%                             break;
%                         end
%                     end
%                 end
                
                
                
                % if isnan, warning
                if isnan(x_s(:,ii))
                    warning '--------------------------------------------')
                    warning('ISNAN!')
                    warning '--------------------------------------------')
                    % Find constants for the equation
%                     
                end
                
        
        if flag_scale_DoE == 1 && flag_active_scale == 1

                doe_scale(:,ii) = min(norm(doe_x(:,1)-x_s(:,ii))/ scale_para, 1e-3*ones(nx,1));
                fprintf('scale down Nr:%d, new size %d \n',ii,doe_scale(1,ii));
                
                if doe_scale(1,ii) < doe_min
                    doe_scale(:,ii) = ones(length(doe_scale(:,ii)),1)*doe_min;
                    fprintf('scaled to min DoE')
                    
                end
        end
        
        end
    end
        
        if flag_plot_p == 1 %&& ii == 8
            
            %figure(3)
            figure(ii)
            clf
            color = ['r','b','g','k','m','r','b','g','k','m','r','b','g','k','m','r','b','g','k','m'];
            
        % Experiments
        hold on
        if extra_spline == 1

            spline_start = new_trend;
            spline_end = trend;
            
            %extra trend_point
            plot(new_trend, spline_curve(new_trend),'MarkerSize',8,'Marker','o','Color', color(ii+1),'LineStyle','none')
            hold on
        else
            spline_start = p_values(1);
            spline_end = p_values(end);

        end
        
        plot(p_values,fun_val_full,'MarkerSize',8,'Marker','o','Color', color(ii),'LineStyle','none')
        hold on
        plot(p_s,0,'MarkerSize',4,'Marker','*','MarkerSize',20,'Color', color(ii))
        hold on

        % Surrogate model, line
        num = 100;
        
        %Biggest value 
        p_candidates = [p_s, p_values(end)];
        [~,Imax] = max(abs(p_candidates));

        p_line = linspace(-p_candidates(Imax), p_candidates(Imax),num);
        p_fun_values = nan(length(p_line),1);
        
        for ij= 1:length(p_line)
            p_fun_values(ij) = surrogate_line(p_line(ij));  
        end
        
            % Surrogate model spline
            p_spline = linspace(spline_start, spline_end, num);
           
            p_spline_values = nan(length(p_line),1);
            
            for ij= 1:length(p_line)
                p_spline_values(ij) = spline_curve(p_spline(ij));
                p_real(ij) = gvalue_fem('variables', alpha(:,ii)* p_line(ij) + doe_x(:,1), probdata, rbdo_parameters,gfundata,ii, 0);
            end
            plot(p_spline,p_spline_values,'LineWidth',2,'Color', color(ii),'LineStyle','-')
            plot(p_line,p_real,'LineWidth',2,'Color', color(ii),'LineStyle','--')
            
            
            
        %end
        hold on
        plot(p_line,p_fun_values,'LineWidth',2,'Color', color(ii),'LineStyle',':')
        if extra_spline == 1
            legend('Extra p_t','Experiments','MPP','Spline','G(p)')
        else
            legend('Extra p_t','Experiments','MPP','Spline','G(p)')
        end
        
        title(sprintf('Limitstate Nr:%d', ii))
        hold on
        grid on
        

        %ylim([0 gm_num*1.1])
        
%             if ii == 10
%                 disp('brake')
%             end
            
        end
        
        if flag_plot_Doe == 1
            
           
            
            
            figure(10 + ii)
            clf
            
            hold on
            % plot test points
            %color = ['r','b','g','k'];
            plot3(u_val_full(1,:)', u_val_full(2,:)', fun_val_full,'MarkerSize',10,'Marker','o','LineWidth',3,'Color', color(ii), 'LineStyle','none')
            
            hold on
            %2d
            %plot(u_val_full(1,:)', fun_val_full,'MarkerSize',10,'Marker','o','LineWidth',3,'Color', color(ii),'LineStyle','none')

            
            % plot MPPs
            plot3(x_s(1,ii)', x_s(2,ii)', 0,'MarkerSize',20,'Marker','*','LineWidth',3,'Color', color(ii))
            
            %2D
            %plot(x_s(1,ii)', 0,'MarkerSize',20,'Marker','*','LineWidth',3,'Color', color(ii),'LineStyle','none')
           
            %plot the fitted values in u every iteration, in the allowed area.
            nr_x1 = 100;
            nr_x2 = 100;

            % Percentage difference
            per = 1;
            
            % Plot a very local area
            x1 = linspace( 1e-8*per, 7.85e-3*per, nr_x1);
            x2 = linspace(  7.85e-5*per, 7.85e-3*per, nr_x2);

            % Allocate memory
            real = nan(nr_x1,nr_x2);
            surrogate = nan(nr_x1,nr_x2);
            Xplot = nan(nr_x1,nr_x2);
            Yplot = nan(nr_x1,nr_x2);
            
            
            for ij = 1:nr_x1
                for ik = 1:nr_x2
                %for ik = 1 % 2d
                    
                    switch type
                        
                        case 'limitstate'
                            % Values for the Real curve
                            real(ij,ik) = gvalue_fem('variables', [x1(ij); x2(ik)], probdata, rbdo_parameters,gfundata,ii, 0);
                            
                            % Values for the fitted curves
                            % 3d
                             surrogate(ij,ik) = surrogate_line( alpha(:,ii)'* ( [x1(ij); x2(ik)] - doe_x(:,1)));
                            
                            % 2d
                            %surrogate(ij,ik) = surrogate_line( alpha(:,ii)'* ( x1(ij) - doe_x(:,1)));
                            
                        case 'cost'
                            % Values for the real cost-curve
                            
                            % 3d
                            real(ij,ik) = ObjectiveFunction( [x1(ij); x2(ik)],rbdo_fundata,gfundata);
                            surrogate(ij,ik) = linear_model( alpha(:,ii)'* ( [x1(ij); x2(ik)] - doe_x(:,1)));
                            
                            %2d
                            %real(ij,ik) = ObjectiveFunction( x1(ij),rbdo_fundata,gfundata);
                            %surrogate(ij,ik) = linear_model( alpha(:,ii)'* ( x1(ij) - doe_x(:,1)));
                    end
                        

                    %Surrogate(r_0(ii), a(ii), b(ii), alpha(:,ii), [x1(ij); x2(ik)], p_bar(ii), gamma(ii));

                    Xplot(ij,ik) = x1(ij);
                    Yplot(ij,ik) = x2(ik);

                end
            end
            
            %3d
            hold on
            h1Surface = surf(Xplot,Yplot,real);
            set(h1Surface, 'FaceColor', color(ii))%, 'FaceAlpha',0.5, 'EdgeAlpha', 0);

            hold on
            h2surface = surf(Xplot,Yplot,surrogate);
            set(h2surface, 'FaceColor', color(ii), 'FaceAlpha',0.5, 'EdgeAlpha', 0);
            hold on

            %2d
            %plot(Xplot,real,'Color', color(ii),'LineStyle','--')%,'Marker','*')
            %plot(Xplot,surrogate,'Color', color(ii),'LineStyle','-')%,'Marker','*')
            
            grid on

            %zlim([-1,2])
            %zlim([0, max(max(real))]);
            xlabel('x1')
            ylabel('x2')
            zlabel('g(u)-value')

        end
    
end



    
