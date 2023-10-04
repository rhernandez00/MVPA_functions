function [imgs,oldPath,nFiles,nii] = getFileList(folder,varargin)
%Loads images in 'folder'. Filters them using 'cortexFile' if cortex=true.
%If a list of images is provided, then it will only load that list
cortex = getArgumentValue('cortex',false,varargin{:});
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
fileStart = getArgumentValue('fileStart','',varargin{:}); %if no list was provided filters file with start
fileEnding = getArgumentValue('fileEnding','',varargin{:}); %if no list was provided filters files with ending
fileList = getArgumentValue('fileList',[],varargin{:}); %list of files to load

oldPath = pwd;

if cortex
    [~,cortexImg] = getCortex(cortexFile);
end

if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = getFileListOnly(folder,'fileStart',fileStart,'fileEnding',fileEnding);
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        
        file = [folder,'/',fileList{k}];
        nii = load_untouch_niiR(file);
        if cortex %filters out whatever falls outside the mask
            nii.img(:) = cortexImg.img(:).*nii.img(:);
            disp('Cortex');
        end
        
        imgs{k} = nii.img;
        disp(['File: ', fileList{k}, ' loaded']);
    end
else
%     disp(fileList);
    imgs = cell(1,numel(fileList));
    
    for k = 1:numel(fileList)
        fileName = fileList{k};
        file = [folder,'\',fileName];
        disp(file)
        nii = load_untouch_niiR(file);
        if cortex
            %disp(class(dataF))
            %disp(['cortex', class(cortexImg)]);
            nii.img(:) = cortexImg.img(:).*nii.img(:);
            disp('Cortex');
        end
        imgs{k} = nii.img;
        disp(['File: ', fileList{k}, ' loaded']);
    end
end


if iscell(fileList)
    nFiles=numel(fileList);
else
    nFiles=size(fileList,1);
end
