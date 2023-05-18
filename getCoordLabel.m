function [labelName,nLabel] = getCoordLabel(coords,varargin)
ref = getArgumentValue('ref','Barney2mm',varargin{:});
coordType = getArgumentValue('coordType','voxel',varargin{:});
atlasNii = getArgumentValue('atlasNii',[],varargin{:});
verbosity = getArgumentValue('verbosity','full',varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});

getDriveFolder;

if strcmp(verbosity,'full')
    disp(['The atlas used will be ', ref]);
    disp(['The values introduced are ', coordType]);
end

%gives back the table file
[~,tableFile] = getAtlas(ref,'loadNii',false);

switch ref
    case 'Barney'
        atlasFile = 'Barney';
    case 'Barney2mm'
        atlasFile = 'Barney2mm';
    case 'MNI2mm'
        atlasFile = 'MNI2mm';
    case 'AAL'
        atlasFile = 'AAL';
    case 'Datta'
        atlasFile = 'Datta';
    otherwise
        error('Wrong reference');
end

xyz = coords;
if strcmp(ref,'Datta')
    xyz = coords;
%     warning('Have to write proper conversion, using simple transformation instead');
else
%     coords2 = coords;
    switch coordType
        case 'voxel'
%             coords2 = voxelToCoordinates(coords,'ref',fileBase,'verbosity', 'none');
            xyz = coords;
        case 'coord'
            
            xyz = coordinatesToVoxel(coords,'ref',atlasFile,'verbosity', 'none');
    end

    
end


x = xyz(1); y = xyz(2); z = xyz(3);


if isempty(atlasNii)
    atlasNii = getAtlas(ref);
end
nLabel = atlasNii.img(x,y,z);
try
    nLabel = atlasNii.img(x,y,z);
catch
    x
    y
    z
    
    atlasNii
    disp(coordType)
    disp(coords)
%     disp(coords2)
    disp(atlasFile)
    disp(xyz)
    labelName='error';
    nLabel = 999;
    error('r');
end
labelTable = loadLabelTable(tableFile);



if nLabel <= 1
    if searchSphere
        rad = 1;
        while nLabel <= 1
            if strcmp(verbosity,'full')
                disp('Running sphere');
            end
            rad  = rad + 1;
            sphere = createSphere(atlasNii.img,rad,xyz);
            [xi,yi,zi] = find3D(sphere);
            labelsObtained = zeros(1,length(xi));
            for nVox = 1:length(xi)
                labelsObtained(nVox) = atlasNii.img(xi(nVox),yi(nVox),zi(nVox));
            end
            nonEmptyLabels = labelsObtained(labelsObtained > 1);
            if ~isempty(nonEmptyLabels)
                nLabel = mode(nonEmptyLabels);
                lbName = labelTable{nLabel,2};
                if sphereName
                    labelName = [lbName{1},'_r',num2str(rad)];
                else
                    labelName = [lbName{1}];
                end
            end
        end
    else
        labelName = 'No label';
        nLabel = 0;
    end
else
    labelName = labelTable{nLabel,2};
end


