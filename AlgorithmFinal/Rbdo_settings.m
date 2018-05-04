classdef Rbdo_settings
   properties
    
    % Input data
    name               % Name of the problem   
    convl              % Convergence criterium for the check step
    
    
    % Solver settings
    RoC_d             % minimum step size deterministic variables, absolute numbers
    RoC_x = 3;        % Minimum step size probibalistic variables, times \beta^T
    
    DoE_size_x      % DoE size in u-space
    DoE_size_d      % DoE size in x-space ( deterministic variables)
    tol = 1e-3;
    max_k = 10000;
    max_l = 100;
    
    lb_probe         % Lowest probe point

    
    %Flags
    f_one_probe
    f_RoC = true;        % Step box constraint with move in feasible dir first!
    f_RoC_step = false;  % Step length constraint
    f_maxstep = 0;
    f_debug
    f_linprog
    f_COV = false;
    f_probe = true; % Runs probe algorithm
    f_corrector
    f_penal         % penalization algorithm

 end
end
