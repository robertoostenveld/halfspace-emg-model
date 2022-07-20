function err = error_function(d1, d2);

% compute the error between the model potential (d2) and the template potential (d1)
% with the optimal scaling (a) of the motor-unit size to minimize this error

% leave out all channels that are NaN
sel = find(~isnan(d1));

% the best model estimate is d1 = d2 * a;
a = d2(sel) \ d1(sel);
err = sum((d1(sel)-a*d2(sel)).^2) / sum(d1(sel).^2);

