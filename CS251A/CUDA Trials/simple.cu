#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define NUM 32

void CUDA_ERROR_EXIT(char str[]) {
    cudaError err = cudaGetLastError();
    if( err != cudaSuccess){
        char temp[] = cudaGetErrorString(err);
        printf("Cuda Error: '%s' for %s\n", temp, str);
        exit(-1);
    }
}

__global__ void D_Mul(int *dA, int *dB, int *dC) {
      int i = threadIdx.x;
      //int i = blockIdx.x * blockDim.x + threadIdx.x;
      dC[i] = dA[i] * dB[i];
}

int main (int argc, char **argv) {
    int size = NUM * sizeof(int);
    int* hA = (int *) malloc(size);
    int* hB = (int *) malloc(size);
    int* hC = (int *) malloc(size);

    if (!hA || !hB || !hC) {
        perror("malloc");
        exit(-1);
    }

    for(int ctr = 0; ctr < NUM; ++ctr)
        hA[ctr] = hB[ctr] = ctr + 1;        //apparently, this works

    //Allocate memory on the device (GPU)
    int *dA, *dB, *dC;
    cudaMalloc(&dA,  size);
    CUDA_ERROR_EXIT("cudaMalloc");
    cudaMalloc(&dB,  size);
    CUDA_ERROR_EXIT("cudaMalloc");
    cudaMalloc(&dC,  size);
    CUDA_ERROR_EXIT("cudaMalloc");

    //Copy hA --> dA and hB --> dB
    cudaMemcpy(dA, hA, size, cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("memcpy1");
    cudaMemcpy(dB, hB, size, cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("memcpy1");

    //Invoke the kernel
    D_Mul<<<1, NUM>>>(dA, dB, dC);
    //int blocks = (NUM + 1023) >> 10;
    //D_Mul<<<blocks, 1024>>>(dA, dB, dC);
    CUDA_ERROR_EXIT("kernel invocation");
    printf("kernel successful\n");

    //Copy back results
    cudaMemcpy(hC, dC, size, cudaMemcpyDeviceToHost);
    CUDA_ERROR_EXIT("memcpy");
    for(int ctr = 0; ctr < NUM; ++ctr)
        printf("%d %d %d\n", hA[ctr], hB[ctr], hC[ctr]);

    free(hA); free(hB); free(hC);
    cudaFree(dA); cudaFree(dB); cudaFree(dC);
    return 0;
}
