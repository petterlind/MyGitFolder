function p_limit = P_lim(dp, alpha, lb, direction)
% Checks if there is a physical boundary in the alpha direction close to
% dp.

p_limit = nan;
n = eye(numel(dp));

dp_r = dp(dp~=lb);
alpha_r = alpha(dp~=lb);
n_r = n(dp~=lb,dp~=lb);
lb_r = lb(dp~=lb);

P0 = dp_r;
P1= dp_r + alpha_r*direction;
for ij = 1:numel(dp_r)
    
    [I, check] = plane_line_intersect(n_r(:,ij),lb_r,P0,P1);
    
    if check == 1 % &&  alpha'*(I-dp) > 0 % || ( direction == -1 && direction == sign(-alpha'*(I-dp)) ) )
        p_limit = direction* min(abs(p_limit),  norm(I-dp_r));
        
    elseif check == 1 && max(abs(I - dp_r)) < 1e-11
        p_limit = 0;
    end
    
end


% for ij = 1:numel(dp)
%     [I, check] = plane_line_intersect(n(:,ij),lb,P0,P1);
%     if check == 1 % &&  alpha'*(I-dp) > 0 % || ( direction == -1 && direction == sign(-alpha'*(I-dp)) ) )
%         p_limit = direction* min(abs(p_limit),  norm(I-dp));
%         
%     elseif check == 1 && max(abs(I - dp)) < 1e-11
%         p_limit = 0;
%     end
%     
% end











