clear all
participants = 4;
runs = 10;
categories = 3; 
nRepetitions = 10000;

distribution = calculateDistribution(participants,runs,categories,nRepetitions);


%%
nReps = 200;
hallgato = false;
if hallgato
    driveFolder = 'C:\Users\Hallgato\Google Drive';
else
    driveFolder = 'D:\Raul\Gdrive';
end
baseFile = [driveFolder,'\Faces_Hu\CommonFiles\Datta.nii.gz'];
repsFolder = [driveFolder,'\Results\DogEmotions\rnd'];

for rep = 1:nReps
    disp(sprintf('%04d',rep))
    dataImg = load_untouch_niiR(baseFile);
    dataPerf = dataImg.img;
    dataBin = dataImg.img > 0;
    for j = 1:length(dataBin(:))
        if dataBin(j)
            perf = randsample(distribution,1,false);
            dataPerf(j) = perf;
        end
    end
    dataImg.img = dataPerf;
    save_untouch_nii(dataImg,[repsFolder,'\','rep',sprintf('%04d',rep),'.nii.gz']);
end