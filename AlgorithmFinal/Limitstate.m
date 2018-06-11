classdef Limitstate
   properties
      conv = false;         %Converged or not.
      active = true;        % Active
      nr                    % number.
      
      DoE_size_x            % DoE size in u-space
      
      nominal_x             % Nominal x (DP)
      nominal_x_old
      nominal_u
      nominal_val           % Nominal value (at DP)
      nominal_val_old
      lambda  =0 % dummy    % Direction orthogonal to alpha towards new nominal point
      
      doe_x                 % Doe coordinates - in x-space
      doe_u                 % Doe coordinates - in u-space
      doe_val               % Corresponding values
      
      slope
      x_trial               % Point in steapest decent where g = 0
      p_trial               % Linear estimate for probe point from DoE.
      p_x                   % pvalues
      p_val                 % p funtion values (based on probe points)
      probe_p               % probe coordinate in p-space - x-space! from nominal!
      probe_val             % probe function value
      probe_s               % probe Mpp estimate
      probe_x_pos           % Position of probe in x-space!
      
      spline                % Spline constants
      c = 0;                    % penalize constant
      
      alpha_p               % Steepest decent direction probabalistic para
      alpha_x               % Steepest decent direction probabalistic variables
      alpha_x_old           % Old -- || --
      beta_v = 0
      
      target_beta
      
      Mpp_p                 % Paramter set beta- away in u space in alpha p-dir.
      Mpp_x                 % Mpp estimate from probe
      Mpp_sx                % Shifted Mpp for dv
      Mpp_x_old             % Old Mpp LS.
      Mpp_u                 % Mpp estimate from probe, u-space
      
      
      no_cross = 0;
       
      func                  % Demands a function call
      expression            % expression for the limit state surface.
      
      
   end
%    methods
%    % Add a spline plot here, 
%    % Add a 
%    
% 
%    end 
end
%end