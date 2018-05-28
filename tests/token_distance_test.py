import math
from collections import Counter
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
    source = "aabbbabaccb"
    target = "abbbaccdf"
    gold = 0.20943057537078857
    assert cosine_distance(source, target) == gold

def test_binary_cosine_distance():
    source = "aabbbabaccb"
    target = "abbbaccdf"
    gold = 0.2857142686843872
    assert binary_cosine_distance(source, target) == gold

def test_jaccard_distance():
    source = "abcd"
    source_shingled = ["ab", "bc", "cd"]
    target = "abddef"
    target_shingled = ["ab", "bd", "dd", "de", "ef"]
    n = 2
    intersection = len(set(source_shingled) & set(target_shingled))
    union = len(set(source_shingled) | set(target_shingled))
    gold = 1 - (intersection / union)
    assert math.isclose(jaccard_distance(source, target, n=n), gold, rel_tol=1e-5)

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

def test_shingle():
    source = ["aa", "aa", "ab", "bc", "cc", "bc"]
    gold = Counter(source)
    res = shingle(source)
    for k in res:
        assert k in gold
        assert res[k] == gold[k]
    for k in gold:
        assert k in res

def test_binary_shingle():
    source = ["aa", "aa", "ab", "bc", "cc", "bc"]
    gold = Counter(source)
    res = binary_shingle(source)
    for k in res:
        assert k in gold
        assert res[k] == 1
    for k in gold:
        assert k in res
    assert res["aa"] != gold["aa"]
    assert res["bc"] != gold["bc"]

def test_norm():
    input_ = {"aa": 12, "bb": 1, "c": 9}
    gold = math.sqrt(12 * 12 + 1 * 1 + 9 * 9)
    assert math.isclose(norm(input_), gold, rel_tol=1e-6)

def test_cosine():
    source = dict(Counter(["1", "1", "2", "3", "4", "7", "0"]))
    target = dict(Counter(["1", "2", "2", "5", "5", "6", "9"]))
    gold = 4 / (norm(source) * norm(target))
    assert math.isclose(cosine(source, target), gold, rel_tol=1e-6)


def test_binary_cosine():
    source = dict.fromkeys(["1", "1", "2", "3", "4", "7", "0"], 1)
    target = dict.fromkeys(["1", "2", "2", "5", "5", "6", "9"], 1)
    gold = 2  / (norm(source) * norm(target))
    assert math.isclose(binary_cosine(source, target), gold, rel_tol=1e-6)

def test_jaccard():
    source = dict.fromkeys(["ab", "bc", "cd"])
    target = dict.fromkeys(["ab", "bd", "dd", "de", "ef"])
    intersection = len(set(source) & set(target))
    union = len(set(source) | set(target))
    gold = intersection / union
    assert math.isclose(jaccard(source, target), gold, rel_tol=1e-6)
