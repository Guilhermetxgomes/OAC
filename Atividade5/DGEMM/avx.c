#include <x86intrin.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

void dgemm (int n, double* A, double* B, double* C) {
    for ( int i = 0; i < n; i+=4 )
        for ( int j = 0; j < n; j++ ) {
            __m256d c0 = _mm256_load_pd(C+i+j*n);
            for( int k = 0; k < n; k++ )
                c0 = _mm256_add_pd(c0,
                    _mm256_mul_pd(_mm256_load_pd(A+i+k*n),
                                  _mm256_broadcast_sd(B+k+j*n)));
            _mm256_store_pd(C+i+j*n, c0);
        }
}

void run_test(int n) {
    printf("\nExecutando DGEMM para matriz %dx%d...\n", n, n);

    double* A = (double*)aligned_alloc(32, n * n * sizeof(double));
    double* B = (double*)aligned_alloc(32, n * n * sizeof(double));
    double* C = (double*)aligned_alloc(32, n * n * sizeof(double));

    // Inicializa matrizes
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

    printf("Tempo de execução para matriz %dx%d: %.6f segundos\n", n, n, time_spent);
    printf("GFLOPS para matriz %dx%d: %.6f gflops\n", n, n, gflops);

    free(A);
    free(B);
    free(C);
}

int main() {
    int dimensions[] = {32, 64, 160, 320, 480, 960, 4096};
    int num_tests = sizeof(dimensions) / sizeof(dimensions[0]);

    for (int i = 0; i < num_tests; ++i) {
        run_test(dimensions[i]);
    }

    return 0;
}
