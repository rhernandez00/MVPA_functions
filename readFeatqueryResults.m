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
subsPossible = getArgumentValue('subsPossible',[],varargin{:}); %participants to 
%load. If empty, it means it is a group-level analysis
resultsPath = getArgumentValue('resultsPath',[],varargin{:});
if isempty(resultsPath)
    getDriveFolder;
    resultsPath = [driveFolder,'\Results\',experiment,'\',figureCode,'\Z',sprintf('%02d',Z*10),'\',specie];
    if ~exist([resultsPath,'\copeList.txt'],'file')
        disp([resultsPath,'\copeList.txt not found, cheking without ', 'Z',sprintf('%02d',Z*10)])
        resultsPath = [driveFolder,'\Results\',experiment,'\',figureCode,'\',specie];
        if ~exist([resultsPath,'\copeList.txt'],'file')
            error([resultsPath,'\copeList.txt not found either']);
        end
    end
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
% Getting catTypes used to interrogate with featQuery for FSLModelBase
[~,~,options] = getStimType(experiment,FSLModelBase,[],1);
catList = options.catTypes;
catTypes = cell(1,sum(options.stimsPerCat));
n = 1;
for nCat = 1:numel(catList)
    for stimRep = 1:options.stimsPerCat(nCat)
        catTypes{n} = [catList{nCat},sprintf('%02d',stimRep)];
        n = n+1;
    end
end

%assigning details to e
e.catTypes = catTypes; 
e.ROIList = ROIList;
e.FSLModelBase = FSLModelBase;
if isempty(subsPossible)
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
else %Individual-level results. Added 17/Jan/2023
     for nROI = 1:numel(ROIList)
        ROIName = ROIList{nROI};
        for nCat = 1:length(catTypes) %getting every cat
            for nSub = 1:numel(subsPossible)
                sub = subsPossible(nSub);
                fileName = [resultsPath,'\sub',sprintf('%03d',sub),'\',...
                    ROIName,'_cat',sprintf('%03d',nCat),fileType,'.txt'];
                fileID = fopen(fileName,'r'); %Reading the txt file
                try
                    vals = fscanf(fileID,'%f');
                catch
                    disp([fileName]);
                    error('error, file probably not found')
                end
                fclose(fileID);

                runsPossible = 1:numel(vals);

                for runN = 1:length(runsPossible) %getting every participant
                    matrixVals.(['sub',sprintf('%03d',sub)])(runN,nCat) = vals(runN)/100;
                end
            end
        end
        e.data.(ROIName) = matrixVals;
        clear matrixVals
     end
end


