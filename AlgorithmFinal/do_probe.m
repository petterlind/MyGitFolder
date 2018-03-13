function obj = do_probe(obj, pdata, RBDO_s)


%  1) Do some kind of sanity check
obj.probe_p = obj.p_trial;

% 2) Probe val - Do experiments
obj.probe_val = gvalue_fem('variables', obj.nominal_x + obj.probe_p*obj.alpha_x, pdata, RBDO_s, obj, 1,0);

% 3) Find closest point from probe to DoE
[~,p_I] = min(abs(obj.p_x - obj.p_trial));

% 4) adapt spline
[obj.spline, obj.probe_s] = spline(obj, p_I);

%p_spline(obj)

% 5) Has to be in same direction as the trial point. Otherwise no cross

sign_first_step = sign(obj.p_val); %corresponds to the nominal step, has to elaborate a bit if more steps is to be conducted.

if sign(obj.probe_s) ~= sign(sign_first_step)
    error('In do_probe.m, p_s is going opposite direction')
end

% 6) Update the Mpp
%p_spline(obj)
obj.Mpp_x = obj.nominal_x + obj.probe_s*obj.alpha_x;
obj.Mpp_u = U_space(obj.Mpp_x, pdata.marg(:,2),pdata.marg(:,3));

