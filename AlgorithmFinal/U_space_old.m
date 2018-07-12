function [u_space_vec, pseduo_dist] = U_space(x_space_vec, mu_vec, stdv_vec, dist)

% function that transform a second order vector of points given in x-space to u-space.

[rows , columns ] = size(x_space_vec);
u_space_vec = nan(rows, columns);
pseduo_dist = nan(rows, 2);
for ii = 1:columns
    
    for ij = 1:rows % normal distributed transformation
        
        if dist(ij) == 1

            u_space_vec(ij,ii) =   (x_space_vec(ij,ii) - mu_vec(ij) )./stdv_vec(ij);
            pseduo_dist(ij,:) = [mu_vec(ij), stdv_vec(ij)];
        elseif dist(ij) == 2 % lognormal distributed transformation
            
            %sigma
            pseduo_dist(ij,2) = normpdf(norminv(cdf('lognormal',x_space_vec(ij,ii), mu_vec(ij),stdv_vec(ij))));
            
            % mu
            pseduo_dist(ij,1) = x_space_vec(ij,ii) - norminv(cdf('lognormal',x_space_vec(ij,ii), mu_vec(ij),stdv_vec(ij)))*pseduo_dist(ij,2);
            
            u_space_vec(ij,ii) = (x_space_vec(ij,ii) -  pseduo_dist(ij,1) )./pseduo_dist(ij,2);
            
        else
            error('Problem in U_space.m, unknown distribution')
        end
    end 
end
end