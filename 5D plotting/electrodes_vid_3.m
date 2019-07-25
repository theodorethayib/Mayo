% VARIABLES
tic %Tracks how long the code runs for
number_of_frequencies = 6;
number_of_patients = 1;
number_of_time = 1;
number_of_electrodes = 72;
number_of_views = 5;
number_of_empty_frames = 4;
frame_rate = 5;
circle_size = 3;
min_ip_threshold = 0.05;
max_ip_threshold = 0.5;

%TIME FOR WHEN WORD IS ON/OFF
word_on_time = 8;
word_off_time = 37;

%NAME OF VIDEO EXPORT
vid_name = 't2.avi';

% Set save_picture to 1 if you want each time-frame to be saved to a png
% file. Set folder pictures to be saved in to pic_export_folder
save_picture = 0;
pic_export_folder = '5D plotting\pic_exports';

% FREQUENCY LEGEND
f1 = '\theta_{L}                ';
f2 = '\theta_{H}                ';
f3 = '\alpha                 ';
f4 = '\beta                  ';
f5 = '\gamma_{L}                ';
f6 = '\gamma_{H}                ';

font_size = 32;


% VARIABLES FOR COLORS FOR ELECTRODES AND FIGURE BACKGROUND (RGB TRIPLETS)
% NOTE THAT THE COLOR BAR IS A PNG FILE (EDITED THROUGH THE
% COLORBAR_NEW2.PSD PHOTOSHOP FILE)- IF THE COLORS ARE CHANGED HERE, THEY
% NEED TO BE MANUALLY CHANGED WITHIN THE PHOTOSHOP FILE AS WELL (GRADIENT
% TOOL).
% transparency_var = 0.3; - THIS IS DOING NOTHING RIGHT NOW
light_blue_color = [0.52 1 0.99];
dark_blue_color = [0.14 0 0.34];
light_red_color = [0.99 0.89 0.01];
dark_red_color = [0.36 0 0.11];
fig_bg_color = [0.8 0.8 0.8];

% CALCULATIONS FOR THE RGB TRIPLETS FOR THE DARK AND LIGHT BLUE
blueRedColorOne = (dark_blue_color(1) - light_blue_color(1)) / 0.9;
blueRedColorTwo = dark_blue_color(1) - blueRedColorOne;
blueBlueColorOne = (dark_blue_color(2) - light_blue_color(2)) / 0.9;
blueBlueColorTwo = dark_blue_color(2) - blueBlueColorOne;
blueGreenColorOne = (dark_blue_color(3) - light_blue_color(3)) / 0.9;
blueGreenColorTwo = dark_blue_color(3) - blueGreenColorOne;

% CALCULATIONS FOR THE RGB TRIPLETS FOR THE DARK AND LIGHT RED
redRedColorOne = (dark_red_color(1) - light_red_color(1)) / 0.9;
redRedColorTwo = dark_red_color(1) - redRedColorOne;
redBlueColorOne = (dark_red_color(2) - light_red_color(2)) / 0.9;
redBlueColorTwo = dark_red_color(2) - redBlueColorOne;
redGreenColorOne = (dark_red_color(3) - light_red_color(3)) / 0.9;
redGreenColorTwo = dark_red_color(3) - redGreenColorOne;

%LOADS ALL REQUIRED DATA FOR ELECTRODES AND BRAIN PLOTTING
load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');
load('hemispheres.mat');
load('BRAIN_SCHEME.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

%LOADS COLORBAR PICTURE
CBar = imread('Colorbar_new3.png');

%PREPARES VIDEO WRITER
v = VideoWriter(vid_name);
v.FrameRate = frame_rate;
open(v);

%CREATES FIGURE, SETS FIGURE TO MAXIMIZED, SETS BG COLOR, AND SETS MATLAB TO USE GPU
f = figure(1);
f.WindowState = 'maximized';
set(gcf,'units','normalized','outerposition',[0 0 1 1])
set(gcf,'color',fig_bg_color);
set(gcf,'InvertHardcopy','off');
set(gcf,'Renderer','OpenGL');

% EMPTY FRAMES AT BEGINNING OF VIDEO
% UPPER TIME GRAPH
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
time_graph(0, fig_bg_color, word_on_time, word_off_time);

% LOWER TIME GRAPH
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
time_graph(0, fig_bg_color, word_on_time, word_off_time);

% COLORBAR
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);imshow(CBar);

