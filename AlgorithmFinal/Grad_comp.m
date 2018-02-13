function [alpha , x_values , fun_value , slope, active_l, ls] = Grad_comp(dp, probdata, rbdo_fundata, gfundata, nr, RBDO_settings, lb, type, x_s, rbdo_parameters, alpha)
% Computes gradient for every function
% Uses the coordinates in u-space if the variables are probabalistic.

Lnumber = 1000; %for allocating matrices
lst = 1:Lnumber;

doe_scale = RBDO_settings.doe_scale;
active_l = 1;
ls = nan;
switch type

        case 'limitstate'
            nx = rbdo_parameters.nx;
            
            if rbdo_parameters.variable == 0 %Deterministic variables, Trusses
                DoE = Experiment(dp, doe_scale); 
                doe_x = DoE;
                
                
            else % Probabalistic variables, Rest
                
                last_mpp = double(min(lst(isnan(x_s(1,:,1)))) -1);
                
                if last_mpp ~= 0 % Set previous Mpp as current position for DoE.
                    DoE_x_s = mysqueeze(alpha(1,end-1,:)).* rbdo_parameters.target_beta + dp;
                    scale = rbdo_parameters.target_beta/200;
                    %DoE_x_s = dp;
                    
                elseif last_mpp == 0 %No previous Mpp found
                    DoE_x_s = dp;
                   scale = rbdo_parameters.target_beta/2;
                else
                    warning('Problem with finding position for DoE')
                end
                
                DoE = Experiment( DoE_x_s, scale); % i p_star %B1 % D1 - scale here!

                dp_x = X_space(zeros(size(dp)), probdata.marg(:,2), probdata.marg(:,3));
                doe_x = X_space( DoE, dp_x, probdata.marg(:,3));
            end
            
            fun_val = nan(length(doe_x),1);
            for ij = 1:length(doe_x)
                [fun_val(ij,1), ~] = gvalue_fem('variables', doe_x(:,ij), probdata, rbdo_parameters, gfundata, nr, 1,0);
            end
            A = [ ones(length(DoE),1) (DoE-dp)'];
            
        case 'cost'
            nx = length(dp);
            
            if rbdo_parameters.variable == 0 %Deterministic variables
                
                doe_x = Experiment(dp, doe_scale); % Linear objective, scale does not matter.
                DoE = doe_x;
                
            elseif rbdo_parameters.variable == 1
                
                
                DoE = Experiment( dp, rbdo_parameters.target_beta/ 2); % Do it around dp!  % B1 ?
                
                dp_x = X_space(zeros(size(dp)), probdata.marg(:,2), probdata.marg(:,3));
                doe_x = X_space( DoE, dp_x, probdata.marg(:,3));
                fun_val = nan(length(doe_x),1);
                
            end
            
            fun_val = nan(length(doe_x),1);  % Allocating fun value vector.

            for ij = 1:length(doe_x)
                fun_val(ij,1) = ObjectiveFunction(doe_x(:,ij), rbdo_fundata, gfundata);
            end
            A = [ ones(length(DoE),1) (DoE)'];

        case 'p_star'
            doe_u = Experiment(zeros(numel(probdata.name),1), 1);
            %doe_u = Experiment( U_space(probdata.p_star(:,nr), probdata.marg(:,2), probdata.marg(:,3)), 3); % i p_star
            doe_xp = X_space( doe_u, probdata.marg(:,2), probdata.marg(:,3));


            fun_val = nan(length(doe_xp),1);  % Allocating fun value vector.
            for ij = 1:length(doe_xp)
                [fun_val(ij,1), ls]= gvalue_fem('parameters',doe_xp(:,ij), probdata, rbdo_parameters, gfundata, nr, 1,0);
                if ij == 1
                    gfundata.limitstates(nr,1) = ls;
                end
            end

            DoE = doe_u;
            A = [ ones(length(DoE),1) (DoE)'];
end

% Fit hyperplane to data
const_plane = A\fun_val;
gradient(:,1) = const_plane(2:end);

%step 1
alpha_vec = - gradient ./ norm(gradient)  ; %norm( gradient );

%step 2
alpha_vec(abs(alpha_vec)<5e-3) = 0;
alpha = alpha_vec ./ norm(alpha_vec);

% Check if it is a feasible direction. - only relevant for trusses, not
% adapted for u-space.

if strcmp(type,'limitstate')  &&  strcmp( gfundata.type, 'TRUSS') 

    % Check if on a limit state
    vector = dp - lb;
    check = abs(vector) < 1e-9; 

      N_full = eye(nx);
      lst = 1:20;
      for ii = 1:sum(check)
          number = lst(check);
          N_vec = N_full(:,number(ii));

        if (N_vec'* alpha < 0 && fun_val(1) > 0 ) || ( N_vec'* alpha > 0 && fun_val(1) < 0)

                alpha_vec(number(ii)) = 0;

                if alpha_vec == 0 %fix
                    alpha = alpha_vec;
                    active_l = 0;
                    warning('Quick fix in Grad-comp')
                else
                    alpha = alpha_vec / norm(alpha_vec);
                end
        end
      end
end

x_values = DoE'; 
slope = alpha(:,1)' * gradient;

% Only the first point
x_values = x_values(1,:);
fun_value = fun_val(1);
