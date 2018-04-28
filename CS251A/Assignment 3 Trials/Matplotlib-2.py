import numpy as np
import matplotlib.pyplot as plt

# evenly sampled time at 200ms intervals
t = np.arange(0., 5., 0.2) #start at 0, go till 5, jump 0.2

# red dashes, blue squares and green triangles
plt.plot(t, t, 'r--', t, 2*t, 'bs')
plt.show()