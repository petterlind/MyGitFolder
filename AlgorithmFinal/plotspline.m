function plotspline(spline_const, p_lower, p_upper, alpha_values, dp, probdata, rbdo_parameters, gfundata, nr )

ptest = linspace(p_lower,p_upper,1000);
spline_val = @(p) spline_const(1) + spline_const(2)*p + spline_const(3)*p.^2 + spline_const(4)*p.^3;

for ij= 1:length(ptest) % Already in X_space
    p_real(ij) = gvalue_fem('variables', alpha_values * ptest(ij) + dp, probdata, rbdo_parameters,gfundata,nr, 0,0);
end   


plot(ptest,spline_val(ptest),'k')
hold on
plot(ptest,p_real,'--r')
legend('Spline','G')


