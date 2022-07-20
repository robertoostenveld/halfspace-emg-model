function grid = grid_construct(nrows, ncols, dr, dc, flip);

% compute the electrode locations
% the rows are along the y-direction
% the columns are along the x-direction
% the first channel is in the upper left corner
nchans = nrows*ncols;
x = (1:ncols) *  dc; x = x-mean(x);
y = (1:nrows) * -dr; y = y-mean(y);
[xx, yy] = meshgrid(x, y);
grid.pnt = [xx(:) yy(:)];

% compute the reference matrices
grid.monopolar = eye(nchans);
grid.average   = eye(nchans) - ones(nchans)/nchans;
grid.bipolar   = eye(nchans);
for i=1:(nchans-1)
  grid.bipolar(i,i+1) = -1;
end
for i=nrows:nrows:nchans
  grid.bipolar(i,:) = NaN;
end

if nargin==5 & flip
  % swap the colums and the rows
  indx = zeros(nrows,ncols);
  indx(:) = 1:(nrows*ncols);
  indx = indx';
  indx = indx(:);
  grid.pnt       = grid.pnt(indx,:);
  grid.monopolar = grid.monopolar(indx,indx);
  grid.bipolar   = grid.bipolar(indx,indx);
  grid.average   = grid.average(indx,indx);
end
 
