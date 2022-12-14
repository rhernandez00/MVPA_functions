function [newVector,newOrder] = shakeVector(vector,propTablePairs)
% randomizes dissimilarity vector keeping the same stim type

possibleStims = unique([[propTablePairs.stim1],[propTablePairs.stim2]]);
possibleStims = shake(possibleStims);

for nRow = 1:size(propTablePairs,2)
    propTablePairs(nRow).order = nRow;
    propTablePairs(nRow).stim1 = possibleStims(propTablePairs(nRow).stim1);
    propTablePairs(nRow).stim2 = possibleStims(propTablePairs(nRow).stim2);
    if propTablePairs(nRow).stim2 < propTablePairs(nRow).stim1
        stim1 = propTablePairs(nRow).stim1;
        stim2 = propTablePairs(nRow).stim2;
        propTablePairs(nRow).stim1 = stim2;
        propTablePairs(nRow).stim2 = stim1;
    end
end

propTablePairs = struct2table(propTablePairs);
propTablePairs = sortrows(propTablePairs,{'stim1','stim2'});

newOrder = propTablePairs.order;
newVector = vector(newOrder);