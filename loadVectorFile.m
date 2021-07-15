function condTable = loadVectorFile(filename)

filename = [filename, '.txt'];
delimiter = '\t';

formatSpec = '%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string',  'ReturnOnError', false);

fclose(fileID);
condTable = table(dataArray{1:end-1}, 'VariableNames', {'onset','duration','ones'});
clearvars filename delimiter formatSpec fileID dataArray ans;