function niftiImg = getNifti(fileToGet)
%Loads cortex file, options are MNI2mm, Barney2MM, Barney, Datta
userName = char(java.lang.System.getProperty('user.name'));
switch userName
    case 'Raul'
        driveFolder = 'D:\Raul\Gdrive';
    case 'Hallgato'
        driveFolder = 'C:\Users\Hallgato\Google Drive';
    otherwise
        error('Check username');
end

switch fileToGet
    case 'MNI2mmCtx'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mmCtx'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'BarneyCtx'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'DattaCtx'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_CortexB.nii.gz'];
    case 'MNI2mm'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\MNI152_T1_2mm_brain_mask.nii.gz'];
    case 'Barney2mm'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\BarneyBrain2mm.nii.gz'];
    case 'Barney'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\BarneyBrain.nii.gz'];
    case 'Datta'
        niftiFile = [driveFolder,'\Faces_Hu\CommonFiles\Datta.nii.gz'];
    
    otherwise
        disp(fileToGet)
        error('Wrong file');
end

niftiImg = load_untouch_niiR(niftiFile);
niftiImg.img = single(logical(niftiImg.img));
% img = niftiImg.img;