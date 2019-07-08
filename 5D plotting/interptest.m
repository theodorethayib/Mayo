m = 2; n = 3; o = 4;
I = rand(m,n,o,10)% your frames
fr = 1:2:16;    % frame time


fri = 2:2:16 ;   % frame time to be inteprolated 
% Ii = zeros(m,n,length(fri)) ;   % initiliaze the interpolated frames 
%%inteproaltion 
for i =1:m
    for j = 1:n
        for k = 1:o
            I_ijk = squeeze(I2(i,j,k,:)) ;
            Ii_ijk = interp1(fr,I_ijk,fri,'spline') ;        
            Ii(i,j,k,:) = reshape(Ii_ijk,1,1,length(fri)) ;
        end
    end
end