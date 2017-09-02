#include <kern/e1000.h>
#include <kern/pmap.h>
#include <kern/sched.h>
struct transmit_descriptor e1000_transmit_descriptors[E1000_TX_DESCS] __attribute__ ((aligned(16)));
struct recieve_descriptor  e1000_recieve_descriptors[E1000_RX_DESCS];

void transmit_initalize()
{
	cprintf("Initializing e1000 tansmit queue\n");
	cprintf("Address of transmit_descriptor %08x\n",e1000_transmit_descriptors);
	e1000_bar0_addr[E1000_TDLEN] = E1000_TX_DESCS * sizeof(struct transmit_descriptor); //Number of descriptors x Size of each descriptor
	e1000_bar0_addr[E1000_TDH] = 0;
	e1000_bar0_addr[E1000_TDT] = 0;
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_EN;
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_PSP;
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_CT;
	e1000_bar0_addr[E1000_TCTL] = e1000_bar0_addr[E1000_TCTL] | E1000_TCTL_COLD;
	e1000_bar0_addr[E1000_TIPG] = 0x0;
	e1000_bar0_addr[E1000_TIPG] = 0xA;
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x4 << 10;
	e1000_bar0_addr[E1000_TIPG] = e1000_bar0_addr[E1000_TIPG] | 0x6 << 20;
	e1000_bar0_addr[E1000_TDBAL] = PADDR(e1000_transmit_descriptors);
	e1000_bar0_addr[E1000_TDBAH] = 0;
	uint32_t i;
	for(i=0;i<E1000_TX_DESCS;i++)
	{
		e1000_transmit_descriptors[i].buff_addr = PADDR(&send_packet[i]);
		e1000_transmit_descriptors[i].cmd = e1000_transmit_descriptors[i].cmd | 0x10011111;
		e1000_transmit_descriptors[i].status = e1000_transmit_descriptors[i].status | E1000_TXD_STAT_DD;
	}
	cprintf("Number of transmit_descriptors initialized are %d \n",i);
}

int transmit_packet(char *packet,int len)
{
	cprintf("Transmitting packet %s\n",packet);
	cprintf("Length is %d\n",len);
	if(strlen(packet) > E1000_TX_PKT_SIZE)
	{
		return -1;
	}
	uint32_t cur_tail = e1000_bar0_addr[E1000_TDT];
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == ~E1000_TXD_STAT_DD)
	{
		sched_yield();
	}
	if((e1000_transmit_descriptors[cur_tail].status & E1000_TXD_STAT_DD) == E1000_TXD_STAT_DD)
	{
		memmove((void*)&send_packet[cur_tail],packet,len);
		e1000_transmit_descriptors[cur_tail].length = len;
		e1000_transmit_descriptors[cur_tail].status = e1000_transmit_descriptors[cur_tail].status & 0;
		e1000_bar0_addr[E1000_TDT] = (cur_tail + 1 ) % E1000_TX_DESCS;
	}
	
	return 0;
}

void recieve_initalize()
{
	cprintf("Initializing E1000 recieve\n");
	e1000_bar0_addr[E1000_RA] = 0x12005452;
	e1000_bar0_addr[E1000_RA+1] = 0x5634;
	e1000_bar0_addr[E1000_RA+1] = e1000_bar0_addr[E1000_RA+1] | E1000_RAH_AV ;
	e1000_bar0_addr[E1000_MTA] = 0;
	e1000_bar0_addr[E1000_RDBAL] = PADDR(e1000_recieve_descriptors);
	e1000_bar0_addr[E1000_RDBAH] = 0;
	//e1000_bar0_addr[E1000_RCTL] = 0x4000002;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_EN;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_BAM;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_SZ_2048;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] | E1000_RCTL_SECRC;
	e1000_bar0_addr[E1000_RCTL] = e1000_bar0_addr[E1000_RCTL] & ~E1000_RCTL_LPE;
	e1000_bar0_addr[E1000_RDLEN] = E1000_RX_DESCS * sizeof(struct recieve_descriptor);
	e1000_bar0_addr[E1000_RDH] = 0;
	e1000_bar0_addr[E1000_RDT] = E1000_RX_DESCS -1;
	uint32_t i;
	cprintf("RCTL register value is %08x \n",e1000_bar0_addr[E1000_RCTL]);
	for(i=0;i<E1000_RX_DESCS;i++)
	{
		e1000_recieve_descriptors[i].buff_addr = PADDR(&recieve_packet[i]);
		e1000_recieve_descriptors[i].status  = 0;
	}

}

int recv_packet(char *data, int *len)
{
	uint32_t c_tail = (e1000_bar0_addr[E1000_RDT] + 1) % E1000_RX_DESCS;		
	if ((e1000_recieve_descriptors[c_tail].status & E1000_RXD_STAT_DD) != E1000_RXD_STAT_DD) 
		return -1;
	if ((e1000_recieve_descriptors[c_tail].status & E1000_RXD_STAT_DD) == E1000_RXD_STAT_DD) 
	{
	cprintf("Head is %d\n",e1000_bar0_addr[E1000_RDH]);
	cprintf("Tail is %d\n",c_tail);
	*len = e1000_recieve_descriptors[c_tail].length;
	memmove(data, recieve_packet[c_tail], *len);

	e1000_recieve_descriptors[c_tail].status &= 0;
	e1000_bar0_addr[E1000_RDT] = c_tail;
	}
return 0;
	
}
// LAB 6: Your driver code here
