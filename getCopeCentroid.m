function [e,nClusters] = getCopeCentroid(sub,Z,FSLModel,specie,nCope,varargin)

getDriveFolder;
experiment = getArgumentValue('experiment','Complex',varargin{:});
r = getArgumentValue('r',3,varargin{:});
zero = getArgumentValue('zero',16,varargin{:});

addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);


[~,copesPossible] = getCopeDict(FSLModel); %gets the list of 

copesPath = getCopePath(experiment,Z,FSLModel,specie,r,sub);
cope = copesPossible(nCope);
ignoreMultipleCentroids = true; %will ignore if the function founds multiple centroids

files = dir([copesPath,'\cope',sprintf('%02d',cope),'*.nii.gz']);
fileList = {files.name};
if isempty(fileList)
    e = [];
    nClusters = 0;
else
    nClusters = size(fileList,2);
    for n = 1:nClusters
        fileToLoad = [copesPath,'\',fileList{n}];
        data = load_untouch_nii(fileToLoad);
        imgMatrix = data.img;
        [~,~,multipleCentroid,coords] = getCentroid(imgMatrix,'ignoreMultipleCentroids',ignoreMultipleCentroids); %#ok<ASGLU>
        e(n).x = coords(1); %#ok<*AGROW>
        e(n).y = coords(2);
        e(n).z = coords(3);
        e(n).nCluster = n;
        e(n).path = fileToLoad;
        if coords(1) > zero
            e(n).direction = 1;
        else
            e(n).direction = -1;
        end
    end
end

% return
%%
%     contrastName = [sprintf('%02d',cope),'_',copeDict{cope}];
%     
%     copeFolder = [resultsFolder,'\',experiment,'\GLM\',sprintf('%03d',fslModel),...
%         '\',specie,'\',num2str(Z*10),'\sub',sprintf('%03d',sub),'.gfeat\','cope',num2str(cope),'.feat'];
%     
%     fileName = [copeFolder,'\thresh_zstat1.nii.gz'];
%     pngFile = [copeFolder,'\rendered_thresh_zstat1.png'];
%     
%     fileOut = [folderOut,'\sub',sprintf('%03d',sub),'_',contrastName];
% end