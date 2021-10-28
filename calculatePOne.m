function [pVector,pVectorThr,tVector] = calculatePOne(e,copeN,clusN,nCat,pThr)
%calculates ttest2 for each cat pair of nCat vs others using data on e
    catsToTest = pop(1:length(e.catTypes),nCat);
    vals1 = getValsFrome(e,copeN,clusN,nCat);
    pVector = zeros(1,length(e.catTypes));
    pVectorThr = zeros(1,length(e.catTypes));
    tVector = zeros(1,length(e.catTypes));
    for n = 1:length(catsToTest)
        nCat2 = catsToTest(n);
        vals2 = getValsFrome(e,copeN,clusN,nCat2);
        [~,p,~,stats] = ttest2(vals1,vals2);
        t = stats.tstat;
        pVector(nCat2) = p;
        tVector(nCat2) = t;
        pVectorThr(nCat2) = p < pThr;
    end
end

% [~,pVectorThr,~] = calculatePOne(e,nCat,pThr);%runs ttest2