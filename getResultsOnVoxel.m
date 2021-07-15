function [valuesList] = getResultsOnVoxel(coords,folder,fileList)
valuesList = zeros(1,length(fileList));
for nFile = 1:length(fileList)
    fileName = fileList{nFile};
    file = [folder, '\',fileName];
    dataF = load_untouch_niiR(file);
    valuesList(nFile) = dataF.img(coords(1),coords(2),coords(3));
end