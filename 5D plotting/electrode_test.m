numer_of_time = 44;

for pNum = 1:numer_of_time
    elec_test = getfield(IPtime2(patients{1}),'ip_all');
    eTest = elec_test(2,2,:);
end