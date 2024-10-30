# calc\_s Program

## Description

Wrote a program to read in multiple input files including files 
produced by CASTEP, extract important data and use it to calculate the 
local softness, s(r). Local softness is written to several files in 
different formats, including one suitable for visualisation with the 
3D molecular viewer jmol. Another output file is suitable for further 
processing via the topology program which calculates the related 
condensed reactivity index, the atomic softness.

## Table of contents

- Installation
- Usage
  - Input files
  - Output files
- Credits

## Installation

Compile with Fortran 90 to generate binary file xcorr.gfortran. Make sure 
this is executable.

For compiling with gfortran first use
`gfortran -c *0`
then link files with
`gfortran -o calc_s *o`

## Usage

How to run the code. This program can be run in linux using the command line \:

```
./calc_s
```

Some debug information for checks is written to standard output.

### Input files
```
calc_loc_soft.in
```
Input file where key variables are specified\: 
- surface
- naming convention of charge
- surface charge 
- number of data points
- seednames of data points
- volume of supercell

```
<surface>_A.csv
```
Converged corrected denominator (also known as parameter A) in 
units of eV A^2 e^-1

```
<seedname>_<charge>.den_fmt
```
Local density CASTEP output file at a given charge in units of 
electrons per supercell. The calc\_s code requires .den\_fmt files
with a positive and negative test charge (of magnitude specified in
the calc\_loc\_soft.in file) 

```
<seedname>.den_fmt
```
Local density CASTEP output file at zero charge in units of electrons
per supercell.

### Output files

#### General output files
```
<seedname>_numerator.dat
```
Text file of numerator of local softness 

```
<seedname>_s_r.dat
```
Text file of the local softness

#### Output files for visualisation with jmol

```
<seedname>_s_r.den_fmt 
```
File of 'out of the box' local softness in units of eV^-1 per supercell
written in the correct format for jmol visualisation

```
<seedname>_halfcell.den_fmt
```
File of density in units of electrons per supercell with the density of
the lower half of the supercell artificially set to zero for jmol
visualisation purposes

```
<seedname>_minus_s_r.den_fmt
```
File of `-s(r)` for jmol colourmaps in units of units of inverse eV 
per cubic Angstrom.

```
<seedname>_jmol_s_r.den_fmt
```
File of `-s(r)` for jmol colourmaps in units of units of inverse eV
per cubic Angstrom. 

This output file has some artificial values in the lower, hidden region
of the supercell. These values are used to set the range for colourmaps
of the local softness in jmol, as there is not a way to specify the 
colourmap range in jmol directly.


#### Output file for further processing using topology program
```
<seedname>.data
```
File in topology.data format for use with Bader theory topology program
columns are i j k density `s(r)` where density has units of electrons
per cubic Angstrom and `s(r)` has units of `eV^-1 A^-3`

### Limitations
Only works for `n_spins = 1`

### Credits
Written by Amy Gunton


