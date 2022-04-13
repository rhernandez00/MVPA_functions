function res = calculateDissimilarityTable(experiment,FSLModel,specie,subsPossible,varargin)
%calculates a table where it compares sets of voxels of given categories
%outputs the table
sameRunOp = getArgumentValue('sameRun','same',varargin{:}); %takes maskN, same,different,all (possible combinations)
sameStimOp = getArgumentValue('sameStim','all',varargin{:});%takes same,different,all (possible combinations)
runsPossible = getArgumentValue('runs',[],varargin{:}); %runs to test
verb = getArgumentValue('verb',true,varargin{:}); %if true prints during execution
tablePath = getArgumentValue('tablePath',[],varargin{:});
regionType = getArgumentValue('regionType','coord',varargin{:}); %takes coord, mask or model (to test a model)
coords = getArgumentValue('coords',[],varargin{:}); %voxel coords
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'c'
r = getArgumentValue('rad',3,varargin{:}); %radius for sphere in voxel coords
mask = getArgumentValue('mask',[],varargin{:}); %can be a mask name or a 3D matrix
nReps = getArgumentValue('nReps',[],varargin{:}); %if a number is introduced,
%that will be the number of permutations to run instead of the actual measurement
modelName = getArgumentValue('modelName','DSMV1',varargin{:}); %in case of using model. Only DSMV1 for now


