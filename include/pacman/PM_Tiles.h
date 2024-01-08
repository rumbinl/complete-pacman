#ifndef __PM_TILES__
#define __PM_TILES__

#include <utils/PM_Core.h>
#include <image/PM_Image.h>
#include <limits.h>

#define PM_GetX(x,w,d) ((d == PM_RIGHT) ? ((x+1)%w) : (d == PM_LEFT ? ((x+w-1)%w) : x))
#define PM_GetY(y,h,d) ((d == PM_DOWN ) ? ((y+1)%h) : (d == PM_UP   ? ((y+h-1)%h) : y))

#define PM_Normal(d) ((d+1)%4)

void PM_DrawLevel(PM_Image32 levelBlueprint, PM_Image32 outputImage, PM_Image32 tilemapImage, unsigned x, unsigned y);

void PM_TraceTileCluster_Algorithm1(PM_Image32 levelBlueprint, PM_Image32 tileHistoryMap, PM_Image32 tilemapImage, PM_Image32 outputImage, unsigned x, unsigned y, unsigned lastDirection);

unsigned PM_TileMatches(PM_Image32 levelBlueprint, unsigned x, unsigned y);

#endif
