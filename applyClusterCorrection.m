function [imgOut,clusterSizeList,clusterSizeListFull] = applyClusterCorrection(imgMatrix,clusterSizeSelected)

imgMatrixB = single(imgMatrix~=0); %created a binarized copy of the image

clustConn=6;
CC = bwconncomp(imgMatrixB,clustConn);
clusterSizeListFull = zeros(1,CC.NumObjects);
for j = 1:CC.NumObjects
    clusSize = size(CC.PixelIdxList{j},1);
    clusterSizeListFull(j) = clusSize;
     if clusSize > clusterSizeSelected
         p = 1;
     else
         p = 0;
     end
    imgMatrixB(CC.PixelIdxList{j}) = p;
end

CC = bwconncomp(imgMatrixB,clustConn);
clusterSizeList =  zeros(1,CC.NumObjects);
for j = 1:CC.NumObjects
    clusSize = size(CC.PixelIdxList{j},1);
    clusterSizeList(j) = clusSize;
end

imgOut = imgMatrix;
imgOut(:) = imgMatrix(:).*imgMatrixB(:);
