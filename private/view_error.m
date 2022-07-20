function varargout = view_error(h, eventdata, handles, varargin)

data = guidata(h);
if ~isfield(data, 'grid'), return, end
if ~isfield(data, 'time'), return, end
if ~isfield(data, 'mu'), return, end
if ~isfield(data, 'tp'), return, end

% compute the error between the model potential and the template potential
d1 = data_reference(data.tp, data.grid);
d2 = data_reference(data.pot, data.grid);
sel = find(~isnan(d1));
err = sum((d1(sel)-d2(sel)).^2) / sum(d1(sel).^2);

fprintf('\nThe residual variance is %4.1f %%\n', 100*err);
