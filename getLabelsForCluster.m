function [structOut,T] = getLabelsForCluster(clusterMap,varargin)
ref = getArgumentValue('ref','Barney2mm',varargin{:});
fileBase = getArgumentValue('fileBase','Barney2mm',varargin{:});
searchSphere = getArgumentValue('searchSphere',false,varargin{:});
sphereName = getArgumentValue('sphereName',true,varargin{:});

atlasNii = getAtlas(ref);
verbosity = 'none';


%This is in case there are nans (NaN appears when a correlation map has a NaN,
%coordinate, the first NaN detected comes in the .mat file) last time 
%checked 1/31/2020
% voxTotal = 0;
% for nVox = 1:length(clusterMap(:))
%     if isnan(clusterMap(nVox))
%         [x,y,z] = flatToXYZ(nVox,clusterMap,'templateFormat','matrix');
%         disp(['x:',num2str(x),' y:',num2str(y),' z:',num2str(z)]);
%         clusterMap(nVox) = 0;
%         voxTotal = voxTotal + 1;
%     end
% end
% disp(voxTotal);
% error('r');
try
    voxMapBin = logical(clusterMap);
catch
    clusterMap(isnan(clusterMap)) = 0;
    voxMapBin = logical(clusterMap);
    disp('nan found');
    pause()
end
[x,y,z] = find3D(voxMapBin);


labelsStr = strings(1,length(x));
for nVox = 1:length(x)
     disp([num2str(nVox), ' / ', num2str(length(x))]);
    coords = [x(nVox),y(nVox),z(nVox)];
    
    [labelName] = getCoordLabel(coords,'ref',ref,'coordType','voxel','atlasNii',atlasNii,...
        'fileBase', fileBase, 'verbosity', verbosity, 'sphereName', sphereName, 'searchSphere', searchSphere);
    labelsStr(nVox) = labelName;
    %disp(labelName)
    %disp(coords)
end

labelPoss=unique(labelsStr);
freq = zeros(1,length(labelPoss));
perc = zeros(1,length(labelPoss));
for k=1:length(labelPoss)
  freq(k)=sum(strcmp(labelsStr,labelPoss(k)));
  perc(k) = freq(k) / length(x);
  
end
[frequency,I] = sort(freq);
I = flip(I);
frequency = flip(frequency);
percentage = perc(I);
labels = labelPoss(I);
for k = 1:length(percentage)
    structOut(k).labels = labels(k);
    structOut(k).percentage = percentage(k);
end


% varNames = ["label","percentage","frequency"];
varNames = {'label','percentage','frequency'};
T = table(labels',percentage',frequency','VariableNames',varNames);


%%
% summary(labels)
% fileName = [driveFolder,'\Results\Prosody\FSLNoFMSTDRSA\res\av2h8task1model01r3_2_5_t_Thr01.nii.gz'];
% voxMap = load_untouch_niiR(fileName);
% voxMap = voxMap.img;