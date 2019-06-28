% VARIABLES
number_of_frequencies = 6;
number_of_patients = 2;
number_of_time = 5;
number_of_electrodes = 72;
IPthreshold = 0.05;
frame_rate = 2;
circle_size = 25;
max_threshold = 0.5;

colormatrix = [];

light_blue_color = [0.52 1 0.99];
dark_blue_color = [0.14 0 0.34];
light_red_color = [0.99 0.89 0.01];
dark_red_color = [0.36 0 0.11];

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

sz = circle_size;

load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');

v = VideoWriter('VidExport.avi');
v.FrameRate = frame_rate;
open(v);

eLocation = all_loc(patients{1});

testnum = 0;
testmatrix = [];

for tNum = 1:number_of_time
    tNum

    elec_rows_matrix = [];
    elec_matrix = [];
    
    for fNum = 1:number_of_frequencies
        elec_rows = 0;
        
        for pNum = 1:number_of_patients
            pNum
            eLocation = all_loc(patients{pNum});
            elec_field = getfield(IPtime2(patients{pNum}),'ip_all');

            figure(1);
            IPvalue_matrix = elec_field(:,fNum,tNum);
            eSize = size(IPvalue_matrix,1);

                    for eNum = 1:eSize
                        IPvalue = IPvalue_matrix(eNum, 1);

                        if (IPvalue_matrix(eNum) >= IPthreshold) || (IPvalue_matrix(eNum) <= -IPthreshold)
                            x = eLocation(eNum, 1);
                            y = eLocation(eNum, 2);
                            z = eLocation(eNum, 3);
                            testnum = testnum + 1;
                            testmatrix = [testmatrix;eNum IPvalue pNum];

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


                            patient_matrix = [x y z sz c];

                            elec_matrix = [elec_matrix;patient_matrix];
                            elec_rows = elec_rows + 1;
                        end
                    end
        end
        elec_rows_matrix = [elec_rows_matrix;elec_rows];
    end
    ha = tight_subplot(6, 1, [0.0 0.0], [0.0 0.0], [0.0 0.0]);
    fprintf("PLOTTING")
    hold on;
    
    for subplot_num = 1:number_of_frequencies; 
        row_count = 1;
        if subplot_num == 1
           row_for_this_frequency = elec_rows_matrix(1);
           row_start = 1; %what row the subplot should start on
        else
            row_start = elec_rows_matrix(subplot_num - 1) + 1
            row_for_this_frequency = row_start - elec_rows_matrix(subplot_num)
        end
        axes(ha(subplot_num)); 
        plot_brain; 
        for row_number = row_start:(row_for_this_frequency + row_start)
            markercolor = [elec_matrix(row_number,5) elec_matrix(row_number,6) elec_matrix(row_number,7)];
            
            s = scatter3(elec_matrix(row_number,1),elec_matrix(row_number,2),elec_matrix(row_number,3),elec_matrix(row_number,4),markercolor,'filled');
            end
        end

    fprintf("DONE PLOTTING")
    
    frame = getframe(gcf);
    writeVideo(v,frame);
    clf;
    
end

hold off;
close(v);
fprintf("Done!");