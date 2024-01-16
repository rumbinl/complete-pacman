#include <pacman/PM_Tiles.h>

void PM_TraceTileCluster_Algorithm1(PM_Image32 levelBlueprint, PM_Image32 tileHistoryMap, PM_Image32 tilemapImage, PM_Image32 outputImage, unsigned x, unsigned y)
{
	unsigned lastDirection = PM_DOWN;

	while(PM_GetPixelValue(tileHistoryMap, x, y) == 0)
	{
		PM_GetPixelValue(tileHistoryMap, x, y) = 1;
		for(unsigned currentDirection = PM_Normal(lastDirection); currentDirection != lastDirection; currentDirection+=1, currentDirection%=4)
		{
			unsigned newX = PM_GetX(x,levelBlueprint.imageWidth, currentDirection), 
					 newY = PM_GetY(y,levelBlueprint.imageHeight,currentDirection);

			if(!PM_TileMatches(levelBlueprint, newX, newY))
				continue;

			unsigned tileIndexVert = 0, tileIndexHorz = 2;
			if(lastDirection == PM_OppositeDirection(currentDirection))
				tileIndexHorz = 1;
			else if(currentDirection == PM_Normal(lastDirection))
				tileIndexVert = 1;

			PM_PasteImage(tilemapImage, outputImage, PM_RectangleInit(tileIndexHorz * 8, tileIndexVert * 8, 8, 8), PM_RectangleInit(x * 8, y * 8, 8, 8), (currentDirection+3)%4);	
			x = newX;
			y = newY;
			lastDirection = PM_OppositeDirection(currentDirection);
			break;
		}
	}
}
