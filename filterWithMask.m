function [BOLDFiltered,maskOut] = filterWithMask(BOLDimg,maskName,varargin)
%filters BOLD using maskName, maskName is found in the Labels2mm folder,
%for a different folder, include argument 'maskPath'
atlas = getArgumentValue('atlas',[],varargin{:}); %for use only when the mask is a number
specie = getArgumentValue('specie',[],varargin{:}); %for use only when the mask is a number
getDriveFolder;
switch specie
    case 'D' %Uses Kalman's
        maskPath = getArgumentValue('maskPath',[driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm'],varargin{:});
    case 'H' %uses AAL
        maskPath = getArgumentValue('maskPath',[driveFolder,'\Faces_Hu\CommonFiles\Human\AAL'],varargin{:});
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



for nVolume = 1:size(BOLDimg,4)
    volume =  BOLDimg(:,:,:,nVolume);
%      size(volume)
%      size(mask)
%      class(volume)
%      class(mask)
    if strcmp(class(volume),'single')
        volumeFiltered = volume.* single(mask);
    elseif strcmp(class(volume),'int16')
        volumeFiltered = volume.* int16(mask);
    elseif strcmp(class(volume),'double')
        size(volume)
        size(mask)
        volumeFiltered = volume.* single(mask);
    else
        disp(class(volume));
        error('program new class designation')
    end
    try
        BOLDFiltered(:,:,:,nVolume) = volumeFiltered;
    catch
        size(volumeFiltered)
        size(BOLDFiltered(:,:,:,nVolume))
    end
end
% BOLDFiltered = BOLD.img(mask);
if strcmp(class(volume),'single')
    maskOut = single(mask);
elseif strcmp(class(volume),'int16')
    maskOut = int16(mask);
else
    disp(class(volume));
    error('program new class designation')
end

 