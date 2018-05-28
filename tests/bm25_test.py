import math
from string_distance import BM25, bm25_scores

corpus = [
    ["black", "cat", "white", "cat"],
    ["cat", "outer", "space"],
    ["wag", "dog"],
]

gold = [
    [1.1237959024144617, 0.1824377227735681, 0],
    [0.11770175662810844, 1.1128701089187656, 0],
    [0, 0, 1.201942644155272]
]

def test_bm_weights():
    scores = bm25_scores(corpus)
    for row, gold_row in zip(scores, gold):
        for weight, gold_weight in zip(row, gold_row):
            assert math.isclose(weight, gold_weight)
