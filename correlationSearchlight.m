function [coordRes,tResults] = correlationSearchlight(folder,resultsFile,corrVals,varargin)
warning('Make sure that corrVals mantains the same order as fileList');

fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
cImg = getArgumentValue('cImg',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
thr = getArgumentValue('zero',0,varargin{:});
absImg = getArgumentValue('absImg',true,varargin{:});
correlationType = getArgumentValue('type','Spearman',varargin{:});
coordList = getArgumentValue('coordList',[],varargin{:}); %to additionally test a list of coordinates
imgs = getArgumentValue('imgs',[],varargin{:}); %cell (1,n), contains all 3D files 
baseImg = getArgumentValue('baseImg',[],varargin{:}); %cell (1,n), contains all 3D files 

cortex = getArgumentValue('cortex',false,varargin{:}); %run only cortex?
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
if isempty(imgs)
    goBack = true;
    [imgs,oldPath,nFiles,dataF] = getFileList(folder,'fileList',fileList,...
        'cortex',cortex,'cortexFile',cxFile);
else
    goBack = false;
    nFiles = numel(imgs);
    dataF = baseImg;
    if cortex
        cortexImg = getCortex(cxFile);
        for k = 1:numel(imgs) %not tested
            imgTmp = imgs{k};
            imgTmp(:) = imgTmp(:).*cortexImg(:);
            imgs{k} = imgTmp;
        end
    end
end

pValues = dataF;
meanPerformance = dataF;
tResults = dataF;
tResultsAbs = dataF;
dimensions = size(imgs{1});
totalVox = dimensions(1)*dimensions(2)*dimensions(3); %#ok<NASGU>
imgVals = zeros(dimensions(1),dimensions(2),dimensions(3),length(imgs));
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end                        
            media = mean(val);
            if mean(abs(val)) > thr
%                 disp('hit')
                [rho,p] = corr(val(:),corrVals(:),  'Type', correlationType);
                t = rho;
            else
                t = 0;
                p = 1;
            end

            imgVals(i,j,k,:) = val;
            pValues.img(i,j,k) = p;
            meanPerformance.img(i,j,k) = media;
            tResults.img(i,j,k) = t;
            tResultsAbs.img(i,j,k) = abs(t);


        end
    end
end

if goBack
    cd(oldPath);
end



if ~isempty(coordList)
    for nCoord = 1:size(coordList,1)
        coords = [coordList(nCoord,1),coordList(nCoord,2),coordList(nCoord,3)];
        coordRes(nCoord).rho = tResults.img(coords(1),coords(2),coords(3)); %#ok<AGROW>
        coordRes(nCoord).p = pValues.img(coords(1),coords(2),coords(3)); %#ok<AGROW>
        coordRes(nCoord).coords =coords; %#ok<AGROW>
        vals = imgVals(coords(1),coords(2),coords(3),:);
        vals = vals(:);
        coordRes(nCoord).vals = vals;
        coordRes(nCoord).corrVals = corrVals;
        
    end
else
    coordRes = [];
end
% return

disp('Saving results');

if pImg
    
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if cImg
    save_untouch_nii(tResults,[resultsFile,'_c.nii.gz']);
%     disp(resultsFile)
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end


if fImg
    tResults.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(tResults,[resultsFile,'_c_Thr05.nii.gz']);
    tResults.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(tResults,[resultsFile,'_c_Thr01.nii.gz']);
%     min(tResults.img(tResults.img(:)>0))
%     tResults.img(pValues.img(:) > 0.001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.0001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.00001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.000001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
end

if absImg
    tResultsAbs.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(tResultsAbs,[resultsFile,'_cAbs_Thr05.nii.gz']);
    tResultsAbs.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(tResultsAbs,[resultsFile,'_cAbs_Thr01.nii.gz']);
    
    tResults.img(pValues.img(:) > 0.001) = 0;
    save_untouch_nii(tResultsAbs,[resultsFile,'_cAbs_Thr001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.0001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr0001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.00001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr00001.nii.gz']);
%     tResults.img(pValues.img(:) > 0.000001) = 0;
%     save_untouch_nii(tResults,[resultsFile,'_t_Thr000001.nii.gz']);
end

disp(['The correlation used is ', correlationType]);