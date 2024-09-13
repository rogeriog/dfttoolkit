#!/usr/bin/env python
###################### HERE CUSTOMIZATION IS NEEDED ######################################
## files needed  ## give in list format
PREFIX=["CsSbIt-In"]
filesdos=['./PP_BANDS/'+PREFIX[0]+'.dos']  ## dos file from QE ## will be used only to find fermi if not given
filespdos=["./PP_BANDS/out."+PREFIX[0]+".pdos"]  ## pdos output of a bandstructure calculation  ## contains most of data we need
symfiles=["./PP_BANDS/out."+PREFIX[0]+".bands"]  ## bands output of bandstructure calculation ## contains high symmetry k points
fermis = [2.556]   ## keeping 0 the script will look for fermi value in filedos file.
labels=[""] ## if label "" no label will be plotted
colors=["black"]

indexes=['$\Gamma$','M','K','$\Gamma$','A','L','H','A','L','M',
         'H','K']      ## these are the indexes of the bandstructure
# Γ—M—K—Γ—A—L—H—A|L—M|H—K ## band path P-3m1 trigonal
#   Γ—Y—F0|Δ0—Γ—Z—B0|G0—T—Y|Γ—S—R—Z—T  ## band path hexagonal CsSbI 63/mmc
#   Γ—X—S—Y—Γ—Z—U—R—T—Z|X—U|Y—T|S—R   ## band path ortorhombic CsSbCl 

RANGE_VB=1.5 ## ev to plot below efermi
RANGE_CB=4 ## ev to plot above efermi
## legend positioning in the end of script as well as output options.

## sometimes we want to shift conduction band applying a scissor operation, 
# define its value in here in eV ## default is 0
scissor_shift=0.0

## COLOR ASSIGNMENT
projected_bands=True ## bands will be projected with different colors in different states.
## to fill appropriatedly run beforehand this script with "checkstates" argument.
## once you write down the states youre interested to color in the bandstructure proceed.
## the numbers given are the number after # in the states list given by checkstates run.
redstates=range(106,115)   ## states colored red, you can always give range(92,96)
greenstates=range(106,115)   ## states colored green
bluestates=[]  ## states colored blue, no states with []
labelsprojs=["","","In"]  ## first red, second green, third blue
## notice if there is overlapping colors will blend

maxcontrast=True  ## notice if maxcontrast=0, color will be as strong as the state proportion, 
#usually this contribution is very low compared to total, therefore maxcontrast is default.
contrast_ratios=[1,0.4,1]  ## only if maxcontrast true # values should be in 0-1 range
#if [1,0.5,0.5], red will be 2 times more intense than highest green and blue.

########### MANUAL INDEXING ##################################
# maybe the script does not position the labels of high symmetry appropriatedly, this section is to correct
# this problem manually, as well as few changes on plot settings
manual_indexing=False
indexes_pos=[]  ## ought to have same size of indexes list

########### EFFECTIVE MASS SETUP ###f############################
emass_calculation=False ## will print effective mass on high symmetry points, use manual indexing for arbitrary points
plot_emass_fitting=False ## will show the fitted curve to obtain effective masses
alat=16.365  ## alat used by quantum espresso have to know to change coords of k points to calculate eff mass
k_width=0.15 ## range above and below hspoint in default k-coordinates to consider in band 0.15 usually enough, 
# can always check turning plot_emass_fitting to True.
ylevel_refpoint=0.5  ## ref point to calculate effective mass remember fermi level y=0. Important this level between gap!
## shift ylevel_refpoint to a value between valence and conduction band to calculate bands.

##########################################################################################
########### LEAVE EVERYTHING ELSE AS IT IS, EXCEPT IF YOU KNOW WHAT YOURE DOING ##########
##########################################################################################
import re
import numpy as np
from math import sqrt
import matplotlib.pyplot as plt
import os,sys
import matplotlib as mpl
from matplotlib.collections import LineCollection
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
from numpy.lib.function_base import diff
import colorsys


