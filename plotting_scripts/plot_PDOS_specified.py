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
import glob, os

RANGE_VB=3.0 ## plotar quantos eV abaixo de Fermi
RANGE_CB=3.0  ## plotar quantos eV acima de Fermi

PREFIX="CSBrNC38pbe"
filename="SpecifiedPDOS_"+PREFIX  ## name to save figure in the end as filename.svg


nspin = 2   ## 2 means spin polarized # if spin polarized add label on setpdos
sumstates=1 ## if 1 it will sum all states in range except pdos_tot , else each 
            ## will be plotted individually

## directories where each projected DOS will be found for each graph.
PDOSdir='./NC38hs_final/PP/PDOS/' # './PP/PDOS/'
        
### set fermi value
#FERMI=[-4.275, -2.036,-2.115]
FERMI=-3.738 #,-2.115]
# FERMI=[-2.042]
 # fermi energies for each system find in out.nscf or prefix.dos
os.chdir(PDOSdir)
fileslist=[]
for index,file in enumerate(glob.glob(PREFIX+".pdos*",recursive=True)):
    print(index,file)
    fileslist.append(file)


pdostot_ind=fileslist.index(PREFIX+".pdos_tot")


### EXECUTAR COM ESSAS LINHAS ANTES PARA PEGAR SO A NUMERACAO DOS ATOMOS PARA DEPOIS
### INCLUIR NO WHICH PLOT
#print(fileslist)
# import sys
# sys.exit()

whichToPlot=list(range(34,49))+list(range(51,54))+[pdostot_ind]  ## Sb  ## pdostot_ind always in the end
#whichToPlot=list(range(0,34))+list(range(49,51))+list(range(95,97))+[pdostot_ind]  ## Br  ## pdostot_ind always in the end

listpdos_files=[ fileslist[i] for i in whichToPlot ]
print(listpdos_files)



all_listpdos=[  listpdos_files #, listpdos_files2, listpdos_files3
              ]
allPDOSfiles=[] # array with all PDOS files read with numpy
energies=[]  # array with energy range for each system

PDOSlist_alldata=[]  # array with all PDOS data (only density of states) for each system
energy=[] ## read energy array of the system
PDOSfile=[] ## stores the PDOSfile being read
PDOSlist_data=[]  ## stores the PDOS data of the file
for i in range(len(listpdos_files)):
        # print(listpdos_files[i])  ## prints the file being read
        PDOSfile.append(np.genfromtxt(listpdos_files[i])) ## reads the file
        if i==0:
            energy=PDOSfile[i][:,0]-FERMI ## gets the energy
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
# print(PDOSlist_alldata)
# import sys 
# sys.exit()

###smoothing function
nw= 256
std = 40
window = gaussian(nw, std, sym=True)

for i in range(len(listpdos_files)):
    # print(i)
    if nspin == 2:
        PDOSlist_alldata[0][i][0] = convolve(PDOSlist_alldata[0][i][0], window, mode='same') /np.sum(window)
        PDOSlist_alldata[0][i][1] = convolve(PDOSlist_alldata[0][i][1], window, mode='same') /np.sum(window)
    else:
        PDOSlist_alldata[0][i] = convolve(PDOSlist_alldata[0][i], window, mode='same') /np.sum(window)
# print('value',np.max(PDOSlist_alldata[0][0]))



### have to smooth before getting max value
heightscale=1.05 ### this will determine how much will be blank on top of the graph
height_plots= []

height_plots.append(np.max(PDOSlist_alldata[0][-1])*heightscale)
#sys.exit()
# print(height_plots)


### PLOTANDO O GRAFICO ###########################################
#fig, (ax1,ax2,ax3) = plt.subplots(3,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
fig, axs = plt.subplots(1,1,sharey=True,sharex=True, gridspec_kw={'hspace': 0})
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
# print(energies, PDOSlist_alldata )



# axs.plot(energies[0],PDOSlist_alldata[0][0] )
# axs.plot(energies[0],-PDOSlist_alldata[0][1] )



### https://matplotlib.org/devdocs/gallery/subplots_axes_and_figures/subplots_demo.html

ax = axs
if nspin==2:
    PDOSsumUP=np.zeros(len(PDOSlist_alldata[0][0][0]))
    PDOSsumDOWN=np.zeros(len(PDOSlist_alldata[0][0][0]))
else :
    PDOSsum=np.zeros(PDOSlist_alldata[0][i])
for i in range(len(listpdos_files)-1):  ## if sum states true will sum data in this part, if sumstates false, will plot individually here
          if sumstates == 1:
              PDOSsumUP+=np.array(PDOSlist_alldata[0][i][0])
              PDOSsumDOWN+=np.array(PDOSlist_alldata[0][i][1])
          else:
              if nspin == 2:
                  ax.plot(energies[0],PDOSlist_alldata[0][i][0],label=listpdos_files[i].split(".")[1])
                  ax.plot(energies[0],-PDOSlist_alldata[0][i][1],label=listpdos_files[i].split(".")[1])
              else:
                  ax.plot(energies[0],PDOSlist_alldata[0][i],label=listpdos_files[i].split(".")[1])

if sumstates == 1:
      ax.plot(energies[0],PDOSsumUP,label="UP SUM")
      ax.plot(energies[0],-PDOSsumDOWN,label="DOWN SUM")
## plot pdos_tot

if nspin == 2:
    ax.fill_between(energies[0],PDOSlist_alldata[0][-1][0],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 )
    ax.fill_between(energies[0],-PDOSlist_alldata[0][-1][1],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 ) 
else:
    ax.fill_between(energies[0],PDOSlist_alldata[0][-1],y2=0,
                    color="blue", 
                    alpha=0.3,linewidth=0 ) 

      
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
legendposition_tuple=(0.5, 1)

handles = []
labels = []

### make a text label to identify each compound
compounds=['','','',
            '$','$']

ax.text(setaxis[1]-3,setaxis[3]-8, compounds[0],size=16)

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

# if nspin == 2:
#     ax.legend(handles[::2],labels[::2],bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
#             loc='upper left', frameon=False, prop={"size":12})
# else:
# ax.legend(handles,labels,bbox_to_anchor=legendposition_tuple,labelspacing=0.3,
#         loc='upper left', frameon=False, prop={"size":12})
      # 
        # labels+=label
# print(handles, labels)
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


