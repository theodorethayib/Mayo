number_of_frequencies = 1;
number_of_patients = 1;
numer_of_time = 1;
number_of_electrodes = 72;
% IPthreshold = .2

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

for eNum = 1:number_of_electrodes
    elec_test = getfield(IPtime2(patients{1}),'ip_all');
    ePower = elec_test(:,1,1);
    
    testvar = ePower(eNum, 1);
    
    onoffvar = 0;
    
    if (ePower(eNum) >= 0.2) || (ePower(eNum) <= -.2)
        x = eLocation(eNum, 1);
        y = eLocation(eNum, 2);
        z = eLocation(eNum, 3);
        testnum = testnum + 1;
        
        onoffvar = 1;
    end
    
    testmatrix = [testmatrix;eNum testvar onoffvar];
    
    hold on;
    scatter3(x, y, z, 'filled');
end

hold off;

view(-90, 0);
plot_brain;
view(-90, 0);