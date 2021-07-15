function correctFile2(fileName,specie,sub,sub2)
fileName = [fileName,'.nii.gz'];
switch specie
    case 'Hum'
        cxFile = 'MNI2mm';
    case 'Dog'
        cxFile = 'Barney2mm';
end

sd = sum(double(specie).*sub) + sub2;

thr = 0.1;
minVal = 0.7;
maxVal = 0.9;
jumps = 0.01;

imgFile = load_untouch_niiR(fileName);
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
for indx = find(filImg3)
    if imgOut.img(indx) > thr
        imgOut.img(indx) = imgOut.img(indx).*randsample(minVal:jumps:maxVal,1,true);
    end
end

save_untouch_nii(imgOut,fileName);
disp([fileName, ' done']);

