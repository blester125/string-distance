import numpy as np


def iterate_diag(matrix):
    rows, cols = matrix.shape
    diags = rows + cols
    for diag in range(1, diags):
        start_col = max(0, diag - rows)
        diag_size = min(diag, (cols - start_col), rows)
        for j in range(diag_size):
            matrix[min(rows, diag) - j - 1, start_col + j] = 1
        print(matrix)


if __name__ == "__main__":
    mat = np.zeros((5, 9))
    iterate_diag(mat)
