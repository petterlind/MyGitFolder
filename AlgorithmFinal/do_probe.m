function obj = do_probe(obj, pdata, Opt_set, RBDO_s)

%  1) RoC for probe point!
if RBDO_s.f_RoC
    obj.probe_x_pos = RoC(RBDO_s, pdata, Opt_set, obj.alpha_x * obj.p_trial + obj.nominal_x, obj.nominal_x, RBDO_s.lb_probe);

    if obj.probe_x_pos < RBDO_s.lb_probe 
        % probe_x_pos(test < Opt_set.lb) = Opt_set.lb;
        error('LS %d, Probe outside bounds for probe!')
    end
    
    obj.probe_p = obj.alpha_x' * (obj.probe_x_pos-obj.nominal_x);

    if obj.probe_p ~= obj.p_trial
        % fprintf('LS %d, RoC probe \n',obj.nr)
    end
    
    if obj.probe_p == 0
        fprintf('LS %d, probe = 0 \n',obj.nr)
        obj.probe_s = obj.probe_p;
        
    elseif (sign(obj.probe_p) ~= sign(obj.p_trial))
        error('SMTH off with Roc, in do_probe.m')
    end
    
else
    obj.probe_p = obj.p_trial;
    obj.probe_x_pos = obj.alpha_x * obj.probe_p + obj.nominal_x;
end


if obj.probe_p ~= 0
    % 2) Probe val - Do experiments
    obj.probe_val = gvalue_fem('variables', obj.nominal_x + obj.probe_p*obj.alpha_x, pdata, Opt_set, RBDO_s, obj, 1,0);

    % 4) adapt spline  
    [obj.spline, obj.probe_s] = spline(obj, 1);

    % 5) Has to be in same direction as the trial point. Otherwise no cross
    % or error
    sign_first_step = sign(obj.p_trial); %corresponds to the nominal step, has to elaborate a bit if more steps is to be conducted.

    if sign(obj.probe_s) ~= sign(sign_first_step)
            
        try
        if obj.nominal_val >1 && obj.probe_val > 1 % Both are positive
            obj.no_cross = 1;

            if RBDO_s.f_debug
                fprintf('No cross LS: %d \n',obj.nr)
                p_spline(obj, pdata, Opt_set, RBDO_s)
            end
        elseif isnan(obj.probe_s)
            error('In do_probe.m, p_s is NaN')
            
        % Should not move backwards from trial unless zero cross!
        elseif sign(obj.nominal_val) == sign(obj.probe_val) && sign(obj.probe_val)*obj.probe_s < sign(obj.probe_val)*obj.p_trial
            obj.probe_s = obj.p_trial;
            if RBDO_s.f_debug
                fprintf('p_s = p_trial, bacwards attempt: %d \n',obj.nr)
            end
            
        % If difference between probe and trial is small, they are the
        % same.
        elseif abs(obj.probe_s -obj.p_trial) < 1e-14
            obj.probe_s = obj.p_trial;
            if RBDO_s.f_debug
                fprintf('p_s = p_trial, no difference: %d \n',obj.nr)
            end
            
        else
            error('In do_probe.m, p_s is going opposite direction')
        end
        
        catch
            error('in do_probe')
        end
        
        
    end
end

% 6) Update the Mpp
obj.Mpp_x = obj.nominal_x + obj.probe_s * obj.alpha_x;
if ~sum(pdata.marg(:,1)) == 0 % If probabilistic variables!
    obj.Mpp_u = U_space(obj.Mpp_x, pdata.marg(:,2),pdata.marg(:,3),pdata.marg(:,1));
end

