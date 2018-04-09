function p_spline(obj, pdata, Opt_set, RBDO_s)

nr_p = 100; % Number of points in plots for lines!

figure(3)
spline_curve = @(p)  obj.spline(1) + obj.spline(2)*p + obj.spline(3)*p.^2 + obj.spline(4)*p.^3;
pp = linspace(obj.p_x(1), obj.probe_p,nr_p);
plot( pp/(2.54e-2)^2, spline_curve(pp));
hold on
plot( [obj.probe_p, obj.probe_s]/(2.54e-2)^2, [obj.probe_val, 0], '--')
hold on

% Points in spline
plot([obj.p_x.'; obj.probe_p]/(2.54e-2)^2 , [obj.p_val; obj.probe_val], 'or');

hold on

% Rest of DoE
if pdata.nx == 0
    [p_doe, val_doe] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x); %then alpha_x is same in x and u-space!
    
    p_doe = (obj.doe_x(:,2:end) - obj.nominal_x)*obj.alpha_x;
    plot(p_doe/(2.54e-2)^2, obj.doe_val(2:end), '+r');
end

% Real value
real_g = nan(nr_p,1);
pp2 = linspace(obj.probe_p, obj.probe_s, nr_p);
real_g2 = nan(nr_p,1);
for ii = 1:nr_p % spline part
    real_g(ii) = gvalue_fem('variables', obj.nominal_x + obj.alpha_x* pp(ii), pdata, Opt_set, RBDO_s, obj, 0,0);
    real_g2(ii) = gvalue_fem('variables', obj.nominal_x + obj.alpha_x* pp2(ii), pdata, Opt_set, RBDO_s, obj, 0,0);
end

    hold on
    plot( pp/(2.54e-2)^2,real_g ,'-sb');
    plot( pp2/(2.54e-2)^2,real_g2 ,'-*b');
    
ylabel('G-value')
xlabel('Distance [In^2]')

