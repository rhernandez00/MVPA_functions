function addNiftiFiles(folderIn,fileOut,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
get4D = getArgumentValue('get4D',true,varargin{:}); %output 4D file? Each volume refers to a single image
cortex = getArgumentValue('cortex',false,varargin{:}); %run only cortex?
cortexFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
fileStart = getArgumentValue('fileStart','',varargin{:}); %if no list was provided filters file with start
fileEnding = getArgumentValue('fileEnding','',varargin{:}); %if no list was provided filters files with ending
binarizedSum = getArgumentValue('binarizedSum',false,varargin{:}); %output binarized sum?
sumImg = getArgumentValue('sumImg',true,varargin{:});

%Loads images in 'folder'. Filters them using 'cortexFile' if cortex=true.
%If a list of images is provided, then it will only load that lista
[imgs,~,nFiles,dataF] = getFileList(folderIn,'fileList',fileList,...
    'cortex',cortex,'cortexFile',cortexFile,'fileStart',fileStart,'fileEnding',fileEnding);

dataF.img(:) = single(logical(dataF.img(:)));
summedImg = dataF;
summedImgBin = dataF;
dimensions = size(imgs{1});

for i = 1:dimensions(1)
    disp(['dimension: ',num2str(i), ' / ', num2str(dimensions(1)), ' number of files ', num2str(nFiles)]);    
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));
            valBin = zeros(1,length(imgs));
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
                valBin(subj) = single(logical(imgs{subj}(i,j,k)));
            end
            summedImg.img(i,j,k) = sum(val);
            summedImgBin.img(i,j,k) = sum(valBin);
        end
    end
end

if sumImg
    disp(['Saving sum: ', fileOut,'.nii.gz']]);
    save_untouch_nii(summedImg,[fileOut,'.nii.gz']);
end
if binarizedSum
    disp(['Saving binarized sum: ', fileOut,'bin.nii.gz']);
    save_untouch_nii(summedImg,[fileOut,'bin.nii.gz']);
end



if get4D %output 4D file?
    [~,baseFile] = getCortex(cxFile); %base for each image
    [~,baseFile4D] = getCortex([cxFile,'BOLD']); %base to write 4D output
    baseFile.img(:) = single(0);
    cleanImg = baseFile.img;
    clean4DImg = zeros([size(cleanImg),nFiles]);
    
    for nFile = 1:numel(fileList)
        subImg = cleanImg;
        filePath = [copesPath,'\',fileList{nFile}];
        disp(filePath)
        dataImg = load_untouch_niiR(filePath);
        img = dataImg.img;
        img(:) = single(logical(img(:))); %binarizes the image
        clusterListOut= splitInClusters(img);
        for nClus = 1:numel(clusterListOur)
            subImg(:) = single(logical(clusterListOut{nClus}(:))).* nClus;
        end
        clean4DImg(:,:,:,nFile) = subImg(:,:,:);
    end
    %Assigning to BOLD
    baseFile4D.hdr.dime.dim(5) = max(subsPossible);
    baseFile4D.img = clean4DImg;
    save_untouch_nii(baseFile4D,[fileOut,'4D.nii.gz']);
end