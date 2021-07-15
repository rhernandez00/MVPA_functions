function [stats,emptyCoords,multipleCentroid,coords] = getCentroid(imgMatrix,varargin)
%calculates centroid of a cluster in a matrix
ignoreMultipleCentroids = getArgumentValue('ignoreMultipleCentroids',false,varargin{:});

emptyCoords = false;
stats = regionprops3(imgMatrix);
if numel(stats.Centroid) > 3
   if ignoreMultipleCentroids
        multipleCentroid = true;
        for nRow = 1:size(stats.Centroid,1)
           if isnan(stats.Centroid(nRow))
               stats.Centroid
               error('nan found')
           else
               coordsTmp = stats.Centroid(nRow);
               if sum(isnan(coordsTmp)) > 0
                    emptyCoords = true;
               else
                   stats = stats(nRow,:);
                   break
               end
               
           end
        end
   else
        error('Must write what to do with multiple centroids');
   end
else
    multipleCentroid = false;
end
if emptyCoords
    coords = [];
else 
    x = round(stats.Centroid(2));
    y = round(stats.Centroid(1));
    z = round(stats.Centroid(3));
    coords = [x,y,z];
end

