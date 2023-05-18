function [catGroup,nStim,options] = getStimType(experiment,FSLModel,runN,nCat)
%inputs: nCat - number of stimulus
%gives back: 
% - catGroup, group to which the stim belongs
% - nStim, number of stim within the group (so it ranges from 1 to N
% elements in a group (not affected by run)
%according to the inputs, gives back a structure called options, this
%structure contains:
% totalStims, the total number of stims (for FSLModel=3, is 48)
% catlen, total number of categories
% catTypes, a list with the names of the categories
% stimsPerCat, a list with the number of elements per category
% runs, a list with the runs available (some FSLModels will have all, some will only have 1)
switch experiment
    case 'Complex'
        switch FSLModel
            case 3
                options.totalStims = 48;
                options.catlen = 4;
                options.catTypes = {'cars','cats','dogs','humans'};
                options.stimsPerCat = [12,12,12,12];
                options.runs = 1:6;
            case 8

                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
%                 options.catTypes = {'CatB','DogB','HumB','CatF','DogF','HumF','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = 1:6; 
                warning('previous version had catTypes weird')
                %options.catTypes = {'Car','CatB','DogB','HumB','CatF','DogF','HumF'};
            case 10 %replacing 8, that this is not actually the contrasts
                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = 1:6;
            case 21
                options.totalStims = 57;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,7,8,8,8,7,7];
                options.runs = 1;
            case 22
                options.totalStims = 55;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,8,7,8,6,7,7];
                options.runs = 2;
            case 23
                options.totalStims = 59;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,8,9,7,8,7,8];
                options.runs = 3;
            case 24
                options.totalStims = 72;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,10,10,11,11,9,9];
                options.runs = 4;
            case 25
                options.totalStims = 68;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,11,10,10,10,8,7];
                options.runs = 5;
            case 26
                options.totalStims = 70;
                options.catlen = 7;
                options.catTypes = {'cars','catFace','catBody','dogFace','dogBody','humanFace','humanBody'};
                options.stimsPerCat = [12,12,11,10,8,9,8];
                options.runs = 6;
             case 40
                options.totalStims = 4;
                options.catlen = 4;
                options.catTypes = {'Cat','Dog','Hum','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = 1:6; 
            case 50
                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = [2,4,6];
            case 52
                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = [1,3,5];
            case 53
                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = [2,4,6];
            case 54
                options.totalStims = 7;
                options.catlen = 7;
                options.catTypes = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = [];%uses odd to find clusters and even for testing
            otherwise
                FSLModel
                error('Wrong FSLModel')
        end
    case 'Prosody'
        switch FSLModel
            case 51
                options.totalStims = 4;
                options.catlen = 4;
                options.catTypes = {'NativeNormal','NativeQuilt','ForeignNormal','ForeignQuilt'};
                options.stimsPerCat = [1,1,1,1];
                options.runs = 1:4;
            case 52
                options.totalStims = 2;
                options.catlen = 2;
                options.catTypes = {'Normal','Quilt'};
                options.stimsPerCat = [1,1];
                options.runs = 1:4;
            otherwise
                error('Wrong FSLModel')
        end
     case 'Objects'
        switch FSLModel
            case 4
                options.totalStims = 27;
                options.catlen = 3;
                options.catTypes = {'cars','cats','dogs','humans'}; %THIS IS WRONG, CHANGE
                options.stimsPerCat = [12,12,12,12]; %THIS IS WRONG, CHANGE
                options.runs = 1:12;
        end
    case 'Emotions'
        switch FSLModel
          case 1
                options.totalStims = 4; %total number of stimuli (sum of stimsPerCat)
                options.catlen = 4; %number of categories
                options.catTypes = {'sad','happy','angry','scared'};
                options.stimsPerCat = [1,1,1,1];
                options.runs = 1:8;
        end
    case 'Sonrisas'
        switch FSLModel
          case 1
                options.totalStims = 2; %total number of stimuli (sum of stimsPerCat)
                options.catlen = 2; %number of categories
                options.catTypes = {'neutral','happy'};
                options.stimsPerCat = [1,1];
                options.runs = 1:8;
        end
    case 'Voice_sens1'
        switch FSLModel
          case 6
                options.totalStims = 7;%total number of stimuli (sum of stimsPerCat)
                options.catlen = 7;%number of categories
                options.catTypes = {'Chimpanzee', 'Dogs', 'Engines', 'Foxes', 'Music', 'Non-speech', 'Speech'};
                options.stimsPerCat = [1,1,1,1,1,1,1];
                options.runs = 1:5;
        end
    otherwise
        error('Wrong experiment');
end

if ~ismember(runN,options.runs)
    if runN ~= 0
        disp(runN)
        error('Wrong run');
    end
end

%This gets the group to which the stim belongs
vector = cumsum(options.stimsPerCat) + 1;
catGroup = find(nCat < vector); catGroup = catGroup(1);
if catGroup > 1
    nStim = nCat - vector(catGroup-1) + 1;
else
    nStim = nCat;
end

