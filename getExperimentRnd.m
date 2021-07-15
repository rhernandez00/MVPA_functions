% function [tResults,pValues]= getExperimentRnd(repsPath,repResultsPath,nParticipants,categories,nReps,varargin)
function getExperimentRnd(repsPath,repResultsPath,nParticipants,categories,nReps,varargin)
initialRep = getArgumentValue('initialRep',1,varargin{:});
testType = getArgumentValue('testType','ttest',varargin{:}); %test to run, takes 'ttest', 'ttest2', 'binomial'
nRuns = getArgumentValue('nRuns',0,varargin{:});
fileEnding = getArgumentValue('fileEnding','',varargin{:});
filteredImg = getArgumentValue('filtered',false,varargin{:});
meanPerfImg = getArgumentValue('meanPerf',false,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
tReference = getArgumentValue('tReference',0,varargin{:});
randMode = getArgumentValue('randMode','byParticipant',varargin{:});

%for ttest2
directional = getArgumentValue('directional',false,varargin{:});
differenceImg = getArgumentValue('differenceImg',false,varargin{:});


if strcmp(testType,'binomial')
    if nRuns == 0
       error('Must indicate the number of runs');
    end
end

currentFolder = pwd;


cd(repsPath)
% fileListFull = ls('*.nii.gz');
fileListFull = dir(['*',fileEnding,'.nii.gz']);
fileListFull = {fileListFull.name};

for j = initialRep:nReps
    disp(['repetition ', num2str(j), ' out of ', num2str(nReps)]);
    %disp(fileList);
    repResultsFile = [repResultsPath,'\res',sprintf('%04d',j)];
    if exist([repResultsFile,'_p.nii.gz'])
        disp(['File exist, skipping ', repResultsFile])
    else
        fclose(fopen([repResultsFile,'_p.nii.gz'],'w'));

        switch randMode
            case 'byParticipant' %takes n samples from the whole file list
                imgList = randsample(1:size(fileListFull,2),nParticipants,false);
                fileList = cell(nParticipants,1);
                for k = 1:nParticipants
                    fileName = fileListFull{imgList(k)};
                    fileList{k} = fileName;
                end
            case 'bySubList' %creates a sublist, having a single file per participant
%                 class(fileListFull)
                
                fileList = getSubList(fileListFull);
%                 size(fileList)
%                 numel(fileList)
%                 error('r');
            otherwise
                error('Wrong randMode, accepts bySubList, byParticipant');
        end
        switch testType
%             case 'nonparametric'%should write
                
            case 'ttest'
%                 [tResults,~,pValues] = ttestSearchlight(repsPath,categories,repResultsFile,'fileList',fileList,'filtered',filteredImg,'t',tImg,'meanPerf',meanPerfImg,'p',pImg, 'tReference', tReference);
                ttestSearchlight(repsPath,categories,repResultsFile,'fileList',fileList,'filtered',filteredImg,'t',tImg,'meanPerf',meanPerfImg,'p',pImg, 'tReference', tReference);
%                 return
            case 'binomial'
                meanPerfImg = true;
                binomialSearchlight(repsPath,categories,nRuns,repResultsFile,'fileList',fileList,'filtered',filteredImg,'meanPerf',meanPerfImg,'p',pImg);
            case 'ttest2'
                disp('Creating second list')
                imgList = randsample(1:size(fileListFull,2),nParticipants,false);
                fileList2 = cell(nParticipants,1);
                for k = 1:nParticipants
                    %fileList{k} = ['STDrep',sprintf('%03d',imgList(k)),'task1model2r3sub001.nii.gz'];
                    fileName = fileListFull{imgList(k)};
%                     fileName = strtrim(fileName);
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
