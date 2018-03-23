# cython: language_level=3
# cython: boundscheck=False
# cython: wrap_around=False

import numpy as np
from cpython cimport PyMem_Malloc, PyMem_Free
from edit_distance cimport ins_func, del_func, sub_func1
from cython.parallel cimport prange

ctypedef int (*cmp_func_no_gil)(int c1, int c2) nogil
ctypedef int (*char_func_no_gil)(int c) nogil

cdef int distance_parallel(
        unicode source, unicode target,
        char_func_no_gil insert_cost,
        char_func_no_gil delete_cost,
        cmp_func_no_gil substitution_cost
) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j, k, diags, start_col, diag_size, diag, rows, cols
    np_table = np.zeros((n + 1, m + 1), dtype=np.int32)
    cdef int[:, :] table = np_table
    cdef int* soruce_ints
    cdef int* target_ints

    source_ints = <int*>PyMem_Malloc(n * sizeof(int))
    if not source_ints:
        raise MemoryError()
    target_ints = <int*>PyMem_Malloc(m * sizeof(int))
    if not target_ints:
        raise MemoryError()

    try:
        table[0, 0] = 0
        for i in range(1, n + 1):
            source_ints[i - 1] = source[i - 1]
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]

        rows = n + 1
        cols = m + 1
        diags = rows + cols
        for diag in range(1, diags):
            start_col = max(0, diag - rows)
            diag_size = min(diag, (cols - start_col), rows)
            for k in prange(diag_size, nogil=True):
                i = min(rows, diag) - k - 1
                j = start_col + k
                if i == 0 and j == 0:
                    continue
                elif i == 0:
                    table[i, j] = table[i, j - 1] + delete_cost(source_ints[j - 1])
                elif j == 0:
                    table[i, j] = table[i - 1, j] + insert_cost(target_ints[i - 1])
                else:
                    table[i, j] = min(
                        table[i - 1, j] + delete_cost(source_ints[i - 1]),
                        table[i, j - 1] + insert_cost(target_ints[j - 1]),
                        table[i - 1, j - 1] + substitution_cost(source_ints[i - 1], target_ints[j - 1])
                    )
    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)
    return table[n, m]


cpdef int levenshtein_parallel(unicode source, unicode target):
    return distance_parallel(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func1
    )
