function h = plotRSA(data,varargin)

minVal = getArgumentValue('minVal',0,varargin{:});
maxVal = getArgumentValue('maxVal',1,varargin{:});
auto = getArgumentValue('auto',true,varargin{:});
fontSize = getArgumentValue('fontSize',18,varargin{:});
centerNum = getArgumentValue('centerNum',true,varargin{:});
barOn = getArgumentValue('barOn',true,varargin{:});
barLegend = getArgumentValue('barLegend',[],varargin{:});
cLabels = getArgumentValue('cLabels',[],varargin{:});

valsForMat = zeros(1,length(data(1).confVals));
for nTest = 1:size(data,2)
    valsForMat = valsForMat + data(nTest).confVals;
end

nLabels = sqrt(length(valsForMat));
confMat = reshape(valsForMat,nLabels,nLabels)';
for nRow = 1:nLabels
    for nCol = 1:nLabels
        confMatN(nRow,nCol) = confMat(nRow,nCol) / sum(confMat(nRow,:));
    end
end

if auto
    minVal = min(confMatN(:));
    maxVal = max(confMatN(:));
end

h = imagesc(confMatN,[minVal,maxVal]);

if centerNum
    for nRow = 1:nLabels
        for nCol = 1:nLabels
            t{nRow,nCol} = text(nRow,nCol,num2str(confMat(nRow,nCol)));
            t{nRow,nCol}.FontSize = fontSize;
            t{nRow,nCol}.HorizontalAlignment = 'center';
        end
    end
end

% set(gca, 'visible', 'off')
set(gca, 'box', 'off');
set(gca, 'XTick', 1:nLabels);
set(gca, 'YTick', 1:nLabels);

if isempty(cLabels)
    set(gca, 'XTickLabel', data(1).labels, 'FontSize',fontSize);
    set(gca, 'YTickLabel', data(1).labels, 'FontSize',fontSize);
else
    set(gca, 'XTickLabel', cLabels, 'FontSize',fontSize);
    set(gca, 'YTickLabel', cLabels, 'FontSize',fontSize);
end



% h.Visible = 'off';
% h.TickLength = [0,0];

if barOn
    clb = colorbar;
    clb.FontSize = fontSize;
    clb.Box = 'off';
    clb.LineWidth = 0.01;
%     clb.Ticks = [(round(minVal*1000)/1000),(round(maxVal*1000)/1000)];
    clb.Ticks = [clb.Ticks(1),clb.Ticks(end)];
    if ~isempty(barLegend)
        clb.Label.String = barLegend;
        clb.Label.FontSize = fontSize;
    end
    pos = clb.Position;
%     clb.Position = [pos(1)*1.1,pos(2),pos(3),pos(4)];
end

