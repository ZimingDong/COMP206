//Ziming Dong
//260951177
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
void errorMsg(char *msg,char *file){
	if(file==NULL){
		printf("%s\n",msg);
	}else{
		printf("Unable to open filname %s\n",file);
	}
	printf("./tv STATE TRANSACTIONS\n");
	printf("./tv state.csv transaction.csv\n");
	printf("./tv ../state.csv /data/log/transaction.csv\n");
}

struct ACCOUNT {
	int accountNumber;
	double startingBalance;
	double endingBalance;
	struct ACCOUNT *next;
};
void* printA(struct ACCOUNT* head){
        struct ACCOUNT* temp = head;
        while(temp!=NULL){
                printf("account   %d\n%.2f\n%.2f\n",temp->accountNumber,temp->startingBalance,temp->endingBalance);
                temp=temp->next;
        }
}


struct ACCOUNT* insert(struct ACCOUNT* head,struct ACCOUNT* record){
	if(head==NULL){
		record->next=NULL;
		return record;
	}
	
	if(head->accountNumber > record->accountNumber){
		record->next = head;
		head = record;
		return head;
	}
	else if(head->accountNumber == record->accountNumber){
		printf("Duplicate account number [account, start, end] : %06d %.2f %.2f\n",head->accountNumber,head->startingBalance,head->endingBalance);
	}
	else{
		struct ACCOUNT* temp = head;
		for(temp;temp!=NULL;temp=temp->next){
			if(temp->next==NULL){
				record->next=NULL;
				temp->next=record;
				return head;
			}
			if(temp->next->accountNumber == record->accountNumber){
				 printf("Duplicate account number [account, start, end] : %06d %.2f %.2f\n",temp->next->accountNumber,temp->next->startingBalance,temp->next->endingBalance);
				 return head;
			}else if(temp->next!=NULL&&temp->next->accountNumber>record->accountNumber){
				record->next=temp->next;
				temp->next=record;
				return head;
			}

		}
	}
	return head;
}
struct ACCOUNT* readF(FILE* inputF){
	char line[1024] = "";
	struct ACCOUNT* head = NULL;
	fgets(line,1024,inputF);
	while(fgets(line,1024,inputF)!= NULL){
		struct ACCOUNT* record = malloc(sizeof(struct ACCOUNT));
		if(record==NULL){
			exit(1);
		}
		record->next = NULL;
		sscanf(line,"%d,%lf,%lf",&(record->accountNumber),&(record->startingBalance),&(record->endingBalance));
		if(record->accountNumber==0){
			continue;
		}
		head = insert(head,record);
	}
	return head;
}
struct ACCOUNT* cal(struct ACCOUNT* head,int num,char mod,float money){
	struct ACCOUNT* temp = head;
	float beforeS;
	for(temp;temp!=NULL;temp=temp->next){
		if(temp->next==NULL){
			printf("Account not found (account, mode, amount): %d %c %.2f\n",num,mod,money);
			break;
		}

		if(temp->accountNumber==num){
			if(mod=='d'){
				temp->startingBalance+=money;
			}
			if(mod=='w'){
				beforeS = temp->startingBalance;
				temp->startingBalance-=money;
				if(temp->startingBalance<0){
					printf("Balance below zero error (amount, mode, transaction, startingBalance before): %d %c %.2f %.2f\n",num,mod,money,beforeS);
				}
			}
			break;
		}
	}
	return head;
}
struct ACCOUNT* scanF(FILE* inputF,struct ACCOUNT* head){
	char line[1024] = "";
	int num;
	char mod;
	float money;
	fgets(line,1024,inputF);
	while(fgets(line,1024,inputF)!= NULL){
		sscanf(line,"%d,%c,%f",&num,&mod,&money);
		if(num==-1){
			continue;
		}
		head = cal(head,num,mod,money);
		num=-1;
	}
	return head;
}
void* check(struct ACCOUNT* head){
	struct ACCOUNT* temp=head;
	while(temp!=NULL){
		if(fabs(temp->startingBalance-temp->endingBalance)>1e-6){
			printf("End of day balances do not agree (account, starting, ending): %06d %.2f %.2f\n",temp->accountNumber,temp->startingBalance,temp->endingBalance);
		}
		temp = temp->next;
	}
}
void* freeNode(struct ACCOUNT* head){
	struct ACCOUNT* temp=head;
	while(head!=NULL){
		temp=head;
		head=head->next;
		free(temp);
	}
}

int main(int argc, char *argv[] ){
	FILE *f1;
	FILE *f2;
	char c1;
	char c2;
	struct ACCOUNT* head;
	if(argc!=3){
		errorMsg("Wrong number of arguments!",NULL);
		exit (1);
	}
	f1=fopen(argv[1],"r");
	f2=fopen(argv[2],"r");
	if(f1==NULL){
		errorMsg("Unable to open filname %s",argv[1]);
		exit (2);
	}
 	if(f2==NULL){
                errorMsg("Unable to open filname %s",argv[2]);
                exit (2);
        }
	c1=getc(f1);
	c2=getc(f2);
	if(c1<33&&c2>=33){
		printf("File state.csv is empty. Unable to validate transaction.csv.");
		exit(3);
	}
	head = readF(f1);
	fclose(f1);
	head = scanF(f2,head);
	fclose(f2);  
	check(head);
	freeNode(head);
}
