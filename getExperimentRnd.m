function getExperimentRnd(repsPath,repResultsPath,nFiles,nReps,varargin)
%nFiles - number of files used per permutation (for a MVPC this refers to
%the number of participants)
initialRep = getArgumentValue('initialRep',1,varargin{:});
testType = getArgumentValue('testType','ttest',varargin{:}); %test to run, takes 'ttest', 'ttest2', 'binomial' 'mean'
nRuns = getArgumentValue('nRuns',0,varargin{:});
fileEnding = getArgumentValue('fileEnding','',varargin{:});
filteredImg = getArgumentValue('filtered',false,varargin{:});
meanPerfImg = getArgumentValue('meanPerf',false,varargin{:});
nPadding = getArgumentValue('nPadding',3,varargin{:}); %For option byPerm refers to the number of digits used 001 --> 3 digits
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
tReference = getArgumentValue('tReference',0,varargin{:});
randMode = getArgumentValue('randMode','byParticipant',varargin{:}); 
%'byParticipant' - takes n samples from the whole file list
%'bySubList' %creates a sublist, having a single file per participant               

SDImg = getArgumentValue('SDImg',false,varargin{:});
%for ttest2
directional = getArgumentValue('directional',false,varargin{:});
differenceImg = getArgumentValue('differenceImg',false,varargin{:});


if strcmp(testType,'binomial')
    if nRuns == 0
       error('Must indicate the number of runs');
    end
end

currentFolder = pwd;
fileListFull = getFileListOnly(repsPath,'fileEnding',fileEnding);
for j = initialRep:nReps
    disp(['repetition ', num2str(j), ' out of ', num2str(nReps)]);
    %disp(fileList);
    repResultsFile = [repResultsPath,'\res',sprintf('%04d',j)];
    if exist([repResultsFile,'_p.nii.gz'])
        disp(['File exist, skipping ', repResultsFile])
    else
        fclose(fopen([repResultsFile,'_p.nii.gz'],'w')); %creates a p file
        %to mark that the script is working on it
%         if isempty(fileListFull)
%             fileListFull
%             error('No files found')
%         end
%         fileListFull
        fileList = getFileListRnd(fileListFull,randMode,nFiles,nPadding);
%         if isempty(fileList)
%             fileListFull
%             error('No files found')
%         end
        if numel(fileList) ~= nFiles
            pFile = [repResultsFile,'_p.nii.gz'];
            delete(pFile)
            error(['Wrong number of files expected: ', num2str(nFiles), ', found in list: ', num2str(numel(fileList))]);
        end
        switch testType
            case 'mean'
                meanNiftiFiles(repsPath,repResultsFile,...
                    'fileList',fileList,'SDImg',SDImg);
            case 'ttest'
                ttestSearchlight(repsPath,categories,repResultsFile,...
                    'fileList',fileList,'filtered',filteredImg,'t',tImg,...
                    'meanPerf',meanPerfImg,'p',pImg, 'tReference', tReference,...
                    'SDImg',SDImg);
            case 'binomial'
                meanPerfImg = true;
                binomialSearchlight(repsPath,categories,nRuns,repResultsFile,'fileList',fileList,'filtered',filteredImg,'meanPerf',meanPerfImg,'p',pImg);
            case 'ttest2'
                disp('Creating second list')
                imgList = randsample(1:size(fileListFull,2),nFiles,false);
                fileList2 = cell(nFiles,1);
                for k = 1:nFiles
                    fileName = fileListFull{imgList(k)};
                    fileList2{k} = fileName;
                end
                ttest2Searchlight(repsPath,fileList,fileList2,repResultsFile,'directional',directional,...
                    'meanImg',meanPerfImg,'filtered',filteredImg,'t',tImg,'p',pImg,'differenceImg',differenceImg);         
            otherwise
                error('Wrong test type, accepted are ttest, ttest2, binomial');
        end
                
        
    end
    
end

cd(currentFolder);
