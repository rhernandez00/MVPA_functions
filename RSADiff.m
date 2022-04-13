function RSADiff(outputFile,experiment,specie,sub,runsToDo,FSLModel,stimType1,stimType2,varargin)
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
rnd = getArgumentValue('rnd',false,varargin{:});
tmpFolder = getArgumentValue('tmpFolder',['D:\Raul\results\',...
    experiment,'\RSADiff\FSLModel',sprintf('%03d',FSLModel)],varargin{:}); %folder to save the results


fileList = cell(length(runsToDo),1);
for nRun = 1:length(runsToDo)
    runN = runsToDo(nRun);
    if rnd
        condTable.cond = shake(condTable.cond);
    end
    finalFile = subRSADiff(experiment,specie,sub,runN,FSLModel,...
        stimType1,stimType2,'condTable',condTable,'filesPath',filesPath,'task',task,'av',av,...
        'rad',rad,'cortex',cortex,'cortexFile',cortexFile,'nanCheck',nanCheck,...
        'nanPercentage',nanPercentage,'SDImg',SDImg,'tmpFolder',tmpFolder);
    fileList{nRun} = [finalFile,'.nii.gz'];
end

meanNiftiFiles(tmpFolder,outputFile,'fileList',fileList,...
    'SDImg',false,'verbose',false,'resultsEnding','');
%cleaning
disp('Cleaning')
for nRun = 1:length(runsToDo)
    deleteFile = [tmpFolder,'\',fileList{nRun}];
    disp(['Deleting...',deleteFile]);
    delete(deleteFile);
end