% All common options for all files are set here so that they can run using
% the same options.

% flags
RBDO_s.f_RoC = true; % Turnn ML on/off ?
RBDO_s.f_SRoC = true;
RBDO_s.f_debug = true;
RBDO_s.f_probe = true;  % TURN PROBE ON OFF!

RBDO_s.f_linprog = true;
RBDO_s.f_active = false; % Turn the active check on/off! FUNKAR EJ MED no_cross featuren! 
RBDO_s.f_penal = false;
RBDO_s.f_nominal_s = false; % no scale of distance to nominal point, not used in article 1!
RBDO_s.f_MC = false;

% Initiate settings and variables
RBDO_s.kappa_n = ones(max(pdata.nx, pdata.nd),1); % DoE
RBDO_s.roc_scale_down = 0.6; % Scale
RBDO_s.roc_scale_up = 1.6;
RBDO_s.size_DoE = 0.1;
RBDO_s.roc_ub = pdata.marg(:,2)*1;

if pdata.nx > 0 
    % Probabalistic design variables
    % Limitstate, set value for \beta target and size of doe
    if numel(target_beta) == 1 % One limitstate
        [LS.target_beta] = deal(target_beta);
        [LS.DoE_size_x] = deal(ones(pdata.nx,1).* target_beta*RBDO_s.size_DoE);
    elseif numel(target_beta) > 1 % Several limitstates
        for ii = 1:numel(target_beta)
            LS(ii).target_beta = target_beta(ii);
            LS(ii).DoE_size_x = ones(pdata.nx,1).* target_beta(ii)*RBDO_s.size_DoE;
        end
    end
    % Values
        extra_size = 3;
    warning('Extra size used!')
    Opt_set.roc_dist = 1.75*pdata.marg(:,3)* min([LS.target_beta])*extra_size; % three times smallest beta
    %RBDO_s.roc_lb = Opt_set.roc_dist*0.35; % FOR ABAQUS EXAMPLE
    RBDO_s.roc_lb = Opt_set.roc_dist*1e-2; % FOR ABAQUS EXAMPLE
    obj.DoE_size_x = ones(pdata.nx,1).*min([LS.target_beta])*RBDO_s.size_DoE*extra_size*22; % objective

elseif pdata.nd > 0
    % Probabalistic parameters!
    
    
    if strcmp(RBDO_s.name, 'Truss')  
        Opt_set.roc_dist = 10*ones(pdata.nd,1); % Chatenouf
    elseif strcmp(RBDO_s.name, 'Cheng') 
       Opt_set.roc_dist = ones(pdata.nd,1)*5*(2.54e-2)^2; % Cheng
    else
        error('unknown problem, cant set ML in set_parameters')
    end
    
    
    % Limitstate, set value for \beta target and size of doe
    if numel(target_beta) == 1 % One limitstate
        [LS.target_beta] = deal(target_beta);
        [LS.DoE_size_p] = deal(ones(pdata.np,1).*target_beta*RBDO_s.size_DoE);
    elseif numel(target_beta) > 1 % Several limitstates
        for ii = 1:numel(target_beta)
            LS(ii).target_beta = target_beta(ii);
            LS(ii).DoE_size_p = ones(pdata.np,1).* target_beta(ii)*RBDO_s.size_DoE;
        end
    end
end
obj.DoE_size_d = ones(pdata.nd,1).* 7e-4*0.5;  %objective 0.5 inch
    
% Failsafes
if pdata.nx > 0 && pdata.nd > 0
    error('More code needed in main.m!')
end

% Dummys
counter = 0;
obj.target_beta = 0;
[LS.beta_v] = deal(zeros(max(pdata.nx, pdata.nd),1));
theta = 110; % for the plot
Delta = zeros(size(Opt_set.delta_old));

% start
[LS.Mpp_x] = deal(Opt_set.dp_x); % start
[LS.Mpp_sx] = deal(Opt_set.dp_x); %start
[LS.nominal_x] = deal(Opt_set.dp_x); %start
[LS.roc_dist_n] = deal(Opt_set.roc_dist); % start value
Opt_set.dp_x_old = Opt_set.dp_x; % start 
Opt_set.dpl_x =  Opt_set.dp_x;
Opt_set.ob_val = ObjectiveFunction(Opt_set, obj, pdata);

% Common start values

[Opt_set.roc_dist, Opt_set.ML_scale, ~, RBDO_s.kappa_n, Delta] = Update_RoC(RBDO_s, Opt_set, LS, Delta);
Opt_set.ML_scale = ones(max(pdata.nx, pdata.nd),1);
Opt_set.ML_scale_n = Opt_set.ML_scale;

% Saving
Objective_v = nan(100,1);
%Objective_v(1) = ObjectiveFunction(Opt_set, obj, pdata);
p_tot = [];

% Class instance
Results = Result;
Results.dv = nan(100,numel(Opt_set.dp_x));
Results.obj = nan(100);
Results.con = nan(100,numel(LS));