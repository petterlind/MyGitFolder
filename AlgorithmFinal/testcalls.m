% TEST CALLS AND RETURNS!
%%
% plane_line_intersect

% 1 - simple case
% Returns, point!
DP0 = [0;0];
DP1 = [1;0];
point = [0.5;0];
n = [1;0];

xval = plane_line_intersect(DP0, DP1, point, n);

% 1.1 - simple higher dimension,
% point but scaled value
DP0 = [0;1;0;0];
DP1 = [1;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, n);

% 2 - simple case, negative normal
DP0 = [0;1;0;0];
DP1 = [1;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);

% 3 - simple case, negative and positive normal, close but no cigarr!
% Should return nan.
DP0 = [0;1;0;0];
DP1 = [0.4999999999999999;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);

% 4 - Miss - outside reach front and back

DP0 = [0;1;0;0];
DP1 = [-2;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);


% 5 - Just reaches the plane - No intersection!
DP0 = [0;1;0;0];
DP1 = [0.5;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);

% 6 - Starts on plane - goes away
DP1 = [0;1;0;0];
DP0 = [0.5;1;0;0];
point = [0.5;0;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);

% 7 - Parallel with plane - no intersection
DP0 = [4.9;10;0;0];
DP1 = [5.1;1;0;0];
point = [5;1;0;0];
n = [1;0;0;0];

xval = plane_line_intersect(DP0, DP1, point, -n);

%%
% Roc.m
% 1 - returns fives..
inpoint = 5*ones(pdata.nx,1);
dp_nom = 5*ones(pdata.nx,1);
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[]);

% 2 - returns Roc in 3-direction
 dp_nom = 5*ones(pdata.nx,1);
 inpoint = 5*ones(pdata.nx,1);
 inpoint(3) = 10;
 xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[]);
%Returns in three direction!
retur = 5 + RBDO_s.RoC_x*pdata.marg(3,3)*Opt_set.target_beta;

% 3- returns Roc in 1-direction, two planes
 dp_nom = 10*ones(pdata.nx,1);
 inpoint = 10*ones(pdata.nx,1);
 inpoint(1) = 10 + 3*pdata.marg(2,3)*Opt_set.target_beta* RBDO_s.RoC_x;
 inpoint(2) = 10 + 3*pdata.marg(2,3)*Opt_set.target_beta* RBDO_s.RoC_x;
 inpoint(3) = 10 + 10*pdata.marg(2,3)*Opt_set.target_beta* RBDO_s.RoC_x;
 xval = RoC(RBDO_s, pdata, Opt_set,inpoint, dp_nom,[]);
%Returns in three direction!

%4- plane close but not far enough away.
dp_nom = rand(pdata.nx,1)+ 1;
inpoint = dp_nom + 0.9*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[]);
%Returns inpoint!

% Above LOWER BOUND, directed inwards
% Should return - lb on first component
dp_nom = Opt_set.lb*1.1;
inpoint = dp_nom - 0.9*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[]);

% Lower than lower bound directed outwards - should return error
dp_nom = Opt_set.lb*0.9;
inpoint = dp_nom + 0.9*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[])

% To optimal
inpoint = 5*ones(pdata.nx,1)+ 0.9*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
dp_nom = 5*ones(pdata.nx,1);
dp_f = 5*ones(pdata.nx,1);
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,[]);

% To feasible
inpoint = 5*ones(pdata.nx,1)+ 2*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
dp_nom = 5*ones(pdata.nx,1);
dp_f = 5*ones(pdata.nx,1)+ 1*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,dp_f);

% not to feasible
inpoint = 5*ones(pdata.nx,1)+ 2*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
dp_nom = 5*ones(pdata.nx,1);
dp_f = 5*ones(pdata.nx,1)- 3*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,dp_f);

% not to optimal
inpoint =2*dp_f;
dp_nom = 5*ones(pdata.nx,1);
dp_f = 5*ones(pdata.nx,1)+ 0.5*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,dp_f);


% feasible -> lb
inpoint =2*dp_f;
dp_nom = 5*ones(pdata.nx,1);
dp_f = 5*ones(pdata.nx,1)-10*pdata.marg(:,3)*Opt_set.target_beta*RBDO_s.RoC_x;
xval = RoC(RBDO_s, pdata, Opt_set,inpoint,dp_nom,dp_f);

% nominal -> lb