% PLOTS EMPTY BRAIN PICTURES
for subplot_num = 1:number_of_frequencies
%     TEXT FOR BRAIN FREQUENCY LEGEND
    switch subplot_num
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
%     PLOTS BRAIN FOR EACH OF THE 5 VIEWS
    for current_view = 1: number_of_views
        subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* subplot_num * 3 - (number_of_views + 1) * 2 + current_view (number_of_views + 1) * subplot_num * 3 + current_view], [0.0 0.0],0,[0.1 0]);

        hold on;
        switch current_view
            case 1
                plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                view(-90,0);
                h = text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold');
                h.HorizontalAlignment = 'right';
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
% SAVES number_of_empty_frames FRAMES OF THE EMPTY BRAIN TO THE VIDEO
for empty_plot = 1:number_of_empty_frames  
    frame = getframe(gcf);
    writeVideo(v,frame);
end

fullFileName = fullfile(pic_export_folder, 'empty_brain.png');
saveas(gcf,fullFileName);

clf;
 
% LOOPS FOR ELECTRODES
for tNum = 1:number_of_time
    tNum % To see how far along the code is - can be commented out
    
%     Resets elec_rows_matrix and elec_matrix
    elec_rows_matrix = [];
    elec_matrix = [];
    
    for fNum = 1:number_of_frequencies
%         Resets elec_rows counter
        elec_rows = 0;
        
        for pNum = 1:number_of_patients
%             Gets location and IP values of electrodes of the current
%             patient
            eLocation = all_loc(patients{pNum});
            elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
            
            IPvalue_matrix = elec_field(:,fNum,tNum);
            eSize = size(IPvalue_matrix,1); %Amount of electrodes in patient
            eHemisphereFull = hemispheres(patients{pNum});

                    for eNum = 1:eSize
                        IPvalue = IPvalue_matrix(eNum, 1);
                        
%                         CHECKS TO SEE IF ELECTRODE IS WITHIN THE IP
%                         THRESHOLDS. IGNORES ELECTRODES THAT ARE NOT
%                         WITHIN THE THRESHOLDS.
                        if (IPvalue_matrix(eNum) >= min_ip_threshold) || (IPvalue_matrix(eNum) <= -min_ip_threshold)
                            x = eLocation(eNum, 1);
                            y = eLocation(eNum, 2);
                            z = eLocation(eNum, 3);
                            
%                             Colors electrodes respective to their IP
%                             values
                            if IPvalue > 0
                                color_value = IPvalue / max_ip_threshold;
                                if color_value > 1
                                    color_value = 1;
                                end    
                                red_color = color_value * redRedColorOne + redRedColorTwo;
                                blue_color = color_value * redBlueColorOne + redBlueColorTwo;
                                green_color = color_value * redGreenColorOne + redGreenColorTwo;

                                c = [red_color blue_color green_color];	
                            else
                                color_value = IPvalue / -max_ip_threshold;
                                if color_value > 1
                                    color_value = 1;
                                end   
                                red_color = color_value * blueRedColorOne + blueRedColorTwo;
                                blue_color = color_value * blueBlueColorOne + blueBlueColorTwo;
                                green_color = color_value * blueGreenColorOne + blueGreenColorTwo;

                                c = [red_color blue_color green_color];
                            end
%                             What hemispehre the electrodes are in
                            eHemisphere = eHemisphereFull(eNum);
                            patient_matrix = [x y z c eHemisphere];
                            
%                             Adds all electrode information (x y z
%                             coordinates, color, and hemisphere) into one
%                             big matrix (elec_matrix) and adds one to the
%                             number of rows
                            elec_matrix = [elec_matrix;patient_matrix];
                            elec_rows = elec_rows + 1;
                        end
                    end
        end
        elec_rows_matrix = [elec_rows_matrix;elec_rows];
    end
    % UPPER TIME GRAPH
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
    time_graph(0, fig_bg_color, word_on_time, word_off_time);

    % LOWER TIME GRAPH
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
    time_graph(0, fig_bg_color, word_on_time, word_off_time);

    % COLORBAR
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);    imshow(CBar);
    
    hold on;
    
%     Brain graphs
    for subplot_num = 1:number_of_frequencies 
        switch subplot_num
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
%         Prepares for figuring out what rows of the matrix each frequency
%         uses
        row_count = 1;
        if subplot_num == 1
           row_for_this_frequency = elec_rows_matrix(1);
           row_start = 1; %what row the subplot should start on
        else
            row_start = row_start + elec_rows_matrix(subplot_num - 1);
            row_for_this_frequency = elec_rows_matrix(subplot_num);
        end
        for current_view = 1: number_of_views
            subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* subplot_num * 3 - (number_of_views + 1) * 2 + current_view (number_of_views + 1) * subplot_num * 3 + current_view], [0.0 0.0],0,[0.1 0]);
            
            hold on;
