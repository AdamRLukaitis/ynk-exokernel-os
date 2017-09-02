
obj/net/testoutput:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 10 03 00 00       	call   800341 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  80003b:	e8 65 0e 00 00       	call   800ea5 <sys_getenvid>
  800040:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  800042:	c7 05 00 40 80 00 a0 	movl   $0x802ca0,0x804000
  800049:	2c 80 00 

	output_envid = fork();
  80004c:	e8 c5 12 00 00       	call   801316 <fork>
  800051:	a3 00 50 80 00       	mov    %eax,0x805000
	if (output_envid < 0)
  800056:	85 c0                	test   %eax,%eax
  800058:	79 1c                	jns    800076 <umain+0x43>
		panic("error forking");
  80005a:	c7 44 24 08 ab 2c 80 	movl   $0x802cab,0x8(%esp)
  800061:	00 
  800062:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800069:	00 
  80006a:	c7 04 24 b9 2c 80 00 	movl   $0x802cb9,(%esp)
  800071:	e8 36 03 00 00       	call   8003ac <_panic>
	else if (output_envid == 0) {
  800076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80007b:	85 c0                	test   %eax,%eax
  80007d:	75 0d                	jne    80008c <umain+0x59>
		output(ns_envid);
  80007f:	89 34 24             	mov    %esi,(%esp)
  800082:	e8 72 02 00 00       	call   8002f9 <output>
		return;
  800087:	e9 c6 00 00 00       	jmp    800152 <umain+0x11f>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80009b:	0f 
  80009c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a3:	e8 3b 0e 00 00       	call   800ee3 <sys_page_alloc>
  8000a8:	85 c0                	test   %eax,%eax
  8000aa:	79 20                	jns    8000cc <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b0:	c7 44 24 08 ca 2c 80 	movl   $0x802cca,0x8(%esp)
  8000b7:	00 
  8000b8:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000bf:	00 
  8000c0:	c7 04 24 b9 2c 80 00 	movl   $0x802cb9,(%esp)
  8000c7:	e8 e0 02 00 00       	call   8003ac <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d0:	c7 44 24 08 dd 2c 80 	movl   $0x802cdd,0x8(%esp)
  8000d7:	00 
  8000d8:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000df:	00 
  8000e0:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000e7:	e8 6e 09 00 00       	call   800a5a <snprintf>
  8000ec:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000f1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000f5:	c7 04 24 e9 2c 80 00 	movl   $0x802ce9,(%esp)
  8000fc:	e8 a4 03 00 00       	call   8004a5 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800101:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800108:	00 
  800109:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800110:	0f 
  800111:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800118:	00 
  800119:	a1 00 50 80 00       	mov    0x805000,%eax
  80011e:	89 04 24             	mov    %eax,(%esp)
  800121:	e8 ad 14 00 00       	call   8015d3 <ipc_send>
		sys_page_unmap(0, pkt);
  800126:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80012d:	0f 
  80012e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800135:	e8 50 0e 00 00       	call   800f8a <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  80013a:	83 c3 01             	add    $0x1,%ebx
  80013d:	83 fb 0a             	cmp    $0xa,%ebx
  800140:	0f 85 46 ff ff ff    	jne    80008c <umain+0x59>
  800146:	b3 14                	mov    $0x14,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800148:	e8 77 0d 00 00       	call   800ec4 <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80014d:	83 eb 01             	sub    $0x1,%ebx
  800150:	75 f6                	jne    800148 <umain+0x115>
		sys_yield();
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	66 90                	xchg   %ax,%ax
  80015b:	66 90                	xchg   %ax,%ax
  80015d:	66 90                	xchg   %ax,%ax
  80015f:	90                   	nop

00800160 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800160:	55                   	push   %ebp
  800161:	89 e5                	mov    %esp,%ebp
  800163:	57                   	push   %edi
  800164:	56                   	push   %esi
  800165:	53                   	push   %ebx
  800166:	83 ec 2c             	sub    $0x2c,%esp
  800169:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	uint32_t stop = sys_time_msec() + initial_to;
  80016c:	e8 da 0f 00 00       	call   80114b <sys_time_msec>
  800171:	03 45 0c             	add    0xc(%ebp),%eax
  800174:	89 c6                	mov    %eax,%esi

	binaryname = "ns_timer";
  800176:	c7 05 00 40 80 00 01 	movl   $0x802d01,0x804000
  80017d:	2d 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800180:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800183:	eb 05                	jmp    80018a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
			sys_yield();
  800185:	e8 3a 0d 00 00       	call   800ec4 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while((r = sys_time_msec()) < stop && r >= 0) {
  80018a:	e8 bc 0f 00 00       	call   80114b <sys_time_msec>
  80018f:	39 c6                	cmp    %eax,%esi
  800191:	76 06                	jbe    800199 <timer+0x39>
  800193:	85 c0                	test   %eax,%eax
  800195:	79 ee                	jns    800185 <timer+0x25>
  800197:	eb 09                	jmp    8001a2 <timer+0x42>
			sys_yield();
		}
		if (r < 0)
  800199:	85 c0                	test   %eax,%eax
  80019b:	90                   	nop
  80019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8001a0:	79 20                	jns    8001c2 <timer+0x62>
			panic("sys_time_msec: %e", r);
  8001a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001a6:	c7 44 24 08 0a 2d 80 	movl   $0x802d0a,0x8(%esp)
  8001ad:	00 
  8001ae:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8001b5:	00 
  8001b6:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  8001bd:	e8 ea 01 00 00       	call   8003ac <_panic>

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001c2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001c9:	00 
  8001ca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001d1:	00 
  8001d2:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001d9:	00 
  8001da:	89 1c 24             	mov    %ebx,(%esp)
  8001dd:	e8 f1 13 00 00       	call   8015d3 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001e2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001e9:	00 
  8001ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001f1:	00 
  8001f2:	89 3c 24             	mov    %edi,(%esp)
  8001f5:	e8 6f 13 00 00       	call   801569 <ipc_recv>
  8001fa:	89 c6                	mov    %eax,%esi

			if (whom != ns_envid) {
  8001fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ff:	39 c3                	cmp    %eax,%ebx
  800201:	74 12                	je     800215 <timer+0xb5>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  80020e:	e8 92 02 00 00       	call   8004a5 <cprintf>
  800213:	eb cd                	jmp    8001e2 <timer+0x82>
				continue;
			}

			stop = sys_time_msec() + to;
  800215:	e8 31 0f 00 00       	call   80114b <sys_time_msec>
  80021a:	01 c6                	add    %eax,%esi
  80021c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800220:	e9 65 ff ff ff       	jmp    80018a <timer+0x2a>

00800225 <input>:
#include <kern/e1000.h>
extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	57                   	push   %edi
  800229:	56                   	push   %esi
  80022a:	53                   	push   %ebx
  80022b:	81 ec 2c 08 00 00    	sub    $0x82c,%esp
  800231:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r ;
	binaryname = "ns_input";
  800234:	c7 05 00 40 80 00 63 	movl   $0x802d63,0x804000
  80023b:	2d 80 00 
	char data[2048];
	int len;
	while(1)
	{ 
		while(sys_e1000_recieve(data,&len)<0)
  80023e:	8d bd e4 f7 ff ff    	lea    -0x81c(%ebp),%edi
  800244:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
  80024a:	eb 05                	jmp    800251 <input+0x2c>
		{
			sys_yield();
  80024c:	e8 73 0c 00 00       	call   800ec4 <sys_yield>
	binaryname = "ns_input";
	char data[2048];
	int len;
	while(1)
	{ 
		while(sys_e1000_recieve(data,&len)<0)
  800251:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800255:	89 34 24             	mov    %esi,(%esp)
  800258:	e8 60 0f 00 00       	call   8011bd <sys_e1000_recieve>
  80025d:	85 c0                	test   %eax,%eax
  80025f:	78 eb                	js     80024c <input+0x27>
		{
			sys_yield();
		}
		int r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
  800261:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800268:	00 
  800269:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  800270:	00 
  800271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800278:	e8 66 0c 00 00       	call   800ee3 <sys_page_alloc>
		while(r<0)
  80027d:	eb 28                	jmp    8002a7 <input+0x82>
		{
		   cprintf("page alloc failed \n");
  80027f:	c7 04 24 6c 2d 80 00 	movl   $0x802d6c,(%esp)
  800286:	e8 1a 02 00 00       	call   8004a5 <cprintf>
		  r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
  80028b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800292:	00 
  800293:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  80029a:	00 
  80029b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002a2:	e8 3c 0c 00 00       	call   800ee3 <sys_page_alloc>
		while(sys_e1000_recieve(data,&len)<0)
		{
			sys_yield();
		}
		int r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		while(r<0)
  8002a7:	85 c0                	test   %eax,%eax
  8002a9:	78 d4                	js     80027f <input+0x5a>
		{
		   cprintf("page alloc failed \n");
		  r = sys_page_alloc(0,&nsipcbuf,PTE_P|PTE_U|PTE_W);
		}
		memcpy(nsipcbuf.pkt.jp_data,data,len);
  8002ab:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  8002b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002b9:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  8002c0:	e8 07 0a 00 00       	call   800ccc <memcpy>
		nsipcbuf.pkt.jp_len = len;
  8002c5:	8b 85 e4 f7 ff ff    	mov    -0x81c(%ebp),%eax
  8002cb:	a3 00 70 86 00       	mov    %eax,0x867000
		while(sys_ipc_try_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P)<0);
  8002d0:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8002d7:	00 
  8002d8:	c7 44 24 08 00 70 86 	movl   $0x867000,0x8(%esp)
  8002df:	00 
  8002e0:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002e7:	00 
  8002e8:	89 1c 24             	mov    %ebx,(%esp)
  8002eb:	e8 e6 0d 00 00       	call   8010d6 <sys_ipc_try_send>
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	78 dc                	js     8002d0 <input+0xab>
  8002f4:	e9 58 ff ff ff       	jmp    800251 <input+0x2c>

008002f9 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 18             	sub    $0x18,%esp
	binaryname = "ns_output";
  8002ff:	c7 05 00 40 80 00 80 	movl   $0x802d80,0x804000
  800306:	2d 80 00 
	while(1)
	{
		sys_ipc_recv(&nsipcbuf);
  800309:	c7 04 24 00 70 86 00 	movl   $0x867000,(%esp)
  800310:	e8 e4 0d 00 00       	call   8010f9 <sys_ipc_recv>
		cprintf("From output.c length recieved is %d \n",nsipcbuf.pkt.jp_len);
  800315:	a1 00 70 86 00       	mov    0x867000,%eax
  80031a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031e:	c7 04 24 8c 2d 80 00 	movl   $0x802d8c,(%esp)
  800325:	e8 7b 01 00 00       	call   8004a5 <cprintf>
		sys_e1000_transmit(nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len);
  80032a:	a1 00 70 86 00       	mov    0x867000,%eax
  80032f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800333:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  80033a:	e8 2b 0e 00 00       	call   80116a <sys_e1000_transmit>
  80033f:	eb c8                	jmp    800309 <output+0x10>

00800341 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800341:	55                   	push   %ebp
  800342:	89 e5                	mov    %esp,%ebp
  800344:	56                   	push   %esi
  800345:	53                   	push   %ebx
  800346:	83 ec 10             	sub    $0x10,%esp
  800349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80034c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80034f:	c7 05 40 50 86 00 00 	movl   $0x0,0x865040
  800356:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800359:	e8 47 0b 00 00       	call   800ea5 <sys_getenvid>
  80035e:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800363:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800366:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80036b:	a3 40 50 86 00       	mov    %eax,0x865040


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800370:	85 db                	test   %ebx,%ebx
  800372:	7e 07                	jle    80037b <libmain+0x3a>
		binaryname = argv[0];
  800374:	8b 06                	mov    (%esi),%eax
  800376:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80037b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80037f:	89 1c 24             	mov    %ebx,(%esp)
  800382:	e8 ac fc ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800387:	e8 07 00 00 00       	call   800393 <exit>
}
  80038c:	83 c4 10             	add    $0x10,%esp
  80038f:	5b                   	pop    %ebx
  800390:	5e                   	pop    %esi
  800391:	5d                   	pop    %ebp
  800392:	c3                   	ret    

00800393 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800393:	55                   	push   %ebp
  800394:	89 e5                	mov    %esp,%ebp
  800396:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800399:	e8 ac 14 00 00       	call   80184a <close_all>
	sys_env_destroy(0);
  80039e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003a5:	e8 a9 0a 00 00       	call   800e53 <sys_env_destroy>
}
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	56                   	push   %esi
  8003b0:	53                   	push   %ebx
  8003b1:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8003b4:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8003b7:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8003bd:	e8 e3 0a 00 00       	call   800ea5 <sys_getenvid>
  8003c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c5:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003d0:	89 74 24 08          	mov    %esi,0x8(%esp)
  8003d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d8:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  8003df:	e8 c1 00 00 00       	call   8004a5 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8003e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	89 04 24             	mov    %eax,(%esp)
  8003ee:	e8 51 00 00 00       	call   800444 <vcprintf>
	cprintf("\n");
  8003f3:	c7 04 24 7e 2d 80 00 	movl   $0x802d7e,(%esp)
  8003fa:	e8 a6 00 00 00       	call   8004a5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003ff:	cc                   	int3   
  800400:	eb fd                	jmp    8003ff <_panic+0x53>

00800402 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	53                   	push   %ebx
  800406:	83 ec 14             	sub    $0x14,%esp
  800409:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80040c:	8b 13                	mov    (%ebx),%edx
  80040e:	8d 42 01             	lea    0x1(%edx),%eax
  800411:	89 03                	mov    %eax,(%ebx)
  800413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800416:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80041a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80041f:	75 19                	jne    80043a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800421:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800428:	00 
  800429:	8d 43 08             	lea    0x8(%ebx),%eax
  80042c:	89 04 24             	mov    %eax,(%esp)
  80042f:	e8 e2 09 00 00       	call   800e16 <sys_cputs>
		b->idx = 0;
  800434:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80043a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80043e:	83 c4 14             	add    $0x14,%esp
  800441:	5b                   	pop    %ebx
  800442:	5d                   	pop    %ebp
  800443:	c3                   	ret    

00800444 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80044d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800454:	00 00 00 
	b.cnt = 0;
  800457:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80045e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800468:	8b 45 08             	mov    0x8(%ebp),%eax
  80046b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80046f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800475:	89 44 24 04          	mov    %eax,0x4(%esp)
  800479:	c7 04 24 02 04 80 00 	movl   $0x800402,(%esp)
  800480:	e8 a9 01 00 00       	call   80062e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800485:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80048b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 79 09 00 00       	call   800e16 <sys_cputs>

	return b.cnt;
}
  80049d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004a3:	c9                   	leave  
  8004a4:	c3                   	ret    

008004a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004a5:	55                   	push   %ebp
  8004a6:	89 e5                	mov    %esp,%ebp
  8004a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8004ab:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8004ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b5:	89 04 24             	mov    %eax,(%esp)
  8004b8:	e8 87 ff ff ff       	call   800444 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004bd:	c9                   	leave  
  8004be:	c3                   	ret    
  8004bf:	90                   	nop

008004c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	57                   	push   %edi
  8004c4:	56                   	push   %esi
  8004c5:	53                   	push   %ebx
  8004c6:	83 ec 3c             	sub    $0x3c,%esp
  8004c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004cc:	89 d7                	mov    %edx,%edi
  8004ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d7:	89 c3                	mov    %eax,%ebx
  8004d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8004dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8004df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004ed:	39 d9                	cmp    %ebx,%ecx
  8004ef:	72 05                	jb     8004f6 <printnum+0x36>
  8004f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004f4:	77 69                	ja     80055f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8004f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8004fd:	83 ee 01             	sub    $0x1,%esi
  800500:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800504:	89 44 24 08          	mov    %eax,0x8(%esp)
  800508:	8b 44 24 08          	mov    0x8(%esp),%eax
  80050c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800510:	89 c3                	mov    %eax,%ebx
  800512:	89 d6                	mov    %edx,%esi
  800514:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800517:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80051a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80051e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800522:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800525:	89 04 24             	mov    %eax,(%esp)
  800528:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80052b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052f:	e8 cc 24 00 00       	call   802a00 <__udivdi3>
  800534:	89 d9                	mov    %ebx,%ecx
  800536:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80053a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	89 54 24 04          	mov    %edx,0x4(%esp)
  800545:	89 fa                	mov    %edi,%edx
  800547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80054a:	e8 71 ff ff ff       	call   8004c0 <printnum>
  80054f:	eb 1b                	jmp    80056c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800551:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800555:	8b 45 18             	mov    0x18(%ebp),%eax
  800558:	89 04 24             	mov    %eax,(%esp)
  80055b:	ff d3                	call   *%ebx
  80055d:	eb 03                	jmp    800562 <printnum+0xa2>
  80055f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800562:	83 ee 01             	sub    $0x1,%esi
  800565:	85 f6                	test   %esi,%esi
  800567:	7f e8                	jg     800551 <printnum+0x91>
  800569:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80056c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800570:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800574:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800577:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80057a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80057e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800582:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800585:	89 04 24             	mov    %eax,(%esp)
  800588:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80058b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058f:	e8 9c 25 00 00       	call   802b30 <__umoddi3>
  800594:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800598:	0f be 80 df 2d 80 00 	movsbl 0x802ddf(%eax),%eax
  80059f:	89 04 24             	mov    %eax,(%esp)
  8005a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a5:	ff d0                	call   *%eax
}
  8005a7:	83 c4 3c             	add    $0x3c,%esp
  8005aa:	5b                   	pop    %ebx
  8005ab:	5e                   	pop    %esi
  8005ac:	5f                   	pop    %edi
  8005ad:	5d                   	pop    %ebp
  8005ae:	c3                   	ret    

008005af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005b2:	83 fa 01             	cmp    $0x1,%edx
  8005b5:	7e 0e                	jle    8005c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005b7:	8b 10                	mov    (%eax),%edx
  8005b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005bc:	89 08                	mov    %ecx,(%eax)
  8005be:	8b 02                	mov    (%edx),%eax
  8005c0:	8b 52 04             	mov    0x4(%edx),%edx
  8005c3:	eb 22                	jmp    8005e7 <getuint+0x38>
	else if (lflag)
  8005c5:	85 d2                	test   %edx,%edx
  8005c7:	74 10                	je     8005d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005ce:	89 08                	mov    %ecx,(%eax)
  8005d0:	8b 02                	mov    (%edx),%eax
  8005d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d7:	eb 0e                	jmp    8005e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005d9:	8b 10                	mov    (%eax),%edx
  8005db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005de:	89 08                	mov    %ecx,(%eax)
  8005e0:	8b 02                	mov    (%edx),%eax
  8005e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005e7:	5d                   	pop    %ebp
  8005e8:	c3                   	ret    

008005e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005f3:	8b 10                	mov    (%eax),%edx
  8005f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8005f8:	73 0a                	jae    800604 <sprintputch+0x1b>
		*b->buf++ = ch;
  8005fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005fd:	89 08                	mov    %ecx,(%eax)
  8005ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800602:	88 02                	mov    %al,(%edx)
}
  800604:	5d                   	pop    %ebp
  800605:	c3                   	ret    

