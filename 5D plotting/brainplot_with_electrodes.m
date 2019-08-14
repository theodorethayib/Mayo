function brainplot_with_electrodes(vectors, faces, brain_color, elec_matrix, circle_size)
% 
% DESCRIPTION:
%   Plots electrodes individually on top of a brain surface.
%   This function is called by electrodes_vid_2.m
% 
% INPUT
%   (1) vectors = vectors of the brain surface (as specified by
%   BRAIN_SCHEME.mat)
%   (2) faces = faces of the brain surface (as specified by
%   BRAIN_SCHEME.mat)
%   (3) brain_color = color for the brain surface in a RGB triplet
%   (4) elec_matrix = 6 x N matrix where the first three columns contain
%   the X, Y, anx Z coordinates (respectively) for an electrode, and the
%   next three columns contain the R G B triplet colors (respectively) for
%   the color of the electrode.
%   (5) circle_size = marker size for plotting each electrode.
% 

plotsurf_wrapper(vectors, faces, brain_color);
    for vectRowNum = 1:size(elec_matrix,1)
        markercolor = [elec_matrix(vectRowNum,4) elec_matrix(vectRowNum,5) elec_matrix(vectRowNum,6)];
        plot3(elec_matrix(vectRowNum,1),elec_matrix(vectRowNum,2),elec_matrix(vectRowNum,3),...
            'o','MarkerSize',circle_size,'Color',markercolor,'MarkerFaceColor',markercolor);
    end
end