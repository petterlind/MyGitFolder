function G_vec = abaqus_beam(Geom)


% Geom = [h1, h2, h3, h4, w0, w1, w2, w3, w4, l1, l2, l3, l4];

% Write to a csv file
disp('Input data')
disp(Geom)
dlmwrite('data/inputMatlab.csv', Geom, 'delimiter', ',', 'precision', 9);

% check length of input and output files.
[inp_len, ~] = length_csv('data/Input.csv', 0);
[out_len, ~] = length_csv('data/Result.csv', 0);


i = 0;
flag_license = 1;
% Licence error loop
while flag_license
    
    
    try
        if i> 10
            disp('10 trials, stop code')
            disp('ERROR IN LICENCE?')
        elseif i>3
            disp(' More than 3 license loops')
        end
    
        % Run abaqus
        !abaqus cae noGUI=model.py

        % Check if new values are exported back, every other second
        flag_pre = 1;
        k = 0;
        while flag_pre
            [l, ~] = length_csv('data/Input.csv', 0);
            if l > inp_len
                flag_pre = 0;
            elseif k > 10
                error('No input, or mesh')
            else
                pause(1)
            end
            k = k + 1;
        end

        % run odb code
        !abaqus python odbread.py

        % Remove files
        !python remove.py

        % Check if new values are exported back
        flag_post = 1;
        kk = 0;
        while flag_post
            [l, G_vec] = length_csv('data/Result.csv', 1);
            if l > out_len
                flag_post = 0;
                
            elseif kk > 10
                error('No Output')
            else
                pause(1)
            end
            kk = kk + 1;
        end
        flag_license = 0; % STOP LOOP
    
    catch
       pause(1)
       i = i + 1;
        
    end
end


%smth
disp('Stress')
disp(G_vec(1))
disp('Displacement')
disp(G_vec(2))
disp('Volume')
disp(G_vec(3))