00800606 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80060c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80060f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800613:	8b 45 10             	mov    0x10(%ebp),%eax
  800616:	89 44 24 08          	mov    %eax,0x8(%esp)
  80061a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	89 04 24             	mov    %eax,(%esp)
  800627:	e8 02 00 00 00       	call   80062e <vprintfmt>
	va_end(ap);
}
  80062c:	c9                   	leave  
  80062d:	c3                   	ret    

0080062e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80062e:	55                   	push   %ebp
  80062f:	89 e5                	mov    %esp,%ebp
  800631:	57                   	push   %edi
  800632:	56                   	push   %esi
  800633:	53                   	push   %ebx
  800634:	83 ec 3c             	sub    $0x3c,%esp
  800637:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80063a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80063d:	eb 14                	jmp    800653 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80063f:	85 c0                	test   %eax,%eax
  800641:	0f 84 b3 03 00 00    	je     8009fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	89 04 24             	mov    %eax,(%esp)
  80064e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800651:	89 f3                	mov    %esi,%ebx
  800653:	8d 73 01             	lea    0x1(%ebx),%esi
  800656:	0f b6 03             	movzbl (%ebx),%eax
  800659:	83 f8 25             	cmp    $0x25,%eax
  80065c:	75 e1                	jne    80063f <vprintfmt+0x11>
  80065e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800662:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800669:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800670:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800677:	ba 00 00 00 00       	mov    $0x0,%edx
  80067c:	eb 1d                	jmp    80069b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800680:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800684:	eb 15                	jmp    80069b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800686:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800688:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80068c:	eb 0d                	jmp    80069b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80068e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800691:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800694:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80069e:	0f b6 0e             	movzbl (%esi),%ecx
  8006a1:	0f b6 c1             	movzbl %cl,%eax
  8006a4:	83 e9 23             	sub    $0x23,%ecx
  8006a7:	80 f9 55             	cmp    $0x55,%cl
  8006aa:	0f 87 2a 03 00 00    	ja     8009da <vprintfmt+0x3ac>
  8006b0:	0f b6 c9             	movzbl %cl,%ecx
  8006b3:	ff 24 8d 20 2f 80 00 	jmp    *0x802f20(,%ecx,4)
  8006ba:	89 de                	mov    %ebx,%esi
  8006bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8006c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8006cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8006ce:	83 fb 09             	cmp    $0x9,%ebx
  8006d1:	77 36                	ja     800709 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006d6:	eb e9                	jmp    8006c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006db:	8d 48 04             	lea    0x4(%eax),%ecx
  8006de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8006e8:	eb 22                	jmp    80070c <vprintfmt+0xde>
  8006ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8006ed:	85 c9                	test   %ecx,%ecx
  8006ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f4:	0f 49 c1             	cmovns %ecx,%eax
  8006f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006fa:	89 de                	mov    %ebx,%esi
  8006fc:	eb 9d                	jmp    80069b <vprintfmt+0x6d>
  8006fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800700:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800707:	eb 92                	jmp    80069b <vprintfmt+0x6d>
  800709:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80070c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800710:	79 89                	jns    80069b <vprintfmt+0x6d>
  800712:	e9 77 ff ff ff       	jmp    80068e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800717:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80071c:	e9 7a ff ff ff       	jmp    80069b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800721:	8b 45 14             	mov    0x14(%ebp),%eax
  800724:	8d 50 04             	lea    0x4(%eax),%edx
  800727:	89 55 14             	mov    %edx,0x14(%ebp)
  80072a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	89 04 24             	mov    %eax,(%esp)
  800733:	ff 55 08             	call   *0x8(%ebp)
			break;
  800736:	e9 18 ff ff ff       	jmp    800653 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80073b:	8b 45 14             	mov    0x14(%ebp),%eax
  80073e:	8d 50 04             	lea    0x4(%eax),%edx
  800741:	89 55 14             	mov    %edx,0x14(%ebp)
  800744:	8b 00                	mov    (%eax),%eax
  800746:	99                   	cltd   
  800747:	31 d0                	xor    %edx,%eax
  800749:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80074b:	83 f8 0f             	cmp    $0xf,%eax
  80074e:	7f 0b                	jg     80075b <vprintfmt+0x12d>
  800750:	8b 14 85 80 30 80 00 	mov    0x803080(,%eax,4),%edx
  800757:	85 d2                	test   %edx,%edx
  800759:	75 20                	jne    80077b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80075b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80075f:	c7 44 24 08 f7 2d 80 	movl   $0x802df7,0x8(%esp)
  800766:	00 
  800767:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	89 04 24             	mov    %eax,(%esp)
  800771:	e8 90 fe ff ff       	call   800606 <printfmt>
  800776:	e9 d8 fe ff ff       	jmp    800653 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80077b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80077f:	c7 44 24 08 45 33 80 	movl   $0x803345,0x8(%esp)
  800786:	00 
  800787:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	e8 70 fe ff ff       	call   800606 <printfmt>
  800796:	e9 b8 fe ff ff       	jmp    800653 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80079e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 50 04             	lea    0x4(%eax),%edx
  8007aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8007af:	85 f6                	test   %esi,%esi
  8007b1:	b8 f0 2d 80 00       	mov    $0x802df0,%eax
  8007b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8007b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8007bd:	0f 84 97 00 00 00    	je     80085a <vprintfmt+0x22c>
  8007c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007c7:	0f 8e 9b 00 00 00    	jle    800868 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d1:	89 34 24             	mov    %esi,(%esp)
  8007d4:	e8 cf 02 00 00       	call   800aa8 <strnlen>
  8007d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007dc:	29 c2                	sub    %eax,%edx
  8007de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8007e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8007e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8007eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8007ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8007f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007f3:	eb 0f                	jmp    800804 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8007f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fc:	89 04 24             	mov    %eax,(%esp)
  8007ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800801:	83 eb 01             	sub    $0x1,%ebx
  800804:	85 db                	test   %ebx,%ebx
  800806:	7f ed                	jg     8007f5 <vprintfmt+0x1c7>
  800808:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80080b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80080e:	85 d2                	test   %edx,%edx
  800810:	b8 00 00 00 00       	mov    $0x0,%eax
  800815:	0f 49 c2             	cmovns %edx,%eax
  800818:	29 c2                	sub    %eax,%edx
  80081a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80081d:	89 d7                	mov    %edx,%edi
  80081f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800822:	eb 50                	jmp    800874 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800824:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800828:	74 1e                	je     800848 <vprintfmt+0x21a>
  80082a:	0f be d2             	movsbl %dl,%edx
  80082d:	83 ea 20             	sub    $0x20,%edx
  800830:	83 fa 5e             	cmp    $0x5e,%edx
  800833:	76 13                	jbe    800848 <vprintfmt+0x21a>
					putch('?', putdat);
  800835:	8b 45 0c             	mov    0xc(%ebp),%eax
  800838:	89 44 24 04          	mov    %eax,0x4(%esp)
  80083c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800843:	ff 55 08             	call   *0x8(%ebp)
  800846:	eb 0d                	jmp    800855 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800848:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800855:	83 ef 01             	sub    $0x1,%edi
  800858:	eb 1a                	jmp    800874 <vprintfmt+0x246>
  80085a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80085d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800860:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800863:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800866:	eb 0c                	jmp    800874 <vprintfmt+0x246>
  800868:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80086b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80086e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800871:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800874:	83 c6 01             	add    $0x1,%esi
  800877:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80087b:	0f be c2             	movsbl %dl,%eax
  80087e:	85 c0                	test   %eax,%eax
  800880:	74 27                	je     8008a9 <vprintfmt+0x27b>
  800882:	85 db                	test   %ebx,%ebx
  800884:	78 9e                	js     800824 <vprintfmt+0x1f6>
  800886:	83 eb 01             	sub    $0x1,%ebx
  800889:	79 99                	jns    800824 <vprintfmt+0x1f6>
  80088b:	89 f8                	mov    %edi,%eax
  80088d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800890:	8b 75 08             	mov    0x8(%ebp),%esi
  800893:	89 c3                	mov    %eax,%ebx
  800895:	eb 1a                	jmp    8008b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800897:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80089b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008a4:	83 eb 01             	sub    $0x1,%ebx
  8008a7:	eb 08                	jmp    8008b1 <vprintfmt+0x283>
  8008a9:	89 fb                	mov    %edi,%ebx
  8008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8008b1:	85 db                	test   %ebx,%ebx
  8008b3:	7f e2                	jg     800897 <vprintfmt+0x269>
  8008b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8008b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008bb:	e9 93 fd ff ff       	jmp    800653 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008c0:	83 fa 01             	cmp    $0x1,%edx
  8008c3:	7e 16                	jle    8008db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8008c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c8:	8d 50 08             	lea    0x8(%eax),%edx
  8008cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008d9:	eb 32                	jmp    80090d <vprintfmt+0x2df>
	else if (lflag)
  8008db:	85 d2                	test   %edx,%edx
  8008dd:	74 18                	je     8008f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	8d 50 04             	lea    0x4(%eax),%edx
  8008e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e8:	8b 30                	mov    (%eax),%esi
  8008ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8008ed:	89 f0                	mov    %esi,%eax
  8008ef:	c1 f8 1f             	sar    $0x1f,%eax
  8008f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f5:	eb 16                	jmp    80090d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8008f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008fa:	8d 50 04             	lea    0x4(%eax),%edx
  8008fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800900:	8b 30                	mov    (%eax),%esi
  800902:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800905:	89 f0                	mov    %esi,%eax
  800907:	c1 f8 1f             	sar    $0x1f,%eax
  80090a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80090d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800913:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800918:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091c:	0f 89 80 00 00 00    	jns    8009a2 <vprintfmt+0x374>
				putch('-', putdat);
  800922:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800926:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80092d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800930:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800933:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800936:	f7 d8                	neg    %eax
  800938:	83 d2 00             	adc    $0x0,%edx
  80093b:	f7 da                	neg    %edx
			}
			base = 10;
  80093d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800942:	eb 5e                	jmp    8009a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800944:	8d 45 14             	lea    0x14(%ebp),%eax
  800947:	e8 63 fc ff ff       	call   8005af <getuint>
			base = 10;
  80094c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800951:	eb 4f                	jmp    8009a2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800953:	8d 45 14             	lea    0x14(%ebp),%eax
  800956:	e8 54 fc ff ff       	call   8005af <getuint>
			base =8;
  80095b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800960:	eb 40                	jmp    8009a2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800962:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800966:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80096d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800970:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800974:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80097b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80097e:	8b 45 14             	mov    0x14(%ebp),%eax
  800981:	8d 50 04             	lea    0x4(%eax),%edx
  800984:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800987:	8b 00                	mov    (%eax),%eax
  800989:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80098e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800993:	eb 0d                	jmp    8009a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800995:	8d 45 14             	lea    0x14(%ebp),%eax
  800998:	e8 12 fc ff ff       	call   8005af <getuint>
			base = 16;
  80099d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8009a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8009aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8009ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8009b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8009b5:	89 04 24             	mov    %eax,(%esp)
  8009b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009bc:	89 fa                	mov    %edi,%edx
  8009be:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c1:	e8 fa fa ff ff       	call   8004c0 <printnum>
			break;
  8009c6:	e9 88 fc ff ff       	jmp    800653 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009cf:	89 04 24             	mov    %eax,(%esp)
  8009d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8009d5:	e9 79 fc ff ff       	jmp    800653 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8009de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009e8:	89 f3                	mov    %esi,%ebx
  8009ea:	eb 03                	jmp    8009ef <vprintfmt+0x3c1>
  8009ec:	83 eb 01             	sub    $0x1,%ebx
  8009ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8009f3:	75 f7                	jne    8009ec <vprintfmt+0x3be>
  8009f5:	e9 59 fc ff ff       	jmp    800653 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8009fa:	83 c4 3c             	add    $0x3c,%esp
  8009fd:	5b                   	pop    %ebx
  8009fe:	5e                   	pop    %esi
  8009ff:	5f                   	pop    %edi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    

00800a02 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a02:	55                   	push   %ebp
  800a03:	89 e5                	mov    %esp,%ebp
  800a05:	83 ec 28             	sub    $0x28,%esp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a0e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a11:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a15:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a1f:	85 c0                	test   %eax,%eax
  800a21:	74 30                	je     800a53 <vsnprintf+0x51>
  800a23:	85 d2                	test   %edx,%edx
  800a25:	7e 2c                	jle    800a53 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a27:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a31:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a35:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3c:	c7 04 24 e9 05 80 00 	movl   $0x8005e9,(%esp)
  800a43:	e8 e6 fb ff ff       	call   80062e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a48:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a4b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a51:	eb 05                	jmp    800a58 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800a53:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800a60:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800a63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a67:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	89 04 24             	mov    %eax,(%esp)
  800a7b:	e8 82 ff ff ff       	call   800a02 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    
  800a82:	66 90                	xchg   %ax,%ax
  800a84:	66 90                	xchg   %ax,%ax
  800a86:	66 90                	xchg   %ax,%ax
  800a88:	66 90                	xchg   %ax,%ax
  800a8a:	66 90                	xchg   %ax,%ax
  800a8c:	66 90                	xchg   %ax,%ax
  800a8e:	66 90                	xchg   %ax,%ax

00800a90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	eb 03                	jmp    800aa0 <strlen+0x10>
		n++;
  800a9d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa4:	75 f7                	jne    800a9d <strlen+0xd>
		n++;
	return n;
}
  800aa6:	5d                   	pop    %ebp
  800aa7:	c3                   	ret    

00800aa8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aa8:	55                   	push   %ebp
  800aa9:	89 e5                	mov    %esp,%ebp
  800aab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800aae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab6:	eb 03                	jmp    800abb <strnlen+0x13>
		n++;
  800ab8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800abb:	39 d0                	cmp    %edx,%eax
  800abd:	74 06                	je     800ac5 <strnlen+0x1d>
  800abf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800ac3:	75 f3                	jne    800ab8 <strnlen+0x10>
		n++;
	return n;
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	53                   	push   %ebx
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ad1:	89 c2                	mov    %eax,%edx
  800ad3:	83 c2 01             	add    $0x1,%edx
  800ad6:	83 c1 01             	add    $0x1,%ecx
  800ad9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  800add:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ae0:	84 db                	test   %bl,%bl
  800ae2:	75 ef                	jne    800ad3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ae4:	5b                   	pop    %ebx
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	53                   	push   %ebx
  800aeb:	83 ec 08             	sub    $0x8,%esp
  800aee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800af1:	89 1c 24             	mov    %ebx,(%esp)
  800af4:	e8 97 ff ff ff       	call   800a90 <strlen>
	strcpy(dst + len, src);
  800af9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800afc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800b00:	01 d8                	add    %ebx,%eax
  800b02:	89 04 24             	mov    %eax,(%esp)
  800b05:	e8 bd ff ff ff       	call   800ac7 <strcpy>
	return dst;
}
  800b0a:	89 d8                	mov    %ebx,%eax
  800b0c:	83 c4 08             	add    $0x8,%esp
  800b0f:	5b                   	pop    %ebx
  800b10:	5d                   	pop    %ebp
  800b11:	c3                   	ret    

00800b12 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b12:	55                   	push   %ebp
  800b13:	89 e5                	mov    %esp,%ebp
  800b15:	56                   	push   %esi
  800b16:	53                   	push   %ebx
  800b17:	8b 75 08             	mov    0x8(%ebp),%esi
  800b1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1d:	89 f3                	mov    %esi,%ebx
  800b1f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b22:	89 f2                	mov    %esi,%edx
  800b24:	eb 0f                	jmp    800b35 <strncpy+0x23>
		*dst++ = *src;
  800b26:	83 c2 01             	add    $0x1,%edx
  800b29:	0f b6 01             	movzbl (%ecx),%eax
  800b2c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b2f:	80 39 01             	cmpb   $0x1,(%ecx)
  800b32:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b35:	39 da                	cmp    %ebx,%edx
  800b37:	75 ed                	jne    800b26 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b39:	89 f0                	mov    %esi,%eax
  800b3b:	5b                   	pop    %ebx
  800b3c:	5e                   	pop    %esi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	56                   	push   %esi
  800b43:	53                   	push   %ebx
  800b44:	8b 75 08             	mov    0x8(%ebp),%esi
  800b47:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800b4d:	89 f0                	mov    %esi,%eax
  800b4f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b53:	85 c9                	test   %ecx,%ecx
  800b55:	75 0b                	jne    800b62 <strlcpy+0x23>
  800b57:	eb 1d                	jmp    800b76 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800b59:	83 c0 01             	add    $0x1,%eax
  800b5c:	83 c2 01             	add    $0x1,%edx
  800b5f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b62:	39 d8                	cmp    %ebx,%eax
  800b64:	74 0b                	je     800b71 <strlcpy+0x32>
  800b66:	0f b6 0a             	movzbl (%edx),%ecx
  800b69:	84 c9                	test   %cl,%cl
  800b6b:	75 ec                	jne    800b59 <strlcpy+0x1a>
  800b6d:	89 c2                	mov    %eax,%edx
  800b6f:	eb 02                	jmp    800b73 <strlcpy+0x34>
  800b71:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800b73:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800b76:	29 f0                	sub    %esi,%eax
}
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b82:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b85:	eb 06                	jmp    800b8d <strcmp+0x11>
		p++, q++;
  800b87:	83 c1 01             	add    $0x1,%ecx
  800b8a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b8d:	0f b6 01             	movzbl (%ecx),%eax
  800b90:	84 c0                	test   %al,%al
  800b92:	74 04                	je     800b98 <strcmp+0x1c>
  800b94:	3a 02                	cmp    (%edx),%al
  800b96:	74 ef                	je     800b87 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b98:	0f b6 c0             	movzbl %al,%eax
  800b9b:	0f b6 12             	movzbl (%edx),%edx
  800b9e:	29 d0                	sub    %edx,%eax
}
  800ba0:	5d                   	pop    %ebp
  800ba1:	c3                   	ret    

