function obj = Grad(obj, pdata, Opt_set, RBDO_s,type)
% Computes gradient for every limitstate and the objective
% Uses the coordinates in u-space if the variables are probabalistic.

switch type
case 'parameters'
    
    % Probabilistic parameters
        pdata.margp(:,2:3) =  Eq_dist(obj.Mpp_p, pdata.margp(:,5), pdata.margp(:,6), pdata.margp(:,1));
        
        u_vec = U_space(obj.Mpp_p, pdata.margp(:,2), pdata.margp(:,3));%, pdata.margp(:,1));
        obj.doe_u = Experiment(u_vec, obj.DoE_size_p );
        obj.doe_x = X_space( obj.doe_u, pdata.margp(:,2) ,pdata.margp(:,3));%,pdata.margp(:,1)); % Transformation back to X-space
       
        % Experiment - in x-space!
        obj.doe_val = nan(pdata.np+1,1);
        for ij=1:(pdata.np+1) 
            obj.doe_val(ij,1) = gvalue_fem('parameters', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val = obj.doe_val(1);
        A = [ ones( pdata.np+1,1) obj.doe_u.']; % U-space!
        
        
        
case 'variables'
    
    if pdata.nx > 0     
        % Probabilistic variables
        
        pdata.marg(:,2:3) =  Eq_dist(obj.nominal_x, pdata.marg(:,5), pdata.marg(:,6), pdata.marg(:,1));
        u_vec = U_space(obj.nominal_x , pdata.marg(:,2), pdata.marg(:,3));
        obj.doe_u = Experiment(u_vec, obj.DoE_size_x.*Opt_set.ML_scale);
        
        % Approximation of isoprobibilistic dist around point x.
        obj.doe_x = X_space( obj.doe_u, pdata.marg(:,2) , pdata.marg(:,3));%, pdata.marg(:,1)); % Transformation back to X-space
        % Experiment - in x-space!
        obj.doe_val = nan(pdata.nx+1,1);
        for ij=1:(pdata.nx+1)
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val_old = obj.nominal_val;
        obj.nominal_val = obj.doe_val(1);
        
        A = [ ones( pdata.nx+1,1) obj.doe_u.'];
        A_x =  [ ones( pdata.nx+1,1) obj.doe_x.']; % TEST
        
        const_plane_x = A_x\obj.doe_val;
        gradient_x(:,1) = const_plane_x(2:end); 
        obj.alpha_x_old = obj.alpha_x;
        obj.alpha_x = - gradient_x / norm(gradient_x);
    
    end
    
    % Deterministic variables
    if pdata.nd > 0
         obj.doe_x = Experiment(obj.nominal_x, obj.DoE_size_d.*Opt_set.ML_scale); %
         A = [ ones( pdata.nd+1,1) (obj.doe_x - obj.nominal_x)' ]; % in x-space!
         
         for ij=1:(pdata.nd+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
         end
         obj.nominal_val = obj.doe_val(1);
         
    end

otherwise
    error('Undefined type in Grad.m')
end

% fit plane, find direction, from nominal point - u-space all but nd.
const_plane = A\obj.doe_val;
gradient(:,1) = const_plane(2:end);
alpha_u = - gradient / norm(gradient);

switch type
    
    case 'variables'
    
    if pdata.nx > 0
        obj.slope =  obj.alpha_x' * gradient_x; %Slope in x-space
        obj.beta_v = X_space(obj.target_beta * alpha_u , pdata.marg(:,2), pdata.marg(:,3)) - pdata.marg(:,2);

        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        obj.x_trial = obj.nominal_x + obj.alpha_x*(-obj.nominal_val/obj.slope);
        obj.p_trial = obj.alpha_x.'*(obj.x_trial-obj.nominal_x);
        
        if ~RBDO_s.f_probe % Linear guess is Mpp-guess if no probe
        obj.Mpp_x = obj.x_trial;
        end        
    end
    
    if pdata.nd > 0
        obj.alpha_x = alpha_u;
        obj.slope =  obj.alpha_x' * gradient;
        
        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
        obj.x_trial = obj.nominal_x + obj.p_trial*obj.alpha_x;

        
        if ~RBDO_s.f_probe % Linear guess is Mpp-guess if no probe
            obj.Mpp_x = obj.x_trial;
        end
    end
    
    case 'parameters'
       %obj.alpha_p = X_space(alpha_u, pdata.margp(:,2),pdata.margp(:,3),pdata.margp(:,1));
       
       Mpp_old = obj.Mpp_p;
       obj.Mpp_p = X_space( alpha_u * obj.target_beta, pdata.margp(:,2),pdata.margp(:,3),pdata.margp(:,1));
       dif = (obj.Mpp_p-Mpp_old);
       
       if obj.nr == 1
         obj.Mpp_p
        disp(dif)
       end
        
    otherwise
        error('Unknown type in Grad.m')
end

