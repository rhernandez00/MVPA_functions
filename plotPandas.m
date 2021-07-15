analisis = 'FacesByRes20_50';
filename = ['C:\Users\Raul\Dropbox\IPython Notebooks\PyMVPA\dogs', analisis, '.csv']; 

[n,s,r] = xlsread(filename);
des_cols = {'Mask', 'Classifier', 'Perf'};
colhdrs = s(1,:);
[~,ia] = intersect(colhdrs, des_cols);
colnrs = flipud(ia);
Data = n(:, colnrs-1);
%%
Data = readtable(filename);


%%

clear all
clf
saveFig = 0;
lineWidth = 2; %width of the plot line
alphaForGraph=0.05 ;%binomial test to be significative in the graph
alphaF = 1; %to select the data
categories = 2;
nRuns=10;
nDogs=4;
fontSize = 10;
markerSize = 5;

maskType = 'b';

analisis = 'FacesByRes20_50';


v = version;
if v(1) == '8'
   filename = ['C:\Users\Raul\Dropbox\IPython Notebooks\PyMVPA\dogs', analisis, '.csv']; 
else
    filename = ['C:\Users\Seven\Dropbox\IPython Notebooks\PyMVPA\dogs', analisis, '.csv'];
end



data=loadMVPACsv(filename);
data = data([data.alphaANOVA] == alphaF);
maskToGraph = 'Caras';


vals = {data.masks};


filtro = [];
for j = 1:size(vals,2)
    maskName = vals{j};
    filtro(j) = maskName(1) == maskType;
end

data = data([filtro] == 1);


for i = 1:length(data)
    
    data(i).removedCats = strrep(data(i).removedCats,'[','');
    data(i).removedCats = strrep(data(i).removedCats,']','');
    data(i).removedCats = strrep(data(i).removedCats,',','');
    data(i).removedCats = strrep(data(i).removedCats,']','');
    data(i).removedCats = strrep(data(i).removedCats,'(','');
    data(i).removedCats = strrep(data(i).removedCats,')','');

    data(i).masks = strrep(data(i).masks,'_','');

    switch data(i).removedCats{1}
        case '0 2'
            data(i).categoriesTested = {'Happiness vs Fear'};
        case '0 3'
            data(i).categoriesTested = {'Happiness vs Anger'};
        case '2 3'
            data(i).categoriesTested = {'Happiness vs Sadness'};
        case '0 1'
            data(i).categoriesTested = {'Anger vs Fear'};
        case '1 2'
            data(i).categoriesTested = {'Sadness vs Fear'};
        case '1 3'
            data(i).categoriesTested = {'Sadness vs Anger'};
        case '1'
            data(i).categoriesTested = {'Negative'};
        case ''
            data(i).categoriesTested = {'All'};
        otherwise
            data(i).removedCats
            error(data(i).removedCats);
    end
end

removedCatsL = unique([data.categoriesTested]);


masks = {data.masks};
masks = unique(masks);
categoriesTested = unique([data.categoriesTested]);
%
newOrder = [4,1,2,3,5,6];
%going trough every pair

clf
total = nRuns * nDogs * categories;
nMin = pBinomialN(total,categories,alphaForGraph);
corrects = [];
corrects2 = [];
for i = 1:length(removedCatsL)
    indxcategoriesTested = strcmp([data.categoriesTested],categoriesTested(i));
    dataMatrix(:,newOrder(i)) = [data(indxcategoriesTested).meanPerf];  
    corrects(newOrder(i)) = mean([data(indxcategoriesTested).meanPerf]);
    corrects2(newOrder(i)) = corrects(newOrder(i))*total;
    pBin(newOrder(i)) = corrects2(newOrder(i)) >= nMin;
    legendNames{newOrder(i)} = categoriesTested{i}; 
end
barWithErrorColors(dataMatrix,legendNames,45);

hold on
ax = axis();
axis([ax(1),ax(2),ax(3),0.8]);
plot(find(pBin),ones(1,length(find(pBin)))*0.75, 'k*', 'MarkerSize', markerSize);
%line([0,ax(2)],[1/categories,1/categories], 'LineStyle', '--', 'Color', [0,0,0], 'LineWidth', lineWidth) ;
xlabel('Emotion pair','FontName','Arial','fontsize',fontSize);
ylabel('Classifier performance','FontName','Arial','fontsize',fontSize);
hold off

v  =version;
if saveFig == 1
    if v(1) == '8'
        saveas(gcf,['C:\Users\Raul\Dropbox\Perros\Figuras\Emociones\nuevo\',analisis,maskType,'.png']);
    else
        saveas(gcf,'C:\Users\Seven\Dropbox\Perros\Figuras\Emociones\allVsAllSonrisasB.png');
    end
end
