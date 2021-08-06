#include "bmp.h"

/*
 * Grayscales pixel data
 * (sums 30% of the red value, 59% of the green value, and 11% of
 * the blue and replaces each compoment)
 */

void bmpGrayscale(float *bmpSrc, float *bmpDst, bmp_header *header)
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
                /* Grayscale data */
                bmpDst[lr * size + i * w + j] = 0.11 * bmpSrc[i * w + j] + \
                    0.59 * bmpSrc[1 * size + i * w + j] + \
                    0.30 * bmpSrc[2 * size + i * w + j];
            }
        }
    }
}
