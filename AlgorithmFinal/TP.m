function TP(D,U,Sc,Ft,A)
C=[D.Coord;D.Coord+Sc*U];e=D.Con(1,:);f=D.Con(2,:);
for i=1:6
    M=[C(i,e);C(i,f);repmat(NaN,size(e))];X(:,i)=M(:);    
end
plot3(X(:,4),X(:,5),X(:,6),':m');
hold on
% for ij = 1:length(X(:,1))*3;
%     if norm
n1 = 1;

% Linewidth!
lw_ref = 5*(2.54e-2)^2;

%lw_ref = 7e-4;

for ii = 1:length(Ft)
    
    lw_i = A(ii)/lw_ref;
    
    try
    if Ft(ii) > 0
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'g','LineWidth',lw_i*5);
    
    elseif Ft(ii) < 0
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'r','LineWidth',lw_i*5);
        
    elseif Ft(ii) == 0 || isnan(Ft(ii))
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'k','LineWidth',lw_i*5); 
    else
        warning('probs in TP.m')
    end
    catch
        error('In TP.m')
    end
    n1 = n1+3;
end
axis('equal');

if D.Re(3,:)==1;view(2);end