if strcmp(regionType,'maskN')
    getDriveFolder;
    maskPath = getArgumentValue('maskPath',[driveFolder,'\Results\',experiment,'\ROIs'],varargin{:});
end

%metrics to calculate
distanceCorrelation = getArgumentValue('distanceCorrelation',true,varargin{:}); % calculate or not correlation distance
Spearman = getArgumentValue('Spearman',false,varargin{:});
Pearson = getArgumentValue('Pearson',false,varargin{:});
Mah = getArgumentValue('Mah',false,varargin{:});

[~,~,options] = getStimType(experiment,FSLModel,1,1); %gets info on the experiment
if isempty(runsPossible) %if empty, gets it from the options
    runsPossible = options.runs;
end
if isempty(tablePath) %if empty, sends it to the default
    getDriveFolder;
    tablePath = [driveFolder,'\Results\',experiment,...
            '\dataTable'];
end
if ~exist(tablePath,'dir') %creates folder if it doesnt exist
    mkdir(tablePath);
end
categories = options.totalStims; %gets the categories possible

%Creating the template table ====================================
stim = repmat(1:categories,1,numel(runsPossible))'; %creates a list of stimuli 
runN = repmat(runsPossible,categories,1); %creates a list of runs
runN = reshape(runN,numel(runN),1);
ID = (1:numel(stim))'; %identifier for a combination of run-stim
baseTable = table(stim,runN,ID); %table that contains one row for each stimuli
pairs = combinator(numel(ID),2,'c'); %creates the pairs to analyze
runN1 = baseTable.runN(pairs(:,1)); %gets the run list for run1
runN2 = baseTable.runN(pairs(:,2)); %gets the run list for run2
sameRun = runN1 == runN2;
stim1 = baseTable.stim(pairs(:,1)); %gets the stim list for stim1
stim2 = baseTable.stim(pairs(:,2)); %gets the stim list for stim1
sameStim = stim1 == stim2;
%infoTable contains the list of stimuli and runs to use. Its the template for
%the stimuli to compare
infoTableO = table(stim1,stim2,runN1,runN2,sameRun,sameStim);
% ==============================================================
%filtering out according to options sameRunOp and sameStimOp
switch sameRunOp
    case 'same'
        infoTableO = infoTableO(infoTableO.sameRun,:);
    case 'different'
        infoTableO = infoTableO(~infoTableO.sameRun,:);
    case 'all'
        %nothing to do
    otherwise
        disp(sameRunOp);
        error('wrong option, acceptable are same, different, all');
end
switch sameStimOp
    case 'same'
        infoTableO = infoTableO(infoTableO.sameStim,:);
    case 'different'
        infoTableO = infoTableO(~infoTableO.sameStim,:);
    case 'all'
        %nothing to do
    otherwise
        disp(sameStimOp);
        error('wrong option, acceptable are same, different, all');
end
if isempty(infoTableO)
    error(['table is empty, check options current: sameStim=',...
        sameStimOp, ' sameRun=',sameRunOp]);
end


res = []; %initializes res
for nSub = 1:length(subsPossible)
    sub = subsPossible(nSub);
    if verb
        disp(['Getting sub: ',num2str(sub)]);
    end
    tablePathFile = [tablePath,'\',specie,'_sub',sprintf('%02d',sub),'.mat'];
    infoTable = infoTableO;
    for nRow = 1:size(infoTable,1)
        if verb
            clc
            disp(['sub: ',num2str(sub)]);
            disp([num2str(nRow),' / ',num2str(size(infoTable,1))]);
        end
        runN1 = infoTable.runN1(nRow);
        runN2 = infoTable.runN2(nRow);
        nCat1 = infoTable.stim1(nRow);
        nCat2 = infoTable.stim2(nRow);

        switch regionType %gets a data vector for each coordinate/mask
            case 'coord'
                vector1 = loadFSLMaps(experiment,specie,FSLModel,sub,runN1,nCat1,...
                    'coords',coords,'rad',r,'tablePath',tablePathFile,...
                    'fileTypeToLoad',fileTypeToLoad);
                vector2 = loadFSLMaps(experiment,specie,FSLModel,sub,runN2,nCat2,...
                    'coords',coords,'rad',r,'tablePath',tablePathFile,...
                    'fileTypeToLoad',fileTypeToLoad);
            case 'maskN'
                disp(['running mask: ', mask])
                vector1 = loadFSLMaps(experiment,specie,FSLModel,sub,...
                    runN1,nCat1,'mask',mask,'tablePath',tablePathFile,...
                    'maskPath',maskPath,'fileTypeToLoad',fileTypeToLoad);
                vector2 = loadFSLMaps(experiment,specie,FSLModel,sub,...
                    runN2,nCat2,'mask',mask,'tablePath',tablePathFile,...
                    'maskPath',maskPath,'fileTypeToLoad',fileTypeToLoad);
            case 'model'
                switch modelName
                    case 'DSMV1'
                        vector1 = getVectorForCat(runN1,nCat1);
                        vector2 = getVectorForCat(runN2,nCat2);
                end
            otherwise
                error('wrong regionType');
        end
        vector1 = reshape(vector1,1,numel(vector1)); %reshaping in case the vector is inverted
        vector2 = reshape(vector2,1,numel(vector2));
        %gets metric and assigns results to table
        if distanceCorrelation
            if isempty(nReps)
                d = pdist2(vector1,vector2,'correlation'); %calculates  correlation distance
            else %calculates permutations instead
                d = zeros(1,nReps);
                for rep = 1:nReps
                    vector1 = shake(vector1);
                    d(rep) = pdist2(vector1,vector2,'correlation');
                end
            end
            infoTable.distanceCorrelation(nRow) = d;
        end
        if Spearman
            if isempty(nReps)
                rho = corr(vector1',vector2',  'Type', 'Spearman');
            else %calculates permutations instead
                rho = zeros(1,nReps);
                for rep = 1:nReps
                    vector1 = shake(vector1);
                    rho(rep) = corr(vector1',vector2',  'Type', 'Spearman');
                end
            end
            infoTable.spearman(nRow) = rho;
        end
        if Pearson
            if isempty(nReps)
                rho = corr(vector1',vector2',  'Type', 'Pearson');
            else %calculates permutations instead
                rho = zeros(1,nReps);
                for rep = 1:nReps
                    vector1 = shake(vector1);
                    rho(rep) = corr(vector1',vector2',  'Type', 'Pearson');
                end
            end
            infoTable.pearson(nRow) = rho;
        end
        if Mah
            if isempty(nReps)
                mahD = pdist2(vector1,vector2,'mahalanobis'); %calculates  correlation distance
            else %calculates permutations instead
                mahD = zeros(1,nReps);
                for rep = 1:nReps
                    vector1 = shake(vector1);
                    mahD(rep) = pdist2(vector1,vector2,'mahalanobis');
                end
            end
            infoTable.distanceCorrelation(nRow) = mahD;
        end
        infoTable.sub(nRow) = sub;
    end
    res = [res;infoTable]; %#ok<AGROW>
end
