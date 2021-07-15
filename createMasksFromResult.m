function createMasksFromResult(fileName,filePath,varargin)
%creates the max, extended and whole cluster files for each cluster found in fileName
getDriveFolder;
outputPath = getArgumentValue('outputPath',filePath,varargin{:});
fileForMasking = getArgumentValue('mask',[driveFolder,'\Faces_Hu\CommonFiles\b_fullbrain2mm'],varargin{:});
sphereRad = getArgumentValue('rad',3,varargin{:});
% atlasFile = 'Barney2mm';

initialFile = [filePath,'\',fileName,'.nii.gz'];
dataF  = load_untouch_niiR(initialFile); %loads the file
imgStats = dataF.img;
map = logical(dataF.img);
clusterList = splitClusters(map); %splits the file into clusters
clusterVals = imgStats;
%creates the max, extended and whole cluster files for each cluster
for nCluster = 1:length(clusterList)
    dataF.img = clusterList{nCluster};
    outputFile = [outputPath,'\',fileName,'_c',sprintf('%02d',nCluster),'.nii.gz'];
    disp(['Creating file for cluster ', num2str(nCluster),' ', outputFile]);
    save_untouch_nii(dataF,outputFile);
    disp(['Creating increased file for cluster ', num2str(nCluster),' ', outputFile]);
    increaseMask(outputFile(1:end-7),sphereRad,'filter',true,'mask', fileForMasking);
    
    clusterVals(:) = imgStats(:).*dataF.img(:);
    [~,indx] = Max3d(clusterVals);
    if size(indx,1) > 1
        warning('the file has more than one max, taking first one');
    end
    sphereCenter = indx;
    outputFile = [outputPath,'\',fileName,'_m',sprintf('%02d',nCluster),'.nii.gz'];
    referenceFile = initialFile;
    disp(['Creating sphere file for cluster ', num2str(nCluster),' ', outputFile]);
    createSphereFileR(sphereCenter,sphereRad,outputFile,referenceFile);
end

disp('done')


