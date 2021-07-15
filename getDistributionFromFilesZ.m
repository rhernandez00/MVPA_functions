function [clustersSizes, numOfClusters]= getDistributionFromFilesZ(rndFolder,distributionFile,varargin)

thr = getArgumentValue('thr',0.001,varargin{:}); %threshold to use for the files
fileSuffix = getArgumentValue('fileSuffix','_p',varargin{:}); 
thrType = getArgumentValue('thrType','lessThan',varargin{:});
fileList = getArgumentValue('fileList',[],varargin{:});

oldPath = pwd;
cd(rndFolder);
if isempty(fileList)
    fileList = dir(['*',fileSuffix,'.nii.gz']);
    fileList = {fileList.name};
end
nReps = numel(fileList);
if nReps == 0
    disp(['*',fileSuffix,'.nii.gz']);
    disp('No files found');
    
    clustersSizes=0;
    numOfClusters=0;
    return
end

clustConn = 6; %connections to count, either 6 or 27

count = 1;
clusterSizes = [];

disp(nReps)
for rep = 1:nReps
    %fileName = [repResultsPath,'\res',sprintf('%03d',j),'_p.nii.gz'];
    fileName = fileList{rep};
   
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)])
    try
        data = load_niiR(fileName);
    catch
        disp(['Failed to load ', fileName, ' skiping'])
        continue
    end
    switch thrType
        case 'lessThan'
            data.img(:) = data.img(:) < thr;
        case 'moreThan'
            data.img(:) = data.img(:) > thr;
        otherwise
            error('thrType invalid');
    end
    CC = bwconncomp(data.img,clustConn);
    for j = 1:CC.NumObjects

        clustersSizes(count) = size(CC.PixelIdxList{j},1); %#ok<SAGROW>    
        if size(CC.PixelIdxList{j},2) ~= 1
            error('k')
        end
        if size(CC.PixelIdxList{j},1) < 1
            error('kk')
        end
        count = count + 1;
    end
    numOfClusters(rep) = CC.NumObjects;
end


cd(oldPath)

try
    save(distributionFile,'clustersSizes','numOfClusters');
catch
    warning('something wrong');
    if isempty(numOfClusters)
        disp(distributionFile)
        return
    end
end

clusterP = 0.05;
sizeTarget = 0;
while true
    sizeTarget = sizeTarget + 1;
    p = pFromDist(clustersSizes,sizeTarget,'moreThan');
    if p < clusterP
        break
    end
    if p == 1/length(clustersSizes)
        break
    end
end
disp(['Cluster size: ', num2str(sizeTarget), ' for p of ', num2str(thr), ' and p of cluster ', num2str(clusterP)]);
disp(['Number of clusters: ', num2str(length(clustersSizes))]);

