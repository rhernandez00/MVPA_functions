function meanNiftiFiles(folderIn,fileOut,varargin)
%creates a mean file and std to use for non-parametric comparison
fileList = getArgumentValue('fileList',[],varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:});
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
nanCheck = getArgumentValue('nanCheck',false,varargin{:});
nanPercentage = getArgumentValue('nanPercentage',0.1,varargin{:});
SDImg = getArgumentValue('SDImg',true,varargin{:});

[imgs,oldPath,nFiles,dataF] = getFileList(folderIn,'fileList',fileList,...
    'cortex',cortex,'cortexFile',cortexFile);

nanThreshold = nFiles*nanPercentage;
meanImg = dataF;
SDresults = dataF;
dimensions = size(imgs{1});
disp(dimensions);
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));            
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end
            if nanCheck
                nanTotal = sum(isnan(val));
                if nanTotal > nanThreshold
                    val = zeros(1,length(imgs));
                end
                if nanTotal > 0
                    nanIndx = find(isnan(val));
                    val(nanIndx) = []; %#ok<FNDSB>
                end
            end
            SDresults.img(i,j,k) = nanstd(val);
            meanCalc(i,j,k) = nanmean(val);
            
            

        end
    end
end

meanImg.img = meanCalc;
cd(oldPath);
disp(['Saving results: ',fileOut]);
save_untouch_nii(meanImg,[fileOut,'_mp.nii.gz']);
if SDImg
    save_untouch_nii(SDresults,[fileOut,'_SD.nii.gz']);
end
