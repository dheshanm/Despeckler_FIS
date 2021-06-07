# Despeckler_FIS
A Neuro-Fuzzy Inference System designed to despeckle SAR images

## Requirements
### Hardware Requirements
The following are the application specific Hardware requirements
1. CPU
    1. Higher core count (6 recommended): The program has been written with CPU parallelization in mind, and a higher core or thread count would significantly reduce the runtime of the program.
    2. Higher Frequency: Helps with reducing execution times
2. Memory/RAM
    1. Higher Capacity (16GB Recommended): Since source SAR images are large, owing to their huge resolutions, and the need to have the entire image loaded onto the system’s memory during runtime, a moderate amount of RAM is required to sustain the program

### Software Requirements
- MATLAB (Written in 2020a)
    - Fuzzy Logic Toolbox (Default Add-on)
    - MEX (setup and configured)
- LibTiff Library (Installed)
- C / C++ compiler (like MinGW) [optional]
    - To optimize for the memory and CPU usage, part of the MATLAB executable code have been converted to native C/C++ code using MATLAB’s MEX system, and therefore, to take advantage of the improved speed and optimizations, a compatible C/C++ compiler is necessary.
    - Results in much faster execution times
    
## How to Use
1. Ensure than MEX has been configured to use a compatible C / C++ compiler
2. Run the ['run_driver.bat'](https://github.com/L4TTiCe/Despeckler_FIS/blob/master/build/run_driver.bat) or ['run_driver.sh'](https://github.com/L4TTiCe/Despeckler_FIS/blob/master/build/run_driver.sh) depending on your Operating System.
    1. Choose an Input SAR image (Preferred format: GeoTiff)
    2. Choose a FIS
        1. Those designed as part of this project can be found under ['build/FIS'](https://github.com/L4TTiCe/Despeckler_FIS/tree/master/build/FIS)
            - For best results use ['sugeno_5.fis'](https://github.com/L4TTiCe/Despeckler_FIS/blob/master/build/FIS/sugeno_5.fis)
    3. Choose the Output Directory, where the output image is to be placed.
    4. Wait patiently for the process to complete.
       - A 1000x1000 image takes roughly 60 seconds on a 6-core machine
3. The input image will be processed and be placed in the chosed Output Directory, with 'out_' prefix.
    - The output will be in GeoTiff format, and therefore uses LibTiff Library
    - A good tool to visualize the output will be [QGIS](https://www.qgis.org/)

   
