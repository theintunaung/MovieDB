//
//  SortMovies.h
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 1/1/19.
//  Copyright © 2019 Thein-LocalAdmin. All rights reserved.
//

#ifndef SortMovies_h
#define SortMovies_h
#define MAXCHAR 100
#include <stdio.h>
#include <stdbool.h>
struct Movie
{    long vote;
     char title[MAXCHAR];
};

void sortMovies(void);

extern int readData(const char * __restrict path);

#endif /* SortMovies_h */
