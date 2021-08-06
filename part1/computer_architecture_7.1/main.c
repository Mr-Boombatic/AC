#include <stdio.h>
#include <string.h>
#include <limits.h>
#define MAXLINE 1024

static int Numbers[MAXLINE];
static short Sum = 0;
static int multiplier = 1;

extern short Sum_Numbers(short, int);
extern void Print_Result(short);

long Trans_Sym(char symbol) {
  symbol -= 48;

  return symbol;
}

int Read_Sym(int length, char buffer[]) {
  int i = 0;
  int count = 0;

  while(1) {
    char symbol = buffer[i];

    if (symbol == '-' && (i - count) == 0) {
      multiplier = -1;
    }

    if (symbol > '9' || symbol < '0') {
      count++;
    } else {
      Numbers[i - count] = Trans_Sym(symbol);
    }
    i++;
    if (i != length && i != MAXLINE) {
      continue;
    }
    break;
  }

  return count;
}

int main() {

  char buf[MAXLINE] = "";

  while (fgets(buf, MAXLINE, stdin) != NULL) {
    int readed = strlen(buf) - 1;
    buf[strlen(buf) - 1] = '\0';

    int noDigitsCount = Read_Sym(readed, buf);
    int number = 0;
    int overflowFlag = 0;

    for (int i = 0; i < readed - noDigitsCount; i++) {
	if (multiplier == 1) {
	    if (number > ( SHRT_MAX - Numbers[i] ) / 10) {
		overflowFlag = 1;
		break;
	    }
	} else {
	    if (number * multiplier < (SHRT_MIN + Numbers[i]) / 10) {
		overflowFlag = 1;
		break;
	    }
	}
      number *= 10;
      number += Numbers[i];
    }
    number *= multiplier;
    multiplier = 1;
    if (overflowFlag) {
	printf("Overflow, enter next number \n");
	continue;
    }
    Sum = Sum_Numbers(Sum, number);
  }

  Print_Result(Sum);
}
