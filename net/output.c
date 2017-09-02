#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";
	while(1)
	{
		sys_ipc_recv(&nsipcbuf);
		cprintf("From output.c length recieved is %d \n",nsipcbuf.pkt.jp_len);
		sys_e1000_transmit(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);
	}
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
}
