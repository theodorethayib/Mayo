load('patients.mat');
load('all_loc.mat');
load('FINAL_AE2.mat');
load('IPtime2.mat');
load('hemispheres.mat');
load('BRAIN_SCHEME.mat');
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

plotThreshold = 4;

colMatrixLeft = NaN(size(vL,1),1);
colMatrixRight = NaN(size(vR,1),1);

eLocation = all_loc(patients{1});
elec_field = getfield(IPtime2(patients{1}),'ip_all');
IPvalue_matrix = elec_field(:,1,1);
eHemisphereFull = hemispheres(patients{1});
eSize = size(IPvalue_matrix,1);
for eNum = 1:eSize
    IPvalue = IPvalue_matrix(eNum, 1);
    if IPvalue > 0.05 || IPvalue < -0.05
        IPvalue = IPvalue * 2;
        if IPvalue >= 1
            IPvalue = 0.99;
        elseif IPvalue <= -1
            IPvalue = -0.99
        end
        x = eLocation(eNum, 1);
        y = eLocation(eNum, 2);
        z = eLocation(eNum, 3);
        if eHemisphereFull(eNum) == 1
            for vectRowNum = 1:size(vL,1)
                if eLocation(eNum,1) >= vL(vectRowNum,1) - plotThreshold && eLocation(eNum,1) <= vL(vectRowNum,1) + plotThreshold &&...
                        eLocation(eNum,2) >= vL(vectRowNum,2) - plotThreshold && eLocation(eNum,2) <= vL(vectRowNum,2) + plotThreshold &&...
                        eLocation(eNum,3) >= vL(vectRowNum,3) - plotThreshold && eLocation(eNum,3) <= vL(vectRowNum,3) + plotThreshold
                    if ~isnan(colMatrixLeft(vectRowNum,1))
                        colMatrixLeft(vectRowNum) = (IPvalue + colMatrixLeft(vectRowNum)) / 2;
                    else
                        colMatrixLeft(vectRowNum) = IPvalue;
                    end
                end
%                 if eLocation(eNum,1) >= vL(vectRowNum,1) - plotThreshold && eLocation(eNum,1) <= vL(vectRowNum,1) + plotThreshold
%                     if eLocation(eNum,2) >= vL(vectRowNum,2) - plotThreshold && eLocation(eNum,2) <= vL(vectRowNum,2) + plotThreshold
%                         if eLocation(eNum,3) >= vL(vectRowNum,3) - plotThreshold && eLocation(eNum,3) <= vL(vectRowNum,3) + plotThreshold
%                             if ~isnan(colMatrixLeft(vectRowNum,1))
%                                 colMatrixLeft(vectRowNum) = (IPvalue + colMatrixLeft(vectRowNum)) / 2;
%                             else
%                                 colMatrixLeft(vectRowNum) = IPvalue;
%                             end
%                         end
%                     end
%                 end
            end
        else
            for vectRowNum = 1:size(vR,1)
                if eLocation(eNum,1) >= vR(vectRowNum,1) - plotThreshold && eLocation(eNum,1) <= vR(vectRowNum,1) + plotThreshold
                    if eLocation(eNum,2) >= vR(vectRowNum,2) - plotThreshold && eLocation(eNum,2) <= vR(vectRowNum,2) + plotThreshold
                        if eLocation(eNum,3) >= vR(vectRowNum,3) - plotThreshold && eLocation(eNum,3) <= vR(vectRowNum,3) + plotThreshold
                             if ~isnan(colMatrixRight(vectRowNum,1))
                                colMatrixRight(vectRowNum) = (IPvalue + colMatrixRight(vectRowNum)) / 2;
                            else
                                colMatrixRight(vectRowNum) = IPvalue;
                            end
                        end
                    end
                end
            end
        end
    end
end
% subtightplot(8,5,1);
vertex3d_withAvailROI(vL,fL,[],colMatrixLeft,1,[-90 0],1,0);
% subtightplot(8,5,5);
figure(2);
vertex3d_withAvailROI(vR,fR,[],colMatrixRight,1,[90 0],1,0);


% camlight;
% h=findobj('type','patch');
% for k=1:length(h);
%     set(h(k),'SpecularStrength',.1, ...
% 	  'DiffuseStrength',.6, ...
% 	  'SpecularColorReflectance',0, ...
% 	  'AmbientStrength',.45);
% end  