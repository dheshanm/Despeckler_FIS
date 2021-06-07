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
