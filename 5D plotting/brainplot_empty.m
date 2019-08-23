function brainplot_empty(number_of_frequencies, number_of_views, number_of_time, fig_bg_color, word_on_time, word_off_time, CBar, vL, fL, vR, fR, f1, f2, f3, f4, f5, f6, font_size)
% 
% DESCRIPTION:
%   Plots an empty figure of all the brain surfaces, along with the
%   colorbar and time graphs.
%   This function is called by electrodes_vid_2.m
% 
% INPUT
%   (1) number_of_frequencies = number of frequencies to be plotted
%   (2) number_of_views = number of views to be plotted
%   (3) number_of_time = total number of frames to be plotted
%   (4) fig_bg_color = color of figure background color
%   (5) word_on_time = frame number for when the word is shown on the
%   screen (during the test)
%   (6) word_off_time = frame number for when the word is removed from the
%   screen (during the test)
%   (7) CBar = picture of the colorbar
%   (8) vL = vectors of the left side of the brain (as specified by
%   BRAIN_SCHEME.mat)
%   (9) fL = faces of the left side of the brain (as specified by
%   BRAIN_SCHEME.mat)
%   (10) vR = vectors of the right side of the brain (as specified by
%   BRAIN_SCHEME.mat)
%   (11) fR = faces of the right side of the brain (as specified by
%   BRAIN_SCHEME.mat)
%   (12-17) f1, f2, f3, f4, f5 & f6 = legend for each frequency to be
%   plotted
%   (18) font_size = font size for the frequency legend
% 
% Written by Theodore Thayib (tpt8899@gmail.com).
% Modificiations:
%  


% Upper time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
    time_graph(0, number_of_time, fig_bg_color, word_on_time, word_off_time);

    % Lower time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
    time_graph(0, number_of_time, fig_bg_color, word_on_time, word_off_time);

    % Colorbar
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);
    imshow(CBar);
    % Plots empty brain pictures.
    for fNum = 1:number_of_frequencies
        % Text for the frequency legend.
        switch fNum
            case 1
                frequency_legend = f1;
            case 2
                frequency_legend = f2;
            case 3
                frequency_legend = f3;
            case 4
                frequency_legend = f4;
            case 5
                frequency_legend = f5;
            case 6
                frequency_legend = f6;
        end
        % Plots brains in the correct views
        for vNum = 1:number_of_views
            subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* fNum * 3 - (number_of_views + 1) * 2 + vNum (number_of_views + 1) * fNum * 3 + vNum], [0.0 0.0],0,[0.1 0]);

            hold on;
            switch vNum
                case 1
                    plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                    view(-90,0);
                    text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
                case 2
                    plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                    view(90,0);
                case 3
                    plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                    plotsurf_wrapper(vR, fR, [0.7, 0.7, 0.7]);
                    view(0,-90);
                case 4
                    plotsurf_wrapper(vR, fR, [0.7, 0.7, 0.7]);
                    view(-90,0);
                case 5
                    plotsurf_wrapper(vR, fR, [0.7, 0.7, 0.7]);
                    view(90,0);
            end
            axis('off');zoom(1);camlight;
            set(gca,'XLim',[-75 75],'YLim',[-125 100],'ZLim',[-75 100]);
        end
    end
    hold off;
end