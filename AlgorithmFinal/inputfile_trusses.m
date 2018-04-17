%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10'};
pdata.name_p = {'F' ,'P' ,'sy', 'E'};

pdata.marg =  [  0  1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1];
              
% Conversion between in^2 and m^2
%pdata.marg(:,2) = optimum;
pdata.marg(:,2) = pdata.marg(:,2)*7e-4;

pdata.margp =  []; 
          
pdata = set_numbers(pdata, pdata.marg);
pdata.np = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = 0.7854e-4 *ones(10,1); % 0.001 in SAP! 0.1 in TANA
Opt_set.ub = 78.54e-4 *ones(10,1);

Opt_set.dp_x = pdata.marg(:,2);
%Opt_set.target_beta = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj = Limitstate; 
obj.expression = {'G = 0.1 * (360*2.54e-2*((A1+A2+A3+A4+A5+A6) + sqrt(2)*(A7+A8+A9+A10))) /(2.54e-2)^3;'}; % in lb!
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
G11 = Limitstate; G11.nr = 11;
G12 = Limitstate; G12.nr = 12;
G13 = Limitstate; G13.nr = 13;
G14 = Limitstate; G14.nr = 14;
G15 = Limitstate; G15.nr = 15;
G16 = Limitstate; G16.nr = 16;
G17 = Limitstate; G17.nr = 17;
G18 = Limitstate; G18.nr = 18;
G19 = Limitstate; G19.nr = 19;
G20 = Limitstate; G20.nr = 20;


G1.nominal_u = Opt_set.dp_u;G2.nominal_u = Opt_set.dp_u;G3.nominal_u = Opt_set.dp_u;
G4.nominal_u = Opt_set.dp_u;G5.nominal_u = Opt_set.dp_u;G6.nominal_u = Opt_set.dp_u;
G7.nominal_u = Opt_set.dp_u;G8.nominal_u = Opt_set.dp_u;G9.nominal_u = Opt_set.dp_u;
G10.nominal_u = Opt_set.dp_u;G11.nominal_u = Opt_set.dp_u;


% First guess of Mpp
G1.nominal_x = Opt_set.dp_x; G2.nominal_x = Opt_set.dp_x;G3.nominal_x = Opt_set.dp_x;
G4.nominal_x = Opt_set.dp_x; G5.nominal_x = Opt_set.dp_x;G6.nominal_x = Opt_set.dp_x;
G7.nominal_x = Opt_set.dp_x; G8.nominal_x = Opt_set.dp_x;G9.nominal_x = Opt_set.dp_x;
G10.nominal_x = Opt_set.dp_x; G11.nominal_x = Opt_set.dp_x; 
G11.nominal_x  = Opt_set.dp_x; 
G12.nominal_x = Opt_set.dp_x; 
G13.nominal_x = Opt_set.dp_x; 
G14.nominal_x = Opt_set.dp_x; 
G15.nominal_x = Opt_set.dp_x; 
G16.nominal_x = Opt_set.dp_x; 
G17.nominal_x = Opt_set.dp_x; 
G18.nominal_x = Opt_set.dp_x; 
G19.nominal_x = Opt_set.dp_x; 
G20.nominal_x = Opt_set.dp_x; 

 % Start Mpp_p guess
% G1.Mpp_p = pdata.margp(:,2);G2.Mpp_p = G1.Mpp_p;G3.Mpp_p = G1.Mpp_p;
% G4.Mpp_p = G1.Mpp_p;G5.Mpp_p = G1.Mpp_p;G6.Mpp_p = G1.Mpp_p;
% G7.Mpp_p = G1.Mpp_p;G8.Mpp_p = G1.Mpp_p;G9.Mpp_p = G1.Mpp_p;
% G10.Mpp_p = G1.Mpp_p;G11.Mpp_p = G1.Mpp_p;

G1.func = {'[F, U] = Aoues(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,20e3,15e3, 0);'};
G2.func = G1.func;G3.func = G1.func;G4.func = G1.func;G5.func = G1.func;
G6.func = G1.func;G7.func = G1.func;G8.func = G1.func;G9.func = G1.func;
G10.func = G1.func;G11.func = G1.func;
G11.func = G1.func;
G12.func = G1.func;
G13.func = G1.func;
G14.func = G1.func;
G15.func = G1.func;
G16.func = G1.func;
G17.func = G1.func;
G18.func = G1.func;
G19.func = G1.func;
G20.func = G1.func;



% 2 inch^2 in TANA!
 %G1.expression = {'G = 4.5*(2.54e-2) - max(max(abs(U(:,:))));'}; % X OR Y DISPLACEMENT, SHOULD BE X!
%G2.expression = {' G = 172.3689 - 1e-6*abs(max(F./[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10]));'};
%G3.expression = {' G = 172.3689 - 1e-6*(min(F./[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10]));'};
 G1.expression = {'G = 172.3689*1e6 - F(1)/A1;'};
G2.expression = {'G = 172.3689*1e6 - F(2)/A2;'};
G3.expression = {'G = 172.3689*1e6 - F(3)/A3;'};
G4.expression = {'G = 170.3689*1e6 - F(4)/A4;'};
G5.expression = {'G = 172.3689*1e6 - F(5)/A5;'};
G6.expression = {'G = 172.3689*1e6 - F(6)/A6;'};
G7.expression = {'G = 172.3689*1e6 - F(7)/A7;'};
G8.expression = {'G = 172.3689*1e6 - F(8)/A8;'};
G9.expression = {'G = 172.3689*1e6 - F(9)/A9;'};
G10.expression ={'G = 172.3689*1e6 - F(10)/A10;'};

G11.expression = {'G = (pi^2*68950*1e6*A1)/(12*3.048^2) + F(1)/A1;'};
G12.expression = {'G = (pi^2*68950*1e6*A2)/(12*3.048^2) + F(2)/A2;'};
G13.expression = {'G = (pi^2*68950*1e6*A3)/(12*3.048^2) + F(3)/A3;'};
G14.expression = {'G = (pi^2*68950*1e6*A4)/(12*3.048^2) + F(4)/A4;'};
G15.expression = {'G = (pi^2*68950*1e6*A5)/(12*3.048^2) + F(5)/A5;'};
G16.expression = {'G = (pi^2*68950*1e6*A6)/(12*3.048^2) + F(6)/A6;'};
G17.expression = {'G = (pi^2*68950*1e6*A7)/(24*3.048^2) + F(7)/A7;'};
G18.expression = {'G = (pi^2*68950*1e6*A8)/(24*3.048^2) + F(8)/A8;'};
G19.expression = {'G = (pi^2*68950*1e6*A9)/(24*3.048^2) + F(9)/A9;'};
G20.expression = {' G =(pi^2*68950*1e6*A10)/(24*3.048^2) + F(10)/A10;'};
 
 LS = [ G1, G2, G3, G4, G5, G6, G7, G8, G9, G10, G11, G11, G12, G13, G14, G15, G16, G17, G18, G19, G20];
%LS = [G1, G2, G3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Cheng';

RBDO_s.f_RoC = false;
RBDO_s.f_RoC_step = true;
RBDO_s.RoC_d = 5*(2.54e-2)^2; % Max deterministic update of dv.
RBDO_s.DoE_size_d = 0.01*(2.54e-2)^2; % 0.1 inch.
RBDO_s.f_debug = 1;
RBDO_s.f_one_probe = 1;

RBDO_s.f_probe = true; % Removes probe algorithm

RBDO_s.lb_probe = ones(10,1)*1e-12;

counter = 0;