function vertex3d_withAvailROI(V,F,CS,D,colorCLIM,viewAZEL,interpIt,isSlice,roiMask,...
         bCol,cMap,satControl)
%
% DESCRIPTION:
%   applies fill3 to the standard lab brain.  this lower level
%   function is called by plot_effect_on_surf_brain.m
%
% INPUT
%   (1) D = N x 1 (where N=number of verts on tal3d brain image) 
%           NaN = paints the defult color [.5 .5 .5]
%           val = paints an actual color
%           
%   (2) viewAzel = the view you want
%   (4) interpIt = interpolation vs. flat
%   (3) cLim = this sets the color limits of the interpolation  
%   (4) CS  = the facevertexdata of a hippocampal axial slice.
%             leave empty is you dont want to plot a slice
%   (5) cMap_OPT
%   (6) brainCol_OPT
%
% written by jfburke (john.fred.burke@gmail.com). 
% Modifications:
%  (1) 12/10: converted this function to be a standalone
%  (2) 12/23: added a quick plot feature.  plots 'Flat' patches,
%      i.e one color per patch. 
%  (3) 4/11: made V and F as direct inputs, which allows slices. 
%

% I think this is the brain color
if ~exist('bCol','var')||isempty(bCol)
  bCol = [0.5];
end
if ~exist('cMap','var')||isempty(cMap)
  lenColorMap   = 1000;
  CL_cMap       = myJet(lenColorMap);
else
  CL_cMap = cMap;
  lenColorMap = size(cMap,1);
end
if ~exist('satControl','var')||isempty(satControl)
  satControl    = .15;
end
fprintf('one')
if isSlice
  % CS contains indices from 1:125 of what the colr at a vertex
  % should be to recover the hippocampal outline.  ROUND CS because
  % actually the indices are not integers,,, they are off by very
  % small decimal places
  CS      = round(CS);
  BW_cMap = gray(125);
  FVCD    = BW_cMap(CS,:);
else
  FVCD    = repmat([bCol bCol bCol],size(V,1),1);
end
fprintf('two')
fprintf('   ')
if exist('roiMask','var') && ~isempty(roiMask)  
  roiMaskLimits = [1 colorCLIM];
  roiMaskVect   = linspace(roiMaskLimits(1),roiMaskLimits(2),lenColorMap);
  roiColVect    = linspace(bCol,0,lenColorMap);
  
  roiMaskOff = nan(size(FVCD,1),3);
  for k=1:size(roiMaskOff,1)
    [~,roiMaskInd]  = min(abs(roiMaskVect-roiMask(k)));
    roiMaskOff(k,:) = repmat(roiColVect(roiMaskInd),[1 3]);
  end

  if ~isSlice
    FVCD = FVCD-roiMaskOff;  
  else
    FVCDcorrected = FVCD-(1./bCol)*roiMaskOff; 
    FVCDcorrected(FVCDcorrected<0)=0;    
    FVCD=FVCDcorrected;
  end
end
fprintf('three')
% indices of all the significant vertices to plot
sigVind = find(~isnan(D));

% only select faces that have all vertices = significant 
sigF    = find(prod(double(ismember(F,sigVind)),2)==1);
insigF  = find(prod(double(ismember(F,sigVind)),2)==0);
fprintf('four')
% create the color map
midColInd     = lenColorMap/2;
LoBoundColInd = midColInd - round(lenColorMap*satControl);
HiBoundColInd = midColInd + round(lenColorMap*satControl);
lenLoBound    = length(LoBoundColInd+1:midColInd);
lenHiBound    = length(midColInd+1:HiBoundColInd);
CL_cMap(LoBoundColInd+1:midColInd,:) = repmat(CL_cMap(LoBoundColInd,:),lenLoBound,1);
CL_cMap(midColInd+1:HiBoundColInd,:) = repmat(CL_cMap(HiBoundColInd,:),lenHiBound,1);
colormap(CL_cMap);
if length(colorCLIM)==1
  set(gca,'CLim',[-colorCLIM colorCLIM])
elseif length(colorCLIM)==2
  set(gca,'CLim',[colorCLIM])
else
  error('bad CLIM value')
end
%f=gcf;
%figure
%colormap(CL_cMap);
%c=colorbar();
%set(c,'YTick',[0])
%figure(f)
fprintf('five')
% now go back and cover up all the areas with no electrodes
f_empty = F(insigF,:);
hold on
% hs = patch('faces',f_empty,'vertices',V,'edgecolor','none','facecolor',[.5 .5 .5]);
hs = patch('faces',f_empty,'vertices',V,'edgecolor','none','FaceColor',...
   'interp','FaceVertexCData',FVCD);
    
