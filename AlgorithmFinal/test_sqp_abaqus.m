
% X0.
h1 = 0.04;
h2 = 0.04;
h3 = 0.04;
h4 = 0.04;

% Cross section widths
w0 = 0.06; % Beginning of shaft
w1 = 0.04; %
w2 = 0.04; %
w3 = 0.04; % Last free cross section.
w4 = 0.04;

% Cross section distances
l1 = 0.01;
l2 = 0.02;
l3 = 0.03;
l4 = 0.04;

smax = 400e6;
dmax = 2e-3;

Geom = [h1, h2, h3, w0, w1, w2, w3, l1, l2, l3];
x0 = Geom;

opts = optimoptions(@fmincon,'Algorithm','sqp','Display','off', 'DiffMinChange', 8e-5);
tic
[x,fval,exitflag,output] = runobjconstr(x0, smax, dmax, opts);
toc

% STOP


figure(1)
plot(1:10, G_vec(:,1), '--or')
title('Stress')

figure(2)
plot(1:10, G_vec(:,2),'--or')
title('Disp')
