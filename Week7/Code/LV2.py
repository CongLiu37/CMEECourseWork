"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: LV2.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: sys, numpy, scipy.integrate, matplotlib.pylab
   Input: 
   Function: Simulate Lotka-Volterra model with prey density dependence 
             and visualize results in two ways. Parameters should be provided by user.
             If no parameter is provided, following default values will be used:
             r = 1
             a = 0.1
             z = 1.5
             e = 0.75
             K =  1,000,000
             The final densities of resource and consumer are printed.
   Output: Results/LV.pdf
           Results/LV1.pdf
   Usage: python LV2.py [r] [a] [z] [e] [K]
   Date: Nov, 2020"""

import sys
import os
import numpy as np
import scipy.integrate as integrate
import matplotlib.pylab as p

try:
   r = float(sys.argv[1])
   a = float(sys.argv[2])
   z = float(sys.argv[3])
   e = float(sys.argv[4])
   K = float(sys.argv[5])
except IndexError:
   r = 1
   a = 0.1
   z = 1.5
   e = 0.75
   K = 1000000


def dCR_dt(pops, t=0, r = 1, a = 0.1, z = 1.5, e = 0.75, K = 1000000):
    """Cauculate dR/dt and dC/dt, where t is time, 
       R and C are densities of resources and consumers."""
    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R/K) - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return np.array([dRdt, dCdt])



t = np.linspace(0, 15, 1000)

R0 = 10
C0 = 5 
RC0 = np.array([R0, C0])

#Integration
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

print(pops[-1,:])

#Plotting
f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.legend(loc='best')
p.text(9.6,35,"r = " + str(r))
p.text(9.6,33.8,"a = " + str(a))
p.text(9.6,32.6,"z = " + str(z))
p.text(9.6,31.4,"e = " + str(e))
p.text(9.6,30.2,"K = " + str(int(K)))
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
#p.show()# To display the figure
f1.savefig('../Results/LV2_1.pdf') #Save figure

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], "r-")
p.text(32.5,23,"r = " + str(r))
p.text(32.5,22.3,"a = " + str(a))
p.text(32.5,21.6,"z = " + str(z))
p.text(32.5,20.9,"e = " + str(e))
p.text(32.5,20.2,"K = " + str(int(K)))
p.xlabel("Resource density")
p.ylabel("Consumer density")
p.title("Consumer-Resource population dynamics")
f2.savefig("../Results/LV2_2.pdf")



