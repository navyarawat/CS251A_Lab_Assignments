/*//no idea why such a complicated procedure is used
    char* currbuff;
    unsigned long bytesread = 0;
    int count = 0;			//to check how many times the loop is executed
    do {
		unsigned long bytes;
		currbuff = buffer + bytesread;
		bytes = read(fd1, currbuff, size - bytesread);
		bytesread += bytes;
		count++;
	} while(size != bytesread);
	printf("%d\n", count);	//it is executed once -_-
	printf("%s\n", buffer);*/