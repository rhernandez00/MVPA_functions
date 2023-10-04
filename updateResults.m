function [clusterData] = updateResults(specie,Z,FSLModel,varargin)
experiment = getArgumentValue('experiment','Complex',varargin{:});
unThrImg = getArgumentValue('unThrImg',true,varargin{:});
removePrevFiles = getArgumentValue('removePrevFiles',true,varargin{:});
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
filterWithReference = false;%filter out voxels outside atlas mask
searchSphere = getArgumentValue('searchSphere',true,varargin{:}); %get label from sphere search?
statName = getArgumentValue('statName','Z',varargin{:}); %name of the statistical test
separation = getArgumentValue('separation',16,varargin{:}); %separation for reporting subpeaks
pCluster = getArgumentValue('pCluster',0.05,varargin{:}); %not used for any calculation, just to fill the table
maskType = 'mask'; %takes sphere or mask
getDriveFolder;
addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);
[copeDict,copesPossible] = getCopeDict(FSLModel);
createNii = true; %creates nii file from copes
% specie = 'H';
ctx = false; %filters out everything outside the selected mask. Currently doesn't work, mis
%mismatch with clusterData = readClusterStats. createROIFromPeaks should
%work from a function independent from readClusterStats as it is unnafected
%by the mask

resultsFolder = 'D:\Raul\results';

% Z = 3.9; %2.3 3.1 3.9



switch specie
    case 'H'
        ref = 'AAL';
        fileBase = 'MNI2mm';
        voxSize = 2;
     case 'D'
        ref = 'Barney2mm';
        fileBase = 'Barney2mm';
        voxSize = 2;
end


sphereRad = 3; %for the ROIs


