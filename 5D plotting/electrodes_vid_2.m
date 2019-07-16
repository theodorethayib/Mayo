% VARIABLES
tic
number_of_frequencies = 6;
number_of_patients = 139;
number_of_time = 5;
number_of_electrodes = 72;
number_of_views = 5;
IPthreshold = 0.05;
frame_rate = 5;
circle_size = 1;
max_threshold = 0.5;

word_on_time = 8;
word_off_time = 37;

vid_name = 'VidExportMultiViewTest1.avi';

transparency_var = 0.3;
light_blue_color = [0.52 1 0.99];
dark_blue_color = [0.14 0 0.34];
light_red_color = [0.99 0.89 0.01];
dark_red_color = [0.36 0 0.11];
fig_bg_color = [0.8 0.8 0.8];

blueRedColorOne = (dark_blue_color(1) - light_blue_color(1)) / 0.9;
blueRedColorTwo = dark_blue_color(1) - blueRedColorOne;
blueBlueColorOne = (dark_blue_color(2) - light_blue_color(2)) / 0.9;
blueBlueColorTwo = dark_blue_color(2) - blueBlueColorOne;
blueGreenColorOne = (dark_blue_color(3) - light_blue_color(3)) / 0.9;
blueGreenColorTwo = dark_blue_color(3) - blueGreenColorOne;

redRedColorOne = (dark_red_color(1) - light_red_color(1)) / 0.9;
redRedColorTwo = dark_red_color(1) - redRedColorOne;
redBlueColorOne = (dark_red_color(2) - light_red_color(2)) / 0.9;
redBlueColorTwo = dark_red_color(2) - redBlueColorOne;
redGreenColorOne = (dark_red_color(3) - light_red_color(3)) / 0.9;
redGreenColorTwo = dark_red_color(3) - redGreenColorOne;

load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');

load('BRAIN_SCHEME.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

v = VideoWriter(vid_name);
v.FrameRate = frame_rate;
open(v);

eLocation = all_loc(patients{1});

figure(1);
set(gcf,'color',fig_bg_color);
set(gcf,'Renderer','OpenGL');


 

for tNum = 1:number_of_time
    tNum

    elec_rows_matrix = [];
    elec_matrix = [];
    
    for fNum = 1:number_of_frequencies
        elec_rows = 0;
        
        for pNum = 1:number_of_patients
            eLocation = all_loc(patients{pNum});
            elec_field = getfield(IPtime2(patients{pNum}),'ip_all');

%             figure(1);
%             set(gcf,'color',fig_bg_color);
            IPvalue_matrix = elec_field(:,fNum,tNum);
            eSize = size(IPvalue_matrix,1);

                    for eNum = 1:eSize
                        IPvalue = IPvalue_matrix(eNum, 1);

                        if (IPvalue_matrix(eNum) >= IPthreshold) || (IPvalue_matrix(eNum) <= -IPthreshold)
                            x = eLocation(eNum, 1);
                            y = eLocation(eNum, 2);
                            z = eLocation(eNum, 3);
                            
                            if IPvalue > 0
                                color_value = IPvalue / max_threshold;
                                if color_value > 1
                                    color_value = 1;
                                end    
                                red_color = color_value * redRedColorOne + redRedColorTwo;
                                blue_color = color_value * redBlueColorOne + redBlueColorTwo;
                                green_color = color_value * redGreenColorOne + redGreenColorTwo;

                                c = [red_color blue_color green_color];	
                            else
                                color_value = IPvalue / -max_threshold;
                                if color_value > 1
                                    color_value = 1;
                                end   
                                red_color = color_value * blueRedColorOne + blueRedColorTwo;
                                blue_color = color_value * blueBlueColorOne + blueBlueColorTwo;
                                green_color = color_value * blueGreenColorOne + blueGreenColorTwo;

                                c = [red_color blue_color green_color];
                            end
                            patient_matrix = [x y z c];

                            elec_matrix = [elec_matrix;patient_matrix];
                            elec_rows = elec_rows + 1;
                        end
                    end
        end
        elec_rows_matrix = [elec_rows_matrix;elec_rows];
    end
%     ha = subtightplot((number_of_frequencies + 1), 1, [0.0 0.0]);
    
    subtightplot(number_of_frequencies + 2, number_of_views, [1 number_of_views], [0.0 0.0]);
    time_graph(tNum, fig_bg_color, word_on_time, word_off_time);

    
    subtightplot(number_of_frequencies+2, number_of_views, [number_of_views * number_of_frequencies + number_of_views + 1 number_of_views * number_of_frequencies + number_of_views + number_of_views], [0.0 0.0]);
    time_graph(tNum, fig_bg_color, word_on_time, word_off_time);

    
    fprintf("PLOTTING")
    hold on;
    
    for subplot_num = 1:number_of_frequencies; 
        
        row_count = 1;
        if subplot_num == 1
           row_for_this_frequency = elec_rows_matrix(1);
           row_start = 1; %what row the subplot should start on
        else
%             row_start = elec_rows_matrix(subplot_num - 1) + 1
            row_start = row_start + elec_rows_matrix(subplot_num - 1)
%             row_for_this_frequency = row_start - elec_rows_matrix(subplot_num)
            row_for_this_frequency = elec_rows_matrix(subplot_num)
        end
        testvar = row_for_this_frequency + row_start;
%         subtightplot(number_of_frequencies+2, number_of_views, subplot_num + 1, [0.0 0.0]);

        %         plot_brain; 
%         hold on;
%         plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
%         axis('off'); view(-90,0); zoom(1);camlight;
%         set(gca,'FontSize',20,'YLim',[-125 100],'ZLim',[-75 100])
        for current_view = 1: number_of_views
            subtightplot(number_of_frequencies+2, number_of_views, subplot_num * number_of_views + current_view, [0.0 0.0]);
            
            hold on;
            switch current_view
                case 1
                    plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
                    view(-90,0);
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
            set(gca,'FontSize',20,'YLim',[-125 100],'ZLim',[-75 100]);
                

                
            
            
            for row_number = row_start:(row_for_this_frequency + row_start - 1)
            markercolor = [elec_matrix(row_number,4) elec_matrix(row_number,5) elec_matrix(row_number,6)];
            x = elec_matrix(row_number,1);
            y = elec_matrix(row_number,2);
            z = elec_matrix(row_number,3);
            
            p = plot3(elec_matrix(row_number,1),elec_matrix(row_number,2),elec_matrix(row_number,3),'o','MarkerSize',circle_size,'Color',markercolor,'MarkerFaceColor',markercolor);
            p.Color(4) = 0.3;
            end
        ax2 = gca;
        ax2.TickLength = [0 0];
        axis('off');
        
        end
        
        
    end
    
%     caxes1 = axes;
%     cGrad1 = colorGradient(light_red_color, dark_red_color, 128);
%     colormap(cGrad1);
%     cBar1 = colorbar;
%     set(cBar1, 'Position', [.8314 .545 .0581 .26]);
%     
%     caxes2 = axes;
%     cGrad3 = colorGradient(dark_blue_color, light_blue_color, 128);
%     colormap(cGrad3);
%     cBar3 = colorbar;
%     set(cBar3, 'Position', [.8314 .175 .0581 .26]); 

    hold off;
    fprintf("DONE PLOTTING")
    
    frame = getframe(gcf);
    writeVideo(v,frame);
    clf;
    
end

hold off;
close(v);
fprintf("Done!");
toc