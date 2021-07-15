function [clusterList,clusterSizes] = getClusterList(voxMap,clusterMin)
%splits the voxMap in clusters
[clusterListOriginal,clusterSizesOriginal] = splitInClusters(voxMap); 

indx = find(clusterSizesOriginal > clusterMin);
if isempty(indx)
    clusterList = [];
    clusterSizes = [];
    return
end
%Selects only the clusters above the minimum cluster size
clusterList = cell(1,length(indx));
clusterSizes = zeros(1,length(indx));
for nIndx = 1:length(indx)
    nClus = indx(nIndx);
    clusterList{nIndx} = clusterListOriginal{nClus};
    clusterSizes(nIndx) = clusterSizesOriginal(nClus);
end