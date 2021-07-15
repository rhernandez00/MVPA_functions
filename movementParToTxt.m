function [lostVolumes,totalVolumes,matTxt,fwd] = movementParToTxt(project,specie,thr,participant,run,varargin)
getDriveFolder;
filesPathMovement = getArgumentValue('pathIn',[driveFolder,'\Results\',project,'\movement'],varargin{:});
savePath = getArgumentValue('pathOut',['D:\Raul\results\',project,'\movement\',specie],varargin{:});
saveTxt = getArgumentValue('saveTxt',true,varargin{:});

cfg.prepro_suite =  'fsl';
cfg.radius = 28;
cfg.motionparam =[filesPathMovement,'\',project,specie,sprintf('%03d',participant),'_run',num2str(run),'.par'];
disp(['Running fwd for: ',cfg.motionparam]);
[fwd,~]=bramila_framewiseDisplacement(cfg);
vals = fwd;

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
end
fileOut = [savePath,'\sub',sprintf('%03d',participant),'_run',sprintf('%03d',run),'.txt'];
if saveTxt
    disp(['Writting file: ',fileOut]);
    dlmwrite(fileOut,matTxt);
else
    disp(['No txt created']);
end

