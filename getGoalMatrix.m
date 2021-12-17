function [goalMatrix,propTablePairs] = getGoalMatrix(model,varargin)
%models accepted are: 'VTCmodel' 'VisualFrame1'
getDriveFolder
experiment = getArgumentValue('experiment','Complex',varargin{:});
%assumes that I'm requesting all six runs
runsToDo = getArgumentValue('runN',[], varargin{:}); %if no run is requested, it 
realData = getArgumentValue('realData',false,varargin{:});
nParticipant = getArgumentValue('nParticipant',[],varargin{:});
dataPath = getArgumentValue('dataPath',[driveFolder,'\Results\',experiment,'\RSA\modelsByParticipant'],varargin{:});
specie = getArgumentValue('specie',[],varargin{:});
%variables used for loading existing vector
FSLModel = getArgumentValue('FSLModel',3,varargin{:}); %this is used only when loading or creating, old calls do not use it
task = getArgumentValue('task',1,varargin{:});
av = getArgumentValue('av',0,varargin{:});
r = getArgumentValue('r',3,varargin{:});
saveModel = getArgumentValue('saveModel',true,varargin{:});
varName = getArgumentValue('varName','stim',varargin{:}); %name of variable from propTablePairs to get the indx
runN = getArgumentValue('runN',[],varargin{:});
%others
addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);
addpath([dropboxFolder,'\MVPA\',experiment,'\RSA']);

propTablePairs = getPropTablePairs(runsToDo,'FSLModel',FSLModel); %gets the list of stimuli
goalMatrix = zeros(1,size(propTablePairs,2));
counter = 1;

if realData %data from experiment (real) or else data from model
    if length(nParticipant) > 1
        goalAll = zeros(length(nParticipant).*length(runsToDo),size(propTablePairs,2));
        for nRun = 1:length(runsToDo)
            runN = runsToDo(nRun);
            for n = 1:length(nParticipant)
                participant = nParticipant(n);
                goalMatName = [dataPath,'\',specie,'sub',sprintf('%03d',participant),'run',sprintf('%02d',runN),'_',model,'.mat'];
                disp(goalMatName)
                if exist(goalMatName,'file')
                    mat = load(goalMatName);
                else
                    disp(model)
                    vector = getGoalVectorFromData(experiment,specie,...
                        participant,FSLModel,model,...
                        'saveModel',saveModel,'runN',runN,'av',av,...
                        'task',task,'r',r,'dataPath',dataPath);
                    mat.vector = vector;
                end
                goalMatrix = mat.vector;
                goalAll(counter,:) = goalMatrix;
                counter = counter + 1;
            end
        end
%         size(goalAll)
        goalMatrix = mean(goalAll);
    else
        goalMatName = [dataPath,'\',specie,'sub',sprintf('%03d',nParticipant),'run',sprintf('%02d',runN),'_',model,'.mat'];
        if exist(goalMatName,'file')
            mat = load(goalMatName);
        else
            vector = getGoalVectorFromData(experiment,specie,...
                nParticipant,FSLModel,model,...
                'saveModel',saveModel,'runN',runN,'av',av,...
                'task',task,'r',r);
            mat.vector = vector;
        end
        goalMatrix = mat.vector;
    end
else %data from experiment (real) or else data from model 
    for nRow = 1:size(propTablePairs,2)
        
        stim1 = propTablePairs(nRow).([varName,'1']);
        stim2 = propTablePairs(nRow).([varName,'2']);
        %disp(['stim1: ', num2str(stim1), ' , stim2: ',num2str(stim2)]);
        dissimilarity = getDissimilarity(stim1,stim2,model,'FSLModel',FSLModel,'runN',[]); %gets the dissimilarity according to the model
        
        
        goalMatrix(nRow) = dissimilarity;
    end
end
