% function [patch_h, camlight_h] = render_freesurfer_3D(surface_filename)
% 
% Generates basic 3d rendering of freesurfer brain in matlab figure window
% 
% 
% 
% 
function [patch_h, camlight_h, vert, fcs] = render_freesurfer_3D(surface_filename)

    [vert, fcs] = freesurfer_read_surf(surface_filename);
    
    figure();
    ax = axes();
    patch_h = patch('vertices',vert, 'faces',fcs(:,[1 3 2]), 'facecolor',[.5 .5 .5],'edgecolor','none');
    daspect([1 1 1])
    lighting('phong')
    view([10 0 0])
    camlight_h = camlight('headlight');
    set(patch_h, 'SpecularExponent', 1000000)
    
    set(ax, 'Color', 'k');
%     cdata = zeros(180, 79, 128);

%     xmin=1; ymin=1; zmin=1;
%     xmax = xmin + size(cdata2, 1);
%     ymax = ymin + size(cdata2, 2);
%     zmax = zmin + size(cdata2, 3);
%     [x y z] = meshgrid(floor(xmin):ceil(xmax), floor(ymin):ceil(ymax), floor(zmin):ceil(zmax));
%     set(patch_h,'FaceColor','interp','EdgeColor','none')
%     isocolors(x,y,z,cdata2 ,patch_h);

    
end
