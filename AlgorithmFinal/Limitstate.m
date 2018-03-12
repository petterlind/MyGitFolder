classdef Limitstate
   properties
      conv = false;         %Converged or not.
      active = true;        % Active
      
      doe_x                 % Doe coordinates - in x-space
      doe_u                 % Doe coordinates - in u-space
      doe_val               % Corresponding values
      p_trial               % Linear estimate for probe point from DoE.
      p_x                   % pvalues
      p_val                 % p funtion values (based on probe points)
      probe_x               % probe coordinate in p-space
      probe_val             % probe function value
      
      alpha_p               % Steepest decent direction probabalistic para
      alpha_x               % Steepest decent direction probabalistic variables
      
      Mpp_p                 % Paramter set beta- away in u space in alpha p-dir.
      Mpp_x                 % Mpp estimate from probe
       
      func                  % Demands a function call
      expression            % expression for the limit state surface.
      
      target_beta           % target beta.
      
   end
%    methods
%    % Add a spline plot here, 
%    % Add a 
%    
% 
%    end 
end
%end