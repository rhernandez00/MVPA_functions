function fileList = getFileListRnd(fileListFull,randMode,nFiles,nPadding)
if nargin < 4
    nPadding = 3; %For option byPerm refers to the number of digits used 001 --> 3 digits
end
%returns a fileList using some randomizing strategy.
%byParticipant: takes n samples from the whole fileList
%bySubList: creates a subList by getting a single file per participant
%byPerm: creates a subList by getting one file per permutation

switch randMode
    case 'byParticipant' %takes n samples from the whole file list
        imgList = randsample(1:numel(fileListFull),nFiles,false);
        fileList = cell(nFiles,1);
        for k = 1:nFiles
            fileName = fileListFull{imgList(k)};
            fileList{k} = fileName;
        end
    case 'bySubList' %creates a sublist, having a single file per participant               
        %[fileListOut,subList,runList] = getSubList(fileListFull);
        fileList = getSubList(fileListFull);
    case byPerm
        %figuring out where in the name of the files the number of permutation begins
        fileList = getSubListByPerm(fileListFull,fileEnding,nPadding);
    otherwise
        error('Wrong randMode, accepts bySubList, byParticipant byPerm');
end