function data = loadSimpleCSV2(filename)
%% Import data from text file.
% Script for importing data from the following text file:
%
%    C:\Users\Hallgato\Dropbox\IPython Notebooks\PyMVPA\dogsSonrisasMVPArev.csv
%
% To extend the code to different selected data or a different text file,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2018/07/25 15:14:12

%% Initialize variables.
filename = [filename,'.csv'];%'C:\Users\Hallgato\Dropbox\IPython Notebooks\PyMVPA\dogsSonrisasMVPArev.csv';
delimiter = ',';
startRow = 2;

%% Format for each line of text:
%   column1: double (%f)
%	column2: double (%f)
%   column3: double (%f)
%	column4: double (%f)
%   column5: categorical (%C)
%	column6: categorical (%C)
%   column7: double (%f)
%	column8: categorical (%C)
%   column9: double (%f)
%	column10: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%f%f%f%C%C%f%C%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
VarName1 = dataArray{:, 1};
AlphaANOVA = dataArray{:, 2};
Averarger = dataArray{:, 3};
HemoCor = dataArray{:, 4};
Mask = dataArray{:, 5};
MaskType = dataArray{:, 6};
MeanPerf = dataArray{:, 7};
RemovedCats = dataArray{:, 8};
Subject = dataArray{:, 9};
VoxelsN = dataArray{:, 10};


%% Clear temporary variables
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

for j = 1:length(AlphaANOVA)
    
    data(j).AlphaANOVA = AlphaANOVA(j);
    data(j).Mask = Mask(j);
    data(j).MaskType = MaskType(j);
    data(j).MeanPerf = MeanPerf(j);
    data(j).Model = RemovedCats(j);
    data(j).Averarger = Averarger(j);
    data(j).HemoCor = HemoCor(j);
    data(j).Subject = Subject(j);

end