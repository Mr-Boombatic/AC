#include "bmp.h"

/*
 * Copies pixel data
 */

void bmpCopy(float *bmpSrc, float *bmpDst, bmp_header *header)
{
    unsigned int lr, i, j;
	unsigned int w = header->width;
	unsigned int h = header->height;
    unsigned int size = h*w;

    /* For each layer */
    for (lr = 0; lr < 3; lr++)
    {
        /* For each picture point */
        for (i = 0; i < h; i++)
        {
            for(j = 0; j < w; j++)
            {
                /* Simply copy the data */
                bmpDst[lr * size + i * w + j]=bmpSrc[lr * size + i * w + j];

            }
        }
    }
}



