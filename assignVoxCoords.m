function clusterData = assignVoxCoords(clusterData,statMap,voxSize,ref,varargin)
statName = getArgumentValue('statName','t',varargin{:});
verbosity = getArgumentValue('verbosity','reduced',varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',true,varargin{:});
atlasNii = getAtlas(ref,'loadNii',true);
fileBase = ref;
% [peaksTable] = getSubPeakTable(statMap,voxSize,separation,'ref',ref,...
%     'searchSphere',true,'statName',statName,'verbosity',verbosity);
allMaximums = false; %find all maximums? true must likely will make an error
voxTolerance = 10;%tolerance for the discrepancy between clusterData and splitClusters

[clusterListOut,clusterSizes]= splitInClusters(statMap);

for nRow = 1:size(clusterData,1)
    dif = abs(clusterData.Voxels(nRow) - clusterSizes(nRow));
    if dif > voxTolerance
        clusterData.Voxels(nRow)
        clusterSizes(nRow)
        
          clusterData.Voxels
        clusterSizes
        error('Wrong match');
    end
    voxMap = clusterListOut{nRow};
    
    [center(1),center(2),center(3)] = maxNifti(voxMap,'allMaximums',allMaximums);%finds the maximum
    peakVal = voxMap(center(1),center(2),center(3));
    coords = voxelToCoordinates(center,'ref',ref,'verbosity',verbosity);
    
    clusterData.voxel_x(nRow) = center(1);
    clusterData.voxel_y(nRow) = center(2);
    clusterData.voxel_z(nRow) = center(3);
    clusterData.x(nRow) = coords(1);
    clusterData.y(nRow) = coords(2);
    clusterData.z(nRow) = coords(3);
    clusterData.(statName)(nRow) = peakVal;
    labelName = getCoordLabel(center,'ref',ref,'coordType','voxel','atlasNii',atlasNii,...
        'fileBase', fileBase, 'verbosity', verbosity, 'searchSphere', searchSphere,...
        'sphereName',sphereName);
    clusterData.label(nRow) = {labelName};
    
    
%     for nPeak = 1:size(peaksTable,2)
%         stat = peaksTable(nPeak).t;
%         x = peaksTable(nPeak).x;
%         y = peaksTable(nPeak).y;
%         z = peaksTable(nPeak).z;
%         errorCalcCoords = distance2points([xTable,yTable,zTable],[x,y,z]);
%         errorCalcStat = abs(statTable - stat);
%         if errorCalcCoords < errorCoords
%             if errorCalcStat < errorStat
%                 clusterData.voxel_x(nRow) = peaksTable(nPeak).voxel_x;
% 
%                 if peaksTable(nPeak).voxel_x < 1
%                     error('peaksTable shows a zero')
%                 end
%                 clusterData.voxel_y(nRow) = peaksTable(nPeak).voxel_y;
%                 clusterData.voxel_z(nRow) = peaksTable(nPeak).voxel_z;
%                 clusterData.x(nRow) = peaksTable(nPeak).x;
%                 clusterData.y(nRow) = peaksTable(nPeak).y;
%                 clusterData.z(nRow) = peaksTable(nPeak).z;
%                 clusterData.(statName)(nRow) = peaksTable(nPeak).(statName);
%                 if size(clusterData,1) == 1
%                     clusterData.label = peaksTable(nPeak).label;
%                 else
%                     try
%                         clusterData.label(nRow) = peaksTable(nPeak).label;
%                     catch
%                         clusterData.label(nRow) = {peaksTable(nPeak).label};
%                     end
%                 end
%                 break;
%             end
%         end
%     end
end
% disp(clusterData)