folderOut = [driveFolder,'\Results\',experiment,'\GLM\Z',num2str(Z*10),'\',sprintf('%03d',FSLModel),...
        '\',specie];
if removePrevFiles
    try
        rmdir(folderOut,'s');
    catch
        disp('Not all files removed')
    end
end
mkdir(folderOut);
tableName = [folderOut,'\',specie,'_results.xlsx'];
delete(tableName);

ROIFolder = [driveFolder,'\Results\',experiment,'\GLM\Z',num2str(Z*10),'\',...
    sprintf('%03d',FSLModel),'\',specie,'\ROI\r',sprintf('%02d',sphereRad),...
    ];
if ~exist(ROIFolder,'dir')
    disp([ROIFolder, ' created']);
    mkdir(ROIFolder);
end
txtName = [ROIFolder,'\copeList.txt'];
copeList = [];
copeInfo = [];
for nCope = 1:length(copesPossible)
    cope = copesPossible(nCope);
    contrastName = [sprintf('%02d',cope),'_',copeDict{nCope}];
    
    copeFolder = [resultsFolder,'\',experiment,'\GLM\',sprintf('%03d',FSLModel),...
        '\',specie,'\',num2str(Z*10),'\cope',num2str(cope),'.gfeat\cope1.feat'];
    fileName = [copeFolder,'\thresh_zstat1.nii.gz'];
    
    copeStatsFile = [copeFolder,'\cluster_zstat1_std.txt'];
    try
        clusterData = readClusterStats(copeStatsFile);
    catch
        clusterData = [];
    end
    
    
    fileOut = [folderOut,'\',contrastName];
    disp(['copying: ', fileName]);
    disp(['to: ', fileOut]);
    copyfile(fileName,[fileOut,'.nii.gz'],'f');
%     copyfile(pngFile,[fileOut,'.png'],'f');
    tMap = load_untouch_niiR([fileOut,'.nii.gz']);
    
    if unThrImg
        fileName2 = [copeFolder,'\stats\tstat1.nii.gz'];
        fileOut2 = [folderOut,'\',contrastName,'_unThrT'];
        copyfile(fileName2,[fileOut2,'.nii.gz'],'f');
        fileName2 = [copeFolder,'\stats\zstat1.nii.gz'];
        fileOut2 = [folderOut,'\',contrastName,'_unThr'];
        copyfile(fileName2,[fileOut2,'.nii.gz'],'f');
    end

    
    if ctx %if filters out everything outside the selected mask
        cortexFileName = getCortexFile(cxFile);  %#ok<*UNRCH>
        cortexImg = load_untouch_niiR(cortexFileName);
        cortexImg.img = single(logical(cortexImg.img));
        tMap.img(:) = cortexImg.img(:).*tMap.img(:);
    end
    statMap = tMap.img;
    %assigns the voxel coordinates and the label for the peak
%     try
    if ~isempty(clusterData)
        clusterData = assignVoxCoords(clusterData,statMap,voxSize,ref,'searchSphere',searchSphere); 
    else
        
    end
    baseName = ['cope',sprintf('%02d',nCope),'_'];
    [clusterList]= splitInClusters(statMap); %moved up from line113 3/31/2021
    if size(clusterData,1) > 0
        [copeListOut,copeInfoOut] = createROIFromPeaks(ROIFolder,clusterData,...
            baseName,specie,sphereRad,contrastName,...
            'createNii',createNii,'maskType',maskType,'filterWithReference',filterWithReference,'clusterList',clusterList); %addedClusterList 3/31/2021
        copeList = [copeList,copeListOut]; 
%         for kk = 1:size(copeInfo,2)
%             copeInfoOut(kk).constrastName = constrastName;
%         end
        copeInfo = [copeInfo,copeInfoOut]; %#ok<*AGROW>
    end
    [peaksTable] = getSubPeakTable(statMap,voxSize,separation,'ref',ref,...
        'searchSphere',searchSphere,'statName',statName);
    
     clusterExtent = getLabelsForMap(statMap,'ref',ref,'fileBase',...
         fileBase,'searchSphere',searchSphere,'sphereName',false);
    
     nRow = 1;
    
    for nCluster = 1:length(clusterList)
        disp(['Running cluster: ', num2str(nCluster), ' out of ', num2str(length(clusterList))]);
        clusterMap = clusterList{nCluster};
        clusterMap(:) = clusterMap(:) ~= 0;
%         resultsCluster = getResultsFromCluster(clusterMap,resultsPath,filePrefix,labelsPath,tableFile,distributionFile,referenceFile,'statName',statName,'fileSuffix',fileSuffix);
        
        statFiltered = statMap; %initializes tFiltered
        statFiltered(:) = statMap(:).*clusterMap(:); %filters out voxels out of the cluster
        
        indx = find(statFiltered(:)==max(statFiltered(:)));
        [coords(1),coords(2),coords(3)] = flatToXYZ(indx(1),statFiltered,'templateFormat','matrix');
        stat = statFiltered(indx);
        
        labelPeak = getCoordLabel(coords,'ref',ref,'fileBase',fileBase,'coordType','voxel','searchSphere',searchSphere);
        
        %Must write what to do with multiple centroids
        runCentroid = false;
        if runCentroid
            [centroidLabelName,~,centroidCoords,multipleCentroid] = getCentroidLabel(statFiltered,'ref',ref,...
            'fileBase',fileBase,'searchSphere',searchSphere,'ignoreMultipleCentroids', true);
        else
            centroidLabelName = ''; %#ok<*NASGU>
            centroidCoords = [0,0,0];
            multipleCentroid = 0;
        end
        xyz = voxelToCoordinates(coords,'ref',ref);
        x = xyz(1); y = xyz(2); z = xyz(3);
        
        res(nRow).cope = cope;
        res(nRow).contrast = copeDict(nCope);
        res(nRow).cluster = nCluster;
        res(nRow).peak = stat;
        res(nRow).peak = labelPeak;
        res(nRow).xVox = coords(1);
        res(nRow).yVox = coords(2);
        res(nRow).zVox = coords(3);
        res(nRow).x = x;
        res(nRow).y = y;
        res(nRow).z = z;
%         res(nRow).resultsCluster = dataTable;
%         res(nRow).centroidPeak = statFiltered(centroidCoords);
%         res(nRow).centroidLabel = centroidLabelName;
%         res(nRow).xCentroidVox = centroidCoords(1);
%         res(nRow).yCentroidVox = centroidCoords(2);
%         res(nRow).zCentroidVox = centroidCoords(3);
        nRow = nRow + 1;
%         error('r')
        
%         results(nCluster) = resultsCluster;
    end
    
    if ~isempty(clusterList)
        sheetName = [contrastName,'_peaks'];
        %writetable(struct2table(res),tableName,'Sheet',sheetName);
        sheetName = [contrastName,'_peaksTable'];
        peaksTable = struct2table(peaksTable);
        legendTable = ['Threshold for reporting was Z > ',...
            sprintf('%.1f', Z),' and a (corrected) cluster significance threshold of p = ',...
            sprintf('%.2f', pCluster),'. All peaks ≥ ',sprintf('%.0f', separation),...
            ' mm apart are reported.'];
        disp(legendTable)
%         peaksTable{end+1,1} = {legendTable};
            
        writetable(peaksTable,tableName,'Sheet',sheetName);
        sheetName = [contrastName,'_clusters'];
        writetable(struct2table(clusterExtent),tableName,'Sheet',sheetName);
        sheetName = [contrastName,'_FSLreport'];
        if ~isempty(clusterData) %if nothing in cluster data, skip
            %writetable(clusterData,tableName,'Sheet',sheetName);
        end
        clear res
    end
    
    
    
%     error('r');
end


writeCopeList(txtName,copeList);
save([ROIFolder,'\copeList.mat'],'copeList','copeInfo');
cleanExcel([specie,'_results.xlsx'],folderOut);
% disp(copeList)
