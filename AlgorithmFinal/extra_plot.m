
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

xy_probe = [3.4421 3.2860
3.4422 3.2857
3.4421 3.2860
3.4441 3.2845
3.4615 3.3068
3.6667 3.8390
5.0000 5.0000];

a_SAP = 100*ones(length(xy_SAP),1);
a_SLSV = 100*ones(length(xy_SLSV),1);
a_probe = 100*ones(length(xy_probe),1);

figure(1)
hold on
scatter(xy_probe(:,1),xy_probe(:,2), a_probe,'MarkerFaceColor','k','MarkerEdgeColor','k',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

scatter(xy_SAP(:,1),xy_SAP(:,2), a_SAP,'MarkerFaceColor','m','MarkerEdgeColor','m',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
hold on
scatter(xy_SLSV(:,1),xy_SLSV(:,2), a_SLSV,'MarkerFaceColor','c','MarkerEdgeColor','c',...
    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

%scatter(xy_probe(:,1),xy_probe(:,2), a_probe,'MarkerFaceColor','k','MarkerEdgeColor','k',...
%    'MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

%legend('G(X)_1','G(X)_2','G(X)_3','Location','northeastoutside')





