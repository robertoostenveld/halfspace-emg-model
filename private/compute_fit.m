function varargout = compute_fit(h, eventdata, handles, varargin)

% if it is one of the options, then toggle the checked status
if ~strcmp(get(h,'tag'), 'fit') & strcmp(get(h,'checked'),'off')
  set(h,'checked','on');
else
  set(h,'checked','off');
end

% if it is the actual 'perform fit' option, then start fitting
if strcmp(get(h,'tag'), 'fit')
  data = guidata(gcbf);
  global fit_x
  global fit_y
  global fit_z
  global fit_tendon1
  global fit_tendon2
  global fit_az
  global fit_el
  global fit_cv
  global fit_on
  fit_x  = strcmp(get(findall(gcbf,'tag','fit_x'),'checked'),'on');
  fit_y  = strcmp(get(findall(gcbf,'tag','fit_y'),'checked'),'on');
  fit_z  = strcmp(get(findall(gcbf,'tag','fit_z'),'checked'),'on');
  fit_tendon1 = strcmp(get(findall(gcbf,'tag','fit_tendon1'),'checked'),'on');
  fit_tendon2 = strcmp(get(findall(gcbf,'tag','fit_tendon2'),'checked'),'on');
  fit_az = strcmp(get(findall(gcbf,'tag','fit_az'),'checked'),'on');
  fit_el = strcmp(get(findall(gcbf,'tag','fit_el'),'checked'),'on');
  fit_cv = strcmp(get(findall(gcbf,'tag','fit_cv'),'checked'),'on');
  fit_on = strcmp(get(findall(gcbf,'tag','fit_on'),'checked'),'on');

  % collect the default values for the parameters that have to be fitted
  count = 1;
  if fit_x
    param(count) = data.mu.pos(1);
    count = count+1;
  end
  if fit_y
    param(count) = data.mu.pos(2);
    count = count+1;
  end
  if fit_z
    param(count) = data.mu.pos(3);
    count = count+1;
  end
  if fit_tendon1
    param(count) = data.mu.tendon1;
    count = count+1;
  end
  if fit_tendon2
    param(count) = data.mu.tendon2;
    count = count+1;
  end
  if fit_az
    param(count) = data.mu.az;
    count = count+1;
  end
  if fit_el
    param(count) = data.mu.el;
    count = count+1;
  end
  if fit_cv
    param(count) = data.mu.cv;
    count = count+1;
  end
  if fit_on
    param(count) = data.mu.on;
    count = count+1;
  end

  % fit the parameters
  options = optimset('Display','iter');
  param = fminunc(@goal_function, param, options, data);

  % extract the parameters that have been fitted
  count = 1;
  if fit_x
    data.mu.pos(1) = param(count);
    count = count+1;
  end
  if fit_y
    data.mu.pos(2) = param(count);
    count = count+1;
  end
  if fit_z
    data.mu.pos(3) = param(count);
    count = count+1;
  end
  if fit_tendon1
    data.mu.tendon1 = param(count);
    count = count+1;
  end
  if fit_tendon2
    data.mu.tendon2 = param(count);
    count = count+1;
  end
  if fit_az
    data.mu.az = param(count);
    count = count+1;
  end
  if fit_el
    data.mu.el = param(count);
    count = count+1;
  end
  if fit_cv
    data.mu.cv = param(count);
    count = count+1;
  end
  if fit_on
    data.mu.on = param(count);
    count = count+1;
  end

  % store the updated data
  guidata(gcbf, data);

  % update the MU size and redraw the screen
  compute_size(h);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function err = goal_function(param, data);
  global fit_x
  global fit_y
  global fit_z
  global fit_tendon1
  global fit_tendon2
  global fit_az
  global fit_el
  global fit_cv
  global fit_on

  % extract the parameters that have to be fitted
  count = 1;
  if fit_x
    data.mu.pos(1) = param(count);
    count = count+1;
  end
  if fit_y
    data.mu.pos(2) = param(count);
    count = count+1;
  end
  if fit_z
    data.mu.pos(3) = param(count);
    count = count+1;
  end
  if fit_tendon1
    data.mu.tendon1 = param(count);
    count = count+1;
  end
  if fit_tendon2
    data.mu.tendon2 = param(count);
    count = count+1;
  end
  if fit_az
    data.mu.az = param(count);
    count = count+1;
  end
  if fit_el
    data.mu.el = param(count);
    count = count+1;
  end
  if fit_cv
    data.mu.cv = param(count);
    count = count+1;
  end
  if fit_on
    data.mu.on = param(count);
    count = count+1;
  end

  pot = mu_potential(data.mu, data.grid, data.time);
  err = error_function(data_reference(data.tp, data.grid), data_reference(pot, data.grid));

