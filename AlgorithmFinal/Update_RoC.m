function [roc_dist, ML_scale, kappa_n] = Update_RoC(RBDO_s, Opt_set)

Delta = Opt_set.delta_old .* Opt_set.delta;

index_short = Delta <= 0;
index_long =  Delta > 0; % CHANGE THIS THING!

% lb check -> if 1, then ok!
lb = Opt_set.roc_dist > RBDO_s.roc_lb;

% ub =...
roc_dist = Opt_set.roc_dist;
kappa_n = RBDO_s.kappa_n;
ML_scale = Opt_set.ML_scale;

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
end





