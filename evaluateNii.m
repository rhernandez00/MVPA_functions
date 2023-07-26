function indxList = evaluateNii(niiPath)
%ranks the voxels in the file and gives back the indices of the top
%performers
nii = load_untouch_niiR(niiPath);
ctx = getCortex('Barney2mm');
nii.img(:) = nii.img(:).*ctx(:);

%Top performers
% topVoxelsN = 10;
% [~,order] = sort(nii.img(:));
% indxTop = order(end-topVoxelsN:end);
% indxList = [];
% indxList = [indxList,indxTop];

% Top in cluster
thrList = linspace(0,max(nii.img(:)),20);
minVox = 30; %minimum number of voxels
n = 1;
voxAbove = 0;
while voxAbove < minVox
    thr = thrList(end-n);
    voxMap = nii.img > thr;
    [clusterListOriginal,clusterSizesOriginal] = splitInClusters(voxMap); 
    voxAbove = sum(clusterSizesOriginal);
    n = n + 1;
end

indxList = [];
for nClus = 1:numel(clusterListOriginal)
    indxList = [indxList;find(clusterListOriginal{nClus})]; %#ok<AGROW>
end

disp(['max in nii: ',num2str(max(nii.img(:)))])