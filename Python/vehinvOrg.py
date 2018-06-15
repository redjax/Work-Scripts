"""Script for organizing the "vehinv" folder on the metrolx server."""

import datetime
import time
import os
import shutil
# import zipfile
from distutils.dir_util import copy_tree

# vehinvPath = "\\\metrolx01/mlx_carsales/vehinv"
# vehinvArch = "\\metrolx01/mlx_carsales/archive/vehinv"

vehinvTest = "\\\metrolx01/backup/jxk5224/vehinv"
vehinvArchTest = "\\\metrolx01/backup/jxk5224/archive/vehinv"


def kinesis(path):
    """Move files to the deletePath for the attila function."""
    # cutoff = datetime.timedelta(days=30)
    cutoff = datetime.timedelta(seconds=30)

    for dirpath, dirnames, filenames in os.walk(path):

        for file in filenames:

            curpath = os.path.join(dirpath, file)
            file_modified = datetime.datetime.fromtimestamp(os.path.getmtime(
                curpath))

            if datetime.datetime.now() - file_modified > cutoff:
                copy_tree(path, vehinvArchTest)

        for dir in dirnames:

            curpath = os.path.join(dirpath, dir)
            file_modified = datetime.datetime.fromtimestamp(os.path.getmtime(
                curpath))

            if datetime.datetime.now() - file_modified > cutoff:
                full_path = os.path.join(path, dir)
                shutil.move(full_path, vehinvArchTest)

    attila(vehinvTest)


def attila(delpath):
    """Attila deletes ever file/directory of a certain age (cutoff)."""
    # Change this variable to delete files older than set:
    # days, minutes, seconds, hours, etc)
    # cutoff = datetime.timedelta(days=30)
    cutoff = datetime.timedelta(seconds=30)

    for dirpath, dirnames, filenames in os.walk(delpath):

        for file in filenames:
            curpath = os.path.join(dirpath, file)
            file_modified = datetime.datetime.fromtimestamp(
                os.path.getmtime(curpath))

            if datetime.datetime.now() - file_modified > cutoff:
                os.remove(curpath)

        for dir in dirnames:

            curpath = os.path.join(dirpath, dir)
            file_modified = datetime.datetime.fromtimestamp(os.path.getmtime(
                curpath))

            if datetime.datetime.now() - file_modified > cutoff:
                shutil.rmtree(curpath)
