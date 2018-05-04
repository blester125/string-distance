# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False
# cython: cdivision=True

from cpython cimport PyMem_Malloc, PyMem_Free
from cython.view cimport array as cvarray


cdef Match* longest_common_substring_base(unicode source, unicode target, Match* match) except NULL:
    cdef int n = len(source)
    cdef int m = len(target)
    cdef int i, j
    cdef int r_i = 0
    cdef int r_j = 0
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
                        r_i = i
                        r_j = j

    finally:
        PyMem_Free(source_ints)
        PyMem_Free(target_ints)

    match.length = result
    match.source_start = r_i - result
    match.source_end = r_i
    match.target_start = r_j - result
    match.target_end = r_j

    return match


cpdef int longest_common_substring(unicode source, unicode target) except -1:
    cdef int length
    cdef Match* match = <Match*>PyMem_Malloc(sizeof(Match))
    if not match:
        raise MemoryError()
    try:
        match = longest_common_substring_base(source, target, match)
        length = match.length
    finally:
        PyMem_Free(match)
    return length


cpdef list longest_common_substrings(unicode source, list targets):
    cdef unicode target
    cdef list result = []
    for target in targets:
        result.append(
            longest_common_substring(source, target)
        )
    return result


cpdef unicode longest_common_substring_string(unicode source, unicode target):
    cdef unicode substring
    cdef Match* match = <Match*>PyMem_Malloc(sizeof(Match))
    if not match:
        raise MemoryError()
    try:
        match = longest_common_substring_base(source, target, match)
        substring = source[match.source_start:match.source_end]
    finally:
        PyMem_Free(match)
    return substring


cpdef list longest_common_substring_strings(unicode source, list targets):
    cdef unicode target
    cdef list result = []
    for target in targets:
        result.append(
            longest_common_substring_string(source, target)
        )
    return result


cdef int rco_recursive(unicode source, unicode target) except -1:
    cdef length = 0
    cdef unicode left_source, right_source, left_target, right_target
    cdef Match* match = <Match*>PyMem_Malloc(sizeof(Match))
    if not match:
        raise MemoryError()
    try:
        match = longest_common_substring_base(source, target, match)
        length = match.length
        if length == 0:
            return 0
        left_source = source[:match.source_start]
        right_source = source[match.source_end:]
        left_target = target[:match.target_start]
        right_target = target[match.target_end:]
    finally:
        PyMem_Free(match)

    return (
        rco_recursive(left_source, left_target) +
        length +
        rco_recursive(right_source, right_target)
    )


cpdef float ratcliff_obershelp(unicode source, unicode target) except -1:
    cdef int element_count = len(source) + len(target)
    if element_count == 0:
        return 0
    return (<float>(2 * rco_recursive(source, target))) / element_count


cpdef list ratcliff_obershelps(unicode source, list targets):
    cdef unicode target
    cdef list result = []
    for target in targets:
        result.append(
            ratcliff_obershelps(source, target)
        )
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


cpdef list longest_common_subsequences(unicode source, list targets):
    cdef unicode target
    cdef list result = []
    for target in targets:
        result.append(
            longest_common_subsequence(source, target)
        )
    return result
