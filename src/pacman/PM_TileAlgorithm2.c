#include <pacman/PM_Tiles.h>

PM_DirectionPair PM_TraceTileCluster_Algorithm2(PM_Image32 levelBlueprint, PM_Image32 tileHistoryMap, PM_Image32 tilemapImage, PM_Image32 outputImage, unsigned x, unsigned y, unsigned lastDirection, unsigned iterationIndex)
{
	unsigned contacts = 0;
	unsigned direction1=lastDirection, direction2 = 5;
	for(unsigned currentDirection=0; currentDirection<4; currentDirection++)
	{
		unsigned newX = PM_GetX(x,levelBlueprint.imageWidth,currentDirection), newY = PM_GetY(y,levelBlueprint.imageHeight,currentDirection);
		if(PM_TileMatches(levelBlueprint, newX, newY))
		{
			if(direction2 == 5)
				direction2 = currentDirection;
			else
				direction1 = currentDirection;
			contacts ++;
		}
	}
	if(contacts > 2) 
	{
		contacts = 0;
		direction1=lastDirection, direction2 = 5;
		PM_GetPixelValue(tileHistoryMap, x, y) = iterationIndex;
		for(unsigned currentDirection=0; currentDirection<4; currentDirection++)
		{
			unsigned newX = PM_GetX(x,levelBlueprint.imageWidth,currentDirection), newY = PM_GetY(y,levelBlueprint.imageHeight,currentDirection);

			if(lastDirection == currentDirection || PM_GetPixelValue(tileHistoryMap, newX, newY) == iterationIndex || !PM_TileMatches(levelBlueprint, newX, newY)) continue;
			
			PM_DirectionPair newContact = PM_TraceTileCluster_Algorithm2(levelBlueprint, tileHistoryMap, tilemapImage, outputImage, newX, newY, PM_OppositeDirection(currentDirection), iterationIndex);

			if(newContact.direction1 == PM_OppositeDirection(currentDirection) || newContact.direction2 == PM_OppositeDirection(currentDirection))
			{
				if(direction2 == 5)
					direction2 = currentDirection;
				else
					direction1 = currentDirection;
				contacts ++;
			}
		}
		PM_GetPixelValue(tileHistoryMap, x, y) = 0;
	}

	PM_DirectionPair pair = { direction1, direction2 };
	return pair;
}
