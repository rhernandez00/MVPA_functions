function v = eventsToVector(timeLine,eventStructure)
%the function takes a timeLine and an eventsStructure and gives back a
%vector of 0 (stimuli absent) and 1 (stimuli present) of the same size as
%timeLine
v = zeros(1,numel(timeLine));
        
for nEvent = 1:size(eventStructure,2)
    onset = eventStructure(nEvent).onset;
    duration = eventStructure(nEvent).duration;
    indx = timeLine >= onset & timeLine < onset + duration;
    v(indx) = 1;
end