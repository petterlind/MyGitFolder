function pplot_sub(x_values, limit_values, slope_values, dp, alpha_values_x, x_s, nr, probdata,rbdo_parameters,gfundata, no_cross)
% Plots splines in p-direction for every limitstate.

% Grafic
figure(nr+10)
clf

% Values in p-direction
[p_val, p_fun, slope] = P_values(x_values, limit_values, alpha_values_x, dp, slope_values);
[p_s, ~, ~] = P_values(x_s, nan(length(x_s)) , alpha_values_x, dp,  nan(length(x_s)));

% fit spline
if p_val(end-1) ~= p_val(end)
    [~, ~, ~, spline_const] = spline_fun(p_val(end-1), p_fun(end-1), p_val(end), p_fun(end), slope(end-1));
    spline_val = @(p) spline_const(1) + spline_const(2)*p + spline_const(3)*p.^2 + spline_const(4)*p.^3;
end

% Plot setup
p_candidates = [p_s, p_val(end)];
[~,Imax] = max(abs(p_candidates));
num = 100;
p_line_full = linspace(-p_candidates(Imax), p_candidates(Imax),num);
p_line_spline = linspace(p_val(end-1),p_val(end), num);
color = ['r','b','g','k','m','r','b','g','k','m','r','b','g','k','m','r','b','g','k','m'];


% Real values
p_real = nan(num,1);
for ij= 1:length(p_line_full)
     p_real(ij) = gvalue_fem('variables', alpha_values_x * p_line_full(ij) + dp, probdata, rbdo_parameters,gfundata,nr, 0);
     hold on
end

% Plot 

% Spline
if p_val(end-1) ~= p_val(end)
    plot(p_line_spline,spline_val(p_line_spline),'MarkerSize',8,'Marker','none','Color', color(nr),'LineStyle','-','LineWidth',4)
    hold on
end

%point
plot(p_val, p_fun,'MarkerSize',8,'Marker','o','Color', color(nr),'LineStyle','none')
hold on
% Mpp
if no_cross == 0 
    hold on
    plot(p_s(end),0,'MarkerSize',4,'Marker','*','MarkerSize',20,'Color', color(nr))
end
%real value
plot(p_line_full,p_real,'LineWidth',2,'Color', color(nr),'LineStyle','--')

% if p_val(end-1) == p_val(end) 
%     legend('Experiments','MPP - estimate','Real value')
% elseif no_cross == 1
%     legend('Spline','Experiments','Real value')
% elseif no_cross == 0 
%     legend('Spline','Experiments','MPP - estimate','Real value')
% end
title(sprintf('Limitstate Nr:%d', nr))
%xlabel('p')
%ylabel('g(p)')
hold on
grid on