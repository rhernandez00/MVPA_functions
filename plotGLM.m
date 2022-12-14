function plotGLM(matrixVals,varargin)
%plots bars with error and different colors. Each row is a participant and
%each colum is a different bar
xPos = getArgumentValue('xPos',1:size(matrixVals,2),varargin{:});
fontSize = getArgumentValue('fontSize',14,varargin{:}); 
black = getArgumentValue('black',true,varargin{:}); %black background?
colorN = getArgumentValue('colorN',11,varargin{:}); %color pallet from getColors
plotYLabel = getArgumentValue('plotYLabel',true,varargin{:}); %plotting Y label?
plotXLabel = getArgumentValue('plotXLabel',true,varargin{:}); %plotting X label?
lineW = getArgumentValue('lineW',1,varargin{:}); %error bar line width

if black
    YColor = 'w';
    XColor = 'w';
    baseColor = 'w';
else
    YColor = 'k';
    XColor = 'k';
    baseColor = 'k';
end

hold on
%plots bars/boxplot from matrixVals
colors = getColors(colorN);


for nCat1 = 1:size(matrixVals,2)
    vals = matrixVals(:,nCat1);
    x = xPos(nCat1);
    b = bar(x,mean(vals));
    er = errorbar(x,mean(vals),stdError(vals));
    er.Color = baseColor;
    er.LineWidth = lineW;
    b.EdgeColor = colors{nCat1}; %#ok<*AGROW>
    b.FaceColor = colors{nCat1};
    % ------------plotting------------
end

%X and Y labels

if plotYLabel
    ylabel('% BOLD signal change','FontSize',fontSize);
end
if plotXLabel
    xlabel('Category','FontSize',fontSize);
else
    set(gca,'xtick',[]);
end

%adding the threhold line
% pl = plot(minX:maxX,ones(length(minX:maxX),1)*chancePerformance,'--','Color',baseColor,'LineWidth',lineW);
% ax = axis;
% axis([ax(1),ax(2),ax(3),ax(4)*1.2]);
% axis([minX,maxX,minY,maxY]);
set(gca, 'box', 'off')
set(gca,'xtick',[]);
set(gca, 'XColor', XColor,'Fontsize',fontSize);
set(gca, 'YColor', YColor,'Fontsize',fontSize);

% set(gca,'ytick',[]);
set(gca,'color', 'none');