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

RANGE_VB=4.0 ## plotar quantos eV abaixo de Fermi
RANGE_CB=4.0  ## plotar quantos eV acima de Fermi


filename="prefix"  ## name to save figure in the end as filename.svg
nspin = 2   ## 2 means spin polarized # if spin polarized add label on setpdos
## directories where each projected DOS will be found for each graph.
alldir=['./PP/PDOS/' , # './PP/PDOS/'
         ] 

#FERMI=[-4.275, -2.036,-2.115]
FERMI=[ 0.0 ]#,-2.115]
# FERMI=[-2.042]
 # fermi energies for each system find in out.nscf or prefix.dos
listpdos_files1=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]

listpdos_files2=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]

listpdos_files3=['p.pdos_tot','sumpdos_p.Sb3p',
                 'sumpdos_p.Br2p','sumpdos_p.Sb2s' 
                 ]


## if 1 in second field the corresponding file will be plotted if 0 not plotted
## if 2 filled plot
setspdos1=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]

setspdos2=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]

setspdos3=[ ['Total',2,'blue','blue',0.3,'solid'],
                      ['Sb $\it{5p}$',1,'purple','purple',1,'solid'],
                      ['Br $\it{4p}$',1,'green','green',1,'solid'],
                      ['Sb $\it{5s}$',1,'blue','blue',1,'solid'],
          ]


plotsettings=[  setspdos1 #, setspdos2, setspdos3
              ]
# plotsettings=[setspdos4
#                ]

all_listpdos=[  listpdos_files1 #, listpdos_files2, listpdos_files3
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
        
        if nspin == 2:
            tmpPDOS2 = PDOSfile[i][:,2]  ## gets the PDOS
            tmpPDOS2=tmpPDOS2[(energy>-RANGE_VB) & (energy<RANGE_CB)]  ## corrects to exclude values not to be plotted
            PDOSlist_data.append([tmpPDOS,tmpPDOS2])    
        else:
            PDOSlist_data.append(tmpPDOS)
        
        # PDOSlist_data.append(PDOSfile[i][:,1])
        # PDOSlist_data[i]=PDOSlist_data[i][energy>-RANGE_VB]
    allPDOSfiles.append(PDOSfile)
    PDOSlist_alldata.append(PDOSlist_data)
    energy=energy[(energy>-RANGE_VB) & (energy<RANGE_CB)] ## corrects to exclude values not to be plotted

    energies.append(energy)
print(PDOSlist_alldata)
# import sys 
# sys.exit()

###smoothing function
nw= 256
std = 1
window = gaussian(nw, std, sym=True)
for j in range(len(alldir)):
  print(j)
  for i in range(len(listpdos_files)):
      print(i)
      if nspin == 2:
          PDOSlist_alldata[j][i][0] = convolve(PDOSlist_alldata[j][i][0], window, mode='same') /np.sum(window)
          PDOSlist_alldata[j][i][1] = convolve(PDOSlist_alldata[j][i][1], window, mode='same') /np.sum(window)
      else:
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
fig.set_figheight(4)
fig.set_figwidth(8)
plt.rcParams['font.size']=14

## para conseguir colocar labels comuns a todos subplots
fig.add_subplot(111, frameon=False)

# add a big axis, hide frame
plt.tick_params(labelcolor='none', top=False, bottom=False, left=False, right=False)
# hide tick and tick label of the big axis
plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
########
### DEFININDO OS TICKS EM X
majorxLocator   = MultipleLocator(1)
majorxFormatter = FormatStrFormatter('%d')
minorxLocator   = MultipleLocator(0.5)
### DEFININDO OS TICKS EM Y
majoryLocator   = MultipleLocator(40)
majoryFormatter = FormatStrFormatter('%d')
minoryLocator   = MultipleLocator(20)

abclist=list(string.ascii_lowercase)  ###lowercase alphabet list
i=0
if nspin ==2 :
    setaxis=[-RANGE_VB, RANGE_CB, -np.max(height_plots), np.max(height_plots) ]
else :
    setaxis=[-RANGE_VB, RANGE_CB, 0, np.max(height_plots) ]
print(energies, PDOSlist_alldata )



# axs.plot(energies[0],PDOSlist_alldata[0][0] )
# axs.plot(energies[0],-PDOSlist_alldata[0][1] )

# import sys
# sys.exit()
for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### https://matplotlib.org/devdocs/gallery/subplots_axes_and_figures/subplots_demo.html


    for i in range(len(listpdos_files)):
      if plotsettings[j][i][1] == 1 : ## only what defined to be plotted
          if nspin == 2:
              ax.plot(energies[j],PDOSlist_alldata[j][i][0],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][2], lw=plotsettings[j][i][4],
                    ls=plotsettings[j][i][5] )
              ax.plot(energies[j],-PDOSlist_alldata[j][i][1],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][3], lw=plotsettings[j][i][4],
                    ls=plotsettings[j][i][5] )
          else:
              ax.plot(energies[j],PDOSlist_alldata[j][i],label=plotsettings[j][i][0],
                    color=plotsettings[j][i][2], lw=plotsettings[j][i][3],
                    ls=plotsettings[j][i][4] )
      if plotsettings[j][i][1] == 2 : ## plots with filling
          if nspin == 2:
              ax.fill_between(energies[j],PDOSlist_alldata[j][i][0],y2=0,
                              color=plotsettings[j][i][2], 
                              alpha=plotsettings[j][i][4],linewidth=0 )
              ax.fill_between(energies[j],-PDOSlist_alldata[j][i][1],y2=0,
                              color=plotsettings[j][i][3], 
                              alpha=plotsettings[j][i][4],linewidth=0 )
          else:
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
    #ax.set_yticklabels([])
    #ax.axvline(x=0, ymin=setaxis[2], ymax=setaxis[3], ls='--', color='black',alpha=0.5)
        ## if you want to show each legend the following lines can be useful.
        #axx.legend(loc='upper left')
        #axx.legend(bbox_to_anchor=(1, 1),loc='upper left')
      #   axx.set_yticks([])
   # plt.yticks([])
   
   ##### LEGEND POSITION
legendposition_tuple=(1, 1)

handles = []
labels = []
for j in range(len(alldir)):
    if len(alldir) == 1:
        ax = axs
    else:
        ax = axs[j]
### make a text label to identify each compound
    compounds=['','','',
                '$','$']

    ax.text(setaxis[1]-3,setaxis[3]-8, compounds[j],size=16)

    handle,label = ax.get_legend_handles_labels()
    
    if nspin!=2:
        handles.extend(x for x in handle if x not in handles)
        labels.extend(x for x in label if x not in labels)
    else:
        handles=handle
        labels=label
    # else:
    #     handles.extend(x for x in handle if x not in handles)
    #     labels.extend(x for x in label if x not in labels)
if len(alldir) == 1:
      ax = axs
      if nspin == 2:
          ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
      else:
          ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
      # 
else:
        ax = axs[0]
        if nspin == 2:
          ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
        else:
          ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
                  loc='upper left', frameon=False, prop={"size":16})
        # ax[0].legend()

        # handles+=handle
        # labels+=label
print(handles, labels)
# for j in range(len(alldir)):
#       if len(alldir) == 1:
#           ax = axs
#       else:
#           ax = axs[j]
#       ax.legend()


fig.set_size_inches(8.5, 5.5)
plt.tight_layout()
#plt.show()  ### only shows plot
fig.savefig(filename+'.svg', format='svg', dpi=1000)  ## to save a file.
fig.savefig(filename+'.png', format='png', dpi=1000)  ## to save a file.

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

