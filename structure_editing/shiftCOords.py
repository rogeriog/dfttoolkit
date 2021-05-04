import numpy as np
import pandas as pd
filename="CSBrNC73qUcoords.in"
data=pd.read_csv(filename, sep='\s+',header=None)
# print(data)
# print(data[1]) ## get column
# print(data[1:]) ## get rows 1 onwards

for i in [1,2,3]:
    data[i]=round(data[i]+13.5,5)


data.to_csv("CSBrNC73qUcoords_shifted.in", sep="\t",index=False, header=False)