function partialImg = loadFSLMapsTMP(experiment,specie,FSLModel,sub,runN,nCat,varargin)
getDriveFolder;
mask = getArgumentValue('mask',[],varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'cope'
rad = getArgumentValue('rad',3,varargin{:});
task = getArgumentValue('task',1,varargin{:});
coords = getArgumentValue('coords',[],varargin{:});
maskPath = getArgumentValue('maskPath',[driveFolder,'\Results\',experiment,'\ROIs'],varargin{:});
tablePath = getArgumentValue('tablePath',[driveFolder,'\Results\',experiment,'\dataTable\dataTable.mat'],varargin{:});
isCoord = ~isempty(coords);


[found,data] = checkTable(tablePath,isCoord,mask,coords,rad,sub,runN,FSLModel,specie,nCat,fileTypeToLoad,task);
% if found == 0
%     tablePath
%     isCoord
%     mask
%     coords
%     rad
%     sub
%     runN
%     FSLModel
%     specie
%     nCat
%     fileTypeToLoad
%     task
%     error('not found')
% end

switch fileTypeToLoad
    case 't'
        fileToLoad = 'tstat1';%options are tstat1, zstat1, cope1
    case 'z'
        fileToLoad = 'zstat1';%options are tstat1, zstat1, cope1
    case 'cope'
        fileToLoad = 'cope1';%options are tstat1, zstat1, cope1
    otherwise
        error('Wrong fileType, accepted are: t, z or cope');
end


filesPath = [basePath,'\',experiment,'\FSL',experiment,specie,'STD'];

fileName = [filesPath,'\',sprintf('%03d',FSLModel),'\data\sub',...
    sprintf('%03d',sub),'\BOLD\task',sprintf('%03d',task),'_run',...
    sprintf('%03d',runN),'\BOLD.nii.gz'];
BOLD = load_untouch_niiR(fileName);
disp(fileName)
disp(size(BOLD.img))


fullImg = BOLD.img(:,:,:,nCat);


if isempty(mask)%if there is no mask, creates a sphere and gets the data from within the sphere
    if isempty(coords)
        error('If filterWithMask, then you should supply a mask or coords');
    else
        maskImg = createSphere(fullImg,rad,coords); %creates a sphere
    end
else
    maskData = load_untouch_niiR([maskPath,'\',mask,'.nii.gz']); %loads the designated mask
    maskImg = maskData.img;
    maskImg = logical(maskImg); %binarizes whatever is in mask
end


partialImg = fullImg(maskImg); %gets only the voxels within the selected area





