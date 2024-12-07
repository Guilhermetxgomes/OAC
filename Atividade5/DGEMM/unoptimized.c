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

    // Inicializa matrizes
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            A[i + j * n] = i + j + 1;
            B[i + j * n] = (i + 1) * (j + 1);
            C[i + j * n] = 0.0;
        }
    }

    // Medição do tempo
    clock_t start = clock();
    dgemm(n, A, B, C);
    clock_t end = clock();

    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;

    printf("Tempo de execução para matriz %dx%d: %.6f segundos\n", n, n, time_spent);

    free(A);
    free(B);
    free(C);
}

int main() {
    int dimensions[] = {32};
    int num_tests = sizeof(dimensions) / sizeof(dimensions[0]);

    for (int i = 0; i < num_tests; ++i) {
        run_test(dimensions[i]);
    }

    return 0;
}
