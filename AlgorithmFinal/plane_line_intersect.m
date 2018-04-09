function sol_dp = plane_line_intersect(L0,L1,P1,n)
% L0, L1 - points on line
% P1 - point on plane
% n - normal vector on plane

u = L1 - L0; % Line vector
w = L0 - P1; % Vector between plane and line

D = dot(n,u); % Projection plane normal, line vector
N = -dot(n,w); % negative projection plane normal, connection plane line
sI = N / D; % Ratio 

% Outside of segment!
if (sI > 0 && sI < 1)
    sol_dp = L0 + sI.*u; %Intersection point
else % no intersection
    sol_dp = nan(numel(L0),1);
end

end