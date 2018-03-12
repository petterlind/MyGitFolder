classdef Probdata
   properties
    marg                % [distribution (0 1 2 - det, normal, log), type (0 1 - para, variable), mean, stdv]
    nx                  % Number of design variables
    np                  % Number of probabalistic parameters
    nd                  % Numbers of determensitic variables
      
   end
    methods
     function obj = set_numbers(obj,marg)
         obj.nd = sum( marg(:,1) == 0 & marg(:,2) == 1);
         obj.nx = sum( (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,2) == 1);
         obj.np = sum( (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,2) == 0);
        
         % Add correlation here aswell?!
     end
    end 
end
%end