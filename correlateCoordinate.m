%function correlateCoordinate(baseFile,coords,fileName)
function goalMatrix = correlateCoordinate(baseFile,testedFile,resFile,coords,categories,pThr,varargin)
rnd = getArgumentValue('rnd',false,varargin{:});
%baseFile name of file from which get RSA
%coords, coords of the DSM


%baseFileData = load_untouch_niiR(baseFile);
baseFileData = load_untouch_niiR([baseFile,'_',sprintf('%03d',0),'_',sprintf('%03d',1),'.nii.gz']); %loads an image to be used as mold
for j = 1:length(baseFileData.img(:))
    baseFileData.img(j) = j;
end
indx = baseFileData.img(coords(1),coords(2),coords(3));
map = combineFilesVector(baseFile,categories);
goalMatrix = map(indx,:);

disp('Goal matrix loaded')
disp('Doing correlation')
thrImg = false;
corImg = true;
pImg = true;
binImg = false;
corrType = 'Spearman';
testCorrelation(testedFile,resFile,categories,goalMatrix,'pThr',pThr,'thrImg',thrImg,'corImg',corImg,'corrType',corrType,'binImg',binImg,'pImg',pImg,'rnd',rnd);