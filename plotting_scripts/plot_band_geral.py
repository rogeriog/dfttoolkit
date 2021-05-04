#### SCRIPT TO PLOT BAND STRUCTURE ######
#!/usr/bin/env python
# Modified from band.py, written by Levi Lentz for the Kolpak Group at MIT
# This is distributed under the MIT license
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gs
import sys, os, re

#DO NOT EDIT ANYTHING IN HERE################################################
#############################################################################
#############################################################################
#############################################################################
#This function extracts the high symmetry points from the output of bandx.out
def Symmetries(fstring):
  f = open(fstring,'r')
  x = np.zeros(0)
  for i in f:
    if "high-symmetry" in i:
      x = np.append(x,float(i.split()[-1]))
  f.close()
  return x
#############################################################################
# Split list into lists by particular value 
def SplitBandsSection(test_list):
    size = len(test_list) 
    idx_list = [idx + 1 for idx, val in
                enumerate(test_list) if val == "|"] 
    
    idx_list.insert(0,0)
    idx_list.append(size)
    res=[]
    for i in range(len(idx_list)-1):
        if i < (len(idx_list)-2):
            res.append(test_list[idx_list[i]:idx_list[i+1]-1])
        else: # last section
            res.append(test_list[idx_list[i]:idx_list[i+1]])
    return res
#############################################################################

# This function takes in the datafile, the fermi energy, the symmetry file, a subplot, and the label
# It then extracts the band data, and plots the bands, the fermi energy in red, and the high symmetry points
def bndplot(filename,datafile,fermi,symmetryfile,colorband,HSpts,labelbands,y1,y2,leg_x,leg_y):
    fig, subplots = plt.subplots(1,len(datafile),sharey=True,sharex=True, gridspec_kw={'wspace': 0.1}, figsize=(8, 3))
    for nplot in range(len(datafile)):
      if len(datafile)==1:
          subplot=subplots
      else:
          subplot=subplots[nplot]
      z = np.loadtxt(datafile[nplot]) #This loads the bandx.dat.gnu file
      x = np.unique(z[:,0]) #This is all the unique x-points
      bands = []
      bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
      Fermi = float(fermi[nplot])
      axis = [min(x),max(x), y1,y2]
      print(axis)
      for i in range(0,bndl):
        bands.append(np.zeros([len(x),2])) #This is where we storre the bands
      for i in range(0,len(x)):
        sel = z[z[:,0] == x[i]]  #Here is the energies for a given x
        test = []
        for j in range(0,bndl): #This separates it out into a single band
          bands[j][i][0] = x[i]
          bands[j][i][1] = np.multiply(sel[j][1],1)
      if labelbands[nplot] == '' or labelbands[nplot] == None :
          togetlabel=0
      else:
          togetlabel=1
          subplot.legend(loc=(leg_x, leg_y))
          
      for i in bands: #Here we plots the bands
         if togetlabel:
            subplot.plot(i[:,0],i[:,1]-fermi[nplot],label=labelbands[nplot],lw=1,color=colorband[nplot])
            togetlabel=0
         else:
            subplot.plot(i[:,0],i[:,1]-fermi[nplot],lw=1,color=colorband[nplot])
  
      temp = Symmetries(symmetryfile[nplot])
      print(temp)
      subplot.set_xticks(temp)
      ind = 0
      for j in temp: #This is the high symmetry lines
        x1 = [j,j]
        x2 = [axis[2],axis[3]]
        subplot.plot(x1,x2,'--',lw=0.3,color='black',alpha=0.75)
        subplot.text(j-max(x)/100,axis[2]-0.08*(axis[3]-axis[2]), HSpts[ind])
        ind+=1
      if nplot == 0: 
          subplot.set_ylabel("Energy (eV)")
      #subplot.plot([min(x),max(x)],[Fermi,Fermi],'--',color='black')
      subplot.set_xticklabels([])
      subplot.set_ylim([axis[2],axis[3]])
      subplot.set_xlim([axis[0],axis[1]])
    #fig.tight_layout()
    fig.savefig(filename+".svg", format='svg', dpi=1000)  ## para salvar um arquivo 
