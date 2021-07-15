function makeTables(filePrefix,resultsPath,distributionFile,varargin)
specie = getArgumentValue('specie','Dog',varargin{:});
tThr = getArgumentValue('Thr',0.05,varargin{:}); %thr for t test
saveTablePath = getArgumentValue('tablePath',resultsPath,varargin{:});
tablePrefix = getArgumentValue('tablePrefix','',varargin{:});
fileBase = getArgumentValue('fileBase','Barney2mm',varargin{:});
calculateClusterSpread = getArgumentValue('calculateClusterSpread',true,varargin{:});
clusterMin = getArgumentValue('clusterMin',0,varargin{:}); %minimum size of the cluster for the cluster spread
fileSuffix = getArgumentValue('fileSuffix', '_t',varargin{:});
statName = getArgumentValue('statName','t',varargin{:});
voxSize = getArgumentValue('voxSize',2,varargin{:});
calculateSubPeaks = getArgumentValue('calculateSubPeaks',false,varargin{:}); 
separation = getArgumentValue('separation',16,varargin{:});

sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});

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
        ref = 'MNI2mm'; %reference file for the coordinates
    case 'DogDatta'
        ref = 'Datta'; %reference file for the coordinates
    otherwise
        error('Incorrect specie')
end
%loads the table file and the path for the labels
[~,tableFile,labelsPath] = getAtlas(ref,'loadNii',false);

tThrS = fileThrEnding(tThr); %gets the file ending to load the thresholded file

tMap = load_untouch_niiR([resultsPath,'\',filePrefix,'_t_Thr',tThrS,'Corrected.nii.gz']);
pMap = load_untouch_niiR([resultsPath,'\',filePrefix,'_p.nii.gz']);
pMap = pMap.img;
% --------------AGREGAR ESTA PARTE A LA SALIDA -------------------
if calculateClusterSpread
    dataTable = getLabelsForMap(tMap.img,'ref',ref,'fileBase',fileBase,'clusterMin',clusterMin);
end

if calculateSubPeaks
    pThr = tThr;
    [peaksTable] = getSubPeakTableFaces(tMap.img,pMap,voxSize,separation,pThr,'ref',ref,...
        'clusterMin',clusterMin,'sphereName',sphereName,'searchSphere',...
        searchSphere,'statName',statName);
end

tMap = tMap.img;

clusterList = splitInClusters(tMap);
% clear results
if isempty(clusterList)
    results = [];
end
for nCluster = 1:length(clusterList)
    disp(['Running cluster: ', num2str(nCluster), ' out of ', num2str(length(clusterList))]);
    clusterMap = clusterList{nCluster};
    clusterMap(:) = clusterMap(:) ~= 0 ;
%     clusterMap = logical(clusterMap);
    resultsCluster = getResultsFromCluster(clusterMap,resultsPath,filePrefix,labelsPath,tableFile,distributionFile,ref,'statName',statName,'fileSuffix',fileSuffix);
    results(nCluster) = resultsCluster;
end
if ~isdir(saveTablePath)
    disp('No table dir, so dir created');
    disp(saveTablePath);
    mkdir(saveTablePath);
end
% if isempty(tableName) = [];
tableName = [saveTablePath,'\',tablePrefix,filePrefix,'_thr',tThrS,'.xlsx'];
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
        disp('No data for table');
    end
end
if calculateSubPeaks
    if ~isempty(peaksTable)
        resultsTbl = struct2table(peaksTable);
        sheetName = 'peaksTable';
        writetable(resultsTbl,tableName,'Sheet',sheetName);
        disp('Table written (subPeaks)')
    else
        disp('No data for table');
    end
    
end

% catch ME
%     disp(ME.message)
% end

