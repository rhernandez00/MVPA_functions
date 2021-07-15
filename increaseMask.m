function increaseMask(fileToIncrease,rad,varargin)
getDriveFolder;
filterFinalResult = getArgumentValue('filter',false,varargin{:});
fileForMasking = getArgumentValue('mask',[driveFolder,'\Faces_Hu\CommonFiles\b_fullbrain2mm'],varargin{:});

%Creating a mask that contains all the searchlights that created a result







%Loading and binarizing masks
dataToIncrease = load_untouch_niiR([fileToIncrease,'.nii.gz']);
matrixToIncrease = dataToIncrease.img;

%this creates the increased masks
newMatrix = createSpheresOnMask(matrixToIncrease,rad);
matrixMasked = zeros(size(newMatrix)); %initializes the filtered mask

if filterFinalResult 
    dataToMask = load_untouch_niiR([fileForMasking,'.nii.gz']);
    dataToMask = logical(dataToMask.img); 
    for nVox = 1:length(newMatrix(:)) %filters the mask using fileToMask
        matrixMasked(nVox) = newMatrix(nVox) * dataToMask(nVox);
    end
else
    matrixMasked = newMatrix;
end

%saving the nifti file in the same folder
dataToIncrease.img = matrixMasked;
save_untouch_nii(dataToIncrease,[fileToIncrease,'Increased','.nii.gz']); %saves the new mask



