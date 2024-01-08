#ifndef __PM_CORE__
#define __PM_CORE__

#ifndef NOMINMAX
	#ifndef min
		#define min(a,b) ((a)<(b)?(a):(b))
	#endif

	#ifndef max
		#define max(a,b) ((a)>(b)?(a):(b))
	#endif
#endif

#define PM_UP    (0)
#define PM_RIGHT (1)
#define PM_DOWN  (2)
#define PM_LEFT  (3)

#define PM_OppositeDirection(d) ((d > 1) ? (d - 2) : (d + 2))

#endif
