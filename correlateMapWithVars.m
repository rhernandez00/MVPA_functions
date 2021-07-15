function [resGroupPeak,resWhole,resIndividualPeak,tableOrdered,variablesToTest] = correlateMapWithVars(tableIn,resultsPath,varargin)
%takes a table with variables to correlate with data from searchlight maps
ignore = getArgumentValue('ignore',{'ID','participant'},varargin{:});
participantVar = getArgumentValue('participantVar','participant',varargin{:});
modelsToTest = getArgumentValue('modelsToTest',1,varargin{:}); %MVPA models to test
participantsToTest = getArgumentValue('participantsToTest',[tableIn.(participantVar)],varargin{:});
r = getArgumentValue('r',3,varargin{:});
av = getArgumentValue('av',1,varargin{:});
task = getArgumentValue('task',1,varargin{:});
tThr = getArgumentValue('tThr',0.01,varargin{:});
hemo = getArgumentValue('hemo',0,varargin{:});
corrType = getArgumentValue('corrType','Spearman',varargin{:});
MVPA = getArgumentValue('MVPA',true,varargin{:});
categories = getArgumentValue('categories',[],varargin{:});
runSearchlight = getArgumentValue('runSearchlight',false,varargin{:});

[tableOrdered,variablesToTest] = getTableOrdered(tableIn,'ignore',ignore,...
    'participantVar',participantVar,'participantsToTest',participantsToTest);


%% Performs correlation with clusters in MVPA map
if MVPA %run correlation in MVPA results?
    tThrS = num2str(tThr); tThrS = tThrS(3:end);
    for nModel = 1:length(modelsToTest) %Getting results from cluster group peaks
        model = modelsToTest(nModel);
        fileList = cell(length(participantsToTest),1);
        for j = 1:length(participantsToTest)
            fileList{j,1} = ['av',num2str(av),'h',num2str(hemo),'task', num2str(task), 'model',sprintf('%02d',model),'r',num2str(r),'sub',sprintf('%03d',participantsToTest(j)),'.nii.gz'];
        end
        folder = [resultsPath,'\h',num2str(hemo),'\model',sprintf('%02d',model),'\r',num2str(r),'\av',num2str(av)];
        resultsFile = [resultsPath,'\h',num2str(hemo),'\r',num2str(r),'av',num2str(av),'model',sprintf('%02d',model),'_t_Thr',tThrS,'Corrected.nii.gz'];
        resultsMap = load_untouch_niiR(resultsFile);
        clusterListOut= splitInClusters(resultsMap.img);

        %correlations with the cluster group peak
        analysisType = 'groupPeak';
        resGroupPeak = correlateWithTable(corrType,tableOrdered,variablesToTest,clusterListOut,analysisType);
        %correlations with the whole cluster 
        analysisType = 'mask';
        resWhole = correlateWithTable(corrType,tableOrdered,variablesToTest,clusterListOut,analysisType);
        %correlations with the individual peak
        analysisType = 'individualPeak';
        resIndividualPeak = correlateWithTable(corrType,tableOrdered,variablesToTest,clusterListOut,analysisType);
    end
else
    resGroupPeak = [];
    resWhole = [];
    resIndividualPeak = [];
end


function res = correlateWithTable(corrType,tableOrdered,variablesToTest,clusterListOut,analysisType)
    for nCluster = 1:length(clusterListOut)
        clusterMatrix = clusterListOut{nCluster};
        [~,coords] = max3dR(clusterMatrix);
        if size(coords,1) > 1
           disp('Warning, the cluster has more than one peak, using first peak');
        end
        switch analysisType
            case 'mask'
                valuesList = getResultsOnMask(clusterMatrix,folder,'fileList',fileList,'templateFormat','matrix'); %gets the values for the average of the mask (peak)
            case 'groupPeak'
                valuesList = getResultsOnVoxel(coords,folder,fileList); %gets the values for the given coord (peak)
            case 'individualPeak'
                [~,~,valuesList]= getResultsOnMask(clusterMatrix,folder,'fileList',fileList,'templateFormat','matrix'); %gets the values for the given coord (individual peak)
            otherwise
                error('Wrong analysis type')
        end
        for nVarF = 1:length(variablesToTest)
            varName = variablesToTest{nVarF};
            if nCluster == 1
                res(nVarF).variableName = varName; %#ok<AGROW>
            end
            varValues = [tableOrdered.(varName)];
            [rho,pval] = corr(varValues(:),valuesList(:),  'Type', corrType);
            res(nVarF).(['rho_c',sprintf('%03d',nCluster)]) = rho; %#ok<AGROW>
            res(nVarF).(['p_c',sprintf('%03d',nCluster)]) = pval; %#ok<AGROW>
        end
    end
end
    



end