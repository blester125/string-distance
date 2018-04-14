# cdef unicode vowels = u'aeiouAEIOU'
# cdef int[10] VOWELS
# cdef int VOWEL_SIZE = 10
# cdef int i
# for i in range(VOWEL_SIZE):
#     VOWELS[i] = vowels[i]


ctypedef int (*cmp_func)(int c1, int c2)
ctypedef int (*char_func)(int c)
ctypedef int (*init_func)(int place, int cost)
ctypedef int (*max_func)(int a, int b, int c)


cdef inline int trans_func(int c1, int c2):
    return 1


cdef inline int sub_func1(int c1, int c2) nogil:
    if c1 == c2:
        return 0
    return 1


cdef inline int sub_func2(int c1, int c2) nogil:
    if c1 == c2:
        return 0
    return 2

cdef inline int del_func(int c) nogil:
    return 1


cdef inline int ins_func(int c) nogil:
    return 1

cdef inline int nw_init_func(int place, int cost):
    return -(place * cost)

cdef inline int sw_init_func(int place, int cost):
    return 0

cdef inline int nw_max_func(int a, int b, int c):
    return max(a, b, c)

cdef inline int sw_max_func(int a, int b, int c):
    return max(0, a, b, c)

cdef inline int sim_func(int c1, int c2):
    if c1 == c2:
        return 1
    return 0

# cdef inline int heavy_vowels(int c):
#     cdef int i
#     for i in range(VOWEL_SIZE):
#         if c == VOWELS[i]:
#             return 5
#     return 1

# cdef inline int heavy_vowel_sub(int c1, int c2):
#     cdef int i
#     if c1 == c2:
#         return 0
#     for i in range(VOWEL_SIZE):
#         if c2 == VOWELS[i]:
#             return 5
#     return 2
