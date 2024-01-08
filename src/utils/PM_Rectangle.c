#include <utils/PM_Rectangle.h>

PM_Rectangle PM_RectangleInit(unsigned x, unsigned y, unsigned width, unsigned height)
{
	PM_Rectangle resultRectangle = {x,y,width,height};
	return resultRectangle;
}
