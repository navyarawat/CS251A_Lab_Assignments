#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void parse(int* arr, char* string) {
	int i = 0;
	int j = 0;
	int temp = 0;
	while (string[i] != '\0') {
		if (string[i] == ',') {
			arr[j] = temp;
			temp = 0;
			j++;
		}
		else {
			temp = temp*10 + string[i] - '0';
		}
		i++;
	}
	arr[j] = temp;
}

int binarysrch(int a[],int start, int end, int key){
	if (start>end)
		return -1;
	int mid = (start+end)/2;

	if (a[mid]<key)
		return binarysrch(a,mid+1,end,key);
	else if (a[mid]>key)
		return binarysrch(a,start,mid-1,key);
	return mid;
}

int main(int argc, char** argv){
	if (argc != 4) {
		printf("Not enough parameters\n");
		return 0;
	}
	int n = atoi(argv[1]);
	int k = atoi(argv[3]);
	int a[n];
	parse(a,argv[2]);

	int rank = binarysrch(a,0,n-1,k);
	rank = rank>-1?rank+1:rank;
	printf("%d\n", rank);
	return 0;
}
