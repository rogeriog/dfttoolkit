# -*- coding: utf-8 -*-
"""
Created on Tue Oct 27 17:43:25 2020

@author: roger
"""


import numpy as np
import matplotlib.pyplot as plt
import matplotlib.tri as tri




# first load some data:  format x1,x2,x3,value
test_data = np.array([[0,0,1,0.5],
                      [0,1,0,1],
                      [1,0,0,0],
                      [0.55,0.55,0.5,0.5],
                      [0.25,0.25,0.5,1],
                      [0.25,0.5,0.25,1],
                      [0.5,0.25,0.25,1]])

# barycentric coords: (a,b,c)
a=test_data[:,0]
b=test_data[:,1]
c=test_data[:,2]

# values is stored in the last column
v = test_data[:,-1]

# translate the data to cartesian corrds
x = 0.5 * ( 2.*b+c ) / ( a+b+c )
y = 0.5*np.sqrt(3) * c / (a+b+c)


# create a triangulation out of these points
T = tri.Triangulation(x,y)

# plot the contour
plt.tricontourf(x,y,T.triangles,v)


# create the grid
corners = np.array([[0, 0], [1, 0], [0.5,  np.sqrt(3)*0.5]])
triangle = tri.Triangulation(corners[:, 0], corners[:, 1])

# creating the grid
refiner = tri.UniformTriRefiner(triangle)
trimesh = refiner.refine_triangulation(subdiv=4)

#plotting the mesh
plt.triplot(trimesh,'k--')


plt.show()
