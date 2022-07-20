function varargout = grid_thenar16x8(h, eventdata, handles, varargin)
  data = guidata(gcbf);
  data.grid = grid_construct(16,8,3,3,0);
  guidata(gcbf, data);
  compute_reference;

