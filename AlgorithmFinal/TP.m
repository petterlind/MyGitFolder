function TP(D,U,Sc,Ft)
C=[D.Coord;D.Coord+Sc*U];e=D.Con(1,:);f=D.Con(2,:);
for i=1:6
    M=[C(i,e);C(i,f);repmat(NaN,size(e))];X(:,i)=M(:);    
end
figure(4)
plot3(X(:,4),X(:,5),X(:,6),':m');
hold on
% for ij = 1:length(X(:,1))*3;
%     if norm
n1 = 1;
for ii = 1:length(Ft)
    
    if Ft(ii) > 0
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'g','LineWidth',5);
    
    elseif Ft(ii) < 0
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'r','LineWidth',5);
        
    elseif Ft(ii) == 0 || isnan(Ft(ii))
        plot3(X(n1:n1+2,1),X(n1:n1+2,2),X(n1:n1+2,3),'k','LineWidth',5); 
    else
        warning('probs in TP.m')
    end
    n1 = n1+3;
end
axis('equal');

if D.Re(3,:)==1;view(2);end