classdef Probdata
   properties
    marg                 %  [  distribuiton(0 - det, 1- normal, 2-lognormal) mean stdv  (0 - parameter, 1 - variable)]
    margp                % probibilistic dp
    
    name
    name_x
    name_p
    name_d
    nx                  % Number of design variables
    np                  % Number of probabalistic parameters
    nd                  % Numbers of determensitic variables
    
    cov
    stdv_x
    stdv_p
   end
    methods
     function obj = set_numbers(obj,marg)
         pos_nx = (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,4) == 1;
         pos_nd =  marg(:,1) == 0;
         pos_np = (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,4) == 0;
         
         obj.name_d = obj.name(pos_nd);
         obj.name_x = obj.name(pos_nx);
         
         obj.nd = sum( pos_nd & marg(:,4) == 1);
         obj.nx = sum( pos_nx & marg(:,4) == 1);
         
         obj.stdv_x = diag(marg(pos_nx, 3));
         if sum(pos_np) >0
             obj.stdv_p = diag(obj.margp(pos_np, 3));
         end
         
         
         % Add correlation here aswell?!
     end
    end 
end
%end