function [imgOut] = getHRF(specie,sub,varargin)
getDriveFolder;
experiment = getArgumentValue('experiment','Complex',varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
runsPossible = getArgumentValue('runsPossible',1:3,varargin{:});
task = getArgumentValue('task',1,varargin{:});
TR = getArgumentValue('TR',2.5,varargin{:});
volumes = getArgumentValue('volumes',124,varargin{:});
timeStep = getArgumentValue('timeStep',0.02,varargin{:});
minTime = getArgumentValue('minTime',1,varargin{:});
maxTime = getArgumentValue('maxTime',10,varargin{:});
realTimeLine = 0:TR:TR*(volumes-1);
newTimeLine = 0:timeStep:TR*(volumes-1);

participant = getList(specie,'nItem',sub,'experiment',experiment);
onsetFolder = [dropboxFolder,'\MVPA\',experiment,'\runsData\complete'];

e = load([onsetFolder,'\',participant,'.mat']);
complete = e.complete;
for nRow = 1:size(complete,2)
    onset = complete(nRow).onset;
    indx = find(round(onset*100)==round(newTimeLine*100));
    minIndx = indx - minTime/timeStep;
    maxIndx = indx + maxTime/timeStep;
    if minIndx < 1
        minIndx = 1;
    end
    if maxIndx > length(newTimeLine)
        maxIndx = length(newTimeLine);
    end
    complete(nRow).indx = indx;
    complete(nRow).minIndx = minIndx;
    complete(nRow).maxIndx = maxIndx;
end


nRun = 1;
runN = runsPossible(nRun);
complete2 = filterBy(complete,'run',{runN});
%allTimes = nan(size(complete2,2),length(-minTime:timeStep:maxTime));

%gettingBOLD
filename = [basePath,'\',experiment,'\',experiment,specie(1),'STD\data\sub',...
    sprintf('%03d',sub),'\BOLD\task',sprintf('%03d',task),'_run',...
    sprintf('%03d',runN),'\BOLD.nii.gz'];

BOLDImg = load_untouch_niiR(filename);

mask = getCortex([specie(1),'_fullBrain']);
disp('filtering with mask');
[BOLDFiltered,maskOut,maskIndx] = filterWithMask(BOLDImg.img,mask);
imgOut = zeros(size(BOLDFiltered,1),size(BOLDFiltered,2),size(BOLDFiltered,3),length(allTimes));

for x = 1:size(BOLDFiltered,1)
    disp(['x: ', num2str(x), ' / ' ,num2str(size(BOLDFiltered,1))])
    for y = 1:size(BOLDFiltered,2)
        for z = 1:size(BOLDFiltered,3)
            values = BOLDFiltered(x,y,z,:);
            values = values(:);
            if sum(values) == 0
                continue
            else
                
%                 size(realTimeLine)
%                 size(values)
                newValues = interp1(realTimeLine,values,newTimeLine);
                minIndxs = [complete2.minIndx];
                maxIndxs = [complete2.maxIndx];
                
                allTimes = nan(numel(minIndxs),length(minIndx:maxIndx));
%                 size(allTimes)
                for nRow = 1:numel(minIndxs)
                    minIndx = minIndxs(nRow);
                    maxIndx = maxIndxs(nRow);
                    allTimes(nRow,:) = newValues(minIndx:maxIndx);
                end
                %disp(size(allTimes))
                avHRF = nanmean(allTimes); %#ok<NANMEAN>
                imgOut(x,y,z,:) = avHRF;
            end
        end
    end
end