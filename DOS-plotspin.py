import numpy as np
import matplotlib.pyplot as plt
import math
import re
from matplotlib.ticker import MultipleLocator, FormatStrFormatter
import sys
#print("This is the name of the script: ", sys.argv[0])
#print("Number of arguments: ", len(sys.argv))
#print("The arguments are: " , str(sys.argv))

PREFIX=str(sys.argv[1])
SPIN=str(sys.argv[2])

### VERSAO COM SPIN
if SPIN == 'spin':
	#FERMI
	with open(PREFIX+'.dos') as f:
		first_line = f.readline()
	result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
	fermis=np.fromstring(result[0], dtype=float, sep=' ')
	FERMIup=float(fermis[0])
	FERMIdown=float(fermis[1])
	## LER DADOS DO DOS
	f = np.genfromtxt(PREFIX+'.dos')
	energyup = f[:,0]-FERMIup
	energydown = f[:,0]-FERMIdown
	DOSup = f[:,1]
	DOSdown = f[:,2]
	PDOS = f[:,3]

	##CALCULO DO GAP UP
	# indice do nivel de fermi no DOS
	index_fermiup = np.nonzero(energyup==0)[0]
	# pega o DOS acima do nivel de Fermi
	DOS_overfermiup = DOSup[energyup>0] 
	# pega os indices do DOS com valor consideravel
	index_DOSup=np.nonzero(DOS_overfermiup>0.1)[0]
	for i in range(len(index_DOSup)-1):
	#se os indices apresentam uma descontinuidade é a regiao de gap
		if index_DOSup[i] != index_DOSup[i+1]-1:   
			print(index_DOSup[i])
			idxVBup=index_DOSup[i]  # indice da VB
			idxCBup=index_DOSup[i+1] # indice da CB
			break  # so pega a primeira descontinuidade
	try:
		idxVBup
	except:
		print("Não encontrou GAP!")
		GAPup=0
	else:
		print("Existe gap, calculando...")
		index_topVBup = idxVBup+index_fermiup  # indice da VB no DOS inteiro
		index_botCBup = idxCBup+index_fermiup  # indice da CB no DOS inteiro
		#print(index_topVB,index_botCB)
		GAPup=energyup[index_botCBup[0]]-energyup[index_topVBup[0]]
		 #gap é a subtraçao das energias
		print('Valor do GAPup:',GAPup,' eV.')

	##CALCULO DO GAP DOWN
	# indice do nivel de fermi no DOS
	index_fermidown = np.nonzero(energydown==0)[0]
	# pega o DOS acima do nivel de Fermi
	DOS_overfermidown = DOSdown[energydown>0] 
	# pega os indices do DOS com valor consideravel
	index_DOSdown=np.nonzero(DOS_overfermidown>0.1)[0]
	for i in range(len(index_DOSdown)-1):
	#se os indices apresentam uma descontinuidade é a regiao de gap
		if index_DOSdown[i] != index_DOSdown[i+1]-1:   
			print(index_DOSdown[i])
			idxVBdown=index_DOSdown[i]  # indice da VB
			idxCBdown=index_DOSdown[i+1] # indice da CB
			break  # so pega a primeira descontinuidade
	try:
		idxVBdown
	except:
		print("Não encontrou GAPdown!")
		GAPdown=0
	else:
		print("Existe gap, calculando...")
		index_topVBdown = idxVBdown+index_fermidown  # indice da VB no DOS inteiro
		index_botCBdown = idxCBdown+index_fermidown  # indice da CB no DOS inteiro
		#print(index_topVB,index_botCB)
		GAPdown=energydown[index_botCBdown[0]]-energydown[index_topVBdown[0]]
		 #gap é a subtraçao das energias
		print('Valor do GAPdown:',GAPdown,' eV.')

	FERMI=0  ## FERMI vale 0 para o plot
	FAIXA_VB=6 ## quantos eV abaixo de Fermi
	FAIXA_CB=7  ## quantos eV acima de Fermi
	DOS=DOSup
	energy=energyup

	### DETERMINAR A ALTURA DO PLOT
	DOS_plotted=DOS[energy>FERMI-FAIXA_VB]
	altura_plot= np.max(DOS_plotted)*1.4

	### PLOTANDO O GRAFICO
	fig = plt.figure()
	ax = fig.add_subplot(111)
	ax.plot(energy,DOSup,'bo-',ms=1,label='DOS spin-up')
	ax.plot(energy,(-1)*DOSdown,'bo-',ms=1,label='DOS spin-down')
	#plt.plot(energy,PDOS,'rs-',label='PDOS')
	plt.xlabel("Energy (eV)")
	plt.ylabel("DOS")
	ax.axis([FERMI-FAIXA_VB, FERMI+FAIXA_CB, -altura_plot, altura_plot])
	ax.axvline(x=FERMI, color='red',linestyle='--')  ## linha do nivel de FERMI
	### FLECHA DUPLA INDICANDO BAND GAP UP
	if GAPup != 0:
		ax.arrow(energy[index_topVBup[0]], 0.04*altura_plot, GAPup, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
		ax.arrow(energy[index_botCBup[0]], 0.04*altura_plot, -GAPup, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

		ax.text(energy[index_topVBup[0]]+GAPup/2, 0.14*altura_plot, r'$E_g= $'+str(round(GAPup,2))+' eV', horizontalalignment='center')
	### FLECHA DUPLA INDICANDO BAND GAP DOWN
	if GAPdown != 0:
		ax.arrow(energy[index_topVBdown[0]], 0.04*altura_plot, GAPdown, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
		ax.arrow(energy[index_botCBdown[0]], 0.04*altura_plot, -GAPdown, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
		ax.text(energy[index_topVBdown[0]]+GAPdown/2, 0.14*altura_plot, r'$E_g= $'+str(round(GAPdown,2))+' eV', horizontalalignment='center')
	### DEFININDO OS TICKS EM X
	majorLocator   = MultipleLocator(1)
	majorFormatter = FormatStrFormatter('%d')
	minorLocator   = MultipleLocator(0.5)
	ax.xaxis.set_major_locator(majorLocator)
	ax.xaxis.set_major_formatter(majorFormatter)
	ax.xaxis.set_minor_locator(minorLocator)
	ax.legend(loc='upper right')
	plt.show()
	exit()  ## para não executar o loop sem spin.


####  SE NAO TIVER SPIN SEGUE O TRADICIONAL...

## EXTRAIR A ENERGIA DE FERMI DO DOS
with open(PREFIX+'.dos') as f:
	first_line = f.readline()
result = re.findall(r"Fermi *[^\w ] *(.*) eV", first_line, re.IGNORECASE | re.MULTILINE)
FERMI=float(result[0])

## LER DADOS DO DOS
f = np.genfromtxt(PREFIX+'.dos')
energy = f[:,0]-FERMI
DOS = f[:,1]
PDOS = f[:,2]


##CALCULO DO GAP
# indice do nivel de fermi no DOS
index_fermi = np.nonzero(energy==0)[0]
# pega o DOS acima do nivel de Fermi
DOS_overfermi = DOS[energy>0] 
# pega os indices do DOS com valor consideravel
index_DOS=np.nonzero(DOS_overfermi>0.1)[0]
for i in range(len(index_DOS)-1):
#se os indices apresentam uma descontinuidade é a regiao de gap
	if index_DOS[i] != index_DOS[i+1]-1:   
		print(index_DOS[i])
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
	index_topVB = idxVB+index_fermi  # indice da VB no DOS inteiro
	index_botCB = idxCB+index_fermi  # indice da CB no DOS inteiro
	#print(index_topVB,index_botCB)
	GAP=energy[index_botCB[0]]-energy[index_topVB[0]]
	 #gap é a subtraçao das energias
	print('Valor do GAP:',GAP,' eV.')

FERMI=0  ## FERMI vale 0 para o plot
FAIXA_VB=6 ## quantos eV abaixo de Fermi
FAIXA_CB=7  ## quantos eV acima de Fermi

### DETERMINAR A ALTURA DO PLOT
DOS_plotted=DOS[energy>FERMI-FAIXA_VB]
altura_plot= np.max(DOS_plotted)*1.4


### PLOTANDO O GRAFICO
fig = plt.figure()
ax = fig.add_subplot(111)
ax.plot(energy,DOS,'bo-',ms=1,label='DOS')
#plt.plot(energy,PDOS,'rs-',label='PDOS')
plt.xlabel("Energy (eV)")
plt.ylabel("DOS")
ax.axis([FERMI-FAIXA_VB, FERMI+FAIXA_CB, 0, altura_plot])
ax.axvline(x=FERMI, color='red',linestyle='--')  ## linha do nivel de FERMI

### FLECHA DUPLA INDICANDO BAND GAP
if GAP != 0:
	ax.arrow(energy[index_topVB[0]], 0.04*altura_plot, GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)
	ax.arrow(energy[index_botCB[0]], 0.04*altura_plot, -GAP, 0, head_width=0.6, head_length=0.5, color = 'black',  length_includes_head = True)

	ax.text(energy[index_topVB[0]]+GAP/2, 0.14*altura_plot, r'$E_g= $'+str(round(GAP,2))+' eV', horizontalalignment='center')

### DEFININDO OS TICKS EM X
majorLocator   = MultipleLocator(1)
majorFormatter = FormatStrFormatter('%d')
minorLocator   = MultipleLocator(0.5)
ax.xaxis.set_major_locator(majorLocator)
ax.xaxis.set_major_formatter(majorFormatter)
ax.xaxis.set_minor_locator(minorLocator)

ax.legend(loc='upper right')
plt.show()
#plt.savefig(PREFIX+'.eps', format='eps', dpi=1000)
