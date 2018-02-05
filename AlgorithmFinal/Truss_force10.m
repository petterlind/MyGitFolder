function Ft_nt = Truss_force10(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,F,P,Enum,nt, flag_plot)

% Validation
%Truss_force10(design_point(1),design_point(2),design_point(3),design_point(4),design_point(5),design_point(6),design_point(7),design_point(8),design_point(9),design_point(10),F,P,Enum,nt)



% TEST DATA;

% for ii = 1:15
%     eval(sprintf('A%d=0.7854e-4',ii))
% end
% F = 20e3;
% P = 15e3;
% Enum = 68950e6;
% nt = 15;
% % 
L = 3.048;
%  Definition of Data

%  Nodal Coordinates


Coord = [       L 2*L 0
                0 2*L 0
                L L 0
                0 L 0
                L 0 0
                0 0 0];
%  Connectivity

Con = [ 2 4
    2 1
    2 3
    4 1
    1 3
    6 4
    4 3
    4 5
    6 3
    3 5];

% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord));
Re(:,end)=ones(6,1); % Lås all rörelse i z-led (spelar mindre roll)
Re(6,:) = ones(1,3); % Node 1, locked in all DOF
Re(5,:) = [0 1 1];  % Node 2, locked in all but x.

% Definition of Nodal loads 
Load=zeros(size(Coord));
Load(4,:)=[ F 0 0];
Load(1,:)=[ 0 -P 0];
Load(2,:)=[1.2*F -P 0];

% Definition of Modulus of Elasticity
E=ones(1,size(Con,1))*Enum;
% or:   E=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*1e7;

% Definition of Area
A=[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10];

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');

[Ft,U,~]=ST(D);

Ft_nt = Ft(nt);

% Plot whats going on.
if flag_plot == 1
    TP(D,U,100, Ft) ;
end

end