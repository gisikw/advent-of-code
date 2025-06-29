#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int readInt(FILE *file);
long int score(long int time, long int dist);
long int shift(long int num, int basis);

int main(int argc, char *argv[]) {
  FILE *file = fopen(argv[1], "r");
  int nums[8];
  int count = 0;

  int ch;
  while ((ch = fgetc(file)) != EOF) {
    if (ch >= '0' && ch <= '9') {
      ungetc(ch, file);
      nums[count++] = readInt(file);
    }
  }
  fclose(file);

  count /= 2;
  if (atoi(argv[2]) == 1) {
    int result = 1;
    for(int i = 0; i < count; i++) result *= score(nums[i], nums[i + count]);
    printf("%d\n", result);
  } else {
    int time = nums[0];
    long int dist = nums[count];
    for(int i = 1; i < count; i++) {
      time = shift(time, nums[i]) + nums[i];
      dist = shift(dist, nums[i + count]) + nums[i + count];
    }
    printf("%lu\n", score(time, dist));
  }

  return 0;
}

int readInt(FILE *file) {
  char buffer[4];
  int i = 0;
  int ch;
  while ((ch = fgetc(file)) >= '0' && ch <= '9') buffer[i++] = ch;
  return atoi(buffer);
}

long int score(long int time, long int dist) {
  long int button = (sqrt((time * time) - (4 * dist)) - time) / -2 + 1;
  return time - (2 * button) + 1;
}

long int shift(long int num, int basis) {
  if (basis == 0) return num;
  return shift(num * 10, basis / 10);
}
