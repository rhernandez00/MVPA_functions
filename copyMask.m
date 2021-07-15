function subList = copyMask(maskFile,varargin)
getDriveFolder;
defaultFolder = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Labels2mm\others'];
experimentDefaultFolder = 'D:\Raul\data\Prosody\NoFMSTD';
maskFolder = getArgumentValue('maskFolder',defaultFolder,varargin{:});
experimentFolder = getArgumentValue('experimentFolder',experimentDefaultFolder,varargin{:});
destinationFolder = getArgumentValue('destinationFolder','orig',varargin{:});

subList = ls([experimentFolder,'\data\sub*']);

if isempty(subList)
    disp('No participants found');
    disp([experimentFolder,'\data\sub*'])
end

nSubsTotal = size(subList,1);
% nSubsTotal = str2double(subList(end,4:end));

for nSub = 1:nSubsTotal
    sub = subList(nSub,4:end);
    maskToCopy = [maskFolder,'\',maskFile,'.nii.gz'];
%     newFile = [experimentFolder,'\data\sub',sprintf('%03d',nSub),'\masks\',destinationFolder,'\',maskFile,'.nii.gz'];
    maskDestinationFolder = [experimentFolder,'\data\sub',sub,'\masks\',destinationFolder];
    mkdir(maskDestinationFolder);
    newFile = [experimentFolder,'\data\sub',sub,'\masks\',destinationFolder,'\',maskFile,'.nii.gz'];
    try
        copyfile(maskToCopy,newFile,'f');
        disp([maskFile, ' copied from ', maskFolder, ' to ', newFile]);
    catch
        disp(['mask to copy:',maskToCopy])
        disp(['file to create:',newFile])
        disp(['FAILED: ', newFile]);
    end
end
%%
% clear all
% maskFolder = [driveFolder,'\Faces_Hu\CommonFiles\Dogs\Faces'];
% maskList = {'ALLvsFixCross.nii.gz'};

% maskList = {'b_OccipitoTemporal'};
% experimentFolder = 'D:\Raul\data\Faces\FacesHSTD';
% maskFolder = 'D:\Raul\Gdrive\Faces_Hu\CommonFiles\Human\Faces';
% for nMask = 1:length(maskList)
%     fileName = maskList{nMask};
%     subList = copyMask(fileName,'maskFolder',maskFolder,'experimentFolder',experimentFolder);
% end

%
% clear all
% getDriveFolder;
% maskFolder = [driveFolder,'\Faces_Hu\CommonFiles\Human\BN'];
% destinationFolder = 'BN';
% 
% maskList = dir([maskFolder,'\*.nii.gz']);
% maskList = {maskList.name};
% for nMask = 1:length(maskList)
%     maskList{nMask} =  maskList{nMask}(1:end-7);
% end
% % experimentFolder = 'D:\Raul\data\Faces\FacesHSTD';
% experimentFolder = 'D:\Raul\data\MNI';
% for nMask = 1:length(maskList)
%     fileName = maskList{nMask};
%     subList = copyMask(fileName,'maskFolder',maskFolder,...
%         'experimentFolder',experimentFolder,'destinationFolder',destinationFolder);
% %     error('r')
% end