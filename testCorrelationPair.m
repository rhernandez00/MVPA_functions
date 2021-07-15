function [rho,pVal] = testCorrelationPair(participant1,participant2,varargin)
corrType = getArgumentValue('corrType','Spearman',varargin{:});
r = getArgumentValue('r',3,varargin{:});
%participant1 and 2 are structures with the following:
%.specie
%.coords
%.model
%.number
categories = 24;
categoriesModel = 24;
savedFilePath = ['D:\Raul\results\Faces\RSAprep'];

specie1 = participant1.specie;
specie2 = participant2.specie;
model1 = participant1.model;
model2 = participant2.model;
coords1 = participant1.coords;
coords2 = participant2.coords;
part1 = participant1.number;
part2 = participant2.number;







RSAFolder1 = ['D:\Raul\results\Faces\RSA',specie1,'STD',num2str(categoriesModel)];
fileName1 = [RSAFolder1,'\task1model',num2str(model1),'r',num2str(r),'sub',sprintf('%03d',part1)];
template1 = [fileName1,'_000_001.nii.gz'];
nifti1 = load_untouch_niiR(template1);


testedFilePrefix = ['task1model',num2str(model1),'r',num2str(r),'sub'];
testedFile = [savedFilePath,'\',specie1,'\',testedFilePrefix,sprintf('%03d',part1)]; 
load(testedFile);
dims = size(

map;



goalVector1 = getGoalVector(fileName1,coords1,categories);
RSAFolder2 = ['D:\Raul\results\Faces\RSA',specie2,'STD',num2str(categoriesModel)];
fileName2 = [RSAFolder2,'\task1model',num2str(model2),'r',num2str(r),'sub',sprintf('%03d',part2)];
goalVector2 = getGoalVector(fileName2,coords2,categories);





[rho,pVal] = corr(goalVector1,goalVector2,'type',corrType);



