#!/usr/bin/env
""" This project is used to clean the release folder. Only release.py and
cleanup.py files will remain in the current directory after this script is run

Call syntax: python cleanup.py

REQUIREMENTS:
The project was created on Windows 10 64-bit using Python 3.6.5
It should be compatible with Linux 64-bit and Mac OS
To install python visit: python.org

MODIFICATION HISTORY:

Ver     Who         Date        Changes                     Python Version
-----   ----------- ----------- --------------------------  --------------------
1.0     Bogdan Deac 2018-Nov-7  First release for Nexys A7  Python 3.6.5

"""

import sys
import os
import shutil

__author__ = "Bogdan Deac"
__version__ = "1.0"
__maintainer__ = "Bogdan Deac"
__email__ = "bogdan.deac@digilent.ro"
__status__ = "Production"

print("*** cleanup.py ***")
sys.stdout.flush()

running_path = os.path.dirname(os.path.realpath(__file__))
print("I am running in " + running_path)
sys.stdout.flush()

# Delete all directories
for dirpath, dirnames, files in os.walk(running_path):
    for dirs_to_delete in dirnames:
        path_to_delete = os.path.join(dirpath, dirs_to_delete)
        print("Deleting " + path_to_delete)
        sys.stdout.flush()
        shutil.rmtree(path_to_delete, ignore_errors=True)

# Delete all files except release.py and cleanup.py
for file in os.listdir(running_path):
    if (file != "release.py") and (file != "cleanup.py"):
        file_path = os.path.join(running_path, file)
        if os.path.isfile(file_path):
            print("Deleting " + file_path)
            sys.stdout.flush()
            os.remove(file_path)

