#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

void CUDA_ERROR_EXIT(char str[]) {
    cudaError err = cudaGetLastError();
    if( err != cudaSuccess){
        char temp[] = cudaGetErrorString(err);
        printf("Cuda Error: '%s' for %s\n", temp, str);
        exit(-1);
    }
}

__global__ void add(int *a, int *b, int *c) {
    c[blockIdx.x] = a[blockIdx.x] + b[blockIdx.x];
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <integer> <integer>",argv[0]);
        exit(-1);
    }
    int N = atoi(argv[1]);
    int *ha, *hb, *hc;           //host copies of variables
    int size = N * sizeof(int);
    ha = (int *) malloc(size);
    hb = (int *) malloc(size);
    hc = (int *) malloc(size);
    random_ints(ha, N);
    random_ints(hb, N);

    int *da, *db, *dc;          //device copies of variables
    cudaMalloc(&da, size);
    cudaMalloc(&db, size);
    cudaMalloc(&dc, size);

    // Copy inputs to device
    cudaMemcpy(da, ha, size, cudaMemcpyHostToDevice);
    cudaMemcpy(db, hb, size, cudaMemcpyHostToDevice);

    // Launch add() kernel on GPU with N blocks
    add<<<N,1>>>(d_a, d_b, d_c);

    // Copy result back to host
    cudaMemcpy(&c, dc, size, cudaMemcpyDeviceToHost);
    
    free(a); free(b); free(c);
    cudaFree(da); cudaFree(db); cudaFree(dc);
    return 0;
}
