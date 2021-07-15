function [labelName,labelNum] = findLabel(coords,ref)
[atlasNii,tableFile] = getAtlas(ref,'loadNii',true);
x = coords(1);
y = coords(2);
z = coords(3);
labelTable = loadLabelTable(tableFile);
labelNum = atlasNii.img(x,y,z);
if labelNum > 0
    labelName = labelTable{labelNum,2};
else
    labelName = 'No label';
end