00800ba2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	53                   	push   %ebx
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bac:	89 c3                	mov    %eax,%ebx
  800bae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bb1:	eb 06                	jmp    800bb9 <strncmp+0x17>
		n--, p++, q++;
  800bb3:	83 c0 01             	add    $0x1,%eax
  800bb6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bb9:	39 d8                	cmp    %ebx,%eax
  800bbb:	74 15                	je     800bd2 <strncmp+0x30>
  800bbd:	0f b6 08             	movzbl (%eax),%ecx
  800bc0:	84 c9                	test   %cl,%cl
  800bc2:	74 04                	je     800bc8 <strncmp+0x26>
  800bc4:	3a 0a                	cmp    (%edx),%cl
  800bc6:	74 eb                	je     800bb3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bc8:	0f b6 00             	movzbl (%eax),%eax
  800bcb:	0f b6 12             	movzbl (%edx),%edx
  800bce:	29 d0                	sub    %edx,%eax
  800bd0:	eb 05                	jmp    800bd7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800bd2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bd7:	5b                   	pop    %ebx
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800be0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be4:	eb 07                	jmp    800bed <strchr+0x13>
		if (*s == c)
  800be6:	38 ca                	cmp    %cl,%dl
  800be8:	74 0f                	je     800bf9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	0f b6 10             	movzbl (%eax),%edx
  800bf0:	84 d2                	test   %dl,%dl
  800bf2:	75 f2                	jne    800be6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800c01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c05:	eb 07                	jmp    800c0e <strfind+0x13>
		if (*s == c)
  800c07:	38 ca                	cmp    %cl,%dl
  800c09:	74 0a                	je     800c15 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c0b:	83 c0 01             	add    $0x1,%eax
  800c0e:	0f b6 10             	movzbl (%eax),%edx
  800c11:	84 d2                	test   %dl,%dl
  800c13:	75 f2                	jne    800c07 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800c15:	5d                   	pop    %ebp
  800c16:	c3                   	ret    

00800c17 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c17:	55                   	push   %ebp
  800c18:	89 e5                	mov    %esp,%ebp
  800c1a:	57                   	push   %edi
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c20:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c23:	85 c9                	test   %ecx,%ecx
  800c25:	74 36                	je     800c5d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c27:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c2d:	75 28                	jne    800c57 <memset+0x40>
  800c2f:	f6 c1 03             	test   $0x3,%cl
  800c32:	75 23                	jne    800c57 <memset+0x40>
		c &= 0xFF;
  800c34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c38:	89 d3                	mov    %edx,%ebx
  800c3a:	c1 e3 08             	shl    $0x8,%ebx
  800c3d:	89 d6                	mov    %edx,%esi
  800c3f:	c1 e6 18             	shl    $0x18,%esi
  800c42:	89 d0                	mov    %edx,%eax
  800c44:	c1 e0 10             	shl    $0x10,%eax
  800c47:	09 f0                	or     %esi,%eax
  800c49:	09 c2                	or     %eax,%edx
  800c4b:	89 d0                	mov    %edx,%eax
  800c4d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800c4f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800c52:	fc                   	cld    
  800c53:	f3 ab                	rep stos %eax,%es:(%edi)
  800c55:	eb 06                	jmp    800c5d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	fc                   	cld    
  800c5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c5d:	89 f8                	mov    %edi,%eax
  800c5f:	5b                   	pop    %ebx
  800c60:	5e                   	pop    %esi
  800c61:	5f                   	pop    %edi
  800c62:	5d                   	pop    %ebp
  800c63:	c3                   	ret    

00800c64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c64:	55                   	push   %ebp
  800c65:	89 e5                	mov    %esp,%ebp
  800c67:	57                   	push   %edi
  800c68:	56                   	push   %esi
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c72:	39 c6                	cmp    %eax,%esi
  800c74:	73 35                	jae    800cab <memmove+0x47>
  800c76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c79:	39 d0                	cmp    %edx,%eax
  800c7b:	73 2e                	jae    800cab <memmove+0x47>
		s += n;
		d += n;
  800c7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800c80:	89 d6                	mov    %edx,%esi
  800c82:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c84:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c8a:	75 13                	jne    800c9f <memmove+0x3b>
  800c8c:	f6 c1 03             	test   $0x3,%cl
  800c8f:	75 0e                	jne    800c9f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800c91:	83 ef 04             	sub    $0x4,%edi
  800c94:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c97:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800c9a:	fd                   	std    
  800c9b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800c9d:	eb 09                	jmp    800ca8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800c9f:	83 ef 01             	sub    $0x1,%edi
  800ca2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ca5:	fd                   	std    
  800ca6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ca8:	fc                   	cld    
  800ca9:	eb 1d                	jmp    800cc8 <memmove+0x64>
  800cab:	89 f2                	mov    %esi,%edx
  800cad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800caf:	f6 c2 03             	test   $0x3,%dl
  800cb2:	75 0f                	jne    800cc3 <memmove+0x5f>
  800cb4:	f6 c1 03             	test   $0x3,%cl
  800cb7:	75 0a                	jne    800cc3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cb9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800cbc:	89 c7                	mov    %eax,%edi
  800cbe:	fc                   	cld    
  800cbf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cc1:	eb 05                	jmp    800cc8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800cc3:	89 c7                	mov    %eax,%edi
  800cc5:	fc                   	cld    
  800cc6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
  800ccf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce3:	89 04 24             	mov    %eax,(%esp)
  800ce6:	e8 79 ff ff ff       	call   800c64 <memmove>
}
  800ceb:	c9                   	leave  
  800cec:	c3                   	ret    

00800ced <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	56                   	push   %esi
  800cf1:	53                   	push   %ebx
  800cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	89 d6                	mov    %edx,%esi
  800cfa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cfd:	eb 1a                	jmp    800d19 <memcmp+0x2c>
		if (*s1 != *s2)
  800cff:	0f b6 02             	movzbl (%edx),%eax
  800d02:	0f b6 19             	movzbl (%ecx),%ebx
  800d05:	38 d8                	cmp    %bl,%al
  800d07:	74 0a                	je     800d13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800d09:	0f b6 c0             	movzbl %al,%eax
  800d0c:	0f b6 db             	movzbl %bl,%ebx
  800d0f:	29 d8                	sub    %ebx,%eax
  800d11:	eb 0f                	jmp    800d22 <memcmp+0x35>
		s1++, s2++;
  800d13:	83 c2 01             	add    $0x1,%edx
  800d16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d19:	39 f2                	cmp    %esi,%edx
  800d1b:	75 e2                	jne    800cff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d2f:	89 c2                	mov    %eax,%edx
  800d31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d34:	eb 07                	jmp    800d3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d36:	38 08                	cmp    %cl,(%eax)
  800d38:	74 07                	je     800d41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	39 d0                	cmp    %edx,%eax
  800d3f:	72 f5                	jb     800d36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d41:	5d                   	pop    %ebp
  800d42:	c3                   	ret    

00800d43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	57                   	push   %edi
  800d47:	56                   	push   %esi
  800d48:	53                   	push   %ebx
  800d49:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d4f:	eb 03                	jmp    800d54 <strtol+0x11>
		s++;
  800d51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d54:	0f b6 0a             	movzbl (%edx),%ecx
  800d57:	80 f9 09             	cmp    $0x9,%cl
  800d5a:	74 f5                	je     800d51 <strtol+0xe>
  800d5c:	80 f9 20             	cmp    $0x20,%cl
  800d5f:	74 f0                	je     800d51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d61:	80 f9 2b             	cmp    $0x2b,%cl
  800d64:	75 0a                	jne    800d70 <strtol+0x2d>
		s++;
  800d66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800d69:	bf 00 00 00 00       	mov    $0x0,%edi
  800d6e:	eb 11                	jmp    800d81 <strtol+0x3e>
  800d70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800d75:	80 f9 2d             	cmp    $0x2d,%cl
  800d78:	75 07                	jne    800d81 <strtol+0x3e>
		s++, neg = 1;
  800d7a:	8d 52 01             	lea    0x1(%edx),%edx
  800d7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800d86:	75 15                	jne    800d9d <strtol+0x5a>
  800d88:	80 3a 30             	cmpb   $0x30,(%edx)
  800d8b:	75 10                	jne    800d9d <strtol+0x5a>
  800d8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d91:	75 0a                	jne    800d9d <strtol+0x5a>
		s += 2, base = 16;
  800d93:	83 c2 02             	add    $0x2,%edx
  800d96:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9b:	eb 10                	jmp    800dad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800d9d:	85 c0                	test   %eax,%eax
  800d9f:	75 0c                	jne    800dad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800da1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800da3:	80 3a 30             	cmpb   $0x30,(%edx)
  800da6:	75 05                	jne    800dad <strtol+0x6a>
		s++, base = 8;
  800da8:	83 c2 01             	add    $0x1,%edx
  800dab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800dad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800db2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800db5:	0f b6 0a             	movzbl (%edx),%ecx
  800db8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800dbb:	89 f0                	mov    %esi,%eax
  800dbd:	3c 09                	cmp    $0x9,%al
  800dbf:	77 08                	ja     800dc9 <strtol+0x86>
			dig = *s - '0';
  800dc1:	0f be c9             	movsbl %cl,%ecx
  800dc4:	83 e9 30             	sub    $0x30,%ecx
  800dc7:	eb 20                	jmp    800de9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800dc9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800dcc:	89 f0                	mov    %esi,%eax
  800dce:	3c 19                	cmp    $0x19,%al
  800dd0:	77 08                	ja     800dda <strtol+0x97>
			dig = *s - 'a' + 10;
  800dd2:	0f be c9             	movsbl %cl,%ecx
  800dd5:	83 e9 57             	sub    $0x57,%ecx
  800dd8:	eb 0f                	jmp    800de9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800dda:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800ddd:	89 f0                	mov    %esi,%eax
  800ddf:	3c 19                	cmp    $0x19,%al
  800de1:	77 16                	ja     800df9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800de3:	0f be c9             	movsbl %cl,%ecx
  800de6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800de9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800dec:	7d 0f                	jge    800dfd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800dee:	83 c2 01             	add    $0x1,%edx
  800df1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800df5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800df7:	eb bc                	jmp    800db5 <strtol+0x72>
  800df9:	89 d8                	mov    %ebx,%eax
  800dfb:	eb 02                	jmp    800dff <strtol+0xbc>
  800dfd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800dff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e03:	74 05                	je     800e0a <strtol+0xc7>
		*endptr = (char *) s;
  800e05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800e0a:	f7 d8                	neg    %eax
  800e0c:	85 ff                	test   %edi,%edi
  800e0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800e11:	5b                   	pop    %ebx
  800e12:	5e                   	pop    %esi
  800e13:	5f                   	pop    %edi
  800e14:	5d                   	pop    %ebp
  800e15:	c3                   	ret    

00800e16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e16:	55                   	push   %ebp
  800e17:	89 e5                	mov    %esp,%ebp
  800e19:	57                   	push   %edi
  800e1a:	56                   	push   %esi
  800e1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	89 c3                	mov    %eax,%ebx
  800e29:	89 c7                	mov    %eax,%edi
  800e2b:	89 c6                	mov    %eax,%esi
  800e2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e2f:	5b                   	pop    %ebx
  800e30:	5e                   	pop    %esi
  800e31:	5f                   	pop    %edi
  800e32:	5d                   	pop    %ebp
  800e33:	c3                   	ret    

00800e34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800e44:	89 d1                	mov    %edx,%ecx
  800e46:	89 d3                	mov    %edx,%ebx
  800e48:	89 d7                	mov    %edx,%edi
  800e4a:	89 d6                	mov    %edx,%esi
  800e4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	57                   	push   %edi
  800e57:	56                   	push   %esi
  800e58:	53                   	push   %ebx
  800e59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e61:	b8 03 00 00 00       	mov    $0x3,%eax
  800e66:	8b 55 08             	mov    0x8(%ebp),%edx
  800e69:	89 cb                	mov    %ecx,%ebx
  800e6b:	89 cf                	mov    %ecx,%edi
  800e6d:	89 ce                	mov    %ecx,%esi
  800e6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e71:	85 c0                	test   %eax,%eax
  800e73:	7e 28                	jle    800e9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800e80:	00 
  800e81:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800e88:	00 
  800e89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e90:	00 
  800e91:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800e98:	e8 0f f5 ff ff       	call   8003ac <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e9d:	83 c4 2c             	add    $0x2c,%esp
  800ea0:	5b                   	pop    %ebx
  800ea1:	5e                   	pop    %esi
  800ea2:	5f                   	pop    %edi
  800ea3:	5d                   	pop    %ebp
  800ea4:	c3                   	ret    

00800ea5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	57                   	push   %edi
  800ea9:	56                   	push   %esi
  800eaa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eab:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800eb5:	89 d1                	mov    %edx,%ecx
  800eb7:	89 d3                	mov    %edx,%ebx
  800eb9:	89 d7                	mov    %edx,%edi
  800ebb:	89 d6                	mov    %edx,%esi
  800ebd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ebf:	5b                   	pop    %ebx
  800ec0:	5e                   	pop    %esi
  800ec1:	5f                   	pop    %edi
  800ec2:	5d                   	pop    %ebp
  800ec3:	c3                   	ret    

00800ec4 <sys_yield>:

