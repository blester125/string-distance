import math
from string_distance import cosine_distance, jaccard_distance, binary_cosine_distance
import pyximport; pyximport.install(build_in_temp=True, inplace=True)
from wrapper import *

def test_cosine_and_binary_different():
    source = "aabbaabcc"
    target = "abbacc"
    assert cosine_distance(source, target) != binary_cosine_distance(source, target)

def test_cosine_equality():
    for i in range(2, 7):
        word = ''.join(str(n) for n in range(i))
        assert math.isclose(cosine_distance(word, word), 0, abs_tol=1e-6)

def test_cosine_distance():
    source = "This is an example"
    n = n_grams(source, 2)
    s = shingle(n)
    print(n)
    print(s)

def test_n_grams_2():
    n = 2
    source = "abcdef"
    gold = ["ab", "bc", "cd", "de", "ef"]
    assert n_grams(source, n) == gold

def test_n_grams_3():
    n = 3
    source = "abcdef"
    gold = ["abc", "bcd", "cde", "def"]
    assert n_grams(source, n) == gold

def test_jaccard():
    source = "abcd"
    source_shingled = ["ab", "bc", "cd"]
    target = "abddef"
    target_shingled = ["ab", "bd", "dd", "de", "ef"]
    n = 2
    intersection = len(set(source_shingled) & set(target_shingled))
    union = len(set(source_shingled) | set(target_shingled))
    gold = 1 - (intersection / union)
    assert math.isclose(jaccard_distance(source, target, n=n), gold, rel_tol=1e-5)
