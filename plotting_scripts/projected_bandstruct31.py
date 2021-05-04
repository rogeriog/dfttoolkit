#!/usr/bin/env python
###################### HERE CUSTOMIZATION IS NEEDED ######################################
## files needed
PREFIX="CsSbIH-Nb"
filedos='./'+PREFIX+'.dos'  ## dos file from QE ## will be used only to find fermi if not given
filepdos="./out."+PREFIX+".pdos"  ## pdos output of a bandstructure calculation  ## contains most of data we need
symfile="./out."+PREFIX+".bands"  ## bands output of bandstructure calculation ## contains high symmetry k points


indexes=['$\Gamma$','Y','$F_0$','$\Delta_0$','$\Gamma$','Z','B$_0$','G$_0$','T','Y',
         '$\Gamma$','S','R','Z','T']
            ## these are the indexes of the bandstructure
 #   Γ—Y—F0|Δ0—Γ—Z—B0|G0—T—Y|Γ—S—R—Z—T  ## band path hexagonal CsSbI 63/mmc
 #   Γ—X—S—Y—Γ—Z—U—R—T—Z|X—U|Y—T|S—R   ## band path ortorhombic CsSbCl 

fermi = 0  ## keeping 0 the script will look for fermi value in filedos file.
RANGE_VB=3 ## ev to plot below efermi
RANGE_CB=7 ## ev to plot above efermi

## COLOR ASSIGNMENT
## to fill appropriatedly run beforehand this script with "checkstates" argument.
## once you write down the states youre interested to color in the bandstructure proceed.
## the numbers given are the number after # in the states list given by checkstates run.
redstates=[]  ## states colored red, you can always give range(92,96)
greenstates=[]  ## states colored green
bluestates=range(160,173)  ## states colored blue, no states with []
## notice if there is overlapping colors will blend

maxcontrast=True  ## notice if maxcontrast=0, color will be as strong as the state proportion, 
#usually this contribution is very low compared to total, therefore maxcontrast is default.
contrast_ratios=[1,0.5,0.5]  ## only if maxcontrast true # values should be in 0-1 range
#in this example red will be 2 times more intense than highest green and blue.

########### MANUAL INDEXING ##################################
# maybe the script does not position the labels of high symmetry appropriatedly, this section is to correct
# this problem manually, as well as few changes on plot settings
manual_indexing=False
indexes_pos=[]  ## ought to have same size of indexes list

########### LEAVE EVERYTHING ELSE AS IT IS, EXCEPT IF YOU KNOW WHAT YOURE DOING ##########


import re
import numpy as np
from math import sqrt
import matplotlib.pyplot as plt
import os,sys
import matplotlib as mpl
from matplotlib.collections import LineCollection
from matplotlib.ticker import MultipleLocator, FormatStrFormatter


## following snips determine fermi energy, if spin polarized and pdos file type.
if fermi == 0 :
    try:
        with open(filedos) as f:
            first_line = f.readline()
            result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
            fermi=round(float(result[0]),3)
    except IOError:
        print("Dos file not accessible, cannot proceed.")
print("Fermi ",fermi)

nspin=-1 ## have to declare first otherwise is local
try:
    with open(filedos) as f:
        lines = f.readlines()
        if len(lines[2].split()) > 3:
            nspin=True
            print("Spin polarized detected. Up and down spins will be plotted in the same sections. ",fermi)
        else:
            nspin=False
            print("This calculation is not spin polarized",fermi)
except IOError:
    print("Dos file not accessible, cannot proceed.")


bandtype=-1 ## energies dont have ==== in pdos file
try:
    with open(filepdos) as f:
        pdosdata = f.read()  ## gets all data in single string
        if pdosdata.find("==== e") == -1:
            bandtype=1
            print("Bandtype 1. ")
        else:
            bandtype=0
            print("Bandtype 0. ")
except IOError:
    print("Dos file not accessible, cannot proceed.")

def modulo(x,y):
    """Module of the difference between two vectors"""
    return np.linalg.norm(np.subtract(x,y))

