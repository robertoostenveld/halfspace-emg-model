function varargout = compute_scan_all(h, eventdata, handles, varargin)

% get the global data from the figure handle
data = guidata(h);

% create a dialog
pos = get(0,'DefaultFigurePosition');
pos(1) = pos(1) + pos(3)/2 - 420/2;	% center horizontally
pos(3:4) = [380 300];
dlg = figure('Name','Scan parameters','Position',pos,'WindowStyle','normal','MenuBar','none','NumberTitle','off');

% create a frame with all entries for the scanning ranges
% uicontrol('units','pixels','position',[120 335 140 20],'Style','pushbutton','String','Read transformation ...','Callback',@read_file);

uicontrol('units','pixels','position',[040 240 40 20],'Style','text','String','x','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 210 40 20],'Style','text','String','y','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 180 40 20],'Style','text','String','z','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 150 40 20],'Style','text','String','az','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 120 40 20],'Style','text','String','el','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 090 40 20],'Style','text','String','cv','HorizontalAlignment','right');
uicontrol('units','pixels','position',[040 060 40 20],'Style','text','String','on','HorizontalAlignment','right');

uicontrol('units','pixels','position',[120 260 60 20],'Style','text','String','min','HorizontalAlignment','center');
uicontrol('units','pixels','position',[200 260 60 20],'Style','text','String','step','HorizontalAlignment','center');
uicontrol('units','pixels','position',[280 260 60 20],'Style','text','String','max','HorizontalAlignment','center');

uicontrol('units','pixels','position',[120 240 60 20],'Style','edit','Tag','x1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 240 60 20],'Style','edit','Tag','x2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 240 60 20],'Style','edit','Tag','x3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 210 60 20],'Style','edit','Tag','y1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 210 60 20],'Style','edit','Tag','y2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 210 60 20],'Style','edit','Tag','y3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 180 60 20],'Style','edit','Tag','z1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 180 60 20],'Style','edit','Tag','z2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 180 60 20],'Style','edit','Tag','z3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 150 60 20],'Style','edit','Tag','az1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 150 60 20],'Style','edit','Tag','az2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 150 60 20],'Style','edit','Tag','az3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 120 60 20],'Style','edit','Tag','el1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 120 60 20],'Style','edit','Tag','el2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 120 60 20],'Style','edit','Tag','el3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 090 60 20],'Style','edit','Tag','cv1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 090 60 20],'Style','edit','Tag','cv2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 090 60 20],'Style','edit','Tag','cv3','BackgroundColor','white');

uicontrol('units','pixels','position',[120 060 60 20],'Style','edit','Tag','on1','BackgroundColor','white');
uicontrol('units','pixels','position',[200 060 60 20],'Style','edit','Tag','on2','BackgroundColor','white');
uicontrol('units','pixels','position',[280 060 60 20],'Style','edit','Tag','on3','BackgroundColor','white');

% make OK and Cancel buttons which will close the dialog
uicontrol('units','pixels','position',[130 20 60 20],'String','OK'    ,'Callback','uiresume');
uicontrol('units','pixels','position',[210 20 60 20],'String','Cancel','Callback','uiresume; close');

% initialize the elements of this dialog using the current parameters of the motor-unit
set(findall(dlg,'Tag','x1'),'String',sprintf('%.0f',data.mu.pos(1)-10));
set(findall(dlg,'Tag','x2'),'String',sprintf('%.0f',               10));
set(findall(dlg,'Tag','x3'),'String',sprintf('%.0f',data.mu.pos(1)+10));

set(findall(dlg,'Tag','y1'),'String',sprintf('%.0f',data.mu.pos(2)-10));
set(findall(dlg,'Tag','y2'),'String',sprintf('%.0f',               10));
set(findall(dlg,'Tag','y3'),'String',sprintf('%.0f',data.mu.pos(2)+10));

set(findall(dlg,'Tag','z1'),'String',sprintf('%.0f',min(data.mu.pos(3)-10,-1)));
set(findall(dlg,'Tag','z2'),'String',sprintf('%.0f',                       10));
set(findall(dlg,'Tag','z3'),'String',sprintf('%.0f',min(data.mu.pos(3)+10,-1)));

set(findall(dlg,'Tag','az1'),'String',sprintf('%.0f',data.mu.az-45));
set(findall(dlg,'Tag','az2'),'String',sprintf('%.0f',           30));
set(findall(dlg,'Tag','az3'),'String',sprintf('%.0f',data.mu.az+45));

set(findall(dlg,'Tag','el1'),'String',sprintf('%.0f',data.mu.el-5));
set(findall(dlg,'Tag','el2'),'String',sprintf('%.0f',           5));
set(findall(dlg,'Tag','el3'),'String',sprintf('%.0f',data.mu.el+5));

set(findall(dlg,'Tag','cv1'),'String',sprintf('%.1f',max(data.mu.cv-1.0,0)));
set(findall(dlg,'Tag','cv2'),'String',sprintf('%.2f',                 0.66));
set(findall(dlg,'Tag','cv3'),'String',sprintf('%.1f',max(data.mu.cv+1.0,0)));

