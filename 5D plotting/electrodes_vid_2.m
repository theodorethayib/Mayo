% 
% DESCRIPTION:
% 	Plots electrodes directly onto a brain surface with options for saving
% 	each individual frame as a picture, and saving them as a video (with
% 	options for if empty brain frames in the beginning and end of the video
% 	are wanted).
% 
% REQUIRED FILES
%   (1) all_loc.mat = [x y z] location of all electrodes
%        all_loc(patients{1}) will give all electrode [x y z] for patient 1 
%   (2) BRAIN_SCHEME.mat = vectors and faces to plot the left and right
%   sides of the brain.
%   (3) hemispheres.mat = hemisphere for all electrodes (1) for left, (0)
%   for right
%        hemispheres(patients{1}) will show which hemipshere all electrodes
%        for patient 1 are in
%   (4) IPtime2.mat = IP values for each electrode at each frequency at
%   each time point for each patient
%   (5) patients.mat = key of patient indentifiers
%   (6) brainplot_empty.m = empty figure of all the brain surfaces, with the
%   colorbar and time graphs.
%   (7) brainplot_with_electrodes.m = plots electrodes on top of a brain surface.
%   (8) fread.m
%   (9) plot3_wrapper.m = wrapper for plotting the brain surface
%   (10) plotsurf_wrapper.m = wrapper for plotting the brain surface
%   (11) read_surf_wrapper.m = wrapper for read_surf
%   (12) read_surf.m = for reading a surface file
%   (13) render_freesurfer3D.m = rendering a freesurfer surface
%   (14) time_graph.m = plots the time graphs at the bottom and bottom of
%   the figures
%   (15) subtightplot.m = allows for the brain surface subplots to be
%   closer together
%   (16) Colorbar_new3.png = png file for the colorbar
% 

% VARIABLES
tic %Tracks how long the code runs for
number_of_frequencies = 6;
number_of_patients = 139;
number_of_time = 44;
number_of_views = 5;
number_of_empty_frames = 4;
frame_rate = 5;
circle_size = 3;
min_ip_threshold = 0.05;
max_ip_threshold = 0.5;

use_specific_time = 0;
specific_time_start = 6;
specific_time_end = 6;

% Time for when word is on/off during the test.
word_on_time = 8;
word_off_time = 37;

% Name of the exported video.
save_video = 1;
vid_name = 'a2.avi';

% Set save_picture to 1 if you want each time-frame to be saved to a png
% file. Set folder pictures to be saved in to pic_export_folder
save_picture = 0;
pic_export_folder = '5D plotting\pic_exports';

% Frequency legend text.
f1 = '\theta_{L}                ';
f2 = '\theta_{H}                ';
f3 = '\alpha                 ';
f4 = '\beta                  ';
f5 = '\gamma_{L}                ';
f6 = '\gamma_{H}                ';

font_size = 32; %Frequency legend text font size

% Variables for colors, electrodes, and figure background (RGB triplets)
% Note that the colorbar is a png file (edited through the
% colorbar_new2.psd photoshop file) - if the colors are changed here, they
% need to be manually changed within the photoshop file as well (gradient
% tool).
light_blue_color = [0.52 1 0.99];
dark_blue_color = [0.14 0 0.34];
light_red_color = [0.99 0.89 0.01];
dark_red_color = [0.36 0 0.11];
fig_bg_color = [0.8 0.8 0.8];

% Calculations for the darkest and lightest blue colors for the electrode
% markers (RGB triplets).
blueRedColorOne = (dark_blue_color(1) - light_blue_color(1)) / 0.9;
blueRedColorTwo = dark_blue_color(1) - blueRedColorOne;
blueBlueColorOne = (dark_blue_color(2) - light_blue_color(2)) / 0.9;
blueBlueColorTwo = dark_blue_color(2) - blueBlueColorOne;
blueGreenColorOne = (dark_blue_color(3) - light_blue_color(3)) / 0.9;
blueGreenColorTwo = dark_blue_color(3) - blueGreenColorOne;

% Calculations for the darkest and lightest red colors for the electrode
% markers (RGB triplets).
redRedColorOne = (dark_red_color(1) - light_red_color(1)) / 0.9;
redRedColorTwo = dark_red_color(1) - redRedColorOne;
redBlueColorOne = (dark_red_color(2) - light_red_color(2)) / 0.9;
redBlueColorTwo = dark_red_color(2) - redBlueColorOne;
redGreenColorOne = (dark_red_color(3) - light_red_color(3)) / 0.9;
redGreenColorTwo = dark_red_color(3) - redGreenColorOne;

