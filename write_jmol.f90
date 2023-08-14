subroutine write_jmol(seedname, i_size, j_size, k_size, input_file_0, den_Ang_0, loc_soft_Ang, s_min, s_max)
implicit none
!
! written by Amy Gunton
! This subroutine writes the numerator and local softness to output files
!
character(len=200), intent(in) :: seedname                             ! seedname of calculation
character(len=200), intent(in) :: input_file_0                         ! name of zero charge den_fmt file

integer, intent(in) :: i_size, j_size, k_size                          ! number of grid points along x, y, z

double precision, intent(in) :: den_Ang_0(i_size, j_size, k_size)          ! density of zero charge calculation
double precision, intent(in) :: loc_soft_Ang(i_size, j_size, k_size)       ! local softness in eV^-1 A^-3
double precision, intent(in) :: s_min, s_max                           ! minimum and maximum values of -s(r)

! local variables
character(len=250) ::  den_out                                         ! name of density output file
character(len=250) ::  jmol_s_r_file                                   ! name of density output file
character(len=250) ::  std_soft_file                                   ! name of density output file

character(len=15) :: string1(9)                                        ! First line of den_fmt lattice param
character(len=15) :: string2(9)                                        ! Second line of den_fmt lattice param
character(len=15) :: string3(9)                                        ! Third line of den_fmt lattice param

integer :: i, j, k                                                     ! index of grid position
!integer :: i_half, j_half                                              ! index half way along a and b axes of unit cell
integer :: k_half                                                      ! index half way down c axis of unit cell
integer :: k_two_thirds                                                ! index part way down c axis of unit cell

double precision :: den_jmol_0(i_size, j_size, k_size)                 ! zero charge density modified for jmol visualisation
double precision :: jmol_s_r(i_size, j_size, k_size)                   ! jmol local softness in eV^-1 A^-3

! define names of output files
den_out = './'//trim(seedname)//'_halfcell.den_fmt'
jmol_s_r_file = './'//trim(seedname)//'_jmol_s_r.den_fmt'
std_soft_file = './'//trim(seedname)//'_s_r.den_fmt'

! read in header
call read_den_header(seedname, input_file_0, string1, string2, string3)

! write output files

! write file of standard local softness in density format
! open file and write headers

open(34, file = std_soft_file)
write(34, *) " BEGIN header"
write(34, *) " "
write(34, *) "           Real Lattice(A)               Lattice parameters(A)    Cell Angles "
write(34, *) string1(1:3), "a = ", string1(6), "alpha = ", string1(9)
write(34, *) string2(1:3), "b = ", string2(6), "beta  = ", string2(9)
write(34, *) string3(1:3), "c = ", string3(6), "gamma = ", string3(9)
write(34, *) " "
write(34, *) " 1                            ! nspins " ! assume nspins is 1
write(34, *) i_size, j_size, k_size, " ! fine FFT grid along <a,b,c> "
write(34, *) " END header: data is <a b c>  s(r) in units of inverse eV per cubic"
write(34, *) " Angstrom. "
write(34, *) "  "


! open new density format file and write headers
open(15, file=den_out)
write(15, *) " BEGIN header"
write(15, *) " "
write(15, *) "           Real Lattice(A)               Lattice parameters(A)    Cell Angles "
write(15, *) string1(1:3), "a = ", string1(6), "alpha = ", string1(9) 
write(15, *) string2(1:3), "b = ", string2(6), "beta  = ", string2(9)
write(15, *) string3(1:3), "c = ", string3(6), "gamma = ", string3(9)
write(15, *) " "
write(15, *) " 1                            ! nspins " ! assume nspins is 1
write(15, *) i_size, j_size, k_size, " ! fine FFT grid along <a,b,c> "
write(15, *) " END header: data is <a b c> charge in units of electrons per cubic"
write(15, *) " Angstrom "
write(15, *) " "

! Open new local softness density format file and write headers
open(33, file=jmol_s_r_file)
write(33, *) " BEGIN header"
write(33, *) " "
write(33, *) "           Real Lattice(A)               Lattice parameters(A)    Cell Angles "
write(33, *) string1(1:3), "a = ", string1(6), "alpha = ", string1(9) 
write(33, *) string2(1:3), "b = ", string2(6), "beta  = ", string2(9)
write(33, *) string3(1:3), "c = ", string3(6), "gamma = ", string3(9)
write(33, *) " "
write(33, *) " 1                            ! nspins " ! assume nspins is 1
write(33, *) i_size, j_size, k_size, " ! fine FFT grid along <a,b,c> "
write(33, *) " END header: data is <a b c> -s(r) in units of inverse eV per cubic"
write(33, *) " Angstrom. Bulk softness has some false values for scaling the colourplot"
write(33, *) " "


! Make new density matrix with zero charge in the bottom half of the cell

! Define point halfway along c dimension of unit cell
k_half = k_size / 2             ! NB this is integer division therefore will round down 
k_two_thirds = (2 * k_size) / 3 ! NB this is integer division therefore will round down 

den_jmol_0 = den_Ang_0 
den_jmol_0(:,:,k_half:k_two_thirds) = 0.0       ! set some locations in the cell to zero

! Make new softness matrix for jmol visualisation
! This matrix has values of zero for the bottom half of the unit cell
! Also the matrix is the negative of the local softness
! Also add some false values for setting the scale

jmol_s_r = -1.0 * loc_soft_Ang         ! set as negative of s(r)
jmol_s_r(:,:,k_half:k_two_thirds) = 0.0         ! set some locations in the cell to zero
jmol_s_r(1,:,k_two_thirds:k_size) = s_min       ! set line within cell to range minimum
jmol_s_r(2,:,k_two_thirds:k_size) = s_max       ! set line within cell to range maximum

write(*,*) "jmol_s_r(1,1,k_size)", jmol_s_r(1,1,k_size)
write(*,*) "jmol_s_r(2,2,k_size)", jmol_s_r(2,2,k_size)

! write in matrices to output files
do k = 1, k_size
    do j = 1, j_size
        do i = 1, i_size

            ! write zero charge density to a file with zeros for lower half of cell
            write(15,*) i, j, k, den_jmol_0(i, j, k)

            ! write local softness to a file with headers
            write(33,22) i, j, k, jmol_s_r(i, j, k)
            22 format(3(i4),f20.8)

            ! write local softness to a file with headers
            write(34,22) i, j, k, loc_soft_Ang(i, j, k)

        end do
    end do
end do

! close files and end subroutine
close(15)
close(33)

return
end subroutine write_jmol
