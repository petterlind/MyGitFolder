function obj = Grad(obj, pdata, RBDO_s,type)
% Computes gradient for every function
% Uses the coordinates in u-space if the variables are probabalistic.

switch type
case 'parameters'
    
    %fun_val(:,ii) = gvalue_fem('parameters',doe_xp(:,ij), probdata, rbdo_parameters, gfundata, nr, 1,0) 
    error('More code needed in Grad.m')

case 'variables'

    %1)DoE - koshal
    obj.doe_u = Experiment(obj.nominal_u, obj.target_beta/2);
    obj.doe_x = X_space( obj.doe_u, pdata.marg(:,2) , pdata.marg(:,3)); % Transformation back to X-space

    %2)Experiment - in x-space!
    obj.doe_val = nan(pdata.nx+1,1);
    for ij=1:(pdata.nx+1) % Assumes that the objective is only dependent on probabalistic variables.
        obj.doe_val(ij,1) = gvalue_fem('variables', obj.doe_x(:,ij), pdata, RBDO_s, obj, 1,0);    
    end
    obj.nominal_val = obj.doe_val(1);
    A = [ ones( pdata.nx+1,1) (obj.doe_x - obj.nominal_x)' ];

otherwise
    error('Undefined type in Grad.m')

end

%3)fit plane, find direction, from nominal point - x-space
const_plane = A\obj.doe_val;
gradient(:,1) = const_plane(2:end);


switch type
    
    case 'variables'
    obj.alpha_x = - gradient ./ norm(gradient);
    obj.slope =  obj.alpha_x(:,1)' * gradient;
    
    [obj.p_x, obj.p_val] = P_val(obj.doe_x, obj.doe_val, obj);
    obj.p_trial = -obj.nominal_val/obj.slope; % x-space!
    obj.x_trial = obj.nominal_x + obj.p_trial*obj.alpha_x;
    
    case 'parameters'
        error('more code in Grad.m')
        
    otherwise
        error('Unknown type in Grad.m')
end

end


% alpha_vec(abs(alpha_vec)<5e-3) = 0;
% alpha = alpha_vec ./ norm(alpha_vec);

