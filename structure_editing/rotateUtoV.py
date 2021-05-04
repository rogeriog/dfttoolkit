import numpy as np

### ler o vetor v ###
#v = np.array([ v1, v2, v3  ])
v = np.array([ 1, 1, 0 ])

### ler o vetor u ###
#u = np.array([ u1, u2, u3 ])
u = np.array([ 0, 0, 1 ])
### tomar o produto vetorial
a  = np.cross(u, v) / np.linalg.norm(np.cross(u,v))
print(a)

alfa = np.arccos(np.dot(u,v))
print(alfa)
c = np.cos(alfa)
s = np.sin(alfa)

m1= [ np.square(a[0])*(1-c), a[0]*a[1]*(1-c)-s*a[2], a[0]*a[2]*(1-c)+s*a[1] ]
m2= [ a[0]*a[1]*(1-c)+s*a[2], np.square(a[1])*(1-c)+c , a[1]*a[2]*(1-c)-s*a[1]]
m3= [ a[0]*a[2]*(1-c)+s*a[1],  a[1]*a[2]*(1-c)+s*a[0] , np.square(a[2])*(1-c) + c ]

M = np.matrix( [ [ np.square(a[0])*(1-c) + c, a[0]*a[1]*(1-c)-s*a[2], a[0]*a[2]*(1-c)+s*a[1] ], [ a[0]*a[1]*(1-c)+s*a[2], np.square(a[1])*(1-c)+c , a[1]*a[2]*(1-c)-s*a[1] ],  [ a[0]*a[2]*(1-c)-s*a[1],  a[1]*a[2]*(1-c)+s*a[0] , np.square(a[2])*(1-c) + c ]]  )

print(M)

print(np.dot(u, M))

