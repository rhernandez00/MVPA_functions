function [tableOrdered,variablesToTest] = processTable(tableName,participantsToTest,varargin)
participantVar = getArgumentValue('participantVar','Participant',varargin{:});

disp(tableName)
T = readtable([tableName,'.xlsx']);

colNames = T.Properties.VariableNames;
for nRow = 1:size(T,1)
    for nCol = 1:length(colNames)
        fieldName = colNames{nCol};
        tableIn(nRow).(fieldName) = T.(fieldName)(nRow);
    end
end
participantsInTable = [tableIn.(participantVar)];

tableIn = rmfield(tableIn,participantVar);

variablesToTest = fieldnames(tableIn);
disp(variablesToTest);
% Reorders the table and filters out not used participants


for nParticipant = 1:length(participantsToTest)
    participantNumber = participantsToTest(nParticipant);
    tableOrdered(nParticipant).Participant = participantNumber; %#ok<AGROW>
    for nVar = 1:length(variablesToTest)
        varName = variablesToTest{nVar};
        indx = find(participantsInTable==participantNumber);
        tableOrdered(nParticipant).(varName) = tableIn(indx).(varName); %#ok<FNDSB>
    end
end