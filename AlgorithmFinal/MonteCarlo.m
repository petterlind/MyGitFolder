% Monte Carlo
ne = 100000; % number experiments

% Waitbar
% f = waitbar(0,sprintf('Worst %5.2f',0));
% w_update = 100/50;

% Given mu and sigma. Sample an array of X nr of utfall
if isempty(pdata.np)
    nv = pdata.nx;
elseif isempty(pdata.nx) || pdata.nx == 0
    nv = pdata.np;
else
    error('No np or nx in Monte_Carlo?')
end

X_mat = nan(nv,ne);

for ih = 1:nv % Prob dv
    if pdata.marg(ih,1) == 1
        pd = makedist('Normal',pdata.marg(ih,2),pdata.marg(ih,3));
    end
 
 
 p = rand(1, ne);
 X_mat(ih,:) = icdf(pd,p);
end

%Write file 50 000 i varje!
dlmwrite('data/MC1.csv', X_mat', 'delimiter', ',', 'precision', 9);
disp('brake')