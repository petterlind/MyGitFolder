function p_spline(obj, pdata)

figure
spline_curve = @(p)  obj.spline(1) + obj.spline(2)*p + obj.spline(3)*p.^2 + obj.spline(4)*p.^3;
pp = linspace(obj.p_x, obj.probe_p,100);
plot( pp, spline_curve(pp));
hold on
plot( [obj.probe_p, obj.probe_s], [obj.probe_val, 0], '--')
hold on

% Points in spline
plot([obj.p_x, obj.probe_p], [obj.p_val, obj.probe_val], 'or');

hold on
% Rest of DoE
if pdata.nx == 0
    [p_doe, val_doe] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x); %then alpha_x is same in x and u-space!
    
    p_doe = (obj.doe_x(:,2:end) - obj.nominal_x)*obj.alpha_x;
    plot(p_doe, obj.doe_val(2:end), '+r');
end

