# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from string_distance.minimum_edit_distance cimport distance, transpose_distance
from string_distance.cost cimport ins_func, del_func, sub_func1, sub_func2, trans_func


cpdef int hamming(unicode source, unicode target) except -1:
    cdef int i
    cdef int source_length = len(source)
    cdef int target_length = len(target)
    cdef int distance = 0
    if source_length != target_length:
        raise ValueError("Strings must be the same length.")
    for i in range(source_length):
        if source[i] != target[i]:
            distance += 1
    return distance


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


# cpdef int levenshtein_heavy_vowels(unicode source, unicode target):
#     return distance(
#         source, target,
#         insert_cost=heavy_vowels,
#         delete_cost=del_func,
#         substitution_cost=heavy_vowel_sub
#     )


cpdef int damerau_levenshtein(unicode source, unicode target):
    return transpose_distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func1,
        transpose_cost=trans_func
    )
