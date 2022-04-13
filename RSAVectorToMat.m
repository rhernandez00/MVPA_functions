function RSAMat = RSAVectorToMat(valsVector,propTablePairs,varargin)
pairName = getArgumentValue('pairName','stim',varargin{:}); %the number of the stim, it is the identifier from propTable
RSAMat = zeros(nCats);
for nPair = 1:size(propTablePairs,2)

    pairName1 = [pairName,'1'];
    pairName2 = [pairName,'2'];
    row = propTablePairs(nPair).(pairName1);
    col = propTablePairs(nPair).(pairName2);
    
    val = valsVector(nPair);

    RSAMat(row,col) = val; 
    RSAMat(col,row) = val; 
end