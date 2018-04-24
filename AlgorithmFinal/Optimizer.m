classdef Optimizer
   properties
       % Outer loop
        dp_x               % Design point in x-space
        dp_u               % Design point in u-space
 
        dp_x_old           % Old design point in x-space
        dp_u_old           % Old design point in u-space
        
        target_beta         % target beta
        
        ob_val             % Objective function value
        ob_val_old = nan   % Old objective function value
        
        % Inner loop
        dpl_x = nan;
        dpl_xc            % Corrected step
        dpl_u = nan;

        dpl_x_old
        dpl_u_old
        
        lb
        ub
        RoC                % Something that enforces some kind of move-limit.
        inner_conv = 1;
        outer_conv = 1;
        
        l = nan;
        k = 0;
        
      
   end
%    methods
%    % Add a spline plot here, 
%    % Add a 
%    
% 
%    end 
end
%end