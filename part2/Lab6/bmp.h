#ifndef _BMP
#define _BMP

typedef struct {
  char id1;
  char id2;
  unsigned int file_size;
  unsigned int reserved;
  unsigned int bmp_data_offset;
  unsigned int bmp_header_size;
  unsigned int width;
  unsigned int height;
  unsigned short int planes;
  unsigned short int bits_per_pixel;
  unsigned int compression;
  unsigned int bmp_data_size;
  unsigned int h_resolution;
  unsigned int v_resolution;
  unsigned int colors;
  unsigned int important_colors;
} bmp_header;

extern void bmpRead(char *str, bmp_header *header, float **data);
extern void bmpRrite(char *str, bmp_header *header, float *data);
extern void bmpCopy(float *bmpSrc, float *bmpDst, bmp_header *header);
extern void bmpGrayscale(float *bmpSrc, float *bmpDst, bmp_header *header);
extern void bmpSepia(float *bmpSrc, float *bmpDst, bmp_header *header);
extern void bmpGrayscale2(float *bmpSrc, float *bmpDst, bmp_header *header);
extern void bmpGrayscaleSSE(float *bmpSrc, float *bmpDst, bmp_header *header);
#endif
