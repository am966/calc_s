subroutine calc_s_r(denom, surfch, i_size, j_size, k_size, den_m, den_p, numerator, loc_soft)
implicit none
!
! written by Amy Gunton
! This subroutine calculates the numerator and local softness per supercell
!
integer, intent(in) :: i_size, j_size, k_size                          ! number of grid points along x, y, z

double precision, intent(in) :: denom                            ! denominator of local softness
double precision, intent(in) :: surfch                                 ! surface charge
double precision, intent(in) :: den_m(i_size, j_size, k_size)          ! density for negative charge
double precision, intent(in) :: den_p(i_size, j_size, k_size)          ! density for positive charge

double precision, intent(inout) :: numerator(i_size, j_size, k_size)   ! numerator
double precision, intent(inout) :: loc_soft(i_size, j_size, k_size)    ! local softness

integer :: i, j, k                                                     ! index of grid position

! calculate the numerator of local softness and the local softness at each point

numerator = (den_p - den_m) / dble(2 * surfch)
loc_soft = numerator / dble(denom)

write(*,*) "average numerator over whole cell" , sum(numerator) / dble(i_size*j_size*k_size)
write(*,*) "average local softness over whole cell" , sum(loc_soft) / dble(i_size*j_size*k_size)

return

end subroutine calc_s_r
