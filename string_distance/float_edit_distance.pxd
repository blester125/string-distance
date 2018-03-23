ctypedef float (*cmp_func)(int c1, int c2)
ctypedef float (*char_func)(int c)


cdef inline float sub_func(int c1, int c2):
    if c1 == c2:
        return 0
    return 1.0


cdef inline float ins_func(int c1):
    return 0.1


cdef inline float del_func(int c1):
    return 15
