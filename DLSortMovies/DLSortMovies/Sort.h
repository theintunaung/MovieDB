//
//  Sort.h
//  DLSortMovies
//
//  Created by MayMyintHtwe-LocalAdmin on 31/12/18.
//  Copyright © 2018 Thein-LocalAdmin. All rights reserved.
//

#ifndef Sort_h
#define Sort_h

#include <stdio.h>
#include <stdbool.h>
struct Date
{
    int vote;
    char title[50];
};
void sortDates(struct Date arr[], int n);
#endif /* Sort_h */
