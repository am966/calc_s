subroutine write_out(seedname, surfch, denom, i_size, j_size, k_size, numerator, loc_soft)
implicit none
!
! written by Amy Gunton
! This subroutine writes the numerator and local softness to output files
!
character(len=200), intent(in) :: seedname                             ! seedname of calculation

integer, intent(in) :: i_size, j_size, k_size                          ! number of grid points along x, y, z

double precision, intent(in) :: surfch                                 ! surface charge
double precision, intent(in) :: denom                                  ! denominator of local softness

double precision, intent(in) :: numerator(i_size, j_size, k_size)      ! numerator
double precision, intent(in) :: loc_soft(i_size, j_size, k_size)       ! local softness

double precision :: density_orig_units(i_size, j_size, k_size)         ! zero charge density (electrons per supercell)

! local variables
character(len=250) :: input_file       ! name of numerator output file
character(len=250) :: num_out          ! name of numerator output file
character(len=250) :: s_r_out          ! name of s(r) output file
character(len=250) :: top_data         ! name of s(r) output file in topology.data format

integer :: i, j, k                     ! index of grid position

! define names of output files
input_file = './'//trim(seedname)//'.den_fmt'
num_out = './'//trim(seedname)//'_numerator.dat'
s_r_out = './'//trim(seedname)//'_s_r.dat'
top_data = './'//trim(seedname)//'.data'

write(*,*) num_out
write(*,*) s_r_out
write(*,*) top_data

! read in density in original units of electrons per supercell from file
call read_den_orig_units(input_file, i_size, j_size, k_size, density_orig_units)

! write output files

! open numerator output file and write header
open(12, file=num_out)
write(12, *) "numerator data in format i j k numerator( e^-1 A^-1) "

! open local softness output file and write headers
open(13, file=s_r_out)
write(13, *) "local softness data file for", trim(seedname)
write(13, *) "surface charge : ", surfch, "e A^-2"
write(13, *) "denominator : ", denom, "eV A^2 e^-1"
write(13, *) "total local softness: ", sum(loc_soft), " ( eV^-1 A^-3) "
write(13, *) "local softness data in format i j k s_r( eV^-1 A^-3) "

! open topology.data format s(r) output file
open(14, file=top_data)

! write in matrices to output files
do k = 1, k_size
    do j = 1, j_size
        do i = 1, i_size

            ! write numerator of local softness to a file
            write(12,*) i, j, k, numerator(i, j, k)

            ! write local softness to a file with headers
            write(13,22) i, j, k, loc_soft(i, j, k)
            22 format(3(i4),f20.8)

            ! write local softness to a file in topology.data format
            write(14,23) i, j, k, density_orig_units(i, j, k), loc_soft(i, j, k)
            23 format(3(i4),2(f20.8))

        end do
    end do
end do

! close files and end subroutine
close(12)
close(13)
close(14)

return
end subroutine write_out
