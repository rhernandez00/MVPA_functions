function [x,y,z] = flatToXYZ(flat,template, varargin)
templateFormat = getArgumentValue('templateFormat','nifti',varargin{:}); %takes nifti or matrix
%takes an index from a vectorized image and gives back the coordinates
%template is the file from which the index came from
if ischar(template)
    switch template
        case 'MNI2mm'
            newImg = getCortex(template);
            newImg = single(newImg);
        case 'Barney2mm'
            newImg = getCortex(template);
            newImg = single(newImg);
        otherwise
            disp(template);
            error('Wrong template name');
    end
else
    switch templateFormat
        case 'nifti'
            imgData = load_untouch_niiR(template);
            newImg = single(imgData.img);

        case 'matrix'
            newImg = single(template);
    end
end
% disp(templateFormat)

for j = 1:length(newImg(:))
    newImg(j) = j;
end

[x,y,z] = ind2sub(size(newImg),find(newImg==flat));

