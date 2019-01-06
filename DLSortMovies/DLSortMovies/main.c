//
//  main.c
//  DLSortMovies
//
//  Created by MayMyintHtwe-LocalAdmin on 31/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#include <stdio.h>
//#include "mergesort.h"
//#include "foofootests.h"
//#include "sorttest.h"
#include <stdbool.h>
#include "Sort.h"

//struct Date
//{
//    int vote;
//    char title[50];
//};
//
//
//bool compare(const struct Date d1, const struct Date d2)
//{
//    // All cases when true should be returned
//    if (d1.vote < d2.vote)
//        return true;
//
//    // If none of the above cases satisfy, return false
//    return false;
//}
//
//// Function to sort array arr[0..n-1] of dates
//void sortDates(struct Date arr[], int n)
//{
//    // Calling in-built sort function.
//    // First parameter array beginning,
//    // Second paramter - array ending,
//    // Third is the custom compare function
//    int i, j;
//    for( i =0;i<n-1;i++){
//        for (j = 0; j < n-i-1; j++) {
//            if (compare(arr[j], arr[j+1])) {
//                struct Date temp;
//                temp = arr[j];
//                arr[j] = arr[j+1];
//                arr[j+1] = temp;
//            }
//        }
//
//    }
//}

int main(int argc, const char * argv[]) {
    // insert code here...
    
    struct Date arr[] = {{2,"Test1"},{25,"Test2"},{ 3,"Test3"},{20,"Test4"},{15,"Test5"},{ 30,"Test6"}};
    int n = sizeof(arr)/sizeof(arr[0]);
    
    sortDates(arr, n);
    printf ("Sorted dates are\n");
    for (int i=0; i<n; i++)
    {
        printf ("%d %s \n",arr[i].vote,arr[i].title);
    }
    
    return 0;
}

