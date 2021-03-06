function obj = Grad(obj, pdata, Opt_set, RBDO_s,type, count)
% Computes gradient for every limitstate and the objective
% Uses the coordinates in u-space if the variables are probabalistic.

switch type
case 'parameters'
    
    % Probabilistic parameters
       % pdata.margp(:,2:3) =  Eq_dist(obj.Mpp_p, pdata.margp(:,5), pdata.margp(:,6), pdata.margp(:,1));
        
        u_vec = U_space(obj.Mpp_p, pdata.margp(:,2), pdata.margp(:,3), pdata.margp(:,1));
        
        obj.doe_u = Experiment(u_vec, obj.DoE_size_p );
        obj.doe_x = X_space( obj.doe_u, pdata.margp(:,2) ,pdata.margp(:,3),pdata.margp(:,1)); % Transformation back to X-space
       
        % Experiment - in x-space!
        obj.doe_val = nan(pdata.np+1,1);
        for ij=1:(pdata.np+1) 
            obj.doe_val(ij,1) = gvalue_fem('parameters', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj, count, 0);    
        end
        obj.nominal_val = obj.doe_val(1);
        A = [ ones( pdata.np+1,1) obj.doe_u.']; % U-space!
        
        
        
case 'variables'
    
    if pdata.nx > 0     
        % Probabilistic variables
        
        %pdata.marg(:,2:3) =  Eq_dist(obj.nominal_x, pdata.marg(:,2), pdata.marg(:,3), pdata.marg(:,1));
        u_vec = U_space(obj.nominal_x , pdata.marg(:,2), pdata.marg(:,3),pdata.marg(:,1));
        
        % Minimum! Fix for garanteeing minum DoE
         scale = ones(10,1)*2;
         scale(1) = scale(1) * 1.3;
         scale(3) = scale(3) * 1.3; 
         scale(4) = scale(4) * 0.6;
         scale(5) = scale(5) * 0.7;
         scale(8) = scale(8)*2;
         scale(9) = scale(9)*1.7;
%         scale(10) = scale(10)*2
         obj.doe_u = Experiment(u_vec, scale);
         
         
         %obj.doe_u = Experiment(u_vec, obj.DoE_size_x.*Opt_set.ML_scale);
         %Before abaqus
         
        
        % Approximation of isoprobibilistic dist around point x.
        obj.doe_x = X_space( obj.doe_u, pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1)); % Transformation back to X-space
        
        
        obj.doe_x = obj.doe_x(:,1).*ones(size(obj.doe_x));
        for i = 1:10
        obj.doe_x(i,i+1) = obj.doe_x(i,i+1) + 1e-3;
        end
        
        % Experiment - in x-space!
        obj.doe_val = nan(pdata.nx+1,1);
        for ij=1:(pdata.nx+1)
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj,count, 0);    
        end
        obj.nominal_val_old = obj.nominal_val;
        obj.nominal_val = obj.doe_val(1);
        
        A = [ ones( pdata.nx+1,1) obj.doe_u.'];  % u-space
%         A_x =  [ ones( pdata.nx+1,1) obj.doe_x.']; % x-space
%         
%         const_plane_x = A_x\obj.doe_val;
%         gradient_x(:,1) = const_plane_x(2:end); 
%         obj.alpha_x_old = obj.alpha_x;
%         obj.alpha_x = - gradient_x / norm(gradient_x);
    
    end
    
    % Deterministic variables
    if pdata.nd > 0
         obj.doe_x = Experiment(obj.nominal_x, obj.DoE_size_d.*Opt_set.ML_scale); %
         A = [ ones( pdata.nd+1,1) (obj.doe_x - obj.nominal_x)' ]; % in x-space!
         
         for ij=1:(pdata.nd+1) % Assumes that the objective is only dependent on probabalistic variables.
            obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, Opt_set, RBDO_s, obj,count, 0);    
         end
         obj.nominal_val = obj.doe_val(1);
         
    end

otherwise
    error('Undefined type in Grad.m')
end

% fit plane, find direction, from nominal point - u-space all but nd.
const_plane = A\obj.doe_val;
gradient(:,1) = const_plane(2:end);
obj.alpha_u = - gradient / norm(gradient);

switch type
    
    case 'variables'
    
    if pdata.nx > 0
       % obj.slope =  obj.alpha_x' * gradient_x; %Slope in x-space
        obj.slope = obj.alpha_u' * gradient; % Slope in u-space
        
        [obj.p_u, obj.p_val] = P_val(obj.doe_u, obj.doe_val,  obj.doe_u(:,1), obj.alpha_u);
        
        obj.p_trial = -obj.nominal_val/obj.slope; % u-space!
        obj.u_trial =  obj.doe_u(:,1) + obj.p_trial*obj.alpha_u;

        
        %alpha_start = Opt_set.dp_x;
        %alpha_start = obj.doe_x(:,1);
        alpha_start =  Opt_set.dp_x;
        %alpha_end = X_space(obj.u_trial, pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1));
        alpha_end = X_space(obj.alpha_u, pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1));
        obj.alpha_x = (alpha_end-alpha_start)/norm(alpha_end-alpha_start); % Vector from dp towards Mpp.
              
        Mpp_x = X_space(obj.u_trial, pdata.marg(:,2) , pdata.marg(:,3),pdata.marg(:,1)); % Temp Mpp!
        obj.lambda =(Mpp_x - Opt_set.dp_x) / norm(Mpp_x - Opt_set.dp_x);
        
        if ~RBDO_s.f_probe % Linear guess is Mpp-guess if no probe
        obj.Mpp_x = Mpp_x;
        obj.Mpp_sx = X_space(obj.u_trial - (obj.alpha_u'*obj.target_beta)', pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1));
        %obj.Mpp_sx = X_space(obj.u_trial - obj.u_trial*obj.target_beta/ norm(obj.u_trial), pdata.marg(:,2) , pdata.marg(:,3), pdata.marg(:,1)); % shifted in u_space!

        obj.Mpp_ud_old =  obj.Mpp_ud; % used for constraint verification.
        obj.Mpp_ud = norm(obj.alpha_u* obj.p_trial);
        

        
        end        
    end
    
    if pdata.nd > 0
        obj.alpha_x = obj.alpha_u;
        obj.slope =  obj.alpha_x' * gradient;
        
        [obj.p_x, obj.p_val] = P_val((obj.doe_x - obj.nominal_x), obj.doe_val,  (obj.doe_x(:,1) - obj.nominal_x(:,1)), obj.alpha_u); % OBS DETTA �R I X_SPACE F�R DETERMINISTISKA DV!
        
        obj.p_trial = -obj.nominal_val/obj.slope; 
        obj.x_trial =  obj.nominal_x(:,1) + obj.alpha_x* obj.p_trial;
        obj.lambda = (obj.x_trial - Opt_set.dp_x) / norm(obj.x_trial - Opt_set.dp_x);
        
        if ~RBDO_s.f_probe % Linear guess is Mpp-guess if no probe
            obj.Mpp_x = obj.x_trial; % (Uses the shifted parameters, ie this one is shifted already..)
            %obj.Mpp_xs = obj.x_trial; % (Uses the shifted parameters)
            obj.Mpp_sx = obj.x_trial;  % 2019-03-08 ?! Correct
            obj.Mpp_ud_old =  obj.Mpp_ud; % used for constraint verification.
            obj.Mpp_ud = norm(obj.alpha_x* obj.p_trial);
            
        end
    end
    
    case 'parameters'
       %obj.alpha_p = X_space(alpha_u, pdata.margp(:,2),pdata.margp(:,3),pdata.margp(:,1));
       obj.Mpp_p = X_space( obj.alpha_u * obj.target_beta, pdata.margp(:,2),pdata.margp(:,3),pdata.margp(:,1));
        
    otherwise
        error('Unknown type in Grad.m')
end

