function createROIForFeatquery(ROIe,specie,ROIFolder,varargin)
% Takes the coordinates and ROI names from ROIe. Creates spheres using the 
% coordinates and writes copeList.txt to be used with FeatqueryOnFolder.sh
% on gfeat results. Supports individual and group ROIs
% ROIe is a 1xn structure with:
% .peakName: name to be used for the ROI
% .coords: x,y,z coordinate to be used
ref = getArgumentValue('ref',[],varargin{:}); %use to force the use of a different reference map
rad = getArgumentValue('rad',3,varargin{:}); %size of the radius for the sphere. Default is 3
if isempty(ref)
    switch specie
        case 'D'
            ref = 'Barney2mm';
        case 'H'
            ref = 'MNI2mm';
    end
end
copeList = cell(1,size(ROIe,2)); %list of names to be used for the peaks
for nPeak = 1:size(ROIe,2)
    peakName = ROIe(nPeak).peakName;
    coords = ROIe(nPeak).coords;
    
    [brainMap,nii] = getCortex(ref);
    brainMap = zeros(size(brainMap));
    sphere = createSphere(brainMap,rad,coords);

    nii.img = sphere;
    if isfield(ROIe,'sub')
        sub = ROIe(nPeak).sub;
        finalFolder = [ROIFolder,'\',specie,'\sub',sprintf('%03d',sub)];
        ROIFile = [finalFolder,'\',peakName,'.nii.gz'];
        if ~exist(finalFolder,'dir')
            mkdir(finalFolder);
        end
    else
        finalFolder = [ROIFolder,'\',specie];
        ROIFile = [finalFolder,'\',peakName,'.nii.gz'];
        if ~exist(finalFolder,'dir')
            mkdir(finalFolder);
        end
    end
    save_untouch_nii(nii,ROIFile);
    disp([ROIFile, ' saved']);
    copeList{1,nPeak} = peakName; %adding sphere to list
end
if isfield(ROIe,'sub')
    copeList = unique(copeList);
end
txtName = [ROIFolder,'\',specie,'\copeList.txt'];
if exist(txtName,'dir')
    delete(txtName);
end
writeCopeList(txtName,copeList); %writing copeList into txt file