% function createMasksFromResults
clear
getDriveFolder;
pathFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm'];
outputPath = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others'];
fileName = 'b_gPerisylvius';
atlasFile = 'Barney2mm';
fileForMasking = [driveFolder,'\Faces_Hu\CommonFiles\b_fullbrain2mm'];
sphereRad = 3;

initialFile = [pathFile,'\',fileName,'.nii.gz'];
dataF  = load_untouch_niiR(initialFile);
imgStats = dataF.img;
map = logical(dataF.img);
clusterList = splitClusters(map);
clusterList{1} = map;
%
clusterVals = imgStats;
for nCluster = 1%:length(clusterList)
    dataF.img = clusterList{nCluster};
    outputFile = [outputPath,'\',fileName,'_c',sprintf('%02d',nCluster),'.nii.gz'];
    disp(['Creating file for cluster ', num2str(nCluster),' ', outputFile]);
    save_untouch_nii(dataF,outputFile);
    disp(['Creating increased file for cluster ', num2str(nCluster),' ', outputFile]);
    increaseMask(outputFile(1:end-7),sphereRad,'filter',true,'mask', fileForMasking);
    
    clusterVals(:) = imgStats(:).*dataF.img(:);
    [~,indx] = Max3d(clusterVals);
    if (size(indx,1) > 1) || (size(indx,2) > 3) 
        disp('Warning, the file has more than one max, taking first one');
    end
    sphereCenter = indx;
    outputFile = [outputPath,'\',fileName,'_m',sprintf('%02d',nCluster),'.nii.gz'];
    referenceFile = initialFile;
    disp(['Creating sphere file for cluster ', num2str(nCluster),' ', outputFile]);
    createSphereFileR(sphereCenter,sphereRad,outputFile,referenceFile);
    
    
    
end

disp('done')


