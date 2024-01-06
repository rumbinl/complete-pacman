#include <bmp/PM_BMP.h>

int main(int argc, char* argv[])
{
	if(argc>1)
	{
		PM_BMP bmp = PM_OpenBMP(argv[1]);
	}
	return 0;
}
