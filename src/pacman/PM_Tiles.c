#include <pacman/PM_Tiles.h>

void PM_DrawLevel(PM_Image32 levelBlueprint, PM_Image32 outputImage, PM_Image32 tilemapImage, unsigned x, unsigned y)
{
	PM_Image32 tileHistoryMap = PM_CreateBlankImage(levelBlueprint.imageWidth, levelBlueprint.imageHeight);

	for(unsigned j = 0; j < levelBlueprint.imageHeight; j++)

		for(unsigned i = 0; i < levelBlueprint.imageWidth; i++)

			if(PM_TileMatches(levelBlueprint, i, j) && !tileHistoryMap.pixelArray[ i + j * levelBlueprint.imageWidth ])

				PM_TraceTileCluster_Algorithm1(levelBlueprint, tileHistoryMap, tilemapImage, outputImage, i, j, PM_DOWN);
}

void PM_TraceTileCluster_Algorithm1(PM_Image32 levelBlueprint, PM_Image32 tileHistoryMap, PM_Image32 tilemapImage, PM_Image32 outputImage, unsigned x, unsigned y, unsigned lastDirection)
{
	unsigned currentDirection = PM_Normal(lastDirection);

	if(levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth] == 0xff0000c8)
		currentDirection = PM_OppositeDirection(currentDirection);

	for(unsigned i=0; i < 4; i++)
	{
		unsigned newX = PM_GetX(x,levelBlueprint.imageWidth,currentDirection), newY = PM_GetY(y,levelBlueprint.imageHeight,currentDirection);

		if(currentDirection == lastDirection || newX == UINT_MAX || newY == UINT_MAX || newX > tileHistoryMap.imageWidth || newY > tileHistoryMap.imageHeight || !PM_TileMatches(levelBlueprint, newX, newY) || tileHistoryMap.pixelArray[newX+newY*tileHistoryMap.imageWidth])
		{
			if(levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth] == 0xff0000c8)
				currentDirection += 3;
			else
				currentDirection+=1;
			currentDirection%=4;
			continue;
		}

		tileHistoryMap.pixelArray[newX + newY * tileHistoryMap.imageWidth] = PM_OppositeDirection(currentDirection)+1;

		PM_TraceTileCluster_Algorithm1(levelBlueprint, tileHistoryMap, tilemapImage, outputImage, newX, newY, PM_OppositeDirection(currentDirection));	

		break;

	}
	unsigned tileIndexVert = 0, tileIndexHorz = 0;
	if(lastDirection == PM_OppositeDirection(currentDirection))
		tileIndexHorz = 1;
	else if(currentDirection == PM_Normal(lastDirection))
		tileIndexVert = 1, tileIndexHorz = 2;
	else
		tileIndexHorz = 2;

	if(levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth] == 0xff0000c8)
		tileIndexVert += 2;

	PM_PasteImage(tilemapImage, outputImage, PM_RectangleInit(tileIndexHorz * 8, tileIndexVert * 8, 8, 8), PM_RectangleInit(x * 8, y * 8, 8, 8), (currentDirection+3)%4);	
}

unsigned PM_TileMatches(PM_Image32 levelBlueprint, unsigned x, unsigned y)
{
	uint32_t pixelValue = levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth];
	if(pixelValue == 0xff0000ff || pixelValue == 0xff2121ff || pixelValue == 0xff0000c8)
		return 1;
	return 0;
}