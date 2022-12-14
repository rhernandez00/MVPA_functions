function textLine = getList(fileType,varargin)
%fileType: 'Hum' 'Dog'
getDriveFolder;
nItem = getArgumentValue('nItem',false,varargin{:}); %number of item to read
experiment = getArgumentValue('experiment','Complex',varargin{:});
projectFolder = getArgumentValue('projectFolder',driveFolder,varargin{:});
dispName = getArgumentValue('dispName',true,varargin{:});

switch fileType
    case 'Hum'
        fileName = [projectFolder,'\',experiment,'\data\Hum.txt'];
    case 'H'
        fileName = [projectFolder,'\',experiment,'\data\Hum.txt'];
    case 'Dog'
        fileName = [projectFolder,'\',experiment,'\data\Dog.txt'];
    case 'D'
        fileName = [projectFolder,'\',experiment,'\data\Dog.txt'];
    otherwise
        error('Wrong fileType');
end

textLine = readTxtData(fileName,nItem,dispName);
