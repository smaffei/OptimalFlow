# Overview

This repository contains the code ```inst_opt_bound```, to calculate horizontal flows at the Core-Mantle Boundary (CMB) that optimise the rate-of-change of a geomagnetic quantity (such as the dipole tilt and the inclination at a specific location at the Earth's surface). Based on the algorithm developed by Livermore et al. (2014) and Maffei et al. (unpublished as of April 2021).

Also included in the repository is a jupyte Notebook (.ipynb file) to create a sample global map plotting the resulting optimal flow on top of the background magnetic field.

Livermore, Philip W., Alexandre Fournier, and Yves Gallet. "Core-flow constraints on extreme archeomagnetic intensity changes." _Earth and Planetary Science Letters_ 387 (2014): 145-156.

# inst_opt_bound

## Usage

### Compile the code

Compilation of the optimisation code ```inst_opt_bound.F90``` has the following requirements:
- a Fortran compiler like ```gfortran```
- having the ```fftw3``` library installed on your system


The repository contains two Makefiles ready to use:
- ```Makefile_optimisation_mac``` which uses ```gfortran``` version 8.2.0 and has been successfully tested on macOS High Sierra (10.13.6).  
  
  Usage: ```make -f Makefile_optimisation_mac```  
  
  Note that compilation with this version of gfortran causes warnings to be displaied concerning placement of commas after ```WRITE``` commands and is due to a change in standards in ```gfortran``` that occurred during the development of the code and have not been corrected. The option ```-ffree-line-length-0```
- ```Makefile_optimisation``` which uses the ```ifort``` compiler and has been designed for use on a remote cluster where the ```fftw3``` library could be loaded as a module.  
  
  Usage: ```make -f Makefile_optimisation_mac```  
  
Either option will create the ```inst_opt_bound``` executable in the same folder as the Makefile used (unless otherwise specified by modifying the Makefile)

### Running the code

#### Basic usage
```./inst_opt_bound```  
After pressing ```Enter``` the user will be promped for input:
``` 
 ENTER COLAT/LONG (IN DEGREES) FOR OBSERVATION POINT
 ENTER MAX DEGREE FOR U
 ENTER MAX DEGREE FOR B_OBS
 ENTER FILENAME FOR B_OBS: FORMAT SHOULD BE SINGLE LINE OF HEADER THEN GLM/HLM IN TABULAR FORMAT
 ENTER TARGET RMS VALUE FOR FLOW
 ENTER SCALE FACTOR FOR ARROWS
 RESTRICTION OF FLOW? 0: NONE, 1: POL ONLY, 2: TOR ONLY, 3: COLUMNAR
 ENTER ETA
 ENTER MINIMIZATION FLAG. 0: DIPOLE TILT; 1: INTENSITY AT OBSERVATION POINT; 2: INTENSITY CHANGE AT INTENSITY MINIMUM (SAA); SEE DOCUMENTATION FOR MORE
 ```

