### edite esse arquivo com o nivel de FERMI e o nome dos arquivos para plotar
### e assim criar um grafico customizado ao seu interesse.
import numpy as np
import matplotlib.pyplot as plt
import string 
# import math
# import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter

from scipy.signal import convolve 
from scipy.signal import gaussian

RANGE_VB=6.0 ## plotar quantos eV abaixo de Fermi
RANGE_CB=5.0  ## plotar quantos eV acima de Fermi


filename="prefix"  ## name to save figure in the end as filename.svg

## directories where each projected DOS will be found for each graph. 
alldir=['./pathtofirst/PP/PDOS/',
        './pathtosecond/PP/PDOS/',
        './pathtothird/PP/PDOS/',
        './pathtofourth/PP/PDOS/',
        './pathtofifth/PP/PDOS/',
        ]

FERMI=[2.198, 2.431, 2.566, 2.431, 2.566  ] 
 # fermi energies for each system find in out.nscf or prefix.dos

listpdos_files1=['prefix.pdos_tot','sumpdos_prefix.A3p',
                 'sumpdos_prefix.B2p', 'sumpdos_prefix.C4s'
                 ]

listpdos_files2=['prefix.pdos_tot','sumpdos_prefix.A3p',
                 'sumpdos_prefix.B2p', 'sumpdos_prefix.C4s'
                 ]


listpdos_files3=['prefix.pdos_tot','sumpdos_prefix.A3p',
                 'sumpdos_prefix.B2p', 'sumpdos_prefix.C4s'
                 ]

listpdos_files4=['prefix.pdos_tot','sumpdos_prefix.A3p',
                 'sumpdos_prefix.B2p', 'sumpdos_prefix.C4s'
                 ]

listpdos_files5=['prefix.pdos_tot','sumpdos_prefix.A3p',
                 'sumpdos_prefix.B2p', 'sumpdos_prefix.C4s'
                 ]
## if 1 in second field the corresponding file will be plotted if 0 not plotted
## if 2 filled plot
setspdos1=[ ['Total',2,'blue',0.3,'solid'],
                      ['A $\it{4p}$',1,'purple',1,'solid'],
                      ['B $\it{3p}$',1,'green',1,'solid'],
                      ['C $\it{4s}$',1,'red',1,'solid'],
          ]    

setspdos2=[ ['Total',2,'blue',0.3,'solid'],
                      ['A $\it{4p}$',1,'purple',1,'solid'],
                      ['B $\it{3p}$',1,'green',1,'solid'],
                      ['C $\it{4s}$',1,'red',1,'solid'],
          ]      
setspdos3=[ ['Total',2,'blue',0.3,'solid'],
                      ['A $\it{4p}$',1,'purple',1,'solid'],
                      ['B $\it{3p}$',1,'green',1,'solid'],
                      ['C $\it{4s}$',1,'red',1,'solid'],
          ]    
setspdos4=[ ['Total',2,'blue',0.3,'solid'],
                      ['A $\it{4p}$',1,'purple',1,'solid'],
                      ['B $\it{3p}$',1,'green',1,'solid'],
                      ['C $\it{4s}$',1,'red',1,'solid'],
          ]    
setspdos5=[ ['Total',2,'blue',0.3,'solid'],
                      ['A $\it{4p}$',1,'purple',1,'solid'],
                      ['B $\it{3p}$',1,'green',1,'solid'],
                      ['C $\it{4s}$',1,'red',1,'solid'],
          ]      
# setspdos3=[ ['Total',1,'black',2,'solid'],['Mo $\it{1s}$',0,'orange',1.5,'solid'],
#            ['Mo $\it{2p}$','yellow',1.5,'solid'],
#            ['Mo $\it{4s}$',0,'pink',1.5,'solid'], 
#            ['Mo $\it{3d}$',1,'darkred',1.5,'solid'],
#            ['S $\it{1s}$',0,'cyan',1.5,'solid'], 
#            ['S $\it{2p}$',1,'blue',1.5,'solid'] ]    
plotsettings=[setspdos1,
               setspdos2, setspdos3 , setspdos4, setspdos5
              ]


all_listpdos=[listpdos_files1, 
               listpdos_files2, listpdos_files3, listpdos_files4, listpdos_files5
              ]

allPDOSfiles=[] # array with all PDOS files read with numpy
energies=[]  # array with energy range for each system

