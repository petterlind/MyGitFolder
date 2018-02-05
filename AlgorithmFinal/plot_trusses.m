function plot_trusses(dp, probdata, rbdo_parameters, gfundata, flag, nx,k, dp_plot, dp_color)


% Plot the structure
figure(4)
gvalue_fem('variables', dp, probdata, rbdo_parameters, gfundata, 1,0, flag.debug);


figure(5) %A5
hold off
for ii = 1:k
    plotvar = dp_plot(:,ii);
    scatter(ii*ones(sum(dp_color(:,ii) == 1 ),1), plotvar(dp_color(:,ii) == 1 ),'go')
    hold on
    scatter(ii*ones(sum(dp_color(:,ii) == -1 ),1),plotvar(dp_color(:,ii) == -1 ),'ro')
    hold on
end

for ij = 1:nx
    hold on
    plot(dp_plot(ij,:),'-k')
    hold on
    text(k+0.05,dp_plot(ij,k),num2str(ij))
end
grid on
xlabel('Iteration number [-]')
ylabel('Design variable value [m^2]')