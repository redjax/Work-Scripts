import os
import glob

path = glob.glob('')

for f in path:
	if f != 'Keep':
    		os.remove(f)
