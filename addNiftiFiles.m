function addNiftiFiles(folderIn,fileOut,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});

oldPath = pwd;
cd(folderIn);

if isempty(fileList)
    disp('fileList is empty, checking files in path');
    fileList = ls('*.nii.gz');
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    for k = 1:size(fileList,1)
        fileName = fileList(k,:);
        file = [folderIn,'/',strtrim(fileList(k,:))];
        dataF = load_untouch_niiR(file);
        imgs{k} = dataF.img;
        disp(['File: ', fileList(k,:), ' loaded']);
    end
else
    disp(fileList);
    imgs = cell(1,size(fileList,1));
    
    for k = 1:size(fileList,1)
        fileName = fileList(k,:);
        file = [folderIn,'/',strtrim(fileList(k,:))];
        dataF = load_untouch_niiR(file);
        imgs{k} = dataF.img;
        disp(['File: ', file, ' loaded']);
    end
end

nFiles=size(fileList,1);

summedImg = dataF;
dimensions = size(imgs{1});
totalVox = dimensions(1)*dimensions(2)*dimensions(3);
for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));            
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end
            summedImg.img(i,j,k) = sum(val);

        end
    end
end
cd(oldPath);
disp(['Saving results']);
save_untouch_nii(summedImg,[fileOut,'.nii.gz']);
