function varargout = grid_biceps13x10(h, eventdata, handles, varargin)
  data = guidata(gcbf);
  data.grid = grid_construct(13,10,5,5,0);
  guidata(gcbf, data);
  compute_reference;

