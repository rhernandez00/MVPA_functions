function [DMs] = makeDendrogram(csvName,masks,maskTypes,labels,outputPath,trimPercent,repetitions)
%DM(mask,maskType)
if nargin < 6
    trimPercent = 0;
    repetitions = 0;
end
%the alpha of the data must be already filtered
%%
lineWidth = 3; %width of the plot line
fontSize = 24;
data = loadDM(csvName);
printFig = 1;
DMs = cell(length(masks),length(maskTypes));
for k = 1:length(masks)
    mask = masks{k};
    for j = 1:length(maskTypes)
        clf
        maskType = maskTypes{j};
        DM = getDistances(data,mask,maskType,trimPercent,repetitions);
        DMs{k,j} = DM;
%         try
%             DM = getDistances(data,mask,maskType);
%         catch
%             mask
%             maskType
%             error('i');
%         end
        clustTreeCos = linkage(DM,'average');
        %[h,~] = dendrogram(clustTreeCos,0); %vertical
        [h,~] = dendrogram(clustTreeCos,0,'Orientation','left'); %horizontal
        hAxis = get(h(1), 'parent');
        perm=str2num(get(hAxis,'YtickLabel'));
        % Create the XTickLabels
        set(hAxis,'YTickLabel',labels(perm), 'FontSize', fontSize);
        
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
        if printFig == 1
            saveas(gcf,[outputPath, 'dendo',maskType, '_', mask,'.png']);
        end
    end
end
%% ---
% clustTreeCos = linkage(DM,'average');
%         [h,~] = dendrogram(clustTreeCos,0,'Orientation','left');
%         
%         
%         
%         %labels = {'Tristeza','Felicidad', 'Enojo', 'Miedo'};
%         %labels = {'one','two','three','four','five','six','seven','eight','nine','ten'};
%         % Create the XTickLabels
%         set(hAxis,'YTickLabel',labels(perm), 'FontSize', 14)
%         %rotateXLabels(hAxis,-45)
%         for l = 1:length(h)
%             set(h(l),'LineWidth', lineWidth, 'Color', 'k')
%         end
%         ax1 = gca;
%         set(ax1,'XTick',[],'XColor','w','box','off','layer','top', 'YColor', 'k')
%         set(hAxis,'XTickLabel','')
%         yruler = ax1.YRuler;
%         yruler.Axle.Visible = 'off';
%         if printFig == 1
%             saveas(gcf,[outputPath, 'dendo',maskType, '_', mask,'.png'])
%         end












%-----------





%%

% 
% set(ax1,'box','off');  %// here you can basically decide whether you like ticks on
%                       %// top and on the right side or not
% 
% %// new white bounding box on top
% ax2 = axes('Position', get(ax1, 'Position'),'Color','none');
% set(ax2,'XTick',[],'YTick',[],'XColor','w','YColor','w','box','on','layer','top');

