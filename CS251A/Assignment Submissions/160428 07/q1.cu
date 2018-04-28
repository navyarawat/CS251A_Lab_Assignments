#include<stdio.h>
#include<stdlib.h>
#include<sys/time.h>

#define NUM 10000000        //ten million

#define CUDA_ERROR_EXIT(str) do{\
                                cudaError err = cudaGetLastError();\
                                if( err != cudaSuccess){\
                                    printf("Cuda Error: '%s' for %s\n", cudaGetErrorString(err), str);\
                                    exit(-1);\
                                }\
                            } while(0);
#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

struct num_array{
    double num1;
    double num2;
    double result;
};

__device__ void function(struct num_array *a) {
    double square = a ->num1 * a->num1 +  a->num2 * a->num2  + 2 * a->num1 * a->num2;
    a->result = log(square)/sin(square);
    return;
}

__global__ void calculate(char *mem, int num){
    int t = threadIdx.x + (blockDim.x * threadIdx.y) + (blockDim.x * blockDim.y * blockIdx.x);
    if(t >= num)
        return;
    struct num_array *a = (struct num_array *)(mem + (t * 3 * sizeof(double)));
    function(a);
}

int main(int argc, char **argv) {
    if (argc != 4){
        printf("Usage: %s <no of elements> <rows> <cols>\n",argv[0]);
        exit(-1);
    }
    if (atoi(argv[2]) * atoi(argv[3]) > 1024) {
        printf("<rows> * <cols> should be leq 1024\n");
        exit(-1);
    }
    struct timeval start, end, t_start, t_end;

    unsigned long num = atoi(argv[1]);
    if (num < 1){
        num = NUM;          //NUM defined as a MACRO
    }

    char* ptr = (char*) malloc(num * 3 * sizeof(double));
    char* curr = ptr;
    struct num_array* temp;
    for (int i = 0; i < num; i++){
        temp = (struct num_array*) curr;
        temp->num1 = i + i * 0.1;
        temp->num2 = temp->num1 + 1.0;
        curr += 3 * sizeof(double);
    }           //ptr becomes an undercover array of num_arrays
                //whose result part is yet to be calculated

    char* gpu_mem;      //contents of ptr will be copied over to gpu_mem
    gettimeofday(&t_start, NULL);
    // Allocate GPU memory and copy from CPU --> GPU
    cudaMalloc(&gpu_mem, num * 3 * sizeof(double));
    CUDA_ERROR_EXIT("cudaMalloc");
    cudaMemcpy(gpu_mem, ptr, num * 3 * sizeof(double) , cudaMemcpyHostToDevice);
    CUDA_ERROR_EXIT("cudaMemcpy");

    gettimeofday(&start, NULL);
    int x = atoi(argv[2]), y = atoi(argv[3]);
    dim3 threadsPerBlock(x, y);
    int numBlocks = num/(x * y) + (num % (x * y) != 0);
    calculate<<<numBlocks, threadsPerBlock>>>(gpu_mem, num);
    CUDA_ERROR_EXIT("kernel invocation");
    gettimeofday(&end, NULL);

    // Copy back results
    cudaMemcpy(ptr, gpu_mem, num * 3 * sizeof(double) , cudaMemcpyDeviceToHost);
    CUDA_ERROR_EXIT("memcpy");
    gettimeofday(&t_end, NULL);

    printf("Total time = %ld microsecs Processsing = %ld microsecs\n", TDIFF(t_start, t_end), TDIFF(start, end));
    cudaFree(gpu_mem);

    //print last element for sanity check
    temp = (struct num_array *) (ptr + (num - 1) * 3 * sizeof(double));
    printf("num1=%f num2=%f result=%f\n", temp->num1, temp->num2, temp->result);
    free(ptr);
}
