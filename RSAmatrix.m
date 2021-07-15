% function RSAmatrix(baseFile,coords,categories)
%%
clear all
load('C:\Users\Hallgato\Google Drive\Faces_Hu\figures\RSA\testingRSA.mat');
baseFilePath = 'C:\Users\Hallgato\Google Drive\Faces_Hu\RSAHumSTD';
rad = 3;
nHuman = 1;

baseFile = [baseFilePath,'\','task1model1r',num2str(rad),'sub',sprintf('%03d',nHuman)];
coords = [26,41,27]; %FFG      
categories = 24;
pairs = combinator(categories,2,'c');
pairs2 = flip(pairs,2);

%goalVector = getGoalVector(baseFile,coords,categories);

%%

resMatrix = zeros(categories);

for indx = 1:length(goalVector)
    row = pairs(indx,1);
    col = pairs(indx,2);
    row2 = pairs2(indx,1);
    col2 = pairs2(indx,2);
    resMatrix(row,col) = goalVector(indx);
    resMatrix(row2,col2) = goalVector(indx);
end

