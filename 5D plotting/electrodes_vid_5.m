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

fig_bg_color = [0.8 0.8 0.8];

% Set save_picture to 1 if picture is to be saved, 0 if not.
% pic_export_folder is the folder where the exported pictures will be
% saved.
save_picture = 1;
pic_export_folder = '/home/michal/MATLAB/projects/Mayo/trunk/5D plotting/pic_exports';
% pic_export_folder = '/Users/localadmin/Documents/MATLAB/5D plotting_new_new/5D plotting/pic_exports';

% Loads required data.
load('all_loc.mat');
load('BRAIN_SCHEME.mat');
load('hemispheres.mat');
load('IPtime2.mat');
load('patients.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

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
    % Cycles through all frequencies.
    for fNum = 1: number_of_frequencies
        fNum
        % Resets all color and color average matrices.
        colMatrixLeft = NaN(size(vL,1),1);
        colMatrixRight = NaN(size(vR,1),1);
        colAvgLeft = zeros(size(vL,1),2);
        colAvgRight = zeros(size(vR,1),2);
        % Cycles through all patients.
        for pNum = 1:number_of_patients
            eLocation = all_loc(patients{pNum}); % Location of all electrodes for the current patient
            elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
            IPvalue_matrix = elec_field(:,fNum,tNum); % Gets IP values for all electrodes for the current patient in the correct time and frequency
            eHemisphereFull = hemispheres(patients{pNum}); % Gets the hemisphere for all electrodes for the current patient
            % Cycles through all electrodes for the current patient
            for eNum = 1:size(IPvalue_matrix,1)
                IPvalue = IPvalue_matrix(eNum, 1); % Gets IP value for the current electrode
                if IPvalue > min_ip_threshold || IPvalue < min_ip_threshold % Checks to see if electrode is within threshold
                    IPvalue = IPvalue * 2; % Sets IP value to conform with vertex3d color scale
                    if IPvalue >= 1 % Sets all IP values outside of the maximum threshold to the highest color
                        IPvalue = 0.99;
                    elseif IPvalue <= -1
                        IPvalue = -0.99;
                    end
                    if eHemisphereFull(eNum) == 1 % Determines whether to save the electrode color information in the left or right (hemisphere) matrix
                        for vectRowNum = 1:size(vL,1) % Cycles through all vertices of the brain surface to see if the x, y, then z values of the current electrode are within the plot_threshold
                            if eLocation(eNum,1) >= vL(vectRowNum,1) - plotThreshold && eLocation(eNum,1) <= vL(vectRowNum,1) + plotThreshold &&... % Checks x value
                                    eLocation(eNum,2) >= vL(vectRowNum,2) - plotThreshold && eLocation(eNum,2) <= vL(vectRowNum,2) + plotThreshold &&... % Checks y value
                                    eLocation(eNum,3) >= vL(vectRowNum,3) - plotThreshold && eLocation(eNum,3) <= vL(vectRowNum,3) + plotThreshold % Checks z value
                                colAvgLeft(vectRowNum,1) = colAvgLeft(vectRowNum,1) + (IPvalue * (plotThreshold - norm(eLocation(eNum) - vL(vectRowNum)))); % Weighted average for color based on distance from the brain surface
                                                                                                                                                            % Multiplies the IP value by (plot_threshold - distance from the brain surface) and adds that to the first column of the color matrix of the corresponding brain surface vector
                                colAvgLeft(vectRowNum,2) = colAvgLeft(vectRowNum,2) + (plotThreshold - norm(eLocation(eNum) - vL(vectRowNum))); % (plot_threshold - distance from the brain surface) and adds that to the second column of the corresponding brain surface vector
                                % Electrodes closer to the brain surface
                                % carry more weight (as they're multiplied
                                % by a larger number) compared to those
                                % further away in order to properly
                                % (linearly) weight by distance.
                            end
                        end
                    else
                        for vectRowNum = 1:size(vR,1)
                            if eLocation(eNum,1) >= vR(vectRowNum,1) - plotThreshold && eLocation(eNum,1) <= vR(vectRowNum,1) + plotThreshold &&...
                                    eLocation(eNum,2) >= vR(vectRowNum,2) - plotThreshold && eLocation(eNum,2) <= vR(vectRowNum,2) + plotThreshold &&...
                                    eLocation(eNum,3) >= vR(vectRowNum,3) - plotThreshold && eLocation(eNum,3) <= vR(vectRowNum,3) + plotThreshold
                                colAvgRight(vectRowNum,1) = colAvgRight(vectRowNum,1) + (IPvalue * (plotThreshold - norm(eLocation(eNum)- vR(vectRowNum)))); % Weighted average for color based on distance from the brain surface
                                colAvgRight(vectRowNum,2) = colAvgRight(vectRowNum,2) + (plotThreshold - norm(eLocation(eNum) - vR(vectRowNum)));
                            end
                        end
                    end
                end
            end
        end
        % Divides the left and right color matrices to get the weighted
        % averages.
        colMatrixLeft(:,1) = colAvgLeft(:,1) ./ colAvgLeft(:,2);
        colMatrixRight(:,1) = colAvgRight(:,1) ./ colAvgRight(:,2);
        
        % Cycles through all the views
        for vNum = 1:number_of_views
            vNum
%             Each brain is 3 subplots tall and 1 subplot wide, while the
%             time graphs are 1 subplot tall and number_of_frequencies
%             subplots wide. The colorbar is 3 * number_of_frequencies - 2
%             subplots tall and 1 subplot wide.

           % Plots the brain based on subplot
            switch vNum
                case 1
                    vertex3d_withAvailROI(vL,fL,[],colMatrixLeft,0.99,[-90 0],1,0);
                    set(gca,'XLim',[-125 125],'YLim',[-150 125],'ZLim',[-60 85]);
                case 2
                    vertex3d_withAvailROI(vL,fL,[],colMatrixLeft,0.99,[90 0],1,0);
                    set(gca,'XLim',[-125 125],'YLim',[-150 125],'ZLim',[-60 85]);
                case 3
                    hold on;
                    vertex3d_withAvailROI(vL,fL,[],colMatrixLeft,0.99,[0 -90],1,0);
                    vertex3d_withAvailROI(vR,fR,[],colMatrixRight,0.99,[0 -90],1,0);
                    hold off;
                    set(gca,'XLim',[-125 125],'YLim',[-100 75],'ZLim',[-60 85]);
                case 4
                    vertex3d_withAvailROI(vL,fL,[],colMatrixRight,0.99,[-90 0],1,0);
                    set(gca,'XLim',[-125 125],'YLim',[-150 125],'ZLim',[-60 85]);
                case 5
                    vertex3d_withAvailROI(vR,fR,[],colMatrixRight,0.99,[90 0],1,0);
                    set(gca,'XLim',[-125 125],'YLim',[-150 125],'ZLim',[-60 85]);
            end
            camlight; 
            % Sets plot limits
            drawnow;
            pause(1);
            if save_picture == 1
                pngFileName = sprintf('time_%d_%d_%d.png', tNum, fNum, vNum);
                fullFileName = fullfile(pic_export_folder, pngFileName);
    %     saveas(gcf,fullFileName);
                export_fig(fullFileName);
            end
            clf;
            pause(1);
        end
    end
end
fprintf('I am done!!!')
toc