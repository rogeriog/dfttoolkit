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
f = open(PREFIX,"r")

#dicionarios
ATOMCOORD= {} 
CELL={}

#inicializa
SCF_step=0
#ATOMCOORD[SCF_step]= [] 
#CELL[SCF_step]=[]

copy = False
bucket = []
bucket2 = [] 
for line in f:
	if re.search('number of atoms/cell', line):
		fields = line.strip().split()
		atomos = fields[4]

	if re.search('ATOMIC_POSITIONS', line):
		copy=True
		bucket=[]
	elif not line.strip():
		ATOMCOORD[SCF_step] = bucket
		copy=False
	elif copy:
		bucket.append(line.strip())
#		print(line.strip().split())
	if re.search('End of self-consistent calculation', line):
		SCF_step += 1

print(ATOMCOORD)
### por algum motivo ele fecha o arquivo depois do loop
## posso tentar depois juntar os dois loops, o problema e as linhas
## vazias criarem inconsistencia
f = open(PREFIX,"r")
copy = False
SCF_step = 0
bucket2 = [] 
for line in f:
	if re.search('CELL_PARAMETERS', line):
		copy=True
		bucket2=[]
	elif not line.strip():
		CELL[SCF_step] = bucket2
		copy=False
	elif copy:
		print(line)
	
	if re.search('End of self-consistent calculation', line):
		SCF_step += 1

print(CELL)

#	if re.search('CELL_PARAMETERS', line):
#		copy=True
#	elif copy:
#		CELL[SCF_step].append(line)
#	elif not line.strip() :
#		print('anything')
#		copy=False
		
### PLOTANDO O GRAFICO
#fig = plt.figure()
#ax = fig.add_subplot(111)
#plt.plot(range(len(TOT_ENERGY[SCF_step])),TOT_ENERGY[SCF_step],'bo-',ms=0.1,label='Total Energy')
#plt.plot(range(len(Harris_ENERGY[SCF_step])),Harris_ENERGY[SCF_step],'r-',ms=0.1,label='Harris Foulkes estimate')
#plt.errorbar(range(len(TOT_ENERGY[SCF_step])), TOT_ENERGY[SCF_step], yerr=SCFaccur_ENERGY[SCF_step], fmt='o')

#plt.xlabel("iteration")
#plt.ylabel("Energy (Ry)")

### DEFININDO OS TICKS EM X
#majorLocator   = MultipleLocator(1)
#majorFormatter = FormatStrFormatter('%d')
#minorLocator   = MultipleLocator(0.5)
#ax.xaxis.set_major_locator(majorLocator)
#ax.xaxis.set_major_formatter(majorFormatter)
#ax.xaxis.set_minor_locator(minorLocator)

#plt.show()

