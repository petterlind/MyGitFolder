function roc_dist = Update_RoC(RBDO_s, Opt_set,pdata)


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
    
    Delta = (Opt_set.delta_old + Opt_set.delta)./2;
    
    index_short = Delta <= 0;
    index_long =  Delta > 0;
    %index_different = sign(Opt_set.delta) ~= sign(Opt_set.delta_old);
    RBDO_s.roc_dist(index_short) = RBDO_s.roc_dist(index_short )* RBDO_s.roc_scale_down;
   % RBDO_s.roc_dist(index_long) = RBDO_s.roc_dist(index_long) * RBDO_s.roc_scale_up;
    roc_dist = RBDO_s.roc_dist;
    
    % Lower and upper value on Roc. ?!
    
    
    % Largest value of change
end





