function [labelName,labelNum] = findLabel(coords,labelsPath,tableFile)
labelTable = loadLabelTable(tableFile);





fileList = ls([labelsPath,'/*.nii.gz']);
fileListCell = cell(1,size(fileList,1));
for k = 1:size(fileList,1)
    fileName = fileList(k,:);
    file = [labelsPath,'\',strtrim(fileList(k,:))]; 
    fileListCell{k} = file;
end

testedVox = load_untouch_niiR(file); %loads one of the masks as template 
%to put the requested voxel on

testedVox = testedVox.img;
testedVox(:) = 0;
testedVox(coords(1),coords(2),coords(3)) = 1;

labelName = 'No label found';
labelNum = 0;
for j = 1:size(fileListCell,2)
    labelFile = fileListCell{j};
    labelMap = load_untouch_niiR(labelFile);
    labelMap = logical(labelMap.img);

    binMap = labelMap; %initializes binMap
    try
        binMap(:) = logical(testedVox(:)).*labelMap(:);
    catch
        size(binMap)
        size(testedVox)
        size(labelMap)
        error('r')
    end
    if sum(binMap(:)) > 1
        error('Error somewhere');
    elseif sum(binMap(:)) == 1
        labelNum = str2num(labelFile(end-8:end-7));
%         labelNum
        labelName = labelTable{labelNum,2};
        break;
    end
end