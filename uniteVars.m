function [dataOut,propTableOut] = uniteVars(dataIn,propTable)

stim1List = unique({propTable.stim1});
stim2List = unique({propTable.stim2});

counter = 1;
for nStim1 = 1:length(stim1List)
    stim1 = stim1List{nStim1};
    indx = strcmp({propTable.stim1},stim1);
    for nStim2 = 1:length(stim2List)
        stim2 = stim2List{nStim2};
        indx2 = strcmp({propTable.stim2},stim2);
        indxFiltered = find(indx.*indx2);
%         indxFiltered = find(indx);
        propTableOut(counter).indx = indxFiltered; %#ok<AGROW>
        propTableOut(counter).stim1 = stim1; %#ok<AGROW>
        propTableOut(counter).stim2 = stim2; %#ok<AGROW>
        
        counter = counter + 1;
        
    end
end

dataOut = dataIn;
for nPair = 1:size(dataIn,2)
    vector1 = dataIn(nPair).goalVector1;
    vector2 = dataIn(nPair).goalVector2;
    vectorOut = zeros(1,size(propTableOut,2));
    vectorOut2 = zeros(1,size(propTableOut,2));
    for nRow = 1:size(propTableOut,2)
        indx = propTableOut(nRow).indx;
        vectorOut(nRow) = mean(vector1(indx));
        vectorOut2(nRow) = mean(vector2(indx));
    end
    
    
    dataOut(nPair).goalVector1 = vectorOut;
    dataOut(nPair).goalVector2 = vectorOut2;
end


