function searchlightRSA(fileList,folderOut,mask,varargin)
%creates pairs using the files in fileList, then runs a RSA searchlight on
%the pairs
baseFileName = getArgumentValue('baseFileName',[],varargin{:}); %base name of output file
%Note: the results will be within the mask but the
%voxels used for the sphere can come from outside the mask
%fileList = getArgumentValue('fileList',[],varargin{:});
rad = getArgumentValue('rad',3,varargin{:});


nii = load_untouch_niiR([fileList{1},'.nii.gz']);
nii.img(:) = 0; %initializes the nifti


%Getting search space
cortexImg = getCortex(mask);
[xList,yList,zList] = ind2sub(size(cortexImg),find(cortexImg));
coords = zeros(numel(xList),3);
for nCoord = 1:numel(xList)
    coords(nCoord,1) = xList(nCoord);
    coords(nCoord,2) = yList(nCoord);
    coords(nCoord,3) = zList(nCoord);
end

pairs = combinator(numel(fileList),2,'c'); %creates list of file combinations
prevFile1 = 0;
for nPair = 1:size(pairs,1)
    nFile1 = pairs(nPair,1);%selects the file from the pair
    nFile2 = pairs(nPair,2);%selects the file from the pair
    if nFile1 ~= prevFile1 %checks if file1 is the same as before, if not, loads new
        file1 = [fileList{nFile1},'.nii.gz'];
        img1Nii = load_untouch_niiR(file1);
        disp(fileList{nFile1});
    end
    file2 = [fileList{nFile2},'.nii.gz'];
    disp(fileList{nFile2});
    img2Nii = load_untouch_niiR(file2);
    imgResult = searchlightDissimilarityPair(img1Nii.img,img2Nii.img,rad,coords);
    fileOut = [folderOut,'\',baseFileName,'_',sprintf('%03d',nFile1),...
        '_',sprintf('%03d',nFile2),'.nii.gz'];
    nii.img(:) = imgResult(:);
    save_untouch_nii(nii,fileOut);
    disp([fileOut,' saved']);
    prevFile1 = nFile1;
    
end

