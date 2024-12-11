#include <time.h>
#include <stdio.h>
#include <stdlib.h>

void dgemm (int n, double* A, double* B, double* C) {
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j) {
            double cij = C[i+j*n];
            for (int k = 0; k < n; k++)
                cij += A[i+k*n] * B[k+j*n];
            C[i+j*n] = cij;
        }
}

void run_test(int n) {
    printf("\nExecutando DGEMM para matriz %dx%d...\n", n, n);

    double* A = (double*)malloc(n * n * sizeof(double));
    double* B = (double*)malloc(n * n * sizeof(double));
    double* C = (double*)malloc(n * n * sizeof(double));

    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            A[i + j * n] = i + j + 1;
            B[i + j * n] = (i + 1) * (j + 1);
            C[i + j * n] = 0.0;
        }
    }

    clock_t start = clock();
    dgemm(n, A, B, C);
    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    double gflops = 2.0 * n * n * n / time_spent / 1e9;

        // Abrir o arquivo para escrita
    FILE* file = fopen("programa2_resultados5.txt", "a"); // "a" para adicionar no final do arquivo
    if (file == NULL) {
        perror("Erro ao abrir o arquivo");
        exit(EXIT_FAILURE);
    }

    // Escrever no arquivo
    fprintf(file, "Tempo de execução para matriz %dx%d: %.6f segundos\n", n, n, time_spent);
    fprintf(file, "GFLOPS para matriz %dx%d: %.6f gflops\n", n, n, gflops);

    // Fechar o arquivo
    fclose(file);


    free(A);
    free(B);
    free(C);
}

int main() {
    int dimensions[] = {64, 320, 480, 960};
    int num_tests = sizeof(dimensions) / sizeof(dimensions[0]);
    

    for (int i = 0; i < num_tests; ++i) {
        run_test(dimensions[i]);
    }

    return 0;
}
