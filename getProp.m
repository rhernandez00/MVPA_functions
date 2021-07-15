function prop = getProp(runN,nCat,varargin)
% gets n (nCat) a prop from propTable of a run (runN). The prop is defined by 'propName', by
% default, the prop is 'motion'.


getDriveFolder;
experiment = getArgumentValue('experiment','Complex',varargin{:}); %experiment for propTable
FSLModel = getArgumentValue('FSLModel',3,varargin{:}); %FSLModel for propTable
propName = getArgumentValue('propName','motion',varargin{:}); %propName

addpath([dropboxFolder,'\MVPA\',experiment]);
addpath([dropboxFolder,'\MVPA\',experiment,'\functions']);

propTable = getPropTable(runN,'FSLModel',FSLModel);

prop = propTable(nCat).(propName);


