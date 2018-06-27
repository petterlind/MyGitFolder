
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'mu1','mu2'};

pdata.marg =  [  1   5.1969  0.3 1
                 1   0.7405   0.3 1
              ];
          
pdata.margp =  [];
          
pdata = set_numbers(pdata, pdata.marg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = [0; 0];

Opt_set.ub = [10; 10];
Opt_set.dp_x = pdata.marg(:,2);

target_beta = 3.5;

if pdata.nx > 0
    Opt_set.dp_u = U_space(Opt_set.dp_x, pdata.marg(:,2), pdata.marg(:,3), pdata.marg(:,1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%W

obj = Limitstate;
obj.expression  = {'G = -(mu1+mu2-10)^2/30-(mu1-mu2+10)^2/120;'}; 
obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;
obj.nr=0;

G1 = Limitstate; G1.nr = 1;
G2 = Limitstate; G2.nr = 2;
G3 = Limitstate; G3.nr = 3;

G1.nominal_u = Opt_set.dp_u;
G2.nominal_u = Opt_set.dp_u;
G3.nominal_u = Opt_set.dp_u;

G1.nominal_x = Opt_set.dp_x; % First guess of Mpp....
G2.nominal_x = Opt_set.dp_x;
G3.nominal_x = Opt_set.dp_x;

G1.expression = {'G = mu1^2*mu2/20-1;'};
G2.expression = {'Y=0.9063*mu1 + 0.4226*mu2 ;Z=0.4226*mu1-0.9063*mu2 ;G = -1*(-1+(Y-6)^2+(Y-6)^3-0.6*(Y-6)^4+Z);'};
G3.expression = {'G = 80/(mu1^2+8*mu2+5)-1;'};
LS = [G1, G2, G3];
[LS.beta_v] = deal(zeros(pdata.nx,1));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Jeong_Park';

RBDO_s.roc_lb = 1e-10;
RBDO_s.lb_probe = Opt_set.lb; % x-space