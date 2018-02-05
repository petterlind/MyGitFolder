function alpha_inner = Change_dir(active_l_conv, alpha_inner, x_values, dp)
% Function that changes direction of "alpha" if a lower boundary is struck and the

lst = 1:20;
number = lst(active_l_conv);

 N_mat = eye(numel(active_l_conv));
 
 
 x_values
 

% Check wich functions lies on the LB-surface and has converged!
for ii = 1:sum(active_l_conv)
    nr = number(ii)

    % Select point
    x_point = last one

    % Create vector
    vector = x_point - bound_point

    % Check if on a limit state
    bound_check = abs( vector * N_mat -1 ) < 1e-7;

    % Check if the functional value in that point is smaller than zero
    value = pvalue(nr,indexp) < -1;

    % update alpha_inner
    if sum(bound_check) == 1 && value == 1
      N_vec = N_mat(:,nr);
      alpha_inner(:, nr) = alpha_inner(:,nr) - (alpha_inner(:,nr) * N_vec) * N_vec

    elseif sum(bound_check) > 1 && value == 1
      %alpha_inner(:, nr) = alpha_inner(:,nr) - (alpha_inner(:,nr) * N_vec1) * N_vec1 - (alpha_inner(:,nr) * N_vec2) * N_vec2
      warning('More code needed')
    end
end