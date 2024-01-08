#ifndef __PM_IMAGE__
#define __PM_IMAGE__

#include <stdio.h>
#include <stdlib.h>

#include <utils/PM_Core.h>
#include <utils/PM_Rectangle.h>

typedef struct
{
	unsigned int imageWidth, imageHeight;
	uint32_t* pixelArray;
} PM_Image32;

PM_Image32 PM_CreateBlankImage(unsigned imageWidth, unsigned imageHeight);

void PM_ClearImageWithColor(PM_Image32 image, uint32_t clearColor);

void PM_PasteImage(PM_Image32 sourceImage, PM_Image32 destinationImage, PM_Rectangle sourceBounds, PM_Rectangle destinationBounds, unsigned normalCount);

#endif
