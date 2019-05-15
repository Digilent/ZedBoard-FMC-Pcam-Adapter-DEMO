#!/usr/bin/env
""" This project is used to create release binaries for all the Vivado projects
in the repo.

Release binaries are copied to the "packet" directory created next to the script
It calls build scripts specific to each project in the repo.

Call syntax: python release.py

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
import subprocess
import sys
import shutil

__author__ = "Bogdan Deac"
__version__ = "1.0"
__maintainer__ = "Bogdan Deac"
__email__ = "bogdan.deac@digilent.ro"
__status__ = "Production"

# ============================ MAIN FUNCTION ===================================
BUILD_IMAGE_SCRIPT_PATH = os.path.join('src', 'others', 'build_image.py')
CLEANUP_SCRIPT_PATH = os.path.join('.', 'cleanup.py')

# project type description:
#   sdk:    the project consists of a Vivado project + a SDK project; the script
#           will extract the .bit from hardware platform (hw_handoff folder) and
#           will import the SDK project into a temp workspace. The SDK project
#           will be build in Release configuration. After that, the .bit file
#           and .elf file will be merged together in a final .bit file that will
#           be copied to the final release destination
#
#   bit:    the project consists of a Vivado project. The script will copy the
#           .bit file from hw_handoff directory to the final release destination
#
#   bin:    The script will copy the .bit file from hw_handoff directory to the
#           final release destination
SDK_PROJECT_TYPE = 'sdk'
BIT_PROJECT_TYPE = 'bit'
BIN_PROJECT_TYPE = 'bin'

print("*** release.py ***")
sys.stdout.flush()

running_path = os.path.dirname(os.path.realpath(__file__))

print("I am running in " + running_path)
sys.stdout.flush()

# Project source folder relative to script directory
src_path = os.path.join(running_path, '..')

# List of project tuples of type, source path segments list, destination path segments list
projects = [                                    
    (SDK_PROJECT_TYPE, ['zed'], ['packet']),
]

for project in projects:
    # Get the source directory
    project_src_path = os.path.join(src_path, *project[1])
    # Create and change into intermediate build directory
    project_build_path = os.path.join(running_path, *project[1])
    # Output directory
    destination_folder_path = os.path.join(running_path, *project[2])
    
    if not os.path.exists(project_build_path):
        os.makedirs(project_build_path)
        print("Intermediate project directory", project_build_path, "created")
    if not os.path.exists(destination_folder_path):
        os.makedirs(destination_folder_path)
        print("Output project directory", destination_folder_path, "created")
        
    os.chdir(project_build_path)
   
    if project[0] == SDK_PROJECT_TYPE:
        sdk_path = os.path.join(project_src_path, 'sdk')
        if os.path.exists(sdk_path):
            build_image_script_path = os.path.join(
                project_src_path, BUILD_IMAGE_SCRIPT_PATH)
                #
            subprocess.call([
                "python",
                build_image_script_path,
                destination_folder_path
            ])
        else:
            print("*** Invalid sdk project path! ***")
            sys.stdout.flush()

    elif project[0] == BIT_PROJECT_TYPE:
        bit_path = os.path.join(project_src_path, 'hw_handoff')
        if os.path.exists(bit_path):
            # Look for the .bit file
            for bit_file in os.listdir(bit_path):
                if bit_file.endswith('.bit'):
                    print("*** Bit file was found. ***")
                    sys.stdout.flush()
                    src_bit_path = os.path.join(bit_path, bit_file)
                    dst_bit_path = os.path.join(
                        destination_folder_path, bit_file)
                    shutil.copyfile(src_bit_path, dst_bit_path)
                else:
                    print("*** Bit file not found! ***")
                    sys.stdout.flush()
        else:
            print("*** Invalid .bit file path! ***")
            sys.stdout.flush()

    elif project[0] == BIN_PROJECT_TYPE:
        bin_path = os.path.join(project_src_path, 'hw_handoff')
        if os.path.exists(bin_path):
            # Look for the .bin file
            for bin_file in os.listdir(bin_path):
                if bin_file.endswith('.bin'):
                    print("*** Bin file was found. ***")
                    sys.stdout.flush()
                    src_bin_path = os.path.join(bin_path, bin_file)
                    dst_bin_path = os.path.join(
                        destination_folder_path, bin_file)
                    shutil.copyfile(src_bin_path, dst_bin_path)
                else:
                    print("*** Bin file not found! ***")
                    sys.stdout.flush()
        else:
            print("*** Invalid .bin file path! ***")
            sys.stdout.flush()
    
    # Change directory back to release.py path
    os.chdir(running_path)
