% VARIABLES
tic
number_of_frequencies = 6;
number_of_patients = 139;
number_of_time = 2;
number_of_electrodes = 72;
IPthreshold = 0.05;
frame_rate = 5;
circle_size = 1;
max_threshold = 0.5;

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

v = VideoWriter('VidExportPlot3Test5.avi');
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
    ha = tight_subplot((number_of_frequencies + 1), 1, [0.0 0.0], [0.0 0.0], [0.0 0.0]);
    
    axes(ha(1));
    bar_graph = barh(tNum);
    ax = gca;
%     axes('Position',[0 0 .5 .5]);
    xlim([0 44]);
    xticks([8 37]);
%     xticklabels({'WORD ON','WORD OFF'});
    yticks([]);
    ax.TickDirMode = 'manual';
    ax.TickDir = 'in';
    ax.TickLength = [0.06 1];
    ax.XAxisLocation = 'top';
    set(gca,'Color',fig_bg_color);
    ylim([0.75 1.25]);
    text(8.5,1,'WORD ON','Color',fig_bg_color);
    
    if tNum < 8 || tNum > 37
        bar_graph.FaceColor = 'black';
    else
        bar_graph.FaceColor = 'red';
    end
    
    
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
        axes(ha(subplot_num + 1)); 
        plot_brain; 
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