clf
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'RBDO_FUNDATA' and 'RBDO_PARAMETERS'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                           % Cost function in the form: c_0 + c_f * p_f
rbdo_fundata.cost = {'mu1+mu2' };     

rbdo_fundata.constraint = {   -100                    % Deterministic constraints: [lower xi, upper xi]
                              -100
                              100
                              100
                          }; % in u-space!
                      
                      
 rbdo_fundata.mpp_constraint = rbdo_fundata.constraint;
                      
rbdo_parameters.target_beta = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'PROBDATA'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Names of random variables. Default names are 'x1', 'x2', ..., if not explicitely defined.
probdata.name =  {};

% Marginal distributions for each random variable
% probdata.marg =  [ (type) (mean) (stdv) ];

probdata.marg =  [  1   5   0.3;
                    1   5   0.3 ;
                   ];
               
probdata.stdv = diag(probdata.marg(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'GFUNDATA' (one structure per gfun)  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gfundata(1).type       = 'YounChoi';   % Do no change this field!

% Expression of the limit-state function:
gfundata(1).expression = {'mu1^2*mu2/20-1'
                          '(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1'
                          '80/(mu1^2+8*mu2+5)-1'};

gfundata(1).thetaf = { 'mu1' 'mu2' }; % Name of distribution design parameters

% dp

rbdo_parameters.design_point = U_space([ 5; 5], probdata.marg(:,2), probdata.marg(:,3)); % 7 cm^2, in m^2 

% Numbers 
rbdo_parameters.nx = numel(gfundata.thetaf); %Number of design variables
rbdo_parameters.np = 0;%Number of probabalistic parameters
rbdo_parameters.nc = 3; %Number of constraints
rbdo_parameters.variable = 1; % 1 if probabalistic variables


RBDO_settings.doe_scale = rbdo_parameters.target_beta/2; 
RBDO_settings.default_step_t = 10; % defult max step
RBDO_settings.scale_RoC = 100;
RBDO_settings.Roc = 100;
max_step = 	100;