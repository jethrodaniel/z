// note: this is standard C

#include <stdio.h>

void zputc(char c, int fd) {
  putc(c, stdout);
}
