function [p_x, p_val] = P_val(new_p, new_val, obj)

% Transforms all coordinates into p-values
% note, only one limit state at a time is considered!

% Create vectors
x = new_p -obj.nominal_x ; % Doe

% normalize them
norm_x = sum(x.^2,1);
x_normed = x./ sqrt(norm_x);

% Check if direction is same as alpha with tolerance, using scalar product.
same_dir = abs((abs(obj.alpha_x' * x_normed) - 1)) < 2e-2; % acosd(1-2e-2) = 11 grad

% Check if dp is in the vector and add it
if ~isempty(find(norm_x ==0))
    same_dir(find(norm_x ==0)) = true;
elseif sum(norm_x < 1e-12) >= 1
    same_dir( norm_x < 1e-12 ) = true;
end

% Extract the values
p_x = obj.alpha_x' * x(:,same_dir);
p_val = new_val(same_dir);
end
