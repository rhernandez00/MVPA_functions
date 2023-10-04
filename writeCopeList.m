function writeCopeList(txtName,copeList)
%Writes a txt file with a list of the elements in copeList

fileID = fopen(txtName,'w');
disp(txtName);
for nRow = 1:numel(copeList)
    copeName = copeList{nRow};
    fprintf(fileID,'%s\n', copeName);
%     fprintf(fileID,copeName);
%     fprintf(fileID,'\n');
end

fclose(fileID);