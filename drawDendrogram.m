function leafOrder = drawDendrogram(DMvector,varargin)
drawLabels = getArgumentValue('drawLabels',true,varargin{:});
lineWidth = 3; %width of the plot line
fontSize = 10;
printFig = false;

clustTreeCos = linkage(DMvector,'average');
D = pdist(DMvector);
leafOrder = optimalleaforder(clustTreeCos,D);
%[h,~] = dendrogram(clustTreeCos,0); %vertical
[h,~] = dendrogram(clustTreeCos,0,'Orientation','left','reorder',leafOrder); %horizontal
hAxis = get(h(1), 'parent');
perm=str2num(get(hAxis,'YtickLabel')); %#ok<ST2NM>

if drawLabels % Create the XTickLabel
    set(hAxis,'YTickLabel',leafOrder, 'FontSize', fontSize);
else
    set(hAxis,'YTick',[]);
end

%rotateXLabels(hAxis,-45)
for l = 1:length(h)
    set(h(l),'LineWidth', lineWidth, 'Color', 'k');
end

ax1 = gca;
set(ax1,'XTick',[],'XColor','w','box','off','layer','top', 'YColor', 'k'); %horizontal
%set(ax1,'YTick',[],'YColor','w','box','off','layer','top', 'YColor', 'w'); %vertical
set(hAxis,'XTickLabel',''); %horizontal
%set(hAxis,'YTickLabel',''); %vertical
yruler = ax1.YRuler;
yruler.Axle.Visible = 'off';
xruler = ax1.XRuler;
xruler.Axle.Visible = 'off';
if printFig
    saveas(gcf,[outputPath, 'dendo',maskType, '_', mask,'.png']);
end
