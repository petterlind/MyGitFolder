function [LS, theta] = plotiter(pdata, Opt_set, RBDO_s, LS, theta)
%[LS, theta, P_vec]
switch RBDO_s.name
    case {'Abaqus','Cheng', 'TANA', 'Truss'}
        
        % Plot DV
        if Opt_set.k>1
            figure(1)
    
            for ij = 1:pdata.nx
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)], '-ok', 'HandleVisibility','off') %./(2.54e-2)^2
            end

            for ij = 1:pdata.nd
                hold on
                try
                    plot( [Opt_set.k-1 , Opt_set.k] , [Opt_set.dp_x_old(ij) Opt_set.dp_x(ij)], '-ok', 'HandleVisibility','off') %./(2.54e-2)^2
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
            if numel(Opt_set.dp_x) == 10 && strcmp(RBDO_s.name,'Truss')
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
                [F,~] = Cheng(A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,P1,P2, 1);
                
                F_vec = [LS.nominal_val];
                P_vec = [LS.probe_p];
                
                SF_Min = min(F_vec(F<0));
                TF_Min = min(F_vec(F>0));
                
                SP_Min = max(P_vec(F<0));
                TP_Min = max(P_vec(F>0));
                
                D_Min = LS(1).probe_p;
                P_vec = [SF_Min TF_Min SP_Min TP_Min D_Min];

            elseif numel(Opt_set.dp_x) == 5
                
                t = num2cell(Opt_set.dp_x);
                [A1,A2,A3,A4,A5] = deal(t{:});
                if pdata.np > 0 
                    t2 = num2cell(pdata.margp(1:end,2)); % mean values.
                    [F,P,~,E] = t2{:};
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
                    P = 4.4482e5;
                    %E = 68950e6;
                end
                
                [~,~] = Cheng3(A1,A2,A3,P,1);
                
%             else
%                 error('Number of DV does not match any truss structure. in plotiter.m')
            end
        
        % Plot Ls at nominal point!
        if Opt_set.k>1
        
            figure(4)
            for ii = 1:numel(LS)
                
                hold on
                plot( [Opt_set.k-1 , Opt_set.k] , [LS(ii).nominal_val_old, LS(ii).nominal_val], '-sb')
                LS(ii).nominal_val_old =  LS(ii).nominal_val;
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
        if strcmp(RBDO_s.name, 'Jeong_Park')
            Y = @(mu1,mu2)0.9063*mu1 + 0.4226*mu2 ;
            Z = @(mu1,mu2)0.4226*mu1-0.9063*mu2 ;
            g2 = @(mu1,mu2) -1*(-1+(Y(mu1,mu2)-6)^2+(Y(mu1,mu2)-6)^3-0.6*(Y(mu1,mu2)-6)^4+Z(mu1,mu2));
        else
            g2 = @(mu1,mu2)(mu1+mu2-5)^2/30+(mu1-mu2-12)^2/120-1;
        end
        
        g3 = @(mu1,mu2) 80/(mu1^2+8*mu2+5)-1;

        %intervall = [-10 4 -10 2];
        intervall = [ 3.5 7 0.5 3.5];
        levels = 0; 
        levels2 = linspace(-0.3,0,100);
        fc1 = fcontour(g1, intervall,'LineWidth',4,'HandleVisibility','off');
        fc1.LevelList = levels; % Possibility to also show gradient here!
        fc1.LineColor = 'red';
        hold on

        fc2 = fcontour(g2, intervall,'LineWidth',4,'HandleVisibility','off');
        fc2.LevelList = levels; % Possibility to also show gradient here!
        fc2.LineColor = 'blue';

        hold on
        fc3 = fcontour(g3, intervall,'LineWidth',4,'HandleVisibility','off');
        fc3.LineColor = 'green';
        fc3.LevelList = levels; % Possibility to also show gradient here!
        hold on

        figure(1)

        % Plot the probe points
        color = {'ro','bo','go'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).probe_x_pos)
                l1 = LS(ii).probe_x_pos; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
                hold on
            end
        end
        
%         % Plot shifted MPP
%         color = {'rp','bp','gp'};
%         for ii = 1:numel(LS)
%             if ~isempty(LS(ii).Mpp_sx)
%                 l1 = LS(ii).Mpp_sx; 
%                 plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
%                 hold on
%             end
%         end
        

        

        legend('G(X)_1','G(X)_2','G(X)_3','Location','northeastoutside')
        % Plot the nominal points
        color = {'rs','bs','gs'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).nominal_x)
                l1 = LS(ii).nominal_x; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',20)
                hold on
            end
        end
        
        % Plot text next to point
        r = 0.2;
        
        if ~isempty(Opt_set.dp_x_old)
            if norm(Opt_set.dp_x_old - Opt_set.dp_x)< 2*r
                theta = theta - 35;
            else
                theta = 110;
            end
        end
        

       plot(Opt_set.dp_x(1),Opt_set.dp_x(2),'ok','MarkerSize', 10)
        text(Opt_set.dp_x(1)+r*cosd(theta),Opt_set.dp_x(2)+r*sind(theta),num2str(Opt_set.k))

        grid on
        xlabel('X_1')
        ylabel('X_2')
         
        % plot the MPP:s
        color = {'r*','b*','g*'};
        color2 = {'r','b','g'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).Mpp_x) && LS(ii).nr ~=3
                l1 = LS(ii).Mpp_x; 
                plot(l1(1,:),l1(2,:),color{ii}, 'MarkerSize',10, 'HandleVisibility','off')
                text(l1(1,:)+r*cosd(theta),l1(2,:)+r*sind(theta),num2str(Opt_set.k),'Color',color2{ii})
                hold on
            end
        end
        
        % Plot direction cosines.
        color = {'r','x','g'};
        for ii = 1:numel(LS)
            if ~isempty(LS(ii).alpha_x)
                l1 = LS(ii).nominal_x; 
                l2 = LS(ii).alpha_x;
                %plot( l1', l1'+l2' ,color{ii}, 'MarkerSize',5)
                quiver( l1(1,:), l1(2,:), l2(1,:), l2(2,:),0);
                hold on
            end
        end

        axis equal
        warning(orig_state);
end

