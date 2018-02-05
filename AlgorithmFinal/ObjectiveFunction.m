function c = ObjectiveFunction(points, rbdo_fundata, gfundata)

global Cnum
Cnum = Cnum + 1;

nx = length(points);
cost = rbdo_fundata.cost;

% Set variables equal to points
for ii = 1:nx
    eval( sprintf( '%s =  points(ii);',gfundata.thetaf{ii}));
end

% Function value
c = eval(char(cost));
