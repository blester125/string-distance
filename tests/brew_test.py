import numpy as np

from string_distance import brew


def test_example():
    source = "Hosp"
    target = "Hospital"
    gold = 0.4
    np.testing.assert_allclose(brew(source, target), gold)
