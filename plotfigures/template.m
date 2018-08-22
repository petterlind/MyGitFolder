% define figure properties
opts.Colors     = get(groot,'defaultAxesColorOrder');
opts.saveFolder = 'img/';
opts.width      = 8.25;
opts.height     = 6.25;
opts.fontType   = 'Helvetica';
opts.fontSize   = 9;

% create new figure
fig = figure; clf



% plot sin-curves with the 7 standard colors
x = linspace(0, 2*pi, 1e3);
for i = 1:size(opts.Colors,1)
    h = plot(x, cos(x + (i-1)/8*pi)); hold on
end

% add axis labes and legend
axis tight
xlabel('x (rad)')
ylabel('sin(x)')
legend('1','2','3','4','5','6','7')

% scaling
fig.Units               = 'centimeters';
fig.Position(3)         = opts.width;
fig.Position(4)         = opts.height;

% set text properties
set(fig.Children, ...
    'FontName',     'Times', ...
    'FontSize',     9);

% remove unnecessary white space
set(gca,'LooseInset',max(get(gca,'TightInset'), 0.02))

% export to png
fig.PaperPositionMode   = 'auto';
print([opts.saveFolder 'my_figure'], '-dpng', '-r600')