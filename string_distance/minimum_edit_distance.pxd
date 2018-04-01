# cython: language_level=3
# cython: boundscheck=False
# cython: wrap_around=False

from string_distance.cost cimport char_func, cmp_func


cdef int distance(
    unicode source, unicode target,
    char_func insert_cost,
    char_func delete_cost,
    cmp_func substitution_cost
) except -1


cdef int transpose_distance(
    unicode source, unicode target,
    char_func insert_cost,
    char_func delete_cost,
    cmp_func substitution_cost,
    cmp_func transpose_cost
) except -1
