function Gvec = gvalue_fem_mc(type, point, probdata, rbdo_parameters, gfundata, flag_count,flag_plot)

global Gnum
design_point = rbdo_parameters.design_point;
constraint = gfundata.expression;

switch type
    case 'variables'

        % Numer of random parameters
        np = numel(probdata.name);
        for ij = 1:np
            eval( sprintf( '%s =  probdata.p_star(ij);',probdata.name{ij}));
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


    if nx ==5
        Ft = Truss_force5_mc(mu1,mu2,mu3,mu4,mu5,F,P,E,flag_plot);

    elseif nx == 10
        Ft = Truss_force10_mc(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,F,P,E,flag_plot);

    elseif nx == 15
        Ft = Truss_force15_mc(mu1,mu2,mu3,mu4,mu5,mu6,mu7,mu8,mu9,mu10,mu11,mu12,mu13,mu14,mu15,F,P,E,flag_plot);
    else 
        warning('Number of dv does not match the FEM-call')
    end

   
    
F_vec = Ft;
Gvec = nan(nx,1);
for nt = 1:nx
    % set corresponding area
    eval(sprintf(' A = mu%d;',nt));
    Ft = F_vec(nt);
    
    % Determine sgn from Ft
%     if abs(Ft) < 1
%         Ft = 0;
%         sgn = 1;
% 
%     elseif Ft < 0 
%         if nt == 3 || nt == 4 || nt == 8 || nt == 9 || nt == 13 || nt == 14 
%         sgn = 3;
% 
%         elseif nt == 1 || nt == 2 || nt == 5 || nt == 7 || nt == 6 || nt == 10 || nt == 11 || nt == 12 || nt == 8 || nt == 15
%         sgn = 2;
% 
%         else
%             warning('probs in gvalue_fem')
%         end
% 
%     elseif Ft >= 0
%         sgn = 1;
% 
%     elseif isnan(Ft)
%         Ft = 0;
%         sgn = 1;
%     else
%         disp('shit in gvalue_fem?!')
%     end

    % Determine sgn from nominal position
    if nt == 1 || nt ==4 || nt ==6 || nt == 7 || nt == 9 || nt == 11 || nt==14
        sgn = 1;
    elseif nt == 2 || nt == 5 || nt == 10|| nt== 12 || nt == 15
        sgn = 2;
    elseif nt == 3 || nt == 8 || nt == 13
        sgn = 3;
    else 
        warning('smth off with the sgn hack in gvalue_fem_mc')
    end
    
    
    G = eval(constraint{sgn});
    Gvec(nt,1) = G;
end

if flag_count == 1
    Gnum = Gnum+1;
end
end
