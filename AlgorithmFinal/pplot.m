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

% fit spline
if flag_spline == 1
    [~, ~, ~, spline_const] = spline_fun(p_val(end-1), p_fun(end-1), p_val(end), p_fun(end), slope(end-1));
    spline_val = @(p) spline_const(1) + spline_const(2)*p + spline_const(3)*p.^2 + spline_const(4)*p.^3;
end

% Plot setup
p_candidates = [p_s, p_val(end)];
[~,Imax] = max(abs(p_candidates));
num = 100;
p_line_full = linspace(-p_candidates(Imax), p_candidates(Imax),num);
color = ['r','b','g','k','m','r','b','g','k','m','r','b','g','k','m','r','b','g','k','m'];


% Real values, note translation to x_Space!
p_real = nan(num,1);
for ij= 1:length(p_line_full)
     p_real(ij) = gvalue_fem('variables', X_space(alpha_values_x * p_line_full(ij) + dp, probdata.marg(:,2), probdata.marg(:,3)), probdata, rbdo_parameters,gfundata,nr, 0,0);
end

% Plot 
% Spline
if flag_spline == 1
    p_line_spline = linspace(p_val(end-1),p_val(end), num);
    plot(p_line_spline,spline_val(p_line_spline),'MarkerSize',8,'Marker','none','Color', color(nr),'LineStyle','-','LineWidth',4)
    hold on
end

%point
plot(p_val, p_fun,'MarkerSize',8,'Marker','o','Color', color(nr),'LineStyle','none')
hold on

% Mpp
if no_cross == 0 && ~isempty(p_s)
    hold on
    plot(p_s(end),0,'MarkerSize',4,'Marker','*','MarkerSize',20,'Color', color(nr))
end

%real value
plot(p_line_full,p_real,'LineWidth',2,'Color', color(nr),'LineStyle','--')

if ~isnan(p_lim)
    plot(p_lim, 0, 'MarkerSize',4,'Marker','p','MarkerSize',10,'Color', color(nr))
end

hold on
grid on