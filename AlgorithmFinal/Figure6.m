% Jeong Park
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
Y = @(mu1,mu2)0.9063*mu1 + 0.4226*mu2 ;
Z = @(mu1,mu2)0.4226*mu1-0.9063*mu2 ;
g2 = @(mu1,mu2) -1*(-1+(Y(mu1,mu2)-6)^2+(Y(mu1,mu2)-6)^3-0.6*(Y(mu1,mu2)-6)^4+Z(mu1,mu2));
g3 = @(mu1,mu2) 80/(mu1^2+8*mu2+5)-1;

intervall = [ 3.5 7 0.5 3.5];
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


slsvcg = [5.198517017828201 0.7403079416531602
5.09637925445705 1.8685769854132905
4.835630470016207 1.9630275526742305
4.505954619124798 2.1565121555915723
4.707841166936791 2.0317925445705027
4.572411669367909 2.1259254457050245
4.613309562398704 2.1080777957860617
4.6388492706645055 2.080129659643436];

slsvp = [5.1969, 0.7405
4.1454, 1.9792
4.4797, 2.0131
4.1460, 2.2173
4.3519, 2.0925
3.7962, 2.5040
4.1461, 2.2451
4.3561, 2.0628
4.5660, 1.9343
4.5542, 1.9662
4.5286, 1.9817
4.4026, 2.0631
4.5286, 1.9788
4.4530, 2.1469
4.4299, 2.0435
4.4753, 2.0131
4.5025, 1.9969
4.5297, 1.9807
4.5532, 1.9670
4.5554, 1.9660
4.5584, 1.9643
4.5581, 1.9645
4.5580, 1.9645];

    

% slsv = [4.5610 2.2054
% 4.4944 2.2709
% 4.5636 2.2064
% 4.5127 2.2565
% 4.5678 2.2042
% 4.5303 2.2304
% 4.5448 2.1760
% 4.3794 2.2613
% 3.9781 2.6370
% 3.9739 2.1852
% 5.1969 0.7405];

a_slsvp = 100*ones(length(slsvp),1);
a_slsvcg = 100*ones(length(slsvcg),1);
%a_slsv = 100*ones(length(slsv),1);

figure(1)
hold on
scatter(slsvp(:,1),slsvp(:,2), a_slsvp,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

scatter(slsvcg(:,1),slsvcg(:,2), a_slsvcg,'MarkerFaceColor','m','MarkerEdgeColor','m',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
hold on
%scatter(slsv(:,1),slsv(:,2), a_slsv,'MarkerFaceColor','c','MarkerEdgeColor','c',...
%    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

legend('SLSVP','SLSVCG','SLSV')

% add axis labes and legend
axis tight
xlabel('x_1')
ylabel('x_2')
legend('SLSVP','SLA','SLSV','Location','NorthWest')

text(3.7,1,'G_1=0','Color','red')
text(6.2, 1.9,'G_2=0','Color','blue')
text(6.5, 3.2,'G_3=0','Color','green')
text(5.3, 0.9, 'Start point')

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
print([opts.saveFolder 'Figure6'], '-dpng', '-r600')
close