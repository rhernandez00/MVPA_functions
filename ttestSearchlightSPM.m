function ttestSearchlightSPM(folder,categories,resultsFile,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
accImg = getArgumentValue('acc',false,varargin{:});
nRuns = getArgumentValue('nRuns',0,varargin{:});
cortex = getArgumentValue('cortex',true,varargin{:});
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
if accImg
    if nRuns == 0
        error('If acc img is required, then you must give the number of runs nRuns')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch cxFile
    case 'MNI2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Harvard\b_Cortex.nii.gz'];
    case 'Barney2mm'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\b_Cortex.nii.gz'];
    case 'Barney'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels\b_Cortex.nii.gz'];
    case 'Datta'
        cortexFile = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Datta\b_Cortex.nii.gz'];
    otherwise
        error('Wrong cortexFile');
end
if cortex
    cortexImg = load_niiR(cortexFile);
    cortexImg.img = single(logical(cortexImg.img));
end

%
% clear
% resultsFile = 'C:\Users\Seven\Dropbox\PyMVA_nifti\results\res'
% folder = 'C:\Users\Seven\Dropbox\PyMVA_nifti';
% categories = 4;
oldPath = pwd;
cd(folder);
thr = 1/categories;
if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = ls('*.nii.gz');
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    for k = 1:size(fileList,1)
        fileName = fileList(k,:);
        file = [folder,'/',strtrim(fileList(k,:))];
%         dataF = load_niiR(file);
        dataF = load_nii(file);
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
%         dataF = load_niiR(file);
        dataF = load_nii(file);
        imgs{k} = dataF.img;
        disp(['File: ', fileList{k}, ' loaded']);
    end
end



nFiles=size(fileList,1);

pValues = dataF;
meanPerformance = dataF;
tResults = dataF;
accuracy = dataF;
dimensions = size(imgs{1});
totalVox = dimensions(1)*dimensions(2)*dimensions(3);
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end
            media = mean(val);
            if media > 1
                error('something is wrong the values of each voxel are too high (more than 1)')
            end
            if media < 0
                disp(['x = ',num2str(i),' y = ',num2str(j), ' z = ',num2str(k)]);
                disp([num2str(val)]);
%                 disp(fileList);
                error('something is wrong, performance can not be negative')
            end
%             if media > 0
%                 val = val + (1/categories)*0.05;
%             end

            %if all(val > thr)
            if media > thr
                %disp([num2str(i), ' ', num2str(j), ' ' , num2str(k), ' ' ,'/', num2str(dimensions(1)), ' ', num2str(dimensions(2)), ' ' , num2str(dimensions(3))]);
                
                [h,p,ci,stats] = ttest(val,1/categories,'Tail','right');
                %[h,p,ci,stats] = ttest(val,1/categories);
                t = stats.tstat;
            else
                t = 0;
                p = 1;
            end
            pValues.img(i,j,k) = p;
            meanPerformance.img(i,j,k) = media;
            tResults.img(i,j,k) = t;
            accuracy.img(i,j,k) = mean(val)*nFiles*nRuns*categories;

        end
    end
end
cd(oldPath);
disp(['Saving results']);
% save_nii(pValues,[resultsFile,'b_p.nii.gz']);
% save_nii(tResults,[resultsFile,'b_t.nii.gz']);
% save_nii(meanPerformance,[resultsFile,'b_mp.nii.gz']);


if pImg
    save_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if tImg
    save_nii(tResults,[resultsFile,'_t.nii.gz']);
%     disp(resultsFile)
end
if mpImg
    save_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end
if accImg
    save_nii(accuracy,[resultsFile,'_acc.nii.gz']);
end

if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr05.nii.gz']);
    tResults.img(pValues.img(:) > 0.01) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr01.nii.gz']);
    tResults.img(pValues.img(:) > 0.001) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
    tResults.img(pValues.img(:) > 0.0001) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
    tResults.img(pValues.img(:) > 0.00001) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
    tResults.img(pValues.img(:) > 0.000001) = 0;
    save_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
end