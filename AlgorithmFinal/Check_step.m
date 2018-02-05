function active = Check_step( active, alpha_inner, x_s, x_val, flag_no_cross, tolerance)
% Check steplength for the change x_s from the last step.

% Set the indexing for the loop
lst = 1:1000;
number = lst(active);
nca = sum(active);

for ii = 1:nca
    nr = number(ii);
    index_f = max(lst(~isnan(flag_no_cross(nr,:))));
    
    if flag_no_cross(nr, index_f) == 0
        
        % Check if larger than Mpp, pick the last Mpp.
        if sum( length( x_val) / numel(x_val) ) ~= 1
            x_val_red = mysqueeze(x_val(ii,:,:)); % Test to pick the last x-value for the limitstate. Rest should be in same direction....
            mpp_index = double(min(lst(isnan(x_val_red(:,1)))) -1);
            point = x_val_red(mpp_index,:)';
        else
            point = x_val;
        end
%         
        [p_val, ~, ~] = P_values(mysqueeze(x_s(nr,: ,:)),  nan(1,100), alpha_inner(:,nr), point,  nan(1,100));
        
        if length(p_val) == 1 % WHY
            active(nr) = 0;
        elseif abs(p_val(end) - p_val(end-1)) < tolerance
            active(nr) = 0;
        end
    elseif flag_no_cross(nr, index_f) == 1
        active(nr) = 0;
        
    else
        fprintf('flag_no_cross = nan, probs in Check step')
    end
        
    
end
end


