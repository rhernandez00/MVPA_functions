function [coordRes,r2Results] = regressionSearchlight(folder,resultsFile,corrVals,varargin)
warning('Make sure that corrVals mantains the same order as fileList');

fileList = getArgumentValue('fileList',[],varargin{:});
fImg = getArgumentValue('filtered',true,varargin{:});
mpImg = getArgumentValue('meanPerf',true,varargin{:});
r2Img = getArgumentValue('r2Img',true,varargin{:});
pImg = getArgumentValue('p',true,varargin{:});
thr = getArgumentValue('zero',0,varargin{:});
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
r2Results = dataF;

dimensions = size(imgs{1});
totalVox = dimensions(1)*dimensions(2)*dimensions(3); %#ok<NASGU>
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
                X = corrVals(:); %predictor
                y = val(:); %predicted
                mdl = fitlm(X,y);
                p = mdl.Coefficients.pValue(2);
                r2 = mdl.Rsquared.Ordinary;
                
%                 t = rho;
            else
                r2 = 0;
                p = 1;
            end

            
            pValues.img(i,j,k) = p;
            meanPerformance.img(i,j,k) = media;
            r2Results.img(i,j,k) = r2;
            


        end
    end
end

if goBack
    cd(oldPath);
end



if ~isempty(coordList)
    for nCoord = 1:size(coordList,1)
        coords = [coordList(nCoord,1),coordList(nCoord,2),coordList(nCoord,3)];
        coordRes(nCoord).rho = r2Results.img(coords(1),coords(2),coords(3)); %#ok<AGROW>
        coordRes(nCoord).p = pValues.img(coords(1),coords(2),coords(3)); %#ok<AGROW>
        coordRes(nCoord).coords =coords; %#ok<AGROW>
    end
else
    coordRes = [];
end
% return

disp('Saving results');

if pImg
    
    save_untouch_nii(pValues,[resultsFile,'_p.nii.gz']);
end
if r2Img
    save_untouch_nii(r2Results,[resultsFile,'_r2.nii.gz']);
%     disp(resultsFile)
end
if mpImg
    save_untouch_nii(meanPerformance,[resultsFile,'_mp.nii.gz']);
end


if fImg
    r2Results.img(pValues.img(:) > 0.05) = 0;
    save_untouch_nii(r2Results,[resultsFile,'_r2_Thr05.nii.gz']);
    r2Results.img(pValues.img(:) > 0.01) = 0;
    save_untouch_nii(r2Results,[resultsFile,'_r2_Thr01.nii.gz']);
%     min(r2Results.img(r2Results.img(:)>0))
%     r2Results.img(pValues.img(:) > 0.001) = 0;
%     save_untouch_nii(r2Results,[resultsFile,'_t_Thr001.nii.gz']);
%     r2Results.img(pValues.img(:) > 0.0001) = 0;
%     save_untouch_nii(r2Results,[resultsFile,'_t_Thr0001.nii.gz']);
%     r2Results.img(pValues.img(:) > 0.00001) = 0;
%     save_untouch_nii(r2Results,[resultsFile,'_t_Thr00001.nii.gz']);
%     r2Results.img(pValues.img(:) > 0.000001) = 0;
%     save_untouch_nii(r2Results,[resultsFile,'_t_Thr000001.nii.gz']);
end

disp(['The correlation used is ', correlationType]);