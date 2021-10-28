function [BOLDFiltered,maskOut,maskIndx] = filterWithMask(BOLDImg,maskName,varargin)
%filters BOLD using maskName, maskName is found in the Labels2mm folder,
%for a different folder, include argument 'maskPath'
atlas = getArgumentValue('atlas',[],varargin{:}); %for use only when the mask is a number
specie = getArgumentValue('specie','',varargin{:}); %for use only when the mask is a number
keepVoxels = getArgumentValue('keepVoxels',true,varargin{:}); %true-keeps only within mask, false-erases within the mask
getDriveFolder;
switch specie
    case 'D' %Uses Kalman's
        maskPath = getArgumentValue('maskPath',[driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm'],varargin{:});
    case 'H' %uses AAL
        maskPath = getArgumentValue('maskPath',[driveFolder,'\Faces_Hu\CommonFiles\Human\AAL'],varargin{:});
    case ''
        maskPath = [];
end

if ischar(maskName) %the input is the name of the mask
    maskToTest = [maskPath,'\',maskName,'.nii.gz'];
    mask = load_untouch_niiR(maskToTest);
    mask = logical(mask.img);
elseif numel(maskName) == 1 %the input is the mask number
    mask = getMask(maskName,'atlas',atlas,'specie',specie);
    mask = logical(mask);
else
    mask = maskName;
    mask = logical(mask);
end

if ~keepVoxels
    mask = ~mask;
end


switch class(BOLDImg)
    case 'single'
        mask = single(mask);
    case 'int16'
        mask = int16(mask);
    case 'double'
        mask = single(mask);
    otherwise
        disp(class(BOLDImg));
        error('program new class designation')
end

totalVolumes = size(BOLDImg,4);
BOLDFiltered = zeros(size(BOLDImg));
for nVolume = 1:totalVolumes
    volume =  BOLDImg(:,:,:,nVolume);
    disp(['filtering volume: ',num2str(nVolume),' / ',num2str(totalVolumes)]);
    volumeFiltered = volume.*(mask);
    try
        BOLDFiltered(:,:,:,nVolume) = volumeFiltered;
    catch
        size(volumeFiltered)
        size(BOLDFiltered(:,:,:,nVolume))
    end
end
maskOut = mask;
maskIndx = find(logical(maskOut)); %getting indx
 