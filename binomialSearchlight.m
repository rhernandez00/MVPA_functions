function binomialSearchlight(folder,categories,nRuns,resultsFile,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
accImg = getArgumentValue('acc',false,varargin{:});
quickFile = getArgumentValue('quick',false,varargin{:});
thr = getArgumentValue('qThr',1,varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:});

userName = char(java.lang.System.getProperty('user.name'));
switch userName
    case 'Raul'
        driveFolder = 'D:\Raul\Gdrive';
    case 'Hallgato'
        driveFolder = 'C:\Users\Hallgato\Google Drive';
    otherwise
        error('Check username');
end
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch cxFile
    case 'MNI2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'Barney'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'Datta'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_CortexD.nii.gz'];
    otherwise
        error('Wrong cortexFile');
end
if cortex
    disp('Cortex only');
    cortexImg = load_untouch_niiR(cortexFile);
    cortexImg.img = single(logical(cortexImg.img));
end

%
% clear
% resultsFile = 'C:\Users\Seven\Dropbox\PyMVA_nifti\results\res'
% folder = 'C:\Users\Seven\Dropbox\PyMVA_nifti';
% categories = 4;
oldPath = pwd;
cd(folder);
if ~quickFile
    thr = 1/categories;
    disp(['Running full analysis thr ', num2str(thr)]);
else
    disp(['Running quick analysis thr ', num2str(thr)]);
end

if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = ls('*.nii.gz');
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    for k = 1:size(fileList,1)
        fileName = fileList(k,:);
        file = [folder,'/',strtrim(fileList(k,:))];
        dataF = load_untouch_niiR(file);
        if cortex
            dataF.img(:) = cortexImg.img(:).*dataF.img(:);
        end
        
        imgs{k} = dataF.img;
        disp(['File: ', fileList(k,:), ' loaded']);
    end
else
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        fileName = fileList{k};
        file = [folder,'/',fileName];
        dataF = load_untouch_niiR(file);
        imgs{k} = dataF.img;
        disp(['File: ', fileList{k}, ' loaded']);
    end
end




nFiles=size(fileList,1);
total = nFiles*nRuns*categories;

pValues = dataF;
meanPerformance = dataF;

accuracy = dataF;
dimensions = size(imgs{1});
% totalVox = dimensions(1)*dimensions(2)*dimensions(3);
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end
            media = mean(val);
            corrects = media*total;
            if media > 1
                error('something is wrong the values of each voxel are too high (more than 1)')
            end
            if media < 0
                error('something is wrong, performance can not be negative')
            end
            if media > thr
                p = 1 - binocdf(corrects,total,1/categories);
%                 p = binopdf(corrects,total,1/categories);
            else
                p = 1;
            end
            pValues.img(i,j,k) = p;
            meanPerformance.img(i,j,k) = media;
            accuracy.img(i,j,k) = mean(val)*nFiles*nRuns*categories;
        end
    end
end
cd(oldPath);
disp(['Saving results']);



if pImg
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end
if accImg
    save_untouch_nii(accuracy,[resultsFile,'_acc.nii.gz']);
end

if fImg
    meanPerformance.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(meanPerformance,[resultsFile,'_t_Thr05.nii.gz']);
    meanPerformance.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(meanPerformance,[resultsFile,'_t_Thr01.nii.gz']);
    meanPerformance.img(pValues.img(:) > 0.001) = 0;
    save_untouch_nii(meanPerformance,[resultsFile,'_t_Thr001.nii.gz']);
end