userName = char(java.lang.System.getProperty('user.name'));
switch userName
    case 'Raul'
        %driveFolder = 'D:\Raul\Gdrive_oldCpy'; %changed 15/09/2021
        driveFolder = 'G:\My Drive';
    case 'Hallgato'
        %driveFolder = 'C:\Users\Hallgato\Google Drive';
        driveFolder = 'G:\My Drive';
    otherwise
        error('Check username');
end
switch userName
    case 'Raul'
        dropboxFolder = 'D:\Raul\Dropbox';
    case 'Hallgato'
        dropboxFolder = 'C:\Users\Hallgato\Dropbox';
    otherwise
        error('Check username');
end
clear userName