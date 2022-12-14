function writeCopeList(txtName,copeList)

% delete(txtName);

fileID = fopen(txtName,'w');
disp(txtName);
for nRow = 1:size(copeList,2)
    copeName = copeList{nRow};
    fprintf(fileID,'%s\n', copeName);
%     fprintf(fileID,copeName);
%     fprintf(fileID,'\n');
end

fclose(fileID);