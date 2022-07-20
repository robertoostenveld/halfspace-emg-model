function [pot] = mu_potential(mu, grid, time);

% MU_POTENTIAL computes the motor unit potential on the specified time
%
% pot = mu_potential(mu, grid, time)
%
% where
%   mu.pos	x,y,z position (z should be negative)
%   mu.az	azumuthal angle (in same plane as skin)
%   mu.el	elevation angle (towards skin)
%   mu.cv	conduction velocity
%   mu.on	onset moment of MU
%   mu.size	size of MU
%   mu.tendon1	length from end-plate towards the first  tendon (optional)
%   mu.tendon2	length from end-plate towards the second tendon (optional)
% and
%   grid.pnt	position of all electrodes (matrix with x and y position)
%

% (c) 2002, Robert Oostenveld

Npnt  = size(grid.pnt, 1);	% number of channels
Ntime = length(time);		% number of samples
pot   = zeros(Npnt, Ntime);	% potential for each channel and sample
D1    = 1;			% distance between monopoles for tripole
D2    = 3;			% distance between monopoles for tripole
cond  = 1;			% conductivity of medium

% compute the strength of each monopole
i1 =  1;
i2 = -1-D1/D2;
i3 =    D1/D2;

% compute the direction of propagation for the monopoles
[x, y, z] = sph2cart(mu.az*pi/180, mu.el*pi/180, 1);
ori = [x y z];

% use default for the length of the fibers from end-plate to the tendon
if ~isfield(mu, 'tendon1'); mu.tendon1 = Inf; end
if ~isfield(mu, 'tendon2'); mu.tendon2 = Inf; end

time = time - mu.on;
for i=1:Ntime
  t = time(i);

  % compute the length along the fiber that each of the three monopoles has traveled
  length1 = t*mu.cv;
  length2 = t*mu.cv-D1;
  length3 = t*mu.cv-D1-D2;

  % incorporate the start or end-plate effect, the propagation cannot be negative
  length1 = max(0, length1);
  length2 = max(0, length2);
  length3 = max(0, length3);

  % compute the position in 3D coordinates of three monopoles
  % incorporate the tendon effect, monopole cannot propagate past the tendon
  monop1 =  mu.pos + min(length1, mu.tendon1)*ori;
  monop2 =  mu.pos + min(length2, mu.tendon1)*ori;
  monop3 =  mu.pos + min(length3, mu.tendon1)*ori;
  % compute the potential due to each monopole
  pot(:,i) = i1*inf_medium_monopole(monop1, grid.pnt, cond) ...
           + i2*inf_medium_monopole(monop2, grid.pnt, cond) ...
           + i3*inf_medium_monopole(monop3, grid.pnt, cond);

  % compute the position in 3D coordinates of the opposite three monopoles
  % incorporate the tendon effect, monopole cannot propagate past the tendon
  monop1 =  mu.pos - min(length1, mu.tendon2)*ori;
  monop2 =  mu.pos - min(length2, mu.tendon2)*ori;
  monop3 =  mu.pos - min(length3, mu.tendon2)*ori;
  % compute the potential due to each monopole
  pot(:,i) = pot(:,i) ...
           + i1*inf_medium_monopole(monop1, grid.pnt, cond) ...
           + i2*inf_medium_monopole(monop2, grid.pnt, cond) ...
           + i3*inf_medium_monopole(monop3, grid.pnt, cond);
end

% scale the potential with the volume conductor boundary effect
% and with the MUP size
pot = -2 * pot * mu.size;

