function plotDistribution(participants,runs,categories
clf



nRepetitions = 10000;
participants = 17;
runs = 6;
categories = 2;

perf = calculateDistribution(participants,runs,categories,nRepetitions);
fontSizeL = 12;
barLineW = 1;
%load('distributionPairs')
histBins = 17;
tallOfDist = 19000;
hold on
[yHist,xHist] = hist(perf,histBins);



ax1 = gca;
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none');


hold on



b = barh(xHist,yHist, 'Parent', ax2, 'FaceColor', 'k', 'EdgeColor', 'k', 'LineWidth', barLineW);
%b = plot(yHist,xHist, '-' ,'Parent', ax2, 'MarkerEdgeColor', colors{length(maskNames)+1}, 'MarkerFaceColor', colors{length(maskNames)+1}, 'MarkerSize', markerSize, 'LineWidth',lineW2);
b.Parent.XDir = 'r';
%set(b, 'FaceColor', 'w');
%axis(ax2,[0,tallOfDist,0.01,ax(4)]);
xruler = ax2.XRuler;
xruler.Axle.Visible = 'off';
yruler = ax2.YRuler;
yruler.Axle.Visible = 'off';
ax2.XTick = [];
ax2.YTick = [];
%uistack(lineD,'bottom')
%ylabel(ax2,'Probability')

ax1.FontName = 'Arial';
ax1.FontSize = fontSizeL;

hold off
clc
tabulate(perf)

%%
nRepetitions = 1
perf = calculateDistribution(participants,runs,categories,nRepetitions);