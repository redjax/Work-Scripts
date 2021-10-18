import os
import glob

path = glob.glob('C:\\Users\\<USER>\\Desktop\\tmpdesktop\\')

for f in path:
	if f != 'Keep':
    		os.remove(f)
