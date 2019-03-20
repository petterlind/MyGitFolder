function [length_file, G_vec] = length_csv(csv_file, flag_output)

G_vec = nan;
try
    file = csvread(csv_file);
    length_file = numel(file(:,1));
    
    if flag_output
        G_vec = file(end,:);
    end
catch
    % No length! Probably no file...
    length_file = 0;
    warning('no length')
end
