function [vals,fileName] = runQualityFunction(experiment,specie,participant,run,varargin)

filesPath = getArgumentValue('pathIn',['G:\My Drive','\Results\',experiment,'\movement'],varargin{:});
savePath = getArgumentValue('pathOut',['D:\Raul\results\',experiment,'\movement\',specie],varargin{:});
program = getArgumentValue('program','FSL',varargin{:});
functionToUse = getArgumentValue('functionToUse','fwd',varargin{:});

switch functionToUse
    case 'fwd'
        switch program
            case 'FSL'
                cfg.prepro_suite =  'fsl-fs';
                cfg.motionparam =[filesPath,'\',experiment,specie,sprintf('%02d',participant),'run',sprintf('%02d',run),'.par'];
            case 'spm'
                cfg.prepro_suite =  'spm';
                cfg.motionparam =[filesPath,'\',experiment,specie,sprintf('%02d',participant),'run',sprintf('%02d',run),'.txt'];
            otherwise
                error([program, ' not available. Programs accepted are FSL and spm']);
        end

        cfg.radius = 28;

        fileName  = [filesPath,'\',experiment,specie,sprintf('%02d',participant),'run',sprintf('%02d',run),'.par'];
        disp(['Running fwd for: ',cfg.motionparam]);
        [fwd,~]=bramila_framewiseDisplacement(cfg);
        vals = fwd;
    case 'dvars'
        fileName = [filesPath,'\',experiment,specie,sprintf('%02d',participant),'run',sprintf('%02d',run),'.nii'];
        folderName = [filesPath,'\',experiment,specie,sprintf('%02d',participant),'run',sprintf('%02d',run)];
        
        if ~exist(fileName,'file') %checking if the file or folder are available. Then load
            disp(['File ,' fileName,' not found, checking for folder']);
            if ~exist(folderName,'dir')
                error(['Folder ,' folderName,' not found']);
            else
                disp(['Folder ,' folderName,' found, merging into a 4D file']);
                vol.img = load_niiFolder(folderName);
                
            end
        else
            disp(['File ,' fileName,' found, loading...']);
            vol = load_untouch_nii(fileName);
        end
        
        cfg.vol = vol.img;
        [dvars]=bramila_dvars(cfg);
        dvarsZ = [0;zscore(dvars(2:end))];
        vals = abs(dvarsZ);
    otherwise
        error('Wrong function, accepted ade fwd and dvars');
        
        
end

