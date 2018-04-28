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
    if (arridx < *num/2)
        arr[arridx] = arr[arridx] ^ arr[arridx + *num/2 + (*num % 2)];
}

__global__ void updatenum(int* num) {
    *num = (*num)/2 + (*num % 2);
}

int debug(int* arr, int num) {
    int sum = 0;
    for (int i = 0; i < num ; i++) {
        sum = sum ^ arr[i];
    }
    return sum;
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
    /*
    struct timeval seqstart, seqend;
    gettimeofday(&seqstart, NULL);
    printf("%d\n",debug(hArr,N));
    gettimeofday(&seqend, NULL);
    printf("Sequential Processsing time = %ld microsecs\n", TDIFF(seqstart, seqend));
    */

    int *dArr;          //device copy of the array
    int *Num;           //device copy of the number of elements
    cudaMalloc(&dArr, size);
    cudaMalloc(&Num, sizeof(int));
    CUDA_ERROR_EXIT("cudaMalloc");

    // Copy inputs to device
    cudaMemcpy(dArr, hArr, size, cudaMemcpyHostToDevice);
    cudaMemcpy(Num, &N, sizeof(int), cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("cudaMemcopy");

    //define number of threads and blocks
    struct timeval start, end;
    int threadsPerBlock, blocks;
    gettimeofday(&start, NULL);
    int temp = N;
    printf("Starting...\n");
    while (temp > 1) {
        threadsPerBlock = 1024;
        blocks = temp / 1024 + (temp % 1024 != 0);
        xorsum<<<blocks,threadsPerBlock>>>(dArr,Num);
        updatenum<<<1,1>>>(Num);
        CUDA_ERROR_EXIT("kernel invocation");
        temp = temp/2 + (temp % 2);
    }
    printf("Calculated...\nPrinting result...\n");
    gettimeofday(&end, NULL);

    // Copy result back to host
    int result;
    cudaMemcpy(&result, dArr, sizeof(int), cudaMemcpyDeviceToHost);
    CUDA_ERROR_EXIT("cudaMemcopy");
    printf("%d\n",result);
    printf("GPU Processsing time = %ld microsecs\n", TDIFF(start, end));

    free(hArr);
    cudaFree(dArr);
    return 0;
}
