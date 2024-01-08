#include <pacman/PM_Tiles.h>

void PM_DrawLevel(PM_Image32 levelBlueprint, PM_Image32 outputImage, PM_Image32 tilemapImage, unsigned x, unsigned y)
{
	PM_Image32 tileHistoryMap = PM_CreateBlankImage(levelBlueprint.imageWidth, levelBlueprint.imageHeight);

	unsigned tileIndex = 1;

	for(unsigned j = 0; j < levelBlueprint.imageHeight; j++)

		for(unsigned i = 0; i < levelBlueprint.imageWidth; i++)

			if(PM_TileMatches(levelBlueprint, i, j))
			{
				PM_DirectionPair pair = PM_TraceTileCluster_Algorithm2(levelBlueprint, tileHistoryMap, tilemapImage, outputImage, i, j, 5, tileIndex++);
				unsigned tileIndexVert = 0, tileIndexHorz = 0;
				if(pair.direction1 == PM_OppositeDirection(pair.direction2))
					tileIndexHorz = 1;
				else if(pair.direction2 == 5)
					tileIndexHorz = 0;
				else
					tileIndexHorz = 2;
				PM_PasteImage(tilemapImage, outputImage, PM_RectangleInit(tileIndexHorz * 8, tileIndexVert * 8, 8, 8), PM_RectangleInit(i * 8, j * 8, 8, 8), (min((pair.direction1+1)%4, (pair.direction2+1)%4)+2)%4);
			}
}

unsigned PM_TileMatches(PM_Image32 levelBlueprint, unsigned x, unsigned y)
{
	uint32_t pixelValue = levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth];
	if(pixelValue == 0xff0000ff || pixelValue == 0xff2121ff || pixelValue == 0xff0000c8)
		return 1;
	return 0;
}
