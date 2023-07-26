function [fullImg,fileName,BOLD]= loadFSLRes(experiment,specie,FSLModel,sub,runN,nCat,varargin)
%loads an image processed by FSL
getDriveFolder;

basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'c'
task = getArgumentValue('task',1,varargin{:});
loadFromBOLD = getArgumentValue('loadFromBOLD',true,varargin{:});
resultsPath = getArgumentValue('resultsPath','D:\Raul\results',varargin{:});
gfeat = getArgumentValue('gfeat',false,varargin{:});
inputZ = getArgumentValue('inputZ',[],varargin{:}); %z used for the gfeat folder

filesPath = getArgumentValue('filesPath',[],varargin{:});

if isempty(filesPath)
    if strcmp(experiment,'Prosody')
        filesPath = [basePath,'\',experiment,'\FSLNoFMSTD\Prosody'];    
    else
        filesPath = [basePath,'\',experiment,'\FSL',experiment,specie,'STD'];
    end
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
    
    if sub == 0 %loading file from group
        if isempty(inputZ)
            error('must input Z');
        end
        fileName = [resultsPath,'\',experiment,'\GLM\',sprintf('%03d',FSLModel),'\',...
            specie,'\',num2str(inputZ*10),'\run',sprintf('%03d',runN),'.gfeat\cope',...
            num2str(nCat),'.feat\stats\',tileToLoad2,'1.nii.gz'];
    else %Loading file from individual
        if runN ~= 0
            error(['Check runN, it must be 0. Currently it is: ',num2str(runN)]);
        end
        fileName = [resultsPath,'\',experiment,'\GLM\',sprintf('%03d',FSLModel),'\',...
            specie,'\sub',sprintf('%03d',sub),'.gfeat\cope',...
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