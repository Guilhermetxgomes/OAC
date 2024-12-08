import time

def dgemm(n, A, B, C):
    for i in range(n):
        for j in range(n):
            for k in range(n):
                C[i][j] += A[i][k] * B[k][j]

def run_test(n):
    print(f"\nExecutando DGEMM para matriz {n}x{n}...")

    A = [[i + j + 1 for j in range(n)] for i in range(n)]
    B = [[(i + 1) * (j + 1) for j in range(n)] for i in range(n)]
    C = [[0.0 for _ in range(n)] for _ in range(n)]

    start = time.time()
    dgemm(n, A, B, C)
    end = time.time()

    time_spent = end - start
    gflops = 2 * n ** 3 / time_spent / 1e9
    print(f"Tempo de execução para matriz {n}x{n}: {time_spent:.6f} segundos")
    print(f"GFLOPS: {gflops:.6f}")

def main():
    dimensions = [32, 64, 320, 960]
    for dim in dimensions:
        run_test(dim)

if __name__ == "__main__":
    main()
