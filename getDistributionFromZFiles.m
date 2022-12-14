function [clustersSizes, numOfClusters]= getDistributionFromZFiles(rndFolder,distributionFile,varargin)
%Loads each permutated group-based result in rndFolder (Z maps) And calculates the
%cluster size for the entire list of the permutated group-based results.
%Saves the clustersSizes in distributionFile
zThr = getArgumentValue('zThr',3.1,varargin{:});
fileEnding = getArgumentValue('fileEnding','_Z',varargin{:}); %ending of the files
thrType = getArgumentValue('thrType','moreThan',varargin{:}); %
nReps = getArgumentValue('nReps',[],varargin{:}); %number of repetitions to use, default: uses all
fileList = getArgumentValue('fileList',[],varargin{:}); %list of files to use
fileSuffix = getArgumentValue('fileSuffix','',varargin{:}); %if the name has a specific start
if isempty(fileList)
    fileList = getFileListOnly(rndFolder,'fileEnding',fileEnding);
end

if isempty(nReps)
    nReps = size(fileList,1);
    if nReps == 0
        disp(['*',fileSuffix,'.nii.gz']);
        disp('No files found');
        clustersSizes=0;
        clusterSizes=0;
        return
    end
end

totalClusterSizes = [];
numOfClusters = zeros(1,nReps);
for rep = 1:nReps
    fileName = fileList{rep};
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)])
    %data = load_niiR([rndFolder,'\',fileName]);
    try
        data = load_niiR([rndFolder,'\',fileName]);
    catch
        disp(['Failed to load ', fileName, ' skiping'])
        continue
    end
    switch thrType
        case 'lessThan'
            data.img(:) = data.img(:) < zThr;
        case 'moreThan'
            data.img(:) = data.img(:) > zThr;
        otherwise
            error('thrType invalid');
    end
    mapNotBin = data.img;
    [~,clusterSizes]= splitInClusters(mapNotBin);
    clusterSizes = clusterSizes(clusterSizes > 1);
    numOfClusters(rep) = length(clusterSizes);
    totalClusterSizes = [totalClusterSizes,clusterSizes]; %#ok<AGROW>
end
clustersSizes = totalClusterSizes;

try
    save(distributionFile,'clustersSizes','numOfClusters');
catch
    warning('something wrong');
    if isempty(clustersSizes)
        disp('no clusters found');
        disp(distributionFile)
        return
    else
        disp('Probably the path is wrong');
        disp(distributionFile)
    end
end


clusterP = 0.05;
sizeTarget = 1;
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
disp(['Cluster size: ', num2str(sizeTarget), ' for Z of ', num2str(zThr), ' and p of cluster ', num2str(clusterP)]);
disp(['Number of clusters: ', num2str(length(clustersSizes))]);

