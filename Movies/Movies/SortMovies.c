//
//  SortMovies.c
//  Movies
//
//  Created by MayMyintHtwe-LocalAdmin on 1/1/19.
//  Copyright © 2019 Thein-LocalAdmin. All rights reserved.
//

#include "SortMovies.h"
#include <string.h>
#include <stdlib.h>
#define MAXArray 100000

//bool compare(const struct Movie d1, const struct Movie d2)
//{
//    if (d1.vote < d2.vote)
//        return true;
//    return false;
//}

//void sortMovies()
//{
//    int n = sizeof(arr)/sizeof(arr[0]);
//    int i, j;
//    for( i =0;i<n-1;i++){
//        for (j = 0; j < n-i-1; j++) {
//            if (compare(arr[j], arr[j+1])) {
//                struct Movie temp;
//                temp = arr[j];
//                arr[j] = arr[j+1];
//                arr[j+1] = temp;
//            }
//        }
//        
//    }
//}

int readData(const char *path)
{
    FILE *fp;
    char str[MAXCHAR];
    struct Movie arr[MAXArray];
    long vote[MAXArray];
    
    fp = fopen(path, "r");
    if (fp == NULL){
        printf("Could not open file %s",path);
        return 1;
    }
    char sparator[] = ",";
    int e = 0;
    struct Movie aMovie;
    while (fgets(str, MAXCHAR, fp) != NULL)
    {
        char *ptr = strtok(str, sparator);
        int f = 0;
      
        while (ptr != NULL)
        {
            printf("%s\n", ptr);
            if (f == 0) {
                strcpy(aMovie.title, ptr);
                arr[e] = aMovie;
            }else if ( f == 1) {
                vote[e] = strtol(ptr, (char **)NULL, 10);
            }
            ptr = strtok(NULL, sparator);
            f++;
        }
        e++;
    }
    fclose(fp);

    int i, j;

    for( i =0;i<e-1;i++){
        struct Movie aMovie1 = arr[i];
        
        printf("Movie %s\n", aMovie1.title);
        printf("%ld\n", vote[i]);
        for (j = 0; j < e-i-1; j++) {

//             firstStr = str[j];
//             secondStr = str[j+1];
////            if (compare(arr[j], arr[j+1])) {
////                struct Movie temp;
////                temp = arr[j];
////                arr[j] = arr[j+1];
////                arr[j+1] = temp;
////            }
//
            
        }
    }
    
     return 0;
}
