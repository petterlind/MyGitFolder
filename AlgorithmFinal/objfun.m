function myf = objfun(x)

        % Check if is in file
        % if in file - read that value
        % Else - compute new value
        
        % Load file
        try
        load('input_data.mat','x_data')
        load('input_res.mat','x_res')
        catch
            disp('no input_data.mat, or input_res.mat file')
            x_data = [];
            x_res = [];
        end
        
        % Check if is x_data
        flag_eq = 1;
        flag_end = 1;
        i = 0;
        
        while flag_eq && flag_end && ~isempty(x_data)
            i = i+1;
            xLast = x_data(:,i);
            if isequal(x',xLast)
               flag_eq = 0;
            end
            if i == length(x_data(1,:)) %last position
                flag_end = 0;
            end
        end
             
        if  flag_eq % computation is necessary
            smax = 400e6;
            dmax = 2e-3;
            [myf,myc,myceq] = computeall(x, smax, dmax);
            res = [myf,myc,myceq];
            
            % Save new values
            x_data = [ x_data, x'];
            x_res = [x_res, res'];
            
            save('input_data.mat','x_data')
            save('input_res.mat','x_res')
            
            
        else % no computation
            % load values
            myf = x_res(1,i);          
        end