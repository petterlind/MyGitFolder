
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'RBDO_FUNDATA' and 'RBDO_PARAMETERS'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nr_of_trusses == 5
   
    rbdo_fundata.cost = {'3.048*(mu2+mu1+mu5) + sqrt(2)*3.048*(mu3+mu4)' }; 
    rbdo_parameters.design_variable = {  'mu1' 'mu2' 'mu3' 'mu4' 'mu5'};
 
elseif nr_of_trusses == 10
    
    rbdo_fundata.cost = {'3.048*(mu2+mu1+mu5+mu6+mu7+mu10) + sqrt(2)*3.048*(mu3+mu4+mu8+mu9)' }; 
    rbdo_parameters.design_variable = {  'mu1' 'mu2' 'mu3' 'mu4' 'mu5' 'mu6' 'mu7' 'mu8' 'mu9' 'mu10'};

elseif nr_of_trusses == 15
    
    rbdo_fundata.cost = {'3.048*(mu2+mu1+mu5+mu6+mu7+mu10+mu11+mu12+mu15) + sqrt(2)*3.048*(mu3+mu4+mu8+mu9+mu13+mu14)' }; 
    rbdo_parameters.design_variable = {  'mu1' 'mu2' 'mu3' 'mu4' 'mu5' 'mu6' 'mu7' 'mu8' 'mu9' 'mu10' 'mu11' 'mu12' 'mu13' 'mu14' 'mu15'};

else
    warning('Number of trusses do not match with any structure')
end


rbdo_fundata.constraint = {   0.7854e-4.* ones(nr_of_trusses,1) ; 78.54e-4.* ones(nr_of_trusses,1) };                           
rbdo_fundata.mpp_constraint = { 1e-7 * ones(nr_of_trusses,1) ; 1* ones(nr_of_trusses,1) };
rbdo_parameters.target_beta = 3.719;
rbdo_parameters.design_point =  7e-4.* ones(nr_of_trusses,1); % 7cm^2..

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'PROBDATA'  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Names of random variables. Default names are 'x1', 'x2', ..., if not explicitely defined.
probdata.name =  { 'f_yt'
                   'E'
                   'F'
                   'P'
                   };

% Marginal distributions for each random variable
% probdata.marg =  [ (type) (mean) (stdv) ];

probdata.marg =  [  1   172*1e6 172*1e6*0.15 ;
                    1   68950*1e6 68950*1e6*0.1 ;   
                    1   20*1e3  20*1e3*0.3 ;
                    1   15*1e3  15*1e3*0.2 ;
                   ];
               
               

% Correlation matrix
probdata.correlation = eye(2);
probdata.stdv = diag(probdata.marg(:,3));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  DATA FIELDS IN 'GFUNDATA' (one structure per gfun)  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gfundata(1).type       = 'TRUSS'; 

%Circular
gfundata(1).expression = {      'f_yt*A - Ft'
                                '(pi^2*E*A^2)/(12*3.048^2)+ Ft'
                                '(pi^2*E*A^2)/(24*3.048^2)+ Ft'};

gfundata(1).thetaf = rbdo_parameters.design_variable;

% Numbers 
rbdo_parameters.nx = numel(gfundata.thetaf); %Number of design variables
rbdo_parameters.np = numel(probdata.marg(:,2));%Number of probabalistic parameters
rbdo_parameters.nc = rbdo_parameters.nx; %Number of constraints

rbdo_parameters.variable = 0; % 1 if probabalistic variables

probdata.p_star = probdata.marg(:,2).* ones(rbdo_parameters.np,rbdo_parameters.nc);


% Algorithm settings 
 RBDO_settings.doe_scale = 3e-3;%1e-3; %1e-4
% RBDO_settings.tol_non_linear = 0.5; %0.1 was too low?!
% RBDO_settings.tol = 1e-3;
RBDO_settings.default_step_t = 1;
RBDO_settings.scale_RoC = 100;
RBDO_settings.Roc = 7e-3;
max_step = 	10e-3; %8e-3; %3e-3;