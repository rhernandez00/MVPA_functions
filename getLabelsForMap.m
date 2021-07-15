function [dataTable] = getLabelsForMap(voxMap,varargin)
ref = getArgumentValue('ref','Barney2mm',varargin{:});
fileBase = getArgumentValue('fileBase','Barney2mm',varargin{:});
clusterMin = getArgumentValue('clusterMin',0,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});

[clusterList,clusterSizes] = getClusterList(voxMap,clusterMin);

dataTable = [];

for nClus = 1:length(clusterList)
    disp(['Running cluster ', num2str(nClus), ' out of ', num2str(length(clusterList))])
    clusterMap = clusterList{nClus};
    structOut = getLabelsForCluster(clusterMap,'ref',ref,...
        'fileBase',fileBase,'searchSphere',searchSphere,'sphereName',sphereName);
    for nRow = 1:size(structOut,2)
        structOut(nRow).numberOfVox = structOut(nRow).percentage * clusterSizes(nClus);
        structOut(nRow).clusterN = nClus;
        structOut(nRow).clusterSize = clusterSizes(nClus);
    end
    dataTable = [dataTable,structOut];
end



