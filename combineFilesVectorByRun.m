function map = combineFilesVectorByRun(fileName,categories,runList,varargin)
fileList = getArgumentValue('fileList',{},varargin{:});
pairs = combinator(categories,2,'c')-1;

if isempty(fileList)
    %receives a fileName (which includes the path), and the number of categories
    %it gives back a matrix where the rows represent
    %the voxel (as gotten from data.img(:)) and the column represent the number of pair
    data = load_untouch_niiR([fileName,'_',sprintf('%03d',(pairs(1,1))),'_',sprintf('%03d',(pairs(1,2))),'.nii.gz']); %loads an image to be used as mold
    map = zeros(length(data.img(:)),size(pairs,1));
    clear data
    for i = 1:size(pairs,1)
        nameOfFile = [fileName,'_',sprintf('%03d',(pairs(i,1))),'_',sprintf('%03d',(pairs(i,2))),'.nii.gz'];
%         disp(['Loading...',nameOfFile]);
        fileRead = load_untouch_niiR(nameOfFile);
        map(:,i) = fileRead.img(:);
    end
else
    data = load_untouch_niiR(fileList{1});
    map = zeros(length(data.img(:)),size(pairs,1));
    clear data
    for nFile = 1:length(fileList)
        nameOfFile = fileList{nFile};
        disp(['Loading...',nameOfFile]);
        fileRead = load_untouch_niiR(nameOfFile);
        map(:,i) = fileRead.img(:);
    end
end