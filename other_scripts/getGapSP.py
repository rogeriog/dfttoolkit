# import re
import glob
import numpy as np
# import matplotlib.pyplot as plt
# import sys

nspin=False
RANGE_VB=3
RANGE_CB=3
CUTOFF_DOS=1 ## value above is considered 1
fermi_idx_tol=500  ## difference in index from fermi index to consider gap close to fermi level




datatxt=""
for file in glob.glob("**/*.dos",recursive=True):
    if len(file.split("\\")[-1].split(".")) > 2:
        continue  ## case of out.*.dos files skipped
    name=str(file)
    print("DOS FILE GIVEN:", name)
    datatxt=datatxt+"DOS FILE GIVEN: "+name+"\n"
    datatxt=datatxt+"----------------------------------------------------------- \n"
    with open(file) as f:
        line0=f.readlines()[0].split()[-2]  ## to get efermi on top of .dos file
        fermi=float(line0)
    data = np.genfromtxt(file)
    #print(data[data[:,0]==fermi][0][1])
    print("fermi",fermi)


    ## test spin polarized
    if len(data[0,:]) > 3:
        nspin=True
        print("SPIN POLARIZED CONSIDERED!")

    ## only data in specified range
    data_in_range=data[data[:,0]>(fermi-RANGE_VB)]
    data_in_range=data_in_range[data_in_range[:,0]<(fermi+RANGE_CB)]
    energy=data_in_range[:,0]
    fermiidx=np.argwhere(energy==fermi)[0][0]
    if nspin:
        DOSup=np.where(data_in_range[:,1] > CUTOFF_DOS, 1, 0)
        DOSdown=np.where(data_in_range[:,2] > CUTOFF_DOS, 1, 0)
        DOSint=np.where(np.diff(data_in_range[:,3]) > 0.1, 1, 0)
    else:
        DOS=np.where(data_in_range[:,1] > CUTOFF_DOS, 1, 0)
        DOSint=np.where(np.diff(data_in_range[:,2]) > 0.1, 1, 0)
        
        
        
        ### detect all gaps in DOS, those closer to efermi are indicated.
    if nspin:
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSup):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-SpinUP:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-SpinUP: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"

                        
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSdown):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-SpinDOWN:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-SpinDOWN: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"                 
    
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOSint):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap-anySPIN:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap-anySPIN: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"

    else: ## no nspin
        counting=False
        idx0=0
        idx1=0
        for idx, entry in enumerate(DOS):
            if entry == 0 and counting==False:
                counting=True
                idx0=idx
                difftofermi=idx0-fermiidx 
            if entry == 1 and counting==True:
                counting=False
                idx1=idx
                gap=energy[idx1]-energy[idx0]
                if gap > 0.1:
                    print("gap:",energy[idx1]-energy[idx0])
                    datatxt=datatxt+"gap: "+str(energy[idx1]-energy[idx0])
                    if abs(difftofermi) < fermi_idx_tol:
                        print("Probably real gap, close to Efermi")
                        datatxt=datatxt+"  Probably real gap, close to Efermi \n"
                    else:
                        datatxt=datatxt+"\n"
    # plt.plot(data_in_range[:,0], DOSdown)
    datatxt=datatxt+"----------------------------------------------------------- \n"
with open("gaps.txt", "w") as text_file:
        text_file.write(datatxt)


