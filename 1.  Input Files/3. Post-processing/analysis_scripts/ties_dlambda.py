import sys
import numpy as np

with open("lambda_list.dat", "r") as ins:
    lambda_list = [ float(line.strip('\n')) for line in ins.readlines()]

lambda_array = np.array((lambda_list))
lambda_mp = np.array(np.multiply(0.5,np.add(lambda_array[1:],lambda_array[:-1]) ))
lambda_mp = np.insert(lambda_mp,0,lambda_array[0])
last = int(len(lambda_array))
lambda_mp = np.append(lambda_mp,lambda_array[last-1])
a = float(sys.argv[1])
b = 1.0 - a
### check if a or b coincides with a lambda window
if (a or b) in lambda_array:
   print("ERROR: alchElecLambdaStart or (1 - alchElecLambdaStart) coincides with one of the Lambda values.")
   exit() 

def find_nearest(array,value):
    idx = (np.abs(array-value)).argmin()
    return idx
#    return array[idx],idx

x = find_nearest(lambda_mp,a)
y = find_nearest(lambda_mp,b)
#xi = x[1]
#x = x[0]
#yi = y[1]
#y = y[0] 
#print x,y,xi,yi
lambda_mp[x] = a
lambda_mp[y] = b
dlambda = np.array(np.subtract(lambda_mp[1:],lambda_mp[:-1]))
np.savetxt('dlambda_list.dat',dlambda,fmt='%.6f')
