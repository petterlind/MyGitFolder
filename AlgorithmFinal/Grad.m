function obj = Grad(obj, pdata, Opt_set, RBDO_s,type)
% Computes gradient for every function
% Uses the coordinates in u-space if the variables are probabalistic.

switch type
case 'parameters'
    
    % Probabilistic parameters
        obj.doe_u = Experiment(U_space(obj.Mpp_p, pdata.margp(:,2), pdata.margp(:,3), pdata.margp(:,1)), RBDO_s.DoE_size_x );
        obj.doe_x = X_space( obj.doe_u, pdata.margp(:,2) ,pdata.margp(:,3),pdata.margp(:,1)); % Transformation back to X-space

        % Experiment - in x-space!
        obj.doe_val = nan(pdata.np+1,1);
        for ij=1:(pdata.np+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('parameters', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val = obj.doe_val(1);
        %A = [ ones( pdata.np+1,1) (obj.doe_x - pdata.margp(:,2))'];
        A = [ ones( pdata.np+1,1) obj.doe_u.']; % U-space!
        
case 'variables'
    
    % Separate deterministic and probabilistic
    
    if pdata.nx > 0 
        
        % Probabilistic variables
        obj.doe_u = Experiment(obj.nominal_u, RBDO_s.DoE_size_x);
        obj.doe_x = X_space( obj.doe_u, pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1)); % Transformation back to X-space

        %2)Experiment - in x-space!
        obj.doe_val = nan(pdata.nx+1,1);
        for ij=1:(pdata.nx+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, 1,0);    
        end
        obj.nominal_val = obj.doe_val(1);
        A = [ ones( pdata.nx+1,1) obj.doe_u.'];
        A_x =  [ ones( pdata.nx+1,1) obj.doe_x.']; % TEST
        
        const_plane_x = A_x\obj.doe_val;
        gradient_x(:,1) = const_plane_x(2:end); 
        obj.alpha_x = - gradient_x / norm(gradient_x);
    
    end
    
    % Deterministic variables
    if pdata.nd > 0
         obj.doe_x = Experiment(obj.nominal_x, RBDO_s.DoE_size_d); %
         A = [ ones( pdata.nd+1,1) (obj.doe_x - obj.nominal_x)' ]; % in x-space!
         
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

%3)fit plane, find direction, from nominal point - u-space all but nd.
const_plane = A\obj.doe_val;
gradient(:,1) = const_plane(2:end);
alpha_u = - gradient / norm(gradient);

switch type
    
    case 'variables'
    
    if pdata.nx > 0
        %obj.alpha_x = -( pdata.marg(:,3).*gradient ) / norm(pdata.marg(:,3).* gradient); %SLA
        obj.slope =  obj.alpha_x' * gradient_x; % kurvanpassning i u-space?
        %obj.beta_v = Opt_set.target_beta*obj.alpha_x.*pdata.marg(:,3); % Avståndet från dp till MPP i x-space!
        
        obj.beta_v = X_space(Opt_set.target_beta * alpha_u , pdata.marg(:,2), pdata.marg(:,3),pdata.marg(:,1)) - pdata.marg(:,2);
       
        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        %obj.x_trial = X_space( obj.nominal_u + alpha_u*(-obj.nominal_val/obj.slope),pdata.marg(:,2),pdata.marg(:,3), pdata.marg(:,1));
        obj.x_trial = obj.nominal_x + obj.alpha_x*(-obj.nominal_val/obj.slope);
        obj.p_trial = obj.alpha_x.'*(obj.x_trial-obj.nominal_x);
        
        if ~RBDO_s.f_probe % if not probe, take this one as MPP!
        obj.Mpp_x = obj.x_trial;
        end        
    end
    
    if pdata.nd > 0
        obj.alpha_x = alpha_u;
        obj.slope =  obj.alpha_x' * gradient;
        
        [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj.nominal_x, obj.alpha_x);
        obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
        obj.x_trial = obj.nominal_x + obj.p_trial*obj.alpha_x;

        
        if ~RBDO_s.f_probe % if not probe, take this one as MPP!
            % Check ROC!
        
%             if RBDO_s.f_RoC
%                 obj.x_trial  = RoC(RBDO_s, pdata, Opt_set, obj.alpha_x * obj.p_trial + obj.nominal_x, obj.nominal_x, [], RBDO_s.lb_probe);
%                 %obj.x_trial = %obj.nominal_x + (probe_x-obj.nominal_x) * obj.alpha_x'; 
%             end
            
            obj.Mpp_x = obj.x_trial;
        end
    end
    
    case 'parameters'
       obj.Mpp_p = X_space( alpha_u * Opt_set.target_beta, pdata.margp(:,2),pdata.margp(:,3),pdata.margp(:,1));

    otherwise
        error('Unknown type in Grad.m')
end

end


