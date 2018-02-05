function  [max_step_RoC, step] = Max_step(p_val, trial, l, RBDO_settings)
% Computes steplength as function of previous step, if no previous step the
% step length is set to default.

if l > 0 && length(p_val)> 1
    max_step_RoC = RBDO_settings.scale_RoC * abs(p_val(end)-p_val(end-1));
    step = abs(trial-p_val(end));
    %max_step_RoC= RBDO_settings.default_step_t;
elseif l == 0
    max_step_RoC = RBDO_settings.default_step_t;
    step = abs(trial);
    
elseif length(p_val) == 1 && l > 0
    fprintf('no p_val \n')
    step = abs(trial-p_val(end));
    max_step_RoC = RBDO_settings.default_step_t;
else
    warning('Smth off with max-step!')
    max_step_RoC = RBDO_settings.default_step_t;
    step = abs(trial);
end
end
