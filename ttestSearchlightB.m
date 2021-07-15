function ttestSearchlightB(folder,categories,resultsFile,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});

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
        dataF = load_untouch_niiR(file);
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

pValues = dataF;
meanPerformance = dataF;
tResults = dataF;
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
                error('something is wrong, performance can not be negative')
            end
            if media > 0
                val = val + (1/categories)*0.06;
            end

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

        end
    end
end
cd(oldPath);
disp(['Saving results']);
% save_untouch_nii(pValues,[resultsFile,'b_p.nii.gz']);
% save_untouch_nii(tResults,[resultsFile,'b_t.nii.gz']);
% save_untouch_nii(meanPerformance,[resultsFile,'b_mp.nii.gz']);


if pImg
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if tImg
    save_untouch_nii(tResults,[resultsFile,'_t.nii.gz']);
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end
if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(tResults,[resultsFile,'_t_Thr05.nii.gz']);
    tResults.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(tResults,[resultsFile,'_t_Thr01.nii.gz']);
    tResults.img(pValues.img(:) > 0.001) = 0;
    save_untouch_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
end