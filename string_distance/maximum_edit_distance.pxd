# cython: language_level=3
# cython: boundscheck=False
# cython: wrap_around=False

from string_distance.cost cimport init_func, cmp_func, max_func


cdef int distance(
    unicode source, unicode target,
    int gap_cost,
    init_func init,
    cmp_func sim_func,
    max_func max_fn
) except? -1
