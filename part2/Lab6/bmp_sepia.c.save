#include "bmp.h"

/*
 * Sepias pixel data
 */

float min(float a, float b) {
    return a < b ? a : b;
}

void bmpSepia(float *bmpSrc, float *bmpDst, bmp_header *header)
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
                switch (lr) {
                case 0:
                    bmpDst[i * w + j] = min(1, 0.272 * bmpSrc[2 * size + i * w + j] + 0.534 * bmpSrc[1 * size + i * w + j] + 0.131 * bmpSrc[i * w + j]);
                    break;
                case 1:
                    bmpDst[size + i * w + j] = min(1, 0.349 * bmpSrc[2 * size + i * w + j] + 0.686 * bmpSrc[1 * size + i * w + j] + 0.168 * bmpSrc[i * w + j]);
                    break;
                case 2:
                    bmpDst[2 * size + i * w + j] = min(1, 0.393 * bmpSrc[2 * size + i * w + j] + 0.769 * bmpSrc[1 * size + i * w + j] + 0.189 * bmpSrc[i * w + j]);
                    break;
                default:
                    break;
                }
            }
        }
    }
}
