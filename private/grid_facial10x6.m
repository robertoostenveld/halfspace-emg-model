function varargout = grid_facial10x6(h, eventdata, handles, varargin)
  data = guidata(gcbf);
  data.grid = grid_construct(10,6,4,4,0);
  guidata(gcbf, data);
  compute_reference;

