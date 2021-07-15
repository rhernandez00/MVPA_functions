function pl = plotCorrelationSearchlight(folder,corrVals,coords,varargin)
%plots correlation from RSA folders
corrType = getArgumentValue('corrType','Pearson',varargin{:});
fileList = getArgumentValue('fileList',[],varargin{:});
%plot details
colors = getColors(1);
MarkerSize = getArgumentValue('MarkerSize',3,varargin{:});
MarkerEdgeColor = getArgumentValue('MarkerEdgeColor',colors{1},varargin{:});
MarkerFaceColor = getArgumentValue('MarkerFaceColor',colors{1},varargin{:});
xlabelS = getArgumentValue('xlabelS','',varargin{:});
ylabelS = getArgumentValue('ylabelS','',varargin{:});
fontSize = getArgumentValue('fontSize',14,varargin{:});
lineWidth = getArgumentValue('lineWidth',1,varargin{:});
lineColor = getArgumentValue('lineColor',colors{1},varargin{:});

[imgs,oldPath] = getFileList(folder,'fileList',fileList);
cd(oldPath);
if numel(coords) ~= 3
    size(coordS)
    error('Check coords');
end


x = coords(1);
y = coords(2);
z = coords(3);

val = zeros(1,length(imgs));
for subj = 1:length(imgs)%subjs
    val(subj) = imgs{subj}(x,y,z);
end
[rho,pval] = corr(corrVals(:),val(:),'Type',corrType);
pl = plot(corrVals,val,'.','MarkerSize',MarkerSize,...
    'MarkerEdgeColor',MarkerEdgeColor,'MarkerFaceColor',MarkerFaceColor);
xlabel(xlabelS,'FontSize',fontSize);
ylabel(ylabelS,'FontSize',fontSize);

h = lsline;
h.LineWidth = lineWidth;
h.Color = lineColor;

set(gca, 'box', 'off')

