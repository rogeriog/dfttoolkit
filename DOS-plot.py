import numpy as np
import matplotlib.pyplot as plt
import math
import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
from cycler import cycler
import sys, os
#print("This is the name of the script: ", sys.argv[0])
#print("Number of arguments: ", len(sys.argv))
#print("The arguments are: " , str(sys.argv))
#glob.glob(PDOS_FOLDER)
    
# procurar por arquivos com o prefixo.
# prefix.pdos_atm#*\(AT)_wfc#1(s) 
# para cada AT somar todas wfc1,2,3,4...
# invocar sumpdos.x para somar os arquivos.
# arquivo de saida padrao pdos.prefix.AT.wfc*
# plotar todos os arquivos varrendo numero de atomos depois em wfc. plotar com diferentes cores.

PREFIX=str(sys.argv[1])
## EXTRAIR A ENERGIA DE FERMI DO DOS
if not os.path.isfile(PREFIX+'.dos'):
	exit() 

with open(PREFIX+'.dos') as f:
	first_line = f.readline()
result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
FERMI=float(result[0])

## LER DADOS DO DOS
f = np.genfromtxt(PREFIX+'.dos')
energy = f[:,0]-FERMI
DOS = f[:,1]

## LISTA DE ARQUIVOS PDOS
if len(sys.argv)>2 :
	PDOS_FILES = [sys.argv[i] for i in np.arange(len(sys.argv)) if i >= 2]


######## CALCULO DO GAP ################################
# indice do nivel de fermi no DOS
## energy == -0.05 para conseguir encontrar o gap em sistemas que a energia
## de fermi tem um dos muito pequeno.
index_fermi = np.nonzero(energy==0)[0]
# pega o DOS acima do nivel de Fermi
DOS_overfermi = DOS[energy>-0.5] 
# pega os indices do DOS com valor consideravel
index_DOS=np.nonzero(DOS_overfermi>0.1)[0]
for i in range(len(index_DOS)-1):
#se os indices apresentam uma descontinuidade é a regiao de gap
	if (index_DOS[i] != index_DOS[i+1]-1) : #and (index_DOS[i] > 500 ):   
		idxVB=index_DOS[i]  # indice da VB
		idxCB=index_DOS[i+1] # indice da CB
		break  # so pega a primeira descontinuidade
try:
	idxVB
except:
	print("Não encontrou GAP!")
	GAP=0
else:
	print("Existe gap, calculando...")
	index_topVB = index_fermi  # indice da VB no DOS inteiro
	index_botCB = idxCB-idxVB+index_fermi  # indice da CB no DOS inteiro
#	index_topVB = idxVB+index_fermi  # indice da VB no DOS inteiro
#	index_botCB = idxCB+index_fermi  # indice da CB no DOS inteiro
	#print(index_topVB,index_botCB)
	GAP=energy[index_botCB[0]]-energy[index_topVB[0]]
	 #gap é a subtraçao das energias
	print('Valor do GAP pelo DOS:',GAP,' eV.')

FAIXA_VB=6 ## quantos eV abaixo de Fermi
FAIXA_CB=7  ## quantos eV acima de Fermi

### DETERMINAR A ALTURA DO PLOT
DOS_plotted=DOS[energy>-FAIXA_VB]
altura_plot= np.max(DOS_plotted)*1.4

### PLOTANDO O GRAFICO ###########################################
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(energy,DOS,lw=0)
#ax.fill_between(energy,DOS,0, facecolor="gray", label='DOS', alpha=0.4)
#ax.fill_between(energy,DOS,0, facecolor="mediumpurple", label='DOS', alpha=1)
#ax.fill_between(energy,DOS,0, facecolor="darkseagreen", label='DOS', alpha=0.4)  # zno
ax.fill_between(energy,DOS,0, facecolor="lightsteelblue", label='DOS', alpha=0.4)

##
#custom color cycle
#custom_cycler = (cycler(color=['darkgreen', 'orange', 'blue', 'pink', 'cyan']) )
#custom_cycler = (cycler(color=['blue', 'cyan', 'blueviolet', 'mediumorchid', 'red', 'orange', 'darkgreen', 'lime', 'pink']) )
#custom_cycler = (cycler(color=[ 'darkgreen', 'red', 'gold']) )
custom_cycler = (cycler(color=[ 'darkgreen', 'lime', 'gold', 'red']) )
##               +   cycler(linestyle=['-', '--', ':', '-.']))
ax.set_prop_cycle(custom_cycler)
if len(sys.argv)>2 :
	for pdos in PDOS_FILES:
		if pdos == 'PDOS/sum.SCtio2anataseU-1NB.Nb4d' :
			pdos_data = np.genfromtxt(pdos)
			energy_pdos = pdos_data[:,0]-FERMI
			pdos_dos = pdos_data[:,1]*5
			ax.fill_between(energy_pdos,pdos_dos, facecolor='red', alpha=0.4 ,label=pdos.split(".")[-1]+ ' X5')
		else:
			pdos_data = np.genfromtxt(pdos)
			energy_pdos = pdos_data[:,0]-FERMI
			pdos_dos = pdos_data[:,1]
			ax.plot(energy_pdos,pdos_dos,ms=1,label=pdos.split(".")[-1])

#plt.plot(energy,PDOS,'rs-',label='PDOS')
plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
ax.axis([-FAIXA_VB, FAIXA_CB, 0, altura_plot])
ax.axvline(x=0, color='black',linestyle='--')  ## linha do nivel de FERMI

if not os.path.isfile('../gap_nscf'):
	gap_nscf = GAP
	print('There is no NSCF gap, using gap calculated from DOS.')
else
	gap_nscf = float(np.genfromtxt('../gap_nscf'))
	print('Gap given by NSCF calculation will be used.')
	

### FLECHA DUPLA INDICANDO BAND GAP
if (GAP != 0) and (GAP > 1.3 ):
	ax.arrow(energy[index_topVB[0]], 0.04*altura_plot, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
	ax.arrow(energy[index_botCB[0]], 0.04*altura_plot, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

	ax.text(energy[index_topVB[0]]+GAP/2, 0.14*altura_plot, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')

if (GAP != 0) and (GAP < 1.3 ):
	ax.arrow(energy[index_topVB[0]], 0.04*altura_plot, GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)
	ax.arrow(energy[index_botCB[0]], 0.04*altura_plot, -GAP, 0, head_width=0.3, head_length=0.2, color = 'black',  length_includes_head = True)

	ax.text(3, 0.92*altura_plot, r'$E_g= $'+str(round(gap_nscf,2))+' eV', horizontalalignment='center')
### DEFININDO OS TICKS EM X
majorLocator   = MultipleLocator(1)
majorFormatter = FormatStrFormatter('%d')
minorLocator   = MultipleLocator(0.5)
ax.xaxis.set_major_locator(majorLocator)
ax.xaxis.set_major_formatter(majorFormatter)
ax.xaxis.set_minor_locator(minorLocator)

##### ORDEM DAS LEGENDAS TEM QUE SER CORRIGIDA
handles,labels = ax.get_legend_handles_labels()

handles = handles[-1:] + handles[:-1]
labels = labels[-1:] + labels[:-1]
#handles = handles[-2:] + handles[:-2]
#labels = labels[-2:] + labels[:-2]
#handles = [handles[0], handles[2], handles[1]]
#labels = [labels[0], labels[2], labels[1]]

ax.legend(handles,labels,loc='upper right')

#plt.show()
plt.savefig(PREFIX+'.eps', format='eps', dpi=1000)
