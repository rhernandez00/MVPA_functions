
function [found,data,indx,outImg] = checkTable(tablePath,isCoord,name,coords,rad,sub,runN,FSLModel,specie,nCat,fileTypeToLoad,task,gfeat,maskName)
    noOutImg = true;
    %maskName is used only for gfeat
    %disp(['Checking: ',tablePath]);
    if exist([tablePath])
        %disp('it exist!');
        load(tablePath);
    else
        disp('Table not found');
        indx = [];
        outImg = [];
        found = false;
        data = [];
        return
    end
    testing = false; %to check for errors
    cleanMode = true; %to erase duplicate cases
    
    if gfeat
        %disp('getting from gfeat')
        fieldList = {'name','sub','run','FSLModel','specie',...
            'nCat','fileTypeToLoad','task'};
        T = table;
        
        T.name = maskName;
        T.rad(1) = rad; %in case it is  coords, the rad
        T.sub(1) = sub; %number of subject
        T.run(1) = runN; %number of run
        T.FSLModel(1) = FSLModel;%FSLModel
        T.specie(1) = specie;
        T.nCat(1) = nCat;%category
        T.task(1) = task;%task
        T.fileTypeToLoad(1) = fileTypeToLoad; %#ok<*STRNU>
        
        
        [~,indx] = checkMatchCase(dataTable,T,'fieldList',fieldList);
        
    else
    
        indx1 = [dataTable.sub] == sub; 
        indx2 = [dataTable.run] == runN;
        indx3 = [dataTable.specie] == specie;
        indx4 = [dataTable.FSLModel] == FSLModel;
        indx5 = [dataTable.nCat] == nCat;
        indx6 = [dataTable.fileTypeToLoad] == fileTypeToLoad;
        if numel(name(:)) > 50
            name = maskName;
        end
        if isempty(name)
        %if strcmp(name,'coord')
            indx7 = indx6;
            indx7(:) = true;
        else
            indx7 = indx6;
            indx7(:) = 0;
            for nnn = 1:length(indx6)
                indx7(nnn) = isequal(dataTable(nnn).name,name);
            end
        end
        indx8 = [dataTable.isCoord] == isCoord;
        indx9 = [dataTable.rad] == rad;
        indx11 = [dataTable.task] == task;
        indx10 = zeros(size(indx9));
        for nCoord = 1:numel(indx10)
            coordsIn = dataTable(nCoord).coords;
            if isempty(coordsIn)
                if isempty(coords)
                    indx10(nCoord) = true;
                else
                    indx10(nCoord) = false;
                end
            else
                if isempty(coords)
                    indx10(nCoord) = false;
                else
                    indx10(nCoord) = sum([coordsIn(1)==coords(1),...
                        coordsIn(2)==coords(2),...
                        coordsIn(3)==coords(3)]) == 3;
                end
            end
        end
        if testing
            disp(['sub: ',num2str(sum(indx1))]);
            disp(['run: ',num2str(sum(indx2))]);
            disp(['specie: ',num2str(sum(indx3))]);
            disp(['FSLModel: ',num2str(sum(indx4))]);
            disp(['nCat: ',num2str(sum(indx5))]);
            disp(['fileTypeToLoad: ',num2str(sum(indx6))]);
            disp(['name: ',num2str(sum(indx7))]);
            disp(['isCoord: ',num2str(sum(indx8))]);
            disp(['rad: ',num2str(sum(indx9))]);
            disp(['coords: ',num2str(sum(indx10))]);
            disp(['task: ',num2str(sum(indx11))]);
        end

        indx = find(indx1.*indx2.*indx3.*indx4.*indx5.*indx6.*indx7.*indx8.*indx9.*indx10.*indx11);
    end
    if isempty(indx)
        disp('Entrance not found, creating new entrance');
        found = false;
        data = [];
        outImg = [];
    else
%         disp('Entrance found loading from table');
        if length(indx) > 1
            
            if cleanMode %erases duplicates
                disp(['more than one entry, ',num2str(length(indx)),' erasing duplicated entries']);
                dataTable(indx(2:end)) = [];
                save([tablePath,'.mat'],'dataTable');
                disp('table saved without duplicates');
            else
                error('check table, more than one entrance match');
            end
        end
        found = true;
        
        data = dataTable(indx).data;


        if isfield(dataTable,'outImg')
            if noOutImg
                outImg = [];
            else
                outImg = dataTable(indx).outImg;
            end
        else
            outImg = [];
        end
%         data
    end
    
end