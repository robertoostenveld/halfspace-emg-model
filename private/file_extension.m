function [ext] = file_extension(filename);

% FILE_EXTENSION determines the extension from a filename

tmp = findstr(filename, '.');
if ~isempty(tmp)
  tmp = tmp(length(tmp));
  ext = filename(tmp:end);
else
  ext = '';
end

