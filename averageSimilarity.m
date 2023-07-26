function outputFile = averageSimilarity(specie,FSLModel,experiment,analysisName,analysisLevel,varargin)
%This function generates an average of the correlations/dissimilarities
%between stimuli pairs for a determined class.
%The function can be run in two levels (analysisLevel):
% byRun: average all pairs within a run for each individual
% byIndividual: averages all runs for a individual
% bySubstractionSub: substracts the average by participant of one class to another class
% byClass: generates an average across participants for a given class
% bySubstraction: calculates difference between classes
% meanDistribution: %generates the distribution based on the permutations of the comparisons
%The function requires a xlsx file with a sheet for classes and comparisons and a function addDataToInfoTable
%Author: Raul Hernandez 02/June/2023
outputFile = [];
resultsPath = getArgumentValue('resultsPath','D:\Raul\results',varargin{:}); %folder outside the cloud for quick access
rad = getArgumentValue('rad',3,varargin{:}); %radius of the searchlight
filesFolder = [resultsPath,'\',experiment,'\RSA',specie];
fileBaseName = ['FSL_task1model',sprintf('%02d',FSLModel),'av0r',...
            num2str(rad)];
cortex = getArgumentValue('cortex',false,varargin{:}); %filter results using mask?
cortexFile = getArgumentValue('cortexFile',[],varargin{:});
nReps = getArgumentValue('nReps',25,varargin{:}); %number of repetitions for permutations
rnd = getArgumentValue('rnd',false,varargin{:}); %run permutations?
runsStruct = getArgumentValue('runsStruct',[],varargin{:}); %structure with runs available to use. 
%The index corresponds to the participant number, meaning that data from participant 5 is in index 5, and has a field 'runsAvailable'
runsPossible = getArgumentValue('runsPossible',[],varargin{:}); %runs to analyze
if isempty(runsPossible) && strcmp(analysisLevel,'byRun')
    error('Must provide runsPossible for analysisLevel byRun');
end
classesToRun = getArgumentValue('classesToRun',[],varargin{:}); %classes to analyze
if isempty(classesToRun) && (strcmp(analysisLevel,'byIndividual')||strcmp(analysisLevel,'byRun')||strcmp(analysisLevel,'byClass'))
    error('Must provide classesToRun');
end
subsPossible = getArgumentValue('subsPossible',[],varargin{:}); %participants to analyze
if isempty(subsPossible)
    if ~(strcmp(analysisLevel,'bySubstraction') || strcmp(analysisLevel,'meanDistribution'))
        error('must provide subsPossible');
    end
end

if isempty(cortexFile) %if no cortexFile is given, will use fullBrain as default
    switch specie
        case 'D'
            cortexFile = 'D_fullBrain';
        case 'H'
            cortexFile = 'H_fullBrain';
        otherwise
            error('Wrong specie');
    end
end
driveFolder = getArgumentValue('driveFolder',[],varargin{:}); %path where experiments are saved
if isempty(driveFolder)
    getDriveFolder;
end
analysisTablePath = [driveFolder,'\',experiment,'\RSA\',analysisName,'.xlsx'];
classes = readtable(analysisTablePath,'sheet','classes');
comparisons = readtable(analysisTablePath,'sheet','comparisons');

switch analysisLevel
    case 'byRun' %averages all dissimilarities in one run
        for nRun = 1:length(runsPossible)
            runN = runsPossible(nRun);
            [~,~,options] = getStimType(experiment,FSLModel,runN,1);
            categories = options.totalStims;
            pairs = combinator(categories,2,'c');
            stim1 = pairs(:,1);
            stim2 = pairs(:,2);
            infoTable = table(stim1,stim2); %infoTable will contain all the stimuli pairs and data about their interaction (same/different category, etc)

            infoTable = addDataToInfoTable(infoTable,runN,experiment,FSLModel); %adds information to infoTable. This function is specific for each experiment
            infoTable = addClassesToInfoTable(classes,infoTable); %adds the classes. Uses a general function found in MVPA_functions from github

            for nSub = 1:length(subsPossible)
                sub = subsPossible(nSub);
                if isempty(runsStruct)
                    runsAvailable = checkRunsAvailable(sub,specie,experiment);
                else
                    runsAvailable = runsStruct(sub).runsAvailable;
                end
                if ~ismember(runN,runsAvailable)
                    disp(['Run ', num2str(runN), 'not available for participant ',num2str(sub),' skipping']);
                    continue
                end
                for rndNum = 1:nReps
                    for nClass = 1:numel(classesToRun)
                        currentClass = classesToRun{nClass};
                        outputName = ['sub',sprintf('%03d',sub),'run',sprintf('%02d',runN)];

                        infoTable.use = infoTable.(currentClass);
                        %infoTable  = splitInfoTable(infoTable,nGroup,combType);

                        if rnd %true - randomize infoTable for permutation testing
                            infoTable.use = shake(infoTable.use);
                            outputName = [outputName,'_',sprintf('%03d',rndNum)]; %#ok<AGROW>
                            if rndNum > nReps
                                rndNum = 1; %#ok<FXSET>
                                break
                            end
                        else
                            if rndNum > 1 %#ok<*UNRCH>
                                disp(['rndNum is: ',num2str(rndNum), 'breaking'])
                                break
                            end
                        end

                        if rnd

                            saveFolder = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                                specie,'\',currentClass,'\sub',sprintf('%03d',sub)];   
                        else
                            saveFolder = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                            specie,'\',currentClass,'\sub',sprintf('%03d',sub)];
                        end

                        disp(['rndNum is: ',num2str(rndNum)])
                        infoTableF = infoTable(logical(infoTable.use),:);

                        fileList = cell(size(infoTableF,1),1);
                        for nRow = 1:size(infoTableF,1)
                            stim1 = infoTableF.stim1(nRow) - 1;
                            stim2 = infoTableF.stim2(nRow) - 1;
                            fileName = [fileBaseName,'sub',sprintf('%03d',sub),'run',sprintf('%02d',runN),...
                            '_',sprintf('%03d',stim1),'_',sprintf('%03d',stim2),'.nii.gz'];
                            fileList{nRow} = fileName;
                        end
                        if ~exist(saveFolder,'dir')
                            mkdir(saveFolder);
                        end
                        if exist([saveFolder,'\',outputName,'_mp.nii.gz'],'file')
                            disp([saveFolder,'\',outputName,'_mp.nii.gz exist, skipping...'])
                        else
                            meanNiftiFiles(filesFolder,[saveFolder,'\',outputName],...
                                'fileList',fileList,'cortex',cortex,'cortexFile',cortexFile);
                        end

                    end
                end
            end
        end

    case 'byIndividual' %averages all runs for a individual

        for nSub = 1:length(subsPossible)
            sub = subsPossible(nSub);
            disp(['Analyzing sub', sprintf('%03d',sub),'. , ', num2str(nSub), ' out of ', num2str(length(subsPossible))]);
            for rndNum = 1:nReps
                if ~rnd %if this is not a permutation break after 1 repetition
                    if rndNum > 1
                        break
                    end
                end
                for nClass = 1:numel(classesToRun)
                    currentClass = classesToRun{nClass};
                
                    if rnd
                        savePath = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                            specie,'\',currentClass,'\sub',...
                            sprintf('%03d',sub)];

                        fileListFull = getFileListOnly(savePath,'fileStart',['sub',sprintf('%03d',sub)],'fileEnding','_mp');
                        fileList = getSubListByPerm(fileListFull,'_mp');

                        %checks whether the number of files matches with the number of runs expected
                        if isempty(runsStruct)
                            runsAvailable = checkRunsAvailable(sub,specie,experiment);
                        else
                            runsAvailable = runsStruct(sub).runsAvailable;
                        end
                        
                        if numel(runsAvailable) ~= numel(fileList)
                            runsAvailable %#ok<NOPRT>
                            fileList %#ok<NOPRT>
                            error('Wrong number of runs');
                        end

                        fileOut = [savePath,'_',sprintf('%03d',rndNum)];
                    else
                        savePath = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                        specie,'\',currentClass,'\sub',sprintf('%03d',sub)];
                        fileList = getFileListOnly(savePath,'fileEnding','_mp');
                        
                        
                        if isempty(runsStruct)
                            runsAvailable = checkRunsAvailable(sub,specie,experiment);
                        else
                            runsAvailable = runsStruct(sub).runsAvailable;
                        end
                        
                        fileList = cell(numel(runsAvailable),1);
                        for nn = 1:numel(runsAvailable)
                            fileList{nn} = ['sub',sprintf('%03d',sub),'run',sprintf('%02d',runsAvailable(nn)),'_mp.nii.gz'];
                        end
                        
                        fileOut = savePath;
                    end            
                    if exist([fileOut,'_mp.nii.gz'],'file')
                        disp(['File: ', fileOut,'_mp.nii.gz exist, skipping...']);

                    else 
                        meanNiftiFiles(savePath,fileOut,'fileList',fileList,'cortex',cortex,...
                        'cortexFile',cortexFile);
                    end
                end
            end
        end
    case 'bySubstractionSub' %substracts the average by participant of one class to another class
        for nComp = 1:size(comparisons,1)
            classesToCompare = {comparisons.positive{nComp},comparisons.negative{nComp}};

            for nSub = 1:length(subsPossible)
                sub = subsPossible(nSub);
                disp(['Analyzing sub', sprintf('%03d',sub),'. , ', num2str(nSub), ' out of ', num2str(length(subsPossible))]);

                for rndNum = 1:nReps
                    if ~rnd %if this is not a permutation break after 1 repetition
                        if rndNum > 1
                            break
                        end
                    end
                    filesToSubstract = cell(2,1);
                    for nCombType = 1:length(classesToCompare)
                        currentClass = classesToCompare{nCombType};

                        if rnd
                            savePath = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                                specie,'\',currentClass,'\sub',sprintf('%03d',sub)];
                            fileListFull = getFileListOnly(savePath,'fileEnding','_mp');
                            fileList = getSubListByPerm(fileListFull,'_mp');
                            fileOut = [savePath,'_',sprintf('%03d',rndNum)];
                        else
                            savePath = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                            specie,'\',currentClass,'\sub',sprintf('%03d',sub)];
                            fileList = getFileListOnly(savePath,'fileEnding','_mp');
                            fileOut = savePath;
                        end            
                        filesToSubstract{nCombType} = [fileOut,'_mp.nii.gz'];

                        if exist([fileOut,'_mp.nii.gz'],'file')
                                disp([[fileOut,'_mp.nii.gz'],' exist, skipping'])
                                continue
                        end
                        meanNiftiFiles(savePath,fileOut,'fileList',fileList,'cortex',ctx,...
                            'cortexFile',cortexFile);

                    end
                    if rnd
                        resFile = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                                specie,'\sub',sprintf('%03d',sub),'_',sprintf('%03d',rndNum),'.nii.gz'];
                    else
                        resFile = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                                specie,'\sub',sprintf('%03d',sub),'.nii.gz'];
                    end
                    positive = load_untouch_niiR(filesToSubstract{1});
                    negative = load_untouch_niiR(filesToSubstract{2});
                    imgOut = positive.img;
                    imgOut(:) = 0;
                    for nVox = 1:numel(imgOut)
                        imgOut(nVox) = positive.img(nVox) - negative.img(nVox);
                    end
                    positive.img = imgOut;
                    save_untouch_nii(positive,resFile);
                    disp([resFile, ' saved']);
                end
            end
        end
    case 'byClass'
        for nClass = 1:numel(classesToRun)
            nFiles = numel(subsPossible);
            currentClass = classesToRun{nClass};
            if rnd
                filesFolder = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                specie,'\',currentClass];   
            else
                filesFolder = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                specie,'\',currentClass];
            end

            fileListFull = getFileListOnly(filesFolder,'fileEnding','_mp');
            if rnd
                for rep = 1:nReps
                    fileOut = [filesFolder,'_',sprintf('%04d',rep)];
                    if exist([fileOut,'_mp.nii.gz'],'file')
                        disp([fileOut,'_mp.nii.gz exist, skipping...'])
                    else
                        fileList = getFileListRnd(fileListFull,'bySubList',nFiles);
                        if numel(fileList) ~= nFiles
                            disp(fileList')
                            error(['Wrong number of files, found', num2str(numel(fileList)), ' expected: ',num2str(nFiles)])
                        end
                        meanNiftiFiles(filesFolder,fileOut,'fileList',fileList,'cortex',cortex,'cortexFile',cortexFile);
                    end
                end
            else
                fileOut = filesFolder;
                if exist([fileOut,'_mp.nii.gz'],'file')
                    disp([fileOut,'_mp.nii.gz exist, skipping...'])
                else
                    if numel(fileListFull) ~= nFiles
                        disp(fileListFull')
                        error(['Wrong number of files, found', num2str(numel(fileListFull)), ' expected: ',num2str(nFiles)])
                    end
                    
                    meanNiftiFiles(filesFolder,fileOut,'fileList',fileListFull,'cortex',cortex,'cortexFile',cortexFile);
                end
            end
        end
    case 'bySubstraction'
        for rep = 1:nReps
            if ~rnd
                if rep > 1
                    continue
                end
            end
            for nComp = 1:size(comparisons,1)
                classesToCompare = {comparisons.positive{nComp},comparisons.negative{nComp}};
                fileList = cell(1,2);
                for nFile = 1:2
                    currentClass = classesToCompare{nFile};
                    if rnd
                        filesFolder = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                        specie,'\res'];
                        fileName = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                        specie,'\',currentClass,'_',sprintf('%04d',rep),'_mp.nii.gz'];   
                    else
                        filesFolder = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\',...
                        specie];
                        fileName = [filesFolder,'\',currentClass,'_mp.nii.gz'];
                    end
                    fileList{nFile} = fileName;
                end

                nii1 = load_untouch_niiR(fileList{1});
                nii2 = load_untouch_niiR(fileList{2});

                niiSub = nii1;
                niiSub.img(:) = 0;
                niiSub.img(:) = nii1.img(:) - nii2.img(:);

                if ~exist(filesFolder,'dir')
                    mkdir(filesFolder);
                end
                if rnd
                    outputFile = [filesFolder,'\',comparisons.positive{nComp},'-',comparisons.negative{nComp},'_',sprintf('%04d',rep),'_mp.nii.gz'];
                else
                    outputFile = [filesFolder,'\',comparisons.positive{nComp},'-',comparisons.negative{nComp},'_mp.nii.gz'];
                end
                if ~exist(outputFile,'file')
                    save_untouch_nii(niiSub,outputFile);
                    disp([outputFile,' saved'])
                else
                    disp([outputFile, ' exist, skipping...'])
                end

            end
        end
    case 'meanDistribution' %generates the distribution based on the permutations of the comparisons
        for nComp = 1:size(comparisons,1)
            filesFolder = [resultsPath,'\',experiment,'\RSASearchlight\rnd\',analysisName,'\',...
                        specie,'\res'];
            fileStart = [comparisons.positive{nComp},'-',comparisons.negative{nComp}];
            distributionFolder = [driveFolder,'\Results\',experiment,'\RSASearchlight\',analysisName,'\distributions\'];
            fileOut = [distributionFolder,specie,'_',fileStart];
            if ~exist(distributionFolder,'dir')
                mkdir(distributionFolder)
            end
            fileList = getFileListOnly(filesFolder,'fileEnding','_mp','fileStart',[fileStart,'_']);
            meanNiftiFiles(filesFolder,fileOut,'fileList',fileList);
            disp([fileOut, ' saved']);
        end
    otherwise
        error('Wrong analysisLevel');
end 
    