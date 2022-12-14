function [ZVal,fileEnd,distFileEnd] = p2Z(pVal)
switch pVal
    case 0.05
        ZVal = 1.6;
        distFileEnd = sprintf('%05d',(pVal)*10000);
    case 0.01
        ZVal = 2.3;
        distFileEnd = sprintf('%05d',(pVal)*10000);
    case 0.001
        ZVal = 3.1;
        distFileEnd = sprintf('%05d',(pVal)*10000);
    case 0.0001
        ZVal = 3.9;
        distFileEnd = sprintf('%05d',(pVal)*10000);
    case 0.00001
        ZVal = 4.5;
        distFileEnd = sprintf('%05f',(pVal)*10000);
    case 0.000001
        ZVal = 4.9;
end

fileEnd = fileThrEnding(pVal);