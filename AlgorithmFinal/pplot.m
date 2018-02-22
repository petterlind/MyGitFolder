function pplot(x_values, limit_values, slope_values, dp, alpha_values_x, x_s, nr, probdata,rbdo_parameters,gfundata, no_cross, p_lim, exit_flag)
% Plots splines in p-direction for every limitstate.
flag_spline = 0;
% Values in p-direction
[p_val, p_fun, slope] = P_values(x_values, limit_values, alpha_values_x, dp, slope_values);
[p_s, ~, ~] = P_values(x_s, nan(length(x_s)) , alpha_values_x, dp,  nan(length(x_s)));

if length(p_val) > 1
    if abs( p_val(end-1) - p_val(end)) > 1e-12 && exit_flag ~= 23
        flag_spline = 1;
    end
end

p_trial = 6.1138;

% fit spline
if flag_spline == 1
    [~, ~, ~, spline_const] = spline_fun(p_val(end-1), p_fun(end-1), p_val(end), p_fun(end), slope(end-1));
    spline_val = @(p) spline_const(1) + spline_const(2)*p + spline_const(3)*p.^2 + spline_const(4)*p.^3;
end

% Plot setup
p_candidates = [p_s, p_val(end)];
[~,Imax] = max(abs(p_candidates));
num = 100;
%p_line_full = linspace(-p_candidates(Imax), p_candidates(Imax),num);
p_line_full = linspace(0,11,1000);

color = ['k','r','b','g','k','m','r','b','g','k','m','r','b','g','k','m','r','b','g','k','m'];



p_real = nan(num,1);
if strcmp(gfundata.type,'TRUSS')
    for ij= 1:length(p_line_full) % Already in X_space
        p_real(ij) = gvalue_fem('variables', alpha_values_x * p_line_full(ij) + dp, probdata, rbdo_parameters,gfundata,nr, 0,0);
    end   
else
    for ij= 1:length(p_line_full) % translation to x_Space!
        p_real(ij) = gvalue_fem('variables', X_space(alpha_values_x * p_line_full(ij) + dp, probdata.marg(:,2), probdata.marg(:,3)), probdata, rbdo_parameters,gfundata,nr, 0,0);
    end
end


% Plot 
% Spline
if flag_spline == 1
    p_line_spline = linspace(p_val(end-1),p_val(end), num);
    plot(p_line_spline,spline_val(p_line_spline),'MarkerSize',8,'Marker','none','Color', color(nr),'LineStyle','-','LineWidth',4)
    hold on
end

%point 1
plot(p_val(1), p_fun(1),'MarkerSize',8,'Marker','o','Color', color(nr),'LineStyle','none')
hold on
%point 2
plot(p_val(2), p_fun(2),'MarkerSize',8,'Marker','o','Color', color(nr),'LineStyle','none')
hold on

% Mpp
if no_cross == 0 && ~isempty(p_s)
    hold on
    plot(p_trial,0,p_s(end),0,'MarkerSize',4,'Marker','o','MarkerSize',20,'Color', color(nr))
end
%plot(9.99,0,'MarkerSize',4,'Marker','o','MarkerSize',20,'Color', color(nr))

%real value
plot(p_line_full,p_real,'LineWidth',2,'Color', color(nr),'LineStyle','--')

if ~isnan(p_lim)
    plot(p_lim, 0, 'MarkerSize',4,'Marker','p','MarkerSize',10,'Color', color(nr))
end

hold on
grid on

p_trial = 6.1138;

%linear 
plot([p_val(1), p_trial],[p_fun(1), 0],'LineWidth',2,'Color', color(nr),'LineStyle','--' )
plot([p_val(2),p_s(end)],[p_fun(2), 0],'LineWidth',2,'Color', color(nr),'LineStyle','--' )
legend('Nominal value', 'Probe point', 'Mpp Estimates')
xlabel('\alpha \cdot x')
ylabel('G(p)')


yticks([p_fun(1),p_fun(2)])
xticks([0 p_trial p_s(end)])
ytickslabels({'G(0)','G(p_t)'})
xticklabels({'Nominal point','p_t', 'Mpp-estimate'})

