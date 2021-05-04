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


TOT_ENERGY= {} 
Harris_ENERGY={}
SCFaccur_ENERGY={}

SCF_step=1
#for SCF_step in 
##  queria fazer por scfstep assim podia separar iteracoes diferentes
## durante a relaxacao "End of self-consitent..." determina cada fim.
TOT_ENERGY[SCF_step]= [] 
Harris_ENERGY[SCF_step]=[]
SCFaccur_ENERGY[SCF_step]=[]
 
for line in f:
	if re.search('total energy', line):
		if line.startswith('!'):  ## its necessary for the final total energy which starts with an !
			index=4
		else:
			index=3 

		fields = line.strip().split()

		try:     ## if it shows up in a string it will disconsider
			TOT_ENERGY[SCF_step].append(float(fields[index]))
		except:
			pass
	if re.search('Harris-Foulkes', line):
		fields = line.strip().split()
		Harris_ENERGY[SCF_step].append(float(fields[3]))
	if re.search('estimated scf accuracy', line):
		fields = line.strip().split()
		SCFaccur_ENERGY[SCF_step].append(float(fields[4]))
#print(TOT_ENERGY[SCF_step])
#print(range(len(TOT_ENERGY[SCF_step])))
#print(Harris_ENERGY[SCF_step])
#print(SCFaccur_ENERGY[SCF_step])
### PLOTANDO O GRAFICO
fig = plt.figure()
ax = fig.add_subplot(111)
plt.plot(range(len(TOT_ENERGY[SCF_step])),TOT_ENERGY[SCF_step],'bo-',ms=0.1,label='Total Energy')
plt.plot(range(len(Harris_ENERGY[SCF_step])),Harris_ENERGY[SCF_step],'r-',ms=0.1,label='Harris Foulkes estimate')
plt.errorbar(range(len(TOT_ENERGY[SCF_step])), TOT_ENERGY[SCF_step], yerr=SCFaccur_ENERGY[SCF_step], fmt='o')
#plt.errorbar(range(len(TOT_ENERGY[SCF_step])), TOT_ENERGY[SCF_step], yerr=[math.log10(x) for x in SCFaccur_ENERGY[SCF_step]], fmt='o')

plt.xlabel("iteration")
plt.ylabel("Energy (Ry)")
### DEFININDO OS TICKS EM X
#majorLocator   = MultipleLocator(1)
#majorFormatter = FormatStrFormatter('%d')
#minorLocator   = MultipleLocator(0.5)
#ax.xaxis.set_major_locator(majorLocator)
#ax.xaxis.set_major_formatter(majorFormatter)
#ax.xaxis.set_minor_locator(minorLocator)

#ax.legend(loc='upper right')
plt.show()

# End of self-consistent calculation
#	        re.search(r'^Stream\:\s([^\n]+)', f.read(), re.MULTILINE).group(1)
 
