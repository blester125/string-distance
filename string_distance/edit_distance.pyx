# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False
# cython: cdivision=True

from libc.stdlib cimport malloc, free
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


cpdef int damerau_levenshtein(unicode source, unicode target):
    return transpose_distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func1,
        transpose_cost=trans_func
    )


cpdef int needleman_wunsch(unicode source, unicode target, int gap_cost=1):
    return dist(
        source, target,
        gap_cost=gap_cost,
        init=nw_init_func,
        sim_func=sim_func,
        max_fn=nw_max_func
    )


cpdef int smith_waterman(unicode source, unicode target, int gap_cost=1):
    return dist(
        source, target,
        gap_cost=gap_cost,
        init=sw_init_func,
        sim_func=sim_func,
        max_fn=sw_max_func
    )


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


cpdef float jaro(unicode source, unicode target) except -1:
    cdef int s_l = len(source)
    cdef int t_l = len(target)
    cdef int i = 0, j = 0, k = 0
    cdef int m = 0, t = 0
    cdef float w
    cdef int window = (max(s_l, t_l) / 2) - 1

    cdef int* s_ints = <int *>malloc(s_l * sizeof(int))
    if not s_ints:
        raise MemoryError()
    cdef int* t_ints = <int *>malloc(t_l * sizeof(int))
    if not t_ints:
        raise MemoryError()
    cdef int* s_matched = <int *>malloc(s_l * sizeof(int))
    if not s_matched:
        raise MemoryError()
    cdef int* t_matched = <int *>malloc(t_l * sizeof(int))
    if not t_matched:
        raise MemoryError()

    try:
        for i in range(s_l):
            s_ints[i] = source[i]
            s_matched[i] = 0
        for i in range(t_l):
            t_ints[i] = target[j]
            t_matched[i] = 0

        # Search forward within the window for a match.
        for i in range(s_l):
            low = i - window if i > window else 0
            high = i + window if i + window < t_l else t_l - 1
            for j in range(low, high + 1):
                # If you get a match break so you don't double count.
                if target[j] == source[i]:
                    s_matched[i] = 1
                    t_matched[j] = 1
                    m += 1
                    break

        # If there is no matches at all quit.
        if m == 0:
            return 0.0

        # Find transpositions.
        for i in range(s_l):
            # If this character matches something in the other string.
            if s_matched[i] == 1:
                # Loop through other string
                for j in range(k, t_l):
                    # Once we hit a matching char in the other string stop
                    if t_matched[j]:
                        # Move start of search
                        k = j + 1
                        break
                # If the matches we are looking at aren't the same add a transposition
                if s_ints[i] != t_ints[j]:
                    t += 1
        t = t / 2

        w = (<float>m / s_l + <float>m / t_l + <float>(m - t) / m) / 3.

    finally:
        free(s_ints)
        free(t_ints)
        free(s_matched)
        free(t_matched)

    return w


cpdef float jaro_winkler(unicode source, unicode target, float p=0.1) except -1:
    cdef int l = 0
    cdef int end = min(len(source), len(target), 4)
    cdef float jaro_sim
    if p > 0.25:
        raise ValueError("p should not exceed 0.25, got {}".format("p"))
    for l in range(end):
        if source[l] != target[l]:
            break
    jaro_sim = jaro(source, target)
    return jaro_sim + (l * p * (1 - jaro_sim))


# Functions that do a one vs many comparison
cpdef list levenshteins(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            levenshtein(source, target)
        )
    return results


cpdef list levenshtein_no_subs(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            levenshtein_no_sub(source, target)
        )
    return results


cpdef list damerau_levenshteins(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            damerau_levenshtein(source, target)
        )
    return results


cpdef list needleman_wunschs(unicode source, list targets, int gap_cost=1):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            needleman_wunschs(source, target, gap_cost=gap_cost)
        )
    return results


cpdef list smith_watermans(unicode source, list targets, int gap_cost=1):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            smith_waterman(source, target, gap_cost=gap_cost)
        )
    return results


cpdef list hammings(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            hamming(source, target)
        )
    return results


cpdef list jaros(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            jaro(source, target)
        )
    return results


cpdef list jaro_winklers(unicode source, list targets, float p=0.1):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(
            jaro_winkler(source, target, p)
        )
    return results


# cpdef int levenshtein_heavy_vowels(unicode source, unicode target):
#     return distance(
#         source, target,
#         insert_cost=heavy_vowels,
#         delete_cost=del_func,
#         substitution_cost=heavy_vowel_sub
#     )
