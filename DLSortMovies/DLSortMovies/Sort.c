//
//  Sort.c
//  DLSortMovies
//
//  Created by MayMyintHtwe-LocalAdmin on 31/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#include "Sort.h"



bool compare(const struct Date d1, const struct Date d2)
{
    if (d1.vote < d2.vote)
        return true;
    return false;
}

// Function to sort array arr[0..n-1] of dates
void sortDates(struct Date arr[], int n)
{
    
    int i, j;
    for( i =0;i<n-1;i++){
        for (j = 0; j < n-i-1; j++) {
            if (compare(arr[j], arr[j+1])) {
                struct Date temp;
                temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
        
    }
}
