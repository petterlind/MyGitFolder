function [x,f,eflag,outpt] = runobjconstr(x0, smax, dmax,opts)


% NOTE NOT USED IN ARTICLE 1 2019-03-05! %

xLast = []; % Last place computeall was called
myf = []; % Use for objective at xLast
myc = []; % Use for nonlinear inequality constraint
myceq = []; % Use for nonlinear equality constraint

fun = @objfun; % the objective function, nested below
cfun = @nonl; % the constraint function, nested below
lb = x0*0.2;
ub = x0*4;
% Call fmincon
[x,f,eflag,outpt] = fmincon(fun,x0,[],[],[],[],lb,ub,cfun,opts);

    function y = objfun(x)
        global xLast
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = computeall(x, smax, dmax);
            xLast = x;
        end
        % Now compute objective function
        y = myf;
    end

    function [c,ceq] = nonl(x)
        global xLast
        if ~isequal(x,xLast) % Check if computation is necessary
            [myf,myc,myceq] = computeall(x, smax, dmax);
            xLast = x;
        end
        % Now compute constraint functions
        c = myc; % In this case, the computation is trivial
        ceq = myceq;
    end

end