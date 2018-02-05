function Ft_nt = Truss_force5(A1,A2,A3,A4,A5,F,P,Enum,nt, flag_plot)


% Test data
% A1 = 7e-4;
% A2 = A1;
% A3 = A1;
% A4 = A1;
% A5 = A1;
% F = 20e3;
% P = F;
% Enum = 68950e6;
% nt = 1;

 %fprintf('Areas are: A2= %1.5f, A4=%1.5f \n',A2, A4);


L = 3.048;
%  Definition of Data

%  Nodal Coordinates

Coord = [   0 0 0
            L 0 0
            0 L 0
            L L 0];
        
%  Connectivity
Con = [ 1 3
        3 4
        3 2
        1 4
        4 2];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord));
Re(:,end)=ones(4,1); % Lås all rörelse i z-led (spelar mindre roll)
Re(1,:) = ones(1,3); % Node 1, locked in all DOF
Re(2,:) = [0 1 1];  % Node 2, locked in all but x.

% Definition of Nodal loads 
Load=zeros(size(Coord));
Load(3,:)=[ F -P 0];
Load(4,:)=[ 0 -P 0];

% Definition of Modulus of Elasticity
E=ones(1,size(Con,1))*Enum;

% Definition of Area
A=[A1, A2, A3, A4, A5];

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');

[Ft,U,~]=ST(D);

Ft_nt = Ft(nt);
if flag_plot == 1
    % Plot whats going on.
    TP(D,U,100, Ft)
end

end