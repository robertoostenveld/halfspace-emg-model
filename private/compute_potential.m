function varargout = compute_potential(h, eventdata, handles, varargin)

  % compute the motor unit potential on the electrode grid
  data = guidata(gcbf);
  if isfield(data, 'time') & isfield(data, 'grid') & isfield(data, 'mu')
    data.pot = mu_potential(data.mu, data.grid, data.time);
    guidata(gcbf, data);
  end
  view_redraw(gcbf);
