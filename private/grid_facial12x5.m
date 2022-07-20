function varargout = grid_facial12x5(h, eventdata, handles, varargin)
  data = guidata(gcbf);
  data.grid = grid_construct(12,5,4,4,0);
  guidata(gcbf, data);
  compute_reference;

