#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#define CUDA_ERROR_EXIT(str) do{\
                                cudaError err = cudaGetLastError();\
                                if( err != cudaSuccess){\
                                    printf("Cuda Error: '%s' for %s\n", cudaGetErrorString(err), str);\
                                    exit(-1);\
                                }\
                            } while(0);

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

__global__ void xorsum(int* arr, int* num) {
    int arridx = threadIdx.x + blockIdx.x * blockDim.x;
    int totalThreads = blockDim.x;

    while (totalThreads > 1) {
        int halfPoint = (totalThreads >> 1);        //divide by two
        if (threadIdx.x < halfPoint && arridx + halfPoint < *num) {
            arr[arridx] = arr[arridx] ^ arr[arridx + halfPoint];
        }
        __syncthreads();
        totalThreads = halfPoint;
    }
    __syncthreads();
    if (arridx == 0) {
        int temp = blockDim.x;
        while (temp < *num) {
            arr[arridx] = arr[arridx] ^ arr[arridx + temp];
            temp += blockDim.x;
        }
    }
}

int main(int argc, char **argv) {
    if (argc != 3) {
        printf("Usage: %s <no of elements> <seed>\n",argv[0]);
        exit(-1);
    }
    int N = atoi(argv[1]);
    if (N < 1) {
        printf("Numbers of elements has to be greater than 0\n");
        exit(-1);
    }
    int *hArr;           //host copy of the array
    int size = N * sizeof(int);
    hArr = (int *) malloc(size);
    srand(atoi(argv[2]));
    for (int i = 0; i < N; i++)
        hArr[i] = random();

    int *dArr;          //device copy of the array
    int *Num;           //device copy of the number of elements
    cudaMalloc(&dArr, size);
    cudaMalloc(&Num, sizeof(int));

    // Copy inputs to device
    cudaMemcpy(dArr, hArr, size, cudaMemcpyHostToDevice);
    cudaMemcpy(Num, &N, sizeof(int), cudaMemcpyHostToDevice);

    //define number of threads and blocks
    struct timeval start, end;
    int threadsPerBlock = 1024;
    int blocks = N / 1024 + (N % 1024 != 0);
    gettimeofday(&start, NULL);
    xorsum<<<blocks,threadsPerBlock>>>(dArr,Num);
    gettimeofday(&end, NULL);

    // Copy result back to host
    cudaMemcpy(hArr, dArr, sizeof(int), cudaMemcpyDeviceToHost);
    printf("%d\n",hArr[0]);
    printf("Processsing time = %ld microsecs\n", TDIFF(start, end));

    free(hArr);
    cudaFree(dArr);
    return 0;
}
