function categoriesPossible=createVectors(complete,groupingVar,varargin)
%creates vector folders from complete struct complete.
%complete(nRow).onset  - onset
%complete(nRow).duration - duration
%complete(nRow).(groupingVar) - integer variable that defines the condition
createFolders = getArgumentValue('createFolders',true,varargin{:});
nParticipant = getArgumentValue('participant',1,varargin{:});
nModel = getArgumentValue('model',1,varargin{:});
task = getArgumentValue('task',nModel,varargin{:});
skipIfEmpty = getArgumentValue('skipIfEmpty',false,varargin{:});
condCatDependent = getArgumentValue('condCatDependent',true,varargin{:});
% prefix = getArgumentValue('prefix',[],varargin{:});
currentFolder = pwd;

categoriesPossible = unique([complete.(groupingVar)]);
runsPossible = unique([complete.run]);
if isstr(nParticipant) %#ok<DISSTR>
    participantFolder = nParticipant;
else
    participantFolder = ['sub',sprintf('%03d',nParticipant)];
end

if createFolders
    if ~exist([pwd,'\DataStruct'],'dir')
        mkdir([pwd,'\DataStruct']);
    end
    cd('DataStruct');
    %folder creation
    mkdir(participantFolder);
    cd(participantFolder);
    mkdir('model')
    cd('model');
    modelFolder = ['model',sprintf('%03d',nModel)];
    mkdir(modelFolder);
    cd(modelFolder);
    mkdir('onsets');
    cd('onsets');
end



for nRun = 1:length(runsPossible)
    run = runsPossible(nRun);
    runFolder = ['task',sprintf('%03d',task),'_run',sprintf('%03d',run)];
    mkdir(runFolder);
    cd(runFolder)
    indx = find([complete.run] == run);
    completeRun = complete(indx); %#ok<FNDSB>
    nCond = 1;
    for nCategory = 1:length(categoriesPossible)

        category = categoriesPossible(nCategory);
        indx2 = find([completeRun.(groupingVar)] == category);
        completoCategory = completeRun(indx2);
        
        for nRow = 1:size(completoCategory,2)
            dataVector(nRow,1) = completoCategory(nRow).onset; %#ok<AGROW>
            dataVector(nRow,2) = completoCategory(nRow).duration; %#ok<AGROW>
            dataVector(nRow,3) = 1; %#ok<AGROW>
        end
        if skipIfEmpty
            if isempty(indx2)
                disp(['Warning: ', runFolder]);
                disp(category)
                continue
            end
        end
        if condCatDependent
            condName = ['cond',sprintf('%03d',nCategory),'.txt'];
        else
            condName = ['cond',sprintf('%03d',nCond),'.txt'];
            nCond = nCond + 1;
        end
        dlmwrite(condName,dataVector,'delimiter','\t');
        clear dataVector
    end
    cd .. %going back to onsets
    
end
cd(currentFolder)
end