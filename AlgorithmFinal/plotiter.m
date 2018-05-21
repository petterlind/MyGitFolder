function LS = plotiter(pdata, Opt_set, RBDO_s, LS, Corr)

switch RBDO_s.name
    case {'Cheng', 'TANA'}
        
        % Plot DV
        if Opt_set.k>1
            figure(1)
    
            for ij = 1:pdata.nx
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)], '-ok') %./(2.54e-2)^2
            end

            for ij = 1:pdata.nd
                hold on
                try

                    plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)], '-ok') %./(2.54e-2)^2
                catch
                    error('in Plotiter')
                end
   
            end

            grid on
            xlabel('Iteration number [-]')
            ylabel('Design variable value [in.^2]')
            
            
            
        end
        % Plot fig of trusses
        figure(2)
        clf
            if numel(Opt_set.dp_x) == 10
                t = num2cell(Opt_set.dp_x);
                [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10] = deal(t{:});

                if pdata.np > 0 
                    t2 = num2cell(pdata.margp(1:end-1,2));
                    [P1,P2] = deal(t2{:});
                else
                    P1 = 4.4482e5;
                    P2 = P1;
                end

                clf
                [~,~] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, 1);
                %[~,~] = Aoues(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, 1);
                
            elseif numel(Opt_set.dp_x) == 5
                
                t = num2cell(Opt_set.dp_x);
                [A1,A2,A3,A4,A5] = deal(t{:});
                if pdata.np > 0 
                    t2 = num2cell(pdata.margp(1:end,2));
                    [F,P,~,E] = deal(t2{:});
                else
                    F = 20e3;
                    P = 15e3;
                    E = 68950e6;
                end

                [~,~] = Cheng5(A1,A2,A3,A4,A5,F,P,E,1);
                
            elseif numel(Opt_set.dp_x) == 3
                
                 t = num2cell(Opt_set.dp_x);
                [A1,A2,A3] = deal(t{:});
                if pdata.np > 0 
                    t2 = num2cell(pdata.margp(1:end,2));
                    [P,~,E] = deal(t2{:});
                else
                    %F =
                    P = 15e3;
                    E = 68950e6;
                end
                
                [~,~] = Cheng3(A1,A2,A3,P,1);
                
            else
                error('Number of DV does not match any truss structure. in plotiter.m')
            end
        
        % Plot Ls at nominal point!
        if Opt_set.k>1
        
            figure(4)
            for ii = 1:numel(LS)
                
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [LS(ii).nominal_val_old, LS(ii).nominal_val], '-sb')
            end

            grid on
            xlabel('Iteration number [-]')
            ylabel('LS value')
        end

        otherwise
        % Probably youn choi....

        % Supress warnings
        orig_state = warning;
        warning('off','all');
        sigma = pdata.marg(:,3);
        figure(1)
        hold on

        g1 = @(mu1,mu2) mu1^2*mu2/20-1;
        g2 = @(mu1,mu2)(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1;
        g3 = @(mu1,mu2) 80/(mu1^2+8*mu2+5)-1;

        %intervall = [-10 4 -10 2];
        intervall = [ 0 10 0 10];
        levels = 0; 
        levels2 = linspace(-0.3,0,100);
        fc1 = fcontour(g1, intervall,'LineWidth',4);
        fc1.LevelList = levels; % Possibility to also show gradient here!
        fc1.LineColor = 'red';
        hold on

        fc2 = fcontour(g2, intervall,'LineWidth',4);
        fc2.LevelList = levels; % Possibility to also show gradient here!
        fc2.LineColor = 'blue';

        hold on
        fc3 = fcontour(g3, intervall,'LineWidth',4);
        fc3.LineColor = 'green';
        fc3.LevelList = levels; % Possibility to also show gradient here!
        hold on
        
        % Plot the corr function
        if RBDO_s.f_penal && true
        g4 = @(mu1,mu2) penalfun([mu1;mu2], LS); 
        hold on

        p_size = 100;
        X =linspace(0,10,p_size);
        Y = X;
        Zp1 = nan(p_size,p_size);
        Zp2 = nan(p_size,p_size);
        Xp = nan(p_size,p_size);
        Yp = nan(p_size,p_size);
        for ij = 1:p_size
            for ii = 1:p_size
                
                all_values = g4(X(ii),Y(ij));
                Zp1(ii,ij) = all_values(1);
                Zp2(ii,ij) = all_values(2);
                Xp(ii,ij) = X(ii);
                Yp(ii,ij) = Y(ij);
            end
        end
        
        %Zp(Zp < -0.5  | Zp > 0.5) = nan;
       %Zp1(Zp1 < -1000 | Zp1 > 1000 ) = nan;
       %Zp2(Zp2 < -1 | Zp2 > 1 ) = nan;
        %Zp = Zp/ (max(max(Zp)));
        hold on    
        figure(3)
        clf
        surf(Xp,Yp,Zp1)
        figure(4)
        clf
        hold on
        surf(Xp,Yp,Zp2)
        end
        figure(1)
        
        if RBDO_s.f_corrector
        g4 = @(mu1,mu2) G_ppFUN([mu1;mu2], LS([LS.active]), Corr.In_cor, Corr.lambda, Opt_set, Corr.G_plus); 
        hold on
        
        p_size = 100;
        X =linspace(0,10,p_size);
        Y = X;
        Zp = nan(p_size,p_size);
        Xp = nan(p_size,p_size);
        Yp = nan(p_size,p_size);
        for ij = 1:p_size
            for ii = 1:p_size
                Zp(ii,ij) = g4(X(ii),Y(ij)); 
                Xp(ii,ij) = X(ii);
                Yp(ii,ij) = Y(ij);
            end
        end
        
        %Zp(Zp < -0.5  | Zp > 0.5) = nan;
        Zp(Zp < 0 ) = nan;
        Zp = Zp/ (max(max(Zp)));
        hold on    
        surf(Xp,Yp,Zp)
        end
        
        % plot the MPP:s
        color = {'r*','b*','g*'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).Mpp_x)
                l1 = LS(ii).Mpp_x; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
                hold on
            end
        end

        % Plot the probe points
        color = {'ro','bo','go'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).probe_x_pos)
                l1 = LS(ii).probe_x_pos; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
                hold on
            end
        end
