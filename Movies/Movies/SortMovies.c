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
#include <stdio.h>
#define MAXArray 10000

bool compare(long d1, long d2)
{
    if (d1 < d2)
        return true;
    return false;
}


extern int readData(const char * __restrict path)

{
    char filepath[1000];
    strcpy(filepath, path);
    strcat( filepath,"/Data.txt" );
    FILE *fp;
    char str[MAXCHAR];
    char titles [MAXArray][MAXCHAR];
    long votes[MAXArray];

    fp = fopen(filepath, "r");
    if (fp == NULL){
        //printf("Could not open file %s",path);
        return 1;
    }
    char sparator[] = ",";
    int e = 0;

    while (fgets(str, MAXCHAR, fp) != NULL)
    {
        char *ptr = strtok(str, sparator);
        int f = 0;
        
        while (ptr != NULL)
        {
            //printf("%s\n", ptr);
            if (f == 0) {
                strcpy(titles[e], ptr);
                printf("%s\n", ptr);
            }else if ( f == 1) {
                votes[e] = strtol(ptr, (char **)NULL, 10);
            }
            ptr = strtok(NULL, sparator);
            f++;
        }
        e++;
    }
    fclose(fp);
    
    //sorting
    int i, j;
    for( i =0;i<e-1;i++){
        

        for (j = 0; j < e-i-1; j++) {
            
            long temp ;
            char tempStr[MAXCHAR];
            
                if (compare(votes[j],  votes[j+1])) {
                    temp = votes[j];
                    votes[j] = votes[j+1];
                    votes[j+1] = temp;
                    
                    strcpy(tempStr, titles[j]);
                    strcpy(titles[j],  titles[j+1]);
                     strcpy(titles[j+1],  tempStr);
   
               }
        }
    }
    
    //writing result
    FILE *outputfp;
    char outputPath[1000];
    strcpy(outputPath, path);
    strcat( outputPath,"/Output.txt" );
    
    outputfp = fopen(outputPath, "w");  // Try changing to "a"
    for( i =0;i<e-1;i++){
        fprintf(outputfp, "%s \n", titles[i]);
    }
    fclose(outputfp);
    
    return 0;
}

