%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'A1','A2','A3','A4','A5','A6','A7','A8','A9','A10'};% P1 P2 sy

pdata.marg =  [  0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
                 0   6.452e-3   0 1;
              ];
          %      2  4.448e5     2.224e4 0;
          %      2  4.448e5     2.224e4 0;
          %      1  1.724e8     1.724e7 0;]
          
pdata = set_numbers(pdata, pdata.marg);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = [6.45e-8, 6.45e-8]; 
Opt_set.ub = [1.61e-3, 1.61e-3];
Opt_set.dp_x = [6.452e-3;6.452e-3];
Opt_set.dp_u = U_space(Opt_set.dp_x, pdata.marg(:,2), pdata.marg(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target_beta = 3;

obj = Limitstate;
obj.expression = {'9.144*(A1+A2+A3+A4+A5+A6) + sqrt(2)*9.144*(A8+A9+A10)'};
obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;

G1 = Limitstate; G1.nr = 1; % Displacement
G2 = Limitstate; G2.nr = 2; % Tension
G3 = Limitstate; G3.nr = 3; % Compression

G1.target_beta = target_beta;
G2.target_beta = G1.target_beta;
G3.target_beta = G2.target_beta;
obj.target_beta = G3.target_beta; % Scales the Roc, but its linear so size doesent matter.

G1.nominal_u = Opt_set.dp_u;
G2.nominal_u = Opt_set.dp_u;
G3.nominal_u = Opt_set.dp_u;

G1.nominal_x = Opt_set.dp_x; % First guess of Mpp
G2.nominal_x = Opt_set.dp_x;
G3.nominal_x = Opt_set.dp_x;

G1.func = {'[F, U] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2,0)'};
G2.func = {'[F, U] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2,0)'};
G3.func = {'[F, U] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2,0)'};

G1.expression = {'0.1143 - max(U(:,1))'}; % X OR Y DISPLACEMENT, SHOULD BE X!
G2.expression = {'sy - max(F./Avec)'};
G3.expression = {'sy- min(F./Avec)'};
LS = [G1, G2, G3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Cheng';
RBDO_s.f_one_probe = 1;
RBDO_s.f_debug = 1;