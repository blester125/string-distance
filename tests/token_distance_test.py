import math
from string_distance import cosine_distance, jaccard_distance, binary_cosine_distance

def test_cosine_and_binary_different():
    source = "aabbaabcc"
    target = "abbacc"
    assert cosine_distance(source, target) != binary_cosine_distance(source, target)


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