void
sys_yield(void)
{
  800ec4:	55                   	push   %ebp
  800ec5:	89 e5                	mov    %esp,%ebp
  800ec7:	57                   	push   %edi
  800ec8:	56                   	push   %esi
  800ec9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eca:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ed4:	89 d1                	mov    %edx,%ecx
  800ed6:	89 d3                	mov    %edx,%ebx
  800ed8:	89 d7                	mov    %edx,%edi
  800eda:	89 d6                	mov    %edx,%esi
  800edc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ede:	5b                   	pop    %ebx
  800edf:	5e                   	pop    %esi
  800ee0:	5f                   	pop    %edi
  800ee1:	5d                   	pop    %ebp
  800ee2:	c3                   	ret    

00800ee3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ee3:	55                   	push   %ebp
  800ee4:	89 e5                	mov    %esp,%ebp
  800ee6:	57                   	push   %edi
  800ee7:	56                   	push   %esi
  800ee8:	53                   	push   %ebx
  800ee9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	be 00 00 00 00       	mov    $0x0,%esi
  800ef1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eff:	89 f7                	mov    %esi,%edi
  800f01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f03:	85 c0                	test   %eax,%eax
  800f05:	7e 28                	jle    800f2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800f12:	00 
  800f13:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800f1a:	00 
  800f1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f22:	00 
  800f23:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800f2a:	e8 7d f4 ff ff       	call   8003ac <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800f2f:	83 c4 2c             	add    $0x2c,%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
  800f3a:	57                   	push   %edi
  800f3b:	56                   	push   %esi
  800f3c:	53                   	push   %ebx
  800f3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f40:	b8 05 00 00 00       	mov    $0x5,%eax
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f51:	8b 75 18             	mov    0x18(%ebp),%esi
  800f54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f56:	85 c0                	test   %eax,%eax
  800f58:	7e 28                	jle    800f82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f65:	00 
  800f66:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800f6d:	00 
  800f6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f75:	00 
  800f76:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800f7d:	e8 2a f4 ff ff       	call   8003ac <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f82:	83 c4 2c             	add    $0x2c,%esp
  800f85:	5b                   	pop    %ebx
  800f86:	5e                   	pop    %esi
  800f87:	5f                   	pop    %edi
  800f88:	5d                   	pop    %ebp
  800f89:	c3                   	ret    

00800f8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f8a:	55                   	push   %ebp
  800f8b:	89 e5                	mov    %esp,%ebp
  800f8d:	57                   	push   %edi
  800f8e:	56                   	push   %esi
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f98:	b8 06 00 00 00       	mov    $0x6,%eax
  800f9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa3:	89 df                	mov    %ebx,%edi
  800fa5:	89 de                	mov    %ebx,%esi
  800fa7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fa9:	85 c0                	test   %eax,%eax
  800fab:	7e 28                	jle    800fd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800fb8:	00 
  800fb9:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  800fc0:	00 
  800fc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc8:	00 
  800fc9:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  800fd0:	e8 d7 f3 ff ff       	call   8003ac <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fd5:	83 c4 2c             	add    $0x2c,%esp
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
  800fe3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800feb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ff0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff6:	89 df                	mov    %ebx,%edi
  800ff8:	89 de                	mov    %ebx,%esi
  800ffa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ffc:	85 c0                	test   %eax,%eax
  800ffe:	7e 28                	jle    801028 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801000:	89 44 24 10          	mov    %eax,0x10(%esp)
  801004:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80100b:	00 
  80100c:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  801013:	00 
  801014:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80101b:	00 
  80101c:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  801023:	e8 84 f3 ff ff       	call   8003ac <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801028:	83 c4 2c             	add    $0x2c,%esp
  80102b:	5b                   	pop    %ebx
  80102c:	5e                   	pop    %esi
  80102d:	5f                   	pop    %edi
  80102e:	5d                   	pop    %ebp
  80102f:	c3                   	ret    

00801030 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	57                   	push   %edi
  801034:	56                   	push   %esi
  801035:	53                   	push   %ebx
  801036:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801039:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103e:	b8 09 00 00 00       	mov    $0x9,%eax
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 df                	mov    %ebx,%edi
  80104b:	89 de                	mov    %ebx,%esi
  80104d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80104f:	85 c0                	test   %eax,%eax
  801051:	7e 28                	jle    80107b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801053:	89 44 24 10          	mov    %eax,0x10(%esp)
  801057:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80105e:	00 
  80105f:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  801066:	00 
  801067:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106e:	00 
  80106f:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  801076:	e8 31 f3 ff ff       	call   8003ac <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80107b:	83 c4 2c             	add    $0x2c,%esp
  80107e:	5b                   	pop    %ebx
  80107f:	5e                   	pop    %esi
  801080:	5f                   	pop    %edi
  801081:	5d                   	pop    %ebp
  801082:	c3                   	ret    

00801083 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801083:	55                   	push   %ebp
  801084:	89 e5                	mov    %esp,%ebp
  801086:	57                   	push   %edi
  801087:	56                   	push   %esi
  801088:	53                   	push   %ebx
  801089:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801091:	b8 0a 00 00 00       	mov    $0xa,%eax
  801096:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801099:	8b 55 08             	mov    0x8(%ebp),%edx
  80109c:	89 df                	mov    %ebx,%edi
  80109e:	89 de                	mov    %ebx,%esi
  8010a0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	7e 28                	jle    8010ce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010aa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  8010b9:	00 
  8010ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c1:	00 
  8010c2:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  8010c9:	e8 de f2 ff ff       	call   8003ac <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010ce:	83 c4 2c             	add    $0x2c,%esp
  8010d1:	5b                   	pop    %ebx
  8010d2:	5e                   	pop    %esi
  8010d3:	5f                   	pop    %edi
  8010d4:	5d                   	pop    %ebp
  8010d5:	c3                   	ret    

008010d6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	57                   	push   %edi
  8010da:	56                   	push   %esi
  8010db:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dc:	be 00 00 00 00       	mov    $0x0,%esi
  8010e1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8010e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010f4:	5b                   	pop    %ebx
  8010f5:	5e                   	pop    %esi
  8010f6:	5f                   	pop    %edi
  8010f7:	5d                   	pop    %ebp
  8010f8:	c3                   	ret    

008010f9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010f9:	55                   	push   %ebp
  8010fa:	89 e5                	mov    %esp,%ebp
  8010fc:	57                   	push   %edi
  8010fd:	56                   	push   %esi
  8010fe:	53                   	push   %ebx
  8010ff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801102:	b9 00 00 00 00       	mov    $0x0,%ecx
  801107:	b8 0d 00 00 00       	mov    $0xd,%eax
  80110c:	8b 55 08             	mov    0x8(%ebp),%edx
  80110f:	89 cb                	mov    %ecx,%ebx
  801111:	89 cf                	mov    %ecx,%edi
  801113:	89 ce                	mov    %ecx,%esi
  801115:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801117:	85 c0                	test   %eax,%eax
  801119:	7e 28                	jle    801143 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  80111b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801126:	00 
  801127:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  80112e:	00 
  80112f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801136:	00 
  801137:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  80113e:	e8 69 f2 ff ff       	call   8003ac <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801143:	83 c4 2c             	add    $0x2c,%esp
  801146:	5b                   	pop    %ebx
  801147:	5e                   	pop    %esi
  801148:	5f                   	pop    %edi
  801149:	5d                   	pop    %ebp
  80114a:	c3                   	ret    

0080114b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	57                   	push   %edi
  80114f:	56                   	push   %esi
  801150:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801151:	ba 00 00 00 00       	mov    $0x0,%edx
  801156:	b8 0e 00 00 00       	mov    $0xe,%eax
  80115b:	89 d1                	mov    %edx,%ecx
  80115d:	89 d3                	mov    %edx,%ebx
  80115f:	89 d7                	mov    %edx,%edi
  801161:	89 d6                	mov    %edx,%esi
  801163:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    

0080116a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80116a:	55                   	push   %ebp
  80116b:	89 e5                	mov    %esp,%ebp
  80116d:	57                   	push   %edi
  80116e:	56                   	push   %esi
  80116f:	53                   	push   %ebx
  801170:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801173:	bb 00 00 00 00       	mov    $0x0,%ebx
  801178:	b8 0f 00 00 00       	mov    $0xf,%eax
  80117d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801180:	8b 55 08             	mov    0x8(%ebp),%edx
  801183:	89 df                	mov    %ebx,%edi
  801185:	89 de                	mov    %ebx,%esi
  801187:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801189:	85 c0                	test   %eax,%eax
  80118b:	7e 28                	jle    8011b5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801191:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801198:	00 
  801199:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  8011a0:	00 
  8011a1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a8:	00 
  8011a9:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  8011b0:	e8 f7 f1 ff ff       	call   8003ac <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  8011b5:	83 c4 2c             	add    $0x2c,%esp
  8011b8:	5b                   	pop    %ebx
  8011b9:	5e                   	pop    %esi
  8011ba:	5f                   	pop    %edi
  8011bb:	5d                   	pop    %ebp
  8011bc:	c3                   	ret    

008011bd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	57                   	push   %edi
  8011c1:	56                   	push   %esi
  8011c2:	53                   	push   %ebx
  8011c3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8011d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d6:	89 df                	mov    %ebx,%edi
  8011d8:	89 de                	mov    %ebx,%esi
  8011da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8011dc:	85 c0                	test   %eax,%eax
  8011de:	7e 28                	jle    801208 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011e4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8011eb:	00 
  8011ec:	c7 44 24 08 df 30 80 	movl   $0x8030df,0x8(%esp)
  8011f3:	00 
  8011f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011fb:	00 
  8011fc:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  801203:	e8 a4 f1 ff ff       	call   8003ac <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801208:	83 c4 2c             	add    $0x2c,%esp
  80120b:	5b                   	pop    %ebx
  80120c:	5e                   	pop    %esi
  80120d:	5f                   	pop    %edi
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    

00801210 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	53                   	push   %ebx
  801214:	83 ec 24             	sub    $0x24,%esp
  801217:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80121a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80121c:	89 d3                	mov    %edx,%ebx
  80121e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801224:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801228:	74 1a                	je     801244 <pgfault+0x34>
  80122a:	c1 ea 0c             	shr    $0xc,%edx
  80122d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801234:	a8 01                	test   $0x1,%al
  801236:	74 0c                	je     801244 <pgfault+0x34>
  801238:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80123f:	f6 c4 08             	test   $0x8,%ah
  801242:	75 1c                	jne    801260 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801244:	c7 44 24 08 0c 31 80 	movl   $0x80310c,0x8(%esp)
  80124b:	00 
  80124c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801253:	00 
  801254:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  80125b:	e8 4c f1 ff ff       	call   8003ac <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801260:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801267:	00 
  801268:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80126f:	00 
  801270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801277:	e8 67 fc ff ff       	call   800ee3 <sys_page_alloc>
  80127c:	85 c0                	test   %eax,%eax
  80127e:	79 1c                	jns    80129c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801280:	c7 44 24 08 50 31 80 	movl   $0x803150,0x8(%esp)
  801287:	00 
  801288:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80128f:	00 
  801290:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  801297:	e8 10 f1 ff ff       	call   8003ac <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80129c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012a3:	00 
  8012a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a8:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8012af:	e8 18 fa ff ff       	call   800ccc <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  8012b4:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8012bb:	00 
  8012bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012c7:	00 
  8012c8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8012cf:	00 
  8012d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d7:	e8 5b fc ff ff       	call   800f37 <sys_page_map>
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	74 1c                	je     8012fc <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8012e0:	c7 44 24 08 66 32 80 	movl   $0x803266,0x8(%esp)
  8012e7:	00 
  8012e8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8012ef:	00 
  8012f0:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  8012f7:	e8 b0 f0 ff ff       	call   8003ac <_panic>
    sys_page_unmap(0,PFTEMP);
  8012fc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801303:	00 
  801304:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80130b:	e8 7a fc ff ff       	call   800f8a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801310:	83 c4 24             	add    $0x24,%esp
  801313:	5b                   	pop    %ebx
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    

00801316 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
  801319:	57                   	push   %edi
  80131a:	56                   	push   %esi
  80131b:	53                   	push   %ebx
  80131c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80131f:	c7 04 24 10 12 80 00 	movl   $0x801210,(%esp)
  801326:	e8 fb 15 00 00       	call   802926 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80132b:	b8 07 00 00 00       	mov    $0x7,%eax
  801330:	cd 30                	int    $0x30
  801332:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801335:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801337:	bb 00 00 00 00       	mov    $0x0,%ebx
  80133c:	85 c0                	test   %eax,%eax
  80133e:	75 21                	jne    801361 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801340:	e8 60 fb ff ff       	call   800ea5 <sys_getenvid>
  801345:	25 ff 03 00 00       	and    $0x3ff,%eax
  80134a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80134d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801352:	a3 40 50 86 00       	mov    %eax,0x865040
		return 0;
  801357:	b8 00 00 00 00       	mov    $0x0,%eax
  80135c:	e9 de 01 00 00       	jmp    80153f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801361:	89 d8                	mov    %ebx,%eax
  801363:	c1 e8 16             	shr    $0x16,%eax
  801366:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80136d:	a8 01                	test   $0x1,%al
  80136f:	0f 84 58 01 00 00    	je     8014cd <fork+0x1b7>
  801375:	89 de                	mov    %ebx,%esi
  801377:	c1 ee 0c             	shr    $0xc,%esi
  80137a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801381:	83 e0 05             	and    $0x5,%eax
  801384:	83 f8 05             	cmp    $0x5,%eax
  801387:	0f 85 40 01 00 00    	jne    8014cd <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80138d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801394:	f6 c4 04             	test   $0x4,%ah
  801397:	74 4f                	je     8013e8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801399:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013a0:	c1 e6 0c             	shl    $0xc,%esi
  8013a3:	25 07 0e 00 00       	and    $0xe07,%eax
  8013a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013b0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8013b4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013bf:	e8 73 fb ff ff       	call   800f37 <sys_page_map>
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	0f 89 01 01 00 00    	jns    8014cd <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8013cc:	c7 44 24 08 70 31 80 	movl   $0x803170,0x8(%esp)
  8013d3:	00 
  8013d4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8013db:	00 
  8013dc:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  8013e3:	e8 c4 ef ff ff       	call   8003ac <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8013e8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013ef:	a8 02                	test   $0x2,%al
  8013f1:	75 10                	jne    801403 <fork+0xed>
  8013f3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8013fa:	f6 c4 08             	test   $0x8,%ah
  8013fd:	0f 84 87 00 00 00    	je     80148a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801403:	c1 e6 0c             	shl    $0xc,%esi
  801406:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80140d:	00 
  80140e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801412:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801416:	89 74 24 04          	mov    %esi,0x4(%esp)
  80141a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801421:	e8 11 fb ff ff       	call   800f37 <sys_page_map>
  801426:	85 c0                	test   %eax,%eax
  801428:	79 1c                	jns    801446 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80142a:	c7 44 24 08 a8 31 80 	movl   $0x8031a8,0x8(%esp)
  801431:	00 
  801432:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801439:	00 
  80143a:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  801441:	e8 66 ef ff ff       	call   8003ac <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801446:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80144d:	00 
  80144e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801452:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801459:	00 
  80145a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80145e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801465:	e8 cd fa ff ff       	call   800f37 <sys_page_map>
  80146a:	85 c0                	test   %eax,%eax
  80146c:	79 5f                	jns    8014cd <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80146e:	c7 44 24 08 e0 31 80 	movl   $0x8031e0,0x8(%esp)
  801475:	00 
  801476:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80147d:	00 
  80147e:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  801485:	e8 22 ef ff ff       	call   8003ac <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80148a:	c1 e6 0c             	shl    $0xc,%esi
  80148d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801494:	00 
  801495:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801499:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80149d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a8:	e8 8a fa ff ff       	call   800f37 <sys_page_map>
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	74 1c                	je     8014cd <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  8014b1:	c7 44 24 08 08 32 80 	movl   $0x803208,0x8(%esp)
  8014b8:	00 
  8014b9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8014c0:	00 
  8014c1:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  8014c8:	e8 df ee ff ff       	call   8003ac <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8014cd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8014d3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8014d9:	0f 85 82 fe ff ff    	jne    801361 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8014df:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014e6:	00 
  8014e7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014ee:	ee 
  8014ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014f2:	89 04 24             	mov    %eax,(%esp)
  8014f5:	e8 e9 f9 ff ff       	call   800ee3 <sys_page_alloc>
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	79 1c                	jns    80151a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8014fe:	c7 44 24 08 3c 32 80 	movl   $0x80323c,0x8(%esp)
  801505:	00 
  801506:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80150d:	00 
  80150e:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  801515:	e8 92 ee ff ff       	call   8003ac <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80151a:	c7 44 24 04 97 29 80 	movl   $0x802997,0x4(%esp)
  801521:	00 
  801522:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801525:	89 3c 24             	mov    %edi,(%esp)
  801528:	e8 56 fb ff ff       	call   801083 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80152d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801534:	00 
  801535:	89 3c 24             	mov    %edi,(%esp)
  801538:	e8 a0 fa ff ff       	call   800fdd <sys_env_set_status>
		return child;
  80153d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80153f:	83 c4 2c             	add    $0x2c,%esp
  801542:	5b                   	pop    %ebx
  801543:	5e                   	pop    %esi
  801544:	5f                   	pop    %edi
  801545:	5d                   	pop    %ebp
  801546:	c3                   	ret    

00801547 <sfork>:

// Challenge!
int
sfork(void)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80154d:	c7 44 24 08 84 32 80 	movl   $0x803284,0x8(%esp)
  801554:	00 
  801555:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80155c:	00 
  80155d:	c7 04 24 5b 32 80 00 	movl   $0x80325b,(%esp)
  801564:	e8 43 ee ff ff       	call   8003ac <_panic>

00801569 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
  80156e:	83 ec 10             	sub    $0x10,%esp
  801571:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80157a:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80157c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801581:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  801584:	89 04 24             	mov    %eax,(%esp)
  801587:	e8 6d fb ff ff       	call   8010f9 <sys_ipc_recv>
  80158c:	85 c0                	test   %eax,%eax
  80158e:	75 1e                	jne    8015ae <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  801590:	85 db                	test   %ebx,%ebx
  801592:	74 0a                	je     80159e <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  801594:	a1 40 50 86 00       	mov    0x865040,%eax
  801599:	8b 40 74             	mov    0x74(%eax),%eax
  80159c:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80159e:	85 f6                	test   %esi,%esi
  8015a0:	74 22                	je     8015c4 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8015a2:	a1 40 50 86 00       	mov    0x865040,%eax
  8015a7:	8b 40 78             	mov    0x78(%eax),%eax
  8015aa:	89 06                	mov    %eax,(%esi)
  8015ac:	eb 16                	jmp    8015c4 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8015ae:	85 f6                	test   %esi,%esi
  8015b0:	74 06                	je     8015b8 <ipc_recv+0x4f>
				*perm_store = 0;
  8015b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8015b8:	85 db                	test   %ebx,%ebx
  8015ba:	74 10                	je     8015cc <ipc_recv+0x63>
				*from_env_store=0;
  8015bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015c2:	eb 08                	jmp    8015cc <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8015c4:	a1 40 50 86 00       	mov    0x865040,%eax
  8015c9:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	57                   	push   %edi
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	83 ec 1c             	sub    $0x1c,%esp
  8015dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015e2:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8015e5:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8015e7:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8015ec:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8015ef:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 d0 fa ff ff       	call   8010d6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  801606:	eb 1c                	jmp    801624 <ipc_send+0x51>
	{
		sys_yield();
  801608:	e8 b7 f8 ff ff       	call   800ec4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80160d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801611:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801615:	89 74 24 04          	mov    %esi,0x4(%esp)
  801619:	8b 45 08             	mov    0x8(%ebp),%eax
  80161c:	89 04 24             	mov    %eax,(%esp)
  80161f:	e8 b2 fa ff ff       	call   8010d6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801624:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801627:	74 df                	je     801608 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801629:	83 c4 1c             	add    $0x1c,%esp
  80162c:	5b                   	pop    %ebx
  80162d:	5e                   	pop    %esi
  80162e:	5f                   	pop    %edi
  80162f:	5d                   	pop    %ebp
  801630:	c3                   	ret    

00801631 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80163c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80163f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801645:	8b 52 50             	mov    0x50(%edx),%edx
  801648:	39 ca                	cmp    %ecx,%edx
  80164a:	75 0d                	jne    801659 <ipc_find_env+0x28>
			return envs[i].env_id;
  80164c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80164f:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801654:	8b 40 40             	mov    0x40(%eax),%eax
  801657:	eb 0e                	jmp    801667 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801659:	83 c0 01             	add    $0x1,%eax
  80165c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801661:	75 d9                	jne    80163c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801663:	66 b8 00 00          	mov    $0x0,%ax
}
  801667:	5d                   	pop    %ebp
  801668:	c3                   	ret    
  801669:	66 90                	xchg   %ax,%ax
  80166b:	66 90                	xchg   %ax,%ax
  80166d:	66 90                	xchg   %ax,%ax
  80166f:	90                   	nop

00801670 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801673:	8b 45 08             	mov    0x8(%ebp),%eax
  801676:	05 00 00 00 30       	add    $0x30000000,%eax
  80167b:	c1 e8 0c             	shr    $0xc,%eax
}
  80167e:	5d                   	pop    %ebp
  80167f:	c3                   	ret    

00801680 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80168b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801690:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    

00801697 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801697:	55                   	push   %ebp
  801698:	89 e5                	mov    %esp,%ebp
  80169a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80169d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8016a2:	89 c2                	mov    %eax,%edx
  8016a4:	c1 ea 16             	shr    $0x16,%edx
  8016a7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016ae:	f6 c2 01             	test   $0x1,%dl
  8016b1:	74 11                	je     8016c4 <fd_alloc+0x2d>
  8016b3:	89 c2                	mov    %eax,%edx
  8016b5:	c1 ea 0c             	shr    $0xc,%edx
  8016b8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016bf:	f6 c2 01             	test   $0x1,%dl
  8016c2:	75 09                	jne    8016cd <fd_alloc+0x36>
			*fd_store = fd;
  8016c4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	eb 17                	jmp    8016e4 <fd_alloc+0x4d>
  8016cd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016d2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016d7:	75 c9                	jne    8016a2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016d9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8016df:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8016e4:	5d                   	pop    %ebp
  8016e5:	c3                   	ret    

008016e6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016ec:	83 f8 1f             	cmp    $0x1f,%eax
  8016ef:	77 36                	ja     801727 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016f1:	c1 e0 0c             	shl    $0xc,%eax
  8016f4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8016f9:	89 c2                	mov    %eax,%edx
  8016fb:	c1 ea 16             	shr    $0x16,%edx
  8016fe:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801705:	f6 c2 01             	test   $0x1,%dl
  801708:	74 24                	je     80172e <fd_lookup+0x48>
  80170a:	89 c2                	mov    %eax,%edx
  80170c:	c1 ea 0c             	shr    $0xc,%edx
  80170f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801716:	f6 c2 01             	test   $0x1,%dl
  801719:	74 1a                	je     801735 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80171b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80171e:	89 02                	mov    %eax,(%edx)
	return 0;
  801720:	b8 00 00 00 00       	mov    $0x0,%eax
  801725:	eb 13                	jmp    80173a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80172c:	eb 0c                	jmp    80173a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80172e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801733:	eb 05                	jmp    80173a <fd_lookup+0x54>
  801735:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80173a:	5d                   	pop    %ebp
  80173b:	c3                   	ret    

