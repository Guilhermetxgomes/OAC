#include <stdio.h>
#include <stdlib.h>

void dgemm (int n, double* A, double* B, double* C) {
    for (int i = 0; i < n; ++i)
        for (int j = 0; j < n; ++j) {
            double cij = C[i+j*n]; /* cij = C[i][j] */
            
            for( int k = 0; k < n; k++ )
                cij += A[i+k*n] * B[k+j*n]; /* cij += A[i][k]*B[k][j] */
            
            C[i+j*n] = cij; /* C[i][j] = cij */
        }
    }

int main() {
    int n = 3; // Tamanho das matrizes (3x3)
    
    double* A = (double*)malloc(n * n * sizeof(double));
    double* B = (double*)malloc(n * n * sizeof(double));
    double* C = (double*)malloc(n * n * sizeof(double));

    // Inicializando as matrizes A e B com valores, e C com zeros
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            A[i + j * n] = i + j + 1;    // A[i][j] = i + j + 1
            B[i + j * n] = (i + 1) * (j + 1);    // B[i][j] = (i+1) * (j+1)
            C[i + j * n] = 0.0;         // Inicializa C com zeros
        }
    }

    dgemm(n, A, B, C);

    printf("Matriz C (resultado de A * B):\n");
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            printf("%6.2f ", C[i + j * n]); // C[i][j]
        }
        printf("\n");
    }

    free(A);
    free(B);
    free(C);

    return 0;
}