#############################################################################  


    
def bndplot_sep(filename,datafile,fermi,symmetryfile,colorband,HSpts,labelbands,y1,y2,leg_x,leg_y):
    ## defines number of sections in band plot, and define where in kpath it divides
    n_sep=HSpts.count("|")
    nplot=0
    pos_sep=[i for i,d in enumerate(HSpts) if d=='|']
    temp = Symmetries(symmetryfile[nplot])
    j=0; sep_values=[]; temp_coordstosplit=[]
    for i in pos_sep:
        k=i-j ## position to split
        sep_values.append(temp[k])
        j=j+1  ## have to increment to account for another | in array
        temp_coordstosplit.append(k)
    
    ## splits the band structure points and temp in subarrays.
    HSpts_splitted=SplitBandsSection(HSpts)
    temp_coordstosplit.insert(0,0); temp_coordstosplit.append(len(temp))
    
    temp_splitted=[]
    print(range(len(temp_coordstosplit)-1))
    for i in range(len(temp_coordstosplit)-1):
        if i < (len(temp_coordstosplit)-2):
            temp_splitted.append(temp[temp_coordstosplit[i]:temp_coordstosplit[i+1]])
            print(temp_coordstosplit[i],temp_coordstosplit[i+1])
        else: # last section
            temp_splitted.append(temp[temp_coordstosplit[i]:temp_coordstosplit[i+1]])
    deltas=[]
    for section in range(n_sep+1):

   #### calculate ratios for plot from temp_splitted
      delta=abs(temp_splitted[section][0]-temp_splitted[section][-1])
      deltas.append(delta)
    
    ## here the ratios between the graphs are defined to be
    # adjusted for the length of each kpath in subplots declaration
    D=temp[-1]-temp[0]
    print("D",deltas)
    deltas=[i/D for i in deltas]
    print(deltas)
    
    ## declares fig and subplots already appropriatedly scaled.
    fig, subplots = plt.subplots(1,n_sep+1,sharey=True,squeeze=True, gridspec_kw={'wspace': 0.3,'width_ratios': deltas})

    z = np.loadtxt(datafile[nplot]) #This loads the bandx.dat.gnu file
    x = np.unique(z[:,0]) #This is all the unique x-points
    bands = []
    bndl = len(z[z[:,0]==x[1]]) #This gives the number of bands in the calculation
    Fermi = float(fermi[nplot])
    axis = [min(x),max(x), y1,y2]
    print(axis)
    for i in range(0,bndl):
      bands.append(np.zeros([len(x),2])) #This is where we storre the bands
    for i in range(0,len(x)):
      sel = z[z[:,0] == x[i]]  #Here is the energies for a given x
      test = []
      for j in range(0,bndl): #This separates it out into a single band
        bands[j][i][0] = x[i]
        bands[j][i][1] = np.multiply(sel[j][1],1)
    if labelbands[nplot] == '' or labelbands[nplot] == None :
        togetlabel=0
    else:
        togetlabel=1
        subplot.legend(loc=(leg_x, leg_y))
    
    indexes=[0] ## first index is 0
    for sep_value in sep_values:
        indexes.append(bands[0][:,0].tolist().index(sep_value)) ## find till where in bands to plot
    indexes.append(len(bands[0][:,0])-1) ## insert last index 
    
    for section in range(n_sep+1):
      subplot=subplots[section]
      subplot.set_xticklabels([])
      subplot.set_ylim([axis[2],axis[3]])
      
      subplots[section].set_xlim((temp_splitted[section][0],temp_splitted[section][-1]))
      for i in bands: #Here we plots the bands
          subplot.plot(i[indexes[section]:indexes[section+1],0],i[indexes[section]:indexes[section+1],1]-fermi[nplot],
                       lw=1,color=colorband[nplot])
      subplot.set_xticks(temp_splitted[section])
      ind = 0
      for j in temp_splitted[section]: #This is the high symmetry lines
        x1 = [j,j]
        x2 = [axis[2],axis[3]]
        subplot.plot(x1,x2,'--',lw=0.3,color='black',alpha=0.75)
        subplot.text(j-max(x)/100,axis[2]-0.08*(axis[3]-axis[2]), HSpts_splitted[section][ind])
        ind+=1
      if section == 0: 
          subplot.set_ylabel("Energy (eV)")
      #subplot.plot([min(x),max(x)],[Fermi,Fermi],'--',color='black')

    #fig.tight_layout()
    fig.savefig(filename+".svg", format='svg', dpi=1000)  ## para salvar um arquivo 
#############################################################################  
#############################################################################
#DO NOT EDIT ANYTHING IN HERE################################################



###### EDIT FROM HERE ON

### here have to insert all letters corresponding to brillouin zone path.
# Γ—C|C2—Y2—Γ—M2—D|D2—A—Γ|L2—Γ—V2 somethig like that

# Γ—X—S—Y—Γ—Z—U—R—T—Z
HSpts=['$\Gamma$','X','S','Y','$\Gamma$','Z','U','R','T','Z']

## define height of energy to plot
y1=-2
y2=+6
## where to put the legend
leg_x,leg_y=(0.7, 0.3)


if "|" not in HSpts:
    ## can add other datafile symfile, fermi, colors to plot another band side by side.
    filename="prefix_name"
    datafile=['./PP/prefix_bands.dat.gnu']  ## dat.gnu file contains all data
    symfile=['./PP/out.prefix_bands.bands'] ## out.bands in PP contains symmetry points
    fermi=[0] ## insert any value 
    colorbands=['blue']
    labelbands=[''] ## insert a label or put None ''
    bndplot(filename,datafile,fermi,symfile,colorbands,HSpts,labelbands, y1,y2,leg_x,leg_y)

else: #HSpts contains | , case of discontinuous band path.
    filename="prefix_SEP"
    datafile=['./PP/prefix_bands.dat.gnu']  ## dat.gnu file contains all data
    symfile=['./PP/out.prefix_bands.bands'] ## out.bands in PP contains symmetry points
    fermi=[0] ## insert any value 
    colorbands=['blue']
    labelbands=[''] ## insert a label or put None ''
    bndplot_sep(filename,datafile,fermi,symfile,colorbands,HSpts,labelbands, y1,y2,leg_x,leg_y)
