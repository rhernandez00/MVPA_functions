function [partialImg,outImg] = loadFSLMaps(experiment,specie,FSLModel,sub,runN,nCat,varargin)
getDriveFolder;
mask = getArgumentValue('mask',[],varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'c'
rad = getArgumentValue('rad',3,varargin{:});
task = getArgumentValue('task',1,varargin{:});
coords = getArgumentValue('coords',[],varargin{:});
maskPath = getArgumentValue('maskPath',[driveFolder,'\Results\',experiment,'\ROIs'],varargin{:});
tablePath = getArgumentValue('tablePath',[driveFolder,'\Results\',experiment,'\dataTable\dataTable.mat'],varargin{:});
saveDataTable = getArgumentValue('saveDataTable',true,varargin{:});
loadFromBOLD = getArgumentValue('loadFromBOLD',true,varargin{:});
resultsPath = getArgumentValue('resultsPath','D:\Raul\results',varargin{:});
gfeat = getArgumentValue('gfeat',false,varargin{:}); %individual/group mean?
inputZ = getArgumentValue('inputZ',[],varargin{:}); %z used for the gfeat folder
maskName = getArgumentValue('maskName','coord',varargin{:});

if strcmp(experiment,'Prosody')
    filesPath = [basePath,'\',experiment,'\FSLNoFMSTD\Prosody'];    
else
    filesPath = [basePath,'\',experiment,'\FSL',experiment,specie,'STD'];
end

% isCoord = strcmp(
isCoord = ~isempty(coords);

%checks if the entry is in the table. True - loads into 'data'. False -
%creates new entry
% tablePath = [dropboxFolder,'\MVPA\Complex\RSA\dataTable.mat'];
outImg = [];
noOutImg = true;
if noOutImg
%     fieldsToCheck = {'tablePath','isCoord','mask','coords','rad','sub','runN',...
%     'FSLModel','specie','nCat','fileTypeToLoad','task','gfeat','maskName'};
%     for nField = 1:numel(fieldsToCheck)
%         e.(fieldsToCheck{nField}) = eval(fieldsToCheck{nField});
%     end
%     partialImg = []; outImg = [];
%     return
    [found,data,~,~] = checkTable(tablePath,isCoord,mask,coords,rad,sub,runN,...
    FSLModel,specie,nCat,fileTypeToLoad,task,gfeat,maskName);
%     error('r')
else
    [found,data,~,outImg] = checkTable(tablePath,isCoord,mask,coords,rad,sub,runN,...
        FSLModel,specie,nCat,fileTypeToLoad,task,gfeat,maskName); %#ok<UNRCH> %KEEP FOR OUTIMG
    
end
if found == 0
%     tablePath
%     isCoord
%     mask
%     coords
%     rad
%     sub
%     runN
%     FSLModel
%     specie
%     nCat
%     fileTypeToLoad
%     task
%     error('not found')
end

if found
%     disp('Entry found, loading from table');
    partialImg = data;
    return
else
    if exist(tablePath,'file')
        disp([tablePath, ' exist, loading']);
        load(tablePath);
    else
        disp('creating new');
        disp([tablePath, ' doesnt exist']);
        nRow = 1;
        dataTable(nRow).isCoord = true; %is it a coordinate or a mask?
        dataTable(nRow).name = 'test'; %in case it is a mask
        dataTable(nRow).coords = [0,0,0]; %in case it is  coords
        dataTable(nRow).rad = 4; %in case it is  coords, the rad
        dataTable(nRow).sub = 0; %number of participant
        dataTable(nRow).run = nRow; %number of run
        dataTable(nRow).FSLModel = 1;%FSLModel
        dataTable(nRow).data = 0; %vector of data
        dataTable(nRow).specie = 0;
        dataTable(nRow).nCat = nRow;
        dataTable(nRow).fileTypeToLoad = 'z';
        dataTable(nRow).task = 1;
    end
    disp('Not found, getting from images');
end

%Loads an image of results from FSL
[fullImg,fileName]= loadFSLRes(experiment,specie,FSLModel,sub,runN,nCat,...
    'fileTypeToLoad',fileTypeToLoad,'task',task,'loadFromBOLD',loadFromBOLD,...
    'resultsPath',resultsPath,'gfeat',gfeat,'filesPath',filesPath,'basePath',basePath, 'inputZ',inputZ);
disp(fileName);

% if strcmp(mask,'coord')
if isempty(mask)%if there is no mask, creates a sphere and gets the data from within the sphere
    disp('Mask is empty, using coords');
    if isempty(coords)
        error('If filterWithMask, then you should supply a mask or coords');
    else
        maskImg = createSphere(fullImg,rad,coords); %creates a sphere
    end
else %input as either mask or name of the mask
    disp('Mask found')
    if isstr(mask) %#ok<DISSTR> %input as name of mask
        disp(['Loading ',maskPath,'\',mask,'.nii.gz']);
        maskData = load_untouch_niiR([maskPath,'\',mask,'.nii.gz']); %loads the designated mask
        maskImg = maskData.img;
        maskImg = single(logical(maskImg)); %binarizes whatever is in mask
    else
        disp('Mask was not a string');
        disp(class(mask));
    end
    maskImg = logical(maskImg);
end


partialImg = fullImg(maskImg); %gets only the voxels within the selected area

if noOutImg
    outImg = [];
else
    
    outImg = fullImg;
    outImg(:) = fullImg(:).*maskImg(:); %filters out the voxels not in the mask
end

if saveDataTable % This is to save the data loaded in to a table for future use
    nRow = size(dataTable,2) + 1; %selects the new row
    dataTable(nRow).isCoord = ~isempty(coords); %is it a coordinate or a mask?
    if isempty(maskName)
        dataTable(nRow).name = mask; %in case it is a mask
    else
        dataTable(nRow).name = maskName;
    end
    dataTable(nRow).coords = coords; %in case it is  coords
    dataTable(nRow).rad = rad; %in case it is  coords, the rad
    dataTable(nRow).sub = sub; %number of subject
    dataTable(nRow).run = runN; %number of run
    dataTable(nRow).FSLModel = FSLModel;%FSLModel
    dataTable(nRow).data = partialImg; %vector of data
    dataTable(nRow).specie = specie;
    dataTable(nRow).nCat = nCat;%category
    dataTable(nRow).task = task;%task
    dataTable(nRow).fileTypeToLoad = fileTypeToLoad; %#ok<*STRNU>
    if noOutImg
    else
        dataTable(nRow).outImg = outImg;
    end
    disp([tablePath,' saved']);
    save(tablePath,'dataTable');
end


