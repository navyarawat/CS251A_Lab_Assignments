#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <sys/time.h>
#include <math.h>
#include <strings.h>

#define usage_exit(s) do { \
							printf("Usage: %s\n%s\n", argv[0], s); \
                            exit(-1); \
						} while(0);

#define TDIFF(start, end) ((end.tv_sec - start.tv_sec) * 1000000UL + (end.tv_usec - start.tv_usec))

typedef struct THREAD_param {
	pthread_t tid;
	int* array;
	int size;
	int skip;
	int thread_ctr; 
	int max_index;
} thread_param;

int isprime(int a){
	if (a == 2 || a == 3)
		return 1;
	if (a % 2 == 0 || a % 3 == 0)
		return 0;
	int x = sqrt(a);
	int i = 0;
	for (i = 5; i <= x; i++){
		if (a % i == 0)
			break;
	}
	if (i <= x)
		return 0;
	return 1;
}

void* findmaxprime(void* arg) {
	thread_param* p = (thread_param*) arg;
	int ctr = p->thread_ctr;

	p->max_index = -1;

	while(ctr < p->size){
		int x = isprime(p->array[ctr]);
		if(x && ( p->max_index == -1 || p->array[ctr] > p->array[p->max_index])){
			p->max_index = ctr;
		}
		ctr += p->skip;
	}          
	return NULL;
}

int main(int argc, char** argv){
	//check the no of arguments
	if (argc != 3){
		usage_exit("Not enough Arguments");
	}

	//check whether the inputs are correct.
	int n = atoi(argv[1]);				//n = number of elements
	int threadcount = atoi(argv[2]);	//no of threads, obviously
	if (n < 1)
		usage_exit("Invalid number of elements");
	if (threadcount < 1)
		usage_exit("Invalid number of threads");

	//define the random array using malloc. array will be freed later.
	int* arr;
	arr = (int*) malloc(sizeof(int)*n);
	if (!arr)	//will arr will remain NULL if malloced space is too large?
		usage_exit("Not enough memory");
	for(int i = 0; i < n; i++){
		arr[i] = rand();
	}

	//some more initialising variables
	thread_param* p = malloc(sizeof(thread_param)*threadcount);	//array of threads
	struct timeval start, end;
	int counter, max, maxidx;

	//set all bits pointed by the array to zero
	bzero(p, threadcount*sizeof(thread_param));

	gettimeofday(&start, NULL);	//still no idea what this command exactly does

	//divede the work into the threads as follows:
	//thread zero checks the indices 0,n,2n,3n....
	//thread one checks the indices 1,n+1,2n+1,3n+1.... and so on.
	for(int i = 0; i < threadcount; i++){
		thread_param* param = p + i;		//param = p[i];
		param->size = n;					//size of the array
        param->skip = threadcount;			//how many indices to skip
        param->array = arr;					//the array to work upon
        param->thread_ctr = i;				//the index to start from

        //set all the threads to work
        if(pthread_create(&param->tid, NULL, findmaxprime, param) != 0){
			perror("pthread_create");
			exit(-1);
        }
	}

	//compare the results of the threads
	max = 0;
	for(int i = 0; i < threadcount; i++){
        thread_param *param = p + i;
        pthread_join(param->tid, NULL);
        if(i == 0 || (i > 0 && arr[param->max_index] > max)){
			max = arr[param->max_index];
        }
	}

	printf("Max = %d\n", max);
	gettimeofday(&end, NULL);
	printf("Time taken = %ld microsecs\n", TDIFF(start, end));
	free(arr);
	free(p);
	return 0;
}
