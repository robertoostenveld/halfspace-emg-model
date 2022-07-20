function varargout = grid_facial4x8(h, eventdata, handles, varargin)
  data = guidata(gcbf);
  data.grid = grid_construct(4,8,4,4,0);
  guidata(gcbf, data);
  compute_reference;
