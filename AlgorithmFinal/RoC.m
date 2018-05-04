function DP1 = RoC(RBDO_s, pdata, Opt_set, DP1, DP0, DPF, lbp)
% DP0, nominal point
% DP1, New suggested point
% DPF, feasible point

% dp_RoC, new suggested point wrt move limits.

% Hypercube. check if change of variable in any direction is greater than
% allowed.

if isempty(DPF)
    DPF = DP1;
    f_DPF = false;
else
    f_DPF = true;
end

% 1) Input
if pdata.nd >0 % d - a deterministic measure,
    nrdv = pdata.nd;
    roc_dist = RBDO_s.RoC_d;

elseif pdata.nx >0  % x - based on beta.
    nrdv = pdata.nx;
    roc_dist = RBDO_s.RoC_x*pdata.marg(:,3)*Opt_set.target_beta;
end

if pdata.nx > 0 && pdata.nd > 0
    error('More code needed in RoC.m!') % and below aswell!
end


% 2) If it cuts a lb-plane or move-plane!
signs = ones(nrdv,1);
nr_vec = 1:nrdv;
RoC_p = diag(ones(nrdv,1));

% Check in what direction update towards feasible is for all points
index_move_neg = DPF - DP0 < - roc_dist;
index_move_pos = DPF - DP0 > roc_dist;
index_RoC = index_move_neg | index_move_pos;
signs(index_move_neg) = -1;

% If not any limits are passed to feasible
if sum(index_RoC) == 0 && f_DPF
    DP_current = DP1;
    DP_nom = DPF;
    
    index_move_neg = DP1 - DP0 < - roc_dist; % Check IF it crosses any boundaries
    index_move_pos = DP1 - DP0 > roc_dist;
    index_RoC = index_move_neg | index_move_pos;
    signs(index_move_neg) = -1;
else
    DP_current = DPF;
    DP_nom = DP0;
    
end
    
% Check in what direction update towards feasible is for all points

nr = nr_vec(index_RoC);
% 2) Check intersection - move limit
for ii = 1:sum(index_RoC)
    ind = nr(ii);
    sgn = signs(ind);

    n = sgn*RoC_p(:,ind); % normal RoC plane
    % Point on plane - movelimit
    if pdata.nx > 0
        point = DP0 + sgn*RoC_p(:,ind).*pdata.marg(nr(ii),3)*Opt_set.target_beta* RBDO_s.RoC_x; % point on plane
    elseif pdata.nd > 0
        point = DP0 + sgn*RoC_p(:,ind)*RBDO_s.RoC_d; % point on plane
    end

    % Inersection with movelimit plane
    sol_dp =  plane_line_intersect(DP_nom, DP_current, point, n);

    % Check if closer than previous point.
    [~,I] = min([norm(DP_nom-DP_current), norm(DP_nom-sol_dp)]);

    if I == 2 % New movelimit is on the line!
        DP_current = sol_dp;
    end
end

index_lb = DP_current < lbp;
index_lb_dp0 = DP_nom == lbp;



if sum( index_lb & index_lb_dp0) > 0 %Minskar från lb, skip the loop!
    DP1 = DP_nom;
    f_loop = false;
else
    f_loop = true; 
end

% Inersection with lb plane
nr = nr_vec(index_lb);
if f_loop
    for ii = 1:sum(index_lb)

        ind = nr(ii);
        n_lb = -RoC_p(:,ind);

        sol_lb =  plane_line_intersect(DP_nom, DP_current, lbp, n_lb);
        [~,I] = min([norm(DP_current-DP_nom), norm(sol_lb-DP_nom)]);

        if I == 2 % Lower bound is along the line!
            DP_current = sol_lb;
        end
    end
end

DP1 = DP_current;


% Hypersphere - check if distance is greater than allowed.
