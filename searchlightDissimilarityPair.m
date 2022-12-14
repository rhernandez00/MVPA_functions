function imgResult = searchlightDissimilarityPair(img1,img2,searchMatrix,flatCoords)
%runs dissimilarity searchlight for img1 and img2 on searchMatrix.
%searchMatrix is a matrix of (nVoxels,searchSpace). Where nVoxels refers to
%the voxels contained within the search mask, searchSpace refers to the
%size of the search sphere
imgResult = zeros(size(img1));
for nVoxel = 1:size(searchMatrix,1)
    vector1 = img1(searchMatrix(nVoxel,:))';
    vector2 = img2(searchMatrix(nVoxel,:))';
    d = pdist2(vector1,vector2,'correlation'); %calculates correlation distance
    imgResult(flatCoords(nVoxel)) = d;
    
end
