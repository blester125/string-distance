import math
from string_distance import (
    longest_common_substring,
    longest_common_substring_string,
    longest_common_subsequence,
    ratcliff_obershelp
)


# Subsequence Tests
def test_longest_common_subsequence_longer_source():
    source = "bhgABCkdkrnDEFjasfdGkkuHIJ"
    target = "aABCDEFGHIJfd"
    gold = len("ABCDEFGHIJ")
    assert longest_common_subsequence(source, target) == gold


def test_longest_common_subsequence_longer_target():
    source = "aABCDEFGHIJfd"
    target = "bhgABCkdkrnDEFjasfdGkkuHIJ"
    gold = len("ABCDEFGHIJ")
    assert longest_common_subsequence(source, target) == gold


def test_longest_common_subsequence_empty_source():
    source = ""
    target = "ABCD"
    gold = 0
    assert longest_common_subsequence(source, target) == gold


def test_longest_common_subsequence_empty_target():
    source = "ABCD"
    target = ""
    gold = 0
    assert longest_common_subsequence(source, target) == gold


def test_longest_common_subsequence_both_empty():
    source = ""
    target = ""
    gold = 0
    assert longest_common_subsequence(source, target) == gold


# Substring Tests
def test_longest_common_substring_longer_source():
    source = "asdnerhABCDEFfjekn"
    target = "fndbaABCDjEFjj"
    gold = len("ABCD")
    assert longest_common_substring(source, target) == gold


def test_longest_common_substring_longer_target():
    source = "fndbaABCDjEFjj"
    target = "asdnerhABCDEFfjekn"
    gold = len("ABCD")
    assert longest_common_substring(source, target) == gold


def test_longest_common_substring_empty_source():
    source = ""
    target = "asdnerhABCDEFfjekn"
    gold = 0
    assert longest_common_substring(source, target) == gold


def test_longest_common_substring_empty_target():
    source = "asdnerhABCDEFfjekn"
    target = ""
    gold = 0
    assert longest_common_substring(source, target) == gold


def test_longest_common_substring_empty_target():
    source = ""
    target = ""
    gold = 0
    assert longest_common_substring(source, target) == gold


def test_length_and_string_match():
    source = "cvABCDghHJJL"
    target = "ABCDjghjJJL"
    length = longest_common_substring(source, target)
    str_length = len(longest_common_substring_string(source, target))
    assert length == str_length

# Ratcliff Obershelp Tests
def test_rco():
    source = "penVAINia"
    target = "pinVAINeya"
    gold = (len("pnVAINa") * 2) / (len(source) + len(target))
    assert math.isclose(ratcliff_obershelp(source, target), gold, rel_tol=1e-5)


def test_rco_longer_source():
    source = "pinVAINeya"
    target = "penVAINia"
    gold = (len("pnVAINa") * 2) / (len(source) + len(target))
    assert math.isclose(ratcliff_obershelp(source, target), gold, rel_tol=1e-5)


def test_rco_empty_source():
    source = ""
    target = "penVAINia"
    gold = 0
    assert math.isclose(ratcliff_obershelp(source, target), gold, rel_tol=1e-5)


def test_rco_empty_target():
    source = "pinVAINeya"
    target = ""
    gold = 0
    assert math.isclose(ratcliff_obershelp(source, target), gold, rel_tol=1e-5)


def test_rco_both_empty():
    source = ""
    target = ""
    gold = 0
    assert math.isclose(ratcliff_obershelp(source, target), gold, rel_tol=1e-5)