0080173c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80173c:	55                   	push   %ebp
  80173d:	89 e5                	mov    %esp,%ebp
  80173f:	83 ec 18             	sub    $0x18,%esp
  801742:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801745:	ba 00 00 00 00       	mov    $0x0,%edx
  80174a:	eb 13                	jmp    80175f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80174c:	39 08                	cmp    %ecx,(%eax)
  80174e:	75 0c                	jne    80175c <dev_lookup+0x20>
			*dev = devtab[i];
  801750:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801753:	89 01                	mov    %eax,(%ecx)
			return 0;
  801755:	b8 00 00 00 00       	mov    $0x0,%eax
  80175a:	eb 38                	jmp    801794 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80175c:	83 c2 01             	add    $0x1,%edx
  80175f:	8b 04 95 18 33 80 00 	mov    0x803318(,%edx,4),%eax
  801766:	85 c0                	test   %eax,%eax
  801768:	75 e2                	jne    80174c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80176a:	a1 40 50 86 00       	mov    0x865040,%eax
  80176f:	8b 40 48             	mov    0x48(%eax),%eax
  801772:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801776:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177a:	c7 04 24 9c 32 80 00 	movl   $0x80329c,(%esp)
  801781:	e8 1f ed ff ff       	call   8004a5 <cprintf>
	*dev = 0;
  801786:	8b 45 0c             	mov    0xc(%ebp),%eax
  801789:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80178f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801794:	c9                   	leave  
  801795:	c3                   	ret    

00801796 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801796:	55                   	push   %ebp
  801797:	89 e5                	mov    %esp,%ebp
  801799:	56                   	push   %esi
  80179a:	53                   	push   %ebx
  80179b:	83 ec 20             	sub    $0x20,%esp
  80179e:	8b 75 08             	mov    0x8(%ebp),%esi
  8017a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8017ab:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8017b1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8017b4:	89 04 24             	mov    %eax,(%esp)
  8017b7:	e8 2a ff ff ff       	call   8016e6 <fd_lookup>
  8017bc:	85 c0                	test   %eax,%eax
  8017be:	78 05                	js     8017c5 <fd_close+0x2f>
	    || fd != fd2)
  8017c0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8017c3:	74 0c                	je     8017d1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8017c5:	84 db                	test   %bl,%bl
  8017c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cc:	0f 44 c2             	cmove  %edx,%eax
  8017cf:	eb 3f                	jmp    801810 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8017d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	8b 06                	mov    (%esi),%eax
  8017da:	89 04 24             	mov    %eax,(%esp)
  8017dd:	e8 5a ff ff ff       	call   80173c <dev_lookup>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	78 16                	js     8017fe <fd_close+0x68>
		if (dev->dev_close)
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8017ee:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	74 07                	je     8017fe <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8017f7:	89 34 24             	mov    %esi,(%esp)
  8017fa:	ff d0                	call   *%eax
  8017fc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8017fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801802:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801809:	e8 7c f7 ff ff       	call   800f8a <sys_page_unmap>
	return r;
  80180e:	89 d8                	mov    %ebx,%eax
}
  801810:	83 c4 20             	add    $0x20,%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80181d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801820:	89 44 24 04          	mov    %eax,0x4(%esp)
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 04 24             	mov    %eax,(%esp)
  80182a:	e8 b7 fe ff ff       	call   8016e6 <fd_lookup>
  80182f:	89 c2                	mov    %eax,%edx
  801831:	85 d2                	test   %edx,%edx
  801833:	78 13                	js     801848 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801835:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80183c:	00 
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	89 04 24             	mov    %eax,(%esp)
  801843:	e8 4e ff ff ff       	call   801796 <fd_close>
}
  801848:	c9                   	leave  
  801849:	c3                   	ret    

0080184a <close_all>:

void
close_all(void)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	53                   	push   %ebx
  80184e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801851:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801856:	89 1c 24             	mov    %ebx,(%esp)
  801859:	e8 b9 ff ff ff       	call   801817 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80185e:	83 c3 01             	add    $0x1,%ebx
  801861:	83 fb 20             	cmp    $0x20,%ebx
  801864:	75 f0                	jne    801856 <close_all+0xc>
		close(i);
}
  801866:	83 c4 14             	add    $0x14,%esp
  801869:	5b                   	pop    %ebx
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	57                   	push   %edi
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801875:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187c:	8b 45 08             	mov    0x8(%ebp),%eax
  80187f:	89 04 24             	mov    %eax,(%esp)
  801882:	e8 5f fe ff ff       	call   8016e6 <fd_lookup>
  801887:	89 c2                	mov    %eax,%edx
  801889:	85 d2                	test   %edx,%edx
  80188b:	0f 88 e1 00 00 00    	js     801972 <dup+0x106>
		return r;
	close(newfdnum);
  801891:	8b 45 0c             	mov    0xc(%ebp),%eax
  801894:	89 04 24             	mov    %eax,(%esp)
  801897:	e8 7b ff ff ff       	call   801817 <close>

	newfd = INDEX2FD(newfdnum);
  80189c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80189f:	c1 e3 0c             	shl    $0xc,%ebx
  8018a2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8018a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018ab:	89 04 24             	mov    %eax,(%esp)
  8018ae:	e8 cd fd ff ff       	call   801680 <fd2data>
  8018b3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8018b5:	89 1c 24             	mov    %ebx,(%esp)
  8018b8:	e8 c3 fd ff ff       	call   801680 <fd2data>
  8018bd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8018bf:	89 f0                	mov    %esi,%eax
  8018c1:	c1 e8 16             	shr    $0x16,%eax
  8018c4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018cb:	a8 01                	test   $0x1,%al
  8018cd:	74 43                	je     801912 <dup+0xa6>
  8018cf:	89 f0                	mov    %esi,%eax
  8018d1:	c1 e8 0c             	shr    $0xc,%eax
  8018d4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8018db:	f6 c2 01             	test   $0x1,%dl
  8018de:	74 32                	je     801912 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8018e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8018e7:	25 07 0e 00 00       	and    $0xe07,%eax
  8018ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8018f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018fb:	00 
  8018fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801900:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801907:	e8 2b f6 ff ff       	call   800f37 <sys_page_map>
  80190c:	89 c6                	mov    %eax,%esi
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 3e                	js     801950 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801915:	89 c2                	mov    %eax,%edx
  801917:	c1 ea 0c             	shr    $0xc,%edx
  80191a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801921:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801927:	89 54 24 10          	mov    %edx,0x10(%esp)
  80192b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80192f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801936:	00 
  801937:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801942:	e8 f0 f5 ff ff       	call   800f37 <sys_page_map>
  801947:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801949:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80194c:	85 f6                	test   %esi,%esi
  80194e:	79 22                	jns    801972 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801950:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801954:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80195b:	e8 2a f6 ff ff       	call   800f8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801960:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801964:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80196b:	e8 1a f6 ff ff       	call   800f8a <sys_page_unmap>
	return r;
  801970:	89 f0                	mov    %esi,%eax
}
  801972:	83 c4 3c             	add    $0x3c,%esp
  801975:	5b                   	pop    %ebx
  801976:	5e                   	pop    %esi
  801977:	5f                   	pop    %edi
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	53                   	push   %ebx
  80197e:	83 ec 24             	sub    $0x24,%esp
  801981:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801984:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801987:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198b:	89 1c 24             	mov    %ebx,(%esp)
  80198e:	e8 53 fd ff ff       	call   8016e6 <fd_lookup>
  801993:	89 c2                	mov    %eax,%edx
  801995:	85 d2                	test   %edx,%edx
  801997:	78 6d                	js     801a06 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801999:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a3:	8b 00                	mov    (%eax),%eax
  8019a5:	89 04 24             	mov    %eax,(%esp)
  8019a8:	e8 8f fd ff ff       	call   80173c <dev_lookup>
  8019ad:	85 c0                	test   %eax,%eax
  8019af:	78 55                	js     801a06 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b4:	8b 50 08             	mov    0x8(%eax),%edx
  8019b7:	83 e2 03             	and    $0x3,%edx
  8019ba:	83 fa 01             	cmp    $0x1,%edx
  8019bd:	75 23                	jne    8019e2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8019bf:	a1 40 50 86 00       	mov    0x865040,%eax
  8019c4:	8b 40 48             	mov    0x48(%eax),%eax
  8019c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cf:	c7 04 24 dd 32 80 00 	movl   $0x8032dd,(%esp)
  8019d6:	e8 ca ea ff ff       	call   8004a5 <cprintf>
		return -E_INVAL;
  8019db:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e0:	eb 24                	jmp    801a06 <read+0x8c>
	}
	if (!dev->dev_read)
  8019e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019e5:	8b 52 08             	mov    0x8(%edx),%edx
  8019e8:	85 d2                	test   %edx,%edx
  8019ea:	74 15                	je     801a01 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019ec:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019ef:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019fa:	89 04 24             	mov    %eax,(%esp)
  8019fd:	ff d2                	call   *%edx
  8019ff:	eb 05                	jmp    801a06 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801a01:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801a06:	83 c4 24             	add    $0x24,%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 1c             	sub    $0x1c,%esp
  801a15:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a18:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a20:	eb 23                	jmp    801a45 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a22:	89 f0                	mov    %esi,%eax
  801a24:	29 d8                	sub    %ebx,%eax
  801a26:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2a:	89 d8                	mov    %ebx,%eax
  801a2c:	03 45 0c             	add    0xc(%ebp),%eax
  801a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a33:	89 3c 24             	mov    %edi,(%esp)
  801a36:	e8 3f ff ff ff       	call   80197a <read>
		if (m < 0)
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 10                	js     801a4f <readn+0x43>
			return m;
		if (m == 0)
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	74 0a                	je     801a4d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a43:	01 c3                	add    %eax,%ebx
  801a45:	39 f3                	cmp    %esi,%ebx
  801a47:	72 d9                	jb     801a22 <readn+0x16>
  801a49:	89 d8                	mov    %ebx,%eax
  801a4b:	eb 02                	jmp    801a4f <readn+0x43>
  801a4d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a4f:	83 c4 1c             	add    $0x1c,%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5f                   	pop    %edi
  801a55:	5d                   	pop    %ebp
  801a56:	c3                   	ret    

00801a57 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	53                   	push   %ebx
  801a5b:	83 ec 24             	sub    $0x24,%esp
  801a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	89 1c 24             	mov    %ebx,(%esp)
  801a6b:	e8 76 fc ff ff       	call   8016e6 <fd_lookup>
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	85 d2                	test   %edx,%edx
  801a74:	78 68                	js     801ade <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a80:	8b 00                	mov    (%eax),%eax
  801a82:	89 04 24             	mov    %eax,(%esp)
  801a85:	e8 b2 fc ff ff       	call   80173c <dev_lookup>
  801a8a:	85 c0                	test   %eax,%eax
  801a8c:	78 50                	js     801ade <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a91:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a95:	75 23                	jne    801aba <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801a97:	a1 40 50 86 00       	mov    0x865040,%eax
  801a9c:	8b 40 48             	mov    0x48(%eax),%eax
  801a9f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	c7 04 24 f9 32 80 00 	movl   $0x8032f9,(%esp)
  801aae:	e8 f2 e9 ff ff       	call   8004a5 <cprintf>
		return -E_INVAL;
  801ab3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ab8:	eb 24                	jmp    801ade <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801abd:	8b 52 0c             	mov    0xc(%edx),%edx
  801ac0:	85 d2                	test   %edx,%edx
  801ac2:	74 15                	je     801ad9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ac4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ac7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ace:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ad2:	89 04 24             	mov    %eax,(%esp)
  801ad5:	ff d2                	call   *%edx
  801ad7:	eb 05                	jmp    801ade <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801ad9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  801ade:	83 c4 24             	add    $0x24,%esp
  801ae1:	5b                   	pop    %ebx
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    

00801ae4 <seek>:

int
seek(int fdnum, off_t offset)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aea:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801aed:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 ea fb ff ff       	call   8016e6 <fd_lookup>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 0e                	js     801b0e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801b09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	53                   	push   %ebx
  801b14:	83 ec 24             	sub    $0x24,%esp
  801b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b21:	89 1c 24             	mov    %ebx,(%esp)
  801b24:	e8 bd fb ff ff       	call   8016e6 <fd_lookup>
  801b29:	89 c2                	mov    %eax,%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	78 61                	js     801b90 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b2f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b39:	8b 00                	mov    (%eax),%eax
  801b3b:	89 04 24             	mov    %eax,(%esp)
  801b3e:	e8 f9 fb ff ff       	call   80173c <dev_lookup>
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 49                	js     801b90 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b4a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801b4e:	75 23                	jne    801b73 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801b50:	a1 40 50 86 00       	mov    0x865040,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b55:	8b 40 48             	mov    0x48(%eax),%eax
  801b58:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b60:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801b67:	e8 39 e9 ff ff       	call   8004a5 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801b6c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801b71:	eb 1d                	jmp    801b90 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b76:	8b 52 18             	mov    0x18(%edx),%edx
  801b79:	85 d2                	test   %edx,%edx
  801b7b:	74 0e                	je     801b8b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b80:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b84:	89 04 24             	mov    %eax,(%esp)
  801b87:	ff d2                	call   *%edx
  801b89:	eb 05                	jmp    801b90 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801b8b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801b90:	83 c4 24             	add    $0x24,%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5d                   	pop    %ebp
  801b95:	c3                   	ret    

00801b96 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
  801b99:	53                   	push   %ebx
  801b9a:	83 ec 24             	sub    $0x24,%esp
  801b9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ba0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	89 04 24             	mov    %eax,(%esp)
  801bad:	e8 34 fb ff ff       	call   8016e6 <fd_lookup>
  801bb2:	89 c2                	mov    %eax,%edx
  801bb4:	85 d2                	test   %edx,%edx
  801bb6:	78 52                	js     801c0a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc2:	8b 00                	mov    (%eax),%eax
  801bc4:	89 04 24             	mov    %eax,(%esp)
  801bc7:	e8 70 fb ff ff       	call   80173c <dev_lookup>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 3a                	js     801c0a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801bd7:	74 2c                	je     801c05 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801bd9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801bdc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801be3:	00 00 00 
	stat->st_isdir = 0;
  801be6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801bed:	00 00 00 
	stat->st_dev = dev;
  801bf0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801bf6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801bfd:	89 14 24             	mov    %edx,(%esp)
  801c00:	ff 50 14             	call   *0x14(%eax)
  801c03:	eb 05                	jmp    801c0a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801c05:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801c0a:	83 c4 24             	add    $0x24,%esp
  801c0d:	5b                   	pop    %ebx
  801c0e:	5d                   	pop    %ebp
  801c0f:	c3                   	ret    

00801c10 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	56                   	push   %esi
  801c14:	53                   	push   %ebx
  801c15:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c1f:	00 
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	89 04 24             	mov    %eax,(%esp)
  801c26:	e8 28 02 00 00       	call   801e53 <open>
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	85 db                	test   %ebx,%ebx
  801c2f:	78 1b                	js     801c4c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801c31:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c38:	89 1c 24             	mov    %ebx,(%esp)
  801c3b:	e8 56 ff ff ff       	call   801b96 <fstat>
  801c40:	89 c6                	mov    %eax,%esi
	close(fd);
  801c42:	89 1c 24             	mov    %ebx,(%esp)
  801c45:	e8 cd fb ff ff       	call   801817 <close>
	return r;
  801c4a:	89 f0                	mov    %esi,%eax
}
  801c4c:	83 c4 10             	add    $0x10,%esp
  801c4f:	5b                   	pop    %ebx
  801c50:	5e                   	pop    %esi
  801c51:	5d                   	pop    %ebp
  801c52:	c3                   	ret    

00801c53 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
  801c56:	56                   	push   %esi
  801c57:	53                   	push   %ebx
  801c58:	83 ec 10             	sub    $0x10,%esp
  801c5b:	89 c6                	mov    %eax,%esi
  801c5d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801c5f:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801c66:	75 11                	jne    801c79 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801c68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c6f:	e8 bd f9 ff ff       	call   801631 <ipc_find_env>
  801c74:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c79:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c80:	00 
  801c81:	c7 44 24 08 00 60 86 	movl   $0x866000,0x8(%esp)
  801c88:	00 
  801c89:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c8d:	a1 04 50 80 00       	mov    0x805004,%eax
  801c92:	89 04 24             	mov    %eax,(%esp)
  801c95:	e8 39 f9 ff ff       	call   8015d3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c9a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ca1:	00 
  801ca2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cad:	e8 b7 f8 ff ff       	call   801569 <ipc_recv>
}
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	5b                   	pop    %ebx
  801cb6:	5e                   	pop    %esi
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    

00801cb9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc5:	a3 00 60 86 00       	mov    %eax,0x866000
	fsipcbuf.set_size.req_size = newsize;
  801cca:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccd:	a3 04 60 86 00       	mov    %eax,0x866004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd7:	b8 02 00 00 00       	mov    $0x2,%eax
  801cdc:	e8 72 ff ff ff       	call   801c53 <fsipc>
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	8b 40 0c             	mov    0xc(%eax),%eax
  801cef:	a3 00 60 86 00       	mov    %eax,0x866000
	return fsipc(FSREQ_FLUSH, NULL);
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf9:	b8 06 00 00 00       	mov    $0x6,%eax
  801cfe:	e8 50 ff ff ff       	call   801c53 <fsipc>
}
  801d03:	c9                   	leave  
  801d04:	c3                   	ret    

00801d05 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d05:	55                   	push   %ebp
  801d06:	89 e5                	mov    %esp,%ebp
  801d08:	53                   	push   %ebx
  801d09:	83 ec 14             	sub    $0x14,%esp
  801d0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d12:	8b 40 0c             	mov    0xc(%eax),%eax
  801d15:	a3 00 60 86 00       	mov    %eax,0x866000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801d1f:	b8 05 00 00 00       	mov    $0x5,%eax
  801d24:	e8 2a ff ff ff       	call   801c53 <fsipc>
  801d29:	89 c2                	mov    %eax,%edx
  801d2b:	85 d2                	test   %edx,%edx
  801d2d:	78 2b                	js     801d5a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d2f:	c7 44 24 04 00 60 86 	movl   $0x866000,0x4(%esp)
  801d36:	00 
  801d37:	89 1c 24             	mov    %ebx,(%esp)
  801d3a:	e8 88 ed ff ff       	call   800ac7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d3f:	a1 80 60 86 00       	mov    0x866080,%eax
  801d44:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d4a:	a1 84 60 86 00       	mov    0x866084,%eax
  801d4f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801d55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5a:	83 c4 14             	add    $0x14,%esp
  801d5d:	5b                   	pop    %ebx
  801d5e:	5d                   	pop    %ebp
  801d5f:	c3                   	ret    

