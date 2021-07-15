function getExperimentRnd_RSA(repsPath,repResultsPath,nParticipants,categories,nReps,varargin)
initialRep = getArgumentValue('initialRep',1,varargin{:});
ttestS = getArgumentValue('ttest',true,varargin{:});
nRuns = getArgumentValue('nRuns',0,varargin{:});

meanImg = getArgumentValue('meanImg',false,varargin{:});
fImg = getArgumentValue('filtered',false,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
differenceImg = getArgumentValue('differenceImg',false,varargin{:});


nPair1 = getArgumentValue('nPair1',1,varargin{:});
nPair2 = getArgumentValue('nPair2',2,varargin{:});

if ~(ttestS)
    if nRuns == 0
       error('Must indicate the number of runs');
    end
end





filesPossible = dir([repsPath,'\*000_001.nii.gz']);
fileListFull = cell(size(filesPossible,1),1);
for nFile = 1:size(filesPossible,1)
    fileName = filesPossible(nFile).name;
    fileName(length(fileName)-13:end) = [];
    fileListFull{nFile} = fileName;
end


for j = initialRep:nReps
    disp(['repetition ', num2str(j), ' out of ', num2str(nReps)]);
    
    
    
    %disp(fileList);
    repResultsFile = [repResultsPath,'\res',sprintf('%04d',j)];
    if exist([repResultsFile,'_p.nii.gz'])
        disp(['File exist, skipping ', repResultsFile])
    else
        fclose(fopen([repResultsFile,'_p.nii.gz'],'w'));
        
        sampleForLists = randsample(1:size(fileListFull,1)-1,nParticipants,false);

        fileList1 = cell(nParticipants,1);
        fileList2 = cell(nParticipants,1);
        for nSample = 1:nParticipants
            fileN = sampleForLists(nSample);
            fileName = fileListFull{fileN};
            pairs = combinator(categories,2,'c')-1;

            category1 = pairs(nPair1,1);
            category2 = pairs(nPair1,2); 
            fileList1{nSample} = [fileName,sprintf('%03d',category1),'_',sprintf('%03d',category2),'.nii.gz'];

            category1 = pairs(nPair2,1);
            category2 = pairs(nPair2,2); 
            fileList2{nSample} = [fileName,sprintf('%03d',category1),'_',sprintf('%03d',category2),'.nii.gz'];

        end
        ttest2Searchlight(repsPath,fileList1,fileList2,repResultsFile,'meanImg',meanImg,...
    'filtered',fImg,'t',tImg,'p',pImg,'differenceImg',differenceImg);
        
    end
    
end


