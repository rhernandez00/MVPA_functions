function clustersSizes = getClusterDistributionFromfiles(rndFolder,distributionFile,varargin)
fileList = getArgumentValue('fileList',[],varargin{:});
thr = getArgumentValue('thr',0.001,varargin{:});
direction = getArgumentValue('direction','moreThan',varargin{:});
maxPossible = getArgumentValue('maxPossible',0,varargin{:});
nToleratedValues = 10;

if isempty(fileList)
    fileList = ls([rndFolder,'\','*.nii.gz']);
    for rep = 1:size(fileList,1)
        fileName = fileList(rep,:);
        fileName = strtrim(fileName);
        fileList2{rep} = fileName;
    end
    fileList = fileList2;
end

oldPath = pwd;
cd(rndFolder);

nReps = length(fileList);

clustConn = 6; %connections to count, either 6 or 27

count = 1;
clusterSizes = [];


for rep = 1:nReps
    %fileName = [repResultsPath,'\res',sprintf('%03d',j),'_p.nii.gz'];
    fileName = [rndFolder,'\',fileList{rep}];
    disp(fileName);
    disp(['repetition: ',num2str(rep),' of ',num2str(nReps)])
    data = load_niiR(fileName);
    
    if maxPossible == 0
        
    else
        if sum(data.img(:) > maxPossible) > nToleratedValues 
            disp('File dropped')
            continue
        end
    end
    switch direction
        case 'moreThan'
            data.img(:) = data.img(:) > thr;
        case 'lessThan'
            data.img(:) = data.img(:) < thr;
        otherwise
            error('Wrong direction');
    end
    
    CC = bwconncomp(data.img,clustConn);
    for j = 1:CC.NumObjects
        if size(CC.PixelIdxList{j},1) > 1000
            
%             error('r')
        end
            clustersSizes(count) = size(CC.PixelIdxList{j},1); %#ok<SAGROW>
%             if clustersSizes(count) > 100
%                 error('r')
%             end
            if size(CC.PixelIdxList{j},2) ~= 1
                error('k')
            end
            if size(CC.PixelIdxList{j},1) < 1
                error('kk')
            end

            count = count + 1;
    end
    numOfClusters(rep) = CC.NumObjects;
%     error('r')
end


cd(oldPath)


save(distributionFile,'clustersSizes','numOfClusters')
disp('Cluster size distribution file saved');
disp(distributionFile)