%             Plots brains in the correct views
            switch current_view
                case 1
                    plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                    view(-90,0);
                    h = text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold');
                    h.HorizontalAlignment = 'right';
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
            
%             Plots electrodes (in correct hemisphere)
            if current_view <= 2
                for row_number = row_start:(row_for_this_frequency + row_start - 1)
                    if elec_matrix(row_number,7) == 1
                        markercolor = [elec_matrix(row_number,4) elec_matrix(row_number,5) elec_matrix(row_number,6)];
                        x = elec_matrix(row_number,1);
                        y = elec_matrix(row_number,2);
                        z = elec_matrix(row_number,3);

                        p = plot3(elec_matrix(row_number,1),elec_matrix(row_number,2),elec_matrix(row_number,3),'o','MarkerSize',circle_size,'Color',markercolor,'MarkerFaceColor',markercolor);
%                         p.Color(4) = 0.3; I think this line does nothing?
                    end
                end
            elseif current_view >= 4
                for row_number = row_start:(row_for_this_frequency + row_start - 1)
                    if elec_matrix(row_number,7) == 0
                        markercolor = [elec_matrix(row_number,4) elec_matrix(row_number,5) elec_matrix(row_number,6)];
                        x = elec_matrix(row_number,1);
                        y = elec_matrix(row_number,2);
                        z = elec_matrix(row_number,3);

                        p = plot3(elec_matrix(row_number,1),elec_matrix(row_number,2),elec_matrix(row_number,3),'o','MarkerSize',circle_size,'Color',markercolor,'MarkerFaceColor',markercolor);
%                         p.Color(4) = 0.3; I think this line does nothing?
                    end
                end
            else        
                for row_number = row_start:(row_for_this_frequency + row_start - 1)
                    markercolor = [elec_matrix(row_number,4) elec_matrix(row_number,5) elec_matrix(row_number,6)];
                    x = elec_matrix(row_number,1);
                    y = elec_matrix(row_number,2);
                    z = elec_matrix(row_number,3);

                    p = plot3(elec_matrix(row_number,1),elec_matrix(row_number,2),elec_matrix(row_number,3),'o','MarkerSize',circle_size,'Color',markercolor,'MarkerFaceColor',markercolor);
%                     p.Color(4) = 0.3; I think this line does nothing?
                end
            end
        ax2 = gca;
        ax2.TickLength = [0 0];
        axis('off');     
        end      
    end
    hold off;
    
%     Writes current figure to the video
    frame = getframe(gcf);
    writeVideo(v,frame);
    
%     If save_picture is on, it will save the figure as a png file
    if save_picture == 1
        pngFileName = sprintf('time_%d.png', tNum);
        fullFileName = fullfile(pic_export_folder, pngFileName);
        saveas(gcf,fullFileName);
    end
    clf;
end

% EMPTY FRAMES AT THE END OF VIDEO
% UPPER TIME GRAPH
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
time_graph(0, fig_bg_color, word_on_time, word_off_time);

% LOWER TIME GRAPH
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
time_graph(0, fig_bg_color, word_on_time, word_off_time);

% COLORBAR
subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);
imshow(CBar);
% PLOTS EMPTY BRAIN PICTURES
for subplot_num = 1:number_of_frequencies
%     TEXT FOR BRAIN FREQUENCY LEGEND
    switch subplot_num
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
%     PLOTS BRAIN FOR EACH OF THE 5 VIEWS
    for current_view = 1: number_of_views
        subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* subplot_num * 3 - (number_of_views + 1) * 2 + current_view (number_of_views + 1) * subplot_num * 3 + current_view], [0.0 0.0],0,[0.1 0]);

        hold on;
        switch current_view
            case 1
                plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                view(-90,0);
                h = text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold');
                h.HorizontalAlignment = 'right';
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
% SAVES number_of_empty_frames FRAMES OF THE EMPTY BRAIN TO THE VIDEO
for empty_plot = 1:number_of_empty_frames  
    frame = getframe(gcf);
    writeVideo(v,frame);
end

clf;

hold off;
close(v);
toc %Tracks how long the code runs for