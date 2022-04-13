function [finalFile] = subRSADiff(experiment,specie,sub,runN,FSLModel,stimType1,stimType2,varargin)
%Calculates the difference in dissimilarity of a stimuli type (stimType1) and its
%control (stimType2). This means difference between the average of every 
%stimType1-stimType1 and stimType1-stimType2.

%stimType1 is the stimuli type of interest
%stimType2 stimuli used as control
getDriveFolder;
condTable = getArgumentValue('condTable',[],varargin{:}); %table with conditions from conditions_key.txt
if isempty(condTable)
    condTable = getModel(experiment,FSLModel);
end
filesPath = getArgumentValue('filesPath',['D:\Raul\results\',...
    experiment,'\RSA',specie],varargin{:}); %path with the dissimilarity files
task = getArgumentValue('task',1,varargin{:});
av = getArgumentValue('av',3,varargin{:});
rad = getArgumentValue('rad',3,varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:}); %filter out using cortexFile?
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
nanCheck = getArgumentValue('nanCheck',false,varargin{:}); %check if the files have nan
nanPercentage = getArgumentValue('nanPercentage',0.1,varargin{:});%percentaje of nan's allowed before giving error
SDImg = getArgumentValue('SDImg',false,varargin{:}); %output std image?
% outputFolder = getArgumentValue('outputFolder',[driveFolder,'\Results\',...
%     experiment,'\RSADiff\FSLModel',sprintf('%03d',FSLModel)],varargin{:}); %folder to save the results
tmpFolder = getArgumentValue('tmpFolder',['D:\Raul\results\',...
    experiment,'\RSADiff\FSLModel',sprintf('%03d',FSLModel)],varargin{:}); %folder to save the results

%Creating a 2 lists that will contain the name of files to be used in the
%operation
stimType1List = find(condTable.stimType == stimType1); %checks the table to find all the repetitions of stimType1
stimType2List = find(condTable.stimType == stimType2); %checks the table to find all the repetitions of stimType2
numberOfFiles = numel(stimType1List);
pairs = combinator(numberOfFiles,2,'c'); %creates a list of possible combinations
type1List = cell(size(pairs,1),1);
for nPair = 1:size(pairs,1)
    n1 = pairs(nPair,1);%selects first element of the pair
    n2 = pairs(nPair,2);%selects second element of the pair
    stim1A = stimType1List(n1);%checks the list and selects the number in the table
    stim1B = stimType1List(n2);
    
    cond1 = condTable.cond(stim1A); %selects the condition from the table T
    cond2 = condTable.cond(stim1B); 
    
    if cond1 < cond2 %check the correct order of the conditions (there is a single file for each pair, so the order is important)
        conditionString = [sprintf('%03d',cond1),'_',sprintf('%03d',cond2),'.nii.gz'];
    else
        conditionString = [sprintf('%03d',cond2),'_',sprintf('%03d',cond1),'.nii.gz'];
    end
    fileName = ['FSL_task',num2str(task),'model',sprintf('%02d',FSLModel),'av',...
        num2str(av),'r',num2str(rad),'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),'_',...
        conditionString];
    type1List{nPair} = fileName;
end
type12List = cell(numel(stimType1List)*numel(stimType2List),1);
n = 1;
for n1 = 1:numel(stimType1List)
    stim1 = stimType1List(n1);
    cond1 = condTable.cond(stim1);
    for n2 = 1:numel(stimType2List)
        stim2 = stimType2List(n2);
        cond2 = condTable.cond(stim2);
        if cond1 < cond2 %check the correct order of the conditions (there is a single file for each pair, so the order is important)
            conditionString = [sprintf('%03d',cond1),'_',sprintf('%03d',cond2),'.nii.gz'];
        else
            conditionString = [sprintf('%03d',cond2),'_',sprintf('%03d',cond1),'.nii.gz'];
        end
        fileName = ['FSL_task',num2str(task),'model',sprintf('%02d',FSLModel),'av',...
        num2str(av),'r',num2str(rad),'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),'_',...
        conditionString];
        type12List{n} = fileName;
        n = n + 1;
    end
end

if ~exist(tmpFolder,'dir') %creates output folder
    mkdir(tmpFolder);
end
%creating average for type11List
fileOut1 = ['task',num2str(task),'model',sprintf('%02d',FSLModel),'av',...
        num2str(av),'r',num2str(rad),'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),'_',...
        sprintf('%03d',stimType1),'_',sprintf('%03d',stimType1)];
disp('Files in list stim1-stim1');
meanNiftiFiles(filesPath,[tmpFolder,'\',fileOut1],'fileList',type1List,'cortex',cortex,...
    'cortexFile',cortexFile,'nanCheck',nanCheck,...
    'nanPercentage',nanPercentage,'SDImg',SDImg,'verbose',false);

%creating average for type12List
fileOut2 = ['task',num2str(task),'model',sprintf('%02d',FSLModel),'av',...
        num2str(av),'r',num2str(rad),'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),'_',...
        sprintf('%03d',stimType1),'_',sprintf('%03d',stimType2)];
disp('Files in list stim1-stim2');
meanNiftiFiles(filesPath,[tmpFolder,'\',fileOut2],'fileList',type12List,'cortex',cortex,...
    'cortexFile',cortexFile,'nanCheck',nanCheck,...
    'nanPercentage',nanPercentage,'SDImg',SDImg,'verbose',false);

%Calculating difference
nii1 = load_untouch_niiR([tmpFolder,'\',fileOut1,'_mp.nii.gz']);
nii2 = load_untouch_niiR([tmpFolder,'\',fileOut2,'_mp.nii.gz']);
imgOut = nii1.img;
imgOut(:) = 0;
for nVox = 1:numel(nii1.img(:))
    imgOut(nVox) = nii1.img(nVox) - nii2.img(nVox);
end
nii1.img = imgOut;
%cleaning up
delete([tmpFolder,'\',fileOut1,'_mp.nii.gz']);
delete([tmpFolder,'\',fileOut2,'_mp.nii.gz']);

%saving final file
finalFile = ['task',num2str(task),'model',sprintf('%02d',FSLModel),'av',...
        num2str(av),'r',num2str(rad),'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),'_',...
        sprintf('%03d',stimType1),'vs',sprintf('%03d',stimType2)];
save_untouch_nii(nii1,[tmpFolder,'\',finalFile,'.nii.gz']);
disp([finalFile,' saved']);