### this will allow to plot specific states as different colors
def rgbline(x, y, red, green, blue, alpha=1, linestyles="solid",
            linewidth=2.5):
    """Get a RGB coloured line for plotting.
    Args:
        x (list): x-axis data.
        y (list): y-axis data (can be multidimensional array).
        red (list): Red data (must have same shape as ``y``).
        green (list): Green data (must have same shape as ``y``).
        blue (list): blue data (must have same shape as ``y``).
        alpha (:obj:`list` or :obj:`int`, optional): Alpha (transparency)
            data (must have same shape as ``y`` or be an :obj:`int`).
        linestyles (:obj:`str`, optional): Linestyle for plot. Options are
            ``"solid"`` or ``"dotted"``.
    """
    y = np.array(y)
    if len(y.shape) == 1:
        y = np.array([y])
        red = np.array([red])
        green = np.array([green])
        blue = np.array([blue])
        alpha = np.array([alpha])
    elif isinstance(alpha, int):
        alpha = [alpha] * len(y)

    seg = []
    colours = []
    for yy, rr, gg, bb, aa in zip(y, red, green, blue, alpha):
        pts = np.array([x, yy]).T.reshape(-1, 1, 2)
        seg.extend(np.concatenate([pts[:-1], pts[1:]], axis=1))

        nseg = len(x) - 1
        r = [0.5 * (rr[i] + rr[i + 1]) for i in range(nseg)]
        g = [0.5 * (gg[i] + gg[i + 1]) for i in range(nseg)]
        b = [0.5 * (bb[i] + bb[i + 1]) for i in range(nseg)]
        a = np.ones(nseg, np.float) * aa
        colours.extend(list(zip(r, g, b, a)))

    lc = LineCollection(seg, colors=colours, rasterized=True,
                        linewidth=linewidth, linestyles=linestyles)
    return lc

## cubic interpolation is necessary for our bands
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
       # print(2*(xdiff[i-1]+xdiff[i]) - Li_1[i-1] * Li_1[i-1])
       # print(i,ydiff)
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


def Symmetries(fstring):
  f = open(fstring,'r')
  x = np.zeros(0)
  for i in f:
    if "high-symmetry" in i:
      x = np.append(x,float(i.split()[-1]))
  f.close()
  return x

## define bandtype as there are two types of pdos file in QE

## the following loop will look on filepdos file and find in the text, first the different states contained in the structure,
## each orbital of each atom will produce a different state. Its important to know these states so as to find the
## contributions we want colored in the final plot.
## the code will look then for each kpoint and add to the kpoints array and look for each energy of this kpoint
## this will be the raw bandplot, without the compositions
kpoints=[]
fullenergykpts=[]
energykpt=[]
states=[]
with open(filepdos, "r") as f:
    lines=f.readlines()
    for line in lines:
        state=re.findall(r"^\s*state(.*)",line)
        if state != []: 
            states.append([re.findall(r".*(#\s*[0-9]*):.*",state[0]), state]) 
#            states.append(state)
        if line.startswith(" k"):
            kpt = re.findall(r"([0-9]\.[0-9]+)",line)
            kpoints.append(list(map(float,kpt)))
            if energykpt != [] :  ## to close energykpt if new kpoint is found
                fullenergykpts.append(list(map(float,energykpt)))
                energykpt=[]
#        energyk=re.findall(r"^====.*=.*(-?[0-9]\.[0-9]+).*",line)
        if bandtype == 0 : ## there are two band types in .pdos in QE, have to check beforehand
            if line.startswith("===="):
            #energyk=re.findall(r"^====*.*(.[0-9]+\.[0-9]+).*",line)[0]
                energyk=re.findall(r"^====*.* ([-+]?\d+\.\d+).*",line)[0]
                energykpt.append(energyk)
        if bandtype == 1 :
            if re.match(r'\s+e =', line):
                energyk=re.findall(r"^\s*e =*.* ([-+]?\d+\.\d+).*",line)[0]
                energykpt.append(energyk)
        if line.startswith("   JOB DONE."):  ## check job done and appends last energykpt
            fullenergykpts.append(list(map(float,energykpt)))
            energykpt=[]
fullenergykpts=np.array(fullenergykpts)

################ CHECKSTATES RUN #############################
if (len(sys.argv)>1) and (sys.argv[1] == "checkstates"):
    for i in range(len(states)):
        print(states[i][1][0])
    sys.exit()  ### check states will only print the states to check which ones to plot colored
#######################################################################################

## states executed before gave state found in the format '# N' and the line found, we just want the '# N' match.
statesidx=[ states[i][0][0] for i in range(len(states))]

## once raw band with number of kpoints and energies for each was found, we declare an zeroed
## numpy array that will contain the value of contribution of each state for each energy of each kpoint
projections=np.zeros((len(kpoints),len(fullenergykpts[0]),len(states)))

