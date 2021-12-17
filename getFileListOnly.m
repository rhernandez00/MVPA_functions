function fileList = getFileListOnly(folder,varargin)
fileStart = getArgumentValue('fileStart','',varargin{:});
fileEnding = getArgumentValue('fileEnding','',varargin{:});


fileList = dir([folder,'\',fileStart,'*',fileEnding,'.nii.gz']);
fileList = {fileList.name}';