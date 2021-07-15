function rhoList = correlationSearchlightDistribution(folder,distributionFile,corrVals,varargin)
warning('Make sure that corrVals mantains the same order as fileList');

fileList = getArgumentValue('fileList',[],varargin{:});
correlationType = getArgumentValue('type','Spearman',varargin{:});
cortex = getArgumentValue('cortex',false,varargin{:}); %run only cortex?
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:}); %which cortex to use?
reps = getArgumentValue('reps',1000,varargin{:}); %how many permutations?
overwrite = getArgumentValue('overwrite',false,varargin{:});

if exist([distributionFile,'.mat'],'file')
    if ~overwrite
        load(distributionFile); %#ok<LOAD>
        rhoList = dataMatrix; %#ok<NODEF>
        disp('distribution file found, skipping');
        return
    else
        disp('distribution file found, overwritting');
    end
end

[imgs,oldPath,~,dataF] = getFileList(folder,'fileList',fileList,...
    'cortex',cortex,'cortexFile',cxFile);
mask = dataF.img;
mask(:) = 0;
dimensions = size(imgs{1});
totalVox = dimensions(1)*dimensions(2)*dimensions(3); %#ok<NASGU>
for i = 1:dimensions(1)
    for j = 1:dimensions(2)
        for k = 1:dimensions(3)
            val = zeros(1,length(imgs));
            for subj = 1:length(imgs)%subjs
                val(subj) = imgs{subj}(i,j,k);
            end
            mask(i,j,k) = sum(val ~= 0) ~= 0;
        end
    end
end
indx = find(mask);
rhoList = zeros(reps,length(indx));
for nVox = 1:length(indx)
    disp(['running vox: ',num2str(nVox), ' out of ', num2str(length(indx))]);
    vox = indx(nVox);
    val = zeros(1,length(imgs));
    for subj = 1:length(imgs)%subjs
        val(subj) = imgs{subj}(vox);
    end
    for nRep = 1:reps
        corrVals = shake(corrVals);
        rho = corr(val(:),corrVals(:),  'Type', correlationType);
        rhoList(nRep,nVox) = rho;
    end
end

cd(oldPath);

dataMatrix = rhoList(:); %#ok<NASGU>
dataMatrix(isnan(dataMatrix)) = []; %#ok<NASGU>
save(distributionFile,'dataMatrix');
