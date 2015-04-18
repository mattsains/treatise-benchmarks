#include <stdio.h>
#include <stdlib.h>

struct LinkedList
{
   int value;
   struct LinkedList* next;
};
typedef struct LinkedList LinkedList;


LinkedList* reserveList(int size)
{
   LinkedList* start;
   for (int i=0; i<size; i++)
   {
      LinkedList* next = (LinkedList*)malloc(sizeof(LinkedList));
      next->next = start; //lol
      start = next;
   }

   return start;
}

void removeMultiples(LinkedList* list, int n)
{
   
   while (list != 0)
   {
      LinkedList* next = list->next;
      if (next == 0)
         return;
      else
      {
         int val = next->value;
         if (val%n == 0)
         {
            list->next = next->next;
         }

         list = list->next;
      }
   }
}

      

int main(int argc, char* argv[])
{
   const int max = 1000000;
   
   LinkedList* sieve = reserveList(max);

   LinkedList* walk = sieve;
   
   for (int i=0; i<max-2; i++)
   {
      walk->value = i+2;
      walk = walk->next;
   }

   walk = sieve;
   
   while (walk!=0)
   {
      removeMultiples(walk, walk->value);
      walk = walk->next;
   }

   walk=sieve;
   while (walk!=0)
   {
      printf("%d\n",walk->value);
      walk = walk->next;
   }

   return 0;
}

