import math
from collections import Counter

def BM25(corpus, k=1.5, b=0.75):
    corpus_size = len(corpus)
    doc_len = [len(doc) for doc in corpus]
    avg_len = sum(doc_len) / corpus_size
    freqs = []
    df = Counter()
    idf = {}
    epsilon = 0.25

    for document in corpus:
        f = Counter(document)
        freqs.append(f)

        for token, freq in f.items():
            df[token] += 1

    for token, freq in df.items():
        # This is the weird IDF that BM25 uses
        idf[token] = math.log((corpus_size - freq + 0.5) / (freq + 0.5))

    avg_idf = sum(x for x in idf.values()) / len(idf)

    def score(query, d):
        if isinstance(d, int):
            freq = freqs[d]
            dlen = doc_len[d]
        else:
            freq = Counter(d)
            dlen = len(d)
        val = 0
        for token in query:
            if token not in freq:
                continue
            idf_ = idf[token] if idf[token] >= 0 else epsilon * avg_idf
            val += idf_ * (freq[token] * (k + 1)) / (freq[token] + k * (1 - b + b * (dlen / avg_len)))
        return val

    return score

def bm25_scores(corpus):
    bm = BM25(corpus)
    scores = []
    for doc in corpus:
        s = []
        for i in range(len(corpus)):
            s.append(bm(doc, i))
        scores.append(s)
    return scores
