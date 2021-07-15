function testCorrelationQuick(map,templateFile,resFile,goalMatrix,varargin) 
%compares the DSM in map (rows represent voxels, columns represent 1vs1 categories) and compares them against a goalMatrix (goalVector)
%templateFile is a nifti file with the dimensions of the map, to be used as template for the output
%resFile is the name of the output file

pThr = getArgumentValue('pThr',0.01,varargin{:}); %threshold for p image to use (0.01,0.001,..)
thrImg = getArgumentValue('thrImg',true,varargin{:}); %create threshold img?
corImg = getArgumentValue('corImg',true,varargin{:}); %create correlation img?
pImg = getArgumentValue('pImg',true,varargin{:}); %create p img?
corrType = getArgumentValue('corrType','Spearman',varargin{:}); %type of correlation to use
binImg = getArgumentValue('binImg',true,varargin{:}); %create binary img?
rnd = getArgumentValue('rnd',false,varargin{:}); %in case the order of the goal matrix have to be randomized to get permutations
templateFromRSA = getArgumentValue('templateFromRSA',true,varargin{:}); %if the file loaded as template belongs to the RSA files or not


mapC = zeros(size(map,1),1);
mapP = zeros(size(map,1),1);
lenMap=size(map,1);
goalVector = goalMatrix';
if rnd
    goalVector = shake(goalVector);
end
disp(pThr);
% error('e')
for k = 1:lenMap

    if sum(map(k,:)) ~= 0
%         clc
%         disp(['Testing ',num2str(k),' / ', num2str(lenMap)]);
        [mapC(k),mapP(k)] = corr(map(k,:)',goalVector,'type',corrType);
    else
        mapC(k) = 0;
        mapP(k) = 1;
    end
end

%loads one of the files to use it as template
if templateFromRSA
    data = load_untouch_niiR([templateFile,'_000_001.nii.gz']);
else
    loadedFile = [templateFile,'.nii.gz'];
    disp(loadedFile)
    data = load_untouch_niiR(loadedFile);
end
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



