function cortexFile = getCortexFile(cxFile)
%loads a file to filter the results
getDriveFolder;
% driveFolder = ['D:\Raul'];
switch cxFile
    case 'HBase'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\baseSingle.nii.gz'];
    case 'MNI2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'D_fullBrain'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_fullbrain.nii.gz'];
    case 'H_fullBrain'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\Harvard\b_fullBrain.nii.gz'];
    case 'Barney2mmG'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\b_GreyMatter.nii.gz'];
    case 'Barney'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'Datta'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_Cortex.nii.gz'];
    case 'DOccipitoTemporal'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_OccipitoTemporal.nii.gz'];
    case 'HOccipitoTemporal'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\b_OccipitoTemporal.nii.gz'];
    case 'HVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\HVisual.nii.gz'];
    case 'RHVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\RHVisual.nii.gz'];
    case 'LHVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\LHVisual.nii.gz'];
    case 'HVisualInclusive'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\HVisualInclusive.nii.gz'];
    case 'RDVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\RDVisual.nii.gz'];
    case 'LDVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\LDVisual.nii.gz'];
    case 'DVisual'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\DVisual.nii.gz'];
    case 'Barney2mmBOLD'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\BOLD.nii.gz'];
    case 'MNI2mmBOLD'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\BOLD.nii.gz'];
    case 'HCategory'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\Category.nii.gz'];
    case 'DCategory'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others\Category.nii.gz'];
    case 'DKunkun'
        cortexFile = [driveFolder,'\NIRS\Shared\DKunkun.nii.gz']; %this is the default mesh
    case 'DKunkun2mm'
        cortexFile = [driveFolder,'\NIRS\Shared\DKunkun2mm.nii.gz'];
    case 'HAdult'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\MNI152_T1_2mm_brain.nii.gz']; %this is the default mesh
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Human\orig\baseSingle.nii.gz'];
    otherwise
        cortexFile = cxFile;
end