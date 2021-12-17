function [clustersSizes, numOfClusters]= getDistributionFromfiles(rndFolder,distributionFile,varargin)
error('Deprecated, use Z maps or update this one');

pThr = getArgumentValue('pThr',0.001,varargin{:});
fileSuffix = getArgumentValue('fileSuffix','_p',varargin{:});
thrType = getArgumentValue('thrType','lessThan',varargin{:});
followText = getArgumentValue('followText',true,varargin{:});
nReps = getArgumentValue('nReps',[],varargin{:});

oldPath = pwd;
cd(rndFolder);
fileList = ls(['*',fileSuffix,'.nii.gz']);
if isempty(nReps)
    nReps = size(fileList,1);
    if nReps == 0
        disp(['*',fileSuffix,'.nii.gz']);
        disp('No files found');

        clustersSizes=0;
        numOfClusters=0;
        return
    end
end

clustConn = 6; %connections to count, either 6 or 27

count = 1;
clusterSizes = [];

disp(nReps)
for rep = 1:nReps
    %fileName = [repResultsPath,'\res',sprintf('%03d',j),'_p.nii.gz'];
    fileName = fileList(rep,:);
    fileName = strtrim(fileName);
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
            data.img(:) = data.img(:) < pThr;
        case 'moreThan'
            data.img(:) = data.img(:) > pThr;
        otherwise
            error('thrType invalid');
    end
    CC = bwconncomp(data.img,clustConn);
    for j = 1:CC.NumObjects
%         if size(CC.PixelIdxList{j},1) > 1
            clustersSizes(count) = size(CC.PixelIdxList{j},1); %#ok<SAGROW>
            
%             if clustersSizes(count) > 100
%                 error('r')
%             end
            if size(CC.PixelIdxList{j},2) ~= 1
                error('k')
            end
            if size(CC.PixelIdxList{j},1) < 1
                error('kk')
            end

            count = count + 1;
%         end
    end
    numOfClusters(rep) = CC.NumObjects;
%     if rep > 50
%         break
%     end
%     error('r')
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
disp(['Cluster size: ', num2str(sizeTarget), ' for p of ', num2str(pThr), ' and p of cluster ', num2str(clusterP)]);
disp(['Number of clusters: ', num2str(length(clustersSizes))]);

