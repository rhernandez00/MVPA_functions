function [clusterSizeList,data,clusP] = clusterCorrection(fileToCorrect,distributionFile,clusterP,varargin)
binarize = getArgumentValue('Binarize',false,varargin{:});
if nargin < 3    
    clusterSizeSelected = distributionFile;
    clusterCorrectionSim(fileToCorrect,clusterSizeSelected);
else

    load(distributionFile);

    clustersSizes = clustersSizes(clustersSizes>1);
    size(clustersSizes)
    % clustersSizes
    %finding the cluster size and showing it
    sizeTarget = 0;
    while true
        sizeTarget = sizeTarget + 1;
        p = pFromDist(clustersSizes,sizeTarget,'moreThan');
        if p < clusterP
            break
        end
        if p == 1/length(clustersSizes)
            break
        end
    end
    disp(['Cluster size: ', num2str(sizeTarget), ' for p of cluster ', num2str(clusterP)]);

    try
        data = load_untouch_niiR([fileToCorrect,'.nii.gz']);
    catch
        disp('No results, saving empty file...');
        data.img(:) = 0;
        delete([fileToCorrect,'Corrected.nii.gz'])
        return
    end

    data3 = data;
    data3.img = single(data3.img ~= 0);
    clustConn=6;
    CC = bwconncomp(data3.img,clustConn);

    clusP = cell(1,CC.NumObjects);
    for j = 1:CC.NumObjects
        clusSize = size(CC.PixelIdxList{j},1);
        clusterSizeList(j) = clusSize;
        p = pFromDist(clustersSizes,clusSize,'moreThan');

        clusP{j} = CC.PixelIdxList{j};%p < clusterP;
        data3.img(CC.PixelIdxList{j}) = p < clusterP;
    %     if p > clusterP
    %         disp(['Cluster erased ', num2str(clusSize)]);
    %         disp(['Cluster p ', num2str(clusterP)]);
    %     end
    end

    for nVox = 1:length(data.img(:))
        newVal =data.img(nVox) * data3.img(nVox);
        if isnan(newVal)
            disp(data.img(nVox))
            disp(data3.img(nVox))
            error('nan found')
        end
        data.img(nVox) = newVal;


    end
    % data.img = data.img(:).*data3.img(:);
    %max(data.img(data.img>0))
    %
    disp([fileToCorrect,' saved'])
    save_untouch_nii(data,[fileToCorrect,'Corrected.nii.gz']);
    if binarize
        disp('Binarizing')
        data.img = data.img > 0;

        save_untouch_nii(data,[fileToCorrect,'Binarized.nii.gz']);
    end
end
