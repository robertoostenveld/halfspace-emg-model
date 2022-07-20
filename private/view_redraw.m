function varargout = view_redraw(h, eventdata, handles, varargin)
  data = guidata(h);

  if ~isempty(gcbf)
    % switch to the figure from which this callback was created 
    % this is the main figure with the menu bar etc.
    figure(gcbf);
  end

  delete(gca);
  hold on
  axis equal

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

  % draw grid
  if strcmp(get(findall(gcbf,'Tag','grid'),'Checked'), 'on') & isfield(data, 'grid')
    plot(data.grid.pnt(:,1), data.grid.pnt(:,2), 'k.');
  end

  tscale = [];
  zscale = [];

  % draw template potential
  if strcmp(get(findall(gcbf,'Tag','tp'),'Checked'), 'on') & isfield(data, 'time') & isfield(data, 'tp') & isfield(data, 'grid')
    pot = data_reference(data.tp, data.grid);
    % remember the scaling of the template potential
    [tscale, zscale] = elpos2(data.grid.pnt(:,1), data.grid.pnt(:,2), data.time, pot, [], [], 'b');
  end

  % draw model potential
  if strcmp(get(findall(gcbf,'Tag','pot'),'Checked'), 'on') & isfield(data, 'time') & isfield(data, 'pot') & isfield(data, 'grid')
    pot = data_reference(data.pot, data.grid);
    if isempty(zscale)
      % if scaling not known, remember the scaling of the model potential
      [tscale, zscale] = elpos2(data.grid.pnt(:,1), data.grid.pnt(:,2), data.time, pot, tscale, zscale, 'r');
    else
      % use the scaling of the template potential
      elpos2(data.grid.pnt(:,1), data.grid.pnt(:,2), data.time, pot, tscale, zscale, 'r');
    end
  end

  % draw potential difference
  if strcmp(get(findall(gcbf,'Tag','dif'),'Checked'), 'on') & isfield(data, 'time') & isfield(data, 'pot') & isfield(data, 'tp') & isfield(data, 'grid')
    pot1 = data_reference(data.pot, data.grid);
    pot2 = data_reference(data.tp, data.grid);
    pot = pot2 - pot1;
    % use the scaling of either template or model potential
    elpos2(data.grid.pnt(:,1), data.grid.pnt(:,2), data.time, pot, tscale, zscale, 'g');
  end

  % draw motor unit model
  if strcmp(get(findall(gcbf,'Tag','mu'),'Checked'),'on') & isfield(data, 'mu')
    abc = axis;
    % plot3(data.mu.pos(1), data.mu.pos(2), data.mu.pos(3), 'ro');
    plot(data.mu.pos(1), data.mu.pos(2), 'ro');

    bx = data.mu.pos(1) + 100*cos(data.mu.az*pi/180)*cos(data.mu.el*pi/180);
    by = data.mu.pos(2) + 100*sin(data.mu.az*pi/180)*cos(data.mu.el*pi/180);
    bz = data.mu.pos(3) + 100*sin(data.mu.el*pi/180);
    ex = data.mu.pos(1) - 100*cos(data.mu.az*pi/180)*cos(data.mu.el*pi/180);
    ey = data.mu.pos(2) - 100*sin(data.mu.az*pi/180)*cos(data.mu.el*pi/180);
    ez = data.mu.pos(3) - 100*sin(data.mu.el*pi/180);
    % line([bx, ex], [by, ey], [bz, ez], 'color', 'r');
    line([bx, ex], [by, ey], 'color', 'r');
    axis(abc);
  end

  zoom on
