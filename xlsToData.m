function data = xlsToData(xlsFile)
[~,~,raw] = xlsread(xlsFile);

labelNames = cell(1,size(raw,2));
for nLabel = 1:size(raw,2)
    labelNames{nLabel} = (raw{1,nLabel});
end

maskN = find(strcmp(labelNames,'MaskB'));
alphaANOVAN = find(strcmp(labelNames,'AlphaANOVA'));
subjectN = find(strcmp(labelNames,'Subject'));
modelN = find(strcmp(labelNames,'Model'));
meanPerfN = find(strcmp(labelNames,'MeanPerf'));
confMN = find(strcmp(labelNames,'ConfM'));
labelsN = find(strcmp(labelNames,'ConfLabels'));
hemoCorN = find(strcmp(labelNames,'HemoCor'));
removedCatsN = find(strcmp(labelNames,'RemovedCats'));



for nRow = 1:size(raw,1)-1
    maskNames{nRow} = raw{nRow+1,maskN};
    alphaANOVA(nRow) = raw{nRow+1,alphaANOVAN};
    subject(nRow) = raw{nRow+1,subjectN};
    model(nRow) = raw{nRow+1,modelN};
    meanPerf(nRow) = raw{nRow+1,meanPerfN};
    HemoCor(nRow) = raw{nRow+1,hemoCorN};
    removedCats{nRow} = raw{nRow+1,removedCatsN};
    if ~isempty(confMN)
        confVals{nRow} = str2num(raw{nRow+1,confMN});
        labels{nRow} = raw{nRow+1,labelsN};
    end
    
end

data = [];
charsToRemove = {'[',']','"','''',','};
for j = 1:length(maskNames)
    data(j).masks = maskNames{j};
    data(j).alphaANOVA = alphaANOVA(j);
    data(j).subject = subject(j);
    data(j).model = model(j);
    data(j).meanPerf = meanPerf(j);
    data(j).hemoCor = HemoCor(j);    
    str = removedCats{j};
    for jj = 1:length(charsToRemove)
        str = strrep(str,charsToRemove{jj},'');
    end    
    data(j).removedCats = str2num(str);
    if ~isempty(confMN)
        data(j).confVals = confVals{j};
        str = labels{j};
        for jj = 1:length(charsToRemove)
            str = strrep(str,charsToRemove{jj},'');
        end    
        data(j).labels = strsplit(str);
    end
    
end





%% For making the function all  mighty

