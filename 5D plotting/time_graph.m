function tGraph = time_graph(tNum, total_time, fig_bg_color, word_on, word_off)
    %TIME_GRAPH Bar graph that shows current time of the figure.
    %   Takes an input of the time to be shown, the figure background color,
    %   and the word and off times (for tickm marks)
    bar_graph = barh(tNum);
    ax = gca;
    xlim([0 total_time]);
    xticks([word_on word_off]);
    xticklabels({'',''});
    yticks([]);
    ax.TickDirMode = 'manual';
    ax.TickDir = 'in';
    ax.TickLength = [0.02 1];
    set(gca,'Color',fig_bg_color);
    ylim([0.75 1.25]);
    text(word_on + 0.5,1,'WORD ON','Color',fig_bg_color,'FontSize',24);

    % Changes the color of the bar based on if the word is on or off.
    if tNum < 8 || tNum > 37
        bar_graph.FaceColor = [0.2 0.2 0.2];
    else
        bar_graph.FaceColor = 'red';
    end
end
