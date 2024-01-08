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

void PM_PasteImage(PM_Image32 sourceImage, PM_Image32 destinationImage, PM_Rectangle sourceBounds, PM_Rectangle destinationBounds, unsigned normalCount)
{
	unsigned imageWidth  = min(sourceImage.imageWidth, min(sourceBounds.width, destinationBounds.width)), 
			 imageHeight = min(sourceImage.imageHeight, min(sourceBounds.height, destinationBounds.height));

	for(unsigned j = 0; j<imageHeight; j++)

		for(unsigned i = 0; i<imageWidth; i++)
		{
			unsigned destinationX = i, destinationY = j;
			for(unsigned k = 0; k < normalCount % 4; k++)
			{
				unsigned tempDestinationX = destinationX, tempDestinationY = destinationY;

				destinationX = imageWidth - 1 - destinationY ;
				destinationY = tempDestinationX;
			}

			if(destinationBounds.x+destinationX < destinationImage.imageWidth  && 
			   destinationBounds.y+destinationY < destinationImage.imageHeight && 
			   sourceBounds.x+i      < sourceImage.imageWidth       && 
			   sourceBounds.y+j      < sourceImage.imageHeight)
			{
				unsigned destinationPos = (destinationBounds.x+destinationX) + 
										  (destinationBounds.y+destinationY) * 
									      destinationImage.imageWidth;
	
				destinationImage.pixelArray[destinationPos] = 

				sourceImage.pixelArray[ (sourceBounds.x+i) + 
										(sourceBounds.y+j) * 
										sourceImage.imageWidth ];
			}
		}
}
