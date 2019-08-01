% % VARIABLES
% number_of_frequencies = 1;
% number_of_patients = 139;
% numer_of_time = 44;
% number_of_electrodes = 72;
% IPthreshold = .05;
% 
% load('patients.mat');
% load('all_loc.mat');
% load('FINAL_AE2.mat');
% load('IPtime2.mat');
% 
% testnum = 0;
% testmatrix = [];
% 
% for pNum = 1:number_of_patients
%     elec_test = getfield(IPtime2(patients{pNum}),'ip_all');
%     ePower = elec_test(:,:,:);
%     
%     eSize = size(ePower,1);
%     for eNum = 1:eSize
%         testvar = ePower(eNum, 1);
%         if (ePower(eNum) >= IPthreshold) || (ePower(eNum) <= -IPthreshold)
%             testnum = testnum + 1;
%             testmatrix = [testmatrix;eNum testvar pNum];
%         end
%     end
% end

%  vertex3d_withAvailROI(vL,fL,[],0,1,[90 0],0,0)

load('BRAIN_SCHEME.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

% vertex3d_withAvailROI(vL,fL,[],cols,1,[90 0],0,0)
% vertex3d_withAvailROI(v2,f2,[],colors_test,1,[90 0],0,0)
