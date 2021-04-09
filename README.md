## Table of Content
1. [Overview](#overview)
2. [Optimal flow calculation with ```inst_opt_bound```](#OptimalFlowCalculation)
  - [Compile the code](#CompileTheCode)
  - [Running the code](#RunningTheCode)
    - [List of input parameters](#inputs)
    - [List of output files](#outputs)
3. [Flow visualisation with ```plot_flow.ipynb```](#FlowVisualisation)
4. [Details of the algorithm](#algorithm)
5. [References](#refs)


# Overview <a name="overview"></a>

This $\alpha$ repository contains the Fortran code ```inst_opt_bound```, to calculate horizontal flows at the Core-Mantle Boundary (CMB) that optimise the rate-of-change of a geomagnetic quantity (such as the dipole tilt and the inclination at a specific location at the Earth's surface). Based on the algorithm developed by Livermore et al. (2014) and Maffei et al. (unpublished as of April 2021).

Also included in the repository is a jupyter Notebook (```plot_flow.ipynb```) to create a sample global map plotting the resulting optimal flow on top of the background magnetic field.

# Optimal flow calculation with inst_opt_bound <a name="OptimalFlowCalculation"></a>

## Compile the code <a name="CompileTheCode"></a>

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


# Details of the algorithm <a name="algorithm"></a>

The Fortran code implements the optimisation algorithm first presented in Livermore et al. (2014) and expanded in Maffei et al. (in prep) and details can be found therein.

The radial induction equation evaluated at the CMB \citep{roberts1965analysis}, in its diffusionless form, can be written as:

$\dot{B}_r= -\nabla_H\cdot(\textbf{u}_H B_r), $

where, $B_r$ is the radial component of \textbf{B} and $\nabla_H = \nabla - \hat{\textbf{r}}\partial_r$ is the horizontal part of the spatial gradient operator. The time derivative $\dot{B}_r$ is often referred to as the secular variation (SV). At a location $(r,\theta,\phi)$ outside the core, the geomagnetic field is commonly described as an expansion in its Gauss coefficients $(g_l^m,h_l^m)$:
\begin{equation}
\textbf{B} = a \nabla\sum_{l=1}^{L_B}\sum_{m=0}^l\left(\frac{a}{r}\right)^{l+1} \left[ g_l^m\cos(m\phi) + h_l^m \sin(m\phi) \right]P_l^m(\cos(\theta)),    
\label{eqn:SHexp1}
\end{equation}
where $a = 6371$ km is the radius of the Earth, $P_l^m(\cos(\theta))$ are Schmidt semi-normalised associated Legendre polynomials of degree $l$ and order $m$ and $L_B$ is the highest degree of the expansion. 
%The Gauss coefficients are typically measured in nT \citep{thebault2015international,finlay2016recent} or in $\mu$T \citep{leonhardt2007paleomagnetic}. 
In a more compact notation, useful to simplify the following discussion, expansion \eqref{eqn:SHexp1} can be written as:
\begin{equation}
\textbf{B} = a \nabla\sum_{l,m}\left(\frac{a}{r}\right)^{l+1}  \beta_l^m Y_l^m(\theta,\phi),     
\end{equation}
where $\beta_l^m = (g_l^m,h_l^m)$ are the Gauss coefficients and $Y_l^m(\theta,\phi) = (_cY_l^m(\theta,\phi), _sY_l^m(\theta,\phi))$, with $_cY_l^m(\theta,\phi) = \cos(m\phi) P_l^m(\cos(\theta))  $ and $_sY_l^m(\theta,\phi) = \sin(m\phi) P_l^m(\cos(\theta))  $ are real-valued Schmidt semi-normalised spherical harmonics. Similarly, we express the CMB flow $\textbf{u}_H$ as an expansion over a set of modes $\textbf{u}_k$:
\begin{equation}
\textbf{u}_H = \sum_k q_k \textbf{u}_k,
\label{eqn:uH_short}    
\end{equation}
where $k$ is a shorthand notation for the indexes $(l,m)$, with $0<l\le L_U$, $0\le m \le l$, $q_k$ are the coefficients, measured in km/yr of the expansion and $\textbf{u}_k$ is the $k$-th element of a divergence-free basis set consisting of both toroidal and poloidal modes, respectively:
\begin{gather}
\textbf{u}_k^t = \nabla\times Y_l^m(\theta,\phi)\textbf{r},\\
\textbf{u}_k^s = \nabla_H[Y_l^m(\theta,\phi)r].
\end{gather}
Expansion \eqref{eqn:uH_short} can then be more explicitly written as
\begin{equation}
\begin{split}
\textbf{u}_H = &\sum_{l,m} \Big\{ {_ct_l^m} \nabla\times {_cY_l^m}(\theta,\phi)\textbf{r} + {_st_l^m} \nabla\times {_sY_l^m}(\theta,\phi)\textbf{r} \Big\} \\
  + & \sum_{l,m} \Big\{ {_cs_l^m} \nabla_H[ {_cY_l^m}(\theta,\phi)r] + {_ss_l^m} \nabla_H[ {_sY_l^m}(\theta,\phi)r]\Big\},
\end{split}
\end{equation}
where $_ct_l^m$ and $_st_l^m$ are the real-valued toroidal flow coefficients and $_cs_l^m$ and $_ss_l^m$ are the real-valued poloidal flow coefficients.

Given a geomagnetic quantity $\mathcal{A}$, which is a function of the Gauss components $\beta_l^m$, we seek the minimum rms speed $T_0$ of the CMB flows required to reproduce a given rate-of-change value of $\mathcal{A}$. We therefore calculate the flows $\textbf{u}_{\text{opt}}$ at the CMB that optimise $\dot{\mathcal{A}}$. Following the same notation as in \cite{livermore2014core}, the rate-of-change of $\mathcal{A}$ can be generally expressed (by manipulating \eqref{eqn:induction_r}) as:
\begin{equation}
\dot{\mathcal{A}}=  \textbf{G}^T\textbf{q},  
\label{eqn:dFdt}
\end{equation}
with the vector $\textbf{G}$ being a function of the CMB background geomagnetic field $B_r$, through the coefficients $\beta_l^m$ and of the basis set $\textbf{u}_k$. The exact shape of $\textbf{G}$ depends on the functional dependence of $\dot{\mathcal{A}}$ on $\beta_l^m$ and $\dot{\beta}_l^m$. %In particular, note that for geomagnetic quantities defined at the Earth's surface the components of $\textbf{B}$ involved in the definition of said quantities are evaluated at $r=a$, for which, compared to the geomagnetic field components evaluated at $r=c$, smaller spatial scales are attenuated. 
Regardless of whether $\mathcal{A}$ is defined at the Earth's surface or not, each component $G_k$ represents the contribution to $\dot{\mathcal{A}}$ from the flow mode $\textbf{u}_k$, given the CMB background field $B_r$. 

Note that the optimisation problem as posed above is ill-posed since, in general, variations of $\mathcal{A}$, optimal or not, can be expected to grow indefinitely as the kinetic energy of the CMB flow increases. The rms flow speed $T_0$ as:
\begin{equation}
  T_0\equiv\sqrt{\frac{1}{4\pi} \int_{r=c} |\textbf{u}_H|^2 d\Omega} = \sqrt{\textbf{q}^T\textbf{E} \ \textbf{q}}\,
\end{equation}
where $d\Omega = \sin\theta  ~ d\theta ~ d\phi$ is the surface element in spherical coordinates and the integral is evaluated on the surface of the CMB and $\textbf{E}$ is a diagonal matrix with elements $E_k=l(l+1)(2l+1)^{-1}$. 
%In order to constrain the rms flow intensity we introduce the following constraint:
%\begin{equation}
%\sqrt{\textbf{q}^T\textbf{E} \ \textbf{q}} = T_0.  
%\label{eqn:constraint1}
%\end{equation}
%The larger the value of $T_0$, the larger the optimal value of  $\dot{\mathcal{A}}$. 
The procedure to calculate the coefficients $\textbf{q}$ that optimise $\dot{\mathcal{A}}$ is formally equivalent to the one reported in \cite{livermore2014core}, and rests on finding solution to the following maximisation problem:
\begin{equation}
\left. \dot{\mathcal{A}} \right|_\text{max} = \text{max}_\textbf{q} \left[ \textbf{G}^T\textbf{q} - \lambda(\textbf{q}^T\textbf{E} \ \textbf{q} - T_0^2  ) \right],
\label{eqn:Lagrange_eq}
\end{equation}
which allows us to maximise \eqref{eqn:dFdt} subject to the constraint (expressed via the Lagrange multiplier $\lambda$) that the root-mean-squared (rms) velocity of the optimal flow be equal to $T_0$. The solution to \eqref{eqn:Lagrange_eq} gives us the coefficients $\textbf{q}_\text{opt}$ to the optimal flow $\textbf{u}_\text{opt}$:
\begin{equation}
    \textbf{q}_\text{opt} = \frac{1}{2\lambda} \textbf{E}^{-1} \textbf{G}, 
    \label{eqn:qopt}
\end{equation}
where
\begin{equation}
\lambda = \pm \frac{1}{2 T_0}\sqrt{\textbf{G}^T \textbf{E}^{-1} \ \textbf{G}},
\label{eqn:lambda}
\end{equation}
is found by scaling the coefficients $\textbf{q}_\text{opt}$ so that 
\begin{equation}
\textbf{q}_\text{opt}^T\textbf{E} \ \textbf{q}_\text{opt}=T_0^2.
\label{eqn:rms_constraint}
\end{equation}
Notice that this implies that $\textbf{q}_\text{opt}$ and, by \eqref{eqn:dFdt}, $\dot{\mathcal{A}}$ are both directly proportional to $T_0$. However, the form of the optimal flows, and of the SV they drive, is not affected by $T_0$.

# References <a name="refs"></a>
Livermore, Philip W., Alexandre Fournier, and Yves Gallet. "Core-flow constraints on extreme archeomagnetic intensity changes." _Earth and Planetary Science Letters_ 387 (2014): 145-156.

Maffei, Stefano, Philip W. Livermore, Jon E. Mound, Sam Greenwood, and Chris J. Davies. "Fast directional changes during geomagnetic reversals: global reversals or local fluctations?". in prep.
