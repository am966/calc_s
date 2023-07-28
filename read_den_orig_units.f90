subroutine read_den_orig_units(input_file, i_size, j_size, k_size, density_orig_units)
implicit none
!
! This subroutine was written by Amy Gunton
!
! subroutine to read in the den_fmt grid

character(len=210), intent(in) :: input_file                                      ! name of input file
integer, intent(in) :: i_size, j_size, k_size                                     ! number of grid points along x, y, z
double precision, intent(inout) :: density_orig_units(i_size, j_size, k_size)     ! density

character :: dummy_char
integer :: i, j, k                                                     ! grid position indices
integer :: line, number_of_lines                                       ! line number and total lines of matrix information
                                                                  
! open file and skip first 11 lines
open(11,file=input_file)
!
read(11,21) dummy_char
21 format(11(1x/),a1)

! calculate number of lines = number of i values * no. j val * no. k val
number_of_lines=i_size*j_size*k_size

! read number of sample points along x, y and z
do line = 1, number_of_lines
    read(11,*) i, j, k, density_orig_units(i,j,k)
end do

! leave density in units of electrons per supercell

! close file
close(11)

return
end subroutine read_den_orig_units
