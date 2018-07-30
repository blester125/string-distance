import math
import string
import random
import pytest
from string_distance import (
    hamming,
    levenshtein,
    levenshtein_no_sub,
    brew,
    damerau_levenshtein,
    longest_common_subsequence,
    jaro,
    jaro_winkler
)


# Brew Tests
def test_brew():
    source = "Hosp"
    target = "Hospital"
    gold = 0.4
    assert math.isclose(brew(source, target), gold, rel_tol=1e-7)


def test_brew_longer_source():
    source = "Hospital"
    target = "Hosp"
    brew(source, target)


def test_brew_different_when_swapped():
    source = "asdfbne"
    target = "asejrb"
    assert brew(source, target) != brew(target, source)


def test_brew_empty_source():
    source = ""
    target = "asdfb"
    # From brew insert cost
    gold = len(target) * 0.1
    assert brew(source, target) == gold


def test_brew_empty_target():
    source = "asdfb"
    target = ""
    # From brew delete cost
    gold = len(source) * 15
    assert brew(source, target) == gold


def test_brew_both_empty():
    source = ""
    target = ""
    gold = 0
    assert brew(source, target) == gold


# Levenshtein Tests
def test_levenshtein():
    source = "intention"
    target = "execution"
    gold = 5
    assert levenshtein(source, target) == gold

def test_levenshtein_longer_source():
    source = "aaaaaaaa"
    target = "aaaaa"
    gold = abs(len(source) - len(target)) * 1
    assert levenshtein(source, target) == gold

def test_levenshtein_longer_target():
    source = "aaaaa"
    target = "aaaaaaaa"
    gold = abs(len(source) - len(target)) * 1
    assert levenshtein(source, target) == gold

def test_levenshtein_empty_source():
    source = ""
    target = "aaaaa"
    gold = len(target) * 1
    assert levenshtein(source, target) == gold

def test_levenshtein_empty_target():
    source = "aaaaa"
    target = ""
    gold = len(source) * 1
    assert levenshtein(source, target) == gold

def test_levenshtein_both_empty():
    source = ""
    target = ""
    gold = 0
    assert levenshtein(source, target) == gold


# Levenshtein_no_sub Tests
def test_no_sub_is_different():
    source = "aabbc"
    target = "aabbz"
    assert levenshtein(source, target) != levenshtein_no_sub(source, target)


def test_levenshtein_no_sub():
    source = "intention"
    target = "execution"
    gold = 8
    assert levenshtein_no_sub(source, target) == gold

def test_levenshtein_no_sub_longer_source():
    source = "aaaaaaaa"
    target = "aaaaa"
    gold = abs(len(source) - len(target)) * 1
    assert levenshtein_no_sub(source, target) == gold

def test_levenshtein_no_sub_longer_target():
    source = "aaaaa"
    target = "aaaaaaaa"
    gold = abs(len(source) - len(target)) * 1
    assert levenshtein_no_sub(source, target) == gold

def test_levenshtein_no_sub_empty_source():
    source = ""
    target = "aaaaa"
    gold = len(target) * 1
    assert levenshtein_no_sub(source, target) == gold

def test_levenshtein_no_sub_empty_target():
    source = "aaaaa"
    target = ""
    gold = len(source) * 1
    assert levenshtein_no_sub(source, target) == gold

def test_levenshtein_no_subboth_empty():
    source = ""
    target = ""
    gold = 0
    assert levenshtein_no_sub(source, target) == gold


# Damerau Levenshtein
def test_dl_is_different():
    source = "agdaabbvnb"
    target = "aedababicb"
    assert damerau_levenshtein(source, target) != levenshtein(source, target)
    assert damerau_levenshtein(source, target) == levenshtein(source, target) - 1

def test_dl():
    source = "from"
    target = "form"
    gold = 1
    assert damerau_levenshtein(source, target) == gold

def test_dl_2():
    source = "jurisdiction"
    target = "Copley"
    gold = 12
    assert damerau_levenshtein(source, target) == gold

# Hamming Tests
def test_hamming_size_mismatch():
    source = "ABCD"
    target = "AB"
    with pytest.raises(ValueError):
        hamming(source, target)


def test_hamming_empty():
    source = ""
    target = ""
    gold = 0
    assert hamming(source, target) == gold


def test_hamming():
    source = "100110110"
    target = "101110011"
    gold = 3
    assert hamming(source, target) == gold


def test_edit_distance_from_LCS():
    """Edit distance (with only insert and delete) should be equ with
        len(a) + len(b) + 2 * lcs(a, b)
        from: Mining of Massive Datasets second ed. ch 3 page 96
    """
    def real_test(source, target):
        lcs = longest_common_subsequence(source, target)
        gold = levenshtein_no_sub(source, target)
        assert (len(source) + len(target) - (2 * lcs)) == gold

    trials = 100
    for _ in range(trials):
        source = ''.join([random.choice(("G", "A", "T", "C")) for _ in range(random.randint(5, 41))])
        target = ''.join([random.choice(("G", "A", "T", "C")) for _ in range(random.randint(5, 41))])
        real_test(source, target)

# Jaro(_Winker)? tests
def test_jaro_vs_winkler_prefix_match():
    prefix = ''.join([random.choice(string.ascii_lowercase) for _ in range(4)])
    source = ''.join([random.choice(string.ascii_lowercase) for _ in range(10)])
    target = ''.join([random.choice(string.ascii_lowercase) for _ in range(10)])
    source = prefix + source
    target = prefix + target
    j = jaro(source, target)
    jw = jaro_winkler(source, target)
    assert not math.isclose(j, jw)

def test_jaro_vs_winkler_prefix_mismatch():
    prefix = ''.join([random.choice(string.ascii_lowercase) for _ in range(4)])
    prefix2 = ''.join([chr(ord(c) + 1) for c in prefix])
    source = ''.join([random.choice(string.ascii_lowercase) for _ in range(10)])
    target = ''.join([random.choice(string.ascii_lowercase) for _ in range(10)])
    source = prefix + source
    target = prefix2 + target
    assert prefix != prefix2
    j = jaro(source, target)
    jw = jaro_winkler(source, target)
    assert math.isclose(j, jw)

def test_jaro():
    source = "This is a test"
    target = "There is goes"
    gold = 0.7257742285728455
    assert math.isclose(jaro(source, target), gold)

def test_jaro_winkler():
    source = "This is a test"
    target = "There is goes"
    gold = 0.7806193828582764
    assert math.isclose(jaro_winkler(source, target), gold)
