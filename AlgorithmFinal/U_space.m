function u_space_vec = U_space(x_space_vec, mu_vec, stdv_vec)

% function that transform a second order vector of points given in x-space to u-space.
% Transformation to approx normal dist has to be done beforehand!

[rows , columns ] = size(x_space_vec);
u_space_vec = nan(rows, columns);
for ii = 1:columns
    for ij = 1:rows % normal distributed transformation
            u_space_vec(ij,ii) =   (x_space_vec(ij,ii) - mu_vec(ij) )./stdv_vec(ij);
    end 
end
end