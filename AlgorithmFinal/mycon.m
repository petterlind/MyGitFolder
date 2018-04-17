function [c,ceq] = mycon(X, pdata, Opt_set, RBDO_s, LS)

global Opt_set LS

ceq = [];
c = nan(numel(LS),1);

for ii = 1:numel(LS)
    c(ii,1) = -gvalue_fem('variables', X, pdata, Opt_set, RBDO_s, LS(ii), 1,0);
end

Opt_set.l = Opt_set.l+1;
if mod(Opt_set.l,11) == 0 % BLIR ALLTID 1
    Opt_set.l = 0;
    Opt_set.k = Opt_set.k + 1;  
    
    Opt_set.dp_x = X;
    clf
    LS = plotiter(pdata, Opt_set, RBDO_s, LS);
    
    %Update
    Opt_set.dp_x_old = Opt_set.dp_x;
end    