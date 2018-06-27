function [F, U] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, flag_plot)



% t = num2cell(pdata.marg(:,2));
% %t = num2cell(optimum);
% [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10] = deal(t{:});
% 
% t2 = num2cell(pdata.margp(1:end-1,2));
% [P1,P2] = deal(t2{:});
% 
% [F, U] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, 6.895e10, 1)

Enum = 6.895e10; %CHENG and TANA!

L = 9.144;

Coord = [ L 2*L 0
    0 2*L 0
    L L 0
    0 L 0
    L 0 0
    0 0 0];
%  Connectivity

% Con = [ 5 3
%     3 1
%     6 4
%     4 2
%     1 2
%     4 3
%     6 3
%     5 4
%     2 3
%     1 4];
Con = [ 6 4
    4 2
    5 3
    3 1
    3 4
    1 2
    6 3
    5 4
    4 1
    3 2];


% Definition of Degree of freedom (free=0 &  fixed=1); for 2-D trusses the last column is equal to 1
Re=zeros(size(Coord));
Re(:,end)=ones(6,1); % Lås all rörelse i z-led (spelar mindre roll)
Re(6,:) = ones(1,3); % Node 1, locked in all DOF
Re(5,:) = ones(1,3);  % Node 2, locked in all DOF.

% Definition of Nodal loads 
Load=zeros(size(Coord));
Load(1,:)=[ P1 0 0];
Load(3,:)=[ P2 0 0];


% Definition of Modulus of Elasticity
E=ones(1,size(Con,1))*Enum;
% or:   E=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1]*1e7;

% Definition of Area
%syms A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 'positive'
A=[A1, A2, A3, A4, A5, A6, A7, A8, A9, A10];

% Convert to structure array
D=struct('Coord',Coord','Con',Con','Re',Re','Load',Load','E',E','A',A');
[F,U,~]=ST(D);

% Plot whats going on.
if flag_plot == 1
    TP(D,U,100,F,A);
end

% failsafe
F(abs(F)<1e-3) = 0;
end