#include "bmp.h"

/*
 * Grayscales pixel data
 * (sums 30% of the red value, 59% of the green value, and 11% of
 * the blue and replaces each compoment)
 */

void bmpGrayscale2(float *bmpSrc, float *bmpDst, bmp_header *header)
{
    unsigned int lr, i, j, k;
    unsigned int w = header->width;
    unsigned int h = header->height;
    unsigned int size = h*w;
    float red[4], green[4], blue[4], res[4];
    float rmul[4] = {0.30, 0.30, 0.30, 0.30};
    float gmul[4] = {0.59, 0.59, 0.59, 0.59};
    float bmul[4] = {0.11, 0.11, 0.11, 0.11};

    /* For each four picture points */
    for (i = 0; i < h; i++)
    {
        for(j = 0; j < w / 4; j++)
        {
            for (k = 0; k < 4; k++)
            {
                blue[k] = bmpSrc[i * w + 4 * j + k];
                green[k] = bmpSrc[size + i * w + 4 * j + k];
                red[k] = bmpSrc[2 * size + i * w + 4 * j + k];
            }
            for (k = 0; k < 4; k++)
            {
                res[k] = bmul[k] * blue[k] + gmul[k] * green[k] + rmul[k] * red[k];
                bmpDst[i*w+4*j+k] = bmpDst[size + i*w+4*j+k] = bmpDst[2* size +i*w+4*j+k] = res[k];
            }
        }

        j = w / 4;
        for (k = 0; k < w % 4; k++) {
            blue[k] = bmpSrc[i * w + 4 * j + k];
            green[k] = bmpSrc[size + i * w + 4 * j + k];
            red[k] = bmpSrc[2 * size + i * w + 4 * j + k];
        }

        for (k = 0; k < w % 4; k++) {
            res[k] = bmul[k] * blue[k] + gmul[k] * green[k] + rmul[k] * red[k];
            bmpDst[i*w+4*j+k] = bmpDst[size + i*w+4*j+k] = bmpDst[2* size +i*w+4*j+k] = res[k];
        }
    }
}