% 
        % Plot the nominal points
        color = {'rs','bs','gs'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).nominal_x)
                l1 = LS(ii).nominal_x; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
                hold on
            end
        end
%         
%         % Plot the old probe points
%         color = {'rd','bd','gd'};
%         for ii = 1:numel(LS)
%             if ~isempty(LS(ii).probe_p)
%                 l1 = LS(ii).probe_p * LS(ii).alpha_x + LS(ii).nominal_x; 
%                 plot(l1(1,1),l1(2,1),color{ii}, 'MarkerSize',20)
%                 hold on
%             end
%         end


        legend('G(X)_1','G(X)_2','G(X)_3','G+','Location','northeastoutside')


        % plot points
        plot(Opt_set.dp_x(1),Opt_set.dp_x(2),'ok','MarkerSize', 10,'MarkerFaceColor','k')
        hold on
        plot(Opt_set.dpl_x(1),Opt_set.dpl_x(2),'ok','MarkerSize', 10)
        grid on
        xlabel('X_1')
        ylabel('X_2')
        
        axis equal
        

        

        %Plot numbers close to points.
        % if k < 4
        %  text(dp(1)-0.5,dp(2)+0.5,num2str(k-1))
        % elseif k == 4
        %     text(dp(1)+0.1,dp(2)+0.5,num2str(k-1))
        %     
        % elseif k == 5
        %     text(dp(1)+0.1,dp(2)-0.5,num2str(k-1))
        % else
        %     warning('more numbers?! in plot_YounChoi.m?')
        % end

        % Plot loop-result
%         load LoopYounChoiRes175.mat
%         u_div = length(u1_vec);
%         
%         X = -ones(u_div,u_div).* u1_vec';
%         Y = -ones(u_div,u_div).* u2_vec;
%         
%         contour(X,Y,Loop_res, 'ShowText','on')

        %contourf(X,Y,Loop_res, [23, 25, 26, 33, 43, 53, 54, 55, 56, 63, 64],
        %'ShowText','on') filled!

        % title(sprintf('Linear, function evaluations: g=%d', Gnum))
        % title(sprintf('tol_u = %d, tol_{theta} = %d, experiments: %d,iter: %d ',tolerance_conv ,tol_deg, Gnum, k))
        % title('Horizion point method')

        warning(orig_state);
end