def modulo(x,y):
    """Module of the difference between two vectors"""
    return np.linalg.norm(np.subtract(x,y))



### this will allow to plot specific states as different colors
def rgbline(x, y, red, green, blue, alpha=0, linestyles="solid",
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
        a = np.ones(nseg, float) * aa
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
###################### FUNCTIONS AND PROCEDURES ##########################################
##########################################################################################

n_bandsections=-1
for id_structure in range(len(PREFIX)):
    filedos=filesdos[id_structure] 
    filepdos=filespdos[id_structure] 
    symfile=symfiles[id_structure]
    fermi=fermis[id_structure]  
    label_structure=labels[id_structure]
    color=colors[id_structure]

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


    bandtype=-1 ## energies dont have ==== in pdos file  ## two types of bandtype
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


    ##########################################################################################
    ##########################################################################################



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
    
    if id_structure == 0 :  ## only does it for the first plot.
        if nspin:
            n_bandsections=int((len(bandsections)-1)/2)  ## bandsections will be half
            fig, ax = plt.subplots(1,n_bandsections,sharey=True,
                            squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas[:-n_bandsections]})

        else:
            n_bandsections=(len(bandsections)-1)
            fig, ax = plt.subplots(1,n_bandsections,sharey=True,
                            squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas})    

    if nspin and n_bandsections == 2: ## no subsections on band plot
        ax=[ax]  ## no subscript problem

    if n_bandsections == 1: ## no subsections on band plot
        ax=[ax]  ## no subscript problem

    ax[0].set_ylabel("Energy (eV)",fontsize=14)
    ax[0].yaxis.set_tick_params(labelsize=14)
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

        if not plot_emass_fitting: ## useful in plot_emass
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
            if min(energykpts[:,i]) > fermi+0.1:   ##### creating an artificial shift on the graph to match NC PP
                bandinter= cubic_interp1d(kinterp, kpointspaths[m], energykpts[:,i]+scissor_shift-fermi)
            else:
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

            ## need to find hue of rgb 
            hue=np.zeros(len(red)) 
            for i in range(len(hue)):
                hue[i]=colorsys.rgb_to_hsv(red[i],green[i],blue[i])[0] ## get hue
            ## then saturation based on weights of each of the considered states
            satur=np.zeros(len(red)) 
            for i in range(len(satur)):
                satur[i]=red[i]+green[i]+blue[i]
            if maxcontrast:
                satur=(1/max(satur))*satur   if max(satur) != 0 else satur 
            
            ## now satur hue and value=1 will lead to the new red green blue values
            for i in range(len(hue)):
                red[i],green[i],blue[i]=colorsys.hsv_to_rgb(hue[i], satur[i], 1)
            ## now we should colors that vary from white to the mixed color depending on weights on band states
        

            ## here colored lines are finally ploted
            if projected_bands:
                ax[m].plot(kinterp, bandinter, color=color,label=label_structure,lw=1)
                lc = rgbline(kinterp, bandinter, red, green, blue, alpha=1, linestyles='solid',
                                     linewidth=(mpl.rcParams['lines.linewidth'] * 2.75))
                ax[m].add_collection(lc)
            else:
                ax[m].plot(kinterp, bandinter, color=color,label=label_structure,lw=1.5)

            
                

        ### now last touch is to have the labels of high symmetry points placed appropriatedly on the band structure
        ## the symbols are given by indexes function, the number should naturally match number of highsym points in 
        ## the structure

        if id_structure == 0 :
            if not manual_indexing :   ## only first plot needs this setting.
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
                        if not emass_calculation: ## these lines affect emass calculation
                            ax[m].plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
                        xticks.append(p)
                        ax[m].text(p-0.03,axis[2]-(axis[3]-axis[2])/15, indexes[ind],size=16)  ## to adjust labels position
                        ind+=1
                ax[m].set_xticks(xticks)
            else: ## manual_indexing set to True
                for i in range(len(indexes)):
                    x1 = [indexes_pos[i],indexes_pos[i]]
                    # print([j,j])
                    x2 = [axis[2],axis[3]]
                    ax[m].plot(x1,x2,'--',lw=0.55,color='black',alpha=0.75)
                    ax[m].text(indexes_pos[i],axis[2]-(axis[3]-axis[2])/10, indexes[i],size=16)
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
            ### have to shift back the second spin k to overlap first spin k point region
            previous_kinterp = np.linspace(min(kpointspaths[m]),  max(kpointspaths[m]), 
                                num=10*len(kpointspaths[m]), endpoint=True)
            diffk_2spin=min(kinterp)-min(previous_kinterp)  ## get difference of nspin 1 and nspin 2 x of bands
            kinterp=kinterp-diffk_2spin  ## make 2spin overlap previous 1spin.
            for i in range(len(energykpts[0])):  ## for every band 
                ## here interpolation function is called
                if min(energykpts[:,i]) > fermi+0.1:   ##### creating an artificial shift on the graph to match NC PP
                    bandinter= cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin, energykpts[:,i]+scissor_shift-fermi)
                else:
                    bandinter= cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin, energykpts[:,i]-fermi)
                    
                
                ## now the color vectors same size of kinterp are created
                red=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,np.zeros(len(kpointspaths[m+n_bandsections]))))
                for r in np.array(redstates)-1: ## each color states are user defined after checkstates run
                    red+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,projections[:,i,r]))
                if maxcontrast: ## only if maxcontrast option is true
                    red=(contrast_ratios[0]/max(red))*red if max(red) != 0 else red ## get maxs contrast
                    ## contrast ratios values are inserted in this expression

                green=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,np.zeros(len(kpointspaths[m+n_bandsections]))))
                for g in np.array(greenstates)-1:
                    green+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,projections[:,i,g]))
                if maxcontrast:
                    green=(contrast_ratios[1]/max(green))*green if max(green) != 0 else green ## get maxs contrast

                blue=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,np.zeros(len(kpointspaths[m+n_bandsections]))))          
                for b in np.array(bluestates)-1:
                    blue+=np.absolute(cubic_interp1d(kinterp, kpointspaths[m+n_bandsections]-diffk_2spin,projections[:,i,b]))
                if maxcontrast:  
                    blue=(contrast_ratios[2]/max(blue))*blue   if max(blue) != 0 else blue ## get maxs contrast

                ## need to find hue of rgb 
                hue=np.zeros(len(red)) 
                for i in range(len(hue)):
                    hue[i]=colorsys.rgb_to_hsv(red[i],green[i],blue[i])[0]
                ## then saturation based on weights of each of the considered states
                satur=np.zeros(len(red)) 
                for i in range(len(satur)):
                    satur[i]=red[i]+green[i]+blue[i]
                if maxcontrast:
                    satur=(1/max(satur))*satur   if max(satur) != 0 else satur 
                
                ## now satur hue and value=1 will lead to the new red green blue values
                for i in range(len(hue)):
                    red[i],green[i],blue[i]=colorsys.hsv_to_rgb(hue[i], satur[i], 1)
                ## now we should colors that vary from white to the mixed color depending on weights on band states

                ## here colored lines are finally ploted
                if projected_bands:
                    ax[m].plot(kinterp, bandinter, color=color,label=label_structure,lw=1)
                    lc = rgbline(kinterp, bandinter, red, green, blue, alpha=1, linestyles='solid',
                                        linewidth=(mpl.rcParams['lines.linewidth'] * 2.75))
                    ax[m].add_collection(lc)
                else:
                    ax[m].plot(kinterp, bandinter, color=color,label=label_structure,lw=1.5)


    ######################## START CALCULATION OF EFFECTIVE MASS ##########################
    #######################################################################################

    if emass_calculation and id_structure == 0:  ## only runs on first one, needs implementation for more at same time.
        pairs=list(zip(indexes,hspoints))  ## tuples of hspoints and their k value
        ## First we need all points contained in the plot in a huge array
        for m in range(n_bandsections):
            all_data=np.array([[0,0]])
            for i in range(len(ax[m].lines)):
                all_data=np.concatenate((all_data,ax[m].lines[i].get_xydata()),axis=0)
            all_data=np.delete(all_data, 0, axis=0)  # delete first initialized element
            all_data=np.round(all_data,decimals=3)
            mink=min(all_data[:,0])  ## important to define edges
            maxk=max(all_data[:,0])
            
            ## function to calculate effective mass
            def get_emass(band_section,alat,k_hspoint):
                #### PREPARE DATA WE NEED 0,0 on MAX OR MIN OF SEGMENT ####
                ind=np.argsort(band_section[:,0])  ## get indices sorted by lowest x
                band_section=band_section[ind] ## reorganize 

                ### check type of segment 
                hspoint_type=None  ##  will be "max" or "min"
                signcheck=np.sign(np.sum(np.diff(band_section[:,1])))  ## does it increase or decrease as k increase
                diffmax=k_hspoint-np.max(band_section[:,0])
                diffmin=k_hspoint-np.max(band_section[:,0])
                diffcheck=diffmax<diffmin  ## true if closer to max
                if signcheck==-1 and diffcheck:
                    hspoint_type == "min"
                elif signcheck==-1 and not diffcheck:
                    hspoint_type == "max"
                elif signcheck==1 and diffcheck:
                    hspoint_type == "min"
                elif signcheck==1 and not diffcheck:
                    hspoint_type == "min"

                ## max or min has to become 0,0 point
                band_section[:,0]=band_section[:,0]-k_hspoint
                if hspoint_type == "min":
                    band_section[:,1]=band_section[:,1]-min(band_section[:,1])
                if hspoint_type == "max":
                    band_section[:,1]=band_section[:,1]-max(band_section[:,1])
                ###### DATA READY ##########

                ### k coordinates are 2pi/alat, have to convert to 2pi/bohr
                ### multiply 1/alat
                c=np.polynomial.polynomial.polyfit(band_section[:,0]*(2*np.pi)/alat,band_section[:,1]/27.2114,[0,2])
                #print("coeficients from lower to higher",c)
                ### if units of k are bohr-1 and energy are hartree, effmass will be in units of electron mass.
                effmass=1/(2*c[2])  ## have to multiply by 2 because is the second derivative 
                
                # ### if you want to check data in a plot
                # x=np.linspace(min(band_section[:,0]*(2*np.pi)/alat),max(band_section[:,0]*(1/alat)),num=10)
                # p=np.polynomial.polynomial.polyval(x,c)
                # fig, ax = plt.subplots(1,1)
                # ax.plot(x,p)
                # ax.plot(band_section[:,0]*(2*np.pi)/alat,band_section[:,1]/27.2114)
                return effmass

            def plotfit(band_section,ax,**kwargs):
                ## plot points
                ax.plot(band_section[:,0],band_section[:,1],'o-',color=kwargs['color'])
                ## parabolas are wrong commented
                # c_plot=np.polynomial.polynomial.polyfit(band_section[:,0],band_section[:,1],[0,2])
                # x=np.linspace(0,k_width,num=100)
                # p=np.polynomial.polynomial.polyval(x,c_plot)
                # x_hspoint=kwargs['x_hs']
                # ax.plot(x+x_hspoint,p,color="black")


            ref_point=[0.000, ylevel_refpoint]
            ## now we run every hspoint, check if in edges or middle and within data
            for idx_pair, hspoint in enumerate(pairs):
                left_edge,right_edge=(False,False)
                if hspoint[1] > maxk+0.001 or hspoint[1] < mink-0.001: ## is the point valid for the axis
                    ## print("Invalid hspoint, maybe it is in another axis. HSP: {0} MINK: {1} MAXK: {2}".format(hspoint[1],mink,maxk))
                    continue ## if it isnt go to next
                if hspoint[1]-0.1 < mink:  ## left edge point
                    print("left edge")
                    left_edge=True
                if hspoint[1]+0.1 > maxk:  ## right edge point
                    print("right edge")
                    right_edge=True

                ref_point[0]=hspoint[1]  ## ref point k equals the high symmetry point k
                print("hspoint:",hspoint[0])
                ### takes a subset containing all points in the k_width range to the hspoint
                subset=all_data[np.where(np.isclose(all_data[:,0],ref_point[0],atol=k_width))]
                
                
                ### conduction band ####
                cbsubset=subset[subset[:,1]>ref_point[1]]
                ind=np.argsort(cbsubset[:,1])  ## get indices sorted by lowest y
                cbsubset=cbsubset[ind] ## reorganize subset
                lower_cbsubset=np.array([[-1,-1]])
                for point in cbsubset:
                    ## check if point x is already in the list
                    # if any point already added has x close to the new point ## these are points in superior bands
                    if np.any(np.isclose(lower_cbsubset[:,0],point[0],atol=1e-5)): 
                        continue
                    else:
                        lower_cbsubset=np.append(lower_cbsubset,[point],axis=0)
                lower_cbsubset=np.delete(lower_cbsubset,0,axis=0)

                if not left_edge and not right_edge:  ## if its not an edge find and add median.
                    median_cbsubset=np.median(lower_cbsubset,axis=0)
                    idx = (np.abs(lower_cbsubset[:,0] - median_cbsubset[0])).argmin()
                    median_cbsubset[1]=lower_cbsubset[idx,1]  ## median point have same y as its neighbour, not y average
                    if np.any(np.isin(median_cbsubset,lower_cbsubset)): ## if median not in set add
                        lower_cbsubset=np.append(lower_cbsubset,[median_cbsubset],axis=0)
                        ind=np.argsort(lower_cbsubset[:,0])  ## get indices sorted by lowest x
                        lower_cbsubset=lower_cbsubset[ind] ## reorganize subset
                    median_idx=np.where(lower_cbsubset==median_cbsubset)[0][0]
                    lefthand_cband=lower_cbsubset[:median_idx+1]
                    righthand_cband=lower_cbsubset[median_idx:]
                if left_edge:
                    righthand_cband=lower_cbsubset
                if right_edge: 
                    lefthand_cband=lower_cbsubset


            ### valence band ####
                vbsubset=subset[subset[:,1]<ref_point[1]]
                ind=np.argsort(vbsubset[:,1])  ## get indices sorted by lowest y
                vbsubset=vbsubset[ind] ## reorganize subset
                vbsubset=vbsubset[::-1] ## reverse
                higher_vbsubset=np.array([[-1,-1]])
                for point in vbsubset:
                    ## check if point x is already in the list
                    # if any point already added has x close to the new point ## these are points in superior bands
                    if np.any(np.isclose(higher_vbsubset[:,0],point[0],atol=1e-5)): 
                        continue
                    else:
                        higher_vbsubset=np.append(higher_vbsubset,[point],axis=0)
                higher_vbsubset=np.delete(higher_vbsubset,0,axis=0)

                if not left_edge and not right_edge:  ## if its not an edge find and add median.
                    median_vbsubset=np.median(higher_vbsubset,axis=0)
                    idx = (np.abs(higher_vbsubset[:,0] - median_cbsubset[0])).argmin()
                    median_vbsubset[1]=higher_vbsubset[idx,1]  ## median point have same y as its neighbour, not y average
                    if np.any(np.isin(median_vbsubset,higher_vbsubset)): ## if median not in set add
                        higher_vbsubset=np.append(higher_vbsubset,[median_vbsubset],axis=0)
                        ind=np.argsort(higher_vbsubset[:,0])  ## get indices sorted by lowest x
                        higher_vbsubset=higher_vbsubset[ind] ## reorganize subset
                    median_idx=np.where(higher_vbsubset==median_vbsubset)[0][0]
                    lefthand_vband=higher_vbsubset[:median_idx+1]
                    righthand_vband=higher_vbsubset[median_idx:]
                if left_edge:
                    righthand_vband=higher_vbsubset
                if right_edge: 
                    lefthand_vband=higher_vbsubset

                if left_edge:
                    if plot_emass_fitting:
                        plotfit(righthand_cband,ax[m],color="purple",k_hspoint=hspoint[1])
                        plotfit(righthand_vband,ax[m],color="purple",k_hspoint=hspoint[1])
                    print('cbandmass '+pairs[idx_pair][0]+'-'+pairs[idx_pair+1][0],get_emass(righthand_cband,alat,hspoint[1]))
                    print('vbandmass '+pairs[idx_pair][0]+'-'+pairs[idx_pair+1][0],get_emass(righthand_vband,alat,hspoint[1]))


            
                if right_edge:
                    if plot_emass_fitting:
                        plotfit(lefthand_cband,ax[m],color="orange",x_hspoint=hspoint[1]) 
                        plotfit(lefthand_vband,ax[m],color="orange",x_hspoint=hspoint[1]) 
                    print('cbandmass '+pairs[idx_pair-1][0]+'-'+pairs[idx_pair][0],get_emass(lefthand_cband,alat,hspoint[1]))
                    print('vbandmass '+pairs[idx_pair-1][0]+'-'+pairs[idx_pair][0],get_emass(lefthand_vband,alat,hspoint[1]))


                if not left_edge and not right_edge:  ## if its not an edge find and add median.
                    if plot_emass_fitting:
                        plotfit(lefthand_cband,ax[m],color="orange",x_hspoint=hspoint[1]) 
                        plotfit(lefthand_vband,ax[m],color="orange",x_hspoint=hspoint[1])
                        plotfit(righthand_cband,ax[m],color="purple",x_hspoint=hspoint[1])
                        plotfit(righthand_vband,ax[m],color="purple",x_hspoint=hspoint[1])
                    print('cbandmass '+pairs[idx_pair-1][0]+'-'+pairs[idx_pair][0],get_emass(lefthand_cband,alat,hspoint[1]))
                    print('vbandmass '+pairs[idx_pair-1][0]+'-'+pairs[idx_pair][0],get_emass(lefthand_vband,alat,hspoint[1]))
                    print('cbandmass '+pairs[idx_pair][0]+'-'+pairs[idx_pair+1][0],get_emass(righthand_cband,alat,hspoint[1]))
                    print('vbandmass '+pairs[idx_pair][0]+'-'+pairs[idx_pair+1][0],get_emass(righthand_vband,alat,hspoint[1]))


