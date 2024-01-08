#ifndef __PM_WINDOWCONTEXT__
#define __PM_WINDOWCONTEXT__

#include <utils/PM_Rectangle.h>
#include <image/PM_Image.h>
#include <bmp/PM_BMP.h>
#include <pacman/PM_Tiles.h>
#include <limits.h>

#define PM_FRAMEBUFFER_WIDTH 224
#define PM_FRAMEBUFFER_HEIGHT 248

typedef struct 
{
#ifdef __APPLE__
	void* metalWindowState;
#endif
	PM_Image32 framebuffer, tilemapImage, levelImage;

} PM_WindowContext;

PM_WindowContext PM_CreateWindowContext(unsigned int windowWidth, unsigned int windowHeight);

void PM_SetupWindowSprites(PM_WindowContext* windowContext);

void PM_RunLoop(PM_WindowContext windowContext);

#endif
