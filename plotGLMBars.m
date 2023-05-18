function plotGLMBars(e,copeN,clusN,nCat,varargin)
%takes e and plots cope (nCope) and cluster from that cope (clusN)
FSLModel = getArgumentValue('FSLModel',50,varargin{:});

titleS = getArgumentValue('titleS',[],varargin{:});
plotLegend = getArgumentValue('plotLegend',true,varargin{:});
plotTitle = getArgumentValue('plotTitle',true,varargin{:});
plotYLabel = getArgumentValue('plotYLabel',true,varargin{:});
plotXLabel = getArgumentValue('plotXLabel',true,varargin{:});
lineW = getArgumentValue('lineW',1,varargin{:});%witdh of the error line
fontSize = getArgumentValue('fontSize',14,varargin{:});
colorN = getArgumentValue('colorN',11,varargin{:});
black = getArgumentValue('black',false,varargin{:});
pThr = getArgumentValue('pThr',0.05,varargin{:});
plotStar = getArgumentValue('plotStar',true,varargin{:});
starSize = getArgumentValue('starSize',30,varargin{:});
yStar = getArgumentValue('yStar',1,varargin{:});
unbalancedANOVA = getArgumentValue('unbalancedANOVA',false,varargin{:}); %run an unbalanced ANOVA where nCat is tested vs all other cats?
%the result is plot as a star on the first position
catsToUse = getArgumentValue('catsToUse',[],varargin{:}); %categories to use, default all
xPos = getArgumentValue('xPos',[],varargin{:}); %custom position order for cats
if isempty(catsToUse) %if no catsToUse is introduced, then use all
    catsToUse = 1:length(e.catTypes);
    if isempty(xPos)
       xPos = 1:length(e.catTypes); 
    else
       if length(xPos) ~= length(catsToUse)
           error('xPos and catsToUse must the the same size');
       end
    end
else
    if isempty(xPos)
       xPos = 1:length(e.catTypes);
       xPos = xPos(catsToUse);
    else
       if length(xPos) ~= length(catsToUse)
           error('xPos and catsToUse must the the same size');
       end
    end
end


if black
    YColor = 'w';
    XColor = 'w';
    starColor = 'w';
else
    YColor = 'k';
    XColor = 'k';
    starColor = 'k';
end

getDriveFolder;
addpath([dropboxFolder,'\MVPA\Complex']);
addpath([dropboxFolder,'\MVPA\Complex\functions']);

%plot details
colors = getColors(colorN);
plotLegendsS = getLegends('Complex',FSLModel);
plotLegendsS = plotLegendsS(catsToUse); %removing unselected legends

[copeDict,copesPossible] = getCopeDict(FSLModel); %#ok<ASGLU> %gets the list of 
contrastName = copeDict{copeN}; 



b = {};
er = {};
hold on

for n = 1:numel(catsToUse)
    nCat1 = catsToUse(n);
    
    x = xPos(nCat1);
    vals = getValsFrome(e,copeN,clusN,nCat1);
    
    b{nCat1} = bar(x,mean(vals));
    er = errorbar(x,mean(vals),stdError(vals));
    if black
        er.Color = 'w';
    else
        er.Color = 'k';
    end
    er.LineWidth = lineW;
    b{nCat1}.EdgeColor = colors{nCat1}; %#ok<*AGROW>
    b{nCat1}.FaceColor = colors{nCat1};
    
end
if plotTitle
    title(['Contrast: ',contrastName, ' ',titleS]);
end
%     [p,tbl,stats] = anova2(matrixOut,nMeasures,'off');

axVals = axis;
yList = linspace(axVals(3),axVals(4),5);

%     for n = 1:length(p)
%         yT = yList(n+1);
%         text(xT,yT,[resLabels{n},' = ',num2str(round(p(n)*1000)/1000)],'FontSize',pFontSize);
%     end

if plotLegend
    plotAx = [];
    for nLegend = 1:length(plotLegendsS)
        plotAx(nLegend) = b{nLegend};
    end
    lg = legend(plotAx,plotLegendsS);
    set(lg,'Color','none');
    set(lg, 'Box', 'off');
end

if black %changing background color
    set(gca, 'Color', 'k');
else
    set(gca, 'Color', 'w');
end

xtick = [1:length(plotLegendsS)];
if plotYLabel
    ylabel('% BOLD signal change','FontSize',fontSize);
end
if plotXLabel
    xlabel('Category','FontSize',fontSize);
else
    set(gca,'xtick',[]);
end

set(gca,'LineWidth', lineW);

ytick = get(gca,'ytick');
ytick = [min(ytick),max(ytick)];
set(gca,'xtick',xtick, 'XColor', XColor,'Fontsize',fontSize);
set(gca,'ytick',ytick, 'YColor', YColor,'Fontsize',fontSize);
set(gca,'xticklabel',[],'Fontsize',fontSize);
set(gca, 'box', 'off')
set(gca,'xtick',[]);
set(gca, 'xcolor', 'none')
% set(gca, 'visible', 'off');

if plotStar %plot a star where the results are significant
    maxY = max(get(gca,'ytick'));
    [~,pVectorThr,~] = calculatePOne(e,copeN,clusN,nCat,pThr);%runs ttest2
    for n = 1:numel(catsToUse)
        nCat1 = catsToUse(n);
        x = xPos(nCat1);
        if pVectorThr(nCat1)
            plot(x,yStar.*maxY,'*','MarkerSize',starSize,'MarkerEdgeColor',starColor)
        end
    end
end

if unbalancedANOVA %run an unbalanced ANOVA where nCat is tested vs all other cats?
    maxY = max(get(gca,'ytick'));
    [pUnbalanced,tbl,stats] = calculatePOneUnbalanced(e,copeN,clusN,nCat);
    disp(['p = ',num2str(pUnbalanced)]);
    if pUnbalanced < pThr
        plot(1,yStar.*maxY,'*','MarkerSize',starSize,'MarkerEdgeColor',starColor);
    end
end
