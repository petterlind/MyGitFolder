%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'A1','A2','A3'};
pdata.name_p = {'P1' ,'P2' ,'sy'};

%OPTIMAL VALUES

pdata.marg =  [  0  10    0 1
                 0   10   0 1
                 0   10   0 1 ];
              
% Conversion between in^2 and m^2
%pdata.marg(:,2) = optimum;
pdata.marg(:,2) = pdata.marg(:,2)*(2.54e-2)^2;

pdata.margp =  []; 
          
pdata = set_numbers(pdata, pdata.marg);
pdata.np = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = 0.001 *ones(3,1).* (2.54e-2)^2; % 0.1 in TANA! 
Opt_set.ub = [1.61, 1.61, 1.61 ].*100; % REALLY BIG! = no limit

Opt_set.dp_x = pdata.marg(:,2);
%Opt_set.target_beta = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj = Limitstate; 
obj.expression = {'G = 0.1 * (360*2.54e-2*((A1+A3) + sqrt(2)*(A2))) /(2.54e-2)^3;'}; % in lb!
obj.nr = 0; 
obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;
%obj.Mpp_p = pdata.margp(:,2);

G1 = Limitstate; G1.nr = 1;  % Displacement
G2 = Limitstate; G2.nr = 2; 
G3 = Limitstate; G3.nr = 3; 
G4 = Limitstate; G4.nr = 4; 
G5 = Limitstate; G5.nr = 5; 
G6 = Limitstate; G6.nr = 6; 
G7 = Limitstate; G7.nr = 7; 
G8 = Limitstate; G8.nr = 8; 
G9 = Limitstate; G9.nr = 9; 
G10 = Limitstate; G10.nr = 10; 
G11 = Limitstate; G11.nr = 11; % Max/min stress

G1.nominal_u = Opt_set.dp_u;G2.nominal_u = Opt_set.dp_u;G3.nominal_u = Opt_set.dp_u;
G4.nominal_u = Opt_set.dp_u;G5.nominal_u = Opt_set.dp_u;G6.nominal_u = Opt_set.dp_u;
G7.nominal_u = Opt_set.dp_u;G8.nominal_u = Opt_set.dp_u;G9.nominal_u = Opt_set.dp_u;
G10.nominal_u = Opt_set.dp_u;G11.nominal_u = Opt_set.dp_u;

% First guess of Mpp
G1.nominal_x = Opt_set.dp_x; G2.nominal_x = Opt_set.dp_x;G3.nominal_x = Opt_set.dp_x;
G4.nominal_x = Opt_set.dp_x; G5.nominal_x = Opt_set.dp_x;G6.nominal_x = Opt_set.dp_x;
G7.nominal_x = Opt_set.dp_x; G8.nominal_x = Opt_set.dp_x;G9.nominal_x = Opt_set.dp_x;
G10.nominal_x = Opt_set.dp_x; G11.nominal_x = Opt_set.dp_x; 

 % Start Mpp_p guess
% G1.Mpp_p = pdata.margp(:,2);G2.Mpp_p = G1.Mpp_p;G3.Mpp_p = G1.Mpp_p;
% G4.Mpp_p = G1.Mpp_p;G5.Mpp_p = G1.Mpp_p;G6.Mpp_p = G1.Mpp_p;
% G7.Mpp_p = G1.Mpp_p;G8.Mpp_p = G1.Mpp_p;G9.Mpp_p = G1.Mpp_p;
% G10.Mpp_p = G1.Mpp_p;G11.Mpp_p = G1.Mpp_p;

G1.func = {'[F, U] = Cheng3(A1,A2,A3,4.4482e5, 0);'};
G2.func = G1.func;G3.func = G1.func;G4.func = G1.func;G5.func = G1.func;
G6.func = G1.func;G7.func = G1.func;G8.func = G1.func;G9.func = G1.func;
G10.func = G1.func;G11.func = G1.func;


% 2 inch^2 in TANA!
G1.expression = {'G = 4.5*(2.54e-2) - max(abs(U(1,:)));'}; % X OR Y DISPLACEMENT, SHOULD BE X!
G2.expression = {' G = 172.3689e6 - abs(max(F./[A1, A2, A3]));'};
G3.expression = {' G = 172.3689e6 - abs(min(F./[A1, A2, A3]));'};
%  G2.expression = {'F = abs(F(1)); G = 172.3689 - 1e-6*F/A1;'};
%  G3.expression = {'F = abs(F(2)); G = 172.3689 - 1e-6*F/A2;'};
%  G4.expression = {'F = abs(F(3)); G = 172.3689 - 1e-6*F/A3;'};
%  G5.expression = {'F = abs(F(4)); G = 170.3689 - 1e-6*F/A4;'};
%  G6.expression = {'F = abs(F(5)); G = 172.3689 - 1e-6*F/A5;'};
%  G7.expression = {'F = abs(F(6)); G = 172.3689 - 1e-6*F/A6;'};
%  G8.expression = {'F = abs(F(7)); G = 172.3689 - 1e-6*F/A7;'};
%  G9.expression = {'F = abs(F(8)); G = 172.3689 - 1e-6*F/A8;'};
%  G10.expression = {'F = abs(F(9)); G = 172.3689 - 1e-6*F/A9;'};
%  G11.expression = {'F = abs(F(10)); G = 172.3689 - 1e-6*F/A10;'};
%  LS = [G1, G2, G3, G4, G5, G6, G7, G8, G9, G10, G11];
LS = [G1, G2, G3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Cheng';

RBDO_s.f_RoC = true;
RBDO_s.f_RoC_step = false;
RBDO_s.f_SRoC = true;
RBDO_s.roc_scale_down = 0.99;
RBDO_s.roc_scale_up = 1.2;

RBDO_s.RoC_d = 4*(2.54e-2)^2 .*ones(pdata.nd,1);
RBDO_s.DoE_size_d = 0.01*(2.54e-2)^2; % 0.1 inch.
RBDO_s.f_debug = 1;
RBDO_s.f_one_probe = 1;

RBDO_s.f_probe = false; % Removes probe algorithm
RBDO_s.lb_probe = Opt_set.lb*1e-2;

RBDO_s.f_linprog = true; 
RBDO_s.f_penal = false;
counter = 0;
Corr = nan;