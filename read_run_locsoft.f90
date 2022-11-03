program read_run_locsoft
implicit none
!
! This program was written by Amy Miller on 30 Mar 2016
!
! Program to read in data and run a subroutine  which calculates the local softness
! for each grid point in the cell
!
! characters
character:: dummy_char                     ! dummy character to skip lines
character(len=200)::seedname               ! seedname of calculation
character(len=10) :: ch_char               ! character of charge naming convention

! integers
integer :: number_files, ifile             ! number of files and index of file names

! double precision
double precision:: surfch                  ! surface charge e A^-2
double precision:: denom             ! denominator of local softness eV A^2 e^-1

! read in values from input file
open(9, file="calc_loc_soft.in")

! skip first 3 lines
read(9,15) dummy_char
15 format(2(1x/),a1)

! read in string of charge for naming convention
read(9,*) ch_char
write(*,*) ch_char

! skip two lines
read(9,16) dummy_char
16 format(1(1x/),a1)

! read in surface charge in double precision
read(9,*) surfch
write(*,*) surfch

! ! skip two lines
read(9,16) dummy_char

! read in denominator of local softness eV A^2 e^-1
read(9,*) denom

! skip two lines
read(9,16) dummy_char

! read in number of data points
read(9,*) number_files

! skip two lines
read(9,16) dummy_char

! read in name of files
do ifile = 1, number_files
    read(9,*) seedname
    write(*,*) 'file number', ifile, trim(seedname)
    call calc_loc_soft_delegate(seedname, ch_char, surfch, denom)
end do

close(9)
stop 
end program read_run_locsoft
