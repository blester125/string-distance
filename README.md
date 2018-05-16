# Minimum Edit Distance in Cython

[![Build Status](https://travis-ci.com/blester125/string_distance.svg?branch=master)](https://travis-ci.com/blester125/string_distance)

This provides String Distance functions in Cython.

### Edit Based

With these metrics smaller is better.

 * `levenshtein` (1 for insert, 1 for delete, and 1 for substitution)
 * `levenshtein_no_sub` (1 for insert, 1 for delete, 2 for substitution)
 * `brew` (0.1 for insert, 15 for delete, and 1 for substitution)
 * `dameran_levenshtein` (1 for insert, 1 for delete, 1 for substitution, 1 for transposition)

### Token Based

 * `cosine_distance`
 * `binary_cosine_distance`
 * `jaccard_distance`

### Sequence Based

With these metrics Larger is better.

 * `longest_common_subsequence`
 * `longest_common_substring`
 * `Ratcliff-Obershelft`
