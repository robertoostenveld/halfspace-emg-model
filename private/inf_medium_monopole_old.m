function [V] = inf_medium_monopole(rd, pnt, cond);

% INF_MEDIUM_MONOPOLE calculate the infinite medium potential 
% for a monopole at position rd in a medium with conductivity 
% cond and for an electrode located at pnt
%
% [V] = inf_medium_monopole(rd, pnt, cond)
%
% (c) Robert Oostenveld, 2002

Npnt     = size(pnt,1);
Vinf     = zeros(Npnt,1);
s1       = size(rd);

% make sure that the dipole position is a row-vector
if s1(1)>s1(2); rd = rd'; end

% make sure that electrode positions are defined in 3D 
% assume that z=0 if only 2D position is given
if size(pnt,2)==2; pnt = [pnt zeros(Npnt, 1)]; end

R = sum((pnt - repmat(rd, Npnt, 1)).^2, 2).^0.5;
V = 1 ./ (4*pi*cond*R);

