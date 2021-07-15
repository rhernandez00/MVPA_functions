%function correlateCoordinate(baseFile,coords,fileName)
function goalMatrix = correlateVector(baseFile,testedFile,resFile,coords,categories,pThr,varargin)
rnd = getArgumentValue('rnd',false,varargin{:});
corrType = getArgumentValue('corrType','Spearman',varargin{:});
%baseFile name of file from which get RSA
%coords, coords of the DSM


%baseFileData = load_untouch_niiR(baseFile);




thrImg = false;
corImg = false;
pImg = false;
binImg = true;

testCorrelation(testedFile,resFile,categories,goalMatrix,'pThr',pThr,'thrImg',thrImg,'corImg',corImg,'corrType',corrType,'binImg',binImg,'pImg',pImg,'rnd',rnd);