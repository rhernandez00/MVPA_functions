function [dataP,distribution,mu,sigma] = compareToDistribution(fileToCompare,varargin)
%takes a mean performance file and compares it against a file of a
%distribution (.mat), which is a matrix with nRep as row, and nVox as
%columns
side = getArgumentValue('side','moreThan',varargin{:});
suffix = getArgumentValue('suffix','_mp',varargin{:});
meanDistributionFile = getArgumentValue('meanDistributionFile',[],varargin{:});
ZImg = getArgumentValue('ZImg',false,varargin{:});
mpFiltered = getArgumentValue('mpFiltered',false,varargin{:});
ZFiltered = getArgumentValue('ZFiltered',true,varargin{:});
fImg = getArgumentValue('filtered',[],varargin{:});
absVals = getArgumentValue('absVals',false,varargin{:});

if ~isempty(fImg)
    error('deprecated, use mpFiltered or ZFiltered');
end
%false, compares each voxel with voxels in the same location, true -
%compares with all the voxels in the map
compareWithAll = getArgumentValue('compareWithAll', false, varargin{:}); 
%to filter with cortex
cortex = getArgumentValue('cortex',false,varargin{:});
getDriveFolder;
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:});

if cortex
    ctx = getCortex(cxFile);
end

if isempty(meanDistributionFile)
    dataMatrix = getArgumentValue('distributionMatrix',[],varargin{:});
    if isempty(dataMatrix)
        error('must introduce something!');
    end
else
    % atlas = 'C:\Users\Hallgato\Google Drive\Faces_Hu\CommonFiles\BarneyBrain2mm.nii.gz';
    disp('Loading mean distribution...');
    load(meanDistributionFile); %#ok<LOAD>
end



fileM=[fileToCompare,suffix,'.nii.gz'];
disp(['Loading ', fileM]);

dataMean = load_untouch_niiR(fileM);
dataMean.img(isnan(dataMean.img(:))) = 0;
for nVox = 1:length(dataMean.img(:))
    val =  dataMean.img(nVox);
    
    if isnan(val)
        disp(['the value is: ',num2str(val)])
        disp(['the indx is: ',num2str(nVox)])
%         disp(nVox)
        error('nan found')
    end 
end

ZImgOut = dataMean;
if cortex %filters out whatever falls outside the mask
    dataMean.img(:) = ctx(:).*dataMean.img(:);
    disp('Cortex');
end

if isobject(dataMatrix)
    distribution = dataMatrix;
    if absVals
        dataMean.img(:) = abs(dataMean.img(:));
        switch distribution.DistributionName
            case 'Normal'
                val = abs(random(distribution,[10000,1]));
                distribution = fitdist(val,'HalfNormal');
            case 'Half Normal'
                disp('Using half-normal distribution');
            otherwise
                error('Make correction for distribution that only accounts for abs');
        end
    end
    mu = distribution.mu;
    sigma = distribution.sigma;
else
    if absVals
        distribution = abs(dataMatrix);
        dataMean.img(:) = abs(dataMean.img(:));
    else
        distribution = dataMatrix;
    end
    if compareWithAll
        distribution = dataMatrix(:);
    end
    mu = nanmean(distribution(:));
    sigma = nanstd(distribution(:));
end

dataP = dataMean;
img = dataMean.img(:);
nVoxs = length(dataMean.img(:));%size(dataMatrix,2); %#ok<NODEF>


for nVox = 1:nVoxs
    val = img(nVox);
    if val == 0
        p = 1;
        dataP.img(nVox) = p;
        continue
    end
    if ~compareWithAll
        distribution = dataMatrix(:,nVox); %#ok<*IDISVAR>
    end
    disp(['Comparing ', num2str(nVox), ' / ', num2str(nVoxs)]);
    p = pFromDist(distribution,val,side);
    dataP.img(nVox) = p;
end


disp(['Saving ', fileToCompare])
% save_untouch_nii(dataP,[fileToCompare,'pFromPerms.nii.gz']);
save_untouch_nii(dataP,[fileToCompare,'_p.nii.gz']);


if ZImg
    ZImgOut.img(:) = (ZImgOut.img(:) - mu)/sigma;
    save_untouch_nii(ZImgOut,[fileToCompare,'_Z.nii.gz']);
    disp(['the file tested is: ', fileToCompare,'_Z.nii.gz'])
end

delete([fileToCompare,'_Perms_Thr05.nii.gz']);
delete([fileToCompare,'_Perms_Thr01.nii.gz']);
delete([fileToCompare,'_Perms_Thr001.nii.gz']);
delete([fileToCompare,'_Perms_Thr0001.nii.gz']);
delete([fileToCompare,'_Perms_Thr00001.nii.gz']);
delete([fileToCompare,'_Perms_Thr000001.nii.gz']);

if mpFiltered
    dataMean.img(dataP.img(:) > 0.05) = 0;
    if sum(dataMean.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr05.nii.gz']);
    end

    dataMean.img(dataP.img(:) > 0.01) = 0;
    if sum(dataMean.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr01.nii.gz']);
    end
    dataMean.img(dataP.img(:) > 0.001) = 0;
    if sum(dataMean.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr001.nii.gz']);
    end
    dataMean.img(dataP.img(:) > 0.0001) = 0;
    if sum(dataP.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr0001.nii.gz']);        
    end
    dataMean.img(dataP.img(:) > 0.00001) = 0;
    if sum(dataP.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr00001.nii.gz']);
    end
    dataMean.img(dataP.img(:) > 0.000001) = 0;
    if sum(dataP.img(:) > 0)
        save_untouch_nii(dataMean,[fileToCompare,'_Perms_Thr000001.nii.gz']);
    end
end

delete([fileToCompare,'_Z_Thr05.nii.gz']);
delete([fileToCompare,'_Z_Thr01.nii.gz']);
delete([fileToCompare,'_Z_Thr001.nii.gz']);
delete([fileToCompare,'_Z_Thr0001.nii.gz']);
delete([fileToCompare,'_Z_Thr00001.nii.gz']);
delete([fileToCompare,'_Z_Thr000001.nii.gz']);

if ZFiltered
    ZImgOut.img(dataP.img(:) > 0.05) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.05) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr05.nii.gz']);
    end
    
    ZImgOut.img(dataP.img(:) > 0.01) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.01) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr01.nii.gz']);
    end
    
    ZImgOut.img(dataP.img(:) > 0.001) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.001) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr001.nii.gz']);
    end
    
    ZImgOut.img(dataP.img(:) > 0.0001) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.0001) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr0001.nii.gz']);
    end
    
    ZImgOut.img(dataP.img(:) > 0.00001) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.00001) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr00001.nii.gz']);
    end
    
    ZImgOut.img(dataP.img(:) > 0.000001) = 0;
    if sum(ZImgOut.img(:) > 0)
        ZImgOut.img(dataP.img(:) > 0.00001) = 0;
        save_untouch_nii(ZImgOut,[fileToCompare,'_Z_Thr000001.nii.gz']);
    end
    
end


disp('Done')