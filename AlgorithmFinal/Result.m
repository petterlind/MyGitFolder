classdef Result
    properties
        s_conv = false      % Change of absolute step fulfilled, number of iterations.
        v_conv = false      % Change of relative value fulfilled, true/false
        c_conv = false
        s_nr        % Nr of experiments needed
        v_nr        % Nr of experiments needed
        c_nr
        s_obj       % Objective value   
        v_obj       % Objective value
        c_obj
        s_iter      % At what iteration
        v_iter      % At what iteration
        c_iter
        MC          % Mc result at every limitstate
        Max_iterations % Max number of iteration reached
   end
%    methods
%    end 
end
%end