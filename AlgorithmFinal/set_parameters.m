% All common options for all files are set here so that they can run using
% the same options.



% Initiate settings and variables
if pdata.nx > 0 
    % Probabalistic design variables
    
    % Settings
    RBDO_s.roc_scale_down = 0.6; % Scale
    %RBDO_s.roc_scale_up
    
    RBDO_s.kappa_n = ones(max(pdata.nx, pdata.nd),1); % DoE
    RBDO_s.size_DoE = 0.1;
    %RBDO_s.DoE_size_p %FILL IN!
    
    % flags
    RBDO_s.f_one_probe = true;
    RBDO_s.f_RoC = true;
    RBDO_s.f_SRoC = true;
    RBDO_s.f_debug = true;
    RBDO_s.f_probe = true; 

    RBDO_s.f_corrector = false;
    RBDO_s.f_linprog = true; 
    RBDO_s.f_penal = false;

    RBDO_s.f_nominal_s = true;

    % Values
    Opt_set.roc_dist = 3.*pdata.marg(:,3)* min([LS.target_beta]); % three times smallest beta.
    [LS.DoE_size_x] = deal(ones(pdata.nx,1).* target_beta*RBDO_s.size_DoE);
    obj.DoE_size_x = ones(pdata.nx,1).*min([LS.target_beta])*RBDO_s.size_DoE; % for 

elseif pdata.nd > 0
    % Probabalistic parameters!
    
    Opt_set.roc_dist = nan; %trusses!!
    RBDO_s.DoE_size_d
   error('More code in set_parameters') 
end
    

% Failsafes
if pdata.nx > 0 && pdata.nd > 0
    error('More code needed in main.m!')
end


% Dummys
counter = 0;
obj.target_beta = 0;

% Common start values
[Opt_set.roc_dist, Opt_set.ML_scale, RBDO_s.kappa_n] = Update_RoC(RBDO_s, Opt_set);
Opt_set.ML_scale = ones(max(pdata.nx, pdata.nd),1);






