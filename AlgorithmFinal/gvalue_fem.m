function G = gvalue_fem(type, point, pdata, Opt_set, RBDO_s, obj, f_count, f_plot)
                    
global Gnum
if f_count == 1
    Gnum = Gnum+1;
end

switch type
    case 'variables'
       
        % Numer of random parameters
        for ij = 1:pdata.np
            eval( sprintf( '%s =  obj.Mpp_p(ij);', pdata.name_p{ij}));
        end 

        % Number of probabilistic design variables
        for ij = 1:pdata.nx
            eval( sprintf( '%s =  point(ij);',pdata.name_x{ij}))
        end 
        
        % Number of deterministic design variables
        for ij = 1:pdata.nd
            eval( sprintf( '%s =  point(ij);',pdata.name_d{ij}))
        end 
    
        if pdata.nd >0 && pdata.nx>0
            error('Change the code above, cant be the same values of"point(ij)"!')
        end
        
    case 'parameters'
        
        design_point = Opt_set.dp_x;
        
        for ij = 1:pdata.np
            eval( sprintf( '%s =  point(ij);',pdata.name_p{ij}));
        end 

        % Number of probabilistic design variables
        for ij = 1:pdata.nx
            eval( sprintf( '%s =  design_point(ij);',pdata.name_x{ij}));
        end
        
        % Number of deterministic design variables
        for ij = 1:pdata.nd
            eval( sprintf( '%s =  design_point(ij);',pdata.name_d{ij}));
        end
        
        if pdata.nd >0 && pdata.nx>0
            error('Change the code above, cant be the same values of"point(ij)"!')
        end
end

% Function call
if ~isempty(obj.func)
    eval(sprintf( '%s',obj.func{1}));
end

% Evaluate expression
if ~isempty(obj.expression)
    eval(sprintf('%s',obj.expression{1}))
end


end
