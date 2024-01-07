#include <bmp/PM_BMP.h>

PM_BMP PM_OpenBMP(char* fileName)
{
	PM_BMP newBMP = {0, 0, 0, 0, NULL, NULL};

	FILE* _filePointer = fopen(fileName, "r");
	if(_filePointer == NULL)
		return newBMP;

	/*int i=1;
	while(!feof(_filePointer))
	{
		uint8_t byte;
		fread(&byte, 1,1,_filePointer);
		if(byte < 0x10)
			printf("0");
		printf("%x ", byte);
		if(!((i++)%4)) printf("\n");
	}
	rewind(_filePointer);*/

	unsigned char _header[14]; // Can't use bitfields because 4-byte padding skipping mem. values
	fread(_header, 14, 1, _filePointer);

	struct { int32_t size : 32, width : 32, height : 32, colorPanes : 16, bitsPerPixel : 16, compressionMethod : 32, imageSize : 32, horizontalRes: 32, verticalRes: 32, numColors : 32, numImportantColors: 32; } _dibInfo;

	fread(&_dibInfo, sizeof(_dibInfo), 1, _filePointer);

	//printf("%d %d %d %d %d %d %d %d %d %d %d\n", _dibInfo.size, _dibInfo.width, _dibInfo.height, _dibInfo.colorPanes, _dibInfo.bitsPerPixel, _dibInfo.compressionMethod, _dibInfo.imageSize, _dibInfo.horizontalRes, _dibInfo.verticalRes, _dibInfo.numColors, _dibInfo.numImportantColors);

	newBMP.colorPalette = NULL;
	if(_dibInfo.bitsPerPixel <= 8)
	{
		newBMP.colorPalette = (uint32_t*)calloc((1<<_dibInfo.bitsPerPixel), sizeof(uint8_t));
		fread(newBMP.colorPalette, 4, 1<<(_dibInfo.bitsPerPixel), _filePointer);
	}

	newBMP.pixelArray = (uint32_t*)calloc(abs(_dibInfo.width) * abs(_dibInfo.height), _dibInfo.bitsPerPixel/8);
	newBMP.imageWidth = abs(_dibInfo.width);
	newBMP.imageHeight = abs(_dibInfo.height);
	newBMP.isFlipped = _dibInfo.height < 0;
	newBMP.bitsPerPixel = _dibInfo.bitsPerPixel;

	fseek(_filePointer, *(uint32_t*)(_header+0x0A), SEEK_SET);
	fread(newBMP.pixelArray, _dibInfo.bitsPerPixel/8, abs(_dibInfo.width) * abs(_dibInfo.height), _filePointer);

	fclose(_filePointer);

	return newBMP;
}

PM_Image32 PM_GetImage32(PM_BMP bmp)
{
	PM_Image32 image = {bmp.imageWidth, bmp.imageHeight, NULL};

	image.pixelArray = (uint32_t*)malloc(4 * bmp.imageWidth * bmp.imageHeight);

	for(uint32_t j=0; j<bmp.imageHeight; j++)
	{
		for(uint32_t i=0; i<bmp.imageWidth; i++)
		{
			uint32_t pixelValue = 0x00000000;
			for(unsigned k=0; k<bmp.bitsPerPixel/8; k++)
			{
				uint32_t comp = (bmp.isFlipped ? *((unsigned char*)bmp.pixelArray + (i+j*bmp.imageWidth)*(bmp.bitsPerPixel/8) + k) : *((unsigned char*)bmp.pixelArray + (i+(bmp.imageHeight-j-1)*bmp.imageWidth)*(bmp.bitsPerPixel/8)+k)) << (k*8);
				pixelValue |= comp;
			}
			if(bmp.bitsPerPixel/8 < 4)
				pixelValue |= 0xff000000;
			if(bmp.colorPalette != NULL)
				pixelValue = bmp.colorPalette[pixelValue];
			image.pixelArray[i+j*bmp.imageWidth] = pixelValue;
		}
	}
	
	return image;
}

void PM_DeleteBMP(PM_BMP bmp)
{
	if(bmp.colorPalette)
		free(bmp.colorPalette);	
	if(bmp.pixelArray)
		free(bmp.pixelArray);
}

void PM_DeleteImage32(PM_Image32 img)
{
	if(img.pixelArray)
		free(img.pixelArray);
}
