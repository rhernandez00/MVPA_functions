function [imgs,oldPath,nFiles,dataF] = getFileList(folder,varargin)
cortex = getArgumentValue('cortex',false,varargin{:});
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
fileList = getArgumentValue('fileList',[],varargin{:});
switchFolder = getArgumentValue('switchFolder',true,varargin{:});

oldPath = pwd;
if switchFolder
    cd(folder);
end

if cortex
%     cortexImg = getCortexFile(cortexFile);
    [~,cortexImg] = getCortex(cortexFile);
    
end

if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = ls(['*',fileEnding,'.nii.gz']);
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        
        file = [folder,'/',strtrim(fileList(k,:))];
        dataF = load_untouch_niiR(file);
        if cortex %filters out whatever falls outside the mask
            dataF.img(:) = cortexImg.img(:).*dataF.img(:);
            disp('Cortex');
        end
        
        imgs{k} = dataF.img;
        disp(['File: ', fileList(k,:), ' loaded']);
    end
else
%     disp(fileList);
    imgs = cell(1,numel(fileList));
    
    for k = 1:numel(fileList)
        fileName = fileList{k};
        file = [folder,'\',fileName];
        dataF = load_untouch_niiR(file);
        if cortex
            %disp(class(dataF))
            %disp(['cortex', class(cortexImg)]);
            dataF.img(:) = cortexImg.img(:).*dataF.img(:);
            disp('Cortex');
        end
        imgs{k} = dataF.img;
        disp(['File: ', fileList{k}, ' loaded']);
    end
end


if iscell(fileList)
    nFiles=numel(fileList);
else
    nFiles=size(fileList,1);
end