function partialImg = loadFSLMaps(experiment,specie,FSLModel,sub,run,nCat,varargin)
%fileTypeToLoad accepted are: 't', 'z', 'cope'
filterWithMask = getArgumentValue('filterWithMask',false,varargin{:});
mask = getArgumentValue('mask',[],varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});
rad = getArgumentValue('rad',3,varargin{:});
task = getArgumentValue('task',1,varargin{:});
coords = getArgumentValue('coords',[],varargin{:});


switch fileTypeToLoad
    case 't'
        fileToLoad = 'tstat1';%options are tstat1, zstat1, cope1
    case 'z'
        fileToLoad = 'zstat1';%options are tstat1, zstat1, cope1
    case 'cope'
        fileToLoad = 'cope1';%options are tstat1, zstat1, cope1
    otherwise
        error('Wrong fileType, accepted are: t, z or cope');
end


filesPath = [basePath,'\',experiment,'\FSL',experiment,specie,'STD'];




fileName = [filesPath,'\',sprintf('%03d',FSLModel),'\data\sub',...
    sprintf('%03d',sub),'\BOLD\task',sprintf('%03d',task),'_run',...
    sprintf('%03d',run),'\BOLD.nii.gz'];
BOLD = load_untouch_niiR(fileName);


fullImg = BOLD.img(:,:,:,nCat);

if filterWithMask
    if isempty(mask)
        if isempty(coords)
            error('If filterWithMask, then you should supply a mask or coords');
        else
            mask = createSphere(fullImg,rad,coords);
        end
    end
end

partialImg = fullImg(mask);




