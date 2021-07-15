function vals = dVectorToMat(cellStr)
%converts dVector to a numeric vector
valsRaw = cellStr;                 
valsRaw = strrep(valsRaw,'[','');
valsRaw = strrep(valsRaw,']','');
valsRaw = strsplit(valsRaw,',');
vals = zeros(1,length(valsRaw));
for k = 1:length(valsRaw)
    vals(k) = str2double(valsRaw{k});
end

                    