% Loads all the required data for electrodes and brain plotting.
load('all_loc.mat');
load('BRAIN_SCHEME.mat');
load('hemispheres.mat');
load('IPtime2.mat');
load('patients.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

% Loads the colorbar picture
CBar = imread('Colorbar_new3.png');

% Prepares the video file
if save_video == 1
    v = VideoWriter(vid_name);
    v.FrameRate = frame_rate;
    open(v);
end

% Creates a maximized figure with the background color specified above, and
% sets matlab to use OpenGL.
f = figure(1);
set(gcf,'units','normalized','outerposition',[0 0 1 1],'color',fig_bg_color,'WindowState','maximized','InvertHardcopy','off','Renderer','OpenGL')

% EMPTY FRAMES AT BEGINNING OF VIDEO
brainplot_empty(number_of_frequencies, number_of_views, number_of_time, fig_bg_color, word_on_time, word_off_time, CBar, vL, fL, vR, fR, f1, f2, f3, f4, f5, f6, font_size);
if save_video == 1
    for empty_frames = 1:number_of_empty_frames
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end
if save_picture == 1
    fullFileName = fullfile(pic_export_folder, 'empty_brain.png');
    saveas(gcf,fullFileName);
end

if use_specific_time == 1
    time_value = specific_time_start;
    time_end = specific_time_end;
else
    time_vlaue = 1;
    time_end = number_of_time;
end
clf;

% PLOTS ELECTRODES IN BRAINS LOOPS FOR ELECTRODES
for tNum = time_value:time_end
    tNum % To see how far along the code is - can be commented out
    
     % Upper time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
    time_graph(tNum, number_of_time, fig_bg_color, word_on_time, word_off_time);
    
    % Lower time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
    time_graph(tNum, number_of_time, fig_bg_color, word_on_time, word_off_time);
    
    % Colorbar
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);
    imshow(CBar);
    
    
    
    for fNum = 1:number_of_frequencies
        % Resets elec_rows_matrix and elec_matrix
        elec_matrix_left = [];
        elec_matrix_right = [];
        
        
        
        for pNum = 1:number_of_patients
            % Gets location and IP values of electrodes of the current
            % patient
            eLocation = all_loc(patients{pNum}); % Location of all electrodes for the current patient
            elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
            
            IPvalue_matrix = elec_field(:,fNum,tNum); % Gets IP values for all electrodes for the current patient in the correct time and frequency
            eSize = size(IPvalue_matrix,1); % Amount of electrodes in 
                                            % patient
            eHemisphereFull = hemispheres(patients{pNum}); % Gets the hemisphere for all electrodes for the current patient
            % Cycles through all electrodes for the current patient
            for eNum = 1:eSize
                IPvalue = IPvalue_matrix(eNum, 1);
                
                % Checks to see if the electrode is within the IP
                % threhsolds set above. Ignores electrodes that are not
                % within the thresholds.
                if (IPvalue_matrix(eNum) >= min_ip_threshold) || (IPvalue_matrix(eNum) <= -min_ip_threshold)
                    x = eLocation(eNum, 1);
                    y = eLocation(eNum, 2);
                    z = eLocation(eNum, 3);
                    
                    % Colors electrodes respective to their IP values
                    if IPvalue > 0
                        color_value = IPvalue / max_ip_threshold;
                        if color_value > 1
                            color_value = 1;
                        end
                        red_color = color_value * redRedColorOne + redRedColorTwo;
                        blue_color = color_value * redBlueColorOne + redBlueColorTwo;
                        green_color = color_value * redGreenColorOne + redGreenColorTwo;
                    else
                        color_value = IPvalue / -max_ip_threshold;
                        if color_value > 1
                            color_value = 1;
                        end
                        red_color = color_value * blueRedColorOne + blueRedColorTwo;
                        blue_color = color_value * blueBlueColorOne + blueBlueColorTwo;
                        green_color = color_value * blueGreenColorOne + blueGreenColorTwo;
                    end
                    
                    c = [red_color blue_color green_color];
                    % Saves what hemispehre the electrodes are in
                    % eHemisphere = eHemisphereFull(eNum);
                    if eHemisphereFull(eNum) == 1
                        elec_matrix_left = [elec_matrix_left;x y z c];
                    else
                        elec_matrix_right = [elec_matrix_right;x y z c];
                    end
                    
                end
            end
        end
        % Brain graphs subplot_num is for the rows of the plots (1 is the
        % first brain plot, etc)
        
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
        
        for vNum = 1:number_of_views
%             Each brain is 3 subplots tall and 1 subplot wide, while the
%             time graphs are 1 subplot tall and number_of_frequencies
%             subplots wide. The colorbar is 3 * number_of_frequencies - 2
%             subplots tall and 1 subplot wide.
            subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* fNum * 3 - (number_of_views + 1) * 2 + vNum (number_of_views + 1) * fNum * 3 + vNum], [0.0 0.0],0,[0.1 0]);
            
            hold on;
            % Plots brains in the correct views
            switch vNum
                case 1
                    brainplot_with_electrodes(vL, fL, [0.7 0.7 0.7], elec_matrix_left, circle_size);
                    view(-90,0);
                    text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
                case 2
                    brainplot_with_electrodes(vL, fL, [0.7 0.7 0.7], elec_matrix_left, circle_size);
                    view(90,0);
                case 3
                    brainplot_with_electrodes(vL, fL, [0.7 0.7 0.7], elec_matrix_left, circle_size);
                    brainplot_with_electrodes(vR, fR, [0.7 0.7 0.7], elec_matrix_right, circle_size);
                    view(0,-90);
                case 4
                    brainplot_with_electrodes(vR, fR, [0.7 0.7 0.7], elec_matrix_right, circle_size);
                    view(-90,0);
                case 5
                    brainplot_with_electrodes(vR, fR, [0.7 0.7 0.7], elec_matrix_right, circle_size);
                    view(90,0);
            end
            axis('off');zoom(1);camlight;
            set(gca,'XLim',[-75 75],'YLim',[-125 100],'ZLim',[-75 100]);
        end
    end

    hold off;
    
    % Writes current figure to the video
    if save_video == 1
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    
    
    % If save_picture is on, it will save the figure as a png file
    if save_picture == 1
        pngFileName = sprintf('time_%d.png', tNum);
        fullFileName = fullfile(pic_export_folder, pngFileName);
        saveas(gcf,fullFileName);
    end
    clf;
end

if save_video == 1
    brainplot_empty(number_of_frequencies, number_of_views, number_of_time, fig_bg_color, word_on_time, word_off_time, CBar, vL, fL, vR, fR, f1, f2, f3, f4, f5, f6, font_size);
    for empty_frames = 1:number_of_empty_frames
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
end

% Closes the video writer.
if save_video == 1
    close(v);
end
toc % Tracks how long the code runs for






