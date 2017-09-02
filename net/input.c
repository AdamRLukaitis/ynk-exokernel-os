#include "ns.h"
#include <kern/e1000.h>
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
	int r ;
	binaryname = "ns_input";
	char data[2048];
	int len;
	while(1)
	{ 
		while(sys_e1000_recieve(data,&len)<0)
		{
			sys_yield();
		}
		int r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		while(r<0)
		{
		   cprintf("page alloc failed \n");
		  r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		}
		memcpy(nsipcbuf.pkt.jp_data,data,len);
		nsipcbuf.pkt.jp_len = len;
		while(sys_ipc_try_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P)<0);

	}


	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
}
