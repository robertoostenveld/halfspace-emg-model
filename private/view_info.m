function varargout = view_toggle(h, eventdata, handles, varargin)

  data = guidata(gcbf);
  if isfield(data, 'mu')
    fprintf('\nThe model parameters are\n');
    disp(data.mu);
  end
