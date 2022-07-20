#include <math.h>
#include "mex.h"
#include "matrix.h"

#define M_PI 3.1415926535897931

void
mexFunction (int nlhs, mxArray * plhs[], int nrhs, const mxArray * prhs[])
{
  mxArray *V;
  double *rd, *pnt, *cond, *V_p;
  double dx, dy, dz, s;
  int Nchan, Ndim, i;
  char str[256];

  if (nrhs!=3)
    mexErrMsgTxt ("Invalid number of input arguments");

  if (mxGetM(prhs[0])!=1 || mxGetN(prhs[0])!=3)
    mexErrMsgTxt ("Invalid dimension for input argument 1");
  if (mxGetN(prhs[1])!=2 && mxGetN(prhs[1])!=3)
    mexErrMsgTxt ("Invalid dimension for input argument 2");
  if (mxGetM(prhs[2])!=1 || mxGetN(prhs[2])!=1)
    mexErrMsgTxt ("Invalid dimension for input argument 3");

  rd   = mxGetData (prhs[0]);
  pnt  = mxGetData (prhs[1]);
  cond = mxGetData (prhs[2]);

  Nchan = mxGetM(prhs[1]);
  Ndim  = mxGetN(prhs[1]);

  // mexPrintf("Nchan = %d\n", Nchan);
  // mexPrintf("Ndim  = %d\n", Ndim);

  V   = mxCreateDoubleMatrix (Nchan, 1, mxREAL);
  V_p = mxGetData (V);

  s = 1/(4*M_PI*cond[0]); 

  for (i=0; i<Nchan; i++)
  {
    if (Ndim==2)
    {
      dx = rd[0] - pnt[0*Nchan+i];
      dy = rd[1] - pnt[1*Nchan+i];
      dz = rd[2];
    }
    else
    {
      dx = rd[0] - pnt[0*Nchan+i];
      dy = rd[1] - pnt[1*Nchan+i];
      dz = rd[2] - pnt[2*Nchan+i];
    }

    // compute the infinite medium potential for this electrode
    V_p[i] = s/sqrt(dx*dx + dy*dy + dz*dz);
  }

  // assign the output parameters
  plhs[0] = V;

  return;
}

