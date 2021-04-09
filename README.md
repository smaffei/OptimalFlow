## Table of Content
1. [Overview](#overview)
2. [Optimal flow calculation with ```inst_opt_bound```](#OptimalFlowCalculation)
  - [Compiling the code](#CompileTheCode)
  - [Running the code](#RunningTheCode)
    - [List of input parameters](#inputs)
    - [List of output files](#outputs)
3. [Flow visualisation with ```plot_flow.ipynb```](#FlowVisualisation)
4. [Details of the algorithm and structure of the code](#algorithm)
5. [References](#refs)


# Overview <a name="overview"></a>

This $\alpha$ repository contains the Fortran code ```inst_opt_bound```, to calculate horizontal flows at the Core-Mantle Boundary (CMB) that optimise the rate-of-change of a geomagnetic quantity (such as the dipole tilt and the inclination at a specific location at the Earth's surface). Based on the algorithm developed by Livermore et al. (2014) and Maffei et al. (unpublished as of April 2021).

Also included in the repository is a jupyter Notebook (```plot_flow.ipynb```) to create a sample global map plotting the resulting optimal flow on top of the background magnetic field.

# Optimal flow calculation with inst_opt_bound <a name="OptimalFlowCalculation"></a>

## Compiling the code <a name="CompileTheCode"></a>

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

## Running the code <a name="RunningTheCode"></a>

```./inst_opt_bound < input_optimisation_inclination```  

The input file ```input_optimisation_inclination``` is provided in the repository and sets up the code to calculate the flows that optimise the rate-of-change of inclination at a location corresponding to the Sulmona basin, in Central Italy, with the background magnetic field provided by the 2019 realisation of the CHAOS 6 model (provided in the repository)

### List of input parameters <a name="inputs"></a>
```
   OBS_COLAT, OBS_LONG:  colatitude and longitude of the observation/optimisation 
                         location. They need to be given even when optimising global 
                         quantities (such as dipole tilt rate-of-change)
   PHI_OBS:              OBS_LONG * Pi / 180.0_8
   LMAX_U:               max spherical harmonics degree for the optimal flow
   LMAX_B_OBS:           max spherical harmonics degree for the background
                         magnetic field. If more degrees are available in FILENAME,
                         they are disregarded
   FILENAME:             full path to the file containing the Gauss coefficients
                         describing the background magnetic field
                         format: l m g_lm h_lm
   TARGET_RMS:           rms flow speed (in km/yr)
   SCALE_FACTOR:         scale factor for arrows, used to prepare a flow file (FLOW.DAT)
                         readable by GMT
                         With SCALE_FACTOR = 5e-2: 20km/yr gives 1cm (factor of 1/20 = 5e-2)
   RESTRICTION:          flow geometry restriction:
                         0: unrestricted
                         1: poloidal
                         2: toroidal
                         3: columnar (equatorially symmetric)
   ETA:                  magnetic diffusivity (in m^2/s)
   MINIM_FLAG:           based on this value, the rate-of-change of specific 
                         pre-coded quantity is optimised:
                         0: dipole tilt
                         1: magnetic field intensity at OBS location
                         2: magnetic field intensity at the intensity minimum (e.g. SAA)
                         3: declination at OBS location
                         4: axial dipole coefficient g_1^0
                         5: inclination at OBS location
                         6: g_1^1
                         7: VGP latitude
 ```

### List of output files <a name="outputs"></a>
```
   D_CS_CENTRED.DAT:     declination at grid locations at the CMB
   D_DOT_CS_CENTRED.DAT: declination variations (driven by the optimal solution) 
                         at grid locations at the CMB
   D_DOT_ES.DAT:         declination variations (driven by the optimal solution) 
                         at grid locations at the Earth's surface
   D_DOT_ES_CENTRED.DAT: same as D_DOT_ES.DAT, but the longitude is displayed
                         from -180 rather than 0
   D_ES.DAT:             declination at grid locations at the Earth's surface
   D_ES_CENTRED.DAT:     same as D_ES.DAT, but the longitude is displayed
                         from -180 rather than 0
   FLOW.DAT:             optimal flow (in km/yr) in a format that GMT can read. 
                         format: lon lat flow direction flow intensity
   FLOW_L_SPEC.DAT:      Kinetic Energy spectrum per spherical harmonic degree l
                         (in km/yr^2)
   FLOW_VECTORS_CENTRED.DAT: optimal flow (in km/yr) on a regular grid
                             format: lon lat u_theta u_phi
   FLOW_VECTORS_RANDOM.DAT:  optimal flow (in km/yr) on a random grid (better
                             for plotting with a quiver plot)
                             format: lon lat u_theta u_phi
   F_CS_CENTRED.DAT:     magnetic field intensity (in nT) at grid locations at the CMB
   F_DOT_CS_CENTRED.DAT: magnetic field intensity variation (driven by the 
                         optimal solution, in nT/yr) at grid locations at the CMB
   F_DOT_ES.DAT:         magnetic field intensity variation (driven by the 
                         optimal solution, in nT/yr) at grid locations at the Earth's surface
   F_DOT_ES_CENTRED.DAT: same as F_DOT_ES.DAT, but the longitude is displayed
                         from -180 rather than 0
   F_ES.DAT:             magnetic field intensity (in nT) at grid locations at the
                         Earth's surface
   F_ES_CENTRED.DAT:     same as F_ES.DAT, but the longitude is displayed
                         from -180 rather than 0
   G_POL.DAT:            elements of the G vector from the poloidal flow components
   G_TOR.DAT:            elements of the G vector from the toroidal flow components
   HARMONICS.DAT:        auxilliary file that the code uses to store spherical harmonic indexes
                         format: l m cos/sin
   OPTIMAL_FLOW.DAT:     optimal flow coefficients
                         format: l m POL(COS) POL(SIN) TOR(COS) TOR(SIN)
   OPTIMISED_QUANTITY_DOT.DAT: optimal rate of change of the quantity selected with MINIM_FLAG
```

# Flow visualisation with plot_flow.ipynb <a name="FlowVisualisation"></a>

After the optimal flows have been calculated successfully (```.DAT``` files are present in the directory), simply run the jupyter Notebook ```plot_flow.ipynb```.

This Notebook has been written in Jupyter Notebook 4.4.1, with Python 2.7.11 installed via Anaconda version 1.9.12 (```conda``` 4.8.3) and runs successfully on macOS High Sierra (10.13.6). Jupyter Notebook might require to downgrade the package ```tornado``` to version 4.5.3.

Other requirements:
- ```numpy``` version 1.15.4
- ```sys```
- ```matplotlib``` version 2.2.5
- ```Basemap``` version 1.3.0

The ```Basemap``` package is not maintained anymore and upgrade to Python 3 might require the use of ```cartopy``` instead.


# Details of the algorithm and structure of the code <a name="algorithm"></a>

The Fortran code implements the optimisation algorithm first presented in Livermore et al. (2014) and expanded in Maffei et al. (in prep) and details can be found therein.

The code finds the spherical harmonics coefficients **q** of the toroidal and poloidal horizontal components of the flow **u<sub>H</sub>** at the Core-Mantle Boundary that optimise the rate of change of a given quantity _A_ (selected via ```MINIM_FLAG```) that can be defined as a function of the Gauss coefficients and their time derivatives. The formula that is implemented is:

<a href="https://www.codecogs.com/eqnedit.php?latex=\textbf{q}_\text{opt}&space;=&space;\frac{1}{2\lambda}&space;\textbf{E}^{-1}&space;\textbf{G}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\textbf{q}_\text{opt}&space;=&space;\frac{1}{2\lambda}&space;\textbf{E}^{-1}&space;\textbf{G}" title="\textbf{q}_\text{opt} = \frac{1}{2\lambda} \textbf{E}^{-1} \textbf{G}" /></a>

where **G** is a vector relating the rate-of-change of _A_ to the flow coefficients **q** via

<a href="https://www.codecogs.com/eqnedit.php?latex=\dot{A}=&space;\textbf{G}^T\textbf{q}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\dot{A}=&space;\textbf{G}^T\textbf{q}" title="\dot{A}= \textbf{G}^T\textbf{q}" /></a>

and the elements of **G** are a function of the Gauss coefficients of the background magnetic field; **E** is a diagonal matrix with elements <a href="https://www.codecogs.com/eqnedit.php?latex=E_k=l(l&plus;1)(2l&plus;1)^{-1}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?E_k=l(l&plus;1)(2l&plus;1)^{-1}" title="E_k=l(l+1)(2l+1)^{-1}" /></a> and <a href="https://www.codecogs.com/eqnedit.php?latex=\lambda" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\lambda" title="\lambda" /></a> is a Lagrange multiplier that ensures that the rms of the optimal flow is ```TARGET_RMS```. 

The flow coefficients are saved in the output file ```OPTIMAL_FLOW.DAT``` and define the horizontal flow via the formula

<a href="https://www.codecogs.com/eqnedit.php?latex=\begin{align*}&space;\textbf{u}_H&space;=&space;&\sum_{l=1}^{LMAX\_U}\sum_{m=0}^l&space;\Big\{&space;{_ct_l^m}&space;\nabla\times&space;{_cY_l^m}(\theta,\phi)\textbf{r}&space;&plus;&space;{_st_l^m}&space;\nabla\times&space;{_sY_l^m}(\theta,\phi)\textbf{r}&space;\Big\}&space;\\&space;&plus;&space;&&space;\sum_{l=1}^{LMAX\_U}\sum_{m=0}^l&space;\Big\{&space;{_cs_l^m}&space;\nabla_H[&space;{_cY_l^m}(\theta,\phi)r]&space;&plus;&space;{_ss_l^m}&space;\nabla_H[&space;{_sY_l^m}(\theta,\phi)r]\Big\},&space;\end{align*}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\begin{align*}&space;\textbf{u}_H&space;=&space;&\sum_{l=1}^{LMAX\_U}\sum_{m=0}^l&space;\Big\{&space;{_ct_l^m}&space;\nabla\times&space;{_cY_l^m}(\theta,\phi)\textbf{r}&space;&plus;&space;{_st_l^m}&space;\nabla\times&space;{_sY_l^m}(\theta,\phi)\textbf{r}&space;\Big\}&space;\\&space;&plus;&space;&&space;\sum_{l=1}^{LMAX\_U}\sum_{m=0}^l&space;\Big\{&space;{_cs_l^m}&space;\nabla_H[&space;{_cY_l^m}(\theta,\phi)r]&space;&plus;&space;{_ss_l^m}&space;\nabla_H[&space;{_sY_l^m}(\theta,\phi)r]\Big\},&space;\end{align*}" title="\begin{align*} \textbf{u}_H = &\sum_{l=1}^{LMAX\_U}\sum_{m=0}^l \Big\{ {_ct_l^m} \nabla\times {_cY_l^m}(\theta,\phi)\textbf{r} + {_st_l^m} \nabla\times {_sY_l^m}(\theta,\phi)\textbf{r} \Big\} \\ + & \sum_{l=1}^{LMAX\_U}\sum_{m=0}^l \Big\{ {_cs_l^m} \nabla_H[ {_cY_l^m}(\theta,\phi)r] + {_ss_l^m} \nabla_H[ {_sY_l^m}(\theta,\phi)r]\Big\}, \end{align*}" /></a>

where <a href="https://www.codecogs.com/eqnedit.php?latex={_ct_l^m},&space;{_st_l^m},&space;{_cs_l^m}&space;\text{&space;and&space;}&space;{_ss_l^m}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?{_ct_l^m},&space;{_st_l^m},&space;{_cs_l^m}&space;\text{&space;and&space;}&space;{_ss_l^m}" title="{_ct_l^m}, {_st_l^m}, {_cs_l^m} \text{ and } {_ss_l^m}" /></a>, for which **q** is a shorthand notation, are the toroidal (_t_) and poloidal (_s_) coefficients for the cosine and sine spherical harmonic component of degree _l_ and order _m_. See Livermore et al. (2014) and Maffei et al. (in prep) for more mathematical detail and explanation on the symbols. Furthermore, the jupyter Notebook ```plot_flow.ipynb``` converts flow and Gauss coefficients to flow and magnetic field in physical space for visualisation purposes.

The optimal rate-of-change of _A_ driven by the optimal flow calculated as above is stored in ```OPTIMISED_QUANTITY_DOT.DAT```.

The code in ```inst_opt_bound.F90``` prompts the user for the input parameter (see above) and passes them to ```optimisation_bound.F90```, where the calculation of the coefficients **q** actually takes place. 

The functions defined in ```subs.F90``` handle the spherical harmonics transforms (via ```fftw3``` and Legendre transforms) for the flow and magnetic field components (and their time derivatives). 

Also in ```subs.F90``` is defined 
- the precision of the calculation, via the ```LONG_REAL``` and the ```EXTRA_LONG_REAL``` variables. To increase the resolution of the final result, change the value of ```EXTRA_LONG_REAL```. ```LONG_REAL=8``` and ```EXTRA_LONG_REAL=8``` should suffice for most calculations, though we find that the VGP latitude (```MINIM_FLAG = 7```) requires ```EXTRA_LONG_REAL=16```
- GMT geographical the grid resolution, ```NTHETA_GRID_CONTOUR_GMT = 100, NPHI_GRID_CONTOUR_GMT = 200```
- the grid spacing for arrows in ```FLOW_VECTORS_CENTRED.DAT```, ```GMT_THETA = 30, GMT_PHI = 30```
- the number of random points in ```FLOW_VECTORS_RANDOM.DAT```, ```NUMBER_RANDOM_START_PTS = 1000```
- the CMB and Earth's surface radii: ```CMB_RADIUS = 3485.0E3_8, ES_RADIUS = 6371.0E3_8```


# References <a name="refs"></a>

Livermore, Philip W., Alexandre Fournier, and Yves Gallet. "Core-flow constraints on extreme archeomagnetic intensity changes." _Earth and Planetary Science Letters_ 387 (2014): 145-156.

Maffei, Stefano, Philip W. Livermore, Jon E. Mound, Sam Greenwood, and Chris J. Davies. "Fast directional changes during geomagnetic reversals: global reversals or local fluctations?". in prep.
