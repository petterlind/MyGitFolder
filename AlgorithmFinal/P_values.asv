function [p_val, p_fun, p_slope] = P_values(xvalues,limit_values, alpha, dp, slope)
% Transforms all coordinates into p-values
% note, only one limit state at a time is considered!

% Check what values are non nan
lst = 1:1000;
max_valid = max(lst(~isnan(xvalues(:,1))));

% Create vectors
x = xvalues(1:max_valid,:) - dp'.*ones(size(xvalues(1:max_valid,:)));

% normalize them
norm_x = sum(x.^2,2);
x_normed = x./ sqrt(norm_x);

% Check if direction is same as alpha with tolerance, using scalar product.
same_dir = abs((abs(alpha' * x_normed') - 1)) < 2e-2; % acosd(1-2e-2) = 11 grad

% cross([alpha;0], [x_normed(1,:),0]')
% cross(alpha)
% cross(alpha)

% Check if dp is in the vector and add it
dp_pos = find(norm_x ==0);
if ~isempty(dp_pos)
    same_dir(dp_pos) = 1;
end

% Extract the values
p_val = alpha' * x(same_dir,:)';


if ~isnan(slope(1))
    p_slope = slope(same_dir);
    p_fun = limit_values(same_dir);
    
elseif  isnan(slope(1))
    p_slope = 0;
    p_fun = 0;
    
else
    warning('smth off with P_values')
end
end