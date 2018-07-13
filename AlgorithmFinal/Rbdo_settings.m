classdef Rbdo_settings
   properties
    
    % Input data
    name               % Name of the problem   
    convl              % Convergence criterium for the check step
    
    
    % Solver settings
    RoC_d             % minimum step size deterministic variables, absolute numbers
    RoC_x = 3;        % Minimum step size probibalistic variables, times \beta^T
    roc_scale_down         % Scale (shirnking) of the Roc-cube
    roc_scale_up           % Scale (growing= of the Roc_cube
    roc_lb              % lb for roc
    kappa_n             % vector, distance to nominal point in each direction.
    
    size_DoE            % Relative doe_size compared to beta, start value
    
     
    
    tol = 1e-3;
    max_k = 10000;
    max_l = 100;
    
    lb_probe         % Lowest probe point

    
    %Flags
    f_RoC = true;        % Step box constraint with move in feasible dir first!
    f_RoC_step = false;  % Step length constraint
    f_SRoC               % Scaling Roc!
    f_maxstep = 0;
    f_debug
    f_linprog
    f_COV = false;
    f_probe = true; % Runs probe algorithm
    f_penal         % penalization algorithm
    f_nominal_s         % shrinking distance to nominal point to prevent ocillation?

 end
end
