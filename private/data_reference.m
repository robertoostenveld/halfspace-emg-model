function ref = data_reference(pot, grid);

% compute the re-referenced potential, keeping a special eye on the NaNs

% the potential can either be the model potential which is defined on all
% channels, or it can be the template potential which can be NaN on channels
% that are not connected

if ~isfield(grid, 'ref')
  % no re-referencing possible, since the grid does not specify a reference
  warning('no reference specified');
  ref = pot;
elseif strcmp(grid.ref, 'monopolar')
  % this is the default internal format for the potential data
  % and therefore no re-referencing is neccesary
  ref = pot;
elseif strcmp(grid.ref, 'average')
  % compute average reference over all non-NaN channels
  ref = zeros(size(pot));
  ref(find(~isnan(pot(:,1))),:) = avgref(pot(find(~isnan(pot(:,1))),:));
  ref(find( isnan(pot(:,1))),:) = NaN;
elseif strcmp(grid.ref, 'bipolar')
  % re-reference using the supplied bipolar linear derivation matrix
  tmp = pot;
  % set all unconnected channels to zero
  tmp(find(isnan(pot))) = 0;
  ref = grid.bipolar * tmp;
  % set all unconnected channels to NaN
  ref(find(isnan(pot))) = NaN;
else
  % no re-referencing possible, since the reference is unknown
  error('unknown reference');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ref = avgref(pot)
  ref = pot - repmat(mean(pot), size(pot,1), 1);

