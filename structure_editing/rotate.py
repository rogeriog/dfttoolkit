#####################################################
### THIS PROGRAM PERFORMS SUCCESSIVE ROTATIONS IN A GIVEN VECTOR
### FOR EXAMPLE:
### USE $>  python rotate.py [vx,vy,vz] x=30 y=90
### TO ROTATE VECTOR V=[vx,vy,vz] 30 degrees in X and 90 degrees in Y
#####################################################

import numpy as np
import sys

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

#print("This is the name of the script: ", sys.argv[0])
#print("Number of arguments: ", len(sys.argv))
#print("The arguments are: " , str(sys.argv))


# input must be in format n,n,n or [n,n,n]
v = np.fromstring(sys.argv[1].strip("[]"), dtype=float, sep=',')
for n in range(2, len(sys.argv)) :
    if sys.argv[n].startswith('x=') : 
      dummy, angle = sys.argv[n].split('=')
      angle=float(angle)*np.pi/180
      print(angle)
      v = x_rotation(v, float(angle))
    elif sys.argv[n].startswith('y=') : 
      dummy, angle = sys.argv[n].split('=')
      angle=float(angle)*np.pi/180
      v = y_rotation(v, float(angle))
    elif sys.argv[n].startswith('z=') : 
      dummy, angle = sys.argv[n].split('=')
      angle=float(angle)*np.pi/180
      v = z_rotation(v, float(angle))
    else:
      print('ERROR, no axis defined.')
print(v)

