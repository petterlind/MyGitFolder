function u_space_vec = U_space(x_space_vec, mu_vec, stdv_vec, dist)

% function that transform a second order vector of points given in x-space to u-space.
% Transformation to approx normal dist has to be done beforehand!

[rows , columns ] = size(x_space_vec);
u_space_vec = nan(rows, columns);
for ii = 1:columns
    for ij = 1:rows % normal distributed transformation
        
        if dist(ij)== 1
            u_space_vec(ij,ii) =   (x_space_vec(ij,ii) - mu_vec(ij) )./stdv_vec(ij);
            
        elseif dist(ij) == 2
            c = stdv_vec(ij)/mu_vec(ij);
            mu = log(mu_vec(ij)/sqrt(1+c^2));
            std = sqrt(log(1+c^2));
            
            u_space_vec(ij,ii) = (log(x_space_vec(ij,ii)) - mu) / std;
        else 
            error('Unknown distrubution.')
        end
        
    end 
end
end