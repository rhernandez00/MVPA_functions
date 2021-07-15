function ttestSearchlightM(folder,resultsFile,varargin)
expectedM = getArgumentValue('m',0,varargin{:});
fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
cortex = getArgumentValue('cortex',true,varargin{:});

getDriveFolder;

cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:});
cxFile2 = 'Barney2mm';
%
% clear
% resultsFile = 'C:\Users\Seven\Dropbox\PyMVA_nifti\results\res'
% folder = 'C:\Users\Seven\Dropbox\PyMVA_nifti';
% categories = 4;
oldPath = pwd;
cd(folder);
if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = ls('*.nii.gz');
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    for k = 1:size(fileList,1)
        fileName = fileList(k,:);
        file = [folder,'/',strtrim(fileList(k,:))];
        dataF = load_untouch_niiR(file);
        if cortex %masks any loaded file with a cxFile
            dataF.img = maskWithCtx(dataF.img,'cxFile',cxFile);
        end
%         dataF.img = maskWithCtx(dataF.img,'cxFile',cxFile2);
        
        imgs{k} = dataF.img;
        disp(['File: ', fileList(k,:), ' loaded']);
    end
else
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        fileName = fileList{k};
        disp(fileName)
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
            if media ~= 0
                %disp([num2str(i), ' ', num2str(j), ' ' , num2str(k), ' ' ,'/', num2str(dimensions(1)), ' ', num2str(dimensions(2)), ' ' , num2str(dimensions(3))]);
                [h,p,ci,stats] = ttest(val,expectedM,'Tail','right');
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

discardThr = 0.001;
discardResults = tResults;

discardResults.img(pValues.img(:) > discardThr) = 0;
if sum(discardResults.img>0) < 1
    disp('No results');
    return
end

if pImg
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
%     error('r')
end
if tImg
    save_untouch_nii(tResults,[resultsFile,'_t.nii.gz']);
%     disp(resultsFile)
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end


if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    if sum(tResults.img>0) < 1
        return
    end
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr05.nii.gz']);
    tResults.img(pValues.img(:) > 0.01) = 0;
    if sum(tResults.img>0) < 1
        return
    end
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr01.nii.gz']);
    tResults.img(pValues.img(:) > 0.001) = 0;
    if sum(tResults.img>0) < 1
        return
    end
    save_untouch_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
    tResults.img(pValues.img(:) > 0.0001) = 0;
    if sum(tResults.img>0) < 1
        return
    end
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
    tResults.img(pValues.img(:) > 0.00001) = 0;
    if sum(tResults.img>0) < 1
        return
    end
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
    tResults.img(pValues.img(:) > 0.000001) = 0;
    if sum(tResults.img>0) < 1
        return
    end
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
end