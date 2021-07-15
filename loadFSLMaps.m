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
gfeat = getArgumentValue('gfeat',false,varargin{:});
inputZ = getArgumentValue('inputZ',[],varargin{:});
maskName = getArgumentValue('maskName',[],varargin{:});

if strcmp(experiment,'Prosody')
    filesPath = [basePath,'\',experiment,'\FSLNoFMSTD\Prosody'];    
else
    filesPath = [basePath,'\',experiment,'\FSL',experiment,specie,'STD'];
end

isCoord = ~isempty(coords);

%checks if the entry is in the table. True - loads into 'data'. False -
%creates new entry
[found,data,~,outImg] = checkTable(tablePath,isCoord,mask,coords,rad,sub,runN,...
    FSLModel,specie,nCat,fileTypeToLoad,task,gfeat,maskName);
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

switch fileTypeToLoad
    case 't'
        fileToLoad = 'tstat1';%options are tstat1, zstat1, cope1
        tileToLoad2 = 'tstat';
    case 'z'
        fileToLoad = 'zstat1';%options are tstat1, zstat1, cope1
        tileToLoad2 = 'zstat';
    case 'c'
        fileToLoad = 'cope1';%options are tstat1, zstat1, cope1
        tileToLoad2 = 'cope';
    case 'p'
        fileToLoad = 'pe1';%options are tstat1, zstat1, cope1
        tileToLoad2 = 'pe';
    otherwise
        fileTypeToLoad
        error('Wrong fileType, accepted are: t, z, p or cope');
end

if gfeat
    if isempty(inputZ)
        error('must input Z');
    end
    if sub == 0
        fileName = [resultsPath,'\',experiment,'\GLM\',sprintf('%03d',FSLModel),'\',...
            specie,'\',num2str(inputZ*10),'\run',sprintf('%03d',runN),'.gfeat\cope',...
            num2str(nCat),'.feat\stats\',tileToLoad2,'1.nii.gz'];
    else
        if runN ~= 0
            error(['Check runN, it must be 0. Currently it is: ',num2str(runN)]);
        end
        fileName = [resultsPath,'\',experiment,'\GLM\',sprintf('%03d',FSLModel),'\',...
            specie,'\',num2str(inputZ*10),'\sub',sprintf('%03d',sub),'.gfeat\cope',...
            num2str(nCat),'.feat\stats\',tileToLoad2,'1.nii.gz'];
    end
    BOLD = load_untouch_niiR(fileName);
    fullImg = BOLD.img;
else
    if loadFromBOLD
        fileName = [filesPath,'\',sprintf('%03d',FSLModel),'\data\sub',...
            sprintf('%03d',sub),'\BOLD\task',sprintf('%03d',task),'_run',...
            sprintf('%03d',runN),'\BOLD.nii.gz'];
        BOLD = load_untouch_niiR(fileName);
        fullImg = BOLD.img(:,:,:,nCat);
    else
        fileName = [filesPath,'\',sprintf('%03d',FSLModel),'\data\sub',...
            sprintf('%03d',sub),'\BOLD\task',sprintf('%03d',task),'_run',...
            sprintf('%03d',runN),'\.feat\stats\',tileToLoad2,num2str(nCat),'.nii.gz'];
        BOLD = load_untouch_niiR(fileName);
        fullImg = BOLD.img;
    end
end
disp(fileName);

if isempty(mask)%if there is no mask, creates a sphere and gets the data from within the sphere
    if isempty(coords)
        error('If filterWithMask, then you should supply a mask or coords');
    else
        maskImg = createSphere(fullImg,rad,coords); %creates a sphere
    end
else %input as either mask or name of the mask
    if numel(mask) > 1 %input as mask
        maskImg = logical(mask);
        
    else %input as name of mask
%         size(mask)
        maskData = load_untouch_niiR([maskPath,'\',mask,'.nii.gz']); %loads the designated mask
        maskImg = maskData.img;
        maskImg = single(logical(maskImg)); %binarizes whatever is in mask
    end
end


partialImg = fullImg(maskImg); %gets only the voxels within the selected area
outImg = fullImg;
outImg(:) = fullImg(:).*maskImg(:); %filters out the voxels not in the mask

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
    dataTable(nRow).outImg = outImg;
% dataTable
    disp([tablePath,' saved']);
    save(tablePath,'dataTable');
end


