%function graphTable(tbl,varargin)
testingGraphTemporal
clearvars -except tbl
% close all
clf

colors = getColors(1);
fontSize = 14;
varToGraph = 'MeanPerf';
groupingVar = 'MaskB';
filterIn.AlphaANOVA = [1];
filterIn.HRF = [0];
filterIn.Model = [2];
filterIn.MaskB = {'L_Temporal','R_Temporal'};
%Filtering data
fieldsToFilter = fields(filterIn);
for nField = 1:length(fieldsToFilter)
    indxAll = zeros(height(tbl),1);
    for j = 1:length(filterIn.(fieldsToFilter{nField}))
        val = filterIn.(fieldsToFilter{nField})(j);
%         error('r')
        indx = tbl.(fieldsToFilter{nField}) == val;
        indxAll = indx + indxAll;
    end
    tbl = tbl(find(indxAll),:);
end

%calculating values per group
hold on
cats = unique(tbl.(groupingVar));
for nCat = 1:length(cats)
    indx = find(tbl.(groupingVar) == cats(nCat));
    vals(nCat) = mean(tbl.(varToGraph)(indx));
    errors(nCat) = stdError(tbl.(varToGraph)(indx));
    hBar = bar(nCat,vals(nCat));
    hBar.FaceColor = colors{nCat};
    hBar.EdgeColor = colors{nCat};
    catString{nCat} = char(cats(nCat));
end
hErrorBar = errorbar(1:length(cats),vals,errors,'k');
hErrorBar.LineStyle = 'none';
hErrorBar.MarkerFaceColor = 'k';


catsString = char(cats);
set(gca,'Xtick',[1:length(cats)])
set(gca,'XtickLabel',catString,'FontName','Arial','fontsize',fontSize)
rotateXLabels(gca,45)
line([0,length(cats)+1],[pBinomial(2,4*7,0.01),pBinomial(2,4*7,0.01)])
hold off
