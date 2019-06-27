% VARIABLES
number_of_frequencies = 1;
number_of_patients = 1;
number_of_time = 44;
number_of_electrodes = 72;
IPthreshold = 0.05;
frame_rate = 10;
circle_size = 25;
max_threshold = 0.5;

colormatrix = [];

% light_blue_color = [0.39 0.58 0.93];
% dark_blue_color = [0 0 .5];
% light_red_color = [1 0.4 0.4];
% dark_red_color = [0.6 0 0];
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

for tNum = 1:number_of_time
    eLocation = all_loc(patients{pNum});
    elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
%     IPvalue = elec_field(:,:,:);
    plot_brain;
    view(-90, 0);
    fprintf("time: " tNum);
    
    for pNum = 1:number_of_patients
        figure(1);
        IPvalue_matrix = elec_field(:,1,tNum);
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
                    red_color = color_value * -4/9 + 47/45;
                    blue_color = color_value * -4/9 + 4/9;
                    green_color = color_value * -4/9 + 4/9;

                    c = [red_color blue_color green_color];	
                else
                    color_value = IPvalue / -max_threshold;
                    if color_value > 1
                        color_value = 1;
                    end   
                    red_color = color_value * -13/30 + 13/30;
                    blue_color = color_value * -58/90 + 58/90;
                    green_color = color_value * -43/90 + 44/45;

                    c = [red_color blue_color green_color];
                end
                
                colormatrix = [colormatrix;IPvalue c];
                hold on;
                s = scatter3(x, y, z, sz, c, 'filled');     
            end
        end
        
        frame = getframe(gcf);
        writeVideo(v,frame);
        clf;
    end
    
    
end





% for pNum = 1:number_of_patients
%     eLocation = all_loc(patients{pNum});
%     elec_field = getfield(IPtime2(patients{pNum}),'ip_all');
% %     IPvalue = elec_field(:,:,:);
%     
%     for tNum = 1:number_of_time
%         figure(1);
%         IPvalue_matrix = elec_field(:,1,tNum);
%         eSize = size(IPvalue_matrix,1);
%         
%         for eNum = 1:eSize
%             IPvalue = IPvalue_matrix(eNum, 1);
% 
%             if (IPvalue_matrix(eNum) >= IPthreshold) || (IPvalue_matrix(eNum) <= -IPthreshold)
%                 x = eLocation(eNum, 1);
%                 y = eLocation(eNum, 2);
%                 z = eLocation(eNum, 3);
%                 testnum = testnum + 1;
%                 testmatrix = [testmatrix;eNum IPvalue pNum];
%                 
%                 if IPvalue > 0
%                     color_value = max_threshold / IPvalue;
%                     if color_value > 1
%                         color_value = 1;
%                     end    
%                     red_color = color_value * -4/9 + 47/45;
%                     blue_color = color_value * -4/9 + 4/9;
%                     green_color = color_value * -4/9 + 4/9;
% 
%                     c = [red_color blue_color green_color];	
%                 else
%                     color_value = -max_threshold / IPvalue;
%                     if color_value > 1
%                         color_value = 1;
%                     end   
%                     red_color = color_value * -13/30 + 13/30;
%                     blue_color = color_value * -58/90 + 58/90;
%                     green_color = color_value * -43/90 + 44/45;
% 
%                     c = [red_color blue_color green_color];
%                 end
%                 
%                 hold on;
%                 s = scatter3(x, y, z, sz, c, 'filled');     
%             end
%         end
%         
%         frame = getframe(gcf);
%         writeVideo(v,frame);
%     end
%     
%     
% end

% for tNum = 1:number_of_time
%     current_time = tNum;
%     figure(1);
%     
%     for eNum = 1:number_of_electrodes
%         elec_test = getfield(IPtime2(patients{1}),'ip_all');
%         ePower = elec_test(:,1,tNum);
% 
%         testvar = ePower(eNum, 1);
% 
%     %     onoffvar = 0;
% 
%         if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
%             x = eLocation(eNum, 1);
%             y = eLocation(eNum, 2);
%             z = eLocation(eNum, 3);
%             testnum = testnum + 1;
% 
%     %         onoffvar = 1;
% 
% %             testmatrix = [testmatrix;eNum testvar onoffvar];
% 
%             hold on;
%             s = scatter3(x, y, z, sz, c, 'filled');
%         end
% %         s.MarkerEdgeColor = 'b';
% %         s.LineWidth = 1;
% %         s.MarkerFaceColor = 'b';
%     %     testmatrix = [testmatrix;eNum testvar onoffvar];
% 
%         
%         
%     end
% %     hold on;
% %     scatter3(x, y, z, 'filled');
%     frame = getframe(gcf);
%     writeVideo(v,frame);
% end
hold off;
close(v);
fprintf("Done!");
% plot_brain;
% view(-90, 0);