function [coordsPossible,flatCoord,coordNames] = getCoordsOfInterest(coordSet,varargin)
% gets a set of coordinates, these are coordinates of interest according to
% the experiment
experiment = getArgumentValue('experiment','Complex',varargin{:});
specie = getArgumentValue('specie',[],varargin{:});
coordNames = {};
switch experiment
    case 'Complex'
        switch specie
            case 'H'
                cxFile = 'MNI2mm';
                switch coordSet
                    case 'LOC'
                        coordsPossible = {[24,27,36],[69,26,36]};
                    case 'R_LOC' %Hierarchy peak
                        coordsPossible = {[24,27,36]};
                    case 'L_LOC'
                        coordsPossible = {[69,26,36]};
                    case 'V1'
                        coordsPossible = {[49,22,40],[39,22,40]};
                    case 'R_V1'
                        coordsPossible = {[49,22,40]};
                    case 'L_V1'
                        coordsPossible = {[39,22,40]};
                    case 'L_MOG'
                        coordsPossible = {[68,22,36]};
                    case 'R_MTG'
                        coordsPossible = {[23,34,39]};
                    case 'L_MTG'
                        coordsPossible = {[71,29,39]};
                    case 'MOG'
                        coordsPossible = {[26,24,40],[68,22,36]};
                    case 'MTG'
                        coordsPossible = {[23,34,39],[71,29,39]};
                    otherwise
                        disp(coordset);
                        error('Set not found');
                end
            case 'D'
                cxFile = 'Barney2mm';
                switch coordSet
                    case 'LOC'
                        coordsPossible = {[24,19,23]};
                    case 'V1'
                        coordsPossible = {[14,13,20],[22,14,20]};
                    case 'LMG' %MVPA, STDblock peak 1
                        coordsPossible = {[13,11,25]};
                    case 'LcSSG' %MVPA, STDblock peak 2
                        coordsPossible = {[5,17,17]};
                    case 'RmESG' %MVPA, STDblock peak 3
                        coordsPossible = {[28,19,23]};
                    case 'LcSSGV1' %V1 peak
                        coordsPossible = {[6,19,15]};
                    case 'LOGV1'%V1 peak
                        coordsPossible = {[13,10,21]};
                    case 'LSpGV1'%V1 peak
                        coordsPossible = {[13,18,24]};
                    case 'RcSGV1'%V1 peak
                        coordsPossible = {[25,25,12]};
                    case 'LmSSG'%RSA Mean_VTCModel peak
                        coordsPossible = {[8,20,23]};
                        
                    case 'LSG' %deprecated, I don't know where it comes from
                        coordsPossible = {[15,12,21]};
                    case 'RcSG' %deprecated, I don't know where it comes from
                        coordsPossible = {[28,26,13]};
                    case 'RmSSG' %deprecated, I don't know where it comes from
                        coordsPossible = {[26,16,25]};
                    
                    case 'LOG' %deprecated, I don't know where it comes from
                        coordsPossible = {[14,13,20]};
                    otherwise
                        disp(coordset);
                        error('Set not found');
                end
        end
    case 'Prosody'
        cxFile = 'Barney2mm';
        coordNames = {'R_mSSG','L_mSSG','L_cSSG','R_rSG','L_PCG',...
            'L_cESG','L_rSSG','R_mESG','L_mESG'};
        switch coordSet
            case ''
                coordsPossible = {[1,1,1]};
            case 'R_mSSG' %Model 2 %19,-19,24
                coordsPossible = {[26,21,25]};
            case 'L_mSSG' %Model 2 % -17,-27,20
                coordsPossible = {[8,17,23]};
            case 'L_cSSG' %Model 2 % -17,-29,8
                coordsPossible = {[8,16,17]};
            case 'R_rSG' %Model 5 %15,-25,4
                coordsPossible = {[24,28,15]};
            case 'L_PCG'%Model 5 %-1,9,24
                coordsPossible = {[16,35,25]};
            case 'L_cESG'%Model 5 %-21,-23,12
                coordsPossible = {[6,19,19]};
            case 'L_rSSG'%Model 5 %-15,-11,20
                coordsPossible = {[9,25,23]};
            case 'R_mESG' %25,-17,18
                coordsPossible = {[29,22,22]};
            case 'L_mESG' %-21,-15,20
                coordsPossible = {[6,23,23]};
            otherwise
                error('Wrong region');
        end
    otherwise
        error('Wrong experiment');
   
end

ctx = getCortex(cxFile);
ctx(1:end) = 1:length(ctx(:));
flatCoord = zeros(1,length(coordsPossible));
for nCoord = 1:length(coordsPossible)
    coord = coordsPossible{nCoord};
    flatCoord(nCoord) = ctx(coord(1),coord(2),coord(3));
end


