#ifndef __PM_BMP__
#define __PM_BMP__

#include <stdio.h>
#include <stdlib.h>
#include <image/PM_Image.h>

typedef struct
{
	unsigned imageWidth,imageHeight,isFlipped,bitsPerPixel;
	uint32_t* pixelArray, *colorPalette;
} PM_BMP;

PM_BMP PM_OpenBMP(char* fileName);

PM_Image32 PM_GetImage32(PM_BMP bmp);

void PM_DeleteBMP(PM_BMP bmp);

void PM_DeleteImage32(PM_Image32 img);

#endif
