function [tscale, zscale] = elpos2(x, y, t, z, tscale, zscale, varargin);

% ELPOS2 make timecourse plot of val on ungridded positions (x,y)
% this is an alternative implementation of elpos
%
%  elpos(x, y, time, val)
%
%  where each row of val contains the data to be plotted at one (x,y) position
%  and therefore size(val) = [length(x), length(time)]

% (c) Robert Oostenveld, 2002

N = length(x);

xdif = min(diff(unique(x)));
ydif = min(diff(unique(y)));

if nargin<5 | isempty(tscale)
  tscale = 0.8 * xdif/range(t);
end

if nargin<6 | isempty(zscale)
  zscale = 1.0 * ydif/range(z(:));
end

flag = ishold;
hold on
for i=1:N
  val_t = x(i) + tscale * t;
  val_z = y(i) + zscale * z(i,:);
  plot(val_t, val_z, varargin{:});
end
if ~flag, hold off, end
 
