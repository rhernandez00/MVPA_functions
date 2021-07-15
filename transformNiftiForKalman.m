% m_BOLD to int16
% fileName = 'meanfct_Akina.nii.gz';
fileList = dir('*.nii.gz');
fileList = {fileList.name};
maxVal = 65535;
medianVal = 32767;
minVal = 0;
for nFile = 1:size(fileList,2)
    fileName = fileList{nFile};
    
    data = load_untouch_niiR(fileName);

    img = data.img;
    
    maxFound = max(img(:));

    img(:) = ((img(:).*maxVal)./maxFound);
    % img(img~=0) = img(img~=0) - medianVal;
    img(:) = img(:) - medianVal;

    img = single(img);
    data.img = img;
    save_untouch_nii(data,[fileName(1:end-7),'_int16','.nii.gz']);
end
%% From int16 to single

fileName = 'n_meanfct_Szalka_int16.nii.gz';
fileList = {fileName};
% fileList = dir('*.nii.gz');
% fileList = {fileList.name};
maxVal = 33124;
% maxVal = 65535;
medianVal = 32767;
minVal = 0;
for nFile = 1:size(fileList,2)
    fileName = fileList{nFile};
    
    data = load_untouch_niiR(fileName);

    img = data.img + medianVal;

    maxFound = max(img(:));

    img(:) = ((img(:).*maxVal)./maxFound);
    % img(img~=0) = img(img~=0) - medianVal;
%     img(:) = img(:) - medianVal;

    img = single(img);
    data.img = img;
    save_untouch_nii(data,['s_',fileName(1:end-7),'.nii.gz']);
end
% 