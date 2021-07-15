function peakStruct = getSubPeaks(clusterMap,ref,voxSize,separation,varargin)
pMap = getArgumentValue('pMap',[],varargin{:});
SDMap = getArgumentValue('SDMap',[],varargin{:});
valMap = getArgumentValue('valMap',[],varargin{:});
valName = getArgumentValue('valName','val',varargin{:});
statName = getArgumentValue('statName','t',varargin{:});
verbosity = getArgumentValue('verbosity','none',varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
minVal = getArgumentValue('minVal',1,varargin{:});

%gives back the atlas nifti and the table file
atlasNii = getAtlas(ref,'loadNii',true);
fileBase = ref;

%variables
rad = separation/voxSize;
nPeak = 1;
voxelMap = clusterMap;
allMaximums = false;

if isempty(pMap)
    pMap = voxelMap;
    pMap(:) = 1;
end
if isempty(SDMap)
    SDMap = voxelMap;
    SDMap(:) = 0;
end

if isempty(valMap)
    valMap = voxelMap;
    valMap(:) = 0;
end

while true
    %finds the peak
    [center(1),center(2),center(3)] = maxNifti(voxelMap,'allMaximums',allMaximums);%finds the maximum
    peakVal = voxelMap(center(1),center(2),center(3));
    
    disp(peakVal)
    disp(['the center is: ', num2str(center)]);
    
    peak_p = pMap(center(1),center(2),center(3));
    SDVal = SDMap(center(1),center(2),center(3));
    valVal = valMap(center(1),center(2),center(3));
    %gets the label
    labelName = getCoordLabel(center,'ref',ref,'coordType','voxel','atlasNii',atlasNii,...
        'fileBase', fileBase, 'verbosity', verbosity, 'searchSphere', searchSphere,...
        'sphereName',sphereName);
%     disp(peak_p)
%     disp(pThr)
%     disp(center)
%     error('r')
%     pThr = 0.01;
    if peakVal > minVal
        coords = voxelToCoordinates(center,'ref',ref);
        for kk = 1:nPeak-1
            coordsPrev = [peakStruct(nPeak-1).x,peakStruct(nPeak-1).y,peakStruct(nPeak-1).z];
            distanceCalc = norm(coords - coordsPrev);
            if distanceCalc < separation
                error('Distance exceded');
            end
        end
        
        peakStruct(nPeak).nSubPeak = nPeak;
        peakStruct(nPeak).(statName) = peakVal;
        peakStruct(nPeak).p = peak_p;
        peakStruct(nPeak).SD = SDVal;
        peakStruct(nPeak).(valName) = valVal;
        peakStruct(nPeak).voxel_x = center(1);
        if peakStruct(nPeak).voxel_x < 0
            error('peakStruct have a zero');
        end
        peakStruct(nPeak).voxel_y = center(2);
        peakStruct(nPeak).voxel_z = center(3);
        
        peakStruct(nPeak).x = coords(1);
        peakStruct(nPeak).y = coords(2);
        peakStruct(nPeak).z = coords(3);
        
        peakStruct(nPeak).label = labelName; %#ok<*AGROW>
        %erases everything around the peak
        sphere = ~createSphere(voxelMap,rad,center);
        for nVox = 1:length(voxelMap(:))
            voxelMap(nVox) = voxelMap(nVox) * sphere(nVox);
        end
        nPeak = nPeak + 1;
    else
        if nPeak == 1
            peakStruct = [];
        end
        break;
    end
end

