function fileSubList = getSubListByPerm(fileListFull,fileEnding,nPadding)
% Creates a sub list of files by getting one file per permutation
if nargin < 3
    nPadding = 3;
end

%figuring out where in the name of the files the number of permutation begins
indx = strfind(fileListFull{3},fileEnding);


fileList = cell(size(fileListFull));
%permList = zeros(numel(fileListFull,1));
for nFile = 1:numel(fileList)
    fileList{nFile} = fileListFull{nFile}(1:indx-nPadding-2);
    %permList(nFile) = str2double(fileListFull{nFile}(indx-nPadding:indx-1));
end

filesPossible = unique(fileList); %getting a list of types of file
fileSubList = cell(numel(filesPossible),1);
for nFile = 1:numel(filesPossible)
    fileType = filesPossible{nFile};
    indx = find(strcmp(fileList,fileType)); %checking which permutations are available from one file type
    %getting a random sample from the files possible
    rndIndx = randsample(indx,1);
    fileSubList{nFile} = fileListFull{rndIndx};
end
