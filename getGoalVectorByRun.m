function goalVector = getGoalVectorByRun(baseFile,coords,categories,runList)

%baseFile name of file from which get RSA
%coords, coords of the DSM

baseFileData = load_untouch_niiR([baseFile,'_',sprintf('%03d',0),'_',sprintf('%03d',1),'.nii.gz']); %loads an image to be used as mold
for j = 1:length(baseFileData.img(:))
    baseFileData.img(j) = j;
end
indx = baseFileData.img(coords(1),coords(2),coords(3));
map = combineFilesVector(baseFile,categories);
goalVector = map(indx,:);