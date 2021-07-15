function thrS = fileThrEnding(thr)

switch thr
    case 0.05
        thrS = '05';
    case 0.01
        thrS = '01';
    case 0.001
        thrS = '001';
    case 0.0001
        thrS = '0001';
    case 0.00001
        thrS = '00001';
    case 0.000001
        thrS = '000001';
    otherwise
        
        error(['add new Thr, introduced: ', num2str(thr)]);
end