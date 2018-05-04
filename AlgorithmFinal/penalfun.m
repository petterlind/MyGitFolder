function [c, ceq] =  penalfun(x, LS)


list = 1:100;
act_con = list([LS.active]);
c = nan(numel(act_con),1);
ceq = zeros(numel(act_con),1);

%[LS(active).beta_v]
for ii = 1:sum([LS.active])
    
    p = @(x) LS(act_con(ii)).alpha_x'*(x - LS(act_con(ii)).nominal_x);
    Gspline = @(x) LS(act_con(ii)).spline(1) + LS(act_con(ii)).spline(2)* p(x) + LS(act_con(ii)).spline(3)*p(x)^2 + LS(act_con(ii)).spline(4)* p(x).^3;
    Gpenal = @(x) LS(act_con(ii)).c * ( norm( LS(act_con(ii)).lambda'*(x - LS(act_con(ii)).nominal_x)) )^2;
    Gtot = @(x) -Gspline(x) - Gpenal(x);
    
    c(ii) = Gtot(x + LS(act_con(ii)).beta_v );
end

    



% Put up functions
