# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from cpython cimport PyMem_Malloc, PyMem_Free
from libc.math cimport sqrt


cpdef list n_grams(unicode string, int n):
    cdef int i
    cdef list ngrams = []
    for i in range(len(string) - n + 1):
        ngrams.append(string[i:i+n])
    return ngrams


cpdef dict binary_shingle(list ngrams):
    cdef dict shingled = {}
    cdef unicode gram
    for gram in ngrams:
        shingled[gram] = 1
    return shingled


cpdef dict shingle(list ngrams):
    cdef dict shingled = {}
    cdef unicode gram
    for gram in ngrams:
        if gram in shingled:
            shingled[gram] += 1
        else:
            shingled[gram] = 1
    return shingled


cpdef float binary_cosine(dict source, dict target):
    """intersection could be computed with `len(set(source) & set(target))`
    that is fastest for normal python but with cython explicit loops are faster.

    With`len(source) = 15720` and `len(target) = 46750`
        python way = 0.004878520965576172
        cython way = 0.002151012420654297
    """
    cdef unicode key
    cdef int intersection = 0
    # Because this is binary the norm of a vector is just the sum of the vector
    cdef float norm = sqrt(len(source)) * sqrt(len(target))
    for key in source:
        if key in target:
            intersection += 1
    return 1 - (intersection / norm)


cpdef float norm(dict vector):
    cdef float norm_val = 0
    for v in vector.values():
        norm_val += v * v
    return sqrt(norm_val)


cpdef float cosine(dict source, dict target):
    cdef float source_norm = norm(source)
    cdef float target_norm = norm(target)
    cdef float norm_ = source_norm + target_norm
    cdef float intersection = 0
    for k, v in source.items():
        if k in target:
            intersection += v * target[k]
    return 1 - (intersection / norm_)


cpdef float jaccard(dict source, dict target):
    cdef unicode key
    cdef set union_ = set()
    cdef int intersection = 0
    for key in source:
        union_.add(key)
        if key in target:
            intersection += 1
    for key in target:
        union_.add(key)
    print(intersection)
    print(len(union_))
    return 1 - (intersection / len(union_))
