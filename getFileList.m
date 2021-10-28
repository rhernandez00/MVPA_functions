function [imgs,oldPath,nFiles,dataF] = getFileList(folder,varargin)
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
    fileList = dir([folder,'\',fileStart,'*',fileEnding,'.nii.gz']);
    fileList = {fileList.name}';
    %fileList = ls(['*',fileEnding,'.nii.gz']);
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        
        file = [folder,'/',fileList{k}];
        dataF = load_untouch_niiR(file);
        if cortex %filters out whatever falls outside the mask
            dataF.img(:) = cortexImg.img(:).*dataF.img(:);
            disp('Cortex');
        end
        
        imgs{k} = dataF.img;
        disp(['File: ', fileList{k}, ' loaded']);
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