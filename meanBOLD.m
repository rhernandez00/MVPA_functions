function timeSeries = meanBOLD(BOLD)

mask = logical(BOLD(:,:,:,1));
for nVolume = 1:size(BOLD,4)
    allVox = BOLD(:,:,:,nVolume);
    timeSeries(nVolume) = mean(allVox(mask));
end



