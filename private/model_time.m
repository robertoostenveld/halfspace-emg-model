function varargout = model_define(h, eventdata, handles, varargin)

data = guidata(h);

prompt  = {'Sample frequency (Hz):','Number of samples:'};
title   = 'Time axis';
lines   = 1;
if ~isfield(data, 'time')
  def     = {'2000','60'};
else
  def     = {num2str(1000/(data.time(2)-data.time(1))), num2str(length(data.time))};
end
answer  = inputdlg(prompt,title,lines,def);

if ~isempty(answer)
  fs = str2double(answer{1});
  ns = str2double(answer{2});
  data.time = (0:(ns-1))*(1000/fs);
  guidata(h, data);
  compute_potential;
end
  