## this will coalesce legends into the different color ones with their corresponding color.
final_handles = [] 
handlescolors=[]
final_labels = []
handles,labels = ax[0].get_legend_handles_labels()
for idx, handle in enumerate(handles):
    color=handle.get_color()
    if color not in handlescolors:
        final_handles.append(handle)
        handlescolors.append(color)
        final_labels.append(labels[idx])  ## add corresponding label 

linelegend=plt.legend(final_handles,final_labels,bbox_to_anchor=(1, 0.5),labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":12},
                  handletextpad=0.1)  ## place upper left corner of legend on 0.61,0.5 axes coordinates.
# Add the legend manually to the current Axes.
ax = plt.gca().add_artist(linelegend) ## manual insertion to make two separate legends

import matplotlib.patches as mpatches

patches=[]
red_patch = mpatches.Patch(color='red', label=labelsprojs[0])
green_patch = mpatches.Patch(color='green', label=labelsprojs[1])
blue_patch = mpatches.Patch(color='blue', label=labelsprojs[2])
if len(redstates) != 0 :
    patches.append(red_patch)
if len(greenstates) != 0 :
    patches.append(green_patch)
if len(bluestates) != 0 :
    patches.append(blue_patch)

legendposition_tuple=(1,1)
plt.legend(handles=patches,bbox_to_anchor=legendposition_tuple, frameon=False, prop={"size":12},)

plt.show()
fig.savefig(PREFIX[0]+'_bandproj'+'.svg', format='svg', dpi=1000)  
fig.savefig(PREFIX[0]+'_bandproj'+'.png', format='png', dpi=1000)
