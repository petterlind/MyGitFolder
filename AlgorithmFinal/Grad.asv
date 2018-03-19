function obj = Grad(obj, pdata, Opt_set, RBDO_s,type)
% Computes gradient for every function
% Uses the coordinates in u-space if the variables are probabalistic.

switch type
case 'parameters'
    
    % Probabilistic parameters
        obj.doe_u = Experiment(U_space(obj.Mpp_p, pdata.margp(:,2), pdata.margp(:,3)), obj.target_beta/2);
        obj.doe_x = X_space( obj.doe_u, pdata.margp(:,2) ,pdata.margp(:,3)); % Transformation back to X-space

        %2)Experiment - in x-space!
        obj.doe_val = nan(pdata.np+1,1);
        for ij=1:(pdata.np+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('parameters', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val = obj.doe_val(1);
        A = [ ones( pdata.np+1,1) (obj.doe_x - pdata.margp(:,2))'];

case 'variables'
    
    % Separate deterministic and probabilistic
    
    if pdata.nx > 0 
        
        % Probabilistic variables
        obj.doe_u = Experiment(obj.nominal_u, obj.target_beta/2);
        obj.doe_x = X_space( obj.doe_u, pdata.marg(:,2) , pdata.marg(:,3)); % Transformation back to X-space

        %2)Experiment - in x-space!
        obj.doe_val = nan(pdata.nx+1,1);
        for ij=1:(pdata.nx+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val = obj.doe_val(1);
        A = [ ones( pdata.nx+1,1) (obj.doe_x - obj.nominal_x)' ];
    
    end
    
    % Deterministic variables
    if pdata.nd > 0
         obj.doe_x = Experiment(obj.nominal_x, RBDO_s.det_step);
         A = [ ones( pdata.nd+1,1) (obj.doe_x - obj.nominal_x)' ];
         
         for ij=1:(pdata.nd+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
         end
         obj.nominal_val = obj.doe_val(1);
         
    end
    
    % Deterministic and probabilistic dv!
    if pdata.nd > 0 && pdata.nx > 0
        % Add them into the same vector. Not yet a problem...
        error('More code needed!')
    end
        

otherwise
    error('Undefined type in Grad.m')
end

%3)fit plane, find direction, from nominal point - x-space
const_plane = A\obj.doe_val;
gradient(:,1) = const_plane(2:end);


switch type
    
    case 'variables'
    
    if pdata.nx > 0
        obj.alpha_x = -( pdata.marg(:,3).*gradient ) / norm(pdata.marg(:,3).* gradient); %SLA
        obj.slope =  obj.alpha_x(:,1)' * gradient;

        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
        obj.x_trial = obj.nominal_x + obj.p_trial*obj.alpha_x;
    end
    
    if pdata.nd > 0
        obj.alpha_x = -(gradient ) / norm(gradient); 
        obj.slope =  obj.alpha_x(:,1)' * gradient;

        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
        obj.x_trial = obj.nominal_x + obj.p_trial*obj.alpha_x;
    end
    
    case 'parameters'

        obj.alpha_p = -( pdata.margp(:,3)*gradient ) / norm(pdata.margp(:,3).* gradient); %SLA
        obj.slope =  obj.alpha_p(:,1)' * gradient;
        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, pdata.margp(:,2), obj.alpha_p);
       % obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
        obj.Mpp_p = pdata.margp(:,2) + obj.target_beta*obj.alpha_p;
        
    otherwise
        error('Unknown type in Grad.m')
end

end


% alpha_vec(abs(alpha_vec)<5e-3) = 0;
% alpha = alpha_vec ./ norm(alpha_vec);

