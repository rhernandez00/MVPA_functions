function complete = createVectorsForFSL(nParticipant,runsToDo,condsTotal,nModel)

groupingVar = 'cond';

complete = [];
for nRun = 1:numel(runsToDo)
    runN = runsToDo(nRun);
    
    for nCond = 1:condsTotal
        completeTmp(nCond).onset = nCond-1; 
        completeTmp(nCond).duration = 1; %#ok<*AGROW>
        completeTmp(nCond).run = runN;
        completeTmp(nCond).cond = nCond;
    end
    complete = [complete,completeTmp];
    clear completeTmp
end

participantFolder = ['sub',sprintf('%03d',nParticipant)];
createVectors(complete,groupingVar,'participant',...
    participantFolder,'model',nModel);
