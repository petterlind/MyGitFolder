% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 8.25;
opts.height     = 6.25;
opts.fontType   = 'Times New Roman';
opts.fontSize   = 9;

% create new figure
fig = figure('DefaultTextFontName', opts.fontType, 'DefaultAxesFontName', opts.fontType); clf

g1 = @(mu1,mu2) mu1^2*mu2/20-1;
g2 = @(mu1,mu2)(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1;
g3 = @(mu1,mu2) 80/(mu1^2+8*mu2+5)-1;

intervall = [ 2 6 1.6 5.5];
levels = 0; 
levels2 = linspace(-0.3,0,100);

fc1 = fcontour(g1, intervall,'LineWidth',1,'HandleVisibility','off');
fc1.LevelList = levels; % Possibility to also show gradient here!
fc1.LineColor = 'red';
hold on

fc2 = fcontour(g2, intervall,'LineWidth',1,'HandleVisibility','off');
fc2.LevelList = levels; % Possibility to also show gradient here!
fc2.LineColor = 'blue';

hold on
fc3 = fcontour(g3, intervall,'LineWidth',1,'HandleVisibility','off');
fc3.LineColor = 'green';
fc3.LevelList = levels; % Possibility to also show gradient here!
hold on

xy_SAP = [
5.0 5.0
3.0017    3.0056
3.1574    3.8109
3.2958    3.4363
3.4083    3.2772
3.4256    3.2959];

xy_SLSV = [
3.4898 3.3292
3.4907 3.3298
3.4907 3.3298
3.4947 3.3327
3.4947 3.3327
3.5117 3.3461
3.5117 3.3461
3.5770 3.4087
3.5770 3.4087
3.7862 3.6378
3.7862 3.6378
4.3318 4.1754
4.3318 4.1754
5.0000 5.0000];

xy_probe = [    5.0000    5.0000
    3.6667    3.8390
    3.4446    3.2793
    3.4391    3.2862
    3.4390    3.2867
    3.4391    3.2864];

a_SAP = 100*ones(length(xy_SAP),1);
a_SLSV = 100*ones(length(xy_SLSV),1);
a_probe = 100*ones(length(xy_probe),1);

hold on
scatter(xy_probe(:,1),xy_probe(:,2), a_probe,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

scatter(xy_SAP(:,1),xy_SAP(:,2), a_SAP,'MarkerFaceColor','m','MarkerEdgeColor','m',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
hold on

scatter(xy_SLSV(:,1),xy_SLSV(:,2), a_SLSV,'MarkerFaceColor','c','MarkerEdgeColor','c',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

% add axis labes and legend
axis tight
xlabel('x_1')
ylabel('x_2')
legend('SLSVP','SLA','SLSV','Location','SouthEast')

text(2.1,2.7,'G_1=0','Color','red')
text(3.9,2.3,'G_2=0','Color','blue')
text(5.4,4.9,'G_3=0','Color','green')

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
%set(fig.Children, ...
%    'FontName',     'Times', ...
%    'FontSize',     9);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'Figure5'], '-dpng', '-r600')
close