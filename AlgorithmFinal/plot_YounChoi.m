function plot_YounChoi(probdata, dp, x_s,k)

% Supress warnings
orig_state = warning;
warning('off','all');


% x_s = nan(nc,Lnumber,nx); - For the record
sigma = probdata.marg(:,3);
        
figure(4)
hold on

% dp is in u-space!
dp_x = X_space([0;0] ,probdata.marg(:,2), sigma);

% Limitstate as function of u1 and u2.
g1 = @(u1,u2) (dp_x(2) + sigma(2)*u2) * (dp_x(1) + sigma(1)*u1).^2 / 20 - 1 ;
g2 = @(u1,u2) ((dp_x(1) + sigma(1)*u1) + (dp_x(2) + sigma(2)*u2) - 5 )^2 / 30 + ((dp_x(1) + sigma(1)*u1) - (dp_x(2) + sigma(2)*u2) - 12)^2 /120 -1;
g3 = @(u1,u2) 80 / ( (dp_x(1) + sigma(1)*u1).^2 + 8 * (dp_x(2) + sigma(2)*u2) + 5) -1;



intervall = [-10 4 -10 2];
levels = 0; %linspace(-0.3,0,100);
fc1 = fcontour(g1, intervall,'LineWidth',4);
fc1.LevelList = levels; % Possibility to also show gradient here!
fc1.LineColor = 'red';
hold on

fc2 = fcontour(g2, intervall,'LineWidth',4);
fc2.LevelList = levels; % Possibility to also show gradient here!
fc2.LineColor = 'blue';

hold on
fc3 = fcontour(g3, intervall,'LineWidth',4);
fc3.LineColor = 'green';
fc3.LevelList = levels; % Possibility to also show gradient here!

% plot the old MPP:s
hold on

l1 = mysqueeze( x_s(1,:,:)); %B4
l2 = mysqueeze( x_s(2,:,:));
l3 = mysqueeze( x_s(3,:,:));

plot(l1(:,1),l1(:,2),'r*', 'MarkerSize',20)
hold on
plot(l2(:,1),l2(:,2),'b*', 'MarkerSize',20)
hold on
plot(l3(:,1),l3(:,2),'g*', 'MarkerSize',20)

legend('g(u)_1','g(u)_2','g(u)_3','Location','northeastoutside')

% plot points
plot(dp(1),dp(2),'ok','MarkerSize', 10,'MarkerFaceColor','k')
grid on
xlabel('u_1')
ylabel('u_2')

%Plot numbers close to points.
if k < 4
 text(dp(1)-0.5,dp(2)+0.5,num2str(k-1))
elseif k == 4
    text(dp(1)+0.1,dp(2)+0.5,num2str(k-1))
    
elseif k == 5
    text(dp(1)+0.1,dp(2)-0.5,num2str(k-1))
else
    warning('more numbers?! in plot_YounChoi.m?')
end


% Plot loop-result
load LoopYounChoiRes175.mat
u_div = length(u1_vec);

X = ones(u_div,u_div).* u1_vec';
Y = ones(u_div,u_div).* u2_vec;

contour(X,Y,Loop_res, [23, 25, 26, 33, 43, 53, 54, 55, 56, 63, 64], 'ShowText','on')
%contourf(X,Y,Loop_res, [23, 25, 26, 33, 43, 53, 54, 55, 56, 63, 64],
%'ShowText','on') filled!

% title(sprintf('Linear, function evaluations: g=%d', Gnum))
% title(sprintf('tol_u = %d, tol_{theta} = %d, experiments: %d,iter: %d ',tolerance_conv ,tol_deg, Gnum, k))
% title('Horizion point method')

warning(orig_state);