00801d60 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d60:	55                   	push   %ebp
  801d61:	89 e5                	mov    %esp,%ebp
  801d63:	83 ec 18             	sub    $0x18,%esp
  801d66:	8b 45 10             	mov    0x10(%ebp),%eax
  801d69:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801d6e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801d73:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801d76:	a3 04 60 86 00       	mov    %eax,0x866004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  801d7e:	8b 52 0c             	mov    0xc(%edx),%edx
  801d81:	89 15 00 60 86 00    	mov    %edx,0x866000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801d87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d92:	c7 04 24 08 60 86 00 	movl   $0x866008,(%esp)
  801d99:	e8 c6 ee ff ff       	call   800c64 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801d9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801da3:	b8 04 00 00 00       	mov    $0x4,%eax
  801da8:	e8 a6 fe ff ff       	call   801c53 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	56                   	push   %esi
  801db3:	53                   	push   %ebx
  801db4:	83 ec 10             	sub    $0x10,%esp
  801db7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dba:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc0:	a3 00 60 86 00       	mov    %eax,0x866000
	fsipcbuf.read.req_n = n;
  801dc5:	89 35 04 60 86 00    	mov    %esi,0x866004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd0:	b8 03 00 00 00       	mov    $0x3,%eax
  801dd5:	e8 79 fe ff ff       	call   801c53 <fsipc>
  801dda:	89 c3                	mov    %eax,%ebx
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	78 6a                	js     801e4a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801de0:	39 c6                	cmp    %eax,%esi
  801de2:	73 24                	jae    801e08 <devfile_read+0x59>
  801de4:	c7 44 24 0c 2c 33 80 	movl   $0x80332c,0xc(%esp)
  801deb:	00 
  801dec:	c7 44 24 08 33 33 80 	movl   $0x803333,0x8(%esp)
  801df3:	00 
  801df4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801dfb:	00 
  801dfc:	c7 04 24 48 33 80 00 	movl   $0x803348,(%esp)
  801e03:	e8 a4 e5 ff ff       	call   8003ac <_panic>
	assert(r <= PGSIZE);
  801e08:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801e0d:	7e 24                	jle    801e33 <devfile_read+0x84>
  801e0f:	c7 44 24 0c 53 33 80 	movl   $0x803353,0xc(%esp)
  801e16:	00 
  801e17:	c7 44 24 08 33 33 80 	movl   $0x803333,0x8(%esp)
  801e1e:	00 
  801e1f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801e26:	00 
  801e27:	c7 04 24 48 33 80 00 	movl   $0x803348,(%esp)
  801e2e:	e8 79 e5 ff ff       	call   8003ac <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801e33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e37:	c7 44 24 04 00 60 86 	movl   $0x866000,0x4(%esp)
  801e3e:	00 
  801e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e42:	89 04 24             	mov    %eax,(%esp)
  801e45:	e8 1a ee ff ff       	call   800c64 <memmove>
	return r;
}
  801e4a:	89 d8                	mov    %ebx,%eax
  801e4c:	83 c4 10             	add    $0x10,%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5d                   	pop    %ebp
  801e52:	c3                   	ret    

00801e53 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e53:	55                   	push   %ebp
  801e54:	89 e5                	mov    %esp,%ebp
  801e56:	53                   	push   %ebx
  801e57:	83 ec 24             	sub    $0x24,%esp
  801e5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801e5d:	89 1c 24             	mov    %ebx,(%esp)
  801e60:	e8 2b ec ff ff       	call   800a90 <strlen>
  801e65:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e6a:	7f 60                	jg     801ecc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801e6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e6f:	89 04 24             	mov    %eax,(%esp)
  801e72:	e8 20 f8 ff ff       	call   801697 <fd_alloc>
  801e77:	89 c2                	mov    %eax,%edx
  801e79:	85 d2                	test   %edx,%edx
  801e7b:	78 54                	js     801ed1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801e7d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e81:	c7 04 24 00 60 86 00 	movl   $0x866000,(%esp)
  801e88:	e8 3a ec ff ff       	call   800ac7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e90:	a3 00 64 86 00       	mov    %eax,0x866400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e98:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9d:	e8 b1 fd ff ff       	call   801c53 <fsipc>
  801ea2:	89 c3                	mov    %eax,%ebx
  801ea4:	85 c0                	test   %eax,%eax
  801ea6:	79 17                	jns    801ebf <open+0x6c>
		fd_close(fd, 0);
  801ea8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801eaf:	00 
  801eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb3:	89 04 24             	mov    %eax,(%esp)
  801eb6:	e8 db f8 ff ff       	call   801796 <fd_close>
		return r;
  801ebb:	89 d8                	mov    %ebx,%eax
  801ebd:	eb 12                	jmp    801ed1 <open+0x7e>
	}

	return fd2num(fd);
  801ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec2:	89 04 24             	mov    %eax,(%esp)
  801ec5:	e8 a6 f7 ff ff       	call   801670 <fd2num>
  801eca:	eb 05                	jmp    801ed1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801ecc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ed1:	83 c4 24             	add    $0x24,%esp
  801ed4:	5b                   	pop    %ebx
  801ed5:	5d                   	pop    %ebp
  801ed6:	c3                   	ret    

00801ed7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801edd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee2:	b8 08 00 00 00       	mov    $0x8,%eax
  801ee7:	e8 67 fd ff ff       	call   801c53 <fsipc>
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    
  801eee:	66 90                	xchg   %ax,%ax

00801ef0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ef6:	c7 44 24 04 5f 33 80 	movl   $0x80335f,0x4(%esp)
  801efd:	00 
  801efe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f01:	89 04 24             	mov    %eax,(%esp)
  801f04:	e8 be eb ff ff       	call   800ac7 <strcpy>
	return 0;
}
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	53                   	push   %ebx
  801f14:	83 ec 14             	sub    $0x14,%esp
  801f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801f1a:	89 1c 24             	mov    %ebx,(%esp)
  801f1d:	e8 9c 0a 00 00       	call   8029be <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801f22:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801f27:	83 f8 01             	cmp    $0x1,%eax
  801f2a:	75 0d                	jne    801f39 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801f2c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 29 03 00 00       	call   802260 <nsipc_close>
  801f37:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801f39:	89 d0                	mov    %edx,%eax
  801f3b:	83 c4 14             	add    $0x14,%esp
  801f3e:	5b                   	pop    %ebx
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f47:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f4e:	00 
  801f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f59:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f60:	8b 40 0c             	mov    0xc(%eax),%eax
  801f63:	89 04 24             	mov    %eax,(%esp)
  801f66:	e8 f0 03 00 00       	call   80235b <nsipc_send>
}
  801f6b:	c9                   	leave  
  801f6c:	c3                   	ret    

00801f6d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f6d:	55                   	push   %ebp
  801f6e:	89 e5                	mov    %esp,%ebp
  801f70:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f73:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f7a:	00 
  801f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8f:	89 04 24             	mov    %eax,(%esp)
  801f92:	e8 44 03 00 00       	call   8022db <nsipc_recv>
}
  801f97:	c9                   	leave  
  801f98:	c3                   	ret    

00801f99 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801f99:	55                   	push   %ebp
  801f9a:	89 e5                	mov    %esp,%ebp
  801f9c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801f9f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fa2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fa6:	89 04 24             	mov    %eax,(%esp)
  801fa9:	e8 38 f7 ff ff       	call   8016e6 <fd_lookup>
  801fae:	85 c0                	test   %eax,%eax
  801fb0:	78 17                	js     801fc9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801fbb:	39 08                	cmp    %ecx,(%eax)
  801fbd:	75 05                	jne    801fc4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fbf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc2:	eb 05                	jmp    801fc9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801fc4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	56                   	push   %esi
  801fcf:	53                   	push   %ebx
  801fd0:	83 ec 20             	sub    $0x20,%esp
  801fd3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fd5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd8:	89 04 24             	mov    %eax,(%esp)
  801fdb:	e8 b7 f6 ff ff       	call   801697 <fd_alloc>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	78 21                	js     802007 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801fe6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fed:	00 
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ffc:	e8 e2 ee ff ff       	call   800ee3 <sys_page_alloc>
  802001:	89 c3                	mov    %eax,%ebx
  802003:	85 c0                	test   %eax,%eax
  802005:	79 0c                	jns    802013 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  802007:	89 34 24             	mov    %esi,(%esp)
  80200a:	e8 51 02 00 00       	call   802260 <nsipc_close>
		return r;
  80200f:	89 d8                	mov    %ebx,%eax
  802011:	eb 20                	jmp    802033 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802013:	8b 15 20 40 80 00    	mov    0x804020,%edx
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80201e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802021:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  802028:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80202b:	89 14 24             	mov    %edx,(%esp)
  80202e:	e8 3d f6 ff ff       	call   801670 <fd2num>
}
  802033:	83 c4 20             	add    $0x20,%esp
  802036:	5b                   	pop    %ebx
  802037:	5e                   	pop    %esi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	e8 51 ff ff ff       	call   801f99 <fd2sockid>
		return r;
  802048:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204a:	85 c0                	test   %eax,%eax
  80204c:	78 23                	js     802071 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80204e:	8b 55 10             	mov    0x10(%ebp),%edx
  802051:	89 54 24 08          	mov    %edx,0x8(%esp)
  802055:	8b 55 0c             	mov    0xc(%ebp),%edx
  802058:	89 54 24 04          	mov    %edx,0x4(%esp)
  80205c:	89 04 24             	mov    %eax,(%esp)
  80205f:	e8 45 01 00 00       	call   8021a9 <nsipc_accept>
		return r;
  802064:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802066:	85 c0                	test   %eax,%eax
  802068:	78 07                	js     802071 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80206a:	e8 5c ff ff ff       	call   801fcb <alloc_sockfd>
  80206f:	89 c1                	mov    %eax,%ecx
}
  802071:	89 c8                	mov    %ecx,%eax
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	e8 16 ff ff ff       	call   801f99 <fd2sockid>
  802083:	89 c2                	mov    %eax,%edx
  802085:	85 d2                	test   %edx,%edx
  802087:	78 16                	js     80209f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  802089:	8b 45 10             	mov    0x10(%ebp),%eax
  80208c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802090:	8b 45 0c             	mov    0xc(%ebp),%eax
  802093:	89 44 24 04          	mov    %eax,0x4(%esp)
  802097:	89 14 24             	mov    %edx,(%esp)
  80209a:	e8 60 01 00 00       	call   8021ff <nsipc_bind>
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <shutdown>:

int
shutdown(int s, int how)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	e8 ea fe ff ff       	call   801f99 <fd2sockid>
  8020af:	89 c2                	mov    %eax,%edx
  8020b1:	85 d2                	test   %edx,%edx
  8020b3:	78 0f                	js     8020c4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020bc:	89 14 24             	mov    %edx,(%esp)
  8020bf:	e8 7a 01 00 00       	call   80223e <nsipc_shutdown>
}
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	e8 c5 fe ff ff       	call   801f99 <fd2sockid>
  8020d4:	89 c2                	mov    %eax,%edx
  8020d6:	85 d2                	test   %edx,%edx
  8020d8:	78 16                	js     8020f0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  8020da:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e8:	89 14 24             	mov    %edx,(%esp)
  8020eb:	e8 8a 01 00 00       	call   80227a <nsipc_connect>
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <listen>:

int
listen(int s, int backlog)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	e8 99 fe ff ff       	call   801f99 <fd2sockid>
  802100:	89 c2                	mov    %eax,%edx
  802102:	85 d2                	test   %edx,%edx
  802104:	78 0f                	js     802115 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802106:	8b 45 0c             	mov    0xc(%ebp),%eax
  802109:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210d:	89 14 24             	mov    %edx,(%esp)
  802110:	e8 a4 01 00 00       	call   8022b9 <nsipc_listen>
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80211d:	8b 45 10             	mov    0x10(%ebp),%eax
  802120:	89 44 24 08          	mov    %eax,0x8(%esp)
  802124:	8b 45 0c             	mov    0xc(%ebp),%eax
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 04 24             	mov    %eax,(%esp)
  802131:	e8 98 02 00 00       	call   8023ce <nsipc_socket>
  802136:	89 c2                	mov    %eax,%edx
  802138:	85 d2                	test   %edx,%edx
  80213a:	78 05                	js     802141 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80213c:	e8 8a fe ff ff       	call   801fcb <alloc_sockfd>
}
  802141:	c9                   	leave  
  802142:	c3                   	ret    

00802143 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802143:	55                   	push   %ebp
  802144:	89 e5                	mov    %esp,%ebp
  802146:	53                   	push   %ebx
  802147:	83 ec 14             	sub    $0x14,%esp
  80214a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80214c:	83 3d 08 50 80 00 00 	cmpl   $0x0,0x805008
  802153:	75 11                	jne    802166 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802155:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80215c:	e8 d0 f4 ff ff       	call   801631 <ipc_find_env>
  802161:	a3 08 50 80 00       	mov    %eax,0x805008
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802166:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80216d:	00 
  80216e:	c7 44 24 08 00 70 86 	movl   $0x867000,0x8(%esp)
  802175:	00 
  802176:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80217a:	a1 08 50 80 00       	mov    0x805008,%eax
  80217f:	89 04 24             	mov    %eax,(%esp)
  802182:	e8 4c f4 ff ff       	call   8015d3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802187:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80218e:	00 
  80218f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802196:	00 
  802197:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80219e:	e8 c6 f3 ff ff       	call   801569 <ipc_recv>
}
  8021a3:	83 c4 14             	add    $0x14,%esp
  8021a6:	5b                   	pop    %ebx
  8021a7:	5d                   	pop    %ebp
  8021a8:	c3                   	ret    

008021a9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8021a9:	55                   	push   %ebp
  8021aa:	89 e5                	mov    %esp,%ebp
  8021ac:	56                   	push   %esi
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 10             	sub    $0x10,%esp
  8021b1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8021bc:	8b 06                	mov    (%esi),%eax
  8021be:	a3 04 70 86 00       	mov    %eax,0x867004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8021c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8021c8:	e8 76 ff ff ff       	call   802143 <nsipc>
  8021cd:	89 c3                	mov    %eax,%ebx
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	78 23                	js     8021f6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8021d3:	a1 10 70 86 00       	mov    0x867010,%eax
  8021d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021dc:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  8021e3:	00 
  8021e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e7:	89 04 24             	mov    %eax,(%esp)
  8021ea:	e8 75 ea ff ff       	call   800c64 <memmove>
		*addrlen = ret->ret_addrlen;
  8021ef:	a1 10 70 86 00       	mov    0x867010,%eax
  8021f4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  8021f6:	89 d8                	mov    %ebx,%eax
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5d                   	pop    %ebp
  8021fe:	c3                   	ret    

008021ff <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021ff:	55                   	push   %ebp
  802200:	89 e5                	mov    %esp,%ebp
  802202:	53                   	push   %ebx
  802203:	83 ec 14             	sub    $0x14,%esp
  802206:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	a3 00 70 86 00       	mov    %eax,0x867000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802211:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802215:	8b 45 0c             	mov    0xc(%ebp),%eax
  802218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80221c:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  802223:	e8 3c ea ff ff       	call   800c64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802228:	89 1d 14 70 86 00    	mov    %ebx,0x867014
	return nsipc(NSREQ_BIND);
  80222e:	b8 02 00 00 00       	mov    $0x2,%eax
  802233:	e8 0b ff ff ff       	call   802143 <nsipc>
}
  802238:	83 c4 14             	add    $0x14,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5d                   	pop    %ebp
  80223d:	c3                   	ret    

0080223e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80223e:	55                   	push   %ebp
  80223f:	89 e5                	mov    %esp,%ebp
  802241:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.shutdown.req_how = how;
  80224c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224f:	a3 04 70 86 00       	mov    %eax,0x867004
	return nsipc(NSREQ_SHUTDOWN);
  802254:	b8 03 00 00 00       	mov    $0x3,%eax
  802259:	e8 e5 fe ff ff       	call   802143 <nsipc>
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <nsipc_close>:

int
nsipc_close(int s)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	a3 00 70 86 00       	mov    %eax,0x867000
	return nsipc(NSREQ_CLOSE);
  80226e:	b8 04 00 00 00       	mov    $0x4,%eax
  802273:	e8 cb fe ff ff       	call   802143 <nsipc>
}
  802278:	c9                   	leave  
  802279:	c3                   	ret    

0080227a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	53                   	push   %ebx
  80227e:	83 ec 14             	sub    $0x14,%esp
  802281:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802284:	8b 45 08             	mov    0x8(%ebp),%eax
  802287:	a3 00 70 86 00       	mov    %eax,0x867000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80228c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	89 44 24 04          	mov    %eax,0x4(%esp)
  802297:	c7 04 24 04 70 86 00 	movl   $0x867004,(%esp)
  80229e:	e8 c1 e9 ff ff       	call   800c64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022a3:	89 1d 14 70 86 00    	mov    %ebx,0x867014
	return nsipc(NSREQ_CONNECT);
  8022a9:	b8 05 00 00 00       	mov    $0x5,%eax
  8022ae:	e8 90 fe ff ff       	call   802143 <nsipc>
}
  8022b3:	83 c4 14             	add    $0x14,%esp
  8022b6:	5b                   	pop    %ebx
  8022b7:	5d                   	pop    %ebp
  8022b8:	c3                   	ret    

