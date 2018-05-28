# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

cdef list n_grams(unicode string, int n)
cdef dict shingle(list ngrams)
cdef dict binary_shingle(list ngrams)
cdef float norm(dict vector)
cdef float binary_cosine(dict source, dict target)
cdef float cosine(dict source, dict target)
cdef float jaccard(dict source, dict target)
