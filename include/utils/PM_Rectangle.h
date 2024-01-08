#ifndef __PM_RECTANGLE__
#define __PM_RECTANGLE__

typedef struct
{
	unsigned x, y, width, height;
} PM_Rectangle;

PM_Rectangle PM_RectangleInit(unsigned x, unsigned y, unsigned width, unsigned height);

#endif
