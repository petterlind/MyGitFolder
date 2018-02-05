function G= gvalue_fem(type, point, probdata, rbdo_parameters, gfundata,constraintNr, flag_count)

global Gnum

%set the values: X1 =... X2 =..
design_point = rbdo_parameters.design_point;
constraint = gfundata.expression;
nt = constraintNr; 

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

% set corresponding area
eval(sprintf(' A = mu%d;',nt));

% Rectangular
%b = sqrt(A);
%I = b^4/12;


%Circular
r = sqrt(A/pi);
I = r^4*pi/4;

% Kraft i truss nummer nt.

if nx ==5
    Ft = Truss_force5(mu1,mu2,mu3,mu4,mu5,F,P,E,nt);
    
    %   Five trusses
    if nt == 1
        sgn = 2;
    elseif nt ==2
        sgn = 2;
    elseif nt == 3 % Special
        sgn = 3;
        %sgn = 1;
    %    if (abs) Ft < 1
    %    Ft = abs(Ft);

    elseif nt == 4
        sgn = 1;
    elseif nt == 5
        sgn = 2;
    end

elseif nx == 10
    Ft = Truss_force10(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,F,P,E,nt);
    
    if nt == 1
        sgn = 1;
    elseif nt ==2
        sgn = 2;
    elseif nt == 3
        sgn = 3;
    elseif nt == 4
        sgn = 1;
    elseif nt == 5
        sgn = 2;
    elseif nt == 6
        sgn = 1;
    elseif nt == 7
        sgn = 2;
    elseif nt == 8 % Special
        sgn = 3;
    elseif nt == 9
        sgn = 1;
    elseif nt == 10
        sgn = 2;
    end
    
elseif nx == 15
    Ft = Truss_force15(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,mu11,mu12,mu13,mu14,mu15,F,P,E,nt);
    
    if nt == 1
    sgn = 1;
    elseif nt ==2
    sgn = 2;
    elseif nt == 3
    sgn = 3;
    elseif nt == 4
    sgn = 1;
    elseif nt == 5
    sgn = 2;
    elseif nt == 6
    sgn = 1;
    elseif nt == 7
    sgn = 1;
    elseif nt == 8 % Special
    sgn = 3;
    elseif nt == 9
    sgn = 1;
    elseif nt == 10
    sgn = 2;
    elseif nt == 11
    sgn = 1;
    elseif nt == 12
    sgn = 2;
    elseif nt == 13 %
    sgn = 3;
    elseif nt == 14
    sgn = 1;
    elseif nt == 15
    sgn = 2;
    end

    
elseif nx == 1 
    % Compressive
    Ft = Truss_force_2simple(mu1, -F,P,E,nt);
    
    % Tensile
    %Ft = Truss_force_2simple(mu1,F,P,E,nt);
elseif nx == 2
    
    Ft = Truss_force_separate(mu1,mu2,-F,-P,E,nt);
    sgn = 2;
else 
    warning('Number of dv does not match the FEM-call')
end


if Ft < 0 
    if nt == 3 || nt == 4 || nt == 8 || nt == 9 || nt == 13 || nt == 14 
    sgn = 3
    
elseif Ft >= 0
    sgn = 1
end



G = eval(constraint{sgn});

if flag_count == 1
    Gnum = Gnum+1;
end
end
