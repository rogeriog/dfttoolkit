#####################################################
### THIS PROGRAM PERFORMS SUCCESSIVE ROTATIONS IN A GIVEN VECTOR
### FOR EXAMPLE:
### USE $>  python rotate.py [vx,vy,vz] x=30 y=90
### TO ROTATE VECTOR V=[vx,vy,vz] 30 degrees in X and 90 degrees in Y
#####################################################

import numpy as np
import sys
import os

def unit_vector(vector):
    """ Returns the unit vector of the vector."""
    return vector / np.linalg.norm(vector)

def angle_between(v1, v2):
    """Finds angle between two vectors"""
    v1_u = unit_vector(v1)
    v2_u = unit_vector(v2)
    return np.arccos(np.clip(np.dot(v1_u, v2_u), -1.0, 1.0))

def x_rotation(vector,theta):
    """Rotates 3-D vector around x-axis"""
    R = np.array([[1,0,0],[0,np.cos(theta),-np.sin(theta)],[0, np.sin(theta), np.cos(theta)]])
    return np.dot(R,vector)

def y_rotation(vector,theta):
    """Rotates 3-D vector around y-axis"""
    R = np.array([[np.cos(theta),0,np.sin(theta)],[0,1,0],[-np.sin(theta), 0, np.cos(theta)]])
    return np.dot(R,vector)

def z_rotation(vector,theta):
    """Rotates 3-D vector around z-axis"""
    R = np.array([[np.cos(theta), -np.sin(theta),0],[np.sin(theta), np.cos(theta),0],[0,0,1]])
    return np.dot(R,vector)


def strip_first_col(fname, delimiter=None):
    with open(fname, 'r') as fin:
        for line in fin:
            try:
               yield line.split(delimiter, 1)[1]
            except IndexError:
               continue

def insertline(originalfile,string):
    with open(originalfile,'r') as f:
        with open('newfile.txt','w') as f2: 
            f2.write(string)
            f2.write(f.read())
    os.rename('newfile.txt',originalfile)


#### function to rotate a vector from user input
def rotate_vector(vector):
   for n in range(2, len(sys.argv)) :
       if sys.argv[n].startswith('x=') : 
         dummy, angle = sys.argv[n].split('=')
         angle=float(angle)*np.pi/180
         vector = x_rotation(vector, float(angle))
       elif sys.argv[n].startswith('y=') : 
         dummy, angle = sys.argv[n].split('=')
         angle=float(angle)*np.pi/180
         vector = y_rotation(vector, float(angle))
       elif sys.argv[n].startswith('z=') : 
         dummy, angle = sys.argv[n].split('=')
         angle=float(angle)*np.pi/180
         vector = z_rotation(vector, float(angle))
       else:
         print('ERROR, no axis defined.')
   return vector 

## take name and extension from file
filename, extension= os.path.splitext(sys.argv[1])

# read data from input xyz file
data = np.genfromtxt(sys.argv[1], skip_header=2, dtype=None )


atoms = [ ]
coord_x = [ ]
coord_y = [ ]
coord_z = [ ]
for entry in data:
	atoms.append(entry[0])
	coord_x.append(entry[1])
	coord_y.append(entry[2])
	coord_z.append(entry[3])
atoms = np.array(atoms)
coord_x = np.array(coord_x)
coord_y = np.array(coord_y)
coord_z = np.array(coord_z)

## create vectors
vectors = np.column_stack((coord_x,coord_y,coord_z))

## create rotated array
vectors = np.asarray( [ rotate_vector(v) for v in vectors] )
print(vectors)

## append atoms to new array and decode goddamn bytes
newxyz = np.column_stack((atoms, vectors))
newxyz = [ [ item.decode('UTF-8') for item in element] for element in newxyz]


print(newxyz)
## save xyz file
np.savetxt(filename+'_rotated.xyz', newxyz, fmt='%s')

## add header to xyz file  ## couldnt do it directly in the array
insertline(filename+'_rotated.xyz', str(len(data))+'\n'+'\n')
