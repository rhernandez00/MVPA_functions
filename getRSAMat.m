function map = getRSAMat(matFilesPath,fileNameBase,specie,categories,varargin)
experiment = getArgumentValue('experiment','Complex',varargin{:});
indxToKeep = getArgumentValue('indxToKeep',[],varargin{:});
filesPath = getArgumentValue('filesPath',['D:\Raul\results\',experiment,'\RSA',specie],varargin{:});

% filesPath = ['D:\Raul\results\',project,'\RSA',specie];

if exist([matFilesPath,'\FSL_',fileNameBase,'.mat']) %#ok<EXIST>
    disp(['FSL_',fileNameBase, ' exist, loading...']);
    load([matFilesPath,'\FSL_',fileNameBase,'.mat']); %#ok<LOAD>
elseif exist([matFilesPath,'\',fileNameBase,'.mat']) %#ok<EXIST>
    disp([fileNameBase, ' exist, loading...']);
    load([matFilesPath,'\',fileNameBase,'.mat']); %#ok<LOAD>
else
    disp([matFilesPath,'\',fileNameBase,'.mat'])
    disp(' does not exist creating...');
    try
        fileName = [filesPath,'\FSL_',fileNameBase];
        disp(fileName)
        disp('File not found, checking under different name')
        map = combineFilesVector(fileName,categories);
    catch
        disp('File not found, checking under different name')
        fileName = [filesPath,'\',fileNameBase];
        disp(fileName)
        map = combineFilesVector(fileName,categories);
    end
        
    if ~exist(matFilesPath)
        mkdir(matFilesPath)
    end
    save([matFilesPath,'\',fileNameBase,'.mat'],'map','-v7.3');
    disp([fileNameBase, ' saved']);
end
if isempty(indxToKeep)
    return
else
    disp(['Requested to keep ', num2str(sum(indxToKeep)), ' out of ', num2str(size(map,2))]);
    map = map(:,indxToKeep);
    
end

