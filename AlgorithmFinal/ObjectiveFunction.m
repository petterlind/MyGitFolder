function c = ObjectiveFunction(Opt_set, obj, pdata)

global Cnum
Cnum = Cnum + 1;
points = Opt_set.dp_x;
% Set variables equal to points

for ii = 1:pdata.nx
    eval( sprintf( '%s =  points(ii);',pdata.name_x{ii}));
end

for ij = 1:pdata.nd
    eval( sprintf( '%s =  points(ij);',pdata.name_d{ij}));
end

% Function value
c = eval(obj.expression{1});
