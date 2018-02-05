function u_space_vec = U_space(x_space_vec, mu_vec, stdv_vec)

% function that transform a vector of points given in u-space to x-space.
% Given normal distributed parameters.

[size_column , size_row ] = size(x_space_vec);
u_space_vec = nan(size_column, size_row);

for ii = 1:size_row
    u_space_vec(:,ii) =   (x_space_vec(:,ii) - mu_vec )./stdv_vec;
end

end