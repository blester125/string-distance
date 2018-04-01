from string_distance import levenshtein, levenshtein_no_sub, brew
from string_distance import (
    longest_common_substring,
    longest_common_substring_string,
    ratcliff_obershelp,
)
from textdistance import ratcliff_obershelp as rco

print(levenshtein("intention", "execution"))
print(levenshtein_no_sub("intention", "execution"))
print(brew("Hosp", "Hospital"))

source = "ABCDasdf"
target = "asdfABCDdfg"
print(source)
print(target)
print(longest_common_substring(source, target))
print(longest_common_substring_string(source, target))

print(ratcliff_obershelp(source, target))
print(rco(source, target))
