#include <time.h>
#include <stdio.h>
#include <stdlib.h>

#define BLOCKSIZE 32

void do_block (int n, int si, int sj, int sk, double *A, double *B, double *C) {
    for (int i = si; i < si+BLOCKSIZE; ++i)
        for (int j = sj; j < sj+BLOCKSIZE; ++j) {
            double cij = C[i+j*n];
            for (int k = sk; k < sk+BLOCKSIZE; k++)
                cij += A[i+k*n] * B[k+j*n];
            C[i+j*n] = cij;
        }
}

void dgemm (int n, double* A, double* B, double* C) {
    for (int sj = 0; sj < n; sj += BLOCKSIZE)
        for (int si = 0; si < n; si += BLOCKSIZE)
            for (int sk = 0; sk < n; sk += BLOCKSIZE)
                do_block(n, si, sj, sk, A, B, C);
}

void run_test(int n) {
    printf("\nExecutando DGEMM para matriz %dx%d (Cache Blocking)...\n", n, n);

    double* A = (double*)aligned_alloc(32, n * n * sizeof(double));
    double* B = (double*)aligned_alloc(32, n * n * sizeof(double));
    double* C = (double*)aligned_alloc(32, n * n * sizeof(double));

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
    printf("Tempo de execução para matriz %dx%d: %.6f segundos\n", n, n, time_spent);

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
