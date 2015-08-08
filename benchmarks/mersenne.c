#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

// Create a length 624 array to store the state of the generator
unsigned int MT[624];
int ind = 0;

void initialize_generator(int seed);
unsigned int extract_number();
void generate_numbers();

//until a GC is written, you should use this int to string function to introduce memory leaks
char* i_to_s(int64_t i)
{
  char* str = malloc(21);
  int ind = 0;
  if (i < 0) {
    str[ind++]='-';
    i = -i;
  }
  int64_t mask = 1000000000000000000;
  int printing = 0;
  do {
    char c = '0' + (i / mask);
    printing = printing | (c != '0');
    if (printing)
      str[ind++] = '0' + (i / mask);
    i %= mask;
    mask /= 10;
  } while(i);
  str[ind] = '\0';
  return str;
} 

int main()
{
  initialize_generator(5489);
  for (long i=0; i<100L; i++) {
    printf("%s\n", i_to_s(extract_number()));
  }
  return 0;
}
      
// Initialize the generator from a seed
void initialize_generator(int seed) {
  ind = 0;
  MT[0] = seed;
  for (int i=1; i<=623; i++) { // loop over each element
    MT[i] = 0xffffffff & (1812433253 * (MT[i-1] ^ (MT[i-1]>>30)) + i); // 0x6c078965
  }
}

// Extract a tempered pseudorandom number based on the ind-th value,
// calling generate_numbers() every 624 numbers
unsigned int extract_number() {
  if (ind == 0) {
    generate_numbers();
  }

  unsigned int y = MT[ind];
  y = y ^ (y>>11);
  y = y ^ ((y<<11) & 2636928640); // 0x9d2c5680
  y = y ^ ((y<<15) & 4022730752); // 0xefc60000
  y = y ^ ((y>>18));
  ind = (ind + 1) % 624;
  return y;
}

// Generate an array of 624 untempered numbers
void generate_numbers() {
  for (int i=0; i<=623; i++) {
    unsigned int y = (MT[i] & 0x80000000)                       // bit 31 (32nd bit) of MT[i]
      + (MT[(i+1) % 624] & 0x7fffffff);   // bits 0-30 (first 31 bits) of MT[...]
    MT[i] = MT[(i + 397) % 624] ^ (y>>1);
    if ((y % 2) != 0) { // y is odd
        MT[i] = MT[i] ^ 2567483615; // 0x9908b0df
      }
  }
}
