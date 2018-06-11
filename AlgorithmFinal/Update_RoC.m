function [roc_dist, DoE_size_d, DoE_size_x ] = Update_RoC(RBDO_s, Opt_set,pdata)


if isnan(Opt_set.delta)

    if pdata.nd >0 % d - a deterministic measure,
        nrdv = pdata.nd;
        RBDO_s.roc_dist = RBDO_s.RoC_d;

    elseif pdata.nx >0  % x - based on beta.
        nrdv = pdata.nx;
        RBDO_s.roc_dist = RBDO_s.RoC_x.*pdata.marg(:,3)*Opt_set.target_beta;
    end
    
    roc_dist =  RBDO_s.roc_dist;
else
    
    %Delta = (Opt_set.delta_old + Opt_set.delta)./2;
    
    Delta = Opt_set.delta_old .* Opt_set.delta;
    
    index_short = Delta <= 0;
    index_long =  Delta > 0;
    
    % lb check -> if 1, then ok!
    lb = RBDO_s.roc_dist > RBDO_s.roc_lb;
    % ub =...
    
   roc_dist = RBDO_s.roc_dist;
   DoE_size_d = RBDO_s.DoE_size_d;
   DoE_size_x = RBDO_s.DoE_size_x;
   
   % Shrink
   roc_dist(index_short & lb)  = RBDO_s.roc_dist(index_short & lb)* RBDO_s.roc_scale_down;
   %DoE_size_x(index_short & lb) = RBDO_s.DoE_size_x(index_short & lb )* RBDO_s.roc_scale_down;
   if sum(pdata.nx) > 0 && sum(pdata.nd) == 0
        DoE_size_x(index_short & lb) = RBDO_s.DoE_size_x(index_short & lb )* RBDO_s.roc_scale_down;
   elseif sum(pdata.nd) > 0 && sum(pdata.nx) == 0
       DoE_size_d(index_short & lb) = RBDO_s.DoE_size_d(index_short & lb )* RBDO_s.roc_scale_down;
   elseif sum(pdata.nx) > 0 && sum(pdata.nd) > 0
       error('More code needed in Update_RoC')
   end
   
   % Grow
   % RBDO_s.roc_dist(index_long) = RBDO_s.roc_dist(index_long) * RBDO_s.roc_scale_up;
    end
end





