function [G, sgn]= gvalue_fem(type, point, pdata, RBDO_s, obj, f_count,f_plot)
                    
global Gnum
if f_count == 1
    Gnum = Gnum+1;
end

switch type
    case 'variables'
       
        % Numer of random parameters
        for ij = 1:pdata.np
            eval( sprintf( '%s =  obj.MPP_p(ij);', pdata.name_p{ij}));
        end 

        % Number of design variables
        for ij = 1:pdata.nx
            eval( sprintf( '%s =  point(ij);',pdata.name_x{ij}))
        end 
    
    case 'parameters'
        warning(' Check this code')
        design_point = Opt_set.dp_x;
        
        % Numer of random parameters
        np = numel(probdata.name);
        for ij = 1:np
            eval( sprintf( '%s =  point(ij);',probdata.name{ij}));
        end 

        % Number of design variables
        nx = numel(gfundata.thetaf);
        for ij = 1:nx
            eval( sprintf( '%s =  design_point(ij);',gfundata.thetaf{ij}));
        end 
end

% Function call
if ~isempty(obj.func)
    eval(sprintf( ' F =%s;',obj.func{1}));
end

% Evaluate expression
if ~isempty(obj.expression)
    eval(sprintf(' G = %s;',obj.expression{1}))
end

end
