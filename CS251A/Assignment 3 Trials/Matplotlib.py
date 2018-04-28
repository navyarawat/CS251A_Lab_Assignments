import numpy as np
import matplotlib.pyplot as plt

t = np.linspace(0, 2*np.pi, 100000) #100 numbers between 0 and 5
x = np.sin(t)
x_axis = np.linspace(0, 10, 100000)
plt.plot(x_axis,x_axis-x_axis,'b-',t, x, 'r-')
plt.show()