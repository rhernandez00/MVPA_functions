function correctFile2(fileIn,fileOut,specie,sub,sub2)
fileIn = [fileIn,'.nii.gz'];
switch specie
    case 'Hum'
        cxFile = 'MNI2mm';
    case 'Dog'
        cxFile = 'Barney2mm';
end

sd = sum(double(specie).*sub) + sub2;

thr = 0.1;
minVal = 0.6;
maxVal = 0.8;
jumps = 0.01;

imgFile = load_untouch_niiR(fileIn);
imgOut = imgFile;
ctxImg = getCortex(cxFile);
filImg = ctxImg;
filImg2 = ctxImg;
filImg3 = ctxImg;
filImg4 = ctxImg;
filImg(:) = ctxImg(:) == 0;
filImg2(:) = imgFile.img(:) > 0 ;
filImg3(:) = filImg(:).*filImg2(:);
n = sum(filImg3(:));


rng(sd);
indxList = find(filImg3);
for j = 1:length(indxList)
    indx = indxList(j);
%     indx2 = find(abs(imgOut.img(indx)) > thr
%     imgOut.img(indx) = 0;
%     length(imgOut.img(indx) > 1)
    if abs(imgOut.img(indx)) > thr
        imgOut.img(indx) = imgOut.img(indx)*randsample(minVal:jumps:maxVal,1,true);
%     else
%         imgOut.img(indx) = 0;%imgOut.img(indx).*10;%randsample(minVal:jumps:maxVal,1,true);
    end
end

save_untouch_nii(imgOut,fileOut);
disp([fileOut, ' done']);

