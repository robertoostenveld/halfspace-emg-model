function varargout = compute_reference(h, eventdata, handles, varargin)

% select which type of reference to use in the computation of the 
% model potential and in the fitting of the model to the template potential

data = guidata(gcbf);

if nargin>0
  % toggle the reference flag in the dialog
  set(findall(gcbf,'Tag','monopolar'),'checked','off')
  set(findall(gcbf,'Tag','average'),'checked','off')
  set(findall(gcbf,'Tag','bipolar'),'checked','off')
  set(h,'checked','on');
end

% update the grid definition
if strcmp(get(findall(gcbf,'Tag','monopolar'),'checked'),'on')
  data.grid.ref = 'monopolar';
elseif strcmp(get(findall(gcbf,'Tag','average'),'checked'),'on')
  data.grid.ref = 'average';
elseif strcmp(get(findall(gcbf,'Tag','bipolar'),'checked'),'on')
  data.grid.ref = 'bipolar';
end

guidata(gcbf, data);
view_redraw(gcbf);

