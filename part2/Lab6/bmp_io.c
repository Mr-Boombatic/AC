#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include "bmp.h"

/*
 *  Opens a 24 bit true color bmp file and strips its header and its data.
 *  The data starts at location "data", its grouped into 3 layers of "size"
 *  floats of size and they represent the colors blue, green and red.
 */

void bmpRead(char *str, bmp_header *header, float **data)
{

    FILE *bmp_file;
    unsigned long int size,i;
    unsigned char *ptr;

    /* Open bmp file and read header */
    bmp_file=fopen(str,"r");

    if (bmp_file == NULL)
    {
        printf("File \"%s\" couldn't be opened.\n\n", str);
        exit(EXIT_FAILURE);
    }

    i = fread(header,56,1,bmp_file);

    /* Make header fit into struct */
    for (i = 0; i < 51; i++)
    {
        ptr = (unsigned char*)(header) + (55 - i);
        *ptr= *(ptr - 2);
    }

    /* Check color depth */
    if ((*header).bits_per_pixel != 24)
    {
        printf("Sorry, but can handle only 24-bit true color mode pictures.\n\n",str);
        exit(EXIT_FAILURE);
    }

    size = (*header).width*(*header).height;

    (*data) = (float*)malloc(3 * size*sizeof(float));

    if ((*data) == NULL)
    {
        printf("Not enough memoy for reading picture.\n\n");
        exit(EXIT_FAILURE);
    }

    fseek(bmp_file, 54, SEEK_SET);

    /* Read pixel data into color layers */
    for(i=0;i<size;i++)
    {
        (*data)[i] = (float)fgetc (bmp_file) / 255;
        (*data)[i + size] = (float)fgetc (bmp_file) / 255;
        (*data)[i + 2*size] = (float)fgetc (bmp_file) / 255;
    }

    fclose(bmp_file);
}

/*
 *  Stores a 24 bit true color bmp file given in the format described above.
 */

extern void bmpWrite(char *str, bmp_header *header, float *data)
{
    FILE *bmp_file;
    unsigned long int size,i,j;
    unsigned char *ptr, *buf;

    size=(*header).width*(*header).height;

    /* Open bmp file for writing and write header */
    bmp_file = fopen(str,"w");

    if (bmp_file == NULL)
    {
        printf("File \"%s\" couldn't be opened.\n\n",str);
        exit(EXIT_FAILURE);
    }

    /* Restruct header (remove alignment) */
    for (i = 2; i < 54; i++)
    {
        ptr=(unsigned char*)(header) + i;
        *ptr=*(ptr+2);
    }

    /* Write header */
    j = fwrite(header,54,1,bmp_file);

    /* Write layers */
    for (i = 0; i < size; i++)
    {
        j = fputc ((int)(data[i] * 255),bmp_file);   
        j = fputc ((int)(data[i+size] * 255),bmp_file);   
        j = fputc ((int)(data[i+2*size] * 255),bmp_file);
    }

    fclose(bmp_file);
    free(data);
}


