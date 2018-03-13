classdef Rbdo_settings
   properties
    
    % Input data
    name               % Name of the problem   
    convl              % Convergence criterium for the check step
    
    
    % Solver settings
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
    f_RoC = 0;
    f_maxstep = 0;
    f_debug
    f_linprog
    


    %flag_inner
   end
end
