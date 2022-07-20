function varargout = file_open(h, eventdata, handles, varargin)

% open a file-selection dialog
[fname,pname] = uigetfile(...
      {'*.tpl;*.mat','Matlab (*.tpl, *.mat)';...
       '*.*','All files (*.*)'},...
      'Open file');
if ~fname, return; end

% get the data from the figure
data = guidata(h);

% determine the filetype by looking at the extension
ext = file_extension(fname);
fn  = fullfile(pname, fname);
switch ext

  case {'.tpl'}					% template file (MATLAB format)
    tmp = load('-mat', fn);
    if ~isfield(tmp, 'tp'), return, end
    if ndims(tmp.tp)==2
      data.tp = tmp.tp
    elseif ndims(tmp.tp)==3
      ans = inputdlg({'Template number:'},'Load',1,{'1'});
      if isempty(ans), return, end
      sel = str2double(ans);
      if sel<1 | sel>size(tmp.tp,3), return, end
      data.tp = squeeze(tmp.tp(:,:,sel));
    end

  case {'.mat'}					% MATLAB file
    tmp = load('-mat', fn);
    elem = fieldnames(tmp);
    for i=1:length(elem)
      data = setfield(data, elem{i}, getfield(tmp, elem{i}));
    end

    if isfield(data, 'mu')
      % these could be undefined if the motor unit was read from an old file
      if ~isfield(data.mu, 'tendon1'); data.mu.tendon1 = Inf; end
      if ~isfield(data.mu, 'tendon2'); data.mu.tendon2 = Inf; end
    end

  otherwise
    sprintf('Unknown filetype ''%s'', cannot read file ''%s''', ext, fname);
    errordlg(ans, 'Error');
end

if isfield(data, 'grid')
  % update the grid definition
  if strcmp(get(findall(gcbf,'Tag','monopolar'),'checked'),'on')
    data.grid.ref = 'monopolar';
  elseif strcmp(get(findall(gcbf,'Tag','average'),'checked'),'on')
    data.grid.ref = 'average';
  elseif strcmp(get(findall(gcbf,'Tag','bipolar'),'checked'),'on')
    data.grid.ref = 'bipolar';
  end
end

% put the data back in the figure
guidata(h, data);
view_redraw(h);

