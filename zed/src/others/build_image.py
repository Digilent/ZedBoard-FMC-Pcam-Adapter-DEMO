#!/usr/bin/env
""" This script builds all the release binaries of the project creating
temporary files in the working directory. Final release binaries are copied to
the path specified by <target_dir>

Call syntax: python build_image.py <target_dir>

REQUIREMENTS:
The project was created on Windows 10 64-bit using Python 3.6.5
It should be compatible with Linux 64-bit and Mac OS
To install python visit: python.org

MODIFICATION HISTORY:

Ver     Who         Date        Changes                     Python Version
-----   ----------- ----------- --------------------------  --------------------
1.0     Bogdan Deac 2018-Nov-7  First release for Nexys A7  Python 3.6.5

"""

import os
import shutil
import sys
import subprocess

script_path = os.path.dirname(os.path.realpath(__file__))

TARGETS = {
    'bist': os.path.join('bist', 'Release', 'bist.elf'),
    'fsbl': os.path.join('fsbl', 'Release', 'fsbl.elf'),
    'bit':  os.path.join('system_wrapper_hw_platform_0', 'system_wrapper.bit'),
    'bif':  os.path.join(script_path, 'output.bif'),
    'bin':  os.path.join(sys.argv[1], 'BOOT.bin')
}

# Hello
print("*** build_image.py ***")
sys.stdout.flush()

print("I am from " + script_path)
sys.stdout.flush()

# Verify if the number of arguments is correct
if len(sys.argv) != 2:
    print("Invalid arguments!")
    print("Usage: build_image.py path_to_release_packet_folder")
    sys.stdout.flush()
    sys.exit(-1)

# Search for SDk in Environment Variables
verify_sdk_path = shutil.which("xsct.bat")
if verify_sdk_path is None:
    print("Did not find SDK xsct.bat command. Do you have it added to the PATH "
          "environment variable? Check below:")
    print(os.environ['PATH'])
    sys.stdout.flush()
    sys.exit(-1)

# SDK was found. We can proceed further

print("*** build all projects ***")
sys.stdout.flush()
# Call the first build tcl script
sdk_build_all_path = os.path.join(script_path, 'sdk_build_all.tcl')
subprocess.call(['xsct.bat', sdk_build_all_path])

# Delete the BSP sources from next to MSS files
print("I am going to delete BSP sources from next to MSS files")
sys.stdout.flush()
topdir = '.'
mss_file = '.mss'
# Scan recursively the directory tree which has the root in the current working
# directory
for dirpath, dirnames, files in os.walk(topdir):
    # Verify if in the current directory (iteration) .mss file is located
    for name in files:
        if name.lower().endswith(mss_file):
            # We found the .mss file. Get the directory in which .mss is located
            for dirs_to_delete in dirnames:
                path_to_delete = os.path.join(dirpath, dirs_to_delete)
                print("Deleting " + path_to_delete)
                sys.stdout.flush()
                # Delete all directories that are in the same directory as .mss,
                # recursively
                shutil.rmtree(path_to_delete)

# Call the second build tcl script
sdk_build_all_2_path = os.path.join(script_path, 'sdk_build_all_2.tcl')
subprocess.call(["xsct.bat", sdk_build_all_2_path])

# Generate bin
subprocess.call(['bootgen',
                 '-image', TARGETS['bif'],
                 '-o', TARGETS['bin'],
                 '-w on'], shell=True)
# shell=True is vulnerable to shell injection! It doesn't work without
# this option

# Search for targets
for name, path in TARGETS.items():
    if not(os.path.isfile(path)):
        print(path + " was not found!")
        sys.stdout.flush()
        sys.exit(-1)
        
# Copy FSBL too for Flash programming
print("Copying FSBL to " + sys.argv[1])
sys.stdout.flush()
shutil.copy(TARGETS['fsbl'], os.path.join(sys.argv[1]))