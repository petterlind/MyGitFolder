function [pt_num, step, max_t_bounds, active_l] = Next_probe(p_val, p_fun, p_trial, l, nr, RBDO_settings,dp, alpha_values, lb, dp_fun, flag)

active_l = true;

%flag.RoC

% Check if outside ROC or boundaries
[max_t_RoC, step] = Max_step(p_val, p_trial, l, RBDO_settings);
max_t_bounds = P_lim(dp, alpha_values, lb, sign(dp_fun));

% p_values is outside bounds
if abs(max_t_bounds) <=  abs(p_val(end)) && abs(p_trial) > abs(max_t_bounds) || abs( p_val(end) - max_t_bounds) <1e-12
    pt_num = max_t_bounds;
    step = 0;
    
    if sign(dp_fun) > 0
        %active_l = false; % if to be removed
        if flag.debug == 1
            fprintf('p_trend is on limit Nr: %d, sign(G(p=0))>0, keep active \n', nr)
        end
    elseif sign(dp_fun) < 0
        if flag.debug == 1
            fprintf('p_trend is on limit Nr: %d, sign(G(p=0))<0, keep active \n', nr)
        end
    else
        warning('strange behaviour Next_probe')
    end
    
% Allt ok med probe    
elseif abs(max_t_bounds) > abs(p_val(end)) || isnan(max_t_bounds) 
    max_step_t = min(abs(max_t_bounds - p_val(end)), max_t_RoC);
    trial_step = abs(p_val(end)-p_trial);
    
    if trial_step > max_step_t 
        step = max_step_t;
        if flag.debug == 1
            fprintf('max p_trend Nr: %d \n', nr)
        end
        
    elseif trial_step <= max_step_t
        step = trial_step;
    else
        warning('p_trial is conflicting with RoC')
    end
    
    pt_num = p_val(end) + step * sign(p_fun(end));
    
else
    warning('smth off in Next_probe')

end

    
    

