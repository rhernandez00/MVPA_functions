function [results] = getResultsFromCluster(binMap,resultsPath,filePrefix,labelsPath,tableFile,distributionFile,referenceFile,varargin) %#ok<INUSL>
% function statFiltered = getResultsFromCluster(binMap,resultsPath,filePrefix,labelsPath,tableFile,distributionFile,referenceFile,varargin)
fileSuffix = getArgumentValue('fileSuffix', '_t',varargin{:});
statName = getArgumentValue('statName','t',varargin{:});
SDMap = getArgumentValue('SDMap',[],varargin{:});
valMap = getArgumentValue('valMap',[],varargin{:});
valName = getArgumentValue('valName','val',varargin{:});
loadpMap = getArgumentValue('loadpMap',true,varargin{:});
getCohen = getArgumentValue('getCohen',false,varargin{:});
if isempty(distributionFile)
    clustersSizes = ones(1,10);
else
    load(distributionFile); %#ok<LOAD> %distribution of the cluster sizes
end

tmapFile = [resultsPath,'\',filePrefix,fileSuffix,'.nii.gz']; %loads t map
tmap = load_untouch_niiR(tmapFile);
statFiltered = tmap.img; %initializes tFiltered
statFiltered(:) = tmap.img(:).*binMap(:); %filters out voxels out of the cluster

%finds the coordinates for the maximum
[coords(1),coords(2),coords(3),indx] = maxNifti(abs(statFiltered),'allMaximums',false);

% Old way of finding the maximum, deprecated-------------------
% [stat,coords] = Max3d(statFiltered); %calculates max t in file
% return
% coords = [0,0,0,0,0];
% while length(coords) > 3
%     [stat,coords] = Max3d(statFiltered); %calculates max t in file
%     statFiltered(coords(1),coords(2),coords(3)) = statFiltered(coords(1),coords(2),coords(3)) -1;
%     warning('More than one max');
% end
%---------------------------------------------------------------
%finds the statistic for the given coordinate
stat = statFiltered(indx);
if loadpMap %loads p file
    pmapFile = [resultsPath,'\',filePrefix,'_p.nii.gz'];
    pmap = load_untouch_niiR(pmapFile);
else %loads the stat map, zeroes it and uses it as reference
    pmapFile = [resultsPath,'\',filePrefix,fileSuffix,'.nii.gz']; %loads the stat map
    pmap = load_untouch_niiR(pmapFile);
    pmap.img(:) = 0;
end
%checks if there is an input for SD and val maps
voxelMap = pmap.img;
voxelMap(:) = 0;
if isempty(SDMap)
    SDMap = voxelMap;
    SDMap(:) = 0;
end
if isempty(valMap)
    valMap = voxelMap;
    valMap(:) = 0;
end

%assigns the corresponding values
p = pmap.img(coords(1),coords(2),coords(3)); %gets p for coords
SDval = SDMap(coords(1),coords(2),coords(3)); %gets SD for coords
valVal = valMap(coords(1),coords(2),coords(3)); %gets SD for coords

disp(tableFile)
% [labelName,labelNum]= findLabel(coords,labelsPath,tableFile); %deprecated
[labelName,labelNum]= findLabel(coords,referenceFile);

pCluster = pFromDist(clustersSizes,sum(binMap(:)),'moreThan'); %calculates the p of the cluster

% results.fileSuffix = fileSuffix;
results.(statName) = stat(1);
results.p = p;
results.SD = SDval;
results.(valName) = valVal;
results.voxel = coords;
results.coords = voxelToCoordinates(coords,'ref',referenceFile);
results.nVox = sum(binMap(:));
results.pCluster = pCluster;
results.region = labelName;
results.labelNum = labelNum;
if getCohen
    categories = 2;
    cohen = abs(valVal - 1/categories)/SDval;
    results.cohen = cohen; 
    if cohen < 0.2
         eMagnitude = 'neglible';
     elseif cohen < 0.5
         eMagnitude = 'small';
     elseif cohen < 0.8
         eMagnitude = 'medium';
     else
         eMagnitude = 'large';
     end
    results.magnitude = eMagnitude;
end

