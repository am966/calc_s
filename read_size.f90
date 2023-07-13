subroutine read_size(seedname, ch_char, i_size, j_size, k_size, input_file_m, input_file_p, input_file_0)
implicit none
!
! This subroutine was written by Amy Miller on 30 Mar 2016
!
! subroutine to read in the size of the den_fmt grid and numerator

character(len=200), intent(in) ::seedname               ! seedname of calculation
character(len=10), intent(in) :: ch_char               ! character of charge naming convention
character(len=210), intent(inout) :: input_file_m       ! name of input file for negative charge
character(len=210), intent(inout) :: input_file_p       ! name of input file for positive charge
character(len=210), intent(inout) :: input_file_0       ! name of input file for zero charge

integer, intent(inout) :: i_size, j_size, k_size           ! number of grid points along x, y, z

character :: dummy_char

! define strings of input files
input_file_m = './'//trim(seedname)//'_m'//trim(ch_char)//'.den_fmt'
input_file_p = './'//trim(seedname)//'_p'//trim(ch_char)//'.den_fmt'
input_file_0 = './'//trim(seedname)//'.den_fmt'

! open file
open(10,file=input_file_0)

! skip first 8 lines
read(10,20) dummy_char
20 format(7(1x/),a1)

! read number of sample points along x, y and z
read(10,*) i_size, j_size, k_size

! close file
close(10)

return
end subroutine read_size
