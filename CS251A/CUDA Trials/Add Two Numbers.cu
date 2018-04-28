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
    *c = *a + *b;
}

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Usage: %s <integer> <integer>",argv[0]);
        exit(-1);
    }
    int ha, hb, hc;           //host copies of variables
    ha = atoi(argv[1]);
    hb = atoi(argv[2]);

    int size = sizeof(int);
    int *da, *db, *dc;          //device copies of variables
    cudaMalloc(&da, size);
    cudaMalloc(&db, size);
    cudaMalloc(&dc, size);

    // Copy inputs to device
    cudaMemcpy(da, &ha, size, cudaMemcpyHostToDevice);
    cudaMemcpy(db, &hb, size, cudaMemcpyHostToDevice);

    add<<<1,1>>>(da, db, dc);

    // Copy result back to host
    cudaMemcpy(&hc, dc, size, cudaMemcpyDeviceToHost);

    cudaFree(da); cudaFree(db); cudaFree(dc);
    return 0;
}
