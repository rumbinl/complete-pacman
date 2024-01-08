#include <window/PM_WindowContext.h>

void PM_SetupWindowSprites(PM_WindowContext* windowContext)
{
	windowContext->framebuffer = PM_CreateBlankImage(PM_FRAMEBUFFER_WIDTH, PM_FRAMEBUFFER_HEIGHT);
	
	PM_BMP tilemapBMP = PM_OpenBMP("img/tilemap.bmp");
	PM_BMP levelBMP = PM_OpenBMP("img/level 1.bmp");

	windowContext->tilemapImage = PM_GetImage32(tilemapBMP);
	windowContext->levelImage = PM_GetImage32(levelBMP);

	PM_DrawLevel(windowContext->levelImage, windowContext->framebuffer, windowContext->tilemapImage, 0, 0);

	PM_DeleteBMP(tilemapBMP);
	PM_DeleteBMP(levelBMP);
}