PDOSlist_alldata=[]  # array with all PDOS data (only density of states) for each system
for j in range(len(alldir)):
    listpdos_files = all_listpdos[j] ## read listpdos_files1, listpdos_files2, and so on.
    energy=[] ## read energy array of the system
    PDOSfile=[] ## stores the PDOSfile being read
    PDOSlist_data=[]  ## stores the PDOS data of the file
    for i in range(len(listpdos_files)):
        print(alldir[j]+listpdos_files[i])  ## prints the file being read
        PDOSfile.append(np.genfromtxt(alldir[j]+listpdos_files[i])) ## reads the file
        if i==0:
            energy=PDOSfile[i][:,0]-FERMI[j] ## gets the energy
        tmpPDOS = PDOSfile[i][:,1]  ## gets the PDOS
        tmpPDOS=tmpPDOS[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
        PDOSlist_data.append(tmpPDOS) 
        #PDOSlist_data.append(PDOSfile[i][:,1])
        #PDOSlist_data[i]=PDOSlist_data[i][energy>-RANGE_VB]
    allPDOSfiles.append(PDOSfile)
    PDOSlist_alldata.append(PDOSlist_data)
    energy=energy[(energy>-RANGE_VB) & (energy<RANGE_CB)] ## corrects to exclude values not to be plotted

    energies.append(energy)


###smoothing function
nw= 256
std = 1
window = gaussian(nw, std, sym=True)
for j in range(len(alldir)):
  for i in range(len(listpdos_files)):
      PDOSlist_alldata[j][i] = convolve(PDOSlist_alldata[j][i], window, mode='same') /np.sum(window)
print('value',np.max(PDOSlist_alldata[0][0]))

### have to smooth before getting max value
heightscale=1.05 ### this will determine how much will be blank on top of the graph
height_plots= []
for j in range(len(alldir)):
    height_plots.append(np.max(PDOSlist_alldata[j][0])*heightscale)
#sys.exit()
print(height_plots)


### PLOTANDO O GRAFICO ###########################################
#fig, (ax1,ax2,ax3) = plt.subplots(3,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig, axs = plt.subplots(len(alldir),1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})

## para conseguir colocar labels comuns a todos subplots
fig.add_subplot(111, frameon=False)

# add a big axis, hide frame
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
# hide tick and tick label of the big axis
plt.xlabel("Energy (eV)")
plt.ylabel("Density of states")
########
### DEFININDO OS TICKS EM X
majorxLocator   = MultipleLocator(1)
majorxFormatter = FormatStrFormatter('%d')
minorxLocator   = MultipleLocator(0.5)
### DEFININDO OS TICKS EM Y
majoryLocator   = MultipleLocator(5)
majoryFormatter = FormatStrFormatter('%d')
minoryLocator   = MultipleLocator(1)

abclist=list(string.ascii_lowercase)  ###lowercase alphabet list
i=0
setaxis=[-RANGE_VB, RANGE_CB, 0, np.max(height_plots) ]

for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### https://matplotlib.org/devdocs/gallery/subplots_axes_and_figures/subplots_demo.html


    for i in range(len(listpdos_files)):
     if plotsettings[j][i][1] == 1 : ## only what defined to be plotted
        ax.plot(energies[j],PDOSlist_alldata[j][i],label=plotsettings[j][i][0], 
                   color=plotsettings[j][i][2], lw=plotsettings[j][i][3], 
                   ls=plotsettings[j][i][4] )
     if plotsettings[j][i][1] == 2 : ## plots with filling
        ax.fill_between(energies[j],PDOSlist_alldata[j][i],y2=0,
                        color=plotsettings[j][i][2],
                        alpha=plotsettings[j][i][3], linewidth=0)
    ax.axis(setaxis)
    # axx.text(-RANGE_VB+0.2, 0.9*np.max(height_plots), "("+abclist[i]+")", fontsize=15)
    i+=1
    ax.xaxis.set_major_locator(majorxLocator)
    ax.xaxis.set_major_formatter(majorxFormatter)
    ax.xaxis.set_minor_locator(minorxLocator)
    ax.yaxis.set_major_locator(majoryLocator)
    ax.yaxis.set_major_formatter(majoryFormatter)
    ax.yaxis.set_minor_locator(minoryLocator)
    ax.set_yticklabels([])
    ax.axvline(x=0, ymin=setaxis[2], ymax=setaxis[3], ls='--', color='black')
        ## if you want to show each legend the following lines can be useful.
        #axx.legend(loc='upper left')
        #axx.legend(bbox_to_anchor=(1, 1),loc='upper left')
     #   axx.set_yticks([])
    plt.yticks([])

handles = [] 
labels = []
for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### make a text label to identify each compound
    compounds=['$A_3B_3C$','$A_3B_3C$','$A_3B_3C$',
               '$A_3B_3C$','$A_3B_3C$']

    ax.text(setaxis[1]-3,setaxis[3]-8, compounds[j],size=12)
    
    handle,label = ax.get_legend_handles_labels()
    handles.extend(x for x in handle if x not in handles)
    labels.extend(x for x in label if x not in labels)

if len(alldir) == 1:
     ax = axs
     ax.legend(handles,labels,bbox_to_anchor=(1, 1),labelspacing=0.3,
                 loc='upper left', frameon=False, prop={"size":12})
else:
        ax = axs[0]
        ax.legend(handles,labels,bbox_to_anchor=(1, 1),labelspacing=0.3,
                 loc='upper left', frameon=False, prop={"size":12})

    #ax[0].legend()
    
        # handles+=handle
        # labels+=label
print(handles, labels)
fig.set_size_inches(6.5, 4.5)
plt.tight_layout()
#plt.show()  ### only shows plot
fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.

## case you need graph with no axes.
# # Hide the right and top spines
# ax.spines['right'].set_visible(False)
# ax.spines['top'].set_visible(False)
# ax.spines['left'].set_visible(False)

# # Only show ticks on the left and bottom spines
# ax.yaxis.set_ticks_position('left')
# ax.xaxis.set_ticks_position('bottom')

# plt.ylabel("")
# ax.get_legend().remove()
# ax.axes.get_yaxis().set_visible(False)
#plt.show()  ### only shows plot
#fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.



