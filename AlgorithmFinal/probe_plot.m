% Produce probe plot - or probe plot constants.


% skala 1:5
obj1 = Limitstate;
obj2 = Limitstate;
obj3 = Limitstate;

obj1.p_x = 1;
obj1.p_val = 3; 
obj1.probe_p = 2;
obj1.probe_val = 1;
obj1.slope = -3; 

obj2.p_x = 1;
obj2.p_val = 3; 
obj2.probe_p = 2;
obj2.probe_val = -1;
obj2.slope = -3; 

obj3.p_x = 1;
obj3.p_val = 3; 
obj3.probe_p = 2;
obj3.probe_val = 0;
obj3.slope = -3; 

[obj1.spline, obj1.probe_s] = spline(obj1, 1);
[obj2.spline, obj2.probe_s] = spline(obj2, 1);
[obj3.spline, obj3.probe_s] = spline(obj3, 1);


p_spline(obj1, pdata, Opt_set, RBDO_s)
hold on
p_spline(obj2, pdata, Opt_set, RBDO_s)
hold on
p_spline(obj3, pdata, Opt_set, RBDO_s)
  
  