set(findall(dlg,'Tag','on1'),'String',sprintf('%.0f',max(data.mu.on-5,0)));
set(findall(dlg,'Tag','on2'),'String',sprintf('%.0f',                  5));
set(findall(dlg,'Tag','on3'),'String',sprintf('%.0f',max(data.mu.on+5,0)));

% process all events untill either OK or Cancel is pressed
uiwait(dlg);

if ishandle(dlg)
  % the dialog is still open, which means that the user pressed OK

  % get the values from the dialog
  x1 = str2double(get(findall(dlg,'Tag','x1'),'String'));
  x2 = str2double(get(findall(dlg,'Tag','x2'),'String'));
  x3 = str2double(get(findall(dlg,'Tag','x3'),'String'));

  y1 = str2double(get(findall(dlg,'Tag','y1'),'String'));
  y2 = str2double(get(findall(dlg,'Tag','y2'),'String'));
  y3 = str2double(get(findall(dlg,'Tag','y3'),'String'));

  z1 = str2double(get(findall(dlg,'Tag','z1'),'String'));
  z2 = str2double(get(findall(dlg,'Tag','z2'),'String'));
  z3 = str2double(get(findall(dlg,'Tag','z3'),'String'));

  az1 = str2double(get(findall(dlg,'Tag','az1'),'String'));
  az2 = str2double(get(findall(dlg,'Tag','az2'),'String'));
  az3 = str2double(get(findall(dlg,'Tag','az3'),'String'));

  el1 = str2double(get(findall(dlg,'Tag','el1'),'String'));
  el2 = str2double(get(findall(dlg,'Tag','el2'),'String'));
  el3 = str2double(get(findall(dlg,'Tag','el3'),'String'));

  cv1 = str2double(get(findall(dlg,'Tag','cv1'),'String'));
  cv2 = str2double(get(findall(dlg,'Tag','cv2'),'String'));
  cv3 = str2double(get(findall(dlg,'Tag','cv3'),'String'));

  on1 = str2double(get(findall(dlg,'Tag','on1'),'String'));
  on2 = str2double(get(findall(dlg,'Tag','on2'),'String'));
  on3 = str2double(get(findall(dlg,'Tag','on3'),'String'));

  % close this dialog
  close(dlg);

  % count the total number of parameter combinations
  num_x  = length(x1:x2:x3);
  num_y  = length(y1:y2:y3);
  num_z  = length(z1:z2:z3);
  num_az = length(az1:az2:az3);
  num_el = length(el1:el2:el3);
  num_cv = length(cv1:cv2:cv3);
  num_on = length(on1:on2:on3);
  num = num_x * num_y * num_z *num_az * num_el * num_cv * num_on;

  tic;
  mu.pos = [x1 y1 z1];
  mu.az = az1;
  mu.el = el1;
  mu.cv = cv1;
  mu.on = on1;
  mu.size = 1;
  pot = mu_potential(mu, data.grid, data.time);
  err = error_function(data_reference(data.tp, data.grid), data_reference(pot, data.grid));
  % estimate the total time that is needed to compute all combinations
  % correction with a factor >1 is needed for the memory and feedback overhead
  tmp = toc*num*1.2;	
  tmp_h = floor(tmp/3600);
  tmp_m = floor((tmp-3600*tmp_h)/60);
  tmp_s = floor((tmp-3600*tmp_h-60*tmp_m));
  msg = sprintf('Estimated time for the complete scan of all parameters is %02dh:%02dm:%02ds\n', tmp_h, tmp_m, tmp_s);
  ans = questdlg(msg, 'Estimated time', 'Continue', 'Cancel', 'Continue');
  if strcmp(ans,'Cancel')
    % do not perform the scanning of all parameters
    return  
  end
  clear mu err pot tmp msg ans;

  bar = waitbar(0, 'Scanning parameters','Name','Progress');
  % compute the error for each combination of motor-unit parameters
  i = 0;
  for x=x1:x2:x3
  for y=y1:y2:y3
  for z=z1:z2:z3
  for az=az1:az2:az3
  for el=el1:el2:el3
  for cv=cv1:cv2:cv3
  for on=on1:on2:on3
    i = i + 1;

    mu(i).pos = [x y z];
    mu(i).az = az;
    mu(i).el = el;
    mu(i).cv = cv;
    mu(i).on = on;
    mu(i).size = 1;
    pot = mu_potential(mu(i), data.grid, data.time);
    err(i) = error_function(data_reference(data.tp, data.grid), data_reference(pot, data.grid));

    % fprintf('--------------------------------------------------\n');
    % disp(mu(i));
    % fprintf('[%d/%d] error: %f\n', i, num, err(i));
    fprintf('%8d/%d (%5.1f%%)\n', i, num, 100*i/num);
    
    if ~mod(i, 10)
       % give some graphical feedback
       waitbar(i/num, bar);
    end
    
  end
  end
  end
  end
  end
  end
  end
  close(bar);

  % find the minimal error and the parameters that belong to it
  [tmp, i] = min(err);
  data.mu  = mu(i);

  % store the updated motor-unit back in the main window
  guidata(h, data);

  % update the MU size and redraw the screen
  compute_size(h);
end

