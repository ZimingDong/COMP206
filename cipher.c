// Ziming Dong
// 260951177
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char inputData[500];
char matrix[500][500];
void errorMsg(char *msg){
	printf("%s\n",msg);
	printf("./cipher SWITCH KEY LENGTH < FILENAME\n");
	printf("./cipher -e 10 100 < filename.txt\n");
	printf("./cipher -d 10 200 < filename.e\n");
	exit (1);
}
void encrypt(int key, int length){
	char matrix[500][500];
	int row=length/key;
	int pos;
	for(int a=0;a<row+1;a++){
		for(int b=0;b<key;b++){
			pos=a*key+b;
			if(pos>=length){
				break;
			}
			matrix[a][b]=inputData[pos];
		}
	}
	int count=0;
	for(int i=0;i<key;i++){
		for(int j=0;j<row+1;j++){
			count=j*key+i;
			if(count>=length){
				break;
			}
			printf("%c",matrix[j][i]);
		}
	}


}

void decrypt(int key, int length){
	char matrix[500][500];
	int row=length/key;
	int cl=length%key;
	int pos=0;
	for(int a=0;a<key;a++){
		for(int b=0;b<row+1;b++){
			if((b==row)&&(a>=cl)){
				break;
			}
			matrix[b][a]=inputData[pos];
			pos++;
			if(pos>=length){
				break;
			}
		}
	}
	int count=0;
	for(int i=0;i<row+1;i++){
		for(int j=0;j<key;j++){
			printf("%c",matrix[i][j]);
			count++;
			if(count>=length){
				break;
			}
		}
	}

}

int main(int argc, char *argv[] )
{
	if(argc!=4){
		errorMsg("Wrong number of arguments");
	}
	if(atoi(argv[3])>=500){
		errorMsg("LENGTH is too long");
	}
	if(atoi(argv[2])>=atoi(argv[3])){
		errorMsg("KEY should less than LENGTH");
	}
	if(strcmp(argv[1],"-e")==0){
		for(int i=0;i<atoi(argv[3]);i++){
			inputData[i]=getc(stdin);
		}	
		encrypt(atoi(argv[2]), atoi(argv[3]));
	}
	else if(strcmp(argv[1],"-d")==0){
		for(int i=0;i<atoi(argv[3]);i++){
                        inputData[i]=getc(stdin);
                }
		decrypt(atoi(argv[2]), atoi(argv[3]));
	}
	else{
		errorMsg("Wrong SWITCH");
	}
}






