#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
 
void *thread_function(void *arg) {
	int i;
	for ( i=0; i<5; i++ ) {
		printf("Thread says hi!\n");
    	sleep(1);
	}
	return NULL;
}

int main(void) { 
	pthread_t mythread;
   
	if ( pthread_create( &mythread, NULL, thread_function, NULL) ) {
		printf("error creating thread.");
		abort();
	}
	printf("Testing....\n");
	sleep(1);
	printf("Testing....\n");
	
	if ( pthread_join ( mythread, NULL ) ) {
		printf("error joining thread.");
		abort();
	}
	printf("Merged\n");
	exit(0);
}