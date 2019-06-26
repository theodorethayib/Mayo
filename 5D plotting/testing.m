% VARIABLES
number_of_frequencies = 1;
number_of_patients = 139;
numer_of_time = 44;
number_of_electrodes = 72;
IPthreshold = .05;

load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');

testnum = 0;
testmatrix = [];

for pNum = 1:number_of_patients
    elec_test = getfield(IPtime2(patients{pNum}),'ip_all');
    ePower = elec_test(:,:,:);
    
    eSize = size(ePower,1);
    for eNum = 1:eSize
        testvar = ePower(eNum, 1);
        if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
            testnum = testnum + 1;
            testmatrix = [testmatrix;eNum testvar pNum];
        end
    end
end