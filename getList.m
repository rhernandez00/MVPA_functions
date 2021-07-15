function textLine = getList(fileType,varargin)
%fileType: 'Hum' 'Dog'
getDriveFolder;
nItem = getArgumentValue('var1',false,varargin{:});
projectName = getArgumentValue('projectName','Complex',varargin{:});
projectFolder = getArgumentValue('projectFolder',driveFolder,varargin{:});
dispName = getArgumentValue('dispName',true,varargin{:});

switch fileType
    case 'Hum'
        fileName = [projectFolder,'\',projectName,'\data\Hum.txt'];
    case 'Dog'
        fileName = [projectFolder,'\',projectName,'\data\Dog.txt'];
    otherwise
        error('Wrong fileType');
end

if dispName
    disp(fileName)
end
fid = fopen(fileName);
tline = fgetl(fid);
n = 1;
while ischar(tline)
%     disp(tline)
    nChar = strfind(tline,' ');
    textList{n} =tline(nChar+1:end); 
    n = n+1;
%     disp();
    tline = fgetl(fid);
end
fclose(fid);

if nItem
    textLine = textList{nItem};
else
    textLine = textList;
end