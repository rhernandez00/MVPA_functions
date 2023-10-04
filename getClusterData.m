function [clusterData] = getClusterData(experiment,Z,FSLModel,specie,nCope,nCluster,varargin)
switch specie
    case 'D'
        atlasFile = 'Barney2mm';
end

getDriveFolder;
% addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);
resultsFolder = [driveFolder,'\Results\',experiment,'\GLM\Z',...
    sprintf('%02d',Z*10),'\',sprintf('%03d',FSLModel),'\',specie];

[copeDict] = getCopeDict(FSLModel);


% contrastName = [sprintf('%02d',cope),'_',copeDict{nCope}];
copeFile = [resultsFolder,'\',sprintf('%02d',nCope),'_',copeDict{nCope}];
tMap = load_untouch_niiR([copeFile,'.nii.gz']);    
statMap = tMap.img;
[clusterList]= splitInClusters(statMap); 

[val,coords] = max3dR(clusterList{nCluster});
[~,x,y,z] = voxelToCoordinates(coords,'atlasFile',atlasFile);
    
clusterData.voxel_x(nRow) = coords(1);
clusterData.voxel_y(nRow) = coords(2);
clusterData.voxel_z(nRow) = coords(3);
clusterData.x(nRow) = x;
clusterData.y(nRow) = y;
clusterData.z(nRow) = z;
clusterData.t(nRow) = val;




% getDriveFolder;
