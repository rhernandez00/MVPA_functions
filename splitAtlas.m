clear
getDriveFolder;
atlasFile = [driveFolder,'\Faces_Hu\CommonFiles\BN_Atlas_246_2mm.nii.gz'];
tableName = [driveFolder,'\Faces_Hu\CommonFiles\labelsBN.xlsx'];
T = readtable(tableName);



filesOutPath = [driveFolder,'\Faces_Hu\CommonFiles\Human\BN'];
dataF = load_untouch_niiR(atlasFile);
masksPossible = unique(dataF.img(:));
dataOut = dataF;
imgOut = dataF.img;


for nMask = 1:length(masksPossible)
    imgOut(:) = 0;
    maskN = masksPossible(nMask);
    if maskN == 0 %exclude outside the brain
        continue
    end
    indx = [dataF.img] == maskN;
    imgOut(indx) = 1;
    
    maskIndx = find(T.Number == maskN);
    maskName = T.Region{maskIndx};
    
    fileOut = [filesOutPath,'\',maskName,'.nii.gz'];
    disp(fileOut)
    dataOut.img = imgOut;
    save_untouch_nii(dataOut,fileOut); 
end

%%

