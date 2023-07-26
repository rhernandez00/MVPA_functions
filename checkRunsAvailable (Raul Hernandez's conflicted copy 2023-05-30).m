function runsAvailable = checkRunsAvailable(sub,experiment)
%returns the runs available for a participant (sub) and a determined
%experiment
switch experiment
    case 'Actions'
        switch sub
            case 1
                runsAvailable = 1:10;
            case 7
                runsAvailable = [1:7,9,10];
            case 2
                runsAvailable = 1:19;
            case {3,6,8,9,10}
                runsAvailable = 1:11;
            case {4,5}
                runsAvailable = 1:13;
            case {11,12}
                runsAvailable = 1:15;
            otherwise
                error(['wrong sub: ',num2str(sub)]);
        end
        
    otherwise
        disp(['experiment: ',experiment]);
        error('Wrong experiment');
end