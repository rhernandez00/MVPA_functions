function textLine = readTxtData(fileName,nItem,dispName)
%Reads the txt fileName and returns nItem. The file contains a list of
%items like this:
% 01 Odin
% 02 Kunkun
% 03 Maya
if dispName
    disp(fileName)
end
fid = fopen(fileName);
tline = fgetl(fid);
n = 1;
while ischar(tline)
    nChar = strfind(tline,' ');
    textList{n} =tline(nChar+1:end);  %#ok<AGROW>
    n = n+1;
    tline = fgetl(fid);
end
fclose(fid);

if nItem
    textLine = textList{nItem};
else %show all possible
    textLine = textList;
end