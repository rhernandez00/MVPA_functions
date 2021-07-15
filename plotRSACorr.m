function plotRSACorr(RSAPath,fileList,coords,tableOrdered,varargin)
fontSize = getArgumentValue('fontSize',12,varargin{:});
varToPlot = getArgumentValue('varToPlot',[],varargin{:});
labelsOn = getArgumentValue('labelsOn',false,varargin{:});
lineWidth = getArgumentValue('lineWidth',2,varargin{:});

if isempty(varToPlot)
    columnNames = fieldnames(tableOrdered);
    indx = find(strcmp('Participant',columnNames));
    columnNames(indx) = []; %#ok<FNDSB>
    if numel(columnNames) > 1
        disp(columnNames);
        error('More than one variable to plot, specify one or remove others');
    else
        xLabelS = getArgumentValue('xLabelS',columnNames{1},varargin{:});
    end
else
    xLabelS = getArgumentValue('xLabelS',varToPlot,varargin{:});
end
yLabelS = getArgumentValue('yLabelS','Dissimilarity',varargin{:});
printTitle = getArgumentValue('printTitle',false,varargin{:});
corrType = getArgumentValue('coorType','Spearman',varargin{:});
nColor = getArgumentValue('nColor',1,varargin{:}); %color for dots, from getColors
colorSet = getArgumentValue('colorSet',1,varargin{:});
printStats = getArgumentValue('printStats',true,varargin{:});

clf
hold on
% saveFigPath = [driveFolder,'\Results\Diana\RSAD'];
colors = getColors(colorSet);

nLineColor = 3; %color for line

color = colors{nColor};
markerSize = 10;




imgVals = zeros(1,length(fileList));
varValues = [tableOrdered.(varToPlot)];


for nFile = 1:length(fileList)
    fileName = fileList{nFile};
    data = load_untouch_niiR([RSAPath,'\',fileName]);
    imgVals(nFile) = data.img(coords(1),coords(2),coords(3));
end

[rho,pval] = corr(imgVals(:),varValues(:),'Type', corrType);

xVals = varValues;
yVals = imgVals;
pl = plot(xVals,yVals,'o','MarkerEdgeColor',color,'MarkerFaceColor',color,'MarkerSize',markerSize); %#ok<NASGU>

if labelsOn
    ylabel(yLabelS, 'FontSize', fontSize);
    xlabel(xLabelS, 'FontSize', fontSize);
end
set(gca, 'box', 'off')
set(gca,'linewidth',lineWidth)
ax1 = get(gca);
ax1.FontSize = fontSize;
set(gca,'FontSize',fontSize)

% set(gca,'xTickLabel',get(gca,'xTickLabel'),'FontSize',fontSize)

adjustLine = true;

if adjustLine
%     disp(nLineColor)
        lineColor = colors{nLineColor};
        m = rho;
        x = varValues(:);
        y = imgVals(:);
        fun = @(vals)difCuadrados(y,recta(x,vals(1),vals(2)));
        vals0 = [m,0];
        vals = fminsearch(fun,vals0);
        x1 = min(varValues):max(varValues);
        h = plot(x1,recta(x1,vals(1),vals(2)), 'Color', lineColor);
        h.LineWidth = lineWidth;
    hold off
end
set(gca, 'box', 'off')
if printTitle
    title(['r = ', num2str(rho),' , p = ',num2str(pval)]);
end
if printStats
    if pval < 0.001
        textToPrint = ['r = ', num2str(round(rho*1000)/1000),' , p < 0.001'];
    else
        textToPrint = ['r = ', num2str(round(rho*1000)/1000),' , p = ',num2str(round(pval*1000)/1000)];
    end
    lg = legend(textToPrint,'location','SE');
    lg.FontSize = fontSize;
    set(lg,'Color','none')
    %remove box as well
    set(lg, 'Box', 'off');
end

% figName = [saveFigPath,'\corrPlot.png'];
% saveas(gcf,figName)
% export_fig(figName,'-transparent')