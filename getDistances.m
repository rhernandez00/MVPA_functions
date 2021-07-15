function [DM,DMComplete,subjectList] = getDistances(data,mask,maskType,trimPercent,repetitions)
%%
if nargin < 4
    trimPercent = 0;
    repetitions = 0;
end
filterMask = strcmp([data.mask],mask);
if strcmp(maskType,'All')
    finalFilter = find(filterMask);
else
    
    filterType = strcmp([data.type],maskType);
    finalFilter = find(filterMask.*filterType);
end

    
%sum(finalFilter)
data = data(finalFilter);
% data
% length(data)
% length(data(1).DMvals)

DMComplete = zeros(length(data),length(data(1).DMvals));
subjectList = zeros(length(data(1).DMvals),1);
for i = 1:length(data)
    DMComplete(i,:) = data(i).DMvals;
    subjectList(i,1) = data(i).subject;
end

size(DMComplete);
length(data(1).DMvals);
if ~(trimPercent)
    DM = mean(DMComplete);
else
    DM = [];
    for k = 1:length(data(1).DMvals)
        samples = randsample(DMComplete(:,k),repetitions,true);
        DM(k) = trimmean(samples,trimPercent);
    end
end
