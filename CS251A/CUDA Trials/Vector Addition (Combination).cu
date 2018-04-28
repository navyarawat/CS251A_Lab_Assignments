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

__global__ void add(int *a, int *b, int *c, int *N) {
    int i = threadIdx.x + blockIdx.x * blockDim.x;
    if ( i >= *N)
        return;
    c[i] = a[i] + b[i];
}

int main(int argc, char **argv) {
    if (argc != 2) {
        printf("Usage: %s <integer>",argv[0]);
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
    int *Num;
    cudaMalloc(&da, size);
    cudaMalloc(&db, size);
    cudaMalloc(&dc, size);

    // Copy inputs to device
    cudaMemcpy(da, ha, size, cudaMemcpyHostToDevice);
    cudaMemcpy(db, hb, size, cudaMemcpyHostToDevice);
    cudaMemcpy(Num, N, sizeof(int), cudaMemcpyHostToDevice);

    //define number of threads and blocks
    int threadsPerBlock = 512;
    int blocks = N / 512 + (N % 512 != 0);
    add<<<blocks,threadsPerBlock>>>(d_a, d_b, d_c, Num);

    // Copy result back to host
    cudaMemcpy(hc, dc, size, cudaMemcpyDeviceToHost);

    free(ha); free(hb); free(hc);
    cudaFree(da); cudaFree(db); cudaFree(dc);
    return 0;
}
