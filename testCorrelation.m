function testCorrelation(testFile,resFile,categories,goalMatrix,varargin) %#ok<INUSL>
%testFile can either be the map or the filename to load the RSA searchlight files 
%The function compares the map against a goalMatrix
%resFile = name of the results file, testFile = prefix of files to test or map

% pThr = getArgumentValue('pThr',0.05,varargin{:});
thrImg = getArgumentValue('thrImg',true,varargin{:}); %output thr images
corImg = getArgumentValue('corImg',true,varargin{:}); %output corr images
pImg = getArgumentValue('pImg',true,varargin{:}); %output p img
corrType = getArgumentValue('corrType','Spearman',varargin{:}); %correlation to use
binImg = getArgumentValue('binImg',false,varargin{:}); %binarize?
rnd = getArgumentValue('rnd',false,varargin{:}); %randomize data before calculating?
cortex = getArgumentValue('cortex',false,varargin{:}); %run only cortex?
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
baseFile = getArgumentValue('baseFile','Barney2mm',varargin{:});

if cortex %FINISH, IT USES THE CORTEX THING, but at the very end, so inneficient
    cortexFile = getCortexFile(cxFile);
    cortexImg = load_untouch_niiR(cortexFile);
    cortexImg.img = single(logical(cortexImg.img));
%     disp('Using cortex')
end

if ischar(testFile)
    map = combineFilesVector(testFile,categories);
    %loads one of the files to use it as template
    data = load_untouch_niiR([testFile,'_000_001.nii.gz']);
else
    map = testFile;
    %loads a cortex file to use as base
    [~,data] = getCortex(baseFile);
end

%initializes the variables to store the correlation and it's p
mapC = zeros(size(map,1),1);
mapP = zeros(size(map,1),1);
lenMap=size(map,1);
goalVector = goalMatrix';
if rnd
    goalVector = shake(goalVector);
end

for k = 1:lenMap %performs the correlation and gets the results in mapC and mapP
    if sum(map(k,:)) ~= 0
        [mapC(k),mapP(k)] = corr(map(k,:)',goalVector,'type',corrType);
    else
        mapC(k) = 0;
        mapP(k) = 1;
    end
end

if cortex
    mapC(:) = mapC(:).*cortexImg.img(:);
end

%Saves the images requested
disp(['Saving ',resFile]);
if corImg
%     size(data.img(:))
%     size(mapC(:))
    data.img(:) = mapC(:);
    save_untouch_nii(data,[resFile,'_c.nii.gz']);
end
if thrImg
%     mapCThr = mapC;
%     mapCThr(mapP > pThr) = 0; 
%     data.img(:) = mapCThr(:);
%     save_untouch_nii(data,[resFile,'_Thr',num2str(pThr),'.nii.gz']);
    
    mapCThr(mapP(:) > 0.01) = 0;
    data.img(:) = mapCThr(:);
    if sum(data.img(:)) > 0
        save_untouch_nii(data,[resFile,'_Thr01.nii.gz']);
    end
    mapCThr(mapP(:) > 0.001) = 0;
    data.img(:) = mapCThr(:);
    if sum(data.img(:)) > 0
        save_untouch_nii(data,[resFile,'_Thr001.nii.gz']);
    end
    mapCThr(mapP(:) > 0.0001) = 0;
    data.img(:) = mapCThr(:);
    if sum(data.img(:)) > 0
        save_untouch_nii(data,[resFile,'_Thr0001.nii.gz']);
    end
    mapCThr(mapP(:) > 0.00001) = 0;
    data.img(:) = mapCThr(:);
    if sum(data.img(:)) > 0
        save_untouch_nii(data,[resFile,'_Thr00001.nii.gz']);
    end
    
    
end
if pImg %p image
    data.img(:) = mapP(:);
    save_untouch_nii(data,[resFile,'_p.nii.gz']);
end
if binImg %binary image
    mapBin = mapC;
    mapFilt = mapP < pThr;
    mapBin = mapFilt .* sign(mapBin);
    data.img = mapBin;
    save_untouch_nii(data,[resFile,'_bin.nii.gz']);
end

disp('...Done')



