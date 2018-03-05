function [G, sgn]= gvalue_fem(type, point, probdata, rbdo_parameters, gfundata,constraintNr, flag_count,flag_plot)

global Gnum

if flag_count == 1
    Gnum = Gnum+1;
end

%set the values: X1 =... X2 =..
design_point = rbdo_parameters.design_point;
constraint = gfundata.expression;
nt = constraintNr; 


gfundata.limitstates(constraintNr) = nan;
switch type
    case 'variables'

        % Numer of random parameters
        np = numel(probdata.name);
        for ij = 1:np
            eval( sprintf( '%s =  probdata.p_star(ij,constraintNr);',probdata.name{ij}));
        end 

        % Number of design variables
        nx = numel(gfundata.thetaf);
        for ij = 1:nx
            eval( sprintf( '%s =  point(ij);',gfundata.thetaf{ij}))
        end 
    
    case 'parameters'
        
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

if strcmp(gfundata.type,'TRUSS')

    % set corresponding area
    eval(sprintf(' A = mu%d;',nt));

    if nx ==5
        Ft = Truss_force5(mu1,mu2,mu3,mu4,mu5,F,P,E,nt,flag_plot);

    elseif nx == 10
        Ft = Truss_force10(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,F,P,E,nt,flag_plot);

    elseif nx == 15
        Ft = Truss_force15(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,mu11,mu12,mu13,mu14,mu15,F,P,E,nt,flag_plot);

    elseif nx == 1 
        % Compressive
        Ft = Truss_force_2simple(mu1, -F,-P,E,nt);

        % Tensile
        %Ft = Truss_force_2simple(mu1,F,P,E,nt);
    elseif nx == 2

        Ft = Truss_force_separate(mu1,mu2,-F,P,E,nt);
        %sgn = 2;
    else 
        warning('Number of dv does not match the FEM-call')
    end

    if isnan(gfundata.limitstates(constraintNr))
        if abs(Ft) < 0
            Ft = 0;
            sgn = 1;

        elseif Ft < 0 
            if nt == 3 || nt == 4 || nt == 8 || nt == 9 || nt == 13 || nt == 14 
            sgn = 3;

            elseif nt == 1 || nt == 2 || nt == 5 || nt == 7 || nt == 6 || nt == 10 || nt == 11 || nt == 12 || nt == 8 || nt == 15
            sgn = 2;

            else
                warning('probs in gvalue_fem')
            end

        elseif Ft >= 0
            sgn = 1;

        elseif isnan(Ft)
            fprintf('Ft=nan, nr = %d',nt)
            Ft = 0;
            sgn = 1;
        else
            disp('shit in gvalue_fem?!')
        end
    else
        sgn = gfundata.limitstates(constraintNr);
    end
    G = eval(constraint{sgn});
    
elseif strcmp(gfundata.type,'YounChoi') || strcmp(gfundata.type,'Madsen')
    
    G = eval(constraint{constraintNr});
    sgn = nan;
else
    warning('Unidentified gfundata.type')
end
end
