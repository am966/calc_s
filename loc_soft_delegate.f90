subroutine calc_loc_soft_delegate(seedname, ch_char, surfch, denom, volume, s_min, s_max)
implicit none
!
! This program was written by Amy Gunton
!
! Program to read in the numerator of local softness and 
! using a supplied value of the denominator 
! calculated the local softness for each grid point in the cell
!
! characters
character:: dummy_char                                 ! dummy character to skip lines
character(len=200), intent(in) :: seedname             ! seedname of calculation
character(len=10), intent(in) :: ch_char               ! character of charge naming convention
character(len=210) :: input_file_m                     ! name of input file for negative charge
character(len=210) :: input_file_p                     ! name of input file for positive charge
character(len=210) :: input_file_0                     ! name of input file for zero charge

! integers
integer:: i_size, j_size, k_size                       ! number of grid points along x, y, z

! double precision
double precision, intent(in):: surfch                  ! surface charge e A^-2
double precision, intent(in):: denom                   ! denominator of local softness eV A^2 e^-1
double precision, intent(in):: volume                  ! volume of supercell A^3
double precision, intent(in):: s_min                   ! minimum value of -s(r) for range
double precision, intent(in):: s_max                   ! maximum value of -s(r) for range

double precision, dimension(:,:,:), allocatable:: numerator  ! numerator of local softness per supercell
double precision, dimension(:,:,:), allocatable:: loc_soft   ! local softness eV^-1 per supercell
double precision, dimension(:,:,:), allocatable:: loc_soft_Ang   ! local softness eV^-1 A^-3 

double precision, dimension(:,:,:), allocatable:: den_m      ! density for negative charge per supercell
double precision, dimension(:,:,:), allocatable:: den_p      ! density for positive charge per supercell
double precision, dimension(:,:,:), allocatable:: den_0      ! density for zero charge per supercell

double precision, dimension(:,:,:), allocatable:: den_Ang_0  ! density for zero charge in A^-3

! call subrout to read in size of arrays
call read_size(seedname, ch_char, i_size, j_size, k_size, input_file_m, input_file_p, input_file_0)

! allocate arrays
allocate(den_m(i_size, j_size, k_size))
allocate(den_p(i_size, j_size, k_size))
allocate(den_0(i_size, j_size, k_size))

allocate(den_Ang_0(i_size, j_size, k_size))

allocate(numerator(i_size, j_size, k_size))
allocate(loc_soft(i_size, j_size, k_size))

allocate(loc_soft_Ang(i_size, j_size, k_size))

! call subrout to read in density from den_fmt files in units of electrons per supercell 
call read_den(input_file_m, i_size, j_size, k_size, den_m) 
call read_den(input_file_p, i_size, j_size, k_size, den_p) 
call read_den(input_file_0, i_size, j_size, k_size, den_0) 

! call subrout to calculate numerator
call calc_s_r(denom, surfch, i_size, j_size, k_size, den_m, den_p, numerator, loc_soft)

! call subrout to write the local softness into a file
call write_out(seedname, surfch, denom, i_size, j_size, k_size, den_0, loc_soft)

! Calculate the density and softness in units of A^-3 instead of per supercell
den_Ang_0 = den_0 / volume
loc_soft_Ang = loc_soft / volume

call write_jmol(seedname, i_size, j_size, k_size, input_file_0, den_Ang_0, loc_soft_Ang, s_min, s_max)

! deallocate arrays and finish program
deallocate(numerator)
deallocate(loc_soft)
deallocate(den_m)
deallocate(den_p)
deallocate(den_0)

deallocate(loc_soft_Ang)
deallocate(den_Ang_0)

return
end subroutine calc_loc_soft_delegate
