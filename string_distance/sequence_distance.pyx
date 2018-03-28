# cython: language_level=3
# cython: boundscheck=False
# cython: wrap_around=False

from cpython cimport PyMem_Malloc, PyMem_Free
from cython.view cimport array as cvarray


cpdef int longest_common_substring(unicode source, unicode target) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j
    cdef int result = 0
    cdef int[:, :] table = cvarray(shape=(n + 1, m + 1), itemsize=sizeof(int), format="i")
    cdef int* source_ints
    cdef int* target_ints

    source_ints = <int*>PyMem_Malloc(n * sizeof(int))
    if not source_ints:
        raise MemoryError()
    target_ints = <int*>PyMem_Malloc(m * sizeof(int))
    if not target_ints:
        raise MemoryError()

    try:
        for i in range(1, n + 1):
            source_ints[i - 1] = source[i - 1]
            table[i, 0] = 0
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = 0

        table[0, 0] = 0
        for i in range(1, n + 1):
            for j in range(1, m + 1):
                table[i, j] = 0
                if source_ints[i - 1] == target_ints[j - 1]:
                    table[i, j] = table[i - 1, j - 1] + 1
                    if table[i, j] > result:
                        result = table[i, j]

    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)

    return result


cpdef int longest_common_subsequence(unicode source, unicode target) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j
    cdef int[:, :] table = cvarray(shape=(n + 1, m + 1), itemsize=sizeof(int), format="i")
    cdef int* source_ints
    cdef int* target_ints

    source_ints = <int*>PyMem_Malloc(n * sizeof(int))
    if not source_ints:
        raise MemoryError()
    target_ints = <int*>PyMem_Malloc(m * sizeof(int))
    if not target_ints:
        raise MemoryError()

    try:
        for i in range(1, (n + 1)):
            source_ints[i - 1] = source[i - 1]
            table[i, 0] = 0
        for j in range(1, (m + 1)):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = 0

        table[0, 0] = 0
        for i in range(1, (n + 1)):
            for j in range(1, (m + 1)):
                if source_ints[i - 1] == target_ints[j - 1]:
                    table[i, j] = table[i - 1, j - 1] + 1
                else:
                    table[i, j] = max(table[i - 1, j], table[i, j - 1])

    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)

    return table[n, m]
