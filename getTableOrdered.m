function [tableOrdered,variablesToTest] = getTableOrdered(tableIn,varargin)
ignore = getArgumentValue('ignore',{'ID','participant'},varargin{:});
participantVar = getArgumentValue('participantVar','participant',varargin{:});
participantsToTest = getArgumentValue('participantsToTest',[tableIn.(participantVar)],varargin{:});

% Filters the variables to test
variablesToTest = fieldnames(tableIn); %gets the variables in the struct
for n = 1:length(ignore) %removes the variables that will not be tested
    varName = ignore{n};
    ignoreIndx = find(strcmp(variablesToTest,varName));
    variablesToTest = popArray(variablesToTest,ignoreIndx);
end
% Reorders the table and filters out not used participants

participantsInTable = [tableIn.(participantVar)];
for nParticipant = 1:length(participantsToTest)
    participantNumber = participantsToTest(nParticipant);
    tableOrdered(nParticipant).participant = participantNumber; %#ok<AGROW>
    for nVar = 1:length(variablesToTest)
        varName = variablesToTest{nVar};
        indx = find(participantsInTable==participantNumber);
        tableOrdered(nParticipant).(varName) = tableIn(indx).(varName); %#ok<FNDSB>
    end
end