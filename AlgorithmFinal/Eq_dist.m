function pseduo_dist = Eq_dist(x_space_vec, mu, sigma, dist)
%
% Computes equivalent normal mu sigma at point x. for lognormal (or normal)
% dist.
%

[rows , columns ] = size(x_space_vec);
pseduo_dist = nan(rows, 2);

for ii = 1:columns
    for ij = 1:rows
        if dist(ij) == 1 % normal
            pseduo_dist(ij,:) = [mu(ij), sigma(ij)];
        elseif dist(ij) == 2 %lognormal

            %sigma
            pseduo_dist(ij,2) = normpdf(norminv(cdf('lognormal',x_space_vec(ij,ii), mu(ij),sigma(ij))));
            % mu
            pseduo_dist(ij,1) = x_space_vec(ij,ii) - norminv(cdf('lognormal',x_space_vec(ij,ii), mu(ij),sigma(ij)))*pseduo_dist(ij,2);

        else
            error('Problem in Eq_dist.m, unknown distribution')


        end
    end
end

            %%%
            % plot
%              for ii = 1: numel(pdata.marg(:,2))
%                     
%                  xp = linspace(0.7*LS(ii).nominal_x(ii),2*LS(ii).nominal_x(ii),10000);
%                  
%                  pd1 = makedist('Lognormal',pdata.marg(ii,5) ,pdata.marg(ii,6));         
%                  pdf_lognormal = pdf(pd1,xp);
% 
%                  pd2 = makedist('normal',pdata.marg(ii,2) ,pdata.marg(ii,3)); 
%                  pdf_normal = pdf(pd2,xp);
%                  plot(xp,pdf_lognormal,'LineWidth',2)
%                  hold on
%                  plot(xp,pdf_normal,'LineWidth',2)
%                  legend('log-normal','normal')
%              end
%         
        %%%
