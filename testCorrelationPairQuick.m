function [rho,pVal,goalVector1,goalVector2] = testCorrelationPairQuick(participant1,participant2,varargin)
corrType = getArgumentValue('corrType','Spearman',varargin{:});
r = getArgumentValue('r',3,varargin{:});
%participant1 and 2 are structures with the following:
%.specie
%.coords
%.model
%.number

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
dims = size(map);
vector1 = 1:dims(1);
nifti1.img(:) = vector1(:);

flatCoord = nifti1.img(coords1(1),coords1(2),coords1(3));
goalVector1 = map(flatCoord,:);
% map;


RSAFolder2 = ['D:\Raul\results\Faces\RSA',specie2,'STD',num2str(categoriesModel)];
fileName2 = [RSAFolder2,'\task1model',num2str(model2),'r',num2str(r),'sub',sprintf('%03d',part2)];
template2 = [fileName2,'_000_001.nii.gz'];
nifti2 = load_untouch_niiR(template2);

testedFilePrefix = ['task1model',num2str(model2),'r',num2str(r),'sub'];
testedFile = [savedFilePath,'\',specie2,'\',testedFilePrefix,sprintf('%03d',part2)]; 
load(testedFile);
dims = size(map);
vector2 = 1:dims(1);
nifti2.img(:) = vector2(:);

flatCoord = nifti2.img(coords2(1),coords2(2),coords2(3));
goalVector2 = map(flatCoord,:);

% goalVector2 = getGoalVector(fileName2,coords2,categories);





[rho,pVal] = corr(goalVector1',goalVector2','type',corrType);



