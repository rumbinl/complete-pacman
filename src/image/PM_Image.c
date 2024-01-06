#include <image/PM_Image.h>

PM_Image32 PM_CreateBlankImage(unsigned imageWidth, unsigned imageHeight)
{
	PM_Image32 returnImage = { imageWidth, imageHeight, (uint32_t*)calloc(imageWidth*imageHeight, sizeof(uint32_t)) };
	return returnImage;
}

void PM_ClearImageWithColor(PM_Image32 image, uint32_t clearColor)
{
	for(unsigned i=0; i<image.imageWidth * image.imageHeight; i++)
		image.pixelArray[i]=clearColor;
}
