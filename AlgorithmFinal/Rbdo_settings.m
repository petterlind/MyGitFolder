classdef Rbdo_settings
   properties
    
    % Input data
    name               % Name of the problem   
    convl              % Convergence criterium for the check step
    
    
    % Solver settings
    det_step
    RoC_d           % minimum step size deterministic variables, absolute numbers
    RoC_x = 3;        % Minimum step size probibalistic variables, times \beta^T
    tol = 1e-3;
    max_k = 10;
    max_l = 20;
    doe_scale 
    default_step_t 
    scale_RoC 
    Roc 
    max_step
    
    %Flags
    f_one_probe
    f_RoC = true;
    f_maxstep = 0;
    f_debug
    f_linprog

   end
end
