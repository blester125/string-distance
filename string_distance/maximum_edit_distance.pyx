# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from cpython cimport PyMem_Malloc, PyMem_Free
from cython.view cimport array as cvarray
from string_distance.cost cimport init_func, cmp_func, max_func


cdef int distance(
    unicode source, unicode target,
    int gap_cost,
    init_func init,
    cmp_func sim_func,
    max_func max_fn
) except? -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i = 0
    cdef int j = 0
    cdef int index = 0
    cdef int offset
    cdef int[:, :] table = cvarray(shape=(2, m + 1), itemsize=sizeof(int), format="i")
    cdef int* source_ints
    cdef int* target_ints

    source_ints = <int*>PyMem_Malloc(n * sizeof(int))
    if not source_ints:
        raise MemoryError()
    target_ints = <int*>PyMem_Malloc(m * sizeof(int))
    if not target_ints:
        raise MemoryError()

    try:
        table[0, 0] = 0
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = init(j, gap_cost)

        for i in range(1, n + 1):
            index = i % 2
            if index == 1:
                offset = -1
            else:
                offset = 1
            source_ints[i - 1] = source[i - 1]
            table[index, 0] = init(i, gap_cost)

            for j in range(1, m + 1):
                table[index, j] = max_fn(
                    table[index + offset, j - 1] + sim_func(source_ints[i - 1], target_ints[j - 1]),
                    table[index + offset, j] - gap_cost,
                    table[index, j - 1] - gap_cost
                )

    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)
    return table[index, m]
