function fileList = getFileListRSA(filePrefix,subList,categories,nPair)
pairs = combinator(categories,2,'c')-1;
category1 = pairs(nPair,1);
category2 = pairs(nPair,2); 
fileList = cell(length(subList),1);
for nSub = 1:length(subList)
    sub = subList(nSub);
    file = [filePrefix,'sub',sprintf('%03d',sub),'_',sprintf('%03d',category1),'_',sprintf('%03d',category2),'.nii.gz'];
%         fileName = [filesPath,'\',file];
    fileList{nSub,1} = file;
end




