#include <stdio.h>
#include <stdlib.h>

int readInt(FILE *file);
long int score(int time, long int dist);

int main(int argc, char *argv[]) {
  FILE *file = fopen(argv[1], "r");
  int nums[8];
  int count = 0;
  int result = 1;
  char *eptr;

  while(!feof(file)) {
    char ch = fgetc(file);
    if (ch >= '0' && ch <= '9') nums[count++] = readInt(file);
  }
  fclose(file);
  count /= 2;

  if (atoi(argv[2]) == 1) {
    for(int i = 0; i < count; i++) result *= score(nums[i], nums[i + count]);
    printf("%d\n", result);
  } else {
    long int time = nums[0];
    long int dist = nums[count];
    for(int i = 1; i < count; i++) {
      char nextTime[16];
      sprintf(nextTime, "%d%d", time, nums[i]);
      time = atoi(nextTime);
      char nextDist[32];
      sprintf(nextDist, "%lu%lu", dist, nums[i + count]);
      dist = strtol(nextDist, &eptr, 10);
    }
    printf("%lu\n", score(time, dist));
  }

  return 0;
}

int readInt(FILE *file) {
  char buffer[4];
  fseek(file, -1, SEEK_CUR);
  int i = 0;
  while (1) {
    char ch = fgetc(file);
    if (ch < '0' || ch > '9') break;
    buffer[i++] = ch;
  }
  return atoi(buffer);
}

long int score(int time, long int dist) {
  long int button = 0;
  do {
    button++;
  } while (button * (time - button) <= dist);
  return time - (2 * button) + 1;
}
