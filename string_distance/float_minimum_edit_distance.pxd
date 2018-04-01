from string_distance.float_cost cimport char_func, cmp_func

cdef float distance(
        unicode source, unicode target,
        char_func insert_cost,
        char_func delete_cost,
        cmp_func substitution_cost
) except -1
