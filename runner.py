import time
import argparse
import requests
from MachineLearning.Utils.TextProcessing import remove_html

parser = argparse.ArgumentParser()
parser.add_argument("--python", "-p", action="store_true")
args = parser.parse_args()

if args.python:
    from py_edit_distance import levenshtein, levenshtein_no_sub
else:
    from edit_distance import levenshtein, levenshtein_no_sub, levenshtein_parallel, levenshtein_heavy_vowels

print(levenshtein("intention", "execution"))
print(levenshtein_parallel("intention", "execution"))
print(levenshtein_no_sub("intention", "execution"))
print(levenshtein_heavy_vowels("intention", "execution"))

url1 = "https://en.wikipedia.org/wiki/Edit_distance"
text1 = requests.get(url1).text

url2 = "https://en.wikipedia.org/wiki/Computational_linguistics"
text2 = requests.get(url2).text

text1 = remove_html(text1)
text2 = remove_html(text2)

print(len(text1))
print(len(text2))

limit = None
text1 = text1[:limit]
text2 = text2[:limit]

t0 = time.time()
print(levenshtein(text1, text2))
print(time.time() - t0)

if not args.python:
    t0 = time.time()
    print(levenshtein_parallel(text1, text2))
    print(time.time() - t0)
