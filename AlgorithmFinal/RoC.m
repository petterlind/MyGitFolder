function DP1 = RoC(RBDO_s, pdata, Opt_set, DP1, DP0, lbp, shift)
% DP0, nominal point
% DP1, New suggested point
% DPF, feasible point
% lbp, lower bound point

% DP1, new suggested point wrt move limits.

% Hypercube. check if change of variable in any direction is greater than
% allowed.

% 1) Input

% Shift it!
if isempty(shift)
    shift = zeros(numel(RBDO_s.roc_dist),1);
end

roc_dist = RBDO_s.roc_dist-shift;

if pdata.nx > 0 && pdata.nd > 0
    error('More code needed in RoC.m!') % and below aswell!
end

% 2) If it cuts a lb-plane or move-plane!
nrdv = length(roc_dist);
signs = ones(nrdv,1);
nr_vec = 1:nrdv;
RoC_p = diag(ones(nrdv,1));

% Check in what direction update towards feasible is for all points
index_move_neg = DP1 - DP0 < - roc_dist;
index_move_pos = DP1 - DP0 > roc_dist;
index_RoC = index_move_neg | index_move_pos;
signs(index_move_neg) = -1;
    
% Check in what direction update towards feasible is for all points
nr = nr_vec(index_RoC);

% 2) Check intersection - move limit
for ii = 1:sum(index_RoC)
    ind = nr(ii);
    sgn = signs(ind);

    n = sgn*RoC_p(:,ind); % normal RoC plane
    % Point on plane - movelimit
    if pdata.nx > 0
        point = DP0 + sgn*RoC_p(:,ind).*pdata.marg(nr(ii),3)*Opt_set.target_beta* roc_dist(ind); % point on plane
    elseif pdata.nd > 0
        point = DP0 + sgn*RoC_p(:,ind)* roc_dist(ind); % point on plane
    end
    
    % Lower bound!
    if DP1(ind) < lbp(ind)
        point = lbp;
    end
    

    % Inersection with movelimit plane
    sol_dp =  plane_line_intersect(DP0, DP1, point, n);

    % Check if closer than previous point.
    [~,I] = min([norm(DP0-DP1), norm(DP0-sol_dp)]);

    if I == 2 % New movelimit is on the line!
        DP1 = sol_dp;
    end
end
