classdef Probdata
   properties
    margd                % deterministic dv
    margx                % probibilistic dv
    margp                % probibilistic dp
    
    name_x
    name_p
    name_d
    nx                  % Number of design variables
    np                  % Number of probabalistic parameters
    nd                  % Numbers of determensitic variables
    
    stdv_x
    stdv_p
   end
    methods
     function obj = set_numbers(obj,marg)
         pos_nx = (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,4) == 1;
         pos_nd =  marg(:,1) == 0;
         pos_np = (marg(:,1) == 1 | marg(:,1) ==2) & marg(:,4) == 0;
         
         obj.name_x = obj.name(pos_nx);
         obj.name_p = obj.name(pos_np);
         
         obj.nd = sum( pos_nd & marg(:,4) == 1);
         obj.nx = sum( pos_nx & marg(:,4) == 1);
         obj.np = sum( pos_np & marg(:,4) == 0);
         
         obj.stdv_x = diag(marg(pos_nx, 3));
         obj.stdv_p = diag(marg(pos_np, 3));
         
         % Add correlation here aswell?!
     end
    end 
end
%end