function [fileListOut,subList,runList] = getSubList(fileListFull)
%Checks fileListFull and gets the number of subjects available, as well as the number of runs
%randomly selects one run number for each subject and outputs a list 
%
    fileList = fileListFull;

    fileListOut = {};
    subList = getSubList(fileList);
    runList = getRunList(fileList);
    for nSub = 1:numel(subList)
        sub = subList(nSub);
        for nRun = 1:length(runList)
            runN = runList(nRun);
            [fileChoosen] = getFile(fileList,sub,runN);
            if isempty(fileChoosen)
                disp(['File not found: sub ',num2str(sub),' run ', num2str(runN)]);
            else
                fileListOut{length(fileListOut)+1} = fileChoosen; 
            end
        end
    end
%     fileListOut
%     error('r')
%     fileListOut = fileListOut(:);

    function subList = getSubList(fileList)
        subList = zeros(1,numel(fileList));
        for nFile = 1:numel(fileList)
            fileName = fileList{nFile};
            %disp(fileName)
            placeS = findstr(fileName,'sub'); %#ok<FSTR>
            sub = str2num(fileName(placeS+3:placeS+5)); %#ok<ST2NM>
            subList(nFile) = sub;
        end
        subList = unique(subList);
    end

    function runList = getRunList(fileList)
        runList = zeros(1,numel(fileList));
        for nFile = 1:numel(fileList)
            fileName = fileList{nFile};
            placeS = findstr(fileName,'run'); %#ok<FSTR>
            if isempty(placeS) %when there are no runs
                run = 0;
            else
                run = str2num(fileName(placeS+3:placeS+4)); %#ok<ST2NM>
            end 
            runList(nFile) = run;
        end
        runList = unique(runList);
    end


    function [fileChoosen,indxList] = getFile(fileList,sub,runN)

        [fileList,indxList] = subIn(fileList,sub);
        fileList = checkRun(fileList,runN);
        
        if isempty(fileList)
            fileChoosen = [];
        else
            indx = randsample(1:numel(fileList),1);
            fileChoosen = fileList{indx};
        end
    end

    function [fileListOut,indxList] = subIn(fileList,sub)
        indxList = [];
        for nFile = 1:numel(fileList)
            fileName = fileList{nFile};
            if contains(fileName,['sub',sprintf('%03d',sub)])
                indxList = [indxList;nFile];
            end
        end
        fileListOut = fileList(indxList);

    end

    function fileListOut = checkRun(fileList,runN)
        %checks which files in fileList are runN type of run
        if runN == 0
            fileListOut = fileList;
        else
            indxList = [];
            for nFile = 1:numel(fileList)
                fileName = fileList{nFile};
                if contains(fileName,['run',sprintf('%02d',runN)])
                    indxList = [indxList;nFile]; %#ok<*AGROW>
                end
            end
            fileListOut = fileList(indxList);
        end
    end
end