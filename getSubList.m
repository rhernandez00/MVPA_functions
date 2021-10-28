function [fileListOut] = getSubList(fileListFull)
    fileList = fileListFull;

    fileListOut = {};
    subList = getSubList(fileList);
    runList = getRunList(fileList);
    for nSub = 1:length(subList)
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
        subList = zeros(1,size(fileList,2));
        for nFile = 1:size(fileList,2)
            fileName = fileList{nFile};
            disp(fileName)
            placeS = findstr(fileName,'sub'); %#ok<FSTR>
            sub = str2num(fileName(placeS+3:placeS+5)); %#ok<ST2NM>
            subList(nFile) = sub;
        end
        subList = unique(subList);
    end

    function runList = getRunList(fileList)
        runList = zeros(1,size(fileList,2));
        for nFile = 1:size(fileList,2)
            fileName = fileList{nFile};
            placeS = findstr(fileName,'run');
            run = str2num(fileName(placeS+3:placeS+4));
            runList(nFile) = run;
        end
        runList = unique(runList);
    end


    function [fileChoosen,indxList] = getFile(fileList,sub,runN)

        [fileList,indxList] = subIn(fileList,sub);
%         for n = 1:numel(fileList)
%             disp(fileList{n})
%         end
        fileList = checkRun(fileList,runN);
        
        if isempty(fileList)
            fileChoosen = [];
        else
            indx = randsample(1:size(fileList,2),1);
            fileChoosen = fileList{indx};
        end
    end

    function [fileListOut,indxList] = subIn(fileList,sub)
        indxList = [];
        for nFile = 1:size(fileList,2)
            fileName = fileList{nFile};
            if contains(fileName,['sub',sprintf('%03d',sub)])
                indxList = [indxList;nFile];
            end
        end
        fileListOut = fileList(indxList);

    end

    function fileListOut = checkRun(fileList,runN)
        indxList = [];
        for nFile = 1:size(fileList,2)
            fileName = fileList{nFile};
            if contains(fileName,['run',sprintf('%02d',runN)])
                indxList = [indxList;nFile]; %#ok<*AGROW>
            end
        end
        fileListOut = fileList(indxList);
    end
end