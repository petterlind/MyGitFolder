% Three bar analytical solution using knot-movement-method.


A1 = 1
A2 = 1
A3 = 1

E = 1
L = 1
a = pi/4    %radians;
Px = 1      %Horisontal
Py = 1      %Vertical

A = [   -sqrt(2)*L/(E*A1) 0 0 -sin(a) sin(a)
    0 -L/(E*A2) 0 0 1
    0 0 sqrt(2)*L/(E*A3) sin(a) sin(a)
    cos(a) 1 cos(a) 0 0
    sin(a) -sin(a) 0 0 0];

B = [0;0;0;Py;Px];
    
x = A\B;
