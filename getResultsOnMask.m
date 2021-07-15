function [valuesMeanList,fileList,valuesMaxList] = getResultsOnMask(mask,filesPath,varargin)
%takes a mask and a set of files, gives back a list of the mean in the whole mask for each file and the max value for each file
fileList = getArgumentValue('fileList',[],varargin{:});
templateFormat = getArgumentValue('templateFormat','nifti',varargin{:});

% oldPath = pwd;
% cd(folder);

if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = getFileList(filesPath,'extention','.nii.gz');
%     disp(fileList);
end
switch templateFormat
    case 'nifti'
        mask = [mask, '.nii.gz'];
        maskImg = load_untouch_niiR(mask);
        maskImg.img = single(logical(maskImg.img));
        maskMatrix = maskImg.img;
    case 'matrix'
        maskMatrix = single(logical(mask));
    otherwise
        error('Wrong template format');
end

valuesMeanList = zeros(1,length(fileList));
valuesMaxList = zeros(1,length(fileList));
for nFile = 1:length(fileList)
    fileName = fileList{nFile};
    file = [filesPath, '\',fileName];
    dataF = load_untouch_niiR(file);
    dataF.img(:) = maskMatrix(:).*dataF.img(:);
    indx = find(maskMatrix(:));
    meanInMask = mean(dataF.img(indx));
    valuesMeanList(nFile) = meanInMask; 
    
    maxInMask = max(dataF.img(indx));
    valuesMaxList(nFile) = maxInMask; 
    

end
% cd(oldPath);