008022b9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
  8022bc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c2:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.listen.req_backlog = backlog;
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	a3 04 70 86 00       	mov    %eax,0x867004
	return nsipc(NSREQ_LISTEN);
  8022cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8022d4:	e8 6a fe ff ff       	call   802143 <nsipc>
}
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	83 ec 10             	sub    $0x10,%esp
  8022e3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.recv.req_len = len;
  8022ee:	89 35 04 70 86 00    	mov    %esi,0x867004
	nsipcbuf.recv.req_flags = flags;
  8022f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8022f7:	a3 08 70 86 00       	mov    %eax,0x867008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022fc:	b8 07 00 00 00       	mov    $0x7,%eax
  802301:	e8 3d fe ff ff       	call   802143 <nsipc>
  802306:	89 c3                	mov    %eax,%ebx
  802308:	85 c0                	test   %eax,%eax
  80230a:	78 46                	js     802352 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80230c:	39 f0                	cmp    %esi,%eax
  80230e:	7f 07                	jg     802317 <nsipc_recv+0x3c>
  802310:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802315:	7e 24                	jle    80233b <nsipc_recv+0x60>
  802317:	c7 44 24 0c 6b 33 80 	movl   $0x80336b,0xc(%esp)
  80231e:	00 
  80231f:	c7 44 24 08 33 33 80 	movl   $0x803333,0x8(%esp)
  802326:	00 
  802327:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80232e:	00 
  80232f:	c7 04 24 80 33 80 00 	movl   $0x803380,(%esp)
  802336:	e8 71 e0 ff ff       	call   8003ac <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80233b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80233f:	c7 44 24 04 00 70 86 	movl   $0x867000,0x4(%esp)
  802346:	00 
  802347:	8b 45 0c             	mov    0xc(%ebp),%eax
  80234a:	89 04 24             	mov    %eax,(%esp)
  80234d:	e8 12 e9 ff ff       	call   800c64 <memmove>
	}

	return r;
}
  802352:	89 d8                	mov    %ebx,%eax
  802354:	83 c4 10             	add    $0x10,%esp
  802357:	5b                   	pop    %ebx
  802358:	5e                   	pop    %esi
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    

0080235b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	53                   	push   %ebx
  80235f:	83 ec 14             	sub    $0x14,%esp
  802362:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802365:	8b 45 08             	mov    0x8(%ebp),%eax
  802368:	a3 00 70 86 00       	mov    %eax,0x867000
	assert(size < 1600);
  80236d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802373:	7e 24                	jle    802399 <nsipc_send+0x3e>
  802375:	c7 44 24 0c 8c 33 80 	movl   $0x80338c,0xc(%esp)
  80237c:	00 
  80237d:	c7 44 24 08 33 33 80 	movl   $0x803333,0x8(%esp)
  802384:	00 
  802385:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80238c:	00 
  80238d:	c7 04 24 80 33 80 00 	movl   $0x803380,(%esp)
  802394:	e8 13 e0 ff ff       	call   8003ac <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802399:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80239d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a4:	c7 04 24 0c 70 86 00 	movl   $0x86700c,(%esp)
  8023ab:	e8 b4 e8 ff ff       	call   800c64 <memmove>
	nsipcbuf.send.req_size = size;
  8023b0:	89 1d 04 70 86 00    	mov    %ebx,0x867004
	nsipcbuf.send.req_flags = flags;
  8023b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8023b9:	a3 08 70 86 00       	mov    %eax,0x867008
	return nsipc(NSREQ_SEND);
  8023be:	b8 08 00 00 00       	mov    $0x8,%eax
  8023c3:	e8 7b fd ff ff       	call   802143 <nsipc>
}
  8023c8:	83 c4 14             	add    $0x14,%esp
  8023cb:	5b                   	pop    %ebx
  8023cc:	5d                   	pop    %ebp
  8023cd:	c3                   	ret    

008023ce <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8023ce:	55                   	push   %ebp
  8023cf:	89 e5                	mov    %esp,%ebp
  8023d1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	a3 00 70 86 00       	mov    %eax,0x867000
	nsipcbuf.socket.req_type = type;
  8023dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023df:	a3 04 70 86 00       	mov    %eax,0x867004
	nsipcbuf.socket.req_protocol = protocol;
  8023e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023e7:	a3 08 70 86 00       	mov    %eax,0x867008
	return nsipc(NSREQ_SOCKET);
  8023ec:	b8 09 00 00 00       	mov    $0x9,%eax
  8023f1:	e8 4d fd ff ff       	call   802143 <nsipc>
}
  8023f6:	c9                   	leave  
  8023f7:	c3                   	ret    

008023f8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	83 ec 10             	sub    $0x10,%esp
  802400:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	89 04 24             	mov    %eax,(%esp)
  802409:	e8 72 f2 ff ff       	call   801680 <fd2data>
  80240e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802410:	c7 44 24 04 98 33 80 	movl   $0x803398,0x4(%esp)
  802417:	00 
  802418:	89 1c 24             	mov    %ebx,(%esp)
  80241b:	e8 a7 e6 ff ff       	call   800ac7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802420:	8b 46 04             	mov    0x4(%esi),%eax
  802423:	2b 06                	sub    (%esi),%eax
  802425:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80242b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802432:	00 00 00 
	stat->st_dev = &devpipe;
  802435:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80243c:	40 80 00 
	return 0;
}
  80243f:	b8 00 00 00 00       	mov    $0x0,%eax
  802444:	83 c4 10             	add    $0x10,%esp
  802447:	5b                   	pop    %ebx
  802448:	5e                   	pop    %esi
  802449:	5d                   	pop    %ebp
  80244a:	c3                   	ret    

0080244b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80244b:	55                   	push   %ebp
  80244c:	89 e5                	mov    %esp,%ebp
  80244e:	53                   	push   %ebx
  80244f:	83 ec 14             	sub    $0x14,%esp
  802452:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802455:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802460:	e8 25 eb ff ff       	call   800f8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802465:	89 1c 24             	mov    %ebx,(%esp)
  802468:	e8 13 f2 ff ff       	call   801680 <fd2data>
  80246d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802471:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802478:	e8 0d eb ff ff       	call   800f8a <sys_page_unmap>
}
  80247d:	83 c4 14             	add    $0x14,%esp
  802480:	5b                   	pop    %ebx
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    

00802483 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	57                   	push   %edi
  802487:	56                   	push   %esi
  802488:	53                   	push   %ebx
  802489:	83 ec 2c             	sub    $0x2c,%esp
  80248c:	89 c6                	mov    %eax,%esi
  80248e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802491:	a1 40 50 86 00       	mov    0x865040,%eax
  802496:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802499:	89 34 24             	mov    %esi,(%esp)
  80249c:	e8 1d 05 00 00       	call   8029be <pageref>
  8024a1:	89 c7                	mov    %eax,%edi
  8024a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024a6:	89 04 24             	mov    %eax,(%esp)
  8024a9:	e8 10 05 00 00       	call   8029be <pageref>
  8024ae:	39 c7                	cmp    %eax,%edi
  8024b0:	0f 94 c2             	sete   %dl
  8024b3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8024b6:	8b 0d 40 50 86 00    	mov    0x865040,%ecx
  8024bc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8024bf:	39 fb                	cmp    %edi,%ebx
  8024c1:	74 21                	je     8024e4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8024c3:	84 d2                	test   %dl,%dl
  8024c5:	74 ca                	je     802491 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8024c7:	8b 51 58             	mov    0x58(%ecx),%edx
  8024ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ce:	89 54 24 08          	mov    %edx,0x8(%esp)
  8024d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024d6:	c7 04 24 9f 33 80 00 	movl   $0x80339f,(%esp)
  8024dd:	e8 c3 df ff ff       	call   8004a5 <cprintf>
  8024e2:	eb ad                	jmp    802491 <_pipeisclosed+0xe>
	}
}
  8024e4:	83 c4 2c             	add    $0x2c,%esp
  8024e7:	5b                   	pop    %ebx
  8024e8:	5e                   	pop    %esi
  8024e9:	5f                   	pop    %edi
  8024ea:	5d                   	pop    %ebp
  8024eb:	c3                   	ret    

008024ec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024ec:	55                   	push   %ebp
  8024ed:	89 e5                	mov    %esp,%ebp
  8024ef:	57                   	push   %edi
  8024f0:	56                   	push   %esi
  8024f1:	53                   	push   %ebx
  8024f2:	83 ec 1c             	sub    $0x1c,%esp
  8024f5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024f8:	89 34 24             	mov    %esi,(%esp)
  8024fb:	e8 80 f1 ff ff       	call   801680 <fd2data>
  802500:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802502:	bf 00 00 00 00       	mov    $0x0,%edi
  802507:	eb 45                	jmp    80254e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802509:	89 da                	mov    %ebx,%edx
  80250b:	89 f0                	mov    %esi,%eax
  80250d:	e8 71 ff ff ff       	call   802483 <_pipeisclosed>
  802512:	85 c0                	test   %eax,%eax
  802514:	75 41                	jne    802557 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802516:	e8 a9 e9 ff ff       	call   800ec4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80251b:	8b 43 04             	mov    0x4(%ebx),%eax
  80251e:	8b 0b                	mov    (%ebx),%ecx
  802520:	8d 51 20             	lea    0x20(%ecx),%edx
  802523:	39 d0                	cmp    %edx,%eax
  802525:	73 e2                	jae    802509 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802527:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80252a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80252e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802531:	99                   	cltd   
  802532:	c1 ea 1b             	shr    $0x1b,%edx
  802535:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802538:	83 e1 1f             	and    $0x1f,%ecx
  80253b:	29 d1                	sub    %edx,%ecx
  80253d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802541:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802545:	83 c0 01             	add    $0x1,%eax
  802548:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254b:	83 c7 01             	add    $0x1,%edi
  80254e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802551:	75 c8                	jne    80251b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802553:	89 f8                	mov    %edi,%eax
  802555:	eb 05                	jmp    80255c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802557:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80255c:	83 c4 1c             	add    $0x1c,%esp
  80255f:	5b                   	pop    %ebx
  802560:	5e                   	pop    %esi
  802561:	5f                   	pop    %edi
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    

00802564 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802564:	55                   	push   %ebp
  802565:	89 e5                	mov    %esp,%ebp
  802567:	57                   	push   %edi
  802568:	56                   	push   %esi
  802569:	53                   	push   %ebx
  80256a:	83 ec 1c             	sub    $0x1c,%esp
  80256d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802570:	89 3c 24             	mov    %edi,(%esp)
  802573:	e8 08 f1 ff ff       	call   801680 <fd2data>
  802578:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80257a:	be 00 00 00 00       	mov    $0x0,%esi
  80257f:	eb 3d                	jmp    8025be <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802581:	85 f6                	test   %esi,%esi
  802583:	74 04                	je     802589 <devpipe_read+0x25>
				return i;
  802585:	89 f0                	mov    %esi,%eax
  802587:	eb 43                	jmp    8025cc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802589:	89 da                	mov    %ebx,%edx
  80258b:	89 f8                	mov    %edi,%eax
  80258d:	e8 f1 fe ff ff       	call   802483 <_pipeisclosed>
  802592:	85 c0                	test   %eax,%eax
  802594:	75 31                	jne    8025c7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802596:	e8 29 e9 ff ff       	call   800ec4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80259b:	8b 03                	mov    (%ebx),%eax
  80259d:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a0:	74 df                	je     802581 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025a2:	99                   	cltd   
  8025a3:	c1 ea 1b             	shr    $0x1b,%edx
  8025a6:	01 d0                	add    %edx,%eax
  8025a8:	83 e0 1f             	and    $0x1f,%eax
  8025ab:	29 d0                	sub    %edx,%eax
  8025ad:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8025b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025b5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8025b8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025bb:	83 c6 01             	add    $0x1,%esi
  8025be:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025c1:	75 d8                	jne    80259b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025c3:	89 f0                	mov    %esi,%eax
  8025c5:	eb 05                	jmp    8025cc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8025cc:	83 c4 1c             	add    $0x1c,%esp
  8025cf:	5b                   	pop    %ebx
  8025d0:	5e                   	pop    %esi
  8025d1:	5f                   	pop    %edi
  8025d2:	5d                   	pop    %ebp
  8025d3:	c3                   	ret    

008025d4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
  8025d7:	56                   	push   %esi
  8025d8:	53                   	push   %ebx
  8025d9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025df:	89 04 24             	mov    %eax,(%esp)
  8025e2:	e8 b0 f0 ff ff       	call   801697 <fd_alloc>
  8025e7:	89 c2                	mov    %eax,%edx
  8025e9:	85 d2                	test   %edx,%edx
  8025eb:	0f 88 4d 01 00 00    	js     80273e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f8:	00 
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802600:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802607:	e8 d7 e8 ff ff       	call   800ee3 <sys_page_alloc>
  80260c:	89 c2                	mov    %eax,%edx
  80260e:	85 d2                	test   %edx,%edx
  802610:	0f 88 28 01 00 00    	js     80273e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802616:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802619:	89 04 24             	mov    %eax,(%esp)
  80261c:	e8 76 f0 ff ff       	call   801697 <fd_alloc>
  802621:	89 c3                	mov    %eax,%ebx
  802623:	85 c0                	test   %eax,%eax
  802625:	0f 88 fe 00 00 00    	js     802729 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802632:	00 
  802633:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802636:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802641:	e8 9d e8 ff ff       	call   800ee3 <sys_page_alloc>
  802646:	89 c3                	mov    %eax,%ebx
  802648:	85 c0                	test   %eax,%eax
  80264a:	0f 88 d9 00 00 00    	js     802729 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	89 04 24             	mov    %eax,(%esp)
  802656:	e8 25 f0 ff ff       	call   801680 <fd2data>
  80265b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802664:	00 
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802670:	e8 6e e8 ff ff       	call   800ee3 <sys_page_alloc>
  802675:	89 c3                	mov    %eax,%ebx
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 88 97 00 00 00    	js     802716 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802682:	89 04 24             	mov    %eax,(%esp)
  802685:	e8 f6 ef ff ff       	call   801680 <fd2data>
  80268a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802691:	00 
  802692:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802696:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80269d:	00 
  80269e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a9:	e8 89 e8 ff ff       	call   800f37 <sys_page_map>
  8026ae:	89 c3                	mov    %eax,%ebx
  8026b0:	85 c0                	test   %eax,%eax
  8026b2:	78 52                	js     802706 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026b4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8026bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8026c9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8026cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	89 04 24             	mov    %eax,(%esp)
  8026e4:	e8 87 ef ff ff       	call   801670 <fd2num>
  8026e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ec:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	89 04 24             	mov    %eax,(%esp)
  8026f4:	e8 77 ef ff ff       	call   801670 <fd2num>
  8026f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026fc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	eb 38                	jmp    80273e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80270a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802711:	e8 74 e8 ff ff       	call   800f8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	89 44 24 04          	mov    %eax,0x4(%esp)
  80271d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802724:	e8 61 e8 ff ff       	call   800f8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802729:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802737:	e8 4e e8 ff ff       	call   800f8a <sys_page_unmap>
  80273c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80273e:	83 c4 30             	add    $0x30,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5d                   	pop    %ebp
  802744:	c3                   	ret    

00802745 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802745:	55                   	push   %ebp
  802746:	89 e5                	mov    %esp,%ebp
  802748:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80274b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80274e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	89 04 24             	mov    %eax,(%esp)
  802758:	e8 89 ef ff ff       	call   8016e6 <fd_lookup>
  80275d:	89 c2                	mov    %eax,%edx
  80275f:	85 d2                	test   %edx,%edx
  802761:	78 15                	js     802778 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	89 04 24             	mov    %eax,(%esp)
  802769:	e8 12 ef ff ff       	call   801680 <fd2data>
	return _pipeisclosed(fd, p);
  80276e:	89 c2                	mov    %eax,%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	e8 0b fd ff ff       	call   802483 <_pipeisclosed>
}
  802778:	c9                   	leave  
  802779:	c3                   	ret    
  80277a:	66 90                	xchg   %ax,%ax
  80277c:	66 90                	xchg   %ax,%ax
  80277e:	66 90                	xchg   %ax,%ax

00802780 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    

0080278a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802790:	c7 44 24 04 b7 33 80 	movl   $0x8033b7,0x4(%esp)
  802797:	00 
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 24 e3 ff ff       	call   800ac7 <strcpy>
	return 0;
}
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	57                   	push   %edi
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027bb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027c1:	eb 31                	jmp    8027f4 <devcons_write+0x4a>
		m = n - tot;
  8027c3:	8b 75 10             	mov    0x10(%ebp),%esi
  8027c6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8027c8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027cb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8027d0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027d3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8027d7:	03 45 0c             	add    0xc(%ebp),%eax
  8027da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027de:	89 3c 24             	mov    %edi,(%esp)
  8027e1:	e8 7e e4 ff ff       	call   800c64 <memmove>
		sys_cputs(buf, m);
  8027e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027ea:	89 3c 24             	mov    %edi,(%esp)
  8027ed:	e8 24 e6 ff ff       	call   800e16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027f2:	01 f3                	add    %esi,%ebx
  8027f4:	89 d8                	mov    %ebx,%eax
  8027f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8027f9:	72 c8                	jb     8027c3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027fb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802801:	5b                   	pop    %ebx
  802802:	5e                   	pop    %esi
  802803:	5f                   	pop    %edi
  802804:	5d                   	pop    %ebp
  802805:	c3                   	ret    

00802806 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802806:	55                   	push   %ebp
  802807:	89 e5                	mov    %esp,%ebp
  802809:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802811:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802815:	75 07                	jne    80281e <devcons_read+0x18>
  802817:	eb 2a                	jmp    802843 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802819:	e8 a6 e6 ff ff       	call   800ec4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80281e:	66 90                	xchg   %ax,%ax
  802820:	e8 0f e6 ff ff       	call   800e34 <sys_cgetc>
  802825:	85 c0                	test   %eax,%eax
  802827:	74 f0                	je     802819 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802829:	85 c0                	test   %eax,%eax
  80282b:	78 16                	js     802843 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80282d:	83 f8 04             	cmp    $0x4,%eax
  802830:	74 0c                	je     80283e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802832:	8b 55 0c             	mov    0xc(%ebp),%edx
  802835:	88 02                	mov    %al,(%edx)
	return 1;
  802837:	b8 01 00 00 00       	mov    $0x1,%eax
  80283c:	eb 05                	jmp    802843 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80283e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802843:	c9                   	leave  
  802844:	c3                   	ret    

00802845 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802845:	55                   	push   %ebp
  802846:	89 e5                	mov    %esp,%ebp
  802848:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802851:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802858:	00 
  802859:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80285c:	89 04 24             	mov    %eax,(%esp)
  80285f:	e8 b2 e5 ff ff       	call   800e16 <sys_cputs>
}
  802864:	c9                   	leave  
  802865:	c3                   	ret    

00802866 <getchar>:

