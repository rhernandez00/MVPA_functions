userName = char(java.lang.System.getProperty('user.name'));
switch userName
    case 'Raul'
        dropboxFolder = 'D:\Raul\Dropbox';
    case 'Hallgato'
        dropboxFolder = 'C:\Users\Hallgato\Dropbox';
    otherwise
        error('Check username');
end
clear userName