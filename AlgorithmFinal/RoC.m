function DP1 = RoC(RBDO_s, pdata, Opt_set, DP1, DP0, lbp)
% DP0, nominal point
% DP1, New suggested point
% DPF, feasible point
% lbp, lower bound point
% type, Move limit or lower bound only. 


% DP1, new suggested point wrt move limits.

% Check for the lb and upper bound

% 1) Input
% roc_dist = min([RBDO_s.roc_dist'; Opt_set.dp_x' - lbp; Opt_set.ub' - Opt_set.dp_x'])';

if pdata.nx > 0 && pdata.nd > 0
    error('More code needed in RoC.m!') % and below aswell!
end

% 2) If it cuts a lb-plane or move-plane!
nrdv = length(DP0);
% signs = ones(nrdv,1);
nr_vec = 1:nrdv;
RoC_p = diag(ones(nrdv,1));

% Check in what direction update towards feasible is for all points
% index_move_neg = DP1 - DP0 < - roc_dist;
% index_move_pos = DP1 - DP0 > roc_dist;
% index_lb = DP1 < lbp;
% index_RoC = index_move_neg | index_move_pos | index_lb;
% signs(index_move_neg) = -1;
    
% % Check in what direction update towards feasible is for all points
% nr = nr_vec(index_RoC);
% 
% % 2) Check intersection - move limit
% for ii = 1:sum(index_RoC)
%     ind = nr(ii);
%     sgn = signs(ind);
% 
%     n = sgn*RoC_p(:,ind); % normal RoC plane
%     % Point on plane - movelimit
%     if pdata.nx > 0
%         point = DP0 + sgn*RoC_p(:,ind).*pdata.marg(nr(ii),3)*Opt_set.target_beta* roc_dist(ind); % point on plane
%     elseif pdata.nd > 0
%         point = DP0 + sgn*RoC_p(:,ind)* roc_dist(ind); % point on plane
%     end
%     
%     % Lower bound!
%     % if DP1(ind) < lbp(ind)
%     %     point = lbp;
%     % end
%     
% 
%     % Inersection with movelimit plane
%     sol_dp =  plane_line_intersect(DP0, DP1, point, n);
%     
%    index_brake = sol_dp < lbp;

index_brake = DP1 < lbp;

    % If breaking a lb, check where that intersection is
    if sum(index_brake) > 0
         nr2 = nr_vec(index_brake);
        for ij = 1:sum(index_brake)
            ind2 = nr2(ij);
            nb = -1*RoC_p(:,ind2); %SGN?
            brake =  plane_line_intersect(DP0, DP1, lbp, nb);
            
            % Check if closer than previous point.
            [~,I] = min([norm(DP0-DP1), norm(DP0-brake)]);

            if I == 2 % New movelimit is on the line!
                DP1 = brake;
            end
            
        end
    end
        

% %     % Check if closer than previous point.
% %     [~,I] = min([norm(DP0-DP1), norm(DP0-sol_dp)]);
% % 
% %     if I == 2 % New movelimit is on the line!
% %         DP1 = sol_dp;
% %     end
% % end
