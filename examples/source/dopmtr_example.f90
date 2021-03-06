    Program dopmtr_example

!     DOPMTR Example Program Text

!     Copyright (c) 2018, Numerical Algorithms Group (NAG Ltd.)
!     For licence see
!       https://github.com/numericalalgorithmsgroup/LAPACK_Examples/blob/master/LICENCE.md

!     .. Use Statements ..
      Use lapack_example_aux, Only: nagf_blas_damax_val, &
        nagf_file_print_matrix_real_gen
      Use lapack_interfaces, Only: dopmtr, dsptrd, dstebz, dstein
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Real (Kind=dp), Parameter :: zero = 0.0E0_dp
      Integer, Parameter :: nin = 5, nout = 6
!     .. Local Scalars ..
      Real (Kind=dp) :: r, vl, vu
      Integer :: i, ifail, info, j, k, ldc, m, n, nsplit
      Character (1) :: uplo
!     .. Local Arrays ..
      Real (Kind=dp), Allocatable :: ap(:), c(:, :), d(:), e(:), tau(:), w(:), &
        work(:)
      Integer, Allocatable :: iblock(:), ifailv(:), isplit(:), iwork(:)
!     .. Executable Statements ..
      Write (nout, *) 'DOPMTR Example Program Results'
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n
      ldc = n
      Allocate (ap(n*(n+1)/2), c(ldc,n), d(n), e(n), tau(n), w(n), work(5*n), &
        iblock(n), ifailv(n), isplit(n), iwork(3*n))

!     Read A from data file

      Read (nin, *) uplo
      If (uplo=='U') Then
        Read (nin, *)((ap(i+j*(j-1)/2),j=i,n), i=1, n)
      Else If (uplo=='L') Then
        Read (nin, *)((ap(i+(2*n-j)*(j-1)/2),j=1,i), i=1, n)
      End If

!     Reduce A to tridiagonal form T = (Q**T)*A*Q
      Call dsptrd(uplo, n, ap, d, e, tau, info)

!     Calculate the two smallest eigenvalues of T (same as A)
      Call dstebz('I', 'B', n, vl, vu, 1, 2, zero, d, e, m, nsplit, w, iblock, &
        isplit, work, iwork, info)

      Write (nout, *)
      If (info>0) Then
        Write (nout, *) 'Failure to converge.'
      Else
        Write (nout, *) 'Eigenvalues'
        Write (nout, 100) w(1:m)

!       Calculate the eigenvectors of T, storing the result in C
        Call dstein(n, d, e, m, w, iblock, isplit, c, ldc, work, iwork, &
          ifailv, info)

        If (info>0) Then
          Write (nout, *) 'Failure to converge.'
        Else

!         Calculate the eigenvectors of A = Q * (eigenvectors of T)
          Call dopmtr('Left', uplo, 'No transpose', n, m, ap, tau, c, ldc, &
            work, info)

!         Print eigenvectors
          Write (nout, *)
          Flush (nout)

!         Normalize the eigenvectors
          Do i = 1, m
            Call nagf_blas_damax_val(n, c(1,i), 1, k, r)
            If (c(k,i)<zero) Then
              c(1:n, i) = -c(1:n, i)
            End If
          End Do

!         ifail: behaviour on error exit
!                =0 for hard exit, =1 for quiet-soft, =-1 for noisy-soft
          ifail = 0
          Call nagf_file_print_matrix_real_gen('General', ' ', n, m, c, ldc, &
            'Eigenvectors', ifail)

        End If
      End If

100   Format (3X, (9F8.4))
    End Program
