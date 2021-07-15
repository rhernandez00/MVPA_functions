function [clusterListOut,clusterSizes]= splitInClusters(mapNotBin)
%takes a map, splits it in clusters and gives back a list of the clusters
%and their sizes
clusterListOut = [];
% map = logical(mapNotBin);
map = mapNotBin;
map(:) = mapNotBin(:) ~= 0;

map = single(map ~= 0);
clustConn=26; %
CC = bwconncomp(map,clustConn); %calculates the clusters

mapOut = map;
clusterList = cell(1,CC.NumObjects); %creates a list for each cluster
clusterListVals = clusterList;
clusterSizes = zeros(1,CC.NumObjects);
for j = 1:CC.NumObjects %goes through each cluster found
    coords = CC.PixelIdxList{j};
    mapOut(:) = 0;
    mapOut(coords) = 1;
    clusterList{j} = mapOut; %gets the map of each cluster
    %this is to reassign the values to a cluster list: ---------
    clusterVox = clusterList{j};
    clusterVals = clusterVox;
    indx = find(clusterVox(:));
    clusterVals(indx) = mapNotBin(indx);
    clusterListVals{j} = clusterVals;
    %------------
    
    clusterSizes(j) = size(coords,1);
end

[~,I] = sort(clusterSizes);
I = flip(I);
clusterSizes = clusterSizes(I);
for j = 1:length(clusterListVals)
    nClus = I(j);
    clusterListOut{j} = clusterListVals{nClus};
end
