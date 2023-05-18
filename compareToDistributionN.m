 function [dataP,distribution,mu,sigma] = compareToDistributionN(fileToCompare,varargin)
%takes a mean performance file and compares it against a file of a
%nifti distribution (mp.nii.gz, SD.nii.gz), which is a matrix with nRep as row, and nVox as
%columns
side = getArgumentValue('side','moreThan',varargin{:});
suffix = getArgumentValue('suffix','_mp',varargin{:});
mul = getArgumentValue('mul',1,varargin{:}); %
distributionNifti = getArgumentValue('distributionNifti',[],varargin{:}); %name of file without _mp
if isempty(distributionNifti)
    error('Must introduce mean file');
else
    dataMu = load_untouch_niiR([distributionNifti,'_mp.nii.gz']);
    dataSigma = load_untouch_niiR([distributionNifti,'_SD.nii.gz']);
end

ZImg = getArgumentValue('ZImg',false,varargin{:});
pImg = getArgumentValue('pImg',true,varargin{:});
ZFiltered = getArgumentValue('ZFiltered',true,varargin{:});

%to filter with cortex
cortex = getArgumentValue('cortex',false,varargin{:});
getDriveFolder;
cxFile = getArgumentValue('cortexFile','MNI2mm',varargin{:});

if cortex
    ctx = getCortex(cxFile);
end

fileM=[fileToCompare,suffix,'.nii.gz'];
disp(['Loading ', fileM]);

dataMean = load_untouch_niiR(fileM);
dataMean.img(isnan(dataMean.img(:))) = 0;

ZImgOut = dataMean;
ZImgOut.img(:) = 0;
dataP = dataMean;
img = dataMean.img(:);

if cortex %filters out whatever falls outside the mask
    indx = find(ctx(:));
    disp('Cortex');
else
    indx = 1:length(dataMean.img(:));
end

nVoxs = length(dataMean.img(:));%size(dataMatrix,2); %#ok<NODEF>


for nVox = 1:length(indx)
    
    if isempty(indx)
        break
    end
    vox = indx(nVox);
    val = dataMean.img(vox);
    mu = dataMu.img(vox);
    sigma = dataSigma.img(vox)*mul;
    if isnan(mu) %if is nan, assign default values
        p = 1;
        z = 0;
    elseif sigma == 0 %air or not calculable
        p = 1;
        z = 0;

    else 
        distribution = makedist('Normal','mu',mu,'sigma',sigma);%create distribution,
        p = pFromDist(distribution,val,side); % make comparison
        z = (val - mu) / sigma; %z transform
    end
    
    dataP.img(vox) = p;
    ZImgOut.img(vox) = z;
    if isnan(z)
        vox
        val
        mu
        sigma
        error('z is nan')
    end
end

disp(['Saving ', fileToCompare])
if pImg
    save_untouch_nii(dataP,[fileToCompare,'_p.nii.gz']);
end


if ZImg
    save_untouch_nii(ZImgOut,[fileToCompare,'_Z.nii.gz']);
%     disp(['the file tested is: ', fileToCompare,suffix])
    disp(['the output file is: ', fileToCompare,'_Z.nii.gz'])
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