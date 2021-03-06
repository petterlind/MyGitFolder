% Monte Carlo
ne = 1e6; % number experiments

% Waitbar
f = waitbar(0,sprintf('Worst %5.2f',0));
w_update = 100/50;

% Given mu and sigma. Sample an array of X nr of utfall
if isempty(pdata.np)
    nv = pdata.nx;
elseif isempty(pdata.nx) || pdata.nx == 0
    nv = pdata.np;
else
    error('No np or nx in Monte_Carlo?')
end

G_mat = nan(numel(LS), ne);
X_mat = nan(nv,ne);

for ih = 1:nv % Prob dv
    if ~isempty(pdata.np)
        if pdata.margp(ih,1) == 1
            pd = makedist('Normal',pdata.margp(ih,2),pdata.margp(ih,3));
        elseif pdata.margp(ih,1) == 2
            mu = log(pdata.margp(ih,2)/(sqrt(1+pdata.margp(ih,3)/pdata.margp(ih,2)^2)));
            sigma = sqrt(log(1+pdata.margp(ih,3)/pdata.margp(ih,2)^2));
            pd = makedist('Lognormal',mu ,sigma);
            
             x =linspace(4.44e5,4.454e5,10000);
             pdf_log =  pdf(pd,x);
            plot(x,pdf_log,'LineWidth',2)
        else
            error('unknown distrubution in Monte_Carlo.m')
        end
    end
    
    if ~isempty(pdata.nx) && pdata.nx ~= 0
        
        if pdata.marg(ih,1) == 1 % Prob dp
            pd = makedist('Normal',Opt_set.dp_x(ih),pdata.marg(ih,3));
            
        elseif  pdata.marg(ih,1) == 2
            
            mu = log(Opt_set.dp_x(ih)/(sqrt(1+pdata.marg(ih,3)^2/Opt_set.dp_x(ih)^2)));
            sigma = sqrt(log(1+pdata.marg(ih,3)^2/Opt_set.dp_x(ih)^2));
            pd = makedist('Lognormal',mu ,sigma);
        else
            error('unknown distrubution in Monte_Carlo.m')
        end 
    end
 
 p = rand(1, ne);
 X_mat(ih,:) = icdf(pd,p);
end


if strcmp(RBDO_s.name,'Cheng')
    
    for ii = 1:ne
        G_mat(:, ii) = gvalue_fem_MC_Truss('parameters', X_mat(:,ii), pdata, Opt_set, RBDO_s, LS, 0, 0);
    % Update waitbar and message
        if ii == w_update
            w_update = w_update + ne/50;
            pf = sum(G_mat< 0 ,2) / ne;
            waitbar(w_update/ne,f,sprintf('Worst %5.5f',max(pf)))
        end
    end
    
else 
    for ii = 1:ne % Trusses can run a single loop here, just rewrite gvalue_fem!
        
        if isempty(pdata.nx)
            for ij = 1:numel(LS)
                G_mat(ij, ii)=  gvalue_fem('parameters', X_mat(:,ii), pdata, Opt_set, RBDO_s, LS(ij), 0, 0);
            end
        elseif isempty(pdata.np)
             for ij = 1:numel(LS)
                G_mat(ij, ii)=  gvalue_fem('variables', X_mat(:,ii), pdata, Opt_set, RBDO_s, LS(ij), 0, 0);
             end    
        end
        
        % Update waitbar and message
        if ii == w_update
            w_update = w_update + ne/50;
            pf = sum(G_mat< 0 ,2) / ne;
            waitbar(w_update/ne,f,sprintf('Worst %5.5f',max(pf)))
        end
    end
end

pf = 100*sum(G_mat< 0 ,2) / ne;

for ik = 1:numel(LS)

    figure
    histogram(G_mat(ik,:));
    title(sprintf('Limitstate %d',ik));
end
delete(f)
