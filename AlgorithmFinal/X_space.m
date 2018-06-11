function x_space_vec = X_space(u_space_vec, mu_vec, stdv_vec,dist)

% function that transform a second order tensor of points given in u-space to x-space.

[rows , columns ] = size(u_space_vec);
x_space_vec = nan(rows, columns);

for ii = 1:columns
    
    for ij = 1:rows
        
        if dist(ij) == 1 % normal distributed transformation

            x_space_vec(ij,ii) =  mu_vec(ij) + u_space_vec(ij,ii).*stdv_vec(ij);
            
        elseif dist(ij) == 2 % lognormal distributed transformation
            
            % Using the pseudo-normal variables..
            x_space_vec(ij,ii) =  mu_vec(ij) + u_space_vec(ij,ii).*stdv_vec(ij);
%             c = mu_vec(ij)/ stdv_vec(ij);
%             mu_n = log(mu_vec(ij)/sqrt(1+c^2));
%             std_n = sqrt(log(1+c^2));
%             
%             x_space_vec(ij,ii) =  exp(mu_n + u_space_vec(ij,ii).*std_n);
            
        else
            error('Problem in X_space.m, unknown distribution')
        end
    end       
end
    

end