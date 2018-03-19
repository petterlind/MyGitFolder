%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'mu1','mu2'};

pdata.marg =  [  1   5   0.3 1;
                 1   5   0.3 1;
              ];
pdata.margp =  [];
          
pdata = set_numbers(pdata, pdata.marg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = [0; 0]; 
Opt_set.ub = [10; 10];
Opt_set.dp_x = [5;5];

if pdata.nx > 0
    Opt_set.dp_u = U_space(Opt_set.dp_x, pdata.marg(:,2), pdata.marg(:,3));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target_beta = 3; % 2, 3, 4!

obj = Limitstate;
obj.expression = {'mu1+mu2'};
obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;

G1 = Limitstate; G1.nr = 1;
G2 = Limitstate; G2.nr = 2;
G3 = Limitstate; G3.nr = 3;

G1.target_beta = target_beta;
G2.target_beta = G1.target_beta;
G3.target_beta = G2.target_beta;
obj.target_beta = G3.target_beta; % Scales the Roc, but its linear so size doesent matter.

G1.nominal_u = Opt_set.dp_u;
G2.nominal_u = Opt_set.dp_u;
G3.nominal_u = Opt_set.dp_u;

G1.nominal_x = Opt_set.dp_x; % First guess of Mpp....
G2.nominal_x = Opt_set.dp_x;
G3.nominal_x = Opt_set.dp_x;

G1.expression = {'mu1^2*mu2/20-1'};
G2.expression = {'(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1'};
G3.expression = {'80/(mu1^2+8*mu2+5)-1'};
LS = [G1, G2, G3];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'YounChoi';


RBDO_s.f_one_probe = true;
RBDO_s.f_RoC = false;
RBDO_s.f_debug = true;