function [infoTable,classesPossible] = addClassesToInfoTable(classes,infoTable)
% Checks every row in infoTable to see if it matches with the conditions
% listed for each row in groups. The function gives back infoTable with
% added columns to designate each group added
classesPossible = unique(classes.className);

conditions = classes.Properties.VariableNames; %gets the conditions from the groups table
conditions(ismember(conditions,'className')) = []; %removes className

for nClass = 1:numel(classesPossible)

    currentClass = classesPossible{nClass};

    %Checks if the column already exist, if it does, it throws an error
    isColumn = ismember(currentClass, infoTable.Properties.VariableNames);
    if isColumn
        currentClass %#ok<NOPRT>
%         error('Column names in groups should not match the group names')
        infoTable.(currentClass) = []; %This removes the group
    end

    infoTable.(currentClass)(1) = 0; %adds a new column to infoTable
    classesF = classes(strcmp(classes.className,currentClass),:); %filters classes to keep all the rows of the same class
    for nClass2 = 1:size(classesF,1) %loops through all the rows of groupsF
        for nRow = 1:size(infoTable,1)
            conds = zeros(1,size(classesF,2));
            for nCond = 1:numel(conditions) %loops through all conditions of groupsF
                condName = conditions{nCond};
                conds(nCond) = infoTable.(condName)(nRow) == classesF.(condName)(nClass2);%
            end
            if sum(conds) == numel(conditions) %checks if the row meet all conditions
                infoTable.(currentClass)(nRow) = 1;
            else
                infoTable.(currentClass)(nRow) = 0;
            end
        end
    end
end