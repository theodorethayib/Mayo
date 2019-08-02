function cmap = myJet(n)
%function cmap = myjet(n)

if (nargin > 0)
    cmap = jet(n);
else
    cmap = jet();
end

cmap(1,:) = 1;
