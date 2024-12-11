import time

def dgemm(n, A, B, C):
    for i in range(n):
        for j in range(n):
            for k in range(n):
                C[i][j] += A[i][k] * B[k][j]

def run_test(n, output_file):
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
    print(f"GFLOPS para matriz {n}x{n}: {gflops:.6f}")

    # Escreve os resultados no arquivo de saída
    with open(output_file, "a") as f:
        f.write(f"Tempo de execução para matriz {n}x{n}: {time_spent:.6f} segundos\n")
        f.write(f"GFLOPS para matriz {n}x{n}: {gflops:.6f} gflops\n")

def main():
    # Nome do programa para salvar os resultados
    program_name = "programa1"
    output_file = f"{program_name}_resultados5.txt"
    
    # Limpa o conteúdo do arquivo antes de começar
    open(output_file, "w").close()

    dimensions = [64, 320, 480, 960]
    for dim in dimensions:
        run_test(dim, output_file)

if __name__ == "__main__":
    main()
