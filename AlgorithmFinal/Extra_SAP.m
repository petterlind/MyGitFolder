extra_plot

xy_SAP = [
    4.9913    4.9906
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

figure(1)
plot(xy_SAP(:,1),xy_SAP(:,2),'ok','MarkerSize', 10,'MarkerFaceColor',[0.5 0.5 0.5], 'MarkerEdgeColor','[0.5 0.5 0.5]','MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)

hold on
plot(xy_SAP(:,1),xy_SAP(:,2),'ok','MarkerSize', 10,'MarkerFaceColor',[0.7 0.7 0.7], 'MarkerEdgeColor','[0.5 0.5 0.5]','MarkerFaceAlpha',.2,'MarkerEdgeAlpha',.2)
