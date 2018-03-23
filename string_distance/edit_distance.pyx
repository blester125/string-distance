# cython: language_level=3
# cython: boundscheck=False
# cython: wrap_around=False

from cpython cimport PyMem_Malloc, PyMem_Free
from cython.view cimport array as cvarray

cdef int distance(
        unicode source, unicode target,
        char_func insert_cost,
        char_func delete_cost,
        cmp_func substitution_cost
) except -1:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j
    cdef int[:, :] table = cvarray(shape=(n + 1, m + 1), itemsize=sizeof(int), format="i")
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
            table[i, 0] = table[i - 1, 0] + delete_cost(source_ints[i - 1])
        for j in range(1, m + 1):
            target_ints[j - 1] = target[j - 1]
            table[0, j] = table[0, j - 1] + insert_cost(target_ints[j - 1])

        for i in range(1, n + 1):
            for j in range(1, m + 1):
                table[i, j] = min(
                    table[i - 1, j] + delete_cost(source_ints[i - 1]),
                    table[i, j - 1] + insert_cost(target_ints[j - 1]),
                    table[i - 1, j - 1] + substitution_cost(source_ints[i - 1], target_ints[j - 1])
                )
    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)
    return table[n, m]


cpdef int levenshtein(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func1
    )


cpdef int levenshtein_no_sub(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func2
    )


cpdef int levenshtein_heavy_vowels(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=heavy_vowels,
        delete_cost=del_func,
        substitution_cost=heavy_vowel_sub
    )
