function varargout = view_toggle(h, eventdata, handles, varargin)

  if strcmp(get(h,'checked'),'off')
    set(h,'checked','on');
  else
    set(h,'checked','off');
  end
  view_redraw(gcbf);

