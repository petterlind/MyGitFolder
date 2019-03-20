classdef Limitstate
   properties
      conv = false;         %Converged or not.
      active = true;        % Active
      nr                    % number.
      
      DoE_size_d            % DoE size in x-space ( deterministic variables)
      DoE_size_x            % DoE size in u-space for prob var.
      DoE_size_p            % DoE size in u-space for parameters
      
      nominal_x             % Nominal x (DP)
      nominal_x_old
      nominal_x_v             % vector from dp to nominal value
      nominal_x_v_old
      nominal_u
      nominal_val           % Nominal value (at DP)
      nominal_val_old
      lambda                % Direction towards MPP estimate in x-space
      
      doe_x                 % Doe coordinates - in x-space
      doe_u                 % Doe coordinates - in u-space
      doe_val               % Corresponding values
      delta                 % used for move limit
      delta_old             % used for move limit
      
      slope
      x_trial               % Point in stepest descent where g = 0, x-space
      u_trial               % Point in stepest descent where g = 0, u-space
      p_trial               % Linear estimate for probe point from DoE.
      p_u                   % pvalues in u-space
      p_x                   % pvalues in x-space for deterministic dv.
      p_val                 % p funtion values (based on probe points)
      probe_p               % probe coordinate in p-space - x-space! from nominal!
      probe_val             % probe function value
      probe_s               % probe Mpp estimate
      probe_x_pos           % Position of probe in x-space!
      
      roc_dist_n            % move limit, limitstate, x-space.
      
      spline                % Spline constants
      c = 0;                    % penalize constant
      
      alpha_p               % Steepest decent direction probabalistic para
      alpha_x               % Steepest decent direction probabalistic variables
      alpha_u
      alpha_x_old           % Old -- || --
      beta_v = 0
      
      target_beta
      
      Mpp_p                 % Parameter set beta- away in u space in alpha p-dir.
      Mpp_x                 % Mpp estimate from probe
      Mpp_sx                % Shifted Mpp for dv
      Mpp_x_old             % Old Mpp LS.
      Mpp_ud = [];                % Distance to Mpp in u-space, dummy value
      Mpp_ud_old =[];           % Distance to Mpp in u-space old, dummy value
      
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