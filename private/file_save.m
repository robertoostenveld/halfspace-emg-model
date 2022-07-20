function varargout = file_save(h, eventdata, handles, varargin)

if length(varargin)==0
  % open a file-selection dialog
  [fname,pname] = uiputfile(...
	{'*.mat','Matlab (*.mat)'},...
	'Save data');
  if ~fname, return; end
end

% check whether the correct filetype is used for the extension
ext = file_extension(fname);
if ~strcmp(ext, '.mat')
  fname = [fname '.mat'];
end

% get the data from the figure
data = guidata(h);
field = {};
if isfield(data, 'mu')
  mu = data.mu;
  field{length(field)+1} = 'mu';
end
if isfield(data, 'time')
  time = data.time;
  field{length(field)+1} = 'time';
end
if isfield(data, 'grid')
  grid = data.grid;
  field{length(field)+1} = 'grid';
end
if isfield(data, 'pot')
  pot = data.pot;
  field{length(field)+1} = 'pot';
end
if isfield(data, 'tp')
  tp = data.tp;
  field{length(field)+1} = 'tp';
end

% save the data
save([pname filesep fname], field{:}); 

