from string_distance import (
    levenshtein,
    levenshtein_no_sub,
)


def test_levenshtein():
    source = "intention"
    target = "execution"
    gold = 5
    assert levenshtein(source, target) == gold


def test_levenshtein_no_sub():
    source = "intention"
    target = "execution"
    gold = 8
    assert levenshtein_no_sub(source, target) == gold
