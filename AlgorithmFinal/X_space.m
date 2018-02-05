function x_space_vec = X_space(u_space_vec, mu_vec, stdv_vec)

% function that transform a vector of points given in u-space to x-space.
% Given normal distributed parameters.

[size_row , size_column ] = size(u_space_vec);

x_space_vec = nan(size_row, size_column);

for ii = 1:size_column
    x_space_vec(:,ii) =  mu_vec + u_space_vec(:,ii).*stdv_vec;
end
    

end