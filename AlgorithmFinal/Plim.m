function p_limits = Plim(dp, alpha, lb, active)
% Checks if there is a physical boundary in the alpha direction close to
% dp.

lst = 1:1000;
% Set the indexing for the loop
number = lst(active);
nca = sum(active);

p_limits = nan(numel(active),1);
n = eye(numel(active));

for ii = 1:nca %For all active constraints
    nr = number(ii);
    P0 = dp;
    %P0 = dp - 10* alpha(nr,:)';
    P1= dp +  10* alpha(nr,:)';
    
    for ij = 1:numel(active)
        [I, check]=plane_line_intersect(n(:,ij),lb,P0,P1);
        if check == 1
            p_limits(nr) = sign(alpha(nr,:)*(I - dp))* min( p_limits(nr), norm(I - dp));
        end
    end
end












