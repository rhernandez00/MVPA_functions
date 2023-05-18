function drawDendrogram(distanceVector,labels)
if nargin < 2
    drawLabels = false;
else
    drawLabels =true;
end
% drawLabels = getArgumentValue('drawLabels',true,varargin{:});
lineWidth = 3; %width of the plot line
fontSize = 10;


distanceVector = reshape(distanceVector,[1,numel(distanceVector)]);

clustTreeCos = linkage(distanceVector,'average');

leafOrder = optimalleaforder(clustTreeCos,distanceVector);
%[h,~] = dendrogram(clustTreeCos,0); %vertical
[h,~] = dendrogram(clustTreeCos,0,'Orientation','left','reorder',leafOrder); %horizontal
hAxis = get(h(1), 'parent');

if drawLabels % Create the XTickLabel
    set(hAxis,'YTickLabel',labels(leafOrder), 'FontSize', fontSize);
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
% if printFig
%     saveas(gcf,[outputPath, 'dendo',maskType, '_', mask,'.png']);
% end
