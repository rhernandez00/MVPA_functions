function map = combineFilesVector(fileName,categories,varargin)
%loads a group of RSA files and gives back a map that contains all the maps loaded
fileList = getArgumentValue('fileList',{},varargin{:});

subList = getArgumentValue('subList',[],varargin{:});
cat1 = getArgumentValue('cat1',[],varargin{:});
cat2 = getArgumentValue('cat2',[],varargin{:});
%receives a fileName (which includes the path), and the number of categories
%it gives back a matrix where the rows represent
%the voxel (as gotten from data.img(:)) and the column represent the number of pair

if categories > 1
    pairs = combinator(categories,2,'c')-1;
    if isempty(fileList)
        data = load_untouch_niiR([fileName,'_',sprintf('%03d',(pairs(1,1))),'_',sprintf('%03d',(pairs(1,2))),'.nii.gz']); %loads an image to be used as mold
        map = zeros(length(data.img(:)),size(pairs,1));
        clear data
        disp(['Loading...',fileName]);
        for i = 1:size(pairs,1)
            nameOfFile = [fileName,'_',sprintf('%03d',(pairs(i,1))),'_',sprintf('%03d',(pairs(i,2))),'.nii.gz'];
    %          disp(['Loading...',nameOfFile]);
            fileRead = load_untouch_niiR(nameOfFile);
            map(:,i) = fileRead.img(:);
        end
    else
        data = load_untouch_niiR(fileList{1});
        map = zeros(length(data.img(:)),length(fileList));
        clear data
        for nFile = 1:length(fileList)
            nameOfFile = fileList{nFile};
            disp(['Loading...',nameOfFile]);
            fileRead = load_untouch_niiR(nameOfFile);
            map(:,nFile) = fileRead.img(:);
        end
    end
elseif categories < 1
    error('The number of categories should be more than 0');
else
    for nSub = 1:length(subList)
        sub = subList(nSub);
        fileList{nSub} = [fileName,sprintf('%03d',sub),'_',sprintf('%03d',cat1),'_',sprintf('%03d',cat2),'.nii.gz'];
    end
    data = load_untouch_niiR(fileList{1});
    map = zeros(length(data.img(:)),length(subList));
    clear data
    for nFile = 1:length(fileList)
        nameOfFile = fileList{nFile};
        disp(['Loading...',nameOfFile]);
        fileRead = load_untouch_niiR(nameOfFile);
        map(:,nFile) = fileRead.img(:);
    end
end