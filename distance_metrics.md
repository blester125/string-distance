# Edit Distances
---

-string\_distance
 |
 |-edit\_distance
 | |
 | |-edit\)utils
 | | |
 | | |-char_func
 | | |-cmp_func
 | | |-inserts
 | | |-deletes
 | | |-substitutions
 | | |-transposes
 | |
 | |-Hamming
 | |-MLPNS
 | |-Levenshtein
 | |-Levenshtein
 | |-Full Dameran-Levenshtein
 | |-Partial Dameran-Levenshtein
 | |-Jaro-Winkler
 | |-Neddleman-Wunsh
 | |-Gothoh
 | |-Smith-Waterman
 | |-Brew
 |
 |-token\_distance
 | |-token\_utils
 | | |
 | | |-n-grams
 | | |-shingle
 | |
 | |-Jaccard Index
 | |-Sorensin-Dice Coefficient
 | |-Tversky Index
 | |-Overlap coefficient
 | |-Tanimoto distance
 | |-Cosine Similarity
 | |-Binary Cosine
 | |-tf-idf Cosine
 | |-Monge-Elkan
 | |-Bag distance
 |
 |-sequence\_distance
 | |-longest common subsequence
 | |-longest common substring
 | |-ratcliff-obershelft


### Edit Based

|           metric              | implemented |
|:-----------------------------:|:-----------:|
|          `Hamming`            |   &#10003;  |
|          `MLIPNS`             |             |
|       `Levenshtein`           |   &#10003;  |
|    `Levenshtein_no_sub`       |   &#10003;  |
|   `Full Dameran-Levenshtein`  |   &#10003;  |
| `Partial Dameran-Levenshtein` |             |
|       `Jaro-Winkler`          |             |
|         `StrCmp95`            |             |
|      `Neddleman-Wunsh`        |             |
|          `Gothoh`             |             |
|      `Smith-Waterman`         |             |
|           `Brew`              |   &#10003;  |


### Token Based

|           metric            | implemented |
|:---------------------------:|:-----------:|
|       `Jaccard Index`       |             |
| `Sorensin-Dice coefficient` |             |
|       `Tversky Index`       |             |
|    `Overlap coefficient`    |             |
|     `Tanimoto distance`     |             |
|     `Cosine similarity`     |             |
|  `Binary Cosine Similarity` |             |
|  `tf-idf Cosine Similarity` |             |
|        `Monge-Elkan`        |             |
|        `Bag distance`       |             |

### Sequence Based

|          metric              | implemented |
|:----------------------------:|:-----------:|
| `longest common subsequence` |   &#10003;  |
|  `longest common substring`  |   &#10003;  |
|    `Ratcliff-Obershelft`     |             |
