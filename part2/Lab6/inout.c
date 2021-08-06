#include <stdio.h>
#include <stdlib.h>

#include "bmp.h"

int main(int argc, char **argv){

  /* Contains information concerning the image */
  bmp_header header;

  /* Storage for reading and writing the image data */
  float *data_in, *data_out;

  long int size ,i ,j , lay;

  if (argc != 3)
  {
    printf("Usage: inout <InFile> <OutFile>\n\n");
    exit(EXIT_FAILURE);
  }

  /* Reads the image header and data of the picture named argv[1] */
  bmpRead(argv[1], &header, &data_in);

  /* Size = Number of bytes for one layer */
  /* The number of layers is 3 (blue, green, red) */ 
  size=header.height*header.width;

  /* Memory allocated for copying the data into */
  /* Notice the factor 3 (see above) */
  data_out=(float*)malloc(3 * size*sizeof(float));

  //bmpCopy(data_in, data_out, &header);
  //bmpGrayscale(data_in, data_out, &header);
  //bmpSepia(data_in, data_out, &header);
  bmpGrayscaleSSE(data_in, data_out, &header);

  /* And write the whole thing back on disk (File named argv[2]) */
  bmpWrite(argv[2],&header,data_out);

  return(0);
}
