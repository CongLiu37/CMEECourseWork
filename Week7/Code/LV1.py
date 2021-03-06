"""Language: Python3
   Author: Cong Liu (cong.liu20@imperial.ac.uk)
   Script: LV1.py
   Work Path: CMEECourseWork/Week7/Code
   Dependencies: numpy, scipy.integrate, matplotlib.pylab, sys
   Input: 
   Function: Simulate Lotka-Volterra model for a predator-prey system 
             and visualize results in two ways. 
   Output: ../Results/LV1_1.pdf
           ../Results/LV1_2.pdf
   Usage: python LV1.py
   Date: Nov, 2020"""

import numpy as np
import scipy.integrate as integrate
import matplotlib.pylab as p
import sys

def dCR_dt(pops, t=0):
    """Cauculate dR/dt and dC/dt, where t is time, 
       R and C are densities of resource and consumer."""
    R = pops[0]
    C = pops[1]
    dRdt = r * R - a * R * C 
    dCdt = -z * C + e * a * R * C
    
    return np.array([dRdt, dCdt])

r = 1.
a = 0.1 
z = 1.5
e = 0.75

t = np.linspace(0, 15, 1000)

R0 = 10
C0 = 5 
RC0 = np.array([R0, C0])

#Integration
pops, infodict = integrate.odeint(dCR_dt, RC0, t, full_output=True)

#Plotting
f1 = p.figure()
p.plot(t, pops[:,0], 'g-', label='Resource density') # Plot
p.plot(t, pops[:,1]  , 'b-', label='Consumer density')
p.grid()
p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population density')
p.title('Consumer-Resource population dynamics')
#p.show()# To display the figure
f1.savefig('../Results/LV1_1.pdf') #Save figure

f2 = p.figure()
p.plot(pops[:,0], pops[:,1], "r-")
p.grid()
p.xlabel("Resource density")
p.ylabel("Consumer density")
p.title("Consumer-Resource population dynamics")
f2.savefig("../Results/LV1_2.pdf")


