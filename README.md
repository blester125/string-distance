# Minimum Edit Distance in Cython

[![Build Status](https://travis-ci.com/blester125/string_distance.svg?branch=master)](https://travis-ci.com/blester125/string_distance)

This provides String Distance functions in Cython.

### Edit Based

With these metrics smaller is better.

 * `levenshtein` (1 for insert, 1 for delete, and 1 for substitution)
 * `levenshtein_no_sub` (1 for insert, 1 for delete, 2 for substitution)
 * `brew` (0.1 for insert, 15 for delete, and 1 for substitution)
 * `dameran_levenshtein` (1 for insert, 1 for delete, 1 for substitution, 1 for transposition)
 * `jaro_winkler`

### Token Based

 * `cosine_distance`
 * `binary_cosine_distance`
 * `jaccard_distance`

### Sequence Based

With these metrics Larger is better.

 * `longest_common_subsequence`
 * `longest_common_substring`
 * `ratcliff_obershelft`


### Extending and rolling your own cost functions

There are 2 kinds of functions used to define costs for the dynamic programming minimum edit distance algorithm. The first is `ctypedef int (*cmp_func)(int c1, int c2)` which is used to compare two characters and return a cost. The second is `ctypedef int (*char_func)(int c1)`. By implementing your own versions of these functions (I would recommned doing it in cost.pxd and inline'ing the function) you can pass them to the distance solver to implement your own weighting scheme. The `cmp_func` can be used to weight a substitution (for example a low cost to letter next to each other on the keyboard like `w` and `e` and high cost to far keys like `z` and `p`). The `char_func` can can be used to weight the insert or delete, for example you could weight inserts by their scabble scores.
