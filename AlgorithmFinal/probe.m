function [x_new, limit_new, slope_new, x_s, no_cross, exit_val, max_t_bounds,active_l, ps_final] = probe(x_values, limit_values, alpha_values, slope_values, dp, RBDO_settings, probdata, rbdo_parameters, gfundata, nr, l,k, lb, flag)
% Inputs: x-values, direction, dp, slope  
% Outputs: new trend point, slope at that point. Outputs no_cross = 1 if no crossing occurs.
lst = 1:1000;

dp = mysqueeze(dp);
if numel( dp(1,:) ) > 1
    mpp_index = double(min(lst(isnan(dp(:,1)))) -1);
    dp = dp(mpp_index,:)';
    % limit_values(1) = []; % one more Mpp than function values at mpp.  D2
    % limit_not_nan = limit_values(~isnan(limit_values));
    % limit_values = limit_not_nan(1:end-1); % Remove the one added from gradient!
end

% Pick values in the alpha direction
[p_val, p_fun, slope] = P_values(x_values, limit_values, alpha_values, dp, slope_values);

% The last one is the latest update.
gm_num = p_fun(end);
pm_num = p_val(end);
k_num = slope(end);
dp_fun = p_fun(1);

% Intersection with y =0
p_trial = pm_num - gm_num/k_num;

[pt_num, step, max_t_bounds, active_l] = Next_probe(p_val, p_fun, p_trial, l, nr, RBDO_settings, dp, alpha_values, lb, dp_fun, flag);
[pt_final, ps_final, limit_new, slope_new, no_cross, exit_val, active_l] = Check_probe(pt_num, pm_num, gm_num, k_num, step, dp, alpha_values, probdata, rbdo_parameters, gfundata, nr, RBDO_settings, active_l, flag.debug);

x_new = alpha_values * pt_final + dp;
x_s = alpha_values * ps_final + dp;
end

    
    
    