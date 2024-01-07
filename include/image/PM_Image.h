#ifndef __PM_IMAGE__
#define __PM_IMAGE__

#include <stdio.h>
#include <stdlib.h>

typedef struct
{
	unsigned imageWidth, imageHeight;
	uint32_t* pixelArray;
} PM_Image32;

PM_Image32 PM_CreateBlankImage(unsigned imageWidth, unsigned imageHeight);

void PM_ClearImageWithColor(PM_Image32 image, uint32_t clearColor);

void PM_PasteImage(PM_Image32 destinationImage, PM_Image32 sourceImage, unsigned x, unsigned y);

#endif
