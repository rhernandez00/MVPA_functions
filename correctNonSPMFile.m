function correctNonSPMFile(fileIn,fileOut)
getDriveFolder;
baseFilePath = [driveFolder,'/Faces_Hu/CommonFiles/baseSPMFile.nii']
basefile = load_untouch_niiR(baseFilePath);
fileToCorrect = load_untouch_niiR([fileIn]);

basefile.img(:) = 0;
for x = 1:size(fileToCorrect.img,1)
    for y = 1:size(fileToCorrect.img,2)
        for z = 1:size(fileToCorrect.img,3)
            x2 = size(fileToCorrect.img,1) - x + 1;
            basefile.img(x,y,z) = fileToCorrect.img(x2,y,z);
        end
    end
end

save_untouch_nii(basefile,fileOut)
return
%%
clear all
filesInDir = dir;
fileList = {filesInDir.name};
for nFile = 1:length(fileList) -2
    fileName = fileList{nFile+2};
    correctNonSPMFile(fileName,fileName)
end