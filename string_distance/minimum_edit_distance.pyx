# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from cpython cimport PyMem_Malloc, PyMem_Free
from cython.view cimport array as cvarray
from string_distance.cost cimport char_func, cmp_func

cdef int distance(
        unicode source, unicode target,
        char_func insert_cost,
        char_func delete_cost,
        cmp_func substitution_cost
) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j, index, offset
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
        index = 0
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = table[0, j - 1] + insert_cost(target_ints[j - 1])

        for i in range(1, n + 1):
            index = i % 2
            if index == 1:
                offset = -1
            else:
                offset = 1
            # This could be moved out of the loop
            source_ints[i - 1] = source[i - 1]
            table[index, 0] = table[index + offset, 0] + delete_cost(source_ints[i - 1])

            for j in range(1, m + 1):
                table[index, j] = min(
                    table[index + offset, j] + delete_cost(source_ints[i - 1]),
                    table[index, j - 1] + insert_cost(target_ints[j - 1]),
                    table[index + offset, j - 1] + substitution_cost(source_ints[i - 1], target_ints[j - 1])
                )
    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)
    return table[index, m]


cdef int transpose_distance(
        unicode source, unicode target,
        char_func insert_cost,
        char_func delete_cost,
        cmp_func substitution_cost,
        cmp_func transpose_cost
) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j, index, offset, t_offset
    cdef int[:, :] table = cvarray(shape=(3, m + 1), itemsize=sizeof(int), format="i")
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
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = table[0, j - 1] + insert_cost(target_ints[j - 1])

        for i in range(1, n + 1):
            index = i % 3
            if index == 0:
                offset = 2
                t_offset = 1
            elif index == 1:
                offset = -1
                t_offset = 1
            elif index == 2:
                offset = -1
                t_offset = -2
            source_ints[i - 1] = source[i - 1]
            table[index, 0] = table[index + offset, 0] + delete_cost(source_ints[i - 1])

            for j in range(1, m + 1):
                table[index, j] = min(
                    table[index + offset, j] + delete_cost(source_ints[i - 1]),
                    table[index, j - 1] + insert_cost(target_ints[j - 1]),
                    table[index + offset, j - 1] + substitution_cost(source_ints[i - 1], target_ints[j - 1])
                )
                # If I can do a transpose
                if i > 1 and j > 1:
                    if source_ints[i - 1] == target_ints[j - 2] and source_ints[i - 2] == target_ints[j - 1]:
                        table[index, j] = min(
                            table[index, j],
                            table[index + t_offset, j - 2] + transpose_cost(source_ints[i - 1], target_ints[i - 2])
                        )
    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)
    return table[index, m]
