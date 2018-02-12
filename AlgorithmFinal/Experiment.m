function [position] = Experiment(poi, scale)%, alpha, nr, probdata, rbdo_parameters, gfundata)

% TEST

% poi = [0.7;0.7;0.7]e-4;
% scale = 1;
% alpha = [ 1; 0; 0 ];
% nr = 1;
% probdata


% In x-space.. Otherwise we wouldn't need the scaling \sigma factor.

    %Koshal design
    deltax = [ zeros(1,length(poi))
              eye(length(poi)).* scale];


    % Nx+1 experiments
    position = ones(length(poi)+1,length(poi)).*poi' + deltax; % DoE
   position = position';
    
%     % Koshal plus
%         deltax = [ zeros(1,length(poi))
%               eye(length(poi)).* scale
%               ones(1,length(poi)).*scale];
% 
% 
%     % Nx+1 experiments
%     position = ones(length(poi)+2,length(poi)).*poi'+ deltax; % DoE
%     position = position';
%     
    


% ROTATION
%  y= ones(length(poi),1);
%             % Rotation 
% for ii = 1:length(poi)
%     x= position(:,ii); % Vector som vi vill rotera
%     u=x/norm(x);
%     v=y-u'*y*u;
%     v=v/norm(v);
%     cost=x'*y/norm(x)/norm(y);
%     sint=sqrt(1-cost^2);
%     R = eye(length(x))-u*u'-v*v' + [u v]* [cost -sint;sint cost] *[u v]';
% 
%     fprintf('testing\n');
%     should_be_identity = R*R';
%     should_be_y = R*x;
%     
%     position(:,ii) = R*x
% end

% Rotation 2

% Based on Artivle %Raymond and Beverly Sackler, Rotation designs for
% experiments in high-bias situation



%dCC = ccdesign(3,'type','faced')
% 
% dCC = [ -1 1 -1
%     -1 -1 -1
%     1 -1 -1
%     1 1 -1
%     -1 1 1
%     -1 -1 1
%     1 -1 1
%     1 1 1 ];
%     
% 
% plot3(dCC(:,1),dCC(:,2),dCC(:,3),'ro','MarkerFaceColor','g')
% plot3(dCC(:,1),dCC(:,2),dCC(:,3))
% plot3(position(:,1),position(:,2),position(:,3))
% 
% % X = [1 -1 -1 -1; 1 1 1 -1];
% % Y = [-1 -1 1 -1; 1 -1 1 1];
% % line(X,Y,'Color','b')
% axis square equal



% Hlast =  1/sqrt(2) * [ 1 1; 1 -1];
% for ii = 1:length(poi)-1
%     H = 1/sqrt(2) * [Hlast Hlast; Hlast -Hlast];
%     Hlast = H;
% end

%nx = length(poi);
% % % 

% % % deg = 10;
% % % position_diff = position'-poi;
% % % nx = length(poi);
% % % position_diff = [position_diff; zeros(2^nx-nx,nx+1)];
% % % 
% % % H = (1/(sqrt(2)^nx)) *  hadamard(2^nx);
% % % 
% % % diag_mid = ones(2*2^(nx-1),1);
% % % diag_side = zeros(2*2^(nx-1)-1,1);
% % % diag_side_below = zeros(2*2^(nx-1)-1,1);
% % % diag_side_top = zeros(2*2^(nx-1)-1,1);
% % % 
% % % 
% % % diag_side_below(1:2:end) = diag_side(1:2:end)+ sind(deg);
% % % diag_side_top(1:2:end) = diag_side(1:2:end)+ sind(-deg);
% % % diag_mid = diag_mid*cosd(deg);
% % % 
% % % S = diag(diag_mid) + diag(diag_side_below,-1) + diag(diag_side_top,1);
% % % 
% % % 
% % % delta_rot = position_diff'*H*S*H';
% % % delta_rot = delta_rot(:,1:nx);
% % % position = ones(length(poi)+1,length(poi)).*poi' + delta_rot;
% % % % % % 


% % position = position';
end









