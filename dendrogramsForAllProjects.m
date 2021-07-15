%% 10cat
clear
addpath('C:\Users\Raul\Dropbox\MVPA\funciones')
%clc
close all
csvName = 'RSA10catMask';
repetitions = 0;%1000;
trimpercent = 0;%25;
masks = {'LOC2','PL','M1','V1'};
outputPath = 'C:\Users\Raul\Dropbox\MVPA\10cat\RSA\';
maskTypes = {'b'};
labels = {'Bottles','Spoons', 'Strings', 'Figures', 'Pens', 'Books', 'Sandpapers', 'Balls', 'Stuffed toys', 'Drinking glasses'};
DMs = makeDendrogram(csvName,masks,maskTypes,labels,outputPath,trimpercent,repetitions);
%DMs = makeDendrogram(csvName,masks,maskTypes,labels,outputPath);
combMat = combnk(1:length(masks),2);
%pValMat = zeros(length(masks),length(maskTypes));
pValMat = [];
for j = 1:size(combMat,1)
    mask1 = combMat(j,1);
    mask2 = combMat(j,2);
    [rho(j),pValMat(j)] = corr(DMs{mask1,1}(:),DMs{mask2,1}(:),'type','Spearman');
    [corrMat{j},pMat{j}] = corrcoef(DMs{mask1,1},DMs{mask2,1});
end
rho
pValMat
return
%% Orientation
addpath('C:\Users\Raul\Dropbox\MVPA\funciones')
clc
close all
csvName = 'orientationMask';
repetitions = 1000;
trimpercent = 25;
masks = {'BA1','BA2','BA3a','BA3b','SII','SmG','SPL_5','SPL_7','AIPS','BA44','BA45','AG','BA4','BA6'};
outputPath = 'C:\Users\Raul\Dropbox\MVPA\rotacionGeneral\resultados\RSA\';
maskTypes = {'b'};
labels = {'-30','-60', '30', '60'};
makeDendrogram(csvName,masks,maskTypes,labels,outputPath,trimpercent,repetitions);