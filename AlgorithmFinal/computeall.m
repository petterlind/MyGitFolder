function [obj,c,ceq] = computeall(x,smax, dmax)

all_val = abaqus_beam(x);
obj = all_val(3);
c = [smax, dmax] - all_val(1:2);
ceq = [];