function [indx,vals,outImg] = getContrastNVoxels(sub,specie,experiment,inputContrast,inputFSLModel,nVoxels,varargin)
%outputs which voxels have the highest result for the inputContrast in the
%whole brain or in a mask (mask) if a mask is defined

%experiment - name of experiment
%specie - specie to load
%nMask - number of mask to read
%inputContrast - contrast from which to select the highest (or lowest) nVoxels
%nVoxels = getArgumentValue('nVoxels',[],varargin{:});
getDriveFolder;
atlas = getArgumentValue('atlas',[],varargin{:});
side = getArgumentValue('side','highest',varargin{:});
mask = getArgumentValue('mask',[],varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'c'
task = getArgumentValue('task',1,varargin{:});
maskPath = getArgumentValue('maskPath',[driveFolder,'\Results\',experiment,'\ROIs'],varargin{:});
tablePath = getArgumentValue('tablePath',[driveFolder,'\Results\',experiment,'\dataTable\dataTable.mat'],varargin{:});
loadFromBOLDInput = getArgumentValue('loadFromBOLDInput',false,varargin{:});

inputZ = getArgumentValue('inputZ',[],varargin{:});

if isempty(atlas)
    switch specie
        case 'D'
            atlas = 'Barney2mm';
        case 'H'
            atlas = 'AAL';
    end
end
if isempty(mask)
    maskMatrix = [];
    disp('No mask');
else
    if numel(mask) == 1
        [maskMatrix] = getMask(mask,'atlas',atlas,'specie',specie);
    elseif ismatrix(mask)
        maskMatrix = mask;
    else
        error('Wrong input matrix');
    end     
end
        
runN = 0; %run is ignored as it will load the gfeat
[~,outImg]  = loadFSLMaps(experiment,specie,inputFSLModel,sub,runN,inputContrast,...
    'mask',maskMatrix,'basePath',basePath,'fileTypeToLoad',fileTypeToLoad,...
    'task',task,'maskPath',maskPath,'tablePath',tablePath,...
    'gfeat',true,'inputZ',inputZ,'maskName',mask);
flatImg = outImg(:);

[sortedVals,I] = sort(flatImg);


switch side
    case 'highest'
        indx = I(end-nVoxels+1:end);
        vals = sortedVals(end-nVoxels+1:end);
    case 'lowest'
        indx = I(1:nVoxels);
        vals = sortedVals(1:nVoxels);
end






