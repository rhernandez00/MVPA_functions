function [vals,maskIndx,maskVals,outImg] = loadValsFromThrRegion(sub,specie,experiment,...
    inputContrast,inputFSLModel,testCat,testFSLModel,nVoxels,runsToTest,varargin)
%Takes a contrast result (inputContrast, calculated using half the runs) and a mask (mask), selects a
%number of voxels (nVoxels) with the highest value for the contrast. Using
%that selection, outputs values for the same voxels using the other runs (runsToTest)
%experiment - name of experiment
%specie - specie to load
%nMask - number of mask to read
%inputContrast - contrast from which to select the highest (or lowest) nVoxels
%nVoxels = getArgumentValue('nVoxels',[],varargin{:});
getDriveFolder;
atlas = getArgumentValue('atlas',[],varargin{:});
side = getArgumentValue('side','highest',varargin{:});
mask = getArgumentValue('mask',[],varargin{:});
basePath = getArgumentValue('basePath','D:\Raul\data',varargin{:});
fileTypeToLoad = getArgumentValue('fileTypeToLoad','z',varargin{:});%accepted are: 't', 'z', 'c'
task = getArgumentValue('task',1,varargin{:});
maskPath = getArgumentValue('maskPath',[driveFolder,'\Results\',experiment,'\ROIs'],varargin{:});
tablePath = getArgumentValue('tablePath',[driveFolder,'\Results\',experiment,'\dataTable\dataTable.mat'],varargin{:});
loadFromBOLDTest = getArgumentValue('loadFromBOLDTest',true,varargin{:});
inputZ = getArgumentValue('inputZ',[],varargin{:});


%'cope': values from the cope
%'other': values from maps in basePath


[maskIndx,maskVals,outImg] = getContrastNVoxels(sub,specie,experiment,inputContrast,...
    inputFSLModel,nVoxels,'side',side,'mask',mask,...
    'tablePath',tablePath,'inputZ',inputZ,'atlas',atlas,'basePath',basePath,...
    'fileTypeToLoad',fileTypeToLoad,'task',task,'maskPath',maskPath);
% disp(vals)
% error('r')

vals = zeros(1,numel(runsToTest));
 for nRun = 1:length(runsToTest)
    runN = runsToTest(nRun);
    [~,valsImg]  = loadFSLMaps(experiment,specie,testFSLModel,sub,runN,testCat,...
        'mask',outImg,'basePath',basePath,'fileTypeToLoad','p',...
        'task',task,'maskPath',maskPath,'tablePath',tablePath,...
        'loadFromBOLD',loadFromBOLDTest,'maskName',mask);
    valsTest = valsImg(maskIndx); %filters to keep only the requested voxels

    valOut = mean(valsTest);
    vals(1,nRun) = valOut;
end




