function [pt_final, ps_final, limit_new, slope_new, no_cross, exit_val, active_l] = Check_probe(pt_num, pm_num, gm_num, k_num, step, dp, alpha_values, probdata, rbdo_parameters, gfundata, nr, RBDO_settings, active_l, flag_debug)


% PROBE
% exit_val = 0, is on limit (pt = pm)
% exit_val = 1, Everything OK
% exit_val = 2, Iterated inside
% exit_val = 20, iterated, on limit
% exit_val = 21, Iterated, ok
% exit_val = 23, Iterated, no_cross

conv = 1;
no_cross = 0;

% Check if pt is same as pm
if  abs(pm_num - pt_num) < 1e-12

    pt_final = pm_num;
    ps_final = pt_final;
    limit_new = gm_num;
    slope_new = k_num;
    % active_l = active_l
    exit_val = 0;

else %not too close, lets do a spline and investigate!

    % Extra experiment at the trend point
    x_values_extra = alpha_values * pt_num + dp;
    
    if strcmp(gfundata.type,'TRUSS')
        [Gt_num, ~] = gvalue_fem('variables', x_values_extra, probdata, rbdo_parameters, gfundata, nr, 1,0);
    elseif strcmp(gfundata.type,'YounChoi') || strcmp(gfundata.type,'Madsen') %Transform dp to x-space!
        [Gt_num, ~] = gvalue_fem('variables', X_space(x_values_extra, probdata.marg(:,2),probdata.marg(:,3)), probdata, rbdo_parameters, gfundata, nr, 1,0);
    end
        
    [~, a_trial, p_s_trial, spline_const] = spline_fun(pm_num, gm_num, pt_num, Gt_num, k_num);
    %spline_curve_old = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;

    % Check non-linearity
    if abs((k_num -  a_trial) / k_num) > RBDO_settings.tol_non_linear  || sign(k_num) ~= sign(a_trial) || ( sign(gm_num) == sign(Gt_num) && abs(gm_num) - abs(Gt_num) < 0 )

        trend_old = pt_num;
        a_temp = a_trial;
        iter = 0;

        while conv
            iter = iter + 1;

            step = step/2;
            % Figure out direction
            if gm_num > 0
                trend_new = pm_num + step;
            elseif gm_num < 0
                trend_new = pm_num - step;
            else
                warning('Gt_num is NaN in Check_probe')
            end

            % saving function expression of older spline
            spline_curve_old = @(p)  spline_const(1) + spline_const(2)*p + spline_const(3) * p ^2 + spline_const(4) * p ^3;
            Gt_old = Gt_num;

            % New experiment
            if strcmp(gfundata.type,'TRUSS')
                [Gt_num, ~] = gvalue_fem('variables', alpha_values * trend_new + dp, probdata, rbdo_parameters, gfundata, nr, 1,0);
            elseif strcmp(gfundata.type,'YounChoi') || strcmp(gfundata.type,'Madsen') % Transform dp to x-space!
                [Gt_num, ~] = gvalue_fem('variables', X_space(alpha_values * trend_new + dp, probdata.marg(:,2),probdata.marg(:,3)), probdata, rbdo_parameters, gfundata, nr, 1,0);
            end
            a_old = a_temp;

            % Check step
            if abs(pm_num - trend_new) > 1e-13
                [~, a_temp, ~, spline_const] = spline_fun(pm_num, gm_num, trend_new, Gt_num, k_num);

                if abs((spline_curve_old(trend_new) - Gt_num) / spline_curve_old(trend_new)) < RBDO_settings.tol_non_linear && ( sign(gm_num) == sign(Gt_old) && abs(gm_num) - abs(Gt_old) < 0 ) == 0 && sign(k_num) == sign(a_temp)

                    conv = 0;
                    pt_final = trend_old;
                    limit_new = Gt_old;
                    slope_new = a_old;
                    ps_final = pt_final - limit_new/slope_new; % linear
                    exit_val = 21;
                    if flag_debug == 1
                        fprintf('Iterations: %d, limitstate: %d \n',iter, nr);
                    end

                elseif sign(k_num) ~= sign(a_temp) && abs((spline_curve_old(trend_new) - Gt_num) / spline_curve_old(trend_new)) < RBDO_settings.tol_non_linear && ( sign(gm_num) == sign(Gt_num) && abs(gm_num) - abs(Gt_num) > 0 ) % ( sign(gm_num) == sign(Gt_old) && abs(gm_num) - abs(Gt_old) > 0 ) 

                    % Still not crossing - no solution exists
                    conv = 0;
                    no_cross = 1;
                    %no_cross = 0;
                    pt_final = trend_old;
                    limit_new = Gt_old;
                    slope_new = a_old;
                    ps_final = nan; % linear
                    %ps_final = pt_final
                    exit_val = 23;

                    if flag_debug == 1
                        fprintf('No cross, Iterations: %d, limitstate: %d \n',iter, nr);
                    end

                else % still not sure.
                    trend_old = trend_new;
                end

            else

                pt_final = pm_num;
                ps_final = pm_num - gm_num/k_num;
                limit_new = gm_num;
                slope_new = k_num;
                % active_l = active_l
                exit_val = 20;
                conv = 0;

                if flag_debug == 1
                fprintf('pt=pm, Iterations: %d, limitstate: %d \n',iter, nr);
                end
            end
        end
    else
        pt_final = pt_num;
        ps_final = p_s_trial;
        limit_new = Gt_num;
        slope_new = a_trial;
        % active_l = active_l
        exit_val = 1;
    end
end