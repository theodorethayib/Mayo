% VARIABLES
number_of_frequencies = 1;
number_of_patients = 2;
number_of_time = 44;
number_of_electrodes = 72;
IPthreshold = 0.05;
frame_rate = 10;
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

% circle_color = light_blue_color;

sz = circle_size;
% c = circle_color;

load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');

v = VideoWriter('VidExport.avi');
v.FrameRate = frame_rate;
open(v);

% for tNum = 1:numer_of_time
%     elec_test = getfield(IPtime2(patients{1}),'ip_all');
%     eTest = elec_test(:,1,:);
%     figure();
%     x = elec_test(:,1,tNum);
%     scatter3(x, y, z, 'filled');
% end

eLocation = all_loc(patients{1});

testnum = 0;
testmatrix = [];

% plot_brain;
% view(-90, 0);

% pNum = 1;

for tNum = 1:number_of_time
%     eLocation = all_loc(patients{pNum});
%     elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
%     IPvalue = elec_field(:,:,:);
    plot_brain;
    view(-90, 0);
    tNum
    
    for pNum = 1:number_of_patients
        pNum
        eLocation = all_loc(patients{pNum});
        elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
        
        figure(1);
        IPvalue_matrix = elec_field(:,1,tNum);
        eSize = size(IPvalue_matrix,1);
        
            for fNum = 1:number_of_frequencies
%             doPlot = 0;

            fNum

                for eNum = 1:eSize
%                     plot_brain;
%                         view(-90, 0);
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

                        colormatrix = [colormatrix;IPvalue c];
%                         doPlot = 1;
                        
                        
                        hold on;
                        s = scatter3(x, y, z, sz, c, 'filled');     
                    end
                end
%                 hold on;
%     %             plot_brain;
%                 view(-90, 0);
%                 if doPlot == 1
%     %                 plot_brain;
%     %                 view(-90, 0);
%     %                 set(gca,'FontSize',12);
%     %                 hold on;
%     %                 subplot_1 = subplot(number_of_frequencies,1,fNum);
%                     s = scatter3(x, y, z, sz, c, 'filled');
%     %                 title('FREQUENCY');
%                 end
%                 plot_brain;
%                 hold off;
            end
        
%         frame = getframe(gcf);
%         writeVideo(v,frame);
%         clf;
    end
    
    frame = getframe(gcf);
    writeVideo(v,frame);
    clf;
    
end




hold off;
close(v);
fprintf("Done!");
% plot_brain;
% view(-90, 0);