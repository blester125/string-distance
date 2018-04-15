# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False

from string_distance.float_minimum_edit_distance cimport distance
from string_distance.float_cost cimport ins_func, del_func, sub_func


cpdef float brew(unicode source, unicode target):
    return distance(
        source, target,
        insert_cost=ins_func,
        delete_cost=del_func,
        substitution_cost=sub_func
    )


cpdef list brews(unicode source, list targets):
    cdef unicode target
    cdef list results = []
    for target in targets:
        results.append(brew(source, target))
    return results
