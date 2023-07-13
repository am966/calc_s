Program written by Amy Gunton

This code calculates the local softness and writes to ouput files

Input files
calc_loc_soft.in		Input file with surface, naming convention of charge,
				surface charge, number of data points, seednames of data points,
                                and volume of supercell

<surface>_A.csv			Input file with converged corrected denominator in eV A^2 e^-1

<seedname>_<charge>.den_fmt	Formatted file of local density at a given charge 
                                in units of electrons per supercell.
<seedname>.den_fmt		Formatted file of local density at zero charge 

Output files
<seedname>_numerator.dat	File of numerator of local softness with headers
<seedname>_s_r.dat		File of local softness data with headers
<seedname>.data			File in topology.data format for use with Bader theory topology program
                                columns are i j k density s(r) 
                                where density has units of electrons per cubic Angstrom
                                and s(r) has units of eV^-1 A^-3
<seedname>_halfcell.den_fmt     File of density in correct units with lower half of the cell artificially
                                set to zero for jmol visualisation.
<seedname>_s_r.den_fmt          File of 'out of the box' softness in the correct units and in den_fmt 
                                for jmol visualisation
<seedname>_jmol_s_r.den_fmt     File of -s(r) for jmol colourmaps. This has units of eV^-1 
                                A^-3 and the lower half of the cell is artificially set to zero. 
                                Certain regions within the slab are artificially set to 8888888.00000000
                                or 9999999.00000000 in order to be able to manually change the range for 
                                the colourmaps

corrected error where the zero charge matrix was read in as a 1D array (resulting in only getting charge
from the vacuum region with massive errors)

Limitations
only works for n_spins = 1
