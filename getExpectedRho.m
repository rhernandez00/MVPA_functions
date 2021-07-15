function [expectedRho,expectedStd]= getExpectedRho(vector1,vector2,varargin)
nReps = getArgumentValue('nReps',10000,varargin{:});
corrType = getArgumentValue('corrType','Spearman',varargin{:});
getDriveFolder;

load([driveFolder,'\Faces_Hu\figures\RSA\expectedRhoBase.mat']); %#ok<LOAD>
vectorLen = length(vector1);
indx = find(nElements == vectorLen); %#ok<NODEF>
if isempty(indx)
    disp('Checking rho distribution');
    rhoList = zeros(nReps,1);
    for n = 1:nReps
        vectorRnd = randswap(vector2);
        rho = corr(vector1(:),vectorRnd(:),'type',corrType);
        rhoList(n) = rho;
    end

    expectedRho = mean(rhoList);
    expectedStd = std(rhoList);
    nElements = [nElements,vectorLen]; %#ok<NASGU>
    expectedList = [expectedList,expectedRho]; %#ok<NODEF,NASGU>
    expectedStdList = [expectedStdList,expectedStd];
    save([driveFolder,'\Faces_Hu\figures\RSA\expectedRhoBase.mat'],'expectedList','nElements','expectedStdList'); %#ok<LOAD>
else
    expectedRho = expectedList(indx); %#ok<NODEF>
    expectedStd = expectedStdList(indx); %#ok<NODEF>
end