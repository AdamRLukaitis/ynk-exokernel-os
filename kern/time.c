#include <kern/time.h>
#include <inc/assert.h>
#include <kern/cpu.h>

static unsigned int ticks[NCPU];

void
time_init(void)
{
	unsigned int i;
	for(i=0;i<NCPU;i++)
		ticks[i]=0;
}

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(unsigned int c_no)
{
	ticks[c_no] = ticks[c_no]+1;
	if (ticks[c_no] * 10 < ticks[c_no])
		panic("time_tick: time overflowed");
}

unsigned int
time_msec(unsigned int c_no)
{
	return ticks[c_no] * 10;
}
