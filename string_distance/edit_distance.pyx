# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from string_distance.minimum_edit_distance cimport distance, transpose_distance
from string_distance.maximum_edit_distance cimport distance as dist
from string_distance.cost cimport (
    ins_func, del_func,
    sub_func1, sub_func2,
    trans_func,
    nw_init_func, sw_init_func,
    nw_max_func, sw_max_func,
    sim_func
)


cpdef int needleman_wunsch(unicode source, unicode target, int gap_cost=1):
    return dist(
        source, target,
        gap_cost=gap_cost,
        init=nw_init_func,
        sim_func=sim_func,
        max_fn=nw_max_func
    )


cpdef list needleman_wunschs(unicode source, list targets, int gap_cost=1):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            needleman_wunschs(source, target, gap_cost=gap_cost)
        )
    return results


cpdef int smith_waterman(unicode source, unicode target, int gap_cost=1):
    return dist(
        source, target,
        gap_cost=gap_cost,
        init=sw_init_func,
        sim_func=sim_func,
        max_fn=sw_max_func
    )


cpdef list smith_watermans(unicode source, list targets, int gap_cost=1):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            smith_waterman(source, target, gap_cost=gap_cost)
        )
    return results


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


cpdef list hammings(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            hamming(source, target)
        )
    return results


cpdef int levenshtein(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func1
    )


cpdef list levenshteins(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            levenshtein(source, target)
        )
    return results


cpdef int levenshtein_no_sub(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func2
    )


cpdef list levenshtein_no_subs(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            levenshtein_no_sub(source, target)
        )
    return results

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


cpdef list damerau_levenshteins(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            damerau_levenshtein(source, target)
        )
    return results
