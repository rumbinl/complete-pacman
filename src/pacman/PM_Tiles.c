#include <pacman/PM_Tiles.h>

void PM_DrawLevel(PM_Image32 levelBlueprint, PM_Image32 outputImage, PM_Image32 tilemapImage)
{
	PM_Image32 tileHistoryMap = PM_CreateBlankImage(levelBlueprint.imageWidth, levelBlueprint.imageHeight);

	for(unsigned j = 0; j < levelBlueprint.imageHeight; j++)

		for(unsigned i = 0; i < levelBlueprint.imageWidth; i++)

			if(PM_TileMatches(levelBlueprint, i, j))
				PM_TraceTileCluster_Algorithm1(levelBlueprint, tileHistoryMap, tilemapImage, outputImage, i, j);
}

unsigned PM_TileMatches(PM_Image32 levelBlueprint, unsigned x, unsigned y)
{
	uint32_t pixelValue = levelBlueprint.pixelArray[x + y * levelBlueprint.imageWidth];
	if(pixelValue == 0xff0000ff || pixelValue == 0xff2121ff/* || pixelValue == 0xff0000c8*/)
		return 1;
	return 0;
}
