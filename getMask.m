function [maskOut,niiFile] = getMask(nMask,varargin)
%loads the mask numbered nMask from the atlas specified or simply the
%default ones (MNI2mm and )
atlas = getArgumentValue('atlas',[],varargin{:});
specie = getArgumentValue('specie',[],varargin{:});

if isempty(atlas)
%     disp('is empty atlas');
    if isempty(specie)
        error('If no atlas is selected, at least you should provide specie');
    else 
        switch specie
            case 'H'
                atlas = 'AAL';
            case 'D'
                atlas = 'Barney2mm';
        end
    end     
end
[atlasNii] = getAtlas(atlas,'loadNii',true);
maskOut = atlasNii.img;
maskOut(:) = 0;
for n = 1:length(nMask)
    maskToRead = nMask(n);
    indx = atlasNii.img(:) == maskToRead;
    maskOut(indx) = 1;
end
niiFile = atlasNii;
niiFile.img = maskOut;
%TEST FINAL RESULT