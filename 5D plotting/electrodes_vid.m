% VARIABLES
number_of_frequencies = 1;
number_of_patients = 1;
number_of_time = 44;
number_of_electrodes = 72;
IPthreshold = 0.05
frame_rate = 2;
circle_size = 25;
circle_color = 'b';

sz = circle_size;
c = circle_color;

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

plot_brain;
view(-90, 0);

for tNum = 1:number_of_time
    current_time = tNum;
    figure(1);
    
    for eNum = 1:number_of_electrodes
        elec_test = getfield(IPtime2(patients{1}),'ip_all');
        ePower = elec_test(:,1,tNum);

        testvar = ePower(eNum, 1);

    %     onoffvar = 0;

        if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
            x = eLocation(eNum, 1);
            y = eLocation(eNum, 2);
            z = eLocation(eNum, 3);
            testnum = testnum + 1;

    %         onoffvar = 1;

%             testmatrix = [testmatrix;eNum testvar onoffvar];

            hold on;
            s = scatter3(x, y, z, sz, c, 'filled');
        end
%         s.MarkerEdgeColor = 'b';
%         s.LineWidth = 1;
%         s.MarkerFaceColor = 'b';
    %     testmatrix = [testmatrix;eNum testvar onoffvar];

        
        
    end
%     hold on;
%     scatter3(x, y, z, 'filled');
    frame = getframe(gcf);
    writeVideo(v,frame);
end
hold off;
close(v);
fprintf("Done!");
% plot_brain;
% view(-90, 0);