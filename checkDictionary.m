function e = checkDictionary(stringName,dictionary,varargin)
%This function checks in the dictionary specified stringName and returns a structure
%that contains the elements matching with stringName
dictionaryPath = getArgumentValue('dictionaryPath',[],varargin{:});
if isempty(dictionaryPath)
    getDriveFolder;
    dictionaryPath = [driveFolder,'\Faces_Hu\CommonFiles'];
end
dTable = readtable([dictionaryPath,'\',dictionary]);
possibleColumns = dTable.Properties.VariableNames;

indx = 0;
e = [];
for nCol = 1:numel(possibleColumns) %checks every column in the table
    colName = possibleColumns{nCol};
    for nRow = 1:size(dTable,1) %checks every row in the column
        switch class(dTable.(colName))%verifies the type of column it is
            case 'double'
                hit = isequal(num2str(dTable.(colName)(nRow)),stringName);
            case 'cell'
                hit = isequal(dTable.(colName){nRow},stringName);
            otherwise
                error(['Class type ', class(dTable.(colName)), ' not coded']);
        end
        if hit
            indx = nRow;
            %disp(['match found: ', num2str(indx)]);
            break
        end
    end
    if indx ~= 0
        for nCol2 = 1:numel(possibleColumns)
            colName = possibleColumns{nCol2};
            switch class(dTable.(colName))
                case 'double'
                    e.(colName) = dTable.(colName)(nRow);
                case 'cell'
                    e.(colName) = dTable.(colName){nRow};
                otherwise
                    error(['Class type ', class(dTable.(colName)), ' not coded']);
            end
        end
        break
    end
    
end
if isempty(e)
    disp([stringName, ' not found in dictionary: ', dictionary]);
end
