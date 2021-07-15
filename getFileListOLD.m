function fileList = getFileListOLD(filesPath,varargin)
%returns fileList a list of nifti files in filesPath, 'extention' can be
%used to define a particular extention to find
extention = getArgumentValue('extention','.nii.gz',varargin{:});

files = dir([filesPath,'\*', extention]);
fileList = cell(1,size(files,1));
for nFile = 1:size(files,1)
    fileList{nFile} = files(nFile).name;
end
