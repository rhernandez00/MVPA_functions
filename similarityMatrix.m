function [distanceMatrixO,stimType,runType,goalVector,pairs] = similarityMatrix(baseFile,coords,nRuns,nTypes,varargin)
atlasFile = getArgumentValue('ref','Barney2mm',varargin{:});

coordsVox = coordinatesToVoxel(coords,'ref',atlasFile);
categories = nRuns*nTypes;
goalVector = getGoalVector(baseFile,coordsVox,categories);

%

pairs = combinator(categories,2,'c')-1;
distanceMatrix = zeros(categories);

minVal = getArgumentValue('minVal',0,varargin{:});
maxVal = getArgumentValue('maxVal',max(goalVector),varargin{:});

for j = 1:length(goalVector)
    column = pairs(j,1)+1;
    row = pairs(j,2)+1;
    distanceMatrix(row,column) = goalVector(j);
    distanceMatrix(column,row) = goalVector(j);
end
% subplot(1,2,1)
% h = imagesc(distanceMatrix,[minVal,maxVal]);
% colormap(hot)
% % cmap = colormap;
% %




%  -----------sorting by type -------------
%DO 1, DF 2, HO 3, HF 4
stimType = [];
runType = [];
for run = 1:nRuns
    stimType = [stimType,1:nTypes];
    runType = [runType,ones(1,nTypes).*run];
end
[stimTypeO,I] = sort(stimType);
runTypeO = runType(I);
% vectorO = goalVector(I);

for row = 1:categories
    for column = 1:categories
         distanceMatrixO(row,column) = distanceMatrix(I(row),I(column));
    end
end

h = imagesc(distanceMatrixO,[minVal,maxVal]);

colormap(hot)
ax = gca;
ax.YTick = [];
ax.XTick = [];
ax.Visible = 'off';

%Creating table
dataTable = table;
dataTable.vals(:) = goalVector(:);
dataTable.comp1(:) = (pairs(:,1)+1)';
dataTable.comp2(:) = (pairs(:,2)+1)';
dataTable.stimType1(:) = stimType(dataTable.comp1(:));
dataTable.stimType2(:) = stimType(dataTable.comp2(:));
dataTable.runType1(:) = runType(dataTable.comp1(:));
dataTable.runType2(:) = runType(dataTable.comp2(:));
