function LS = plotiter(pdata, Opt_set, RBDO_s, LS)

switch RBDO_s.name
    case {'Cheng', 'TANA'}
        
        % Plot DV
        if Opt_set.k>1
            figure(1)
    
            for ij = 1:pdata.nx
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)]./(2.54e-2)^2, '-ok')
            end

            for ij = 1:pdata.nd
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)]./(2.54e-2)^2, '-ok')
            end

            grid on
            xlabel('Iteration number [-]')
            ylabel('Design variable value [in.^2]')
            
            
            
        end
        % Plot fig of trusses
        figure(2)
        try
        t = num2cell(Opt_set.dp_x);
        [A1,A2,A3,A4,A5,A6,A7,A8,A9,A10] = deal(t{:});
        if pdata.np > 0 
            t2 = num2cell(pdata.margp(1:end-1,2));
            [P1,P2] = deal(t2{:});
        else
            P1 = 4.4482e5;
            P2 = P1;
        end
        
        [~,~] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, 1);
        
        catch
        t = num2cell(Opt_set.dp_x);
        [A1,A2,A3] = deal(t{:});
        if pdata.np > 0 
            t2 = num2cell(pdata.margp(1:end-1,2));
            [P1] = deal(t2{:});
        else
            P1 = 4.4482e5;
        end
        
        [~,~] = Cheng3(A1,A2,A3,P1, 1);
            
        end
        % Plot Ls at nominal point!
        if Opt_set.k>1
        
            figure(4)
            for ii = 1:numel(LS)
                G_p = gvalue_fem('variables', LS(ii).nominal_x , pdata, Opt_set, RBDO_s, LS(ii), 0,0);
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [LS(ii).G_p_old, G_p], '-sb')
                LS(ii).G_p_old = G_p;
            end

            grid on
            xlabel('Iteration number [-]')
            ylabel('LS value')
            
        else
            for ii = 1:numel(LS)
                LS(ii).G_p_old = gvalue_fem('variables', LS(ii).nominal_x , pdata, Opt_set, RBDO_s, LS(ii), 0,0);
            end
        end
        
        
        
        
        
        
        otherwise
        % Probably youn choi....

        % Supress warnings
        orig_state = warning;
        warning('off','all');
        sigma = pdata.marg(:,3);
        figure(1)
        hold on

        % Limitstate as function of u1 and u2.
        % g1 = @(u1,u2) (Opt_set.dp_x(2) + sigma(2)*u2) * (Opt_set.dp_x(1) + sigma(1)*u1).^2 / 20 - 1 ;
        % g2 = @(u1,u2) ((Opt_set.dp_x(1) + sigma(1)*u1) + (Opt_set.dp_x(2) + sigma(2)*u2) - 5 )^2 / 30 + ((Opt_set.dp_x(1) + sigma(1)*u1) - (Opt_set.dp_x(2) + sigma(2)*u2) - 12)^2 /120 -1;
        % g3 = @(u1,u2) 80 / ( (Opt_set.dp_x(1) + sigma(1)*u1).^2 + 8 * (Opt_set.dp_x(2) + sigma(2)*u2) + 5) -1;

        g1 = @(mu1,mu2) mu1^2*mu2/20-1;
        g2 = @(mu1,mu2)(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1;
        g3 = @(mu1,mu2) 80/(mu1^2+8*mu2+5)-1;

        %intervall = [-10 4 -10 2];
        intervall = [ 0 10 0 10];
        levels = 0; %linspace(-0.3,0,100);
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

%         % plot the old MPP:s
%         color = {'r*','b*','g*'};
%         for ii = 1:numel(LS)
%             if ~isempty(LS(ii).Mpp_x)
%                 l1 = LS(ii).Mpp_x; 
%                 plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
%                 hold on
%             end
%         end

%         % Plot the old Trial points
%         color = {'ro','bo','go'};
%         for ii = 1:numel(LS)
%             if ~isempty(LS(ii).x_trial)
%                 l1 = LS(ii).x_trial; 
%                 plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
%                 hold on
%             end
%         end
% 
%         % Plot the nominal points
%         color = {'rs','bs','gs'};
%         for ii = 1:numel(LS)
%             if ~isempty(LS(ii).nominal_x)
%                 l1 = LS(ii).nominal_x; 
%                 plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
%                 hold on
%             end
%         end
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

        legend('G(X)_1','G(X)_2','G(X)_3','Location','northeastoutside')


        % plot points
        plot(Opt_set.dp_x(1),Opt_set.dp_x(2),'ok','MarkerSize', 10,'MarkerFaceColor','k')
        grid on
        xlabel('X_1')
        ylabel('X_2')

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
        load LoopYounChoiRes175.mat
        u_div = length(u1_vec);
        
        X = -ones(u_div,u_div).* u1_vec';
        Y = -ones(u_div,u_div).* u2_vec;
        
        contour(X,Y,Loop_res, 'ShowText','on')

        %contourf(X,Y,Loop_res, [23, 25, 26, 33, 43, 53, 54, 55, 56, 63, 64],
        %'ShowText','on') filled!

        % title(sprintf('Linear, function evaluations: g=%d', Gnum))
        % title(sprintf('tol_u = %d, tol_{theta} = %d, experiments: %d,iter: %d ',tolerance_conv ,tol_deg, Gnum, k))
        % title('Horizion point method')

        warning(orig_state);
end

