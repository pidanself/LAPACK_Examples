    Program zsptri_example

!     ZSPTRI Example Program Text

!     Copyright (c) 2018, Numerical Algorithms Group (NAG Ltd.)
!     For licence see
!       https://github.com/numericalalgorithmsgroup/LAPACK_Examples/blob/master/LICENCE.md

!     .. Use Statements ..
      Use lapack_example_aux, Only: nagf_file_print_matrix_complex_packed_comp
      Use lapack_interfaces, Only: zsptrf, zsptri
      Use lapack_precision, Only: dp
!     .. Implicit None Statement ..
      Implicit None
!     .. Parameters ..
      Integer, Parameter :: nin = 5, nout = 6
!     .. Local Scalars ..
      Integer :: i, ifail, info, j, n
      Character (1) :: uplo
!     .. Local Arrays ..
      Complex (Kind=dp), Allocatable :: ap(:), work(:)
      Integer, Allocatable :: ipiv(:)
      Character (1) :: clabs(1), rlabs(1)
!     .. Executable Statements ..
      Write (nout, *) 'ZSPTRI Example Program Results'
!     Skip heading in data file
      Read (nin, *)
      Read (nin, *) n

      Allocate (ap(n*(n+1)/2), work(n), ipiv(n))

!     Read A from data file

      Read (nin, *) uplo
      If (uplo=='U') Then
        Read (nin, *)((ap(i+j*(j-1)/2),j=i,n), i=1, n)
      Else If (uplo=='L') Then
        Read (nin, *)((ap(i+(2*n-j)*(j-1)/2),j=1,i), i=1, n)
      End If

!     Factorize A
      Call zsptrf(uplo, n, ap, ipiv, info)

      Write (nout, *)
      Flush (nout)
      If (info==0) Then

!       Compute inverse of A
        Call zsptri(uplo, n, ap, ipiv, work, info)

!       Print inverse

!       ifail: behaviour on error exit
!              =0 for hard exit, =1 for quiet-soft, =-1 for noisy-soft
        ifail = 0
        Call nagf_file_print_matrix_complex_packed_comp(uplo, 'Nonunit', n, &
          ap, 'Bracketed', 'F7.4', 'Inverse', 'Integer', rlabs, 'Integer', &
          clabs, 80, 0, ifail)

      Else
        Write (nout, *) 'The factor D is singular'
      End If

    End Program
