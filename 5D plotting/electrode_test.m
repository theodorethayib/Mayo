% VARIABLES
number_of_frequencies = 1;
number_of_patients = 1;
numer_of_time = 44;
% number_of_electrodes = 72; % - this appears to change per patient -
IPthreshold = 0.8;

load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');
% eLocation = all_loc(patients{1});

% for tNum = 1:numer_of_time
%     elec_test = getfield(IPtime2(patients{1}),'ip_all');
%     eTest = elec_test(:,1,:);
%     figure();
%     x = elec_test(:,1,tNum);
%     scatter3(x, y, z, 'filled');
% end


testnum = 0;
testmatrix = [];

for pNum = 1:number_of_patients
    eLocation = all_loc(patients{pNum});
    elec_test = getfield(IPtime2(patients{pNum}),'ip_all');
    ePower = elec_test(:,:,:);
    
    number_of_electrodes = size(ePower,1);
    for eNum = 1:number_of_electrodes
        testvar = ePower(eNum, 1);
        if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
            x = eLocation(eNum, 1);
            y = eLocation(eNum, 2);
            z = eLocation(eNum, 3);
            testnum = testnum + 1;
            testmatrix = [testmatrix;eNum testvar pNum];
        end
    end
end

for eNum = 1:number_of_electrodes
    elec_test = getfield(IPtime2(patients{3}),'ip_all');
    ePower = elec_test(:,:,:);
    
    testvar = ePower(eNum, 1);
    
    if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
        x = eLocation(eNum, 1);
        y = eLocation(eNum, 2);
        z = eLocation(eNum, 3);
        testnum = testnum + 1;
        
%         onoffvar = 1;
        
        testmatrix = [testmatrix;eNum testvar];
        
%         hold on;
%         scatter3(x, y, z, 'filled');
    end
    
%     testmatrix = [testmatrix;eNum testvar onoffvar];
    
    hold on;
    scatter3(x, y, z, 'filled');
end


% 
% view(-90, 0);
plot_brain;
view(-90, 0);
hold off;