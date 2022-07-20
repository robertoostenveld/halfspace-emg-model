function varargout = emg_model(varargin);

% EMG_MODEL starts the graphical interface
%
% This is a infinite-halfspace model of a motor unit with
% endplate effects, but without tendon effects.
%
% The motor unit model can be computed for different electrode
% grids and using a monopolar or bipolar reference.
%
% A measured "template" potential can be read and compared
% to the model potential. Furthermore the model can be 
% fitted to the template potential.
%
% All driver and callback routines are implemented in the
% private subdirectory.
%
% (c) 2002, Robert Oostenveld

if nargin==0  % Launch the GUI

  % Create a new figure
  fig = figure('Name','EMG Model',...
               'NumberTitle','off',...
               'MenuBar','none',...
  	       'Position', [192, 134, 640, 480]);

  movegui(fig,'center');

  % Use system color scheme for figure:
  set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

  % Generate a structure of handles to pass to callbacks, and store it. 
  handles = guihandles(fig);
  figdata = guidata(fig);

  % Generate the toplevel menus
  file_menu = uimenu('Label','File');
  view_menu = uimenu('Label','View');
  model_menu = uimenu('Label','Model');
  compute_menu = uimenu('Label','Compute');

  % Generate the subitems for the file menu
  uimenu(file_menu,'Label','Open','Callback',{@file_open,handles},'Accelerator','O');
  uimenu(file_menu,'Label','Save','Callback',{@file_save,handles},'Accelerator','S');
  uimenu(file_menu,'Label','Close','Callback',{@file_close,handles});
  uimenu(file_menu,'Label','Quit','Callback','closereq','Separator','on','Accelerator','Q');

  % Generate the subitems for the view menu
  uimenu(view_menu,'Label','Grid','Callback',{@view_toggle,handles},'Tag','grid','Checked','on');
  uimenu(view_menu,'Label','Motor unit','Callback',{@view_toggle,handles},'Tag','mu','Checked','on');
  uimenu(view_menu,'Label','Model potential','Callback',{@view_toggle,handles},'Tag','pot','Checked','on');
  uimenu(view_menu,'Label','Template potential','Callback',{@view_toggle,handles},'Tag','tp','Checked','on');
  uimenu(view_menu,'Label','Potential difference','Callback',{@view_toggle,handles},'Tag','dif','Checked','off');
  uimenu(view_menu,'Label','Model information','Callback',{@view_info,handles},'Accelerator','I','Separator','on');
  uimenu(view_menu,'Label','Model error','Callback',{@view_error,handles},'Accelerator','E','Separator','off');
  uimenu(view_menu,'Label','Redraw','Callback',{@view_redraw,handles},'Separator','on','Accelerator','R');

  % Generate the subitems for the model and grid menu
  uimenu(model_menu,'Label','Define motor unit','Callback',{@model_unit,handles},'Accelerator','D');
  uimenu(model_menu,'Label','Define time','Callback',{@model_time,handles},'Accelerator','T');
  uimenu(model_menu,'Label','Biceps 13x10','Callback',{@grid_biceps13x10,handles},'Separator','on');
  uimenu(model_menu,'Label','Thenar 16x8','Callback',{@grid_thenar16x8,handles});
  uimenu(model_menu,'Label','Facial 12x5','Callback',{@grid_facial12x5,handles});
  uimenu(model_menu,'Label','Facial 10x6','Callback',{@grid_facial10x6,handles});
  uimenu(model_menu,'Label','Facial 4x8','Callback',{@grid_facial4x8,handles});
  uimenu(model_menu,'Label','Custom grid ...','Callback',{@grid_custom,handles});

  % Generate the subitems for the compute menu
  uimenu(compute_menu,'Label','Monopolar (infinite)','Tag','monopolar','Callback',{@compute_reference,handles},'Checked','on','Separator','off');
  uimenu(compute_menu,'Label','Monopolar (average)','Tag','average','Callback',{@compute_reference,handles},'Checked','off');
  uimenu(compute_menu,'Label','Bipolar','Tag','bipolar','Callback',{@compute_reference,handles},'Checked','off');
  uimenu(compute_menu,'Label','Compute potential','Callback',{@compute_potential,handles},'Accelerator','U','Separator','on');
  uimenu(compute_menu,'Label','Estimate size','Callback',{@compute_size,handles},'Separator','on');

  compute_scan_menu = uimenu(compute_menu,'Label','Parameter scan');
  uimenu(compute_scan_menu,'Tag','x', 'Label','location X','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','y', 'Label','location Y','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','z', 'Label','location Z','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','tendon1', 'Label','length to 1st tendon','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','tendon2', 'Label','length to 2nd tendon','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','az','Label','azimuth','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','el','Label','elevation','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','cv','Label','conduction velocity','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Tag','on','Label','onset time','Callback',{@compute_scan,handles});
  uimenu(compute_scan_menu,'Label','Scan all parameters ...','Callback',{@compute_scan_all,handles},'Separator','on');

  compute_fit_menu = uimenu(compute_menu,'Label','Parameter fit');
  uimenu(compute_fit_menu,'Tag','fit_x', 'Label','location X','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_y', 'Label','location Y','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_z', 'Label','location Z','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_tendon1', 'Label','length to 1st tendon','Callback',{@compute_fit,handles},'Checked','off');
  uimenu(compute_fit_menu,'Tag','fit_tendon2', 'Label','length to 2nd tendon','Callback',{@compute_fit,handles},'Checked','off');
  uimenu(compute_fit_menu,'Tag','fit_az','Label','azimuth','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_el','Label','elevation','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_cv','Label','conduction velocity','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit_on','Label','onset time','Callback',{@compute_fit,handles},'Checked','on');
  uimenu(compute_fit_menu,'Tag','fit','Label','Perform fit','Callback',{@compute_fit,handles},'Separator','on');

  data = [];
  % Read the demonstration/test data
  % load test
  guidata(fig, data);
  view_redraw(fig);

  if nargout > 0
    varargout{1} = fig;
  end

elseif ischar(varargin{1}) % Invoke the named subfunction or callback

  try 
    % FEVAL switchyard
    if (nargout)
      [varargout{1:nargout}] = feval(varargin{:});
    else
      feval(varargin{:});
    end
  catch
    disp('the FEVAL swithcyard caught an exception');
    disp(lasterr);
  end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all gui CALLBACKS are implemented as subfunctions in private
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

