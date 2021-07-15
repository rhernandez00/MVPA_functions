function [nVoxels,match] = niftiIntersection(files,varargin)
fileOut = getArgumentValue('fileOut',[],varargin{:});
%introduce the name of two files and counts the number of voxels that both
%share

dataN = load_untouch_niiR([files{1},'.nii.gz']); %loads file 1 to create a template for
%the other files
dataN.img(:) = 1; %fills with ones the template
match = dataN.img;
for nFile = 1:length(files)
    dataN = load_untouch_niiR([files{nFile},'.nii.gz']); %loads each file 
    match = match(:).*logical(dataN.img(:)); %calculates the intersection
end

nVoxels = sum(match);

if ~isempty(fileOut)
    dataN.img = match;
    save_untouch_nii(dataN,fileOut);
end