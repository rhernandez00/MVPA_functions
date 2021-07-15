function outputMap = maskWithCtx(inputMap,varargin)
getDriveFolder;
cxFile = getArgumentValue('cxFile','Barney2mm',varargin{:});

switch cxFile
    case 'MNI2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'Barney'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'Datta'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_Cortex.nii.gz'];
    case 'CtxVisual'
        cortexFile = [driveFolder, '\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\cortexVisual.nii.gz'];
    otherwise
        cortexFile = cxFile;
end

cortexImg = load_untouch_niiR(cortexFile);
cortexImg.img = single(logical(cortexImg.img));

outputMap = inputMap;        
outputMap(:) = cortexImg.img(:).*inputMap(:);
        