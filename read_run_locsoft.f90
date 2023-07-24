program read_run_locsoft
implicit none
!
! This program was written by Amy Gunton 
!
! Program to read in data and run a subroutine  which calculates the local softness
! for each grid point in the cell
!
! characters
character:: dummy_char                     ! dummy character to skip lines
character(len=200)::seedname               ! seedname of calculation
character(len=10) :: ch_char               ! character of charge naming convention
character(len=10) :: surface               ! surface in Elhkl format 
character(len=200)::denom_file             ! name of file containing converged corrected denominator

! integers
integer :: number_files, ifile             ! number of files and index of file names

! double precision
double precision:: surfch                  ! surface charge e A^-2
double precision:: denom                   ! denominator of local softness eV A^2 e^-1
double precision:: volume                  ! volume of supercell/ A^3
double precision:: s_min                   ! minimum value of -s(r)
double precision:: s_max                   ! maximum value of -s(r)

! initialise volume
volume = 0.0

! read in values from input file
open(8, file="calc_loc_soft.in")

! skip first 3 lines
read(8,15) dummy_char
15 format(2(1x/),a1)

! read in string of charge for naming convention
read(8,*) ch_char
write(*,*) "charge is ", ch_char

! skip two lines
read(8,16) dummy_char
16 format(1(1x/),a1)

! read in surface charge in double precision
read(8,*) surfch
write(*,*) "surface charge is ", surfch

! ! skip two lines
read(8,16) dummy_char

! read in surface string
read(8,*) surface

! open file of denominator information
denom_file=trim(surface)//"_A.csv"
open(9, file=denom_file)

! skip first line
read(9,*) dummy_char

! read in denominator of local softness eV A^2 e^-1
read(9,*) dummy_char, denom

! close denominator file
close(9)

! skip two lines
read(8,16) dummy_char

! read in number of data points
read(8,*) number_files

! check there is only one file. I think it only works in this case.
if (number_files/=1) then

    ! write warning
    write(*,*) "WARNING multiple files are not supported!"

end if

! skip two lines
read(8,16) dummy_char

read(8,*) seedname

! skip two lines
read(8,16) dummy_char

! read in supercell volume in cubic Angstroms
read(8,*) volume

! skip two lines
read(8,16) dummy_char

! read in minimum value of -s(r)
read(8,*) s_min
write(*,*) "minimum is", s_min

! skip two lines
read(8,16) dummy_char

! read in maximum value of -s(r)
read(8,*) s_max

write(*,*) trim(seedname)
call calc_loc_soft_delegate(seedname, ch_char, surfch, denom, volume, s_min, s_max)

write(*,*) "volume = ", volume
    
close(8)

stop 
end program read_run_locsoft
