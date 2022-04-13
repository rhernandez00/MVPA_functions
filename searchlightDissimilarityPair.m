function imgResult = searchlightDissimilarityPair(img1,img2,rad,coords)
%runs dissimilarity searchlight of rad for img1 and img2 in coords. 
imgResult = zeros(size(img1));
for nCoord = 1:size(coords,1)
    center = [coords(nCoord,1),coords(nCoord,2),coords(nCoord,3)];
    [~,flatCoords] = createSphere(img1,rad,center); %creates a sphere in img1 space
    vector1 = img1(flatCoords)';
    vector2 = img2(flatCoords)';
    d = pdist2(vector1,vector2,'correlation'); %calculates correlation distance
    imgResult(center(1),center(2),center(3)) = d;
end