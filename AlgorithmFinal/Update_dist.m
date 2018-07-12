function [mu, sigma] = Update_dist(mean, std, dist)
%
% Updates the distribution parameters mu and sigma for lognormal or normal
% dist.
%
% Plug in COV here if needed!

mu = nan(numel(mean),1);
sigma = nan(numel(mean),1);

for ii = 1:numel(mean)
    
    if dist(ii) == 1
        mu(ii) = mean(ii);
        sigma(ii) = std(ii);
    elseif dist(ii) == 2
        mu(ii) = log( mean(ii) /(sqrt(1 + std(ii)^2 / mean(ii)^2)));
        sigma(ii) = sqrt(log(1+std(ii)^2 / mean(ii)^2));
    end
end

