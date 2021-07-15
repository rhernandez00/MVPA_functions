function [dataMatrix,errorLog,fileList,indxList] = getMeanDistributionFromfilesQuick(rndFolder,meanDistributionFile,varargin)
fileSuffix = getArgumentValue('fileSuffix','_mp',varargin{:});
getDriveFolder;
mask = load_untouch_niiR([driveFolder,'\Results\Emotions\Positive\maskTmp.nii.gz']);

oldPath = pwd;
cd(rndFolder);
fileList = ls(['*',fileSuffix,'.nii.gz']);
nReps = size(fileList,1);

%initializing the matrix for all reps using rep 1
fileName = fileList(1,:);
fileName = strtrim(fileName);
data = load_niiR(fileName); %dataLength = length(data.img(:));
fileName = fileList(2,:);
fileName = strtrim(fileName);
data2 = load_niiR(fileName); %dataLength = length(data.img(:));
data.img(:) = data.img(:) + data2.img(:);

% mask = load_untouch_niiR(maskFile);

indxList = find(mask.img(:) ~= 0);
dataLength = length(indxList);
dataMatrix = zeros(nReps,dataLength);
%keeping track of files with errors
errorLog = [];

for rep = 1:nReps
    fileName = fileList(rep,:);
    fileName = strtrim(fileName);
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)]);
    try
        data = load_niiR(fileName);    
        dataOut = data.img(indxList);
        dataMatrix(rep,:) = dataOut;
    catch
        warning(['error in: ', num2str(rep)]);
        errorLog(length(errorLog)+1) = rep;
        continue
        
    end
    
end
cd(oldPath)


save(meanDistributionFile,'dataMatrix','errorLog','fileList','-v7.3');
