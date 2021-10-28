function [coordsOut,x,y,z] = voxelToCoordinates(coordsIn,varargin)
atlasFile = getArgumentValue('ref','Barney2mm',varargin{:});
getVals = getArgumentValue('getVals',false,varargin{:}); %outputs structure
% used for conversion (I have no idea why this was useful, probably for testing)
verbosity = getArgumentValue('verbosity','full',varargin{:});
if length(coordsIn) ~= 3
    error('You must introduce 3 coordinates');
end
coordsOut = [0,0,0];
switch atlasFile
    case 'Barney2mm'
        baseX = 16.5; baseY = 30.5; baseZ = 13;
        resolution = 2;
        coordsOut(1) = (coordsIn(1) - baseX)*resolution;
        coordsOut(2) = (coordsIn(2) - baseY)*resolution;
        coordsOut(3) = (coordsIn(3) - baseZ)*resolution;
    case 'Barney'
        baseX = 74; baseY = 119; baseZ = 57;
        resolution = 0.5;
        coordsOut(1) = (coordsIn(1) - baseX)*resolution;
        coordsOut(2) = (coordsIn(2) - baseY)*resolution;
        coordsOut(3) = (coordsIn(3) - baseZ)*resolution;
        
    case 'MNI2mm'
        baseX = 46; baseY = 64; baseZ = 37;
        resolution = 2;
        
        coordsOut(1) = (coordsIn(1) - baseX)*resolution*-1;
        coordsOut(2) = (coordsIn(2) - baseY)*resolution;
        coordsOut(3) = (coordsIn(3) - baseZ)*resolution;
    case 'AAL'
        baseX = 46; baseY = 64; baseZ = 37;
        resolution = 2;
        
        coordsOut(1) = (coordsIn(1) - baseX)*resolution*-1;
        coordsOut(2) = (coordsIn(2) - baseY)*resolution;
        coordsOut(3) = (coordsIn(3) - baseZ)*resolution;
    case 'BN'
        baseX = 46; baseY = 64; baseZ = 37;
        resolution = 2;
        
        coordsOut(1) = (coordsIn(1) - baseX)*resolution*-1;
        coordsOut(2) = (coordsIn(2) - baseY)*resolution;
        coordsOut(3) = (coordsIn(3) - baseZ)*resolution;        
    case 'Datta'
        coordsOut = [0,0,0];
        
    otherwise
        error('Reference not recognized')
end


if getVals %erases output and gives back the structure of vals used for conversion
    clear coordsOut
    coordsOut.baseX = baseX;
    coordsOut.baseY = baseY;
    coordsOut.baseZ = baseZ;
    coordsOut.resolution = resolution;
    return
else
    if strcmp(verbosity,'full')
        disp(['Reference used: ', atlasFile]);
    end
end

x = coordsOut(1);
y = coordsOut(2);
z = coordsOut(3);

