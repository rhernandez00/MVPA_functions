function [labelName,nLabel,coords,multipleCentroid] = getCentroidLabel(imgMatrix,varargin)
%receives a matrix and gives back the label where the centroid lands
ref = getArgumentValue('ref','Barney2mm',varargin{:});
fileBase = getArgumentValue('fileBase','Barney2mm',varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
ignoreMultipleCentroids = getArgumentValue('ignoreMultipleCentroids',false,varargin{:});

[~,emptyCoords,multipleCentroid,coords] = getCentroid(imgMatrix,'ignoreMultipleCentroids',ignoreMultipleCentroids);

if sum(isnan(coords)) > 0
    emptyCoords = true;
end

if ~emptyCoords
    [labelName,nLabel] = getCoordLabel(coords,'ref',ref,'fileBase',fileBase,...
    'verbosity','reduced','searchSphere',searchSphere, 'sphereName', sphereName);
%     if nLabel == 999
%         multipleCentroid = 0;
%         error('r');
%     end
else
    labelName = 'not found';
    nLabel = 0;
end
