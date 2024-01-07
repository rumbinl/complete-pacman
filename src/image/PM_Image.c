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

void PM_PasteImage(PM_Image32 destinationImage, PM_Image32 sourceImage, unsigned x, unsigned y)
{
	//printf("%d %d\n", destinationImage.imageWidth, destinationImage.imageHeight);
	//printf("%d %d\n", sourceImage.imageWidth, sourceImage.imageHeight);
	//for(int i=0; i<sourceImage.imageWidth * sourceImage.imageHeight; i++) printf("%x ", sourceImage.pixelArray[i]);
	printf("\n");
	for(unsigned j = 0; j<sourceImage.imageHeight; j++)
		for(unsigned i = 0; i<sourceImage.imageWidth; i++)
			if(x+i<destinationImage.imageWidth && y+j < destinationImage.imageHeight)
				destinationImage.pixelArray[(x+i)+(y+j)*destinationImage.imageWidth] = sourceImage.pixelArray[i+j*sourceImage.imageWidth];
}
