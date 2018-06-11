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
            % From Structural reliability p 80.
            
%             c = mu_vec(ij)/ stdv_vec(ij);
%             mu_n = log(mu_vec(ij)/sqrt(1+c^2));
%             std_n = sqrt(log(1+c^2));
%             
%             u_space_vec(ij,ii) =   (log(x_space_vec(ij,ii)) - mu_n )./std_n;
            
            % From Methods of structural reliability p.103
            % Lognormally distributed variables with means mu_vec, and stds
            % stdv_vec
            
            % 1) Equivalent standard distributed variable.
            
            sy = sqrt(log((stdv_vec(ij)/mu_vec(ij))^2 +1));
            muy = log(mu_vec(ij)) - 0.5*sy^2;
            
            %2 Density function at x_val
            fy = exp(-0.5*((log(x_space_vec(ij,ii))- muy)/ sy)^2) / (sqrt(2*pi)*x_space_vec(ij,ii)*sy);
            i_cdf = (log(x_space_vec(ij,ii))- muy)/ sy;
            pdf = exp(-0.5*((log(x_space_vec(ij,ii))- muy)/ sy)^2) / sqrt(2*pi);
            
            % Equivalent stdv and mean for a normally distributed variable
            pseduo_dist(ij,2) = pdf / fy;
            pseduo_dist(ij,1) = x_space_vec(ij,ii) - i_cdf * stdv_vec;
            
            u_space_vec(ij,ii) =   (x_space_vec(ij,ii) -  pseduo_dist(ij,1) )./pseduo_dist(ij,2);
            
        else
            error('Problem in U_space.m, unknown distribution')
        end
    end
    
    
end




end