function [c, ceq] = G_ppFUN(x, LS, In_cor, lambda, Opt_set, G_plus)

% Shiftad en sträcka beta_v?!

ceq = 0;
p = @(x) LS(In_cor).alpha_x'*(x - LS(In_cor).nominal_x);
Gspline = @(x)  LS(In_cor).spline(1) + LS(In_cor).spline(2)* p(x) + LS(In_cor).spline(3)*p(x)^2 + LS(In_cor).spline(4)* p(x).^3;
%Gplane = @(x) (G_plus - LS(In_cor).probe_val) / ( lambda'*(Opt_set.dpl_x - LS(In_cor).probe_x_pos)) *(lambda' * (x - LS(In_cor).probe_x_pos));
Gplane = @(x) (G_plus - LS(In_cor).nominal_val) / ( lambda'*(Opt_set.dpl_x - LS(In_cor).nominal_x)) *(lambda' * (x - LS(In_cor).nominal_x));
c = -Gspline(x) -Gplane(x);