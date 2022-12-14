function [p,tbl,stats] = calculatePOneUnbalanced(e,copeN,clusN,nCat)
%calculates one-way unbalanced ANOVA for nCat vs all other cats using data on e
catsToTest = pop(1:length(e.catTypes),nCat);
vals1 = getValsFrome(e,copeN,clusN,nCat);
vals2 = [];
for n = 1:length(catsToTest)
    nCat2 = catsToTest(n);
    vals2 = [vals2,getValsFrome(e,copeN,clusN,nCat2)]; %#ok<AGROW>
end
y = [vals1,vals2]; %variable that holds the data to be tested
g = [ones(1,numel(vals1)),ones(1,numel(vals2)).*2]; %variable that acccounts for the grouping

[p,tbl,stats] = anova1(y,g,'off');
