function [results,tableNameS,saveTablePath] = makeTables(filePrefix,resultsPath,distributionFile,varargin)

%distributionFile: 
specie = getArgumentValue('specie','Dog',varargin{:});
tThr = getArgumentValue('Thr',0.05,varargin{:}); %thr for t test
saveTablePath = getArgumentValue('tablePath',resultsPath,varargin{:});
tablePrefix = getArgumentValue('tablePrefix','',varargin{:});
fileBase = getArgumentValue('fileBase','Barney2mm',varargin{:});
calculateClusterSpread = getArgumentValue('calculateClusterSpread',true,varargin{:});
clusterMin = getArgumentValue('clusterMin',0,varargin{:}); %minimum size of the cluster for the cluster spread
fileSuffix = getArgumentValue('fileSuffix', '_t',varargin{:});
statName = getArgumentValue('statName','t',varargin{:}); %stat used
voxSize = getArgumentValue('voxSize',2,varargin{:});
calculateSubPeaks = getArgumentValue('calculateSubPeaks',false,varargin{:}); 
separation = getArgumentValue('separation',16,varargin{:});
statMapFile = getArgumentValue('statMapFile','_t_Thr',varargin{:}); %ending of the for main stat
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
minVal = getArgumentValue('minVal',1,varargin{:});
valMap = getArgumentValue('valMap',[],varargin{:});
valName = getArgumentValue('valName','val',varargin{:});
loadSDMap = getArgumentValue('loadSDMap',true,varargin{:});
getCohen = getArgumentValue('getCohen',false,varargin{:});



switch specie
    case 'Hum'
        if ~strcmp(fileBase,'MNI2mm')
            error('file base doesnt match');
        end
    case 'Dog'
        if ~strcmp(fileBase,'Barney2mm')
            error('file base doesnt match');
        end
    case 'DogDatta'
        if ~strcmp(fileBase,'Datta')
            error('file base doesnt match');
        end
end

switch specie
    case 'Dog'
        ref = 'Barney2mm'; %reference file for the coordinates
    case 'Hum'
        ref = 'AAL'; %reference file for the coordinates
%         ref = 'MNI2mm'; %reference file for the coordinates
    case 'DogDatta'
        ref = 'Datta'; %reference file for the coordinates
    otherwise
        error('Incorrect specie')
end
%loads the table file and the path for the labels
[~,tableFile,labelsPath] = getAtlas(ref,'loadNii',false);

tThrS = fileThrEnding(tThr); %gets the file ending to load the thresholded file

statMapFileName = [resultsPath,'\',filePrefix,statMapFile,tThrS,'Corrected.nii.gz'];
try
    tMap = load_untouch_niiR(statMapFileName);
catch
    disp('No file found, no results')
    results = [];
    tableNameS = '';
    disp(statMapFileName);
    disp('Press any key to continue');
%     pause();
    return
end

%loads p map
pMapFileName = [resultsPath,'\',filePrefix,'_p.nii.gz'];
pMap = load_untouch_niiR(pMapFileName);
pMap = pMap.img;

if loadSDMap
    %loads SD map
    try
        SDMapFileName = [resultsPath,'\',filePrefix,'_SD.nii.gz'];
        SDMap = load_untouch_niiR(SDMapFileName);
        SDMap = SDMap.img;
    catch
        error('No SD map');
    end
else
    SDMap = [];
end

% disp(statMapFileName)
% error('r')
% --------------AGREGAR ESTA PARTE A LA SALIDA -------------------
if calculateClusterSpread
    dataTable = getLabelsForMap(tMap.img,'ref',ref,'fileBase',fileBase,...
        'clusterMin',clusterMin,'searchSphere',searchSphere,'sphereName',sphereName);
end

if calculateSubPeaks
    disp('Running SubPeaks');
    [peaksTable] = getSubPeakTable(tMap.img,voxSize,separation,'ref',ref,...
        'clusterMin',clusterMin,'sphereName',sphereName,'searchSphere',...
        searchSphere,'statName',statName,'minVal',minVal,'pMap',pMap,...
        'SDMap',SDMap,'valMap',valMap,'valName',valName);
%     peaksTable
%     error('r')
end

tMap = tMap.img;

clusterList = splitInClusters(tMap);
% clear results
if isempty(clusterList)
    results = [];
    
end
%calculating peakTable
for nCluster = 1:length(clusterList)
    disp(['Running cluster: ', num2str(nCluster), ' out of ', num2str(length(clusterList))]);
    clusterMap = clusterList{nCluster};
    clusterMap(:) = clusterMap(:) ~= 0 ;
%     clusterMap = logical(clusterMap);
    resultsCluster = getResultsFromCluster(clusterMap,resultsPath,filePrefix,...
        labelsPath,tableFile,distributionFile,ref,'statName',statName,...
        'fileSuffix',fileSuffix,'valMap',valMap,'valName',valName,'SDMap',SDMap,...
        'getCohen',getCohen);
    results(nCluster) = resultsCluster;
end
if ~isdir(saveTablePath)
    disp('No table dir, so dir created');
    disp(saveTablePath);
    mkdir(saveTablePath);
end
% if isempty(tableName) = [];
tableNameS = [tablePrefix,filePrefix,'_thr',tThrS,'.xlsx'];
tableName = [saveTablePath,'\',tableNameS];
delete(tableName);
if isempty(results)
    disp('No results');
else
    sheetName = 'peaks';
    resultsTbl = struct2table(results);
    writetable(resultsTbl,tableName,'Sheet',sheetName);
end

if calculateClusterSpread
    if ~isempty(dataTable)
        resultsTbl = struct2table(dataTable);
        sheetName = 'clusterSpread';
        writetable(resultsTbl,tableName,'Sheet',sheetName);
        disp('Table written')
    else
        disp('No data for table cluster spread');
    end
end
if calculateSubPeaks
    if ~isempty(peaksTable)
        resultsTbl = struct2table(peaksTable);
        sheetName = 'peaksTable';
        writetable(resultsTbl,tableName,'Sheet',sheetName);
        disp('Table written (subPeaks)')
    else
        disp('No data for table (subPeaks)');
    end
    
end

% catch ME
%     disp(ME.message)
% end

