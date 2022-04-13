function [h,matOrdered,labels,RSAmat,alphaMap,rgb_image] = drawRSA(valsVector,propTablePairs,propTable,varargin)
% nOrder = getArgumentValue('nOrder',1,varargin{:});
% propTablePairs = getArgumentValue('propTablePairs',
% experiment = getArgumentValue('experiment','Prosody',varargin{:});
sortByVars = getArgumentValue('sortByVars',[],varargin{:}); %list of variables to use to sort the data
pairName = getArgumentValue('pairName','stim',varargin{:}); %the number of the stim, it is the identifier from propTable
perc = getArgumentValue('perc',false,varargin{:});
labelVar = getArgumentValue('labelVar','stim',varargin{:});
clims = getArgumentValue('clims',[],varargin{:});
halfMat = getArgumentValue('halfMat',false,varargin{:});
fileName = getArgumentValue('fileName','RSAMat',varargin{:});
saveFile = getArgumentValue('saveFile',false,varargin{:});
% indxName = getArgumentValue('indxName','indx',varargin{:});

if perc
    valsVector2 = zeros(1,length(valsVector));
    for nVal = 1:length(valsVector)
        value = valsVector(nVal);
        x = comp_percentile(valsVector,value);
        valsVector2(nVal) = x;
    end
    valsVector = valsVector2;
end
% h = 0;
% matOrdered = 0;
% return



%Makes propTable a table (tblA) so it can be sorted
if istable(propTable)
    tblA = propTable;
else
    tblA =table();
    columnNames = fieldnames(propTable);
    for nCol = 1:length(columnNames)
        fieldName = columnNames{nCol};
        if isstr(propTable(1).(fieldName)) %#ok<DISSTR>
            newElements = {propTable.(fieldName)}';
        else
            newElements = [propTable.(fieldName)]';
        end
        
        try
            tblA.(fieldName) = newElements;
        catch
            size(newElements)
            tblA.(fieldName) %#ok<NOPRT>
            newElements %#ok<NOPRT>
            error('r')
        end
    end
end

%adds indx to tblA
if sum(strcmp('indx',columnNames)) < 1
    tblA.indx = [1:size(tblA,1)]'; %#ok<NBRAK>
end

%sorts tblA according to the variable choosen to sort
for nVar = 1:length(sortByVars)
    varForSort = sortByVars{nVar};
    tblA = sortrows(tblA,varForSort);
end

%

RSAmat = RSAVectorToMat(valsVector,propTablePairs,'pairName',pairName); %transforms vector to matrix
%indx matches with variables pair1 and pair2 of propTablePairs
tblA.newOrder = [1:size(tblA,1)]'; %#ok<NBRAK>
newOrder = tblA.newOrder;

% [matOrdered,labels] = orderMat(newOrder,tblA,RSAmat);

%Ordering the new matrix
[~,I] = sort(newOrder);
indx = tblA.indx;
indxOder = indx(I);
% labels = tblA.stim;
% labels = labels(I);
matOrdered = zeros(size(tblA,1),size(tblA,1));
% matOrdered = ones(size(tblA,1),size(tblA,1)).*2;
% size(tblA)

for nRow = 1:size(tblA,1)
    for nCol = 1:size(tblA,1)
        newCol = indxOder(nCol);
        newRow = indxOder(nRow);
%         disp(['col: ',num2str(newCol), ' row: ',num2str(newRow)]);
        matOrdered(nRow,nCol) = RSAmat(newCol,newRow);
    end
end
labels = tblA.(labelVar)(I);

% matOrdered(matOrdered == 0) = 2;

% h=0;
% return
% h = imagesc(RSAmat);
if isempty(clims)
%     disp('Clims empty')
    if perc
        minVal = 0;
        maxVal = 100;
    else
        minVal = min(matOrdered(:));
        maxVal = max(matOrdered(:));
    end
else
    minVal = clims(1);
    maxVal = clims(2);
end

% h = imagesc(matOrdered,[minVal,maxVal]);
h = imagesc(matOrdered);
disp('setting axes')
set(gca,'xtick',1:size(propTablePairs,2));
set(gca,'ytick',1:size(propTablePairs,2));
% set(gca,'xticklabel',labels);
set(gca,'yticklabel',labels);
% set(gca,'XColor','w','YColor','w','box','off')
set(gca,'XColor','none','YColor','none','box','off');
axis equal

alphaMap = ones(size(matOrdered));

if halfMat
    tam = size(matOrdered);
    for n = 1:tam(1)
        for m = 1:tam(2)
            if m >= n
                alphaMap(n,m) = 0;
            end
        end
    end
end

% colormap(parula(8))
map = colormap;
% minVal
% maxVal
minv = minVal;%min(vals2(:));
maxv = maxVal;%max(vals2(:));
ncol = size(map,1);
s = round(1+(ncol-1)*(matOrdered-minv)/(maxv-minv));
rgb_image = ind2rgb(s,map);

if saveFile
    imwrite(rgb_image,[fileName,'.png'],'png','Alpha',alphaMap);
end


