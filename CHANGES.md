# changes on 10-9-2002 by Robert
- implemented end-effects for the tendons
- implemented a MEX version of `inf_medium_monopole` (17x speed increase)
- changed the default reference from average to infinite
- fixed a bug in `view_redraw`
- fixed the electrode distancxe in the biceps grid
- changed the default values for parameter scanning
- cosmetical changes

# changes on 10-9-2002 by Robert
- implemented multi-dimensional scanning (i.e. multiple parameters are
  varied over a specified range) as `compute_scan_all`
- changed parameter scanning, so that the minimum is automatically copied into
  the mu parameters

# changes on 10-7-2002 by Robert
- fixed a bug in the average referencing (the unconnected channels were not
  handled properly)
- changed the selection of referencing, instead of assigning a matrix to
  grid.ref, I now assign a string. The function `data_reference` knows what to
  do with it. The grid.monopolar and grid.average matrices are obsolete.
- changed the default parameters of the motor unit

# changes on 8-7-2002 by Robert
- modified the structure of the data of the `*.mat` file format
- re-ordered the menu items between "model" and "compute"

# changes on 4-7-2002 by Robert
- implemented the fitting and scanning of motor unit parameters, given a
  template potential

# changes on 3-7-2002 by Robert
- implemented an interface around the motor unit potential computation
