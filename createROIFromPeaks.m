function [copeList,copeInfo] = createROIFromPeaks(ROIFolder,clusterData,baseName,specie,sphereRad,contrastName,varargin)
maskType = getArgumentValue('maskType','sphere',varargin{:}); %takes 'sphere' or 'mask'
clusterList = getArgumentValue('clusterList',[],varargin{:});
createNii = getArgumentValue('createNii',false,varargin{:});
filterWithReference = getArgumentValue('filterWithReference',true,varargin{:});

if strcmp(maskType,'mask')
    if isempty(clusterList)
        error('Must introduce clusterList');
    end
end
getDriveFolder;

switch specie
    case 'H'
        ref = 'MNI2mm';
     case 'D'
        ref = 'Barney2mm';
end
[atlasNii] = getAtlas(ref);

if ~exist(ROIFolder,'dir')
    mkdir(ROIFolder);
end
% copeList = cell(1,size(clusterData,1)); %before changing
copeList = cell(1,numel(clusterData.voxel_x)); %after changing 1/08/2020
for nRow = 1:numel(clusterData.voxel_x)
    Vox_x = clusterData.voxel_x(nRow);
    Vox_y = clusterData.voxel_y(nRow);
    Vox_z = clusterData.voxel_z(nRow);
    if Vox_x==0
        error('Zero found')
    end
    x = clusterData.x(nRow);
    y = clusterData.y(nRow);
    z = clusterData.z(nRow);
    valInCoords = clusterData.t(nRow); %im not sure if it is really the peak
    
    sphereCenter = [Vox_x,Vox_y,Vox_z];
    nameOfFile = [baseName,sprintf('%02d',nRow)];
    nameOfFileF = [ROIFolder,'\',nameOfFile];
    if createNii
        switch maskType
            case 'sphere'
                createSphereFileR(sphereCenter,sphereRad,nameOfFileF, atlasNii,...
                    'filterWithReference',filterWithReference);
            case 'mask'
                atlasNii.img = single(logical(clusterList{nRow}));
                save_untouch_nii(atlasNii,[nameOfFileF,'.nii.gz']);
        end
    end
    copeList{nRow} = nameOfFile;
    copeInfo(nRow).Vox_x = Vox_x; %#ok<*AGROW>
    copeInfo(nRow).Vox_y = Vox_y;
    copeInfo(nRow).Vox_z = Vox_z;
    
    copeInfo(nRow).x = x;
    copeInfo(nRow).y = y;
    copeInfo(nRow).z = z;
    
    copeInfo(nRow).valInCoords = valInCoords;
    copeInfo(nRow).cope = baseName(1:end-1);
    copeInfo(nRow).nPeak = sprintf('%02d',nRow);
    copeInfo(nRow).contrastName = contrastName;
end