## before filling projections array, we need to estabilish the kpointspath coordinate,
##  this will be the x of our bandstructure. There are complications when the band is divided in sections.
mod=0
mod_section_list=[0]
fullkpointspath=[0]
## creates kpoint list direct from file
for i in range(len(kpoints)-1): 
   mod=modulo(kpoints[i+1],kpoints[i])+mod
   fullkpointspath.append(mod) 
   ## the kpoints in reciprocal space have their distance calculated, there will be huge differences when
   ## the band structure is discontinuous.
##find sections of kpointspath where there is band discontinuity, a 0.2 value of change is taken as enough
## for a discontinuity to be defined, usually the difference in kpoints should be less than 0.1 in a good
## band structure.
bandsections=np.where(np.diff(fullkpointspath)>0.2)[0]+1 ## add 1 because ndiff takes the previous value
print(" A total of %2d sections were found. Is that what you expected? " % (len(bandsections)+1) )
### bandsections holds indexes of the discontinuity the fullkpointspath 
bandsections=np.insert(bandsections, 0, 0, axis=0)  ## add 0 in beginning
bandsections=np.insert(bandsections, len(bandsections), -1, axis=0) 


## add last term as -1, that is, end of kpointspath

## calculate the path differences to correct the discontinuities and have continuous x along the kpath
endpath=[fullkpointspath[i-1] for i in bandsections[1:-1]] 
beginnextpath=[fullkpointspath[i] for i in bandsections][1:-1]
pathdifferences=np.array(beginnextpath)-np.array(endpath)
pathdifferences=np.insert(pathdifferences, 0, 0, axis=0)  ## add 0 in beginning
pathdifferences=np.cumsum(pathdifferences)  ## pathdifferences is cummulative 
## pathdifference will be subtracted on each beggining of subsection.

### kpoints path subdivided
### there is a calculation of deltas which is the normalized size of each subsection
### this comes handy for the plotting of the final bandstructure to be proportional
### to the size of each section.
bandsections=list(bandsections[:-1])+[None]  
## had to change bandsections again otherwise kpointspath is cut short in last section
deltas=[]
kpointspaths=[]
lastkpointcoord=0
fullkpointspath=np.array(fullkpointspath)
for m in range(len(bandsections)-1):
      kpointspath=fullkpointspath[bandsections[m]:bandsections[m+1]]-pathdifferences[m]
      kpointspaths.append(kpointspath)
      deltas.append(max(kpointspath)-min(kpointspath))
deltas=np.array(deltas)  
sumdelta=np.sum(np.array(deltas))
deltas=deltas/sumdelta

## if spin polarized there will be double of sections detected, have to convolute these in the same graph
if nspin:
    n_bandsections=int((len(bandsections)-1)/2)  ## bandsections will be half
    fig, ax = plt.subplots(1,n_bandsections,sharey=True,
                       squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas[:-n_bandsections]})

else:
    n_bandsections=(len(bandsections)-1)
    fig, ax = plt.subplots(1,n_bandsections,sharey=True,
                       squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas})

if n_bandsections == 2: ## no subsections on band plot
    ax=[ax]  ## no subscript problem



hspoints = Symmetries(symfile)
print("A total of %2d highsymmetry points were found by QE. Is that expected?" % (len(hspoints)))
## hspoints contains the points found in symfile the out.prefix.bands file in which 
# QE finds symmetry lines of band structure

