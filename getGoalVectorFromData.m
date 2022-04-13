function vector = getGoalVectorFromData(experiment,specie,participant,FSLModel,regionModel,varargin)
getDriveFolder;
dataPath = getArgumentValue('dataPath',[driveFolder,'\Results\',experiment,'\RSA\modelsByParticipant'],varargin{:});
saveModel = getArgumentValue('saveModel',true,varargin{:});
runN = getArgumentValue('runN',0,varargin{:});
task = getArgumentValue('task',1,varargin{:});
av = getArgumentValue('av',0,varargin{:});
r = getArgumentValue('r',3,varargin{:});

categories = getCategories(experiment,FSLModel); %gets number of categories
% gets a set of coordinates, these are coordinates of interest
disp(regionModel)
[~,flatCoord] = getCoordsOfInterest(regionModel,'specie',specie,'experiment',experiment);

matFilesPath = ['D:\Raul\results\',experiment,'\RSAmat\',specie];
fileNameBase = ['task',num2str(task),'model',sprintf('%02d',FSLModel),'av',num2str(av),...
            'r',num2str(r),'sub',sprintf('%03d',participant),'run',sprintf('%02d',runN)];
mapI = getRSAMat(matFilesPath,fileNameBase,specie,categories,'project',experiment);

goalMatrix = zeros(length(flatCoord),size(mapI,2));
for nCoord = 1:length(flatCoord)
    flat = flatCoord(nCoord);
    goalVector = mapI(flat,:);
    goalMatrix(nCoord,:) = goalVector;
end
if length(flatCoord) > 1
    vector = mean(goalMatrix);
else
    vector = goalMatrix; 
end

modelFileName = [dataPath,'\',specie,'sub',sprintf('%03d',participant),'run',sprintf('%02d',runN),'_',regionModel,'.mat'];
if saveModel
    save(modelFileName,'vector');
    disp([modelFileName, ' saved']);
end