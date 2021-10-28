function [copesPossible,clustersPossible,copeNum,clusterNum] = separateROIPossible(ROIList)
%ROIList is a cell that contains the names of the copes available.
%gives back a list of copesPossible and the number of clusters (clustersPossible) for each
% clear
% ROIFolder = 'C:\Users\Hallgato\Google Drive\Results\Complex\GLM\Z31\050\D\ROI\r03';
% fileName = [ROIFolder,'\copeList.mat'];
% eX = load(fileName);
% ROIList = eX.copeList;

copeNum = zeros(1,length(ROIList));
clusterNum = zeros(1,length(ROIList));
for kROI  = 1:length(ROIList)
    ROIName = ROIList{kROI};
    ROINameBase = strsplit(ROIName,'_');
    ROINameBase1 = ROINameBase{1};
    ROINameBase2 = ROINameBase{2};
    copeNum(kROI) = str2double(ROINameBase1(5:6)); 
    clusterNum(kROI) = str2double(ROINameBase2);
end


 copesPossible = unique(copeNum); %which copes are availablee
 clustersPossible = zeros(1,length(copesPossible)); %how many clusters each cope has
 for i = 1:length(copesPossible)
   clustersPossible(i) = sum(copeNum==copesPossible(i)); % number of times each unique value is repeated
 end
