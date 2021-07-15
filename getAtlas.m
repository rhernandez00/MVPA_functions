function [atlasNii,tableFile,labelsPath] = getAtlas(ref,varargin)
%gives back the atlas nifti and the table file
loadNii = getArgumentValue('loadNii',true,varargin{:});
getDriveFolder;
switch ref
    case 'Barney'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\LABL_brain_Barney.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsDogs.csv'];
        labelsPath = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\LabelsNums'];
    case 'Barney2mm'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\LABL_Barney2mmImproved.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsDogs.csv'];
        labelsPath = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\LabelsNums2mm'];
    case 'MNI2mm'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\HarvardOxford-cortl-maxprob-thr0-2mm.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsHarvard.csv'];
        labelsPath = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\LabelsNums'];
    case 'AAL'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\AAL3.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsAAL.csv'];
        labelsPath = [];
    case 'BN'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\BN_Atlas_246_2mm.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsBN.csv'];
        labelsPath = [];
    case 'Datta'
        atlasFilePath = [driveFolder,'\Faces_Hu\CommonFiles\Datta_LABL.nii.gz'];
        tableFile = [driveFolder,'\Faces_Hu\CommonFiles\labelsDogs.csv'];
        labelsPath = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\DattaNums'];
    otherwise
        error('Wrong reference');
end

if loadNii
    atlasNii = load_untouch_niiR(atlasFilePath);
else
    atlasNii = [];
end