### finally we proceed to fill the projections array. 
ind=0 ## index of letters of high symmetry 
## has to be outside sectioning loop to proceed lettering otherwise restarts every section
for m in range(n_bandsections):  ## this loop is repeated for each band section
    energykpts=fullenergykpts[bandsections[m]:bandsections[m+1]]
    i=-1
    j=-1
    with open(filepdos, "r") as f:
        lines=f.readlines()
        for line in lines:
            if line.startswith(" k"):
                i+=1
                j=-1 ##resets others
            if bandtype == 0 : ## there are two band types in .pdos in QE, have to check beforehand
                if line.startswith("===="):
                    j+=1
                    energyk=re.findall(r"^====*.* ([-+]?\d+\.\d+).*",line)[0]
                    energykpt.append(energyk)
            if bandtype == 1 :
                if re.match(r'\s+e =', line):
                    j+=1
            ## this will look for the projection and for the identification of the state
            if re.match(r"^\s* psi =", line): 
                result=re.findall(r"(\d+\.\d+)",line)
                label=re.findall(r"\[([^]]*)\]", line)
                newlabel = [ statesidx.index(label[i]) for i in range(len(label)) ]
                results= [[x,y] for x,y in zip(result,newlabel)]
                for jj in range(len(results)):
                    projections[i][j][results[jj][1]]=results[jj][0]

            if re.match(r"^\s* \+",line):
                result=re.findall(r"(\d+\.\d+)",line)
                label=re.findall(r"\[([^]]*)\]", line)
                newlabel = [ statesidx.index(label[i]) for i in range(len(label)) ]
                results= [[x,y] for x,y in zip(result,newlabel)]
                for jj in range(len(results)):
                    projections[i][j][results[jj][1]]=results[jj][0]
    ## remember the band plot has to be interpolated, so after the states are filled we proceed to this
    kinterp = np.linspace(min(kpointspaths[m]),  max(kpointspaths[m]), num=10*len(kpointspaths[m]), endpoint=True)
    #interpolation generates 10 times the previous kpoints in each section

    ax[m].set_xticklabels([]) ## no xticklabels we want the special characters
    axis = [min(kinterp),max(kinterp),-RANGE_VB, RANGE_CB]  ## valence band and conduction band ranges are set in here
    ax[m].set_ylim([axis[2],axis[3]])
    ax[m].set_xlim([axis[0],axis[1]])
    ### SETTING TICKS IN Y AXIS
    majoryLocator   = MultipleLocator(1)
    majoryFormatter = FormatStrFormatter('%d')
    minoryLocator   = MultipleLocator(0.5)
    ax[m].yaxis.set_major_locator(majoryLocator)
    ax[m].yaxis.set_major_formatter(majoryFormatter)
    ax[m].yaxis.set_minor_locator(minoryLocator)
    
    for i in range(len(energykpts[0])):  ## for every band 
        ## here interpolation function is called
        bandinter= cubic_interp1d(kinterp, kpointspaths[m], energykpts[:,i]-fermi)
        
        ## now the color vectors same size of kinterp are created
        red=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],np.zeros(len(kpointspaths[m]))))
        for r in np.array(redstates)-1: ## each color states are user defined after checkstates run
            red+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],projections[:,i,r]))
        if maxcontrast: ## only if maxcontrast option is true
            red=(contrast_ratios[0]/max(red))*red if max(red) != 0 else red ## get maxs contrast
            ## contrast ratios values are inserted in this expression

        green=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],np.zeros(len(kpointspaths[m]))))
        for g in np.array(greenstates)-1:
            green+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],projections[:,i,g]))
        if maxcontrast:
            green=(contrast_ratios[1]/max(green))*green if max(green) != 0 else green ## get maxs contrast

        blue=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],np.zeros(len(kpointspaths[m]))))               
        for b in np.array(bluestates)-1:
            blue+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m],projections[:,i,b]))
        if maxcontrast:  
            blue=(contrast_ratios[2]/max(blue))*blue   if max(blue) != 0 else blue ## get maxs contrast

        ## here colored lines are finally ploted
        lc = rgbline(kinterp, bandinter, red, green, blue, alpha=1, linestyles='solid',
                                 linewidth=(mpl.rcParams['lines.linewidth'] * 1.25))
        ax[m].add_collection(lc)

    ### now last touch is to have the labels of high symmetry points placed appropriatedly on the band structure
    ## the symbols are given by indexes function, the number should naturally match number of highsym points in 
    ## the structure


    if not manual_indexing:
        lastp=-1 ## last point coordinate to not put two labels at same place. Changes after first run.
        #print(hspoints)
        xticks=[] ## xticklabels to be set later
        for p in hspoints: #This is the high symmetry lines
            ## checks if p is within range of the max and min kinterp, therefore placeble and if his distance from last
            ## placed point is larger than 0.1
            if p <= max(kinterp)+0.1 and p >= min(kinterp)-0.1 and abs(lastp-p)>0.1:
                lastp=p
                x1 = [p,p]
                x2 = [axis[2],axis[3]]
                ax[m].plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
                xticks.append(p)
                ax[m].text(p-0.07,axis[2]-(axis[3]-axis[2])/10, indexes[ind],size=14)  ## to adjust labels position
                ind+=1
        ax[m].set_xticks(xticks)
    else: ## manual_indexing set to True
        for i in range(len(indexes)):
            x1 = [indexes_pos[i],indexes_pos[i]]
            # print([j,j])
            x2 = [axis[2],axis[3]]
            ax[m].plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
            ax[m].text(indexes_pos[i],axis[2]-(axis[3]-axis[2])/10, indexes[i],size=14)
    #ax[m].set_xticklabels(indexes)  ## works but labels are not uniform

