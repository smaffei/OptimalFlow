PROGRAM INST_OPT_BOUND
USE SUBS
USE OPTIMISATION_BOUND

IMPLICIT NONE
!-----------------------------------------------------------------------------
! Program to calculate the flow that optimises the rate-of-change of a chosen
! geomagnetic quantity, given a background magnetic field and given the rms
! flow speed at the CMB. 
!
! INPUTS:
!   OBS_COLAT, OBS_LONG:  colatitude and longitude of the observation/optimisation 
!                         location
!   PHI_OBS:              OBS_LONG * Pi / 180.0_8
!   LMAX_U:               max spherical harmonics degree for the optimal flow
!   LMAX_B_OBS:           max spherical harmonics degree for the background
!                         magnetic field. If more degrees are available in FILENAME,
!                         they are disregarded
!   FILENAME:             full path to the file containing the Gauss coefficients
!                         describing the background magnetic field
!                         format: l m g_lm h_lm
!   TARGET_RMS:           rms flow speed (in km/yr)
!   SCALE_FACTOR:         scale factor for arrows, used to prepare a flow file (FLOW.DAT)
!                         readable by GMT
!                         With SCALE_FACTOR = 5e-2: 20km/yr gives 1cm (factor of 1/20 = 5e-2)
!   RESTRICTION:          flow geometry restriction:
!                         0: unrestricted
!                         1: poloidal
!                         2: toroidal
!                         3: columnar (equatorially symmetric)
!   ETA:                  magnetic diffusivity (in m^2/s)
!   MINIM_FLAG:           based on this value, the rate-of-change of specific 
!                         pre-coded quantity is optimised:
!                         0: dipole tilt
!                         1: magnetic field intensity at OBS location
!                         2: magnetic field intensity at the intensity minimum (e.g. SAA)
!                         3: declination at OBS location
!                         4: axial dipole coefficient g_1^0
!                         5: inclination at OBS location
!                         6: g_1^1
!                         7: VGP latitude
!
! OUTPUT FILES:     
!   see description in optimisation_bound.F90
!
! USAGE:
!   Assuming the name of the executable to be ./inst_opt_bound:
!     ./inst_opt_bound                            -> will need to enter the input manually
!     ./inst_opt_bound < input_optimisation       -> will take the input from an input text file
!-----------------------------------------------------------------------------

    REAL( KIND = EXTRA_LONG_REAL) :: OBS_COLAT, OBS_LONG, PHI_OBS
    INTEGER :: LMAX_B_OBS, LMAX_U, RESTRICTION
    INTEGER :: MINIM_FLAG
    CHARACTER(300) :: FILENAME
    REAL( KIND = 8) :: SCALE_FACTOR, TARGET_RMS, ETA

    REAL( KIND = EXTRA_LONG_REAL), ALLOCATABLE :: SPEC_U_TOR(:), SPEC_U_POL(:)
    REAL( KIND = EXTRA_LONG_REAL), ALLOCATABLE, DIMENSION(:) :: GAUSS


    PRINT*, 'ENTER COLAT/LONG (IN DEGREES) FOR OBSERVATION POINT'
    READ*, OBS_COLAT, OBS_LONG

    PHI_OBS = OBS_LONG * Pi / 180.0_8

    PRINT*, 'ENTER MAX DEGREE FOR U'
    READ*, LMAX_U

    PRINT*, 'ENTER MAX DEGREE FOR B_OBS'
    READ*, LMAX_B_OBS

    PRINT*, 'ENTER FILENAME FOR B_OBS: FORMAT SHOULD BE SINGLE LINE OF HEADER THEN GLM/HLM IN TABULAR FORMAT'
    READ*, FILENAME

    PRINT*, 'ENTER TARGET RMS VALUE FOR FLOW'
    READ*, TARGET_RMS

    PRINT*, 'ENTER SCALE FACTOR FOR ARROWS'
    READ*, SCALE_FACTOR


    PRINT*, 'RESTRICTION OF FLOW? 0: NONE, 1: POL ONLY, 2: TOR ONLY, 3: COLUMNAR'
    READ*, RESTRICTION

    PRINT*, 'ENTER ETA'
    READ*, ETA

    PRINT*, 'ENTER MINIMIZATION FLAG. 0: DIPOLE TILT; 1: INTENSITY AT OBSERVATION POINT; 2: INTENSITY CHANGE AT INTENSITY MINIMUM (SAA); SEE DOCUMENTATION FOR MORE'
    READ*, MINIM_FLAG
    
    
    CALL CALCULATE_OPTIMAL_FLOW(GAUSS, &
                                SPEC_U_TOR, &
                                SPEC_U_POL, &
                                OBS_COLAT, &
                                OBS_LONG, &
                                PHI_OBS, &
                                LMAX_U, &
                                LMAX_B_OBS, &
                                FILENAME, &
                                TARGET_RMS, &
                                SCALE_FACTOR, &
                                RESTRICTION, &
                                ETA, &
                                MINIM_FLAG)
STOP

 
END PROGRAM INST_OPT_BOUND
