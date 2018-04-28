#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>
 
int myglobal=0;
 
 void *thread_function(void *arg) {
  int i,j;
  for ( i=0; i<4; i++ ) {
    printf(".");
    fflush(stdout);
   sleep(1);
    myglobal++;
  }
  return NULL;
}
 
int main(void) {
 
  pthread_t mythread;
  int i;
 
  if ( pthread_create( &mythread, NULL, thread_function, NULL) ) {
    printf("error creating thread.");
    abort();
  }
 
  for ( i=0; i<4; i++) {
    printf("o");
    fflush(stdout);
    sleep(1);
    myglobal=myglobal+1;
  }
 
  if ( pthread_join ( mythread, NULL ) ) {
    printf("error joining thread.");
    abort();
  }
 
  printf("\nmyglobal equals %d\n",myglobal);
 
  exit(0);
 
}