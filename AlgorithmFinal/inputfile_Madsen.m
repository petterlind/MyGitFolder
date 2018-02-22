clf
close all

% Note, this inputfile is ONLY used to demonstratate the pf-behaviour. I.e.
% the objective, bounds etc are just dummys to get the algorithm going.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'RBDO_FUNDATA' and 'RBDO_PARAMETERS'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rbdo_fundata.cost = {'-mu1-mu2' };     


rbdo_fundata.constraint = {   -1e9 * ones(7,1) ; 1e9.* ones(7,1) };                           
rbdo_fundata.mpp_constraint = rbdo_fundata.constraint;

rbdo_parameters.target_beta = 3.41; % Used only for DoE-scale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'PROBDATA'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Names of random variables. Default names are 'x1', 'x2', ..., if not explicitely defined.
probdata.name =  {};

% Marginal distributions for each random variable
% probdata.marg =  [ (type) (mean) (stdv) ];

probdata.marg =  [  1   0.01*1e6   0.003 *1e6;
                    1   0.30   0.015 ;
                    1   360*1e6 36*1e6
                    1   226*1e-6    11.3*1e-6
                    1   0.5 0.05
                    1   0.12    0.006
                    1   40*1e6  6*1e6];
               
probdata.stdv = diag(probdata.marg(:,3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'GFUNDATA' (one structure per gfun)  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gfundata(1).type       = 'Madsen';   % Do no change this field!

% Expression of the limit-state function:
gfundata(1).expression = {'(mu2 * mu3 * mu4 ) - ( mu3^2 * mu4^2 *mu5 )/(mu6* mu7) - mu1'};


gfundata(1).thetaf = { 'mu1' 'mu2' 'mu3' 'mu4' 'mu5' 'mu6' 'mu7'}; % Name of distribution design parameters

% dp
rbdo_parameters.design_point = U_space(probdata.marg(:,2), probdata.marg(:,2), probdata.marg(:,3)); % Should of course be zeros...

% Numbers 
rbdo_parameters.nx = numel(gfundata.thetaf); %Number of design variables
rbdo_parameters.np = 0;%Number of probabalistic parameters
rbdo_parameters.nc = 1; %Number of constraints
rbdo_parameters.variable = 1; % 1 if probabalistic variables

RBDO_settings.doe_scale = rbdo_parameters.target_beta/1e8; 
RBDO_settings.default_step_t = 10; % defult max step
RBDO_settings.scale_RoC = 100;
RBDO_settings.Roc = 100;
max_step = 	100;


%% Results

b_probe = 3.425;
pf_probe = cdf('Normal',-b_probe,0,1);

b_madsen = 3.41;
pf_madsen = cdf('Normal',-b_madsen,0,1);

%MC
%pf_MC = 3.8000e-04; % 1e5 runs
pf_MC = 3.3900e-04; % 1e6 runs

error_madsen = (pf_madsen-pf_MC) / pf_MC;
error_probe =  (pf_probe-pf_MC) / pf_MC;

%(pf_probe-pf_madsen)/pf_madsen