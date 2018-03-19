function dp_RoC = RoC(RBDO_s, pdata, Opt_set)
% Determines if the move is outside the movelimit.

% Hypercube. check if change of variable in any direction is greater than
% allowed.


% 1) Allowed distance in each direction
if pdata.nd >0 % d - a deterministic measure,
    signs = ones(pdata.nd,1);
    nr_vec = 1:pdata.nd;
    
    RoC_p = diag( ones(pdata.nd,1).*RBDO_s.RoC_d );
    index_RoC_neg = Opt_set.dpl_x - Opt_set.dp_x < -RBDO_s.RoC_d;
    index_RoC_pos = Opt_set.dpl_x - Opt_set.dp_x > RBDO_s.RoC_d;
    index_RoC = index_RoC_neg | index_RoC_pos;
    signs(index_RoC_neg) = -1;
    nr = nr_vec(index_RoC);
end

if pdata.nx >0  % x - based on beta.
    error('More code needed in RoC.m')
end

dp_RoC = Opt_set.dp_x; % dummy

% 2) Check intersection
for ii = 1:sum(index_RoC)
    ind = nr(ii);
    sgn = signs(ind);
    
    n = sgn*RoC_p(:,ind)/ norm(RoC_p(:,ind)); % normal plane
    point = Opt_set.dp_x + sgn*RoC_p(:,ind); % point on plane
    
    u = Opt_set.dpl_x-Opt_set.dp_x; % Line vector
    w = Opt_set.dp_x - point; % Vector between plane and line
    
    D = dot(n,u); % Projection plane normal, line vector
    N = -dot(n,w); % negative projection plane normal, connection plane line
    sI = N / D; % Ratio 
    
    sol_dp = Opt_set.dp_x + sI.*u; %Intersection point
    
    [m,I] = min([norm(dp_RoC-Opt_set.dpl_x), norm(sol_dp-Opt_set.dpl_x)]); % Check if shorter then previous
    
    if I == 2
        dp_RoC = sol_dp;
    end
    
end

% Hypersphere - check if distance is greater than allowed.

