function textLine = getRunsPossible(fileType,experiment,varargin)
%fileType: 'Hum' 'Dog'

nItem = getArgumentValue('nItem',false,varargin{:}); %number of item to read
projectFolder = getArgumentValue('projectFolder',[],varargin{:});
dispName = getArgumentValue('dispName',true,varargin{:});
if isempty(projectFolder)
    getDriveFolder;
    projectFolder = driveFolder;
end

switch fileType
    case 'Hum'
        fileName = [projectFolder,'\',experiment,'\data\HumRuns.txt'];
    case 'H'
        fileName = [projectFolder,'\',experiment,'\data\HumRuns.txt'];
    case 'Dog'
        fileName = [projectFolder,'\',experiment,'\data\DogRuns.txt'];
    case 'D'
        fileName = [projectFolder,'\',experiment,'\data\DogRuns.txt'];
    otherwise
        error('Wrong fileType');
end

%disp(fileName)
textLine = readTxtData(fileName,nItem,dispName);
