function [val,coords,coordsXYZ] = getBestCoord(fileName,varargin)
atlasFile = getArgumentValue('ref','Barney2mm',varargin{:});

data = load_untouch_niiR(fileName); %loads the file



statFiltered(:) = data.img(:); %initializes tFiltered
indx = find(statFiltered(:)==max(statFiltered(:))); %finds the first highest voxel
disp(statFiltered(indx))
if length(indx) > 1
    warning('The file contains more than one highest voxel');
%     disp(indx)
end
[coords(1),coords(2),coords(3)] = flatToXYZ(indx(1),fileName); %gets the coords of that first voxel
val = statFiltered(indx); %gets the value of the voxel
% [val,coords] = Max3d(data.img); %gets voxel coords

% disp(coords)
coordsXYZ = voxelToCoordinates(coords,'ref',atlasFile); %gets the spatial coords
