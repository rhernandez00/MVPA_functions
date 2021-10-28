function vals = getValsFrome(e,copeN,clusN,nCat)
    runN = 0;
    catType = e.catTypes{nCat};
    subsPossible = e.subsPossible;
    vals = zeros(1,length(subsPossible));
    copeS = ['cope',sprintf('%03d',copeN)];
    clusS = ['clus',sprintf('%03d',clusN)];
    runS = ['run',sprintf('%03d',runN)];
    for nSub = 1:length(subsPossible)
        sub = subsPossible(nSub);
        subS = ['sub',sprintf('%03d',sub)];
        try
            vals(nSub) = e.(subS).(copeS).(clusS).(runS).(catType);
        catch
            disp(subS)
            disp(copeS)
            disp(clusS)
            disp(runS)
            disp(catType)
            error('Error somewhere')
        end
    end
end