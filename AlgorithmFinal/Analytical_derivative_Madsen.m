% Numerical derivative madsen

% Eq on p 56

% Note, x denotes isoprobabalistic variables!
syms x1 x2 x3 x4 x5 x6 x7

G = 0.3*(1+0.05*x2)*360*(1+0.1*x3)*226e-6*(1+0.05*x4) - (0.5*(1+0.1*x5)*360^2*(1+0.1*x3)^2*226^2*1e-12*(1+0.05*x4)^4)/(0.15*(1+0.05*x6)*40*(1+0.15*x7)) - 0.01*(1+0.3*x1);

alpha = [diff(G,x1)
    diff(G,x2)
    diff(G,x3)
    diff(G,x4)
    diff(G,x5)
    diff(G,x6)
    diff(G,x7)];


alpha_num = eval(subs(subs(subs(subs(subs(subs(alpha,x2,0),x3,0),x4,0),x5,0),x6,0),x7,0));

alpha_norm = alpha_num/norm(alpha_num);