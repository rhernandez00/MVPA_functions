function e = readFeatqueryResults(experiment,figureCode,specie,FSLModelBase,Z,varargin)
% Reads Featquery resuls. The results were created using bash script
% FeatqueryOnFolder.sh on group-level gfeat results
% The function returns e . e is a structure that contains:
% e.catTypes: name of the categories
% e.ROIList: list of ROIs interrogated using featquery
% e.FSLModelBase: model used to interrogate featquery
% Inputs: 
% experiment: name of experiment as string (e.g. 'Complex')
% figureCode: name of folder for figure (e.g. 'FigureP')
% specie: specie of the participant ('D' or 'H')
% FSLModelBase: model used to interrogate featquery
fileType = getArgumentValue('fileType','mean',varargin{:}); %either mean or max
resultsPath = getArgumentValue('resultsPath',[],varargin{:});
if isempty(resultsPath)
    getDriveFolder;
    resultsPath = [driveFolder,'\Results\',experiment,'\',figureCode,'\Z',sprintf('%02d',Z*10),'\',specie];
end

%Reading copeList and saving it in ROIList
fileID = fopen([resultsPath,'\copeList.txt'],'r');
disp(['Getting ',resultsPath,'\copeList.txt', ' ....']);
tline = fgetl(fileID);
nROI = 1;
while ischar(tline)
    ROIList{nROI} = tline;  %#ok<AGROW>
    tline = fgetl(fileID);
    nROI = nROI + 1;
end
fclose(fileID);
fileType = ['_',fileType]; %_max or _mean, this is the output from featquery
%%

[~,~,options] = getStimType(experiment,FSLModelBase,[],1);
catTypes = options.catTypes;

%assigning details to e
e.catTypes = catTypes; 
e.ROIList = ROIList;
e.FSLModelBase = FSLModelBase;

for nROI = 1:numel(ROIList)
    ROIName = ROIList{nROI};
    for nCat = 1:length(catTypes) %getting every cat
        fileName = [resultsPath,'\',ROIName,'_cat',sprintf('%03d',nCat),fileType,'.txt'];
        fileID = fopen(fileName,'r'); %Reading the txt file
        try
            vals = fscanf(fileID,'%f');
        catch
            disp([fileName]);
            error('error, file probably not found')
        end
        fclose(fileID);
        subsPossible2 = 1:numel(vals);
        for subN = 1:length(subsPossible2) %getting every participant
            matrixVals(subN,nCat) = vals(subN)/100; %#ok<AGROW>
        end
    end
    e.data.(ROIName) = matrixVals;
    clear matrixVals
end

                    