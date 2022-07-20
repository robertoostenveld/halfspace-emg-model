function varargout = compute_size(h, eventdata, handles, varargin)

data = guidata(h);
if ~isfield(data, 'grid'), return, end
if ~isfield(data, 'time'), return, end
if ~isfield(data, 'mu'), return, end
if ~isfield(data, 'tp'), return, end

% compute the model potential with unit strength
data.mu.size = 1;
d1 = data_reference(data.tp, data.grid);
d2 = data_reference(mu_potential(data.mu, data.grid, data.time), data.grid);

% the best model estimate is d1 = d2 * a;
sel = find(~isnan(d1));
a = d2(sel) \ d1(sel);
fprintf('\nThe estimated motor unit size is %f\n', a);
data.mu.size = a;

% recompute the model potential
data.pot = mu_potential(data.mu, data.grid, data.time);

% store the updated data
guidata(h, data);
view_redraw(h);
