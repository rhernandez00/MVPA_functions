function [legendNames] = getLegends(experiment,FSLModel)
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
            case 10 %replacing 8, that this is not actually the contrasts
                legendNames = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
            case 50
                legendNames = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
            case 54
                legendNames = {'CatF','CatB','DogF','DogB','HumF','HumB','Car'};
            case 39
                legendNames = {'Cat','Dog','Hum','Car'};
            case 40
                legendNames = {'Cat','Dog','Hum','Car'};
            otherwise
                FSLModel %#ok<NOPRT>
                error('Wrong FSLModel')
        end
    
    otherwise
        error('Wrong experiment');
end


