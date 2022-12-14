function [searchMatrix,flatCoords] = createSearchlightMatrix(wholeSpace,mask,rad)
%generates a matrix searchMatrix of (nVoxels,searchSpace). Where nVoxels refers to
%the voxels contained within the search mask, searchSpace refers to the
%size of the search sphere. 
% flatCoords - coordinates used to search in the mask

sampleSphere = createSphere(zeros(rad*3,rad*3,rad*3),rad,[rad*2,rad*2,rad*2]); %creates a temporal sphere
voxelsInSphere = sum(sampleSphere(:)); %counts the number of voxels in the sphere

flatCoords = find(mask > 0);
[x,y,z] = find3D(mask > 0);
searchMatrix = zeros(numel(x),voxelsInSphere);
for nVoxel = 1:numel(flatCoords)
    sphere = createSphere(wholeSpace,rad,[x(nVoxel),y(nVoxel),z(nVoxel)]);
    indx = find(sphere);
    searchMatrix(nVoxel,:) = indx;
end