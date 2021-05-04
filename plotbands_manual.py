import re
import matplotlib.pyplot as plt
import numpy as np
from math import sqrt
#from scipy.interpolate import interp1d

#import numpy as np
#from math import sqrt

def cubic_interp1d(x0, x, y):
    """
    Interpolate a 1-D function using cubic splines.
      x0 : a float or an 1d-array
      x : (N,) array_like
          A 1-D array of real/complex values.
      y : (N,) array_like
          A 1-D array of real values. The length of y along the
          interpolation axis must be equal to the length of x.

    Implement a trick to generate at first step the cholesky matrice L of
    the tridiagonal matrice A (thus L is a bidiagonal matrice that
    can be solved in two distinct loops).

    additional ref: www.math.uh.edu/~jingqiu/math4364/spline.pdf 
    """
    x = np.asfarray(x)
    y = np.asfarray(y)

    # remove non finite values
    # indexes = np.isfinite(x)
    # x = x[indexes]
    # y = y[indexes]

    # check if sorted
    if np.any(np.diff(x) < 0):
        indexes = np.argsort(x)
        x = x[indexes]
        y = y[indexes]

    size = len(x)

    xdiff = np.diff(x)
    ydiff = np.diff(y)

    # allocate buffer matrices
    Li = np.empty(size)
    Li_1 = np.empty(size-1)
    z = np.empty(size)

    # fill diagonals Li and Li-1 and solve [L][y] = [B]
    Li[0] = sqrt(2*xdiff[0])
    Li_1[0] = 0.0
    B0 = 0.0 # natural boundary
    z[0] = B0 / Li[0]

    for i in range(1, size-1, 1):
        Li_1[i] = xdiff[i-1] / Li[i-1]
        Li[i] = sqrt(2*(xdiff[i-1]+xdiff[i]) - Li_1[i-1] * Li_1[i-1])
        Bi = 6*(ydiff[i]/xdiff[i] - ydiff[i-1]/xdiff[i-1])
        z[i] = (Bi - Li_1[i-1]*z[i-1])/Li[i]

    i = size - 1
    Li_1[i-1] = xdiff[-1] / Li[i-1]
    Li[i] = sqrt(2*xdiff[-1] - Li_1[i-1] * Li_1[i-1])
    Bi = 0.0 # natural boundary
    z[i] = (Bi - Li_1[i-1]*z[i-1])/Li[i]

    # solve [L.T][x] = [y]
    i = size-1
    z[i] = z[i] / Li[i]
    for i in range(size-2, -1, -1):
        z[i] = (z[i] - Li_1[i-1]*z[i+1])/Li[i]

    # find index
    index = x.searchsorted(x0)
    np.clip(index, 1, size-1, index)

    xi1, xi0 = x[index], x[index-1]
    yi1, yi0 = y[index], y[index-1]
    zi1, zi0 = z[index], z[index-1]
    hi1 = xi1 - xi0

    # calculate cubic
    f0 = zi0/(6*hi1)*(xi1-x0)**3 + \
         zi1/(6*hi1)*(x0-xi0)**3 + \
         (yi1/hi1 - zi1*hi1/6)*(x0-xi0) + \
         (yi0/hi1 - zi0*hi1/6)*(xi1-x0)
    return f0


arqxml = open("OUTPUT/CsSbClhse3.xml","r")
arqxmlr = arqxml.readlines()
inRecordingMode = False
Marray= []
kpoint= []
Kpoints= []
nowread = False
for line in arqxmlr:
#    xmldata = re.compile(r'<.*?>')
#    text_only = xmldata.sub('',line).strip()
    #match=re.search(r"k_point",line)
    if re.search(r"</starting_k_points",line):
        nowread = True
    if nowread:
        match_kpoints=re.search(r"<k_point .*>(.*)</k_point>",line)
        if match_kpoints:
            print(match_kpoints.group(1))
            for i in match_kpoints.group(1).split():        #print("EIGEN")
                kpoint.append(float(i))
            Kpoints.append(kpoint)
            kpoint= [] 
        if not inRecordingMode:
            if re.match(r"\s*<eigenvalues.*>", line):
                #print('detectou')
                inRecordingMode = True
                array= []
        else:
            if re.match(r"\s+</eigenvalues>", line):
            #    print("detectoufim")
                inRecordingMode = False
                Marray.append(array)
            else:
                for i in line.split():
                    print(i)
                    array.append(13.6056980659*float(i))
                    print(array)
arqxml.close()
print(Marray)
print(Kpoints)
kpointsarr=range(len(Kpoints))
#print(kpoint)                 
fig = plt.figure()
plt.axis([0, max(kpointsarr), -0.1, 5.2])
for i in range(len(Marray[0])):
    band=[]
    for j in range(len(Marray)):
        band.append(Marray[j][i])
##    bandinter = interp1d(kpointsarr, band, kind="cubic")
    kinterp = np.linspace(0,  max(kpointsarr), num=10*len(Kpoints), endpoint=True)
    bandinter= cubic_interp1d(kinterp, kpointsarr, band)
    plt.plot(kpointsarr, band,'--',lw=0.55,color='black')
    plt.plot(kinterp, bandinter,'-',lw=0.55,color='blue')

plt.show()
#fig.savefig('hse_bands.jpg', format='jpg', dpi=1000)


