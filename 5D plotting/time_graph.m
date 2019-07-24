function tGraph = time_graph(tNum, fig_bg_color, word_on, word_off)
%TIME_GRAPH Summary of this function goes here
%   Detailed explanation goes here
bar_graph = barh(tNum);
        ax = gca;
%     axes('Position',[0 0 .5 .5]);
    xlim([0 44]);
    xticks([word_on word_off]);
%     xticklabels({'WORD ON','WORD OFF'});
    xticklabels({'',''});
    yticks([]);
    ax.TickDirMode = 'manual';
    ax.TickDir = 'in';
    ax.TickLength = [0.02 1];
%     ax.XAxisLocation = 'bottom';
    set(gca,'Color',fig_bg_color);
    ylim([0.75 1.25]);
    text(word_on + 0.5,1,'WORD ON','Color',fig_bg_color,'FontSize',24);
    
    if tNum < 8 || tNum > 37
        bar_graph.FaceColor = [0.2 0.2 0.2];
    else
        bar_graph.FaceColor = 'red';
    end
end

