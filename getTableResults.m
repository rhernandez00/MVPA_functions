function [results] = getTableResults(binMap,resultsPath,filePrefix)

tmapFile = [resultsPath,'\',filePrefix,'_t.nii.gz']; %loads t map
tmap = load_untouch_niiR(tmapFile);

clusterList = splitClusters(binMap);
% tList = zeros(1,lengthClusterList);
% pList = zeros(1,lengthClusterList);
% coordList = zeros(1,lengthClusterList);
for nCluster = 1:length(clusterList)
    map = clusterList{nCluster};
    tFiltered = tmap.img; %initializes tFiltered
    tFiltered(:) = tmap.img(:).*map(:); %filters out voxels out of the cluster
    [t,coords] = Max3d(tFiltered); %calculates max t in file
    %loads p file
    pmapFile = [resultsPath,'\',filePrefix,'_p.nii.gz'];
    pmap = load_untouch_niiR(pmapFile);
    p = pmap.img(coords(1),coords(2),coords(3)); %gets p for coords
    
%     tList(nCluster) = t;
%     pList(nCluster) = p;
%     coordList{nCluster} = coords;
    results(nCluster).t = t;
    results(nCluster).p = p;
    results(nCluster).coords = coords;
    results(nCluster).nVox = sum(map(:));
end