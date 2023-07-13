subroutine read_den_header(seedname, input_file_0, string1, string2, string3)
implicit none
!
! This subroutine was written by Amy Gunton
!
! subroutine to read in the size of the den_fmt grid and numerator

character(len=200), intent(in) ::seedname               ! seedname of calculation
character(len=210), intent(inout) :: input_file_0       ! name of input file for zero charge
character(len=15), intent(inout) :: string1(9)          ! First line of den_fmt lattice param
character(len=15), intent(inout) :: string2(9)          ! Second line of den_fmt lattice param
character(len=15), intent(inout) :: string3(9)          ! Third line of den_fmt lattice param

character :: dummy_char

! open file
open(10,file=input_file_0)

! skip first 3 lines
read(10,24) dummy_char
24 format(2(1x/),a1)

! Read in lines as characters
read(10,*) string1
read(10,*) string2
read(10,*) string3

! skip next line
!read(10,*) dummy_char

! read in n_spins parameter
!read(10,*) nspins

! read number of sample points along x, y and z
!read(10,*) i_size, j_size, k_size

! close file
close(10)

return
end subroutine read_den_header
