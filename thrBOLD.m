function flatData = thrBOLD(BOLDimg,maskName,varargin)
%filters BOLD using maskName, maskName is found in the Labels2mm folder,
%for a different folder, include argument 'maskPath'

getDriveFolder;
maskPath = getArgumentValue('maskPath',[driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm'],varargin{:});
maskToTest = [maskPath,'\',maskName,'.nii.gz'];
mask = load_untouch_niiR(maskToTest);
% size(mask.img)
% size(BOLDimg)
mask = logical(mask.img);

counter = 1;
for nVox = 1:length(mask(:))
    if mask(nVox) > 0
        flatData(counter) = BOLDimg(nVox);
        counter = counter + 1;
    end
end
