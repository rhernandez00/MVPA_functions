function peakStruct = getSubPeaksFaces(clusterMap,pMap,ref,voxSize,separation,pThr,varargin)

statName = getArgumentValue('statName','t',varargin{:});
verbosity = getArgumentValue('verbosity','full',varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});

%gives back the atlas nifti and the table file
atlasNii = getAtlas(ref,'loadNii',true);
fileBase = ref;

%variables
rad = separation/voxSize;
nPeak = 1;
voxelMap = clusterMap;
allMaximums = false;

while true
    %finds the peak
    [center(1),center(2),center(3)] = maxNifti(voxelMap,'allMaximums',allMaximums);%finds the maximum
    peakVal = voxelMap(center(1),center(2),center(3));
    peak_p = pMap(center(1),center(2),center(3));
    %gets the label
    labelName = getCoordLabel(center,'ref',ref,'coordType','voxel','atlasNii',atlasNii,...
        'fileBase', fileBase, 'verbosity', verbosity, 'searchSphere', searchSphere,...
        'sphereName',sphereName);
%     disp(peak_p)
%     disp(pThr)
%     disp(center)
%     error('r')
    if peak_p < pThr
        peakStruct(nPeak).nSubPeak = nPeak;
        peakStruct(nPeak).(statName) = peakVal;
        peakStruct(nPeak).p = peak_p;
        peakStruct(nPeak).voxel_x = center(1);
        peakStruct(nPeak).voxel_y = center(2);
        peakStruct(nPeak).voxel_z = center(3);
        coords = voxelToCoordinates(center,'ref',ref);
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

