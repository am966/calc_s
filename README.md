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

corrected error where the zero charge matrix was read in as a 1D array (resulting in only getting charge
from the vacuum region with massive errors)
