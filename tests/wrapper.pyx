from string_distance.token_distance cimport (
    n_grams as cn_grams,
    shingle as cshingle,
    norm as cnorm,
    binary_shingle as cbinary_shingle,
    binary_cosine as cbin_cosine,
    cosine as ccosine,
    jaccard as cjaccard,
)

def n_grams(string, n):
    return cn_grams(string, n)

def shingle(n_g):
    return cshingle(n_g)

def binary_shingle(n_g):
    return cbinary_shingle(n_g)

def norm(d):
    return cnorm(d)

def binary_cosine(s, t):
    return cbin_cosine(s, t)

def cosine(s, t):
    return ccosine(s, t)

def jaccard(s, t):
    return cjaccard(s, t)
