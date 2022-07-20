function varargout = compute_scan(h, eventdata, handles, varargin)

data = guidata(h);
if ~isfield(data, 'grid'), return, end
if ~isfield(data, 'time'), return, end
if ~isfield(data, 'mu'), return, end
if ~isfield(data, 'tp'), return, end

prompt  = {'Min:','Step:','Max:'};
title   = sprintf('Interval for parameter %s', get(h, 'Tag'));
lines   = 1;

% determine the default values for the dialog entries
mu   = data.mu;
elem = get(h, 'Tag');
if strcmp(elem, 'x')
  def = {sprintf('%.0f', mu.pos(1)-15), ...
         sprintf('%.0f', 1), ...
         sprintf('%.0f', mu.pos(1)+15)};
elseif strcmp(elem, 'y')
  def = {sprintf('%.0f', mu.pos(2)-15), ...
         sprintf('%.0f', 1), ...
         sprintf('%.0f', mu.pos(2)+15)};
elseif strcmp(elem, 'z')
  def = {sprintf('%.0f', min(mu.pos(3)-15,-1)), ...
         sprintf('%.0f', 1), ...
         sprintf('%.0f', min(mu.pos(3)+15,-1))};
elseif strcmp(elem, 'tendon1')
  def = {sprintf('%.0f', max(mu.tendon1-25,0)), ...
         sprintf('%.0f', 2.5), ...
         sprintf('%.0f', max(mu.tendon1+35,0))};
elseif strcmp(elem, 'tendon2')
  def = {sprintf('%.0f', max(mu.tendon2-25,0)), ...
         sprintf('%.0f', 2.5), ...
         sprintf('%.0f', max(mu.tendon2+35,0))};
elseif strcmp(elem, 'az')
  def = {sprintf('%.0f', mu.az-45), ...
         sprintf('%.0f', 5), ...
         sprintf('%.0f', mu.az+45)};
elseif strcmp(elem, 'el')
  def = {sprintf('%.0f', mu.el-15), ...
         sprintf('%.0f', 1), ...
         sprintf('%.0f', mu.el+15)};
elseif strcmp(elem, 'on')
  def = {sprintf('%.0f', max(mu.on-5,0)), ...
         sprintf('%.0f', 1), ...
         sprintf('%.0f', max(mu.on+5,0))};
elseif strcmp(elem, 'cv')
  def = {sprintf('%.1f', max(mu.cv-1.0,0)), ...
         sprintf('%.1f', 0.2), ...
         sprintf('%.1f', max(mu.cv+1.0,0))};
end

% create the input dialog for the minimum, stepsize and maximum value
answer  = inputdlg(prompt,title,lines,def);

if isempty(answer), return, end

min  = str2double(answer{1});
step = str2double(answer{2});
max  = str2double(answer{3});
value = min:step:max;

bar = waitbar(0, sprintf('Scanning parameter %s', get(h, 'Tag')), 'Name', 'Progress');
for i=1:length(value)
  if strcmp(elem, 'x')
    mu.pos(1) = value(i);
  elseif strcmp(elem, 'y')
    mu.pos(2) = value(i);
  elseif strcmp(elem, 'z')
    mu.pos(3) = value(i);
  else
    mu = setfield(mu, elem, value(i));
  end
  pot = mu_potential(mu, data.grid, data.time);
  err(i) = error_function(data_reference(data.tp, data.grid), data_reference(pot, data.grid));
  waitbar(i/length(value),bar);
  fprintf('%d\t%f\t: %f\n', i, value(i), err(i));
end
close(bar);

% show the resulting error of scanning this parameter in a new figure
fig = figure
plot(value, 100*err, '.-');
xlabel(elem)
ylabel('residual variance (%)')

% determine the minimum error and the associated parameter value
[tmp, i] = min(err);
if strcmp(elem, 'x')
  data.mu.pos(1) = value(i);
elseif strcmp(elem, 'y')
  data.mu.pos(2) = value(i);
elseif strcmp(elem, 'z')
  data.mu.pos(3) = value(i);
else
  data.mu = setfield(mu, elem, value(i));
end

% store the updated motor-unit back in the main window
guidata(h, data);

% update the MU size and redraw the screen
compute_size(h);

% ensure that the figure with the scan result in on the foreground
figure(fig);
