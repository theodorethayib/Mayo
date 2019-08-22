% DESCRIPTION:
%   Plots electrodes directly onto a brain surface using
%   vertex3d_withAvailROI.m and brain data from BRAIN_SCHEME.mat
% 
% REQUIRED FILES
%   (1) all_loc.mat = [x y z] location of all electrodes
%        all_loc(patients{1}) will give all electrode [x y z] for patient 1 
%   (2)BRAIN_SCHEME.mat = vectors and faces to plot the left and right
%   sides of the brain.
%   (3) hemispheres.mat = hemisphere for all electrodes (1) for left, (0)
%   for right
%        hemispheres(patients{1}) will show which hemipshere all electrodes
%        for patient 1 are in
%   (4) IPtime2.mat = IP values for each electrode at each frequency at
%   each time point for each patient
%   (5) patients.mat = key of patient indentifiers
%   (6) myJet.m = color map for electrode coloring
%   (7) time_graph.m = plots the time graphs at the bottom and bottom of
%   the figures
%   (8) subtightplot.m = allows for the brain surface subplots to be
%   closer together
%   (9) vertex3d_withAvailROI.m = plots a brain surface colored based off
%   electrodes within a ROI
%   (10) Colorbar_new3.png = png file for the colorbar
% 

% VARIABLES
tic
number_of_time = 44; % Total number of time frames within the data.
number_of_frequencies = 6; % Total number of frequencies.
number_of_views = 5; % Total number of views.
number_of_patients = 139; % Total number of patients.
number_of_empty_frames = 4; % Total number of empty frames at the beginning and end of the video.
min_ip_threshold = 0.05; % Minimum threshold for IP values to be plotted
max_ip_threshold = 0.5; % Maximum threshold for IP value colors

% Distance from a brain surface that will be included in it's color
% calculations.
plotThreshold = 4; % Use 4 if no weighted average, 5 if weighted average (distance)

% If use_specific_time is set to 1, it will only plot the times between
% specific_time_start and specific_time_end. If not, it will plot all
% times.
use_specific_time = 1;
specific_time_start = 6;
specific_time_end = 44;

% Time for when word is on/off during the test.
word_on_time = 8;
word_off_time = 37;

% Set save_video to 1 if video is to be saved, 0 if not. vid_name is the
% name of the exported video. frame_rate is the framerate of the video
save_video = 0;
vid_name = 'VidExport_BSurfacePlotTest_3.avi';
frame_rate = 5;

% Set save_picture to 1 if picture is to be saved, 0 if not.
% pic_export_folder is the folder where the exported pictures will be
% saved.
save_picture = 1;
pic_export_folder = '/home/michal/MATLAB/projects/Mayo/trunk/5D plotting/pic_exports';

% Loads required data.
load('all_loc.mat');
load('BRAIN_SCHEME.mat');
load('hemispheres.mat');
load('IPtime2.mat');
load('patients.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};


% CBar loads the colorbar, and fig_bg_color sets the figure's background
% color.
CBar = imread('Colorbar_new3.png');
fig_bg_color = [0.8 0.8 0.8];

% Frequency legend text.
f1 = '\theta_{L}                ';
f2 = '\theta_{H}                ';
f3 = '\alpha                 ';
f4 = '\beta                  ';
f5 = '\gamma_{L}                ';
f6 = '\gamma_{H}                ';

font_size = 32; % Frequency legend text font size

% Prepares the video file
if save_video == 1
    v = VideoWriter(vid_name);
    v.FrameRate = frame_rate;
    open(v);
end

% Creates a maximized figure with the background color specified above, and
% sets matlab to use OpenGL.
f = figure(1);
set(gcf,'units','normalized','outerposition',[0 0 1 1],'color',fig_bg_color,'InvertHardcopy','off')

% If use_specific_time is used, sets the start and end time according to
% specific_time_start and specific_time_end. If not, it sets the start time
% to 1 and the end time to the number stated in number_of_time.
if use_specific_time == 1
    time_value = specific_time_start;
    time_end = specific_time_end;
else
    time_value = 1;
    time_end = number_of_time;
end

% Cycles through each time frame
for tNum = time_value:time_end
    tNum
    
    % Upper time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [1 number_of_views + 1], [0.0 0.0],0,0);
    time_graph(tNum, number_of_time, fig_bg_color, word_on_time, word_off_time);
    
    % Lower time graph
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * number_of_frequencies * 3 + number_of_views + 2 (number_of_views + 1) * number_of_frequencies * 3 + (number_of_views + 1) * 2], [0.0 0.0],0,0);
    time_graph(tNum, number_of_time, fig_bg_color, word_on_time, word_off_time);
    
    % Colorbar
    subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1) * 3 (number_of_views + 1) * (number_of_frequencies * 3)], [],[],[0.2 0.02]);
    imshow(CBar);
    
    % Cycles through all frequencies.
    for fNum = 1: number_of_frequencies
        fNum
        
        % Gets the text label for the current frequency
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
        
        % Cycles through all the views
        for vNum = 1:number_of_views
%             Each brain is 3 subplots tall and 1 subplot wide, while the
%             time graphs are 1 subplot tall and number_of_frequencies
%             subplots wide. The colorbar is 3 * number_of_frequencies - 2
%             subplots tall and 1 subplot wide.
            subtightplot(number_of_frequencies * 3 + 2, number_of_views + 1, [(number_of_views + 1)* fNum * 3 - (number_of_views + 1) * 2 + vNum (number_of_views + 1) * fNum * 3 + vNum], [0.0 0.0],0,[0.1 0]);
            
            hold on;
            % Plots the brain based on subplot
            currentPicture = sprintf('time_%d_%d_%d.png', tNum, fNum, vNum);
            fullCurrentPictureName = fullfile(pic_export_folder, currentPicture);
            fullCurrentPicture = imread(fullCurrentPictureName);
            imshow(fullCurrentPicture);
            if vNum == 1
                text(-3,2,frequency_legend, 'FontSize', font_size, 'FontWeight', 'bold', 'HorizontalAlignment', 'right');
            end
            
            camlight; 
            % Sets plot limits
            hold off;
            drawnow;
            pause(1);
        end
    end
    hold off;
    fprintf('one ')
    pause(1);
    fprintf('two ')
%     drawnow;
    % If save_video is on, save the figure as the set number of frames in
    % the video.
    if save_video == 1
        frame = getframe(gcf);
        writeVideo(v,frame);
    end
    fprintf('three ')
    % If save_picture is on, save the figure as a png file
    if save_picture == 1
        pngFileName = sprintf('time_%d.png', tNum);
        fullFileName = fullfile(pic_export_folder, pngFileName);
    %     saveas(gcf,fullFileName);
        export_fig(fullFileName);
    end
    fprintf('four ')
    pause(1);
    fprintf('five ')
    clf
    fprintf('six ')
    pause(1);
    fprintf('seven ')
end
if save_video == 1
    close(v);
end
fprintf('I am done!!!')
toc