function [x,y,z,indxOut] = maxNifti(niftiMap,varargin)
allMaximums = getArgumentValue('allMaximums',false,varargin{:});


%finds the coordinates for the maximum
indx = find(niftiMap(:)==max(niftiMap(:)));
if allMaximums
    x = zeros(numel(indx),1);
    y = zeros(numel(indx),1);
    z = zeros(numel(indx),1);
    for n = 1:numel(indx)
        [x(n),y(n),z(n)] = flatToXYZ(indx(n),niftiMap, 'templateFormat','matrix');
    end
    indxOut = indx;
else
    [x,y,z] = flatToXYZ(indx(1),niftiMap, 'templateFormat','matrix');
    indxOut = indx(1);
end


