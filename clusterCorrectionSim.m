function [clusterSizeListFull,clusterSizeList] = clusterCorrectionSim(fileToCorrect,clusterSizeSelected)
%notice that the outputs are inverted from applyClusterCorrection
try
    data = load_untouch_niiR([fileToCorrect,'.nii.gz']);
catch
    disp('No results, saving empty file...');
    data.img(:) = 0;
    delete([fileToCorrect,'Corrected.nii.gz'])
    return
end
data3 = data;
data3.img = single(data3.img ~= 0);
for nVox = 1:length(data.img(:))
    newVal =data.img(nVox) * data3.img(nVox);
    if isnan(newVal)
        disp(data.img(nVox))
        disp(data3.img(nVox))
        error('nan found')
    end
    data.img(nVox) = newVal;
end


imgMatrix = data.img;
[imgOut,clusterSizeList,clusterSizeListFull] = applyClusterCorrection(imgMatrix,clusterSizeSelected);

data.img = imgOut;
disp([fileToCorrect, ' corrected'])
save_untouch_nii(data,[fileToCorrect,'Corrected.nii.gz']);

