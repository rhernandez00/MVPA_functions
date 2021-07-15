function [peaksTable] = getSubPeakTable(voxMap,voxSize,separation,varargin)
ref = getArgumentValue('ref','Barney2mm',varargin{:});
clusterMin = getArgumentValue('clusterMin',0,varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
statName = getArgumentValue('statName','t',varargin{:});
minVal = getArgumentValue('minVal',1,varargin{:});
pMap = getArgumentValue('pMap',[],varargin{:});
SDMap = getArgumentValue('SDMap',[],varargin{:});
valMap = getArgumentValue('valMap',[],varargin{:});
valName = getArgumentValue('valName','val',varargin{:});
verbosity = getArgumentValue('verbosity','full',varargin{:});

%splits the voxMap in clusters, filters out the clusters too small
[clusterList,clusterSizes] = getClusterList(voxMap,clusterMin);
if isempty(clusterList)
    peaksTable = [];
    return
end
disp(clusterSizes)
peaksTable = [];
for nClus = 1:length(clusterList)
    disp(['Running cluster peaks for cluster No ', num2str(nClus), ...
        ' out of ', num2str(length(clusterList))])
    clusterMap = clusterList{nClus};
    peakStruct = getSubPeaks(clusterMap,ref,voxSize,separation,...
        'searchSphere',searchSphere,'sphereName',sphereName,...
        'statName',statName,'minVal',minVal,'pMap',pMap,'SDMap',SDMap,...
        'valMap',valMap,'valName',valName,'verbosity',verbosity);
    
    for nRow = 1:size(peakStruct,2)
        peakStruct(nRow).clusterN = nClus;
        peakStruct(nRow).clusterSize = clusterSizes(nClus);
    end
    peaksTable = [peaksTable,peakStruct];  %#ok<AGROW>
end

