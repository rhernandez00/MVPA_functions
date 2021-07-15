function testCorrelationLong(testFile,resFile,categories,goalMatrix,varargin) %#ok<INUSL>
%loads RSA searchlight files and compares them against a goalMatrix
%fileName - name of file to test the matrix with
pThr = getArgumentValue('pThr',0.05,varargin{:});
thrImg = getArgumentValue('thrImg',true,varargin{:});
corImg = getArgumentValue('corImg',true,varargin{:});
pImg = getArgumentValue('pImg',true,varargin{:});
corrType = getArgumentValue('corrType','Spearman',varargin{:});
binImg = getArgumentValue('binImg',true,varargin{:});
rnd = getArgumentValue('rnd',false,varargin{:});

map = combineFilesVector(testFile,categories);
mapC = zeros(size(map,1),1);
mapP = zeros(size(map,1),1);
lenMap=size(map,1);
lenVector = size(map,2);
goalVector = goalMatrix';
if rnd
    goalVector = shake(goalVector);
end
disp(pThr);
% error('e')
reps = length(goalMatrix)/lenVector;
if ~isint(reps)
    disp(length(goalMatrix))
    disp(lenVector)
    error('Dimensions inconsistent');
end


for k = 1:lenMap
    testedVector = map(k,:);
    testedVectorComplete = [];
    for j = 1:reps
        testedVectorComplete = [testedVectorComplete,testedVector]; %#ok<AGROW>
    end
    if sum(map(k,:)) ~= 0
        clc
        disp(['Testing ',num2str(k),' / ', num2str(lenMap)]);
        [mapC(k),mapP(k)] = corr(testedVectorComplete',goalVector,'type',corrType);
    else
        mapC(k) = 0;
        mapP(k) = 1;
    end
end

%loads one of the files to use it as template
data = load_untouch_niiR([testFile,'_000_001.nii.gz']);
%Saves the images requested
disp('Saving...')
if corImg
    data.img(:) = mapC(:);
    save_untouch_nii(data,[resFile,'_c.nii.gz']);
end
if thrImg
    mapCThr = mapC;
    mapCThr(mapP > pThr) = 0; 
    data.img(:) = mapCThr(:);
    save_untouch_nii(data,[resFile,'_Thr',num2str(pThr),'.nii.gz']);
end
if pImg
    data.img(:) = mapP(:);
    save_untouch_nii(data,[resFile,'_p.nii.gz']);
end
if binImg
    mapBin = mapC;
    mapFilt = mapP < pThr;
    mapBin = mapFilt .* sign(mapBin);

%     mapBin(:) = mapC(:).*mapBin(:);
%     for k = 1:length(mapBin(:))
%         mapBin(k) = mapBin(k) * sign(mapC(k));
%     end
    data.img = mapBin;
    save_untouch_nii(data,[resFile,'_bin.nii.gz']);
end

disp('...Done')



