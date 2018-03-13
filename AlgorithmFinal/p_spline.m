function p_spline(obj)

figure
spline_curve = @(p)  obj.spline(1) + obj.spline(2)*p + obj.spline(3)*p.^2 + obj.spline(4)*p.^3;
pp = linspace(obj.p_x, obj.probe_p,100);
plot( pp, spline_curve(pp));
hold on
plot( [obj.probe_p, obj.probe_s], [obj.probe_val, 0], '--')
hold on

plot([obj.p_x, obj.probe_p], [obj.p_val, obj.probe_val], 'or');