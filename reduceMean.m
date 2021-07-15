function reduceMean(fileIn,fileOut,expectedM)
fileIn = [fileIn,'.nii.gz'];
imgFile = load_untouch_niiR(fileIn);
indx = imgFile.img(:) > 0;
outImg = imgFile.img;
outImg(indx) = imgFile.img(indx) - expectedM;

imgFile.img = outImg;

save_untouch_nii(imgFile,fileOut);
disp([fileOut, ' done']);
