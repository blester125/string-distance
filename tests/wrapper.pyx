from string_distance.token_distance cimport n_grams as cn_grams, shingle as cshingle

def n_grams(string, n):
    return cn_grams(string, n)

def shingle(n_g):
    return cshingle(n_g)
