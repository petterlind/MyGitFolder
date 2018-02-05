f_yt = probdata.marg(1,2);
E = probdata.marg(2,2);
F = probdata.marg(3,2);
P = probdata.marg(4,2);
L = 3.048;

F1 = -P;
F2 = -F;
F3 = 0;
F4 = sqrt(2)*F;
F5 = -F-P;

A1 = sqrt(-F1*4*L^2/(pi*E));
A2 = sqrt(-F2*4*L^2/(pi*E));
A3 = 0.7854e-4;
A4 = F4/f_yt; 
A5 = sqrt(-F5*4*L^2/(pi*E));

A = [A1;A2;A3;A4;A5];

objective = (A1+A2+sqrt(2)*A3+sqrt(2)*A4+A5)*L;