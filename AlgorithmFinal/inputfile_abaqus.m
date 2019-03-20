%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'A1','A2','A3','A4','A5','A6','A7','A8','A9', 'A10'}; % 9 geometrical parameters
%pdata.name_p = [];

std = 1;
COV = 3e-2;
% Safe and sound?
% pdata.marg = pdata.marg =  [ 1   0.0326918391    std   1
%                 1   0.0336346301    std   1
%                 1   0.0299901466    std   1
%                 1   0.0631020498    std   1
%                 1   0.0469035559    std   1
%                 1   0.0398223024    std   1
%                 1   0.0313666988    std   1
%                 1   0.0174504461    std   1
%                 1   0.0220673939    std   1
%                 1   0.0318932882    std   1];


pdata.marg =  [ 1   0.0326918391    std   1
                1   0.0336346301    std   1
                1   0.0299901466    std   1
                1   0.0631020498    std   1
                1   0.0469035559    std   1
                1   0.0398223024    std   1
                1   0.0313666988    std   1
                1   0.0174504461    std   1
                1   0.0220673939    std   1
                1   0.0318932882    std   1];
pdata.marg(:,3)= pdata.marg(:,2)* COV; 
% pdata.marg(:,2) =  [ 0.015000000000000
%    0.015000000000000
%    0.015
%    0.055229027948214
%    0.081787471371301
%    0.072252655435077
%    0.041564291222424
%    0.010175467922903
%    0.006114948870005
%    0.007275878747169];

%mu = log(m/(sqrt(1+v/m^2)));
%sigma = sqrt(log(1+v/m^2));

pdata.margp =   [];
          
pdata = set_numbers(pdata, pdata.marg);
%pdata.np = numel(pdata.margp(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = pdata.marg(:,2)*0.2;
Opt_set.lb(1:7) = 0.015;
% Opt_set.lb(1) = 0.015; 
% Opt_set.lb(2) = 0.015; 
% Opt_set.lb(3) = 0.015; 
Opt_set.ub = pdata.marg(:,2)*3;

Opt_set.dp_x = pdata.marg(:,2);

%if pdata.nx > 0
%    Opt_set.dp_u = U_space(Opt_set.dp_x, pdata.marg(:,2), pdata.marg(:,3),pdata.marg(:,1));
%end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

target_beta = 3;

obj = Limitstate;

obj.expression = {'G = objfun([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10])'};

%obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;
%obj.Mpp_p = pdata.margp(:,2);


G1 = Limitstate; G1.nr = 1;  % Displacement
G2 = Limitstate; G2.nr = 2;  % Max/min stress

%G1.nominal_u = Opt_set.dp_u;G2.nominal_u = Opt_set.dp_u;

% First guess of Mpp
G1.nominal_x = Opt_set.dp_x; G2.nominal_x = Opt_set.dp_x;

% Start Mpp_p guess
%G1.Mpp_p = pdata.margp(:,2);G2.Mpp_p = G1.Mpp_p;

G1.func = {'[c, ceq] = nonl([A1,A2,A3,A4,A5,A6,A7,A8,A9,A10])'};
G2.func = G1.func;

G1.expression = {'G = c(1);'};
G2.expression = {'G = c(2);'};
LS = [G1, G2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Abaqus';
RBDO_s.lb_probe = Opt_set.lb*0.1;

RBDO_s.roc_lb = ones(10,1)*7e-3;

%[LS.DoE_size_d] = deal(ones(pdata.nd,1)*3*(2.54e-2)^2);
 

