"""Sublime PyBackup Script.

Description: This script will back up the Packages and Installed Packages
folders in Sublime Text.
Instructions: Change the paths in the variables section to be accurate to your
Sublime Text installation.
"""

import os
import shutil
import zipfile


'''
Notes/Ref
--------------

zf = zipfile.ZipFile("myzipfile.zip", "w")
for dirname, subdirs, files in os.walk("mydirectory"):
    zf.write(dirname)
    for filename in files:
        zf.write(os.path.join(dirname, filename))
zf.close()

'''

'''
Imports
os: For "os.path" in variables
zipfile: For creating .zip of backup files
'''


"""
Variables
Note: In this section, change the path variables to your Sublime Text
installation path.
"""

# Path to Sublime Text installation
instpath = os.path.join("C:\\", "Users", "jxk5224", "AppData", "Roaming", "Sublime Text 3")

# Path to the "Packages" folder
pkgpath = os.path.join( instpath, "Packages")

# Path to the "Installed Packages folder"
instpkgpath = os.path.join( instpath, "Installed Packages")

# Path to copy the files/folders to. It's the Downloads folder by default
copypath = os.path.join( "C:", "Users", "jxk5224", "Downloads", "SublBak")

'''
Use this test function to ensure Python is finding the right path
'''


def testpath():
    print('\n' + "I found the following paths to Sublime Text. Make sure I have it right!")
    print('\n' + instpath + '\n' + pkgpath + '\n' + instpkgpath)
    raw_input("\n\nIf this looks right, press any key to move on to the next step...")
    mainmenu()


def copyfolders():
	print('\n' + "Copying files from " + pkgpath + ' to ' + copypath + '...')
	shutil.copy2(pkgpath, copypath)
	print('\n' + "Copying files from " + instpkgpath + ' to ' + copypath + '...')
	shutil.copy2(instpkgpath, copypath)
	raw_input("Copy complete. Press any key to continue")


def mainmenu():
    choice = raw_input('\n' + 'Would you like to print a test of your paths, or start the backup?' + '\n' + 'Please input \'T\' or \'B\': ')
    choice = choice.upper()
    if choice == 'T':
    	testpath()
    elif choice == 'B':
    	copyfolders()
    else:
        print('\n' + 'Invalid Choice.' + '\n\n' + 'Returning to main menu.')
        mainmenu()

mainmenu()
