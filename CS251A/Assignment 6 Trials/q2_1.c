#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>

char* readfile(char* fileneme, int* fdptr, unsigned long* sizeptr, unsigned long* bytesptr){
	int fd = open(fileneme, O_RDONLY);
	if(fd < 0){
		printf("Can not open file\n");
		exit(-1);
	}
	*fdptr = fd;

	//seek the reading point till the end to get the size of the file
	unsigned long size = lseek(fd, 0, SEEK_END);
    if(size <= 0){
		perror("lseek");
		exit(-1);
    }
    *sizeptr = size;

    //seek the reading point back to the start by using SEEK_SET
    if(lseek(fd, 0, SEEK_SET) != 0){
		perror("lseek");
		exit(-1);
    }

    //array to store contents of the file as a string
    char* buffer = malloc(size);
    if(!buffer){
		perror("mem");
		exit(-1);
    }
	unsigned long bytes = read(fd, buffer, size);
	*bytesptr = bytes;
	return buffer;
}

int main(int argc, char** argv) {
	if(argc != 3) {
		printf("Usage: %s <fileneme1> <fileneme2>\n", argv[0]);
		exit(-1);
	}
	int fd1,fd2;					//file destinations for the files
	unsigned long size1,size2;		//sizes of the files
	char *buffer1, *buffer2;		//the strings in which the data will be poured
	unsigned long bytes1,bytes2;	//bytes read by the read() function

	buffer1 = readfile(argv[1],&fd1,&size1,&bytes1);
	buffer2 = readfile(argv[2],&fd2,&size2,&bytes2);

	return 0;
}