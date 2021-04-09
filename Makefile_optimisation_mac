F90 = gfortran -ffree-line-length-0
FFLAGS = -I/usr/local/include
LDFLAGS = -L/usr/local/lib
LOADLIBES = -lfftw3

inst_opt_bound :  inst_opt_bound.F90 subs.F90 optimisation_bound.F90
	$(F90) $(FFLAGS) -c   subs.F90
	$(F90)  -c   optimisation_bound.F90
	$(F90) $(LDFLAGS) $(LOADLIBES) -o inst_opt_bound inst_opt_bound.F90 subs.o optimisation_bound.o
    