% interp the colors of each sig vertex
X = [V(F(sigF,1),1)';V(F(sigF,2),1)';V(F(sigF,3),1)'];
fprintf('X done')
Y = [V(F(sigF,1),2)';V(F(sigF,2),2)';V(F(sigF,3),2)'];
fprintf('Y done')
Z = [V(F(sigF,1),3)';V(F(sigF,2),3)';V(F(sigF,3),3)'];
fprintf('Z done')
C_raw = [D(F(sigF,1))';D(F(sigF,2))';D(F(sigF,3))'];
fprintf('C_raw done')
if interpIt
  C = C_raw;
  fprintf('interpIt true done')
else      
  C = mean(C_raw,1);
  fprintf('interpIt false done')
end
fprintf('done with interpIt test')
hBrain = fill3(X,Y,Z,C,'EdgeColor','none');
fprintf('six')
% get the shades of all vertices in each patch
CLIMVECTOR = linspace(-colorCLIM,colorCLIM,1000);
if ~isSlice
  patches_allVertShades = [FVCD(F(sigF,1),1) FVCD(F(sigF,2),1) FVCD(F(sigF,3),1)];
  ShadedPatches_inds    = find(sum(patches_allVertShades ~= bCol,2)>0);
  
  for k1=1:length(ShadedPatches_inds)
    thisInd = ShadedPatches_inds(k1);
    correctionFactor    = 1-(1./bCol)*(bCol-patches_allVertShades(thisInd,:));
    thisCData           = get(hBrain(thisInd),'CData');
%    actualCols_inds     = fix(...
%                       (thisCData-(-colorCLIM)) ./...
%         ((colorCLIM-(-colorCLIM))*lenColorMap)...
%                      )+1;
    [~,actualCols_inds(1)] = min(abs((CLIMVECTOR-thisCData(1))));
    [~,actualCols_inds(2)] = min(abs((CLIMVECTOR-thisCData(2))));
    [~,actualCols_inds(3)] = min(abs((CLIMVECTOR-thisCData(3))));
    actualCols          = CL_cMap(actualCols_inds,:);
    %actualCols_corrcted = actualCols-repmat(correctionFactor',1,3);
    actualCols_corrcted = actualCols.*repmat(correctionFactor',1,3);
    actualCols_corrcted(actualCols_corrcted<0)=0;
    set(hBrain(thisInd),'CDataMapping','direct');
    set(hBrain(thisInd),'FaceVertexCData',actualCols_corrcted);
    set(hBrain(thisInd),'CData',reshape(actualCols_corrcted,[3,1,3]));  
  end
else
  shadeFactor_vertsOnSigPatches = [roiMaskOff(F(sigF,1),1) roiMaskOff(F(sigF,2),1) roiMaskOff(F(sigF,3),1)];
  ShadedPatches_inds            = find(sum(shadeFactor_vertsOnSigPatches~=0,2)>0); 
  for k1=1:length(ShadedPatches_inds)
    thisInd = ShadedPatches_inds(k1);
    correctionFactor = 1-(1./bCol)*(shadeFactor_vertsOnSigPatches(thisInd,:));
    thisCData           = get(hBrain(thisInd),'CData');
    %    actualCols_inds     = fix(...
%                       (get(hBrain(thisInd),'CData')-(-colorCLIM)) ./...
%         ((colorCLIM-(-colorCLIM))*lenColorMap)...
%                      )+1;
    [~,actualCols_inds(1)] = min(abs((CLIMVECTOR-thisCData(1))));
    [~,actualCols_inds(2)] = min(abs((CLIMVECTOR-thisCData(2))));
    [~,actualCols_inds(3)] = min(abs((CLIMVECTOR-thisCData(3))));
    actualCols          = CL_cMap(actualCols_inds,:);
    actualCols_corrcted = actualCols.*repmat(correctionFactor',1,3);
    actualCols_corrcted(actualCols_corrcted<0)=0;
    set(hBrain(thisInd),'CDataMapping','direct');
    set(hBrain(thisInd),'FaceVertexCData',actualCols_corrcted);
    %set(hBrain(thisInd),'CData',reshape(actualCols_corrcted,[3,1,3]));  
  end
  
end
hold off
fprintf('seven')
% lighting phong    
% if ~isSlice
%   % you only need light with the brain surfae because the
%   % hippocampal slice is colored already
%   view(viewAZEL)
%   hLight = camlight('headlight');
%   set(hLight,'Color',[1 1 1],'Style','infinite');
%   setBrainProps(hBrain);
%   setBrainProps(hs);
% else
%   view([0 90])
%   setBrainProps(hs,true);
% end

% axis('off');
% % h=findobj('type','patch');
% % for k=1:length(h)
% %     set(h(k),'SpecularStrength',.1, ...
% % 	  'DiffuseStrength',.6, ...
% % 	  'SpecularColorReflectance',0, ...
% % 	  'AmbientStrength',.45);
% % end  
% set(gca,'XLim',[-75 75],'YLim',[-125 100],'ZLim',[-75 100]);
% zoom(1);
% view(viewAZEL);
% camlight;
% fprintf('eight');


