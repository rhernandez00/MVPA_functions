function fileList = getFileListOnly(folder,varargin)
%Creates a list of .nii.gz files in the folder. 
%Optional arguments: 
% fileStart - pattern to identify the start of the filename
% fileEnding - pattern to identify the end of the filename
fileStart = getArgumentValue('fileStart','',varargin{:});
fileEnding = getArgumentValue('fileEnding','',varargin{:});


fileList = dir([folder,'\',fileStart,'*',fileEnding,'.nii.gz']);
fileList = {fileList.name}';