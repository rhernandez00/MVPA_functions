function ROIe = createTableForFeatquery(experiment,specie,Z,FSLModel,copeN,varargin)
%Loads result image for a specific cope. Splits the results into clusters,
%finds the peak in that cluster, creates a nii file of a sphere in that peak,
%creates a list of spheres created and saves the list and nii files
%experiment: name of experiment
%specie: specie
%Z: Z of the cope results
%copeN: number of cope to use
%optional: subsPossible, if subsPossible is introduced, it will calculate
%the peak for each individual and create a group table
getDriveFolder;
subsPossible = getArgumentValue('subsPossible', [], varargin{:}); %If no subsPossible 
%is introduces, it assumes a group level analysis
addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);
resultsPath = [driveFolder,'\Results\',experiment,'\GLM\Z',...
    sprintf('%02d',Z*10),'\',sprintf('%03d',FSLModel),'\',specie];
copeDict = getCopeDict(FSLModel);
copePath = [resultsPath,'\',sprintf('%02d',copeN),'_',copeDict{copeN},'.nii.gz'];
copeNii = load_untouch_niiR(copePath);
zmap = copeNii.img;

disp('Getting cluster list...');
clusterList = getClusterList(zmap,1);

disp('assigning clusters to ROIe');
nROI = 1;
for nCluster = 1:numel(clusterList)
    if isempty(subsPossible)
        [val,coords,~] = max3dR(clusterList{nCluster});
        disp(['val in peak is: ',num2str(val)])
        ROIe(nROI).peakName = [copeDict{copeN},'_clus',sprintf('%02d',nCluster)];
        ROIe(nROI).coords = coords;
        nROI = nROI + 1;
    else
        mask = logical(clusterList{nCluster});
        for subN = 1:numel(subsPossible)
            sub = subsPossible(subN);
            disp(['sub: ',sprintf('%03d',sub)]);
            fullImg = loadFSLRes(experiment,specie,FSLModel,sub,0,copeN,'gfeat',true);
            fullImg = fullImg.*mask;

            [val,coords] = max3dR(fullImg);
            if size(coords,1) > 1
                warning('More than one peak');
                val = val(1);
                coords = coords(1,:);
            end
            disp(['val in peak is: ',num2str(val)]);
            ROIe(nROI).peakName = [copeDict{copeN},'_clus',sprintf('%02d',nCluster)]; %#ok<*AGROW>
            ROIe(nROI).coords = coords;
            ROIe(nROI).sub = sub;
            nROI = nROI + 1;
        end
    end
end
