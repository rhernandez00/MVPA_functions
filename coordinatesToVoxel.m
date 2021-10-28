function coordsVox = coordinatesToVoxel(coords,varargin)
atlasFile = getArgumentValue('ref','Barney2mm',varargin{:});
verbosity = getArgumentValue('verbosity','full',varargin{:});

if length(coords) ~= 3
    error('You must introduce 3 coordinates');
end

coordsVox = [0,0,0];
vals = voxelToCoordinates([0,0,0],'getVals',true,'ref',atlasFile);
baseX = vals.baseX;
baseY = vals.baseY;
baseZ = vals.baseZ;
resolution = vals.resolution;
switch atlasFile
    case 'MNI2mm'
        coordsVox(1) = -1*((coords(1) / resolution) - baseX);
        coordsVox(2) = (coords(2) / resolution) + baseY;
        coordsVox(3) = (coords(3) / resolution) + baseZ;
     case 'AAL'
        coordsVox(1) = -1*((coords(1) / resolution) - baseX);
        coordsVox(2) = (coords(2) / resolution) + baseY;
        coordsVox(3) = (coords(3) / resolution) + baseZ;
    case 'Barney2mm'
        coordsVox(1) = (coords(1) / resolution) + baseX;
        coordsVox(2) = (coords(2) / resolution) + baseY;
        coordsVox(3) = (coords(3) / resolution) + baseZ;
    case 'Barney'
        coordsVox(1) = (coords(1) / resolution) + baseX;
        coordsVox(2) = (coords(2) / resolution) + baseY;
        coordsVox(3) = (coords(3) / resolution) + baseZ;
    otherwise
        error('Reference not recognized')
end
coordsVox = round(coordsVox);
if strcmp(verbosity,'full')
    disp(['Reference used: ', atlasFile]);
end
% coords = [26,41,27]; %FFG
% atlasFile = 'Barney2mm';
% coordsMNI = voxelToCoordinates(coords,'ref',atlasFile);
