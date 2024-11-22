import matplotlib.pyplot as plt
import numpy as np

tt, vi, vo = np.loadtxt('../Data/data00.txt', unpack=True)



plt.plot(tt, vi, 'r-', label='Vin')
plt.plot(tt, vo, 'b-', label='Vout')

plt.show()