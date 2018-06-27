function position = Experiment(poi, scale)
% Sets up a design of experiment nx+1 number of dv.
try
    %Koshal design
    deltax = [ zeros(1,length(poi))
              eye(length(poi)).* scale];


    % Nx+1 experiments
    position = ones(length(poi)+1,length(poi)).*poi' + deltax; % DoE
   position = position';
catch
    error('In experiment.m')
end
end









