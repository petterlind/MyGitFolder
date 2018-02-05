function plot_YounChoi(probdata, dp, x_s)

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
levels = linspace(-0.3,0,100);
fc1 = fcontour(g1, intervall);
fc1.LevelList = levels; % Possibility to also show gradient here!
hold on
fc2 = fcontour(g2, intervall);
fc2.LevelList = levels; % Possibility to also show gradient here!
hold on
fc3 = fcontour(g3, intervall);
fc3.LevelList = levels; % Possibility to also show gradient here!
colorbar

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
plot(dp(1),dp(2),'ok','MarkerSize', 10)
grid on
xlabel('u_1')
ylabel('u_2')
% title(sprintf('Linear, function evaluations: g=%d', Gnum))
% title(sprintf('tol_u = %d, tol_{theta} = %d, experiments: %d,iter: %d ',tolerance_conv ,tol_deg, Gnum, k))
% title('Horizion point method')

warning(orig_state);
