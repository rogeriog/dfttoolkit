import re
f= open("torelax", "r") ## file containing atomic positions that will be allowed to relax
atomscoord=[]
for line in f:
  atomscoord.append(line)
f.close()

## to implement something that verifies disregarding spaces and with tolerance may use these lines
#  line = line.strip().split()
#  atomscoord.append([line[0],line[1],line[2],line[3]])  
#print(coordsrel)

readcontents = ""
g = open("CsSbBr221-VBr1.relax.in", "r")  ## file containing the input file with all atomic coordinates
readv=0
index=1
nat=0
for line in g:
   if ("nat" in  line) :
        match = re.search("nat\s{0,}.\s{0,}(\d{1,})", line)
        nat = int(match.group(1))
        print(nat)
   if ("ATOMIC_POSITIONS" in line) :   ## looks for the entry where atomic positions are defined
        print(" ATOMIC POSITIONS ENTRY FOUND")
        readv=1
        continue
   if  ( readv and  index <=  nat ) :
        if line in atomscoord:
           readcontents += line
        else:
           readcontents += line.strip() + " 0 0 0 \n"
        index = index + 1

print(readcontents)
