function T = getModel(experiment,FSLModel)
%Loads the conditions for a given FSLModel as listed in condition_key. 
%Gives back a table with:
% number. Number of repetition assigned to the condition
% stim. stimuli type as string
% stimType. stimuli number according to the order it appears in the file
getDriveFolder;
filePath = [dropboxFolder,'\MVPA\',experiment,...
    '\DataStruct\models\model',sprintf('%03d',FSLModel),...
    '\condition_key.txt'];


fid = fopen(filePath); %opens condition_key.txt
try
    tline = fgetl(fid);
catch
    if exist(filePath,'file')
        error('Failed to get a line from the file');
    else
        error(['File not found: ',filePath]);
    end
end
%some variables to initialize
condition = cell(1);
number = [];
n = 1;
prevCond = '';
stimNum = 0;
while ischar(tline)
    nChar = strfind(tline,'cond'); %finds cond to figure out where the text begins
    conditionLine =tline(nChar+8:end); 
    number(n) = str2double(conditionLine(1:2));%reads the repetition number
    newCond = conditionLine(3:end); %gets the condition name
    stimNum = stimNum + ~strcmp(prevCond,newCond); %checks if the condition is new
    condList(n) = stimNum; %assigns the condition number according to the order
    condition{n} = newCond;
    prevCond = newCond;
    n = n+1;
    tline = fgetl(fid);
end
fclose(fid);

%creates table to output
condNum = [0:numel(number)-1]';
T = table(number',condition',condList',condNum,'VariableNames',{'rep','stim','stimType','cond'});