function varargout = grid_gridsgen(h, eventdata, handles, varargin)

% ask the user for the grid definition
prompt = {'Number of rows (along y-axis):',...
          'Number of columns (along x-axis):',...
          'Distance between rows (mm)',...
          'Distance between columns (mm)',...
          'Flip rows and columns (0=no, 1=yes)'};
defaults = {'10', '6', '4', '4', '1'};
answer = inputdlg(prompt,'Define grid',1,defaults);

if ~isempty(answer)
  data = guidata(h);
  nrows = str2double(answer{1});
  ncols = str2double(answer{2});
  dr    = str2double(answer{3});
  dc    = str2double(answer{4});
  flip  = str2double(answer{5});
  data.grid = grid_construct(nrows, ncols, dr, dc, flip);
  guidata(h, data);
end
