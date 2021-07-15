function clusterList = splitClusters(map)
warning('Might want to use splitInClusters');
% %%
% clear
% addpath('C:\Users\Hallgato\Dropbox\MVPA\funciones')
% resultsPath = 'C:\Users\Hallgato\Google Drive\Results\Dog';
% filePrefix = 'r3model2';
% 
% 
% tMap = load_untouch_niiR([resultsPath,'\',filePrefix,'_t_Thr001Corrected.nii.gz']);
% map = tMap.img;
% map(:) = tMap.img(:) > 0;
% 
% 
% %%


map = single(map ~= 0);
clustConn=6;
CC = bwconncomp(map,clustConn); %calculates the clusters

mapOut = map;
clusterList = cell(1,CC.NumObjects); %creates a list for each cluster
for j = 1:CC.NumObjects %goes through each cluster found
    coords = CC.PixelIdxList{j};
    mapOut(:) = 0;
    mapOut(coords) = 1;
    clusterList{j} = mapOut; %gets the map of each cluster
end