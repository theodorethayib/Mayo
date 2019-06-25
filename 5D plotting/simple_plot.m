% Data = load('all_loc.mat');
% load('all_loc.mat');
% Data = all_loc(patients{1});
% 
% x=Data(:,1);
% y=Data(:,2);
% z=Data(:,3);
% scatter3(x, y, z, 'filled');
% view(-90, 0);

number_of_patients = 139; %number of patients in data set
load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
for pNum = 1:number_of_patients %THIS WAY SEEMS FASTER FOR RIGHT NOW,
% THOUGH CAN NOT FIGURE OUT HOW TO SEE IF INDIVIDUAL ELECTRODES ARE ACTIVE
% OR INACTIVE
    Data = all_loc(patients{pNum});
    x = Data(:,1);
    y = Data(:,2);
    z = Data(:,3);
    hold on;
    scatter3(x, y, z, 'filled');
end
hold off;
fullData = all_loc(patients{1});


% x = fullData(:,1);
% y = fullData(:,2);
% z = fullData(:,3);
% hold on;
% scatter3(x, y, z, 'filled');
% hold off;




plot_brain;
view(-90, 0);

 