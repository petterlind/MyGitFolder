%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Probdata
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

pdata = Probdata; %Specify the class
pdata.name = {'A1','A2','A3','A4','A5'};
pdata.name_p = {'F' ,'P' ,'sy', 'E'};

pdata.marg =  [  0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 0   1   0 1
                 ];
              
pdata.marg(:,2) = pdata.marg(:,2)*7e-4;

pdata.margp =  [    2  20e3    0.3*20e3        0 20e3    0.3*20e3    
                    2  15e3    0.2*15e3        0 15e3    0.2*15e3    
                    2  172e6   0.15*172e6      0 172e6   0.15*172e6  
                    2  68950e6 0.1*68950e6     0 68950e6 0.1*68950e6 ]; 
          
pdata = set_numbers(pdata, pdata.marg);
pdata.np = numel(pdata.margp(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Optimizer settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Opt_set = Optimizer;
Opt_set.lb = 0.7854e-4 *ones(5,1); 
Opt_set.ub =  78.54e-4 * ones(5,1) * 100;

Opt_set.dp_x = pdata.marg(:,2);
target_beta = 3.719;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions, Obj and Limitstate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

obj = Limitstate; 
obj.expression = {'G = 3.048*((A1+A2+A3) + sqrt(2)*(A4+A5));'};
obj.nr = 0; 
%obj.nominal_u = Opt_set.dp_u;
obj.nominal_x = Opt_set.dp_x;
obj.Mpp_p = pdata.margp(:,2);

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
G1.Mpp_p = pdata.margp(:,2);G2.Mpp_p = G1.Mpp_p;G3.Mpp_p = G1.Mpp_p;
G4.Mpp_p = G1.Mpp_p;G5.Mpp_p = G1.Mpp_p;G6.Mpp_p = G1.Mpp_p;
G7.Mpp_p = G1.Mpp_p;G8.Mpp_p = G1.Mpp_p;G9.Mpp_p = G1.Mpp_p;
G10.Mpp_p = G1.Mpp_p;G11.Mpp_p = G1.Mpp_p;

%G1.func = {'[F, U] = Cheng5(A1,A2,A3,A4,A5,20e3,15e3,68950e6, 0);'};


G1.func = {'[F, U] = Cheng5(A1,A2,A3,A4,A5,F,P,E, 0);'};
%G1.func = {'[F, U] = Cheng5(A1,A2,A3,A4,A5,20e3,15e3 ,68950e6, 0);'};

G2.func = G1.func;G3.func = G1.func;G4.func = G1.func;G5.func = G1.func;
G6.func = G1.func;G7.func = G1.func;G8.func = G1.func;G9.func = G1.func;
G10.func = G1.func;G11.func = G1.func;

% Determenistic! 
%  G2.expression = {'F = F(1); G = 172.3689 - 1e-6*F/A1;'};
%  G3.expression = {'F = F(2); G = 172.3689 - 1e-6*F/A2;'};
%  G4.expression = {'F = F(3); G = 172.3689 - 1e-6*F/A3;'};
%  G5.expression = {'F = F(4); G = 170.3689 - 1e-6*F/A4;'};
%  G6.expression = {'F = F(5); G = 172.3689 - 1e-6*F/A5;'};
%  
%  G7.expression = {'F = F(1); I = A1^2/12 ;G = pi^2*6.895e10*I/3.048^2 + 1e-6*F/A1;'};
%  G8.expression = {'F = F(2); I = A2^2/12 ;G = pi^2*6.895e10*I/3.048^2 + 1e-6*F/A2;'};
%  G9.expression = {'F = F(3); I = A3^2/12 ;G = pi^2*6.895e10*I/3.048^2 + 1e-6*F/A3;'};
%  G10.expression = {'F = F(4); I = A4^2/12 ;G = pi^2*6.895e10*I/(2*3.048^2) + 1e-6*F/A4;'};
%  G11.expression = {'F = F(5); I = A5^2/12 ;G = pi^2*6.895e10*I/(2*3.048^2) + 1e-6*F/A5;'};
 
 G1.expression = {'F = F(1); G = 1e-6*(sy - F/A1);'};
 G2.expression = {'F = F(2); G = 1e-6*(sy - F/A2);'};
 G3.expression = {'F = F(3); G = 1e-6*(sy - F/A3);'};
 G4.expression = {'F = F(4); G = 1e-6*(sy - F/A4);'};
 G5.expression = {'F = F(5); G = 1e-6*(sy - F/A5);'};
 
 G6.expression = {'F = F(1); I = A1^2/(4*pi) ;G = 1e-6*(pi^2*E*I/3.048^2 + F/A1);'};
 G7.expression = {'F = F(2); I = A2^2/(4*pi) ;G = 1e-6*(pi^2*E*I/3.048^2 + F/A2);'};
 G8.expression = {'F = F(3); I = A3^2/(4*pi) ;G = 1e-6*(pi^2*E*I/3.048^2 + F/A3);'};
 G9.expression = {'F = F(4); I = A4^2/(4*pi) ;G = 1e-6*(pi^2*E*I/(2*3.048^2) + F/A4);'};
 G10.expression = {'F = F(5); I = A5^2/(4*pi) ;G = 1e-6*(pi^2*E*I/(2*3.048^2) + F/A5);'};
 
 % Rectangular
% I = A^2/12;
 %Circular
 %I = A^2/(4*pi);
 
 LS = [ G1, G2, G3, G4, G5, G6, G7, G8, G9, G10];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

RBDO_s = Rbdo_settings;
RBDO_s.name = 'Truss';

RBDO_s.roc_lb = 1e-5;
RBDO_s.lb_probe = Opt_set.lb; % x-space

[LS.DoE_size_d] = deal(ones(pdata.nd,1)* 0.5e-4); %0.5 cm^2 DoE to start with!
