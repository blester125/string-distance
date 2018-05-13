import math
from string_distance import cosine_distance, jaccard_distance, binary_cosine_distance

def test_cosine_and_binary_different():
    source = "aabbaabcc"
    target = "abbacc"
    assert cosine_distance(source, target) != binary_cosine_distance(source, target)


def test_jaccard():
    source = "abcd"
    target = "abddef"
    n = 2
    intersection = 1
    union = (len(source) - n) + (len(target) - n)
    gold = intersection / union
    math.isclose(jaccard_distance(source, target, n=n), gold)
