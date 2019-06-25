load('BRAIN_SCHEME.mat'); %has what we need to plot a pretty brain wihtout going to Gold
vL = BRAIN_SCHEME{1};vR = BRAIN_SCHEME{3};
fL = BRAIN_SCHEME{2};fR = BRAIN_SCHEME{4};

hold on;plotsurf_wrapper(vL, fL, [0.7, 0.7, 0.7]);
% axis('off'); view(-90,0); camlight; zoom(1.4);
axis('off'); view(-90,0); camlight; zoom(1);
plotsurf_wrapper(vR, fR, [0.7, 0.7, 0.7]);
set(gca,'FontSize',20)

% You’ll have to zoom out and choose your view 