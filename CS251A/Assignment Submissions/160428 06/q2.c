#include <stdio.h>
#include <stdlib.h>
#include<pthread.h>

typedef struct Account {
   int number;
   double balance;
   int flag;   //flag is 1 if this account is in use.
} acc;

typedef struct Transaction {
   int type;
   double amount;
   int account1;
   int account2;
} txn;

pthread_mutex_t lock;
acc* accounts;
txn* transactions;
int curr = 0;

void executetxn(acc* acc1, acc* acc2, txn t){
   acc a1 = *acc1;
   acc a2 = *acc2;
   if (t.type == 1){
      double temp = 0.99*t.amount;
      a1.balance += temp;
   }
   else if (t.type == 2){
      double temp = 1.01*t.amount;
      a1.balance -= temp;
   }
   else if (t.type == 3){
      a1.balance *= 1.071;
   }
   else {
      double temp = 0.01*t.amount;
      a1.balance -= (t.amount + temp);
      a2.balance += (t.amount - temp);
   }
   *acc1 = a1;
   *acc2 = a2;
}

void* updateaccounts(void* arg){
   int n = *((int* ) arg);
   while (1) {
      pthread_mutex_lock(&lock);
      if (curr >= n) {
         pthread_mutex_unlock(&lock);
         break;
      }
      txn t = transactions[curr];
      acc a1 = accounts[t.account1-1001];
      acc a2 = a1;
      if (t.account2 != 0)
         a2 = accounts[t.account2-1001];
      if (a1.flag == 1 || a2.flag == 1){
         pthread_mutex_unlock(&lock);
         continue;
      }
      accounts[t.account1-1001].flag = 1;
      if (t.account2 != 0)
         accounts[t.account2-1001].flag = 1;
      curr++;
      pthread_mutex_unlock(&lock);
      executetxn(&a1,&a2,t);
      pthread_mutex_lock(&lock);
      accounts[t.account1-1001] = a1;
      if (t.account2 != 0)
         accounts[t.account2-1001] = a2;
      accounts[t.account1-1001].flag = 0;
      if (t.account2 != 0)
         accounts[t.account2-1001].flag = 0;
      pthread_mutex_unlock(&lock);
   }
   return NULL;
}

int main (int argc, char **argv){
   if(argc != 5) {
      printf("Usage: %s <file1> <file2> <no of transactions> <no of threads>\n", argv[0]);
      exit(-1);
   }

   accounts = (acc*) malloc(sizeof(acc)*10000);
   FILE* file = fopen(argv[1],"r");
   int line = 0;
   if (file != NULL){
      int a = fscanf(file, "%d %lf", &accounts->number, &accounts->balance);
      while(a != EOF){
         line++;
         a = fscanf(file, "%d %lf", &(accounts+line)->number, &(accounts+line)->balance);
      }
      fclose(file);
   }
   else {
      perror(argv[1]);
   }

   transactions = (txn*) malloc(sizeof(txn)*atoi(argv[3]));
   FILE* file2 = fopen(argv[2],"r");
   int count2 = 0;
   int num;
   if (file2 != NULL){
      int a = fscanf(file2, "%d %d %lf %d %d",&num, &(transactions->type), &(transactions->amount), &(transactions->account1), &(transactions->account2));
      while(a != EOF){
         count2++;
         a = fscanf(file, "%d %d %lf %d %d", &num, &(transactions[count2].type), &(transactions[count2].amount), &(transactions[count2].account1), &(transactions[count2].account2));
      }
      fclose(file2);
   }
   else {
      perror(argv[2]);
   }
   int txncount = atoi(argv[3]);
   int threadcount = atoi(argv[4]);
   pthread_t threads[threadcount];
   pthread_mutex_init(&lock, NULL);

   for (int i = 0; i < threadcount; i++){
      if(pthread_create(&threads[i], NULL, updateaccounts, &txncount) != 0){
         perror("pthread_create");
         exit(-1);
      }
   }

   for(int i = 0; i < threadcount; i++)
      pthread_join(threads[i], NULL);

   printf("Acc\tBalance         Balance (Rounded off)\n");
   for(int i = 0; i < 10000; i++)
      printf("%d\t%lf\t%.2lf\n", accounts[i].number, accounts[i].balance, accounts[i].balance);
   return 0;
}