if nspin:  ## this will plot other spin on top of first spin sections
    ## the .pdos file is organized such that kpoints of other spin just repeat after first spin is over
    
    for m in range(n_bandsections):  ## this loop is repeated for each band section
        # print('section',m)
        energykpts=fullenergykpts[bandsections[m+n_bandsections]:bandsections[m+n_bandsections+1]]
        ## now bandsections are further to get other spin
        i=-1
        j=-1
        with open(filepdos, "r") as f:
            lines=f.readlines()
            for line in lines:
                if line.startswith(" k"):
                    i+=1
                    j=-1 ##resets others
                if bandtype == 0 : ## there are two band types in .pdos in QE, have to check beforehand
                    if line.startswith("===="):
                        j+=1
                        energyk=re.findall(r"^====*.* ([-+]?\d+\.\d+).*",line)[0]
                        energykpt.append(energyk)
                if bandtype == 1 :
                    if re.match(r'\s+e =', line):
                        j+=1
                ## this will look for the projection and for the identification of the state
                if re.match(r"^\s* psi =", line): 
                    result=re.findall(r"(\d+\.\d+)",line)
                    label=re.findall(r"\[([^]]*)\]", line)
                    newlabel = [ statesidx.index(label[i]) for i in range(len(label)) ]
                    results= [[x,y] for x,y in zip(result,newlabel)]
                    for jj in range(len(results)):
                        projections[i][j][results[jj][1]]=results[jj][0]

                if re.match(r"^\s* \+",line):
                    result=re.findall(r"(\d+\.\d+)",line)
                    label=re.findall(r"\[([^]]*)\]", line)
                    newlabel = [ statesidx.index(label[i]) for i in range(len(label)) ]
                    results= [[x,y] for x,y in zip(result,newlabel)]
                    for jj in range(len(results)):
                        projections[i][j][results[jj][1]]=results[jj][0]
        ## remember the band plot has to be interpolated, so after the states are filled we proceed to this
        kinterp = np.linspace(min(kpointspaths[m+n_bandsections]),  max(kpointspaths[m+n_bandsections]), 
                            num=10*len(kpointspaths[m+n_bandsections]), endpoint=True)
        #interpolation generates 10 times the previous kpoints in each section
       
        for i in range(len(energykpts[0])):  ## for every band 
            ## here interpolation function is called
            bandinter= cubic_interp1d(kinterp, kpointspaths[m+n_bandsections], energykpts[:,i]-fermi)
            
            ## now the color vectors same size of kinterp are created
            red=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],np.zeros(len(kpointspaths[m+n_bandsections]))))
            for r in np.array(redstates)-1: ## each color states are user defined after checkstates run
                red+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],projections[:,i,r]))
            if maxcontrast: ## only if maxcontrast option is true
                red=(contrast_ratios[0]/max(red))*red if max(red) != 0 else red ## get maxs contrast
                ## contrast ratios values are inserted in this expression

            green=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],np.zeros(len(kpointspaths[m+n_bandsections]))))
            for g in np.array(greenstates)-1:
                green+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],projections[:,i,g]))
            if maxcontrast:
                green=(contrast_ratios[1]/max(green))*green if max(green) != 0 else green ## get maxs contrast

            blue=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],np.zeros(len(kpointspaths[m+n_bandsections]))))          
            for b in np.array(bluestates)-1:
                blue+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections],projections[:,i,b]))
            if maxcontrast:  
                blue=(contrast_ratios[2]/max(blue))*blue   if max(blue) != 0 else blue ## get maxs contrast

            ## here colored lines are finally ploted
            lc = rgbline(kinterp, bandinter, red, green, blue, alpha=1, linestyles='solid',
                                    linewidth=(mpl.rcParams['lines.linewidth'] * 1.25))
            ax[m].add_collection(lc)  ## the ax plot is m to overlap first spin


plt.show()
#fig.savefig(PREFIX+'_bandproj'+'.svg', format='svg', dpi=1000)  
fig.savefig(PREFIX+'_bandproj'+'.png', format='png', dpi=1000)


