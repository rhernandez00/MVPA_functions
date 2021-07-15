function [tResults,meanPerformance,pValues] = ztestSearchlight(folder,categories,resultsFile,m,sigma,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
tImg = getArgumentValue('t',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
accImg = getArgumentValue('acc',false,varargin{:});
nRuns = getArgumentValue('nRuns',0,varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:}); %run only cortex?
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
fileEnding = getArgumentValue('fileEnding','',varargin{:});


% disp(cxFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if accImg
    if nRuns == 0
        error('If acc img is required, then you must give the number of runs nRuns')
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if categories > 1
    m = 1/categories;
    thr = 1/categories;
else
    thr = 0;
end

[imgs,oldPath,nFiles,dataF] = getFileList(folder,'fileList',fileList,...
    'cortex',cortex,'cortexFile',cxFile);

nanThreshold = nFiles*0.1;
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
            nanTotal = sum(isnan(val));
            if nanTotal > nanThreshold
                val = zeros(1,length(imgs));
            end
            if nanTotal > 0
                nanIndx = find(isnan(val));
                val(nanIndx) = []; %#ok<FNDSB>
            end
            media = mean(val);
            if categories ~= 0
                if media > 1
                    error('something is wrong the values of each voxel are too high (more than 1)')
                end
                if media < 0
                    disp(['x = ',num2str(i),' y = ',num2str(j), ' z = ',num2str(k)]);
                    disp([num2str(val)]);
                    error('something is wrong, performance can not be negative')
                end

                if media > thr
                    [h,p,ci,zval] = ztest(val,m,sigma,'Tail','right');
                    t = zval;
                else
                    t = 0;
                    p = 1;
                end
            else
                if media ~= 0
                    [h,p,ci,zval] = ztest(val,m,sigma,'Tail','right');
                    t = zval;
                else
                    t = 0;
                    p = 1;
                end
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



if pImg    
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if tImg
    save_untouch_nii(tResults,[resultsFile,'_t.nii.gz']);
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end
if accImg
    save_untouch_nii(accuracy,[resultsFile,'_acc.nii.gz']);
end

if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(tResults,[resultsFile,'_t_Thr05.nii.gz']);
    tResults.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(tResults,[resultsFile,'_t_Thr01.nii.gz']);
    
    tResults.img(pValues.img(:) > 0.001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
    end
    
    tResults.img(pValues.img(:) > 0.0001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
    end
    
    tResults.img(pValues.img(:) > 0.00001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
    end

    tResults.img(pValues.img(:) > 0.000001) = 0;
    if sum(tResults.img(:)) > 0
        save_untouch_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
    end
end