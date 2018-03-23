import numpy as np


def del_cost(c):
    return 1


def ins_cost(c):
    return 1


def sub_cost(c1, c2):
    if c1 == c2:
        return 0
    return 1


def sub_cost_2(c1, c2):
    if c1 == c2:
        return 0
    return 2


def distance(
        source, target, *,
        insert_cost=ins_cost,
        delete_cost=del_cost,
        substitution_cost=sub_cost
):
    n = len(source)
    m = len(target)
    table = np.zeros((n + 1, m + 1), dtype=np.int32)

    table[0, 0] = 0
    for i in range(1, n + 1):
        table[i, 0] = table[i - 1, 0] + del_cost(source[i - 1])
    for j in range(1, m + 1):
        table[0, j] = table[0, j - 1] + ins_cost(target[j - 1])

    for i in range(1, n + 1):
        for j in range(1, m + 1):
            sub_cost_ = 1
            if source[i - 1] == target[j - 1]:
                sub_cost_ = 0
            table[i, j] = min(
                # table[i - 1, j] + delete_cost(source[i - 1]),
                # table[i, j - 1] + insert_cost(target[j - 1]),
                # table[i - 1, j - 1] + substitution_cost(source[i - 1], target[j - 1])
                table[i - 1, j] + 1,
                table[i, j - 1] + 1,
                table[i - 1, j - 1] + sub_cost_
            )

    # top = np.array(list("#" + target))
    # top = np.reshape(top, [1, -1])
    # table = np.concatenate([top, table], axis=0)
    # side = np.array(list(" #" + source))
    # side = np.reshape(side, [-1, 1])
    # table = np.concatenate([side, table], axis=1)
    # print(table)

    return table[n, m]


def diag_dist(
        source, target,
        insert_cost=ins_cost,
        delete_cost=del_cost,
        substitution_cost=sub_cost
):
    n = len(source)
    m = len(target)
    table = np.zeros((n + 1, m + 1), dtype=np.int32)

    rows = n + 1
    cols = m + 1
    diags = rows + cols
    for diag in range(1, diags):
        start_col = max(0, diag - rows)
        diag_size = min(diag, (cols - start_col), rows)
        for k in range(diag_size):
            i = min(rows, diag) - k - 1
            j = start_col + k
            if i == 0 and j == 0:
                continue
            elif i == 0:
                table[i, j] = table[i, j - 1] + 1
            elif j == 0:
                table[i, j] = table[i - 1, j] + 1
            else:
                table[i, j] = 3
        print(table)
    return table[n, m]


def levenshtein(source, target):
    return distance(
        source, target,
        insert_cost=ins_cost,
        delete_cost=del_cost,
        substitution_cost=sub_cost
    )


def levenshtein_no_sub(source, target):
    return distance(
        source, target,
        insert_cost=ins_cost,
        delete_cost=del_cost,
        substitution_cost=sub_cost_2
    )


if __name__ == "__main__":
    print(diag_dist("iiiii", "ooooooooo"))
