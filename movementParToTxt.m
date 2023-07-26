function [lostVolumes,totalVolumes,matTxt,fwd,parFile] = movementParToTxt(project,specie,thr,participant,run,varargin)
%error('deprecated, use functionToTxt');
filesPath = getArgumentValue('pathIn',['G:\My Drive','\Results\',project,'\movement'],varargin{:});
savePath = getArgumentValue('pathOut',['D:\Raul\results\',project,'\movement\',specie],varargin{:});
saveTxt = getArgumentValue('saveTxt',true,varargin{:});
program = getArgumentValue('program','FSL',varargin{:});
functionToUse = getArgumentValue('functionToUse','fwd',varargin{:});

switch functionToUse
    case 'fwd'
        switch program
            case 'FSL'
                cfg.prepro_suite =  'fsl-fs';
                cfg.motionparam =[filesPath,'\',project,specie,sprintf('%03d',participant),'_run',sprintf('%01d',run),'.par'];
            case 'spm'
                cfg.prepro_suite =  'spm';
                cfg.motionparam =[filesPath,'\',project,specie,sprintf('%03d',participant),'_run',sprintf('%01d',run),'.txt'];
            otherwise
                error([program, ' not available. Programs accepted are FSL and spm']);
        end

        cfg.radius = 50; %previously used 28 for dogs

        parFile  = [filesPath,'\',project,specie,sprintf('%03d',participant),'_run',sprintf('%01d',run),'.par'];
        disp(['Running fwd for: ',cfg.motionparam]);
%         cfg
        [fwd,~]=bramila_framewiseDisplacement(cfg);
        vals = fwd;
    case 'dvars'
        fileName = [filesPath,'\',project,specie,sprintf('%03d',participant),'_run',num2str(run),'.nii'];
        vol = load_untouch_nii(fileName);
        cfg.vol = vol.img;
        [dvars]=bramila_dvars(cfg);
        dvarsZ = [0;zscore(dvars(2:end))];
        vals = dvarsZ;
    otherwise
        error('Wrong function, accepted ade fwd and dvars');
        
        
end
        
indx = vals>thr;            
indxNums = find(indx);
totalVolumes = numel(indx);
lostVolumes = length(indxNums);
if ~isempty(indxNums)
    matTxt = zeros(length(vals),length(indxNums));
    for nCol = 1:length(indxNums)
        matTxt(indxNums(nCol),nCol) = 1;
    end
else
    matTxt = zeros(length(vals),1);
    matTxt = [];
end
m = readmatrix(parFile,'FileType','text');
matTxt = [m,matTxt];
fileOut = [savePath,'\sub',sprintf('%03d',participant),'_run',sprintf('%03d',run),'.txt'];
if saveTxt
    if ~exist(savePath,'dir')
        mkdir(savePath);
    end
    disp(['Writting file: ',fileOut]);
    %writematrix(matTxt,fileOut);
    writeTxt(fileOut,matTxt);
    %xlswrite(fileOut,logical(matTxt));
    %dlmwrite(fileOut,matTxt);
else
    disp(['No txt created']);
end

