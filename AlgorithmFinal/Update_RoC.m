function [roc_dist, ML_scale, LS, kappa_n, Delta] = Update_RoC(RBDO_s, Opt_set, LS, Delta_old)


% DESIGN VARIABLES
Delta = Opt_set.delta_old .* Opt_set.delta;
index_short = Delta <= 0;
index_long =  Delta > 0 & Delta_old > 0; 

% lb check -> if 1, then ok!
lb = Opt_set.roc_dist > RBDO_s.roc_lb;
ub = Opt_set.roc_dist < RBDO_s.roc_ub;

% ub =...
kappa_n = RBDO_s.kappa_n;
roc_dist = Opt_set.roc_dist;

ML_scale = Opt_set.ML_scale;
ML_scale_n = Opt_set.ML_scale_n;

% Shrink
% ML_scale parameter, used with size of DoE.
ML_scale(index_short & lb) = ML_scale(index_short & lb )* RBDO_s.roc_scale_down;  

% Adapt distance to nominal point
if RBDO_s.f_nominal_s
    kappa_n(index_short & lb) = kappa_n(index_short & lb) * RBDO_s.roc_scale_down;
end

% Adapt size of ML-box
roc_dist(index_short & lb) = roc_dist(index_short & lb )* RBDO_s.roc_scale_down;

% Grow
% RBDO_s.roc_dist(index_long) = RBDO_s.roc_dist(index_long) * RBDO_s.roc_scale_up;

% ML_scale(index_long & ub) = ML_scale(index_long & ub )* RBDO_s.roc_scale_up;  

% Limitstate


% for all limitstate
if Opt_set.k >2
    for ii = 1:numel(LS)
        Delta_n = LS(ii).delta_old .* LS(ii).delta <=0;
        LS(ii).roc_dist_n(Delta_n & lb) = LS(ii).roc_dist_n(Delta_n & lb )* RBDO_s.roc_scale_down;
    end

    
end



