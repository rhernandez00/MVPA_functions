function [e,ROIInfo] = readROIList2(experiment,Z,FSLModel,specie,subsPossible,varargin)
%creates e, a structure that contains the measured response in all the
%copes and their clusters.
%FSLModel - model from which to get the copes
%Z - Z threshold used
%subsPossible - list of participants to load. Note: the correct assignment
%of the sub fieldname depends on the cope txt files mantaining the same
%number of participants
FSLModelBase = getArgumentValue('FSLModelBase',getFSLBase(experiment,FSLModel),varargin{:});
sphereRad = getArgumentValue('sphereRad',3,varargin{:});
fileType = getArgumentValue('fileType','mean',varargin{:});
resultsLevel = getArgumentValue('resultsLevel','group',varargin{:});
getDriveFolder;
%Reading from individual mean, group-level clusters
[~,~,options] = getStimType(experiment,FSLModelBase,[],1);

catTypes = options.catTypes;


ROIFolder = [driveFolder,'\Results\',experiment,'\GLM\Z',num2str(Z*10),'\',...
    sprintf('%03d',FSLModel),'\',specie,'\ROI\r',sprintf('%02d',sphereRad),...
    ];

fileType = ['_',fileType]; %_max or _mean, this is the output from featquery
fileName = [ROIFolder,'\copeList.mat'];
eX = load(fileName);
ROIInfo = eX.copeInfo;
ROIList = eX.copeList;
[copesPossible,clustersPossible] = separateROIPossible(ROIList);

for nCope = 1:length(copesPossible) %getting every cope
    copeN = copesPossible(nCope); %cope number
    copeS = ['cope',sprintf('%03d',copeN)]; %name of cope field
    for nClus = 1:clustersPossible(nCope) %getting every cluster
        clusS = ['clus',sprintf('%03d',nClus)]; %name of cluster field 
        ROIname = ['cope',sprintf('%02d',copeN),'_',sprintf('%02d',nClus)];
        
        
        for nCat = 1:length(catTypes) %getting every cat
            catS = catTypes{nCat};
            switch resultsLevel
                case 'group'
                    runS = 'run000'; %for individual mean, run becomes irrelevant but the field should be kept
                    fileName = [ROIFolder,'\',ROIname,'_cat',sprintf('%03d',nCat),fileType,'.txt'];
                    fileID = fopen(fileName,'r'); %Reading the txt file
                    try
                        vals = fscanf(fileID,'%f');
                    catch
                        disp([fileName]);
                        error('error, file probably not found')
                    end
                    fclose(fileID);
                    %disp(fileName) %for testing
                    for subN = 1:length(subsPossible) %getting every participant
                        sub = subsPossible(subN);
                        subS = ['sub',sprintf('%03d',sub)]; %name of sub field
                        e.(subS).(copeS).(clusS).(runS).(catS) = vals(sub)./100; %assigning to structure. 
                            %Dividing to convert to %of signal BOLD
                    end
                case 'individual'
                    runsPossible=options.runs;
                    for subN = 1:length(subsPossible)
                        sub = subsPossible(subN);
                        subS = ['sub',sprintf('%03d',sub)]; %name of sub field
                        fileName = [ROIFolder,'sub',sprintf('%03d',sub),'\sub',...
                            sprintf('%03d',sub),ROIname,'_cat',...
                            sprintf('%03d',nCat),fileType,'.txt'];
                        fileID = fopen(fileName,'r'); %Reading the txt file
                        try
                            vals = fscanf(fileID,'%f');
                        catch
                            disp([fileName]);
                            error('error, file probably not found')
                        end
                        fclose(fileID);
                        for nRun = 1:length(runsPossible)
                            runN = runsPossible(nRun);
                            runS = ['run',sprintf('%03d',runN)]; 
                            e.(subS).(copeS).(clusS).(runS).(catS) = vals(nRun)./100; %assigning to structure. 
                            %Dividing to convert to %of signal BOLD
                        end
                    end
                    
            end
        end
    end
end
    
e.catTypes = catTypes;
e.copesPossible = copesPossible;
e.clustersPossible = clustersPossible;
e.ROIList = ROIList;
e.subsPossible = subsPossible;
%C:\Users\Hallgato\Google Drive\Results\Complex\GLM\Z31\050\D\ROI\r03sub001