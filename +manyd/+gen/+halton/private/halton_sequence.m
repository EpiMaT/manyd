function r = halton_sequence ( n )

%*****************************************************************************80
%
%% HALTON_SEQUENCE computes N elements of a leaped Halton subsequence.
%
%  Discussion:
%
%    The DIM_NUM-dimensional Halton sequence is really DIM_NUM separate
%    sequences, each generated by a particular base.
%
%    This routine selects elements of a "leaped" subsequence of the 
%    Halton sequence.  The subsequence elements are indexed by a
%    quantity called STEP, which starts at 0.  The STEP-th subsequence 
%    element is simply element 
%
%      SEED(1:DIM_NUM) + STEP * LEAP(1:DIM_NUM) 
%
%    of the original Halton sequence.
%
%
%    This routine "hides" a number of input arguments.  To specify these
%    arguments explicitly, use the routine I4_TO_HALTON_SEQUENCE instead.
%
%    All the arguments have default values.  However, if you want to
%    examine or change them, you may call the appropriate routine first.
%
%    The arguments that the user may set include:
%
%    * DIM_NUM, the spatial dimension, 
%      Default: DIM_NUM = 1;
%      Required: 1 <= DIM_NUM is required.
%
%    * STEP, the subsequence index.
%      Default: STEP = 0.
%      Required: 0 <= STEP.
%
%    * SEED(1:DIM_NUM), the Halton sequence element corresponding to STEP = 0.
%      Default SEED = (0, 0, ... 0).  
%      Required: 0 <= SEED(1:DIM_NUM).
%
%    * LEAP(1:DIM_NUM), the succesive jumps in the Halton sequence.
%      Default: LEAP = (1, 1, ..., 1). 
%      Required: 1 <= LEAP(1:DIM_NUM).
%
%    * BASE(1:DIM_NUM), the Halton bases.
%      Default: BASE = (2, 3, 5, 7, 11, ... ). 
%      Required: 1 < BASE(1:DIM_NUM).
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    09 July 2004
%
%  Author:
%
%    John Burkardt
%
%  Reference:
%
%    J H Halton,
%    On the efficiency of certain quasi-random sequences of points
%    in evaluating multi-dimensional integrals,
%    Numerische Mathematik,
%    Volume 2, 1960, pages 84-90.
% 
%    J H Halton and G B Smith,
%    Algorithm 247: Radical-Inverse Quasi-Random Point Sequence,
%    Communications of the ACM,
%    Volume 7, 1964, pages 701-702.
%
%    Ladislav Kocis and William Whiten,
%    Computational Investigations of Low-Discrepancy Sequences,
%    ACM Transactions on Mathematical Software,
%    Volume 23, Number 2, 1997, pages 266-294.
%
%  Parameters:
%
%    Input, integer N, the number of elements to compute.
%
%    Output, real R(DIM_NUM,N), the SEED-th through SEED+N-1th elements of 
%    the Halton sequence for base BASE.
%
  dim_num = halton_dim_num_get ( );
  step = halton_step_get ( );
  seed = halton_seed_get ( );
  leap = halton_leap_get ( );
  base = halton_base_get ( );

  r = i4_to_halton_sequence ( dim_num, n, step, seed, leap, base );

  step = step + n;

  halton_step_set ( step );

  return
end
