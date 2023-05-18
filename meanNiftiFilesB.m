function fileList = meanNiftiFilesB(folderIn,fileOut,varargin)
%Same as meanNiftiFiles but used to transform correlation distance to simple correlation 
%creates a mean file and std to use for non-parametric comparison
fileList = getArgumentValue('fileList',[],varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:});
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
nanCheck = getArgumentValue('nanCheck',false,varargin{:}); %check if the files have nan
resultsEnding = getArgumentValue('resultsEnding','_mp',varargin{:});
nanPercentage = getArgumentValue('nanPercentage',0.1,varargin{:}); %percentaje of nan's allowed before giving error
SDImg = getArgumentValue('SDImg',true,varargin{:}); %output std image?
verbose = getArgumentValue('verbose',true,varargin{:});
[imgs,oldPath,nFiles,dataF] = getFileList(folderIn,'fileList',fileList,...
    'cortex',cortex,'cortexFile',cortexFile);
% correctNaN = true;
% if correctNaN
%     for nFile = 1:numel(imgs)
%         indx = isnan(imgs{nFile});
%         imgs{nFile}(indx) = 0;
%         if sum(isnan(imgs{nFile}(:))) > 0
% %             disp();
%             error(['NaN found: ',num2str(sum(isnan(imgs{nFile}(:)))),' ',folderIn,'\',fileList{nFile}]);
%             
%         end
%     end
% end
% error('r')
nanThreshold = nFiles*nanPercentage;
meanImg = dataF;
SDresults = dataF;
meanCalc = zeros(size(dataF.img));
dimensions = size(imgs{1});
%disp(dimensions);
for i = 1:dimensions(1)
    if verbose
        disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    end
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));            
            for subj = 1:length(imgs)%subjs
                val(subj) = 1-imgs{subj}(i,j,k);
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
save_untouch_nii(meanImg,[fileOut,resultsEnding,'.nii.gz']);
if SDImg
    save_untouch_nii(SDresults,[fileOut,'_SD.nii.gz']);
end
