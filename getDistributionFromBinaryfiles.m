% function getDistributionFromBinaryfiles(rndFolder,regionMask,distributionFile)
function AllVals = getDistributionFromBinaryfiles(rndFolder,regionMask)
% 
fileList = ls([rndFolder,'\*.nii.gz']);
nReps = size(fileList,1);
regionMask = load_untouch_niiR([regionMask,'.nii.gz']);

indx = regionMask.img(:) > 0;

disp(size(regionMask.img))

AllVals = [];
for rep = 1:nReps
    fileName = fileList(rep,:);
    fileName = strtrim(fileName);
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)]);
    data = load_untouch_niiR([rndFolder,'\',fileName]);
    vals = data.img(indx);
    AllVals = [AllVals;vals(:)];
end



return





clustConn = 6; %connections to count, either 6 or 27
pThr = 0.001;
count = 1;
clusterSizes = [];


for rep = 1:nReps
    %fileName = [repResultsPath,'\res',sprintf('%03d',j),'_p.nii.gz'];
    fileName = fileList(rep,:);
    fileName = strtrim(fileName);
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)])
    data = load_niiR(fileName);
    data.img(:) = data.img(:) < pThr;
    CC = bwconncomp(data.img,clustConn);
    for j = 1:CC.NumObjects
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
    end
    numOfClusters(rep) = CC.NumObjects;
%     error('r')
end


cd(oldPath)


save(distributionFile,'clustersSizes','numOfClusters')