int
getchar(void)
{
  802866:	55                   	push   %ebp
  802867:	89 e5                	mov    %esp,%ebp
  802869:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80286c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802873:	00 
  802874:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802882:	e8 f3 f0 ff ff       	call   80197a <read>
	if (r < 0)
  802887:	85 c0                	test   %eax,%eax
  802889:	78 0f                	js     80289a <getchar+0x34>
		return r;
	if (r < 1)
  80288b:	85 c0                	test   %eax,%eax
  80288d:	7e 06                	jle    802895 <getchar+0x2f>
		return -E_EOF;
	return c;
  80288f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802893:	eb 05                	jmp    80289a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802895:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80289a:	c9                   	leave  
  80289b:	c3                   	ret    

0080289c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80289c:	55                   	push   %ebp
  80289d:	89 e5                	mov    %esp,%ebp
  80289f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	89 04 24             	mov    %eax,(%esp)
  8028af:	e8 32 ee ff ff       	call   8016e6 <fd_lookup>
  8028b4:	85 c0                	test   %eax,%eax
  8028b6:	78 11                	js     8028c9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8028c1:	39 10                	cmp    %edx,(%eax)
  8028c3:	0f 94 c0             	sete   %al
  8028c6:	0f b6 c0             	movzbl %al,%eax
}
  8028c9:	c9                   	leave  
  8028ca:	c3                   	ret    

008028cb <opencons>:

int
opencons(void)
{
  8028cb:	55                   	push   %ebp
  8028cc:	89 e5                	mov    %esp,%ebp
  8028ce:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028d4:	89 04 24             	mov    %eax,(%esp)
  8028d7:	e8 bb ed ff ff       	call   801697 <fd_alloc>
		return r;
  8028dc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	78 40                	js     802922 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028e2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028e9:	00 
  8028ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f8:	e8 e6 e5 ff ff       	call   800ee3 <sys_page_alloc>
		return r;
  8028fd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8028ff:	85 c0                	test   %eax,%eax
  802901:	78 1f                	js     802922 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802903:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802909:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802918:	89 04 24             	mov    %eax,(%esp)
  80291b:	e8 50 ed ff ff       	call   801670 <fd2num>
  802920:	89 c2                	mov    %eax,%edx
}
  802922:	89 d0                	mov    %edx,%eax
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80292c:	83 3d 00 80 86 00 00 	cmpl   $0x0,0x868000
  802933:	75 58                	jne    80298d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802935:	a1 40 50 86 00       	mov    0x865040,%eax
  80293a:	8b 40 48             	mov    0x48(%eax),%eax
  80293d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802944:	00 
  802945:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80294c:	ee 
  80294d:	89 04 24             	mov    %eax,(%esp)
  802950:	e8 8e e5 ff ff       	call   800ee3 <sys_page_alloc>
		if(return_code!=0)
  802955:	85 c0                	test   %eax,%eax
  802957:	74 1c                	je     802975 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802959:	c7 44 24 08 c4 33 80 	movl   $0x8033c4,0x8(%esp)
  802960:	00 
  802961:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802968:	00 
  802969:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  802970:	e8 37 da ff ff       	call   8003ac <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802975:	a1 40 50 86 00       	mov    0x865040,%eax
  80297a:	8b 40 48             	mov    0x48(%eax),%eax
  80297d:	c7 44 24 04 97 29 80 	movl   $0x802997,0x4(%esp)
  802984:	00 
  802985:	89 04 24             	mov    %eax,(%esp)
  802988:	e8 f6 e6 ff ff       	call   801083 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	a3 00 80 86 00       	mov    %eax,0x868000
}
  802995:	c9                   	leave  
  802996:	c3                   	ret    

00802997 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802997:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802998:	a1 00 80 86 00       	mov    0x868000,%eax
	call *%eax
  80299d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80299f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8029a2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8029a4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8029a8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8029ac:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8029ad:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8029af:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8029b1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8029b5:	58                   	pop    %eax
	popl %eax;
  8029b6:	58                   	pop    %eax
	popal;
  8029b7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8029b8:	83 c4 04             	add    $0x4,%esp
	popfl;
  8029bb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8029bc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8029bd:	c3                   	ret    

008029be <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029be:	55                   	push   %ebp
  8029bf:	89 e5                	mov    %esp,%ebp
  8029c1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029c4:	89 d0                	mov    %edx,%eax
  8029c6:	c1 e8 16             	shr    $0x16,%eax
  8029c9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8029d0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8029d5:	f6 c1 01             	test   $0x1,%cl
  8029d8:	74 1d                	je     8029f7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8029da:	c1 ea 0c             	shr    $0xc,%edx
  8029dd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8029e4:	f6 c2 01             	test   $0x1,%dl
  8029e7:	74 0e                	je     8029f7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8029e9:	c1 ea 0c             	shr    $0xc,%edx
  8029ec:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8029f3:	ef 
  8029f4:	0f b7 c0             	movzwl %ax,%eax
}
  8029f7:	5d                   	pop    %ebp
  8029f8:	c3                   	ret    
  8029f9:	66 90                	xchg   %ax,%ax
  8029fb:	66 90                	xchg   %ax,%ax
  8029fd:	66 90                	xchg   %ax,%ax
  8029ff:	90                   	nop

00802a00 <__udivdi3>:
  802a00:	55                   	push   %ebp
  802a01:	57                   	push   %edi
  802a02:	56                   	push   %esi
  802a03:	83 ec 0c             	sub    $0xc,%esp
  802a06:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a0a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  802a0e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802a12:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a16:	85 c0                	test   %eax,%eax
  802a18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a1c:	89 ea                	mov    %ebp,%edx
  802a1e:	89 0c 24             	mov    %ecx,(%esp)
  802a21:	75 2d                	jne    802a50 <__udivdi3+0x50>
  802a23:	39 e9                	cmp    %ebp,%ecx
  802a25:	77 61                	ja     802a88 <__udivdi3+0x88>
  802a27:	85 c9                	test   %ecx,%ecx
  802a29:	89 ce                	mov    %ecx,%esi
  802a2b:	75 0b                	jne    802a38 <__udivdi3+0x38>
  802a2d:	b8 01 00 00 00       	mov    $0x1,%eax
  802a32:	31 d2                	xor    %edx,%edx
  802a34:	f7 f1                	div    %ecx
  802a36:	89 c6                	mov    %eax,%esi
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	89 e8                	mov    %ebp,%eax
  802a3c:	f7 f6                	div    %esi
  802a3e:	89 c5                	mov    %eax,%ebp
  802a40:	89 f8                	mov    %edi,%eax
  802a42:	f7 f6                	div    %esi
  802a44:	89 ea                	mov    %ebp,%edx
  802a46:	83 c4 0c             	add    $0xc,%esp
  802a49:	5e                   	pop    %esi
  802a4a:	5f                   	pop    %edi
  802a4b:	5d                   	pop    %ebp
  802a4c:	c3                   	ret    
  802a4d:	8d 76 00             	lea    0x0(%esi),%esi
  802a50:	39 e8                	cmp    %ebp,%eax
  802a52:	77 24                	ja     802a78 <__udivdi3+0x78>
  802a54:	0f bd e8             	bsr    %eax,%ebp
  802a57:	83 f5 1f             	xor    $0x1f,%ebp
  802a5a:	75 3c                	jne    802a98 <__udivdi3+0x98>
  802a5c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a60:	39 34 24             	cmp    %esi,(%esp)
  802a63:	0f 86 9f 00 00 00    	jbe    802b08 <__udivdi3+0x108>
  802a69:	39 d0                	cmp    %edx,%eax
  802a6b:	0f 82 97 00 00 00    	jb     802b08 <__udivdi3+0x108>
  802a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802a78:	31 d2                	xor    %edx,%edx
  802a7a:	31 c0                	xor    %eax,%eax
  802a7c:	83 c4 0c             	add    $0xc,%esp
  802a7f:	5e                   	pop    %esi
  802a80:	5f                   	pop    %edi
  802a81:	5d                   	pop    %ebp
  802a82:	c3                   	ret    
  802a83:	90                   	nop
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	89 f8                	mov    %edi,%eax
  802a8a:	f7 f1                	div    %ecx
  802a8c:	31 d2                	xor    %edx,%edx
  802a8e:	83 c4 0c             	add    $0xc,%esp
  802a91:	5e                   	pop    %esi
  802a92:	5f                   	pop    %edi
  802a93:	5d                   	pop    %ebp
  802a94:	c3                   	ret    
  802a95:	8d 76 00             	lea    0x0(%esi),%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	8b 3c 24             	mov    (%esp),%edi
  802a9d:	d3 e0                	shl    %cl,%eax
  802a9f:	89 c6                	mov    %eax,%esi
  802aa1:	b8 20 00 00 00       	mov    $0x20,%eax
  802aa6:	29 e8                	sub    %ebp,%eax
  802aa8:	89 c1                	mov    %eax,%ecx
  802aaa:	d3 ef                	shr    %cl,%edi
  802aac:	89 e9                	mov    %ebp,%ecx
  802aae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802ab2:	8b 3c 24             	mov    (%esp),%edi
  802ab5:	09 74 24 08          	or     %esi,0x8(%esp)
  802ab9:	89 d6                	mov    %edx,%esi
  802abb:	d3 e7                	shl    %cl,%edi
  802abd:	89 c1                	mov    %eax,%ecx
  802abf:	89 3c 24             	mov    %edi,(%esp)
  802ac2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802ac6:	d3 ee                	shr    %cl,%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	d3 e2                	shl    %cl,%edx
  802acc:	89 c1                	mov    %eax,%ecx
  802ace:	d3 ef                	shr    %cl,%edi
  802ad0:	09 d7                	or     %edx,%edi
  802ad2:	89 f2                	mov    %esi,%edx
  802ad4:	89 f8                	mov    %edi,%eax
  802ad6:	f7 74 24 08          	divl   0x8(%esp)
  802ada:	89 d6                	mov    %edx,%esi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	f7 24 24             	mull   (%esp)
  802ae1:	39 d6                	cmp    %edx,%esi
  802ae3:	89 14 24             	mov    %edx,(%esp)
  802ae6:	72 30                	jb     802b18 <__udivdi3+0x118>
  802ae8:	8b 54 24 04          	mov    0x4(%esp),%edx
  802aec:	89 e9                	mov    %ebp,%ecx
  802aee:	d3 e2                	shl    %cl,%edx
  802af0:	39 c2                	cmp    %eax,%edx
  802af2:	73 05                	jae    802af9 <__udivdi3+0xf9>
  802af4:	3b 34 24             	cmp    (%esp),%esi
  802af7:	74 1f                	je     802b18 <__udivdi3+0x118>
  802af9:	89 f8                	mov    %edi,%eax
  802afb:	31 d2                	xor    %edx,%edx
  802afd:	e9 7a ff ff ff       	jmp    802a7c <__udivdi3+0x7c>
  802b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b08:	31 d2                	xor    %edx,%edx
  802b0a:	b8 01 00 00 00       	mov    $0x1,%eax
  802b0f:	e9 68 ff ff ff       	jmp    802a7c <__udivdi3+0x7c>
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	8d 47 ff             	lea    -0x1(%edi),%eax
  802b1b:	31 d2                	xor    %edx,%edx
  802b1d:	83 c4 0c             	add    $0xc,%esp
  802b20:	5e                   	pop    %esi
  802b21:	5f                   	pop    %edi
  802b22:	5d                   	pop    %ebp
  802b23:	c3                   	ret    
  802b24:	66 90                	xchg   %ax,%ax
  802b26:	66 90                	xchg   %ax,%ax
  802b28:	66 90                	xchg   %ax,%ax
  802b2a:	66 90                	xchg   %ax,%ax
  802b2c:	66 90                	xchg   %ax,%ax
  802b2e:	66 90                	xchg   %ax,%ax

00802b30 <__umoddi3>:
  802b30:	55                   	push   %ebp
  802b31:	57                   	push   %edi
  802b32:	56                   	push   %esi
  802b33:	83 ec 14             	sub    $0x14,%esp
  802b36:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b3a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802b3e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802b42:	89 c7                	mov    %eax,%edi
  802b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b48:	8b 44 24 30          	mov    0x30(%esp),%eax
  802b4c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802b50:	89 34 24             	mov    %esi,(%esp)
  802b53:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b57:	85 c0                	test   %eax,%eax
  802b59:	89 c2                	mov    %eax,%edx
  802b5b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b5f:	75 17                	jne    802b78 <__umoddi3+0x48>
  802b61:	39 fe                	cmp    %edi,%esi
  802b63:	76 4b                	jbe    802bb0 <__umoddi3+0x80>
  802b65:	89 c8                	mov    %ecx,%eax
  802b67:	89 fa                	mov    %edi,%edx
  802b69:	f7 f6                	div    %esi
  802b6b:	89 d0                	mov    %edx,%eax
  802b6d:	31 d2                	xor    %edx,%edx
  802b6f:	83 c4 14             	add    $0x14,%esp
  802b72:	5e                   	pop    %esi
  802b73:	5f                   	pop    %edi
  802b74:	5d                   	pop    %ebp
  802b75:	c3                   	ret    
  802b76:	66 90                	xchg   %ax,%ax
  802b78:	39 f8                	cmp    %edi,%eax
  802b7a:	77 54                	ja     802bd0 <__umoddi3+0xa0>
  802b7c:	0f bd e8             	bsr    %eax,%ebp
  802b7f:	83 f5 1f             	xor    $0x1f,%ebp
  802b82:	75 5c                	jne    802be0 <__umoddi3+0xb0>
  802b84:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802b88:	39 3c 24             	cmp    %edi,(%esp)
  802b8b:	0f 87 e7 00 00 00    	ja     802c78 <__umoddi3+0x148>
  802b91:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802b95:	29 f1                	sub    %esi,%ecx
  802b97:	19 c7                	sbb    %eax,%edi
  802b99:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802b9d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ba1:	8b 44 24 08          	mov    0x8(%esp),%eax
  802ba5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802ba9:	83 c4 14             	add    $0x14,%esp
  802bac:	5e                   	pop    %esi
  802bad:	5f                   	pop    %edi
  802bae:	5d                   	pop    %ebp
  802baf:	c3                   	ret    
  802bb0:	85 f6                	test   %esi,%esi
  802bb2:	89 f5                	mov    %esi,%ebp
  802bb4:	75 0b                	jne    802bc1 <__umoddi3+0x91>
  802bb6:	b8 01 00 00 00       	mov    $0x1,%eax
  802bbb:	31 d2                	xor    %edx,%edx
  802bbd:	f7 f6                	div    %esi
  802bbf:	89 c5                	mov    %eax,%ebp
  802bc1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802bc5:	31 d2                	xor    %edx,%edx
  802bc7:	f7 f5                	div    %ebp
  802bc9:	89 c8                	mov    %ecx,%eax
  802bcb:	f7 f5                	div    %ebp
  802bcd:	eb 9c                	jmp    802b6b <__umoddi3+0x3b>
  802bcf:	90                   	nop
  802bd0:	89 c8                	mov    %ecx,%eax
  802bd2:	89 fa                	mov    %edi,%edx
  802bd4:	83 c4 14             	add    $0x14,%esp
  802bd7:	5e                   	pop    %esi
  802bd8:	5f                   	pop    %edi
  802bd9:	5d                   	pop    %ebp
  802bda:	c3                   	ret    
  802bdb:	90                   	nop
  802bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802be0:	8b 04 24             	mov    (%esp),%eax
  802be3:	be 20 00 00 00       	mov    $0x20,%esi
  802be8:	89 e9                	mov    %ebp,%ecx
  802bea:	29 ee                	sub    %ebp,%esi
  802bec:	d3 e2                	shl    %cl,%edx
  802bee:	89 f1                	mov    %esi,%ecx
  802bf0:	d3 e8                	shr    %cl,%eax
  802bf2:	89 e9                	mov    %ebp,%ecx
  802bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bf8:	8b 04 24             	mov    (%esp),%eax
  802bfb:	09 54 24 04          	or     %edx,0x4(%esp)
  802bff:	89 fa                	mov    %edi,%edx
  802c01:	d3 e0                	shl    %cl,%eax
  802c03:	89 f1                	mov    %esi,%ecx
  802c05:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c09:	8b 44 24 10          	mov    0x10(%esp),%eax
  802c0d:	d3 ea                	shr    %cl,%edx
  802c0f:	89 e9                	mov    %ebp,%ecx
  802c11:	d3 e7                	shl    %cl,%edi
  802c13:	89 f1                	mov    %esi,%ecx
  802c15:	d3 e8                	shr    %cl,%eax
  802c17:	89 e9                	mov    %ebp,%ecx
  802c19:	09 f8                	or     %edi,%eax
  802c1b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802c1f:	f7 74 24 04          	divl   0x4(%esp)
  802c23:	d3 e7                	shl    %cl,%edi
  802c25:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802c29:	89 d7                	mov    %edx,%edi
  802c2b:	f7 64 24 08          	mull   0x8(%esp)
  802c2f:	39 d7                	cmp    %edx,%edi
  802c31:	89 c1                	mov    %eax,%ecx
  802c33:	89 14 24             	mov    %edx,(%esp)
  802c36:	72 2c                	jb     802c64 <__umoddi3+0x134>
  802c38:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802c3c:	72 22                	jb     802c60 <__umoddi3+0x130>
  802c3e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802c42:	29 c8                	sub    %ecx,%eax
  802c44:	19 d7                	sbb    %edx,%edi
  802c46:	89 e9                	mov    %ebp,%ecx
  802c48:	89 fa                	mov    %edi,%edx
  802c4a:	d3 e8                	shr    %cl,%eax
  802c4c:	89 f1                	mov    %esi,%ecx
  802c4e:	d3 e2                	shl    %cl,%edx
  802c50:	89 e9                	mov    %ebp,%ecx
  802c52:	d3 ef                	shr    %cl,%edi
  802c54:	09 d0                	or     %edx,%eax
  802c56:	89 fa                	mov    %edi,%edx
  802c58:	83 c4 14             	add    $0x14,%esp
  802c5b:	5e                   	pop    %esi
  802c5c:	5f                   	pop    %edi
  802c5d:	5d                   	pop    %ebp
  802c5e:	c3                   	ret    
  802c5f:	90                   	nop
  802c60:	39 d7                	cmp    %edx,%edi
  802c62:	75 da                	jne    802c3e <__umoddi3+0x10e>
  802c64:	8b 14 24             	mov    (%esp),%edx
  802c67:	89 c1                	mov    %eax,%ecx
  802c69:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802c6d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802c71:	eb cb                	jmp    802c3e <__umoddi3+0x10e>
  802c73:	90                   	nop
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802c7c:	0f 82 0f ff ff ff    	jb     802b91 <__umoddi3+0x61>
  802c82:	e9 1a ff ff ff       	jmp    802ba1 <__umoddi3+0x71>
