
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 ed 01 00 00       	call   80021e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  800048:	c7 04 24 80 2b 80 00 	movl   $0x802b80,(%esp)
  80004f:	e8 2e 03 00 00       	call   800382 <cprintf>
	if ((r = pipe(p)) < 0)
  800054:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800057:	89 04 24             	mov    %eax,(%esp)
  80005a:	e8 95 24 00 00       	call   8024f4 <pipe>
  80005f:	85 c0                	test   %eax,%eax
  800061:	79 20                	jns    800083 <umain+0x43>
		panic("pipe: %e", r);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 99 2b 80 	movl   $0x802b99,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 a2 2b 80 00 	movl   $0x802ba2,(%esp)
  80007e:	e8 06 02 00 00       	call   800289 <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800083:	e8 6e 11 00 00       	call   8011f6 <fork>
  800088:	89 c6                	mov    %eax,%esi
  80008a:	85 c0                	test   %eax,%eax
  80008c:	79 20                	jns    8000ae <umain+0x6e>
		panic("fork: %e", r);
  80008e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800092:	c7 44 24 08 b6 2b 80 	movl   $0x802bb6,0x8(%esp)
  800099:	00 
  80009a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  8000a1:	00 
  8000a2:	c7 04 24 a2 2b 80 00 	movl   $0x802ba2,(%esp)
  8000a9:	e8 db 01 00 00       	call   800289 <_panic>
	if (r == 0) {
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 56                	jne    800108 <umain+0xc8>
		close(p[1]);
  8000b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b5:	89 04 24             	mov    %eax,(%esp)
  8000b8:	e8 3a 16 00 00       	call   8016f7 <close>
  8000bd:	bb c8 00 00 00       	mov    $0xc8,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c5:	89 04 24             	mov    %eax,(%esp)
  8000c8:	e8 98 25 00 00       	call   802665 <pipeisclosed>
  8000cd:	85 c0                	test   %eax,%eax
  8000cf:	74 11                	je     8000e2 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000d1:	c7 04 24 bf 2b 80 00 	movl   $0x802bbf,(%esp)
  8000d8:	e8 a5 02 00 00       	call   800382 <cprintf>
				exit();
  8000dd:	e8 8e 01 00 00       	call   800270 <exit>
			}
			sys_yield();
  8000e2:	e8 bd 0c 00 00       	call   800da4 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000e7:	83 eb 01             	sub    $0x1,%ebx
  8000ea:	75 d6                	jne    8000c2 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000ec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000f3:	00 
  8000f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000fb:	00 
  8000fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800103:	e8 41 13 00 00       	call   801449 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800108:	89 74 24 04          	mov    %esi,0x4(%esp)
  80010c:	c7 04 24 da 2b 80 00 	movl   $0x802bda,(%esp)
  800113:	e8 6a 02 00 00       	call   800382 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800118:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  80011e:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  800121:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800127:	c1 ee 02             	shr    $0x2,%esi
  80012a:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  800130:	89 74 24 04          	mov    %esi,0x4(%esp)
  800134:	c7 04 24 e5 2b 80 00 	movl   $0x802be5,(%esp)
  80013b:	e8 42 02 00 00       	call   800382 <cprintf>
	dup(p[0], 10);
  800140:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800147:	00 
  800148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80014b:	89 04 24             	mov    %eax,(%esp)
  80014e:	e8 f9 15 00 00       	call   80174c <dup>
	while (kid->env_status == ENV_RUNNABLE)
  800153:	eb 13                	jmp    800168 <umain+0x128>
		dup(p[0], 10);
  800155:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80015c:	00 
  80015d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800160:	89 04 24             	mov    %eax,(%esp)
  800163:	e8 e4 15 00 00       	call   80174c <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800168:	8b 43 54             	mov    0x54(%ebx),%eax
  80016b:	83 f8 02             	cmp    $0x2,%eax
  80016e:	74 e5                	je     800155 <umain+0x115>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800170:	c7 04 24 f0 2b 80 00 	movl   $0x802bf0,(%esp)
  800177:	e8 06 02 00 00       	call   800382 <cprintf>
	if (pipeisclosed(p[0]))
  80017c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 de 24 00 00       	call   802665 <pipeisclosed>
  800187:	85 c0                	test   %eax,%eax
  800189:	74 1c                	je     8001a7 <umain+0x167>
		panic("somehow the other end of p[0] got closed!");
  80018b:	c7 44 24 08 4c 2c 80 	movl   $0x802c4c,0x8(%esp)
  800192:	00 
  800193:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 a2 2b 80 00 	movl   $0x802ba2,(%esp)
  8001a2:	e8 e2 00 00 00       	call   800289 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 0d 14 00 00       	call   8015c6 <fd_lookup>
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	79 20                	jns    8001dd <umain+0x19d>
		panic("cannot look up p[0]: %e", r);
  8001bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c1:	c7 44 24 08 06 2c 80 	movl   $0x802c06,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 a2 2b 80 00 	movl   $0x802ba2,(%esp)
  8001d8:	e8 ac 00 00 00       	call   800289 <_panic>
	va = fd2data(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	e8 78 13 00 00       	call   801560 <fd2data>
	if (pageref(va) != 3+1)
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 de 1b 00 00       	call   801dce <pageref>
  8001f0:	83 f8 04             	cmp    $0x4,%eax
  8001f3:	74 0e                	je     800203 <umain+0x1c3>
		cprintf("\nchild detected race\n");
  8001f5:	c7 04 24 1e 2c 80 00 	movl   $0x802c1e,(%esp)
  8001fc:	e8 81 01 00 00       	call   800382 <cprintf>
  800201:	eb 14                	jmp    800217 <umain+0x1d7>
	else
		cprintf("\nrace didn't happen\n", max);
  800203:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  80020a:	00 
  80020b:	c7 04 24 34 2c 80 00 	movl   $0x802c34,(%esp)
  800212:	e8 6b 01 00 00       	call   800382 <cprintf>
}
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    

0080021e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	56                   	push   %esi
  800222:	53                   	push   %ebx
  800223:	83 ec 10             	sub    $0x10,%esp
  800226:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800229:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80022c:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800233:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800236:	e8 4a 0b 00 00       	call   800d85 <sys_getenvid>
  80023b:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800240:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800243:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800248:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80024d:	85 db                	test   %ebx,%ebx
  80024f:	7e 07                	jle    800258 <libmain+0x3a>
		binaryname = argv[0];
  800251:	8b 06                	mov    (%esi),%eax
  800253:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800258:	89 74 24 04          	mov    %esi,0x4(%esp)
  80025c:	89 1c 24             	mov    %ebx,(%esp)
  80025f:	e8 dc fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800264:	e8 07 00 00 00       	call   800270 <exit>
}
  800269:	83 c4 10             	add    $0x10,%esp
  80026c:	5b                   	pop    %ebx
  80026d:	5e                   	pop    %esi
  80026e:	5d                   	pop    %ebp
  80026f:	c3                   	ret    

00800270 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800276:	e8 af 14 00 00       	call   80172a <close_all>
	sys_env_destroy(0);
  80027b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800282:	e8 ac 0a 00 00       	call   800d33 <sys_env_destroy>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    

00800289 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800289:	55                   	push   %ebp
  80028a:	89 e5                	mov    %esp,%ebp
  80028c:	56                   	push   %esi
  80028d:	53                   	push   %ebx
  80028e:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800291:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800294:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80029a:	e8 e6 0a 00 00       	call   800d85 <sys_getenvid>
  80029f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a2:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002ad:	89 74 24 08          	mov    %esi,0x8(%esp)
  8002b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b5:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  8002bc:	e8 c1 00 00 00       	call   800382 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8002c1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c8:	89 04 24             	mov    %eax,(%esp)
  8002cb:	e8 51 00 00 00       	call   800321 <vcprintf>
	cprintf("\n");
  8002d0:	c7 04 24 97 2b 80 00 	movl   $0x802b97,(%esp)
  8002d7:	e8 a6 00 00 00       	call   800382 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002dc:	cc                   	int3   
  8002dd:	eb fd                	jmp    8002dc <_panic+0x53>

008002df <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	53                   	push   %ebx
  8002e3:	83 ec 14             	sub    $0x14,%esp
  8002e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002e9:	8b 13                	mov    (%ebx),%edx
  8002eb:	8d 42 01             	lea    0x1(%edx),%eax
  8002ee:	89 03                	mov    %eax,(%ebx)
  8002f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002f3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002fc:	75 19                	jne    800317 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002fe:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800305:	00 
  800306:	8d 43 08             	lea    0x8(%ebx),%eax
  800309:	89 04 24             	mov    %eax,(%esp)
  80030c:	e8 e5 09 00 00       	call   800cf6 <sys_cputs>
		b->idx = 0;
  800311:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800317:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031b:	83 c4 14             	add    $0x14,%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5d                   	pop    %ebp
  800320:	c3                   	ret    

00800321 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800321:	55                   	push   %ebp
  800322:	89 e5                	mov    %esp,%ebp
  800324:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80032a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800331:	00 00 00 
	b.cnt = 0;
  800334:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80033b:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800352:	89 44 24 04          	mov    %eax,0x4(%esp)
  800356:	c7 04 24 df 02 80 00 	movl   $0x8002df,(%esp)
  80035d:	e8 ac 01 00 00       	call   80050e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800362:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800372:	89 04 24             	mov    %eax,(%esp)
  800375:	e8 7c 09 00 00       	call   800cf6 <sys_cputs>

	return b.cnt;
}
  80037a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80038b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	89 04 24             	mov    %eax,(%esp)
  800395:	e8 87 ff ff ff       	call   800321 <vcprintf>
	va_end(ap);

	return cnt;
}
  80039a:	c9                   	leave  
  80039b:	c3                   	ret    
  80039c:	66 90                	xchg   %ax,%ax
  80039e:	66 90                	xchg   %ax,%ax

008003a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	57                   	push   %edi
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	83 ec 3c             	sub    $0x3c,%esp
  8003a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ac:	89 d7                	mov    %edx,%edi
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b7:	89 c3                	mov    %eax,%ebx
  8003b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8003bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8003cd:	39 d9                	cmp    %ebx,%ecx
  8003cf:	72 05                	jb     8003d6 <printnum+0x36>
  8003d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003d4:	77 69                	ja     80043f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003dd:	83 ee 01             	sub    $0x1,%esi
  8003e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003f0:	89 c3                	mov    %eax,%ebx
  8003f2:	89 d6                	mov    %edx,%esi
  8003f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800405:	89 04 24             	mov    %eax,(%esp)
  800408:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80040b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040f:	e8 cc 24 00 00       	call   8028e0 <__udivdi3>
  800414:	89 d9                	mov    %ebx,%ecx
  800416:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80041a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80041e:	89 04 24             	mov    %eax,(%esp)
  800421:	89 54 24 04          	mov    %edx,0x4(%esp)
  800425:	89 fa                	mov    %edi,%edx
  800427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80042a:	e8 71 ff ff ff       	call   8003a0 <printnum>
  80042f:	eb 1b                	jmp    80044c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800431:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800435:	8b 45 18             	mov    0x18(%ebp),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff d3                	call   *%ebx
  80043d:	eb 03                	jmp    800442 <printnum+0xa2>
  80043f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800442:	83 ee 01             	sub    $0x1,%esi
  800445:	85 f6                	test   %esi,%esi
  800447:	7f e8                	jg     800431 <printnum+0x91>
  800449:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80044c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800450:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800454:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800457:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80045a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80045e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800465:	89 04 24             	mov    %eax,(%esp)
  800468:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80046b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80046f:	e8 9c 25 00 00       	call   802a10 <__umoddi3>
  800474:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800478:	0f be 80 a3 2c 80 00 	movsbl 0x802ca3(%eax),%eax
  80047f:	89 04 24             	mov    %eax,(%esp)
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	ff d0                	call   *%eax
}
  800487:	83 c4 3c             	add    $0x3c,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5e                   	pop    %esi
  80048c:	5f                   	pop    %edi
  80048d:	5d                   	pop    %ebp
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 fa 01             	cmp    $0x1,%edx
  800495:	7e 0e                	jle    8004a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800497:	8b 10                	mov    (%eax),%edx
  800499:	8d 4a 08             	lea    0x8(%edx),%ecx
  80049c:	89 08                	mov    %ecx,(%eax)
  80049e:	8b 02                	mov    (%edx),%eax
  8004a0:	8b 52 04             	mov    0x4(%edx),%edx
  8004a3:	eb 22                	jmp    8004c7 <getuint+0x38>
	else if (lflag)
  8004a5:	85 d2                	test   %edx,%edx
  8004a7:	74 10                	je     8004b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004a9:	8b 10                	mov    (%eax),%edx
  8004ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004ae:	89 08                	mov    %ecx,(%eax)
  8004b0:	8b 02                	mov    (%edx),%eax
  8004b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004b7:	eb 0e                	jmp    8004c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004b9:	8b 10                	mov    (%eax),%edx
  8004bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004be:	89 08                	mov    %ecx,(%eax)
  8004c0:	8b 02                	mov    (%edx),%eax
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004c7:	5d                   	pop    %ebp
  8004c8:	c3                   	ret    

008004c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004d3:	8b 10                	mov    (%eax),%edx
  8004d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004d8:	73 0a                	jae    8004e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004dd:	89 08                	mov    %ecx,(%eax)
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	88 02                	mov    %al,(%edx)
}
  8004e4:	5d                   	pop    %ebp
  8004e5:	c3                   	ret    

008004e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004e6:	55                   	push   %ebp
  8004e7:	89 e5                	mov    %esp,%ebp
  8004e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	89 04 24             	mov    %eax,(%esp)
  800507:	e8 02 00 00 00       	call   80050e <vprintfmt>
	va_end(ap);
}
  80050c:	c9                   	leave  
  80050d:	c3                   	ret    

0080050e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80050e:	55                   	push   %ebp
  80050f:	89 e5                	mov    %esp,%ebp
  800511:	57                   	push   %edi
  800512:	56                   	push   %esi
  800513:	53                   	push   %ebx
  800514:	83 ec 3c             	sub    $0x3c,%esp
  800517:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80051d:	eb 14                	jmp    800533 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80051f:	85 c0                	test   %eax,%eax
  800521:	0f 84 b3 03 00 00    	je     8008da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80052b:	89 04 24             	mov    %eax,(%esp)
  80052e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800531:	89 f3                	mov    %esi,%ebx
  800533:	8d 73 01             	lea    0x1(%ebx),%esi
  800536:	0f b6 03             	movzbl (%ebx),%eax
  800539:	83 f8 25             	cmp    $0x25,%eax
  80053c:	75 e1                	jne    80051f <vprintfmt+0x11>
  80053e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800542:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800549:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800550:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800557:	ba 00 00 00 00       	mov    $0x0,%edx
  80055c:	eb 1d                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800560:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800564:	eb 15                	jmp    80057b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800566:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800568:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80056c:	eb 0d                	jmp    80057b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80056e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800571:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800574:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80057e:	0f b6 0e             	movzbl (%esi),%ecx
  800581:	0f b6 c1             	movzbl %cl,%eax
  800584:	83 e9 23             	sub    $0x23,%ecx
  800587:	80 f9 55             	cmp    $0x55,%cl
  80058a:	0f 87 2a 03 00 00    	ja     8008ba <vprintfmt+0x3ac>
  800590:	0f b6 c9             	movzbl %cl,%ecx
  800593:	ff 24 8d e0 2d 80 00 	jmp    *0x802de0(,%ecx,4)
  80059a:	89 de                	mov    %ebx,%esi
  80059c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8005a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8005ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8005ae:	83 fb 09             	cmp    $0x9,%ebx
  8005b1:	77 36                	ja     8005e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8005b6:	eb e9                	jmp    8005a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8005be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8005c8:	eb 22                	jmp    8005ec <vprintfmt+0xde>
  8005ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005cd:	85 c9                	test   %ecx,%ecx
  8005cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d4:	0f 49 c1             	cmovns %ecx,%eax
  8005d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005da:	89 de                	mov    %ebx,%esi
  8005dc:	eb 9d                	jmp    80057b <vprintfmt+0x6d>
  8005de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005e7:	eb 92                	jmp    80057b <vprintfmt+0x6d>
  8005e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005f0:	79 89                	jns    80057b <vprintfmt+0x6d>
  8005f2:	e9 77 ff ff ff       	jmp    80056e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005fc:	e9 7a ff ff ff       	jmp    80057b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800601:	8b 45 14             	mov    0x14(%ebp),%eax
  800604:	8d 50 04             	lea    0x4(%eax),%edx
  800607:	89 55 14             	mov    %edx,0x14(%ebp)
  80060a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060e:	8b 00                	mov    (%eax),%eax
  800610:	89 04 24             	mov    %eax,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
			break;
  800616:	e9 18 ff ff ff       	jmp    800533 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80061b:	8b 45 14             	mov    0x14(%ebp),%eax
  80061e:	8d 50 04             	lea    0x4(%eax),%edx
  800621:	89 55 14             	mov    %edx,0x14(%ebp)
  800624:	8b 00                	mov    (%eax),%eax
  800626:	99                   	cltd   
  800627:	31 d0                	xor    %edx,%eax
  800629:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80062b:	83 f8 0f             	cmp    $0xf,%eax
  80062e:	7f 0b                	jg     80063b <vprintfmt+0x12d>
  800630:	8b 14 85 40 2f 80 00 	mov    0x802f40(,%eax,4),%edx
  800637:	85 d2                	test   %edx,%edx
  800639:	75 20                	jne    80065b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80063b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80063f:	c7 44 24 08 bb 2c 80 	movl   $0x802cbb,0x8(%esp)
  800646:	00 
  800647:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	89 04 24             	mov    %eax,(%esp)
  800651:	e8 90 fe ff ff       	call   8004e6 <printfmt>
  800656:	e9 d8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80065b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80065f:	c7 44 24 08 05 32 80 	movl   $0x803205,0x8(%esp)
  800666:	00 
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	89 04 24             	mov    %eax,(%esp)
  800671:	e8 70 fe ff ff       	call   8004e6 <printfmt>
  800676:	e9 b8 fe ff ff       	jmp    800533 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80067b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80067e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800681:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800684:	8b 45 14             	mov    0x14(%ebp),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	89 55 14             	mov    %edx,0x14(%ebp)
  80068d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80068f:	85 f6                	test   %esi,%esi
  800691:	b8 b4 2c 80 00       	mov    $0x802cb4,%eax
  800696:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800699:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80069d:	0f 84 97 00 00 00    	je     80073a <vprintfmt+0x22c>
  8006a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006a7:	0f 8e 9b 00 00 00    	jle    800748 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8006ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006b1:	89 34 24             	mov    %esi,(%esp)
  8006b4:	e8 cf 02 00 00       	call   800988 <strnlen>
  8006b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006bc:	29 c2                	sub    %eax,%edx
  8006be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8006c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8006c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8006c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8006cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d3:	eb 0f                	jmp    8006e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006dc:	89 04 24             	mov    %eax,(%esp)
  8006df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006e1:	83 eb 01             	sub    $0x1,%ebx
  8006e4:	85 db                	test   %ebx,%ebx
  8006e6:	7f ed                	jg     8006d5 <vprintfmt+0x1c7>
  8006e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ee:	85 d2                	test   %edx,%edx
  8006f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006f5:	0f 49 c2             	cmovns %edx,%eax
  8006f8:	29 c2                	sub    %eax,%edx
  8006fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006fd:	89 d7                	mov    %edx,%edi
  8006ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800702:	eb 50                	jmp    800754 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800704:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800708:	74 1e                	je     800728 <vprintfmt+0x21a>
  80070a:	0f be d2             	movsbl %dl,%edx
  80070d:	83 ea 20             	sub    $0x20,%edx
  800710:	83 fa 5e             	cmp    $0x5e,%edx
  800713:	76 13                	jbe    800728 <vprintfmt+0x21a>
					putch('?', putdat);
  800715:	8b 45 0c             	mov    0xc(%ebp),%eax
  800718:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800723:	ff 55 08             	call   *0x8(%ebp)
  800726:	eb 0d                	jmp    800735 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800728:	8b 55 0c             	mov    0xc(%ebp),%edx
  80072b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	83 ef 01             	sub    $0x1,%edi
  800738:	eb 1a                	jmp    800754 <vprintfmt+0x246>
  80073a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80073d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800740:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800743:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800746:	eb 0c                	jmp    800754 <vprintfmt+0x246>
  800748:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80074b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80074e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800751:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800754:	83 c6 01             	add    $0x1,%esi
  800757:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80075b:	0f be c2             	movsbl %dl,%eax
  80075e:	85 c0                	test   %eax,%eax
  800760:	74 27                	je     800789 <vprintfmt+0x27b>
  800762:	85 db                	test   %ebx,%ebx
  800764:	78 9e                	js     800704 <vprintfmt+0x1f6>
  800766:	83 eb 01             	sub    $0x1,%ebx
  800769:	79 99                	jns    800704 <vprintfmt+0x1f6>
  80076b:	89 f8                	mov    %edi,%eax
  80076d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800770:	8b 75 08             	mov    0x8(%ebp),%esi
  800773:	89 c3                	mov    %eax,%ebx
  800775:	eb 1a                	jmp    800791 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800777:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800782:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800784:	83 eb 01             	sub    $0x1,%ebx
  800787:	eb 08                	jmp    800791 <vprintfmt+0x283>
  800789:	89 fb                	mov    %edi,%ebx
  80078b:	8b 75 08             	mov    0x8(%ebp),%esi
  80078e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800791:	85 db                	test   %ebx,%ebx
  800793:	7f e2                	jg     800777 <vprintfmt+0x269>
  800795:	89 75 08             	mov    %esi,0x8(%ebp)
  800798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80079b:	e9 93 fd ff ff       	jmp    800533 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007a0:	83 fa 01             	cmp    $0x1,%edx
  8007a3:	7e 16                	jle    8007bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8007a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a8:	8d 50 08             	lea    0x8(%eax),%edx
  8007ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ae:	8b 50 04             	mov    0x4(%eax),%edx
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b9:	eb 32                	jmp    8007ed <vprintfmt+0x2df>
	else if (lflag)
  8007bb:	85 d2                	test   %edx,%edx
  8007bd:	74 18                	je     8007d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8007bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c2:	8d 50 04             	lea    0x4(%eax),%edx
  8007c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c8:	8b 30                	mov    (%eax),%esi
  8007ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	c1 f8 1f             	sar    $0x1f,%eax
  8007d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007d5:	eb 16                	jmp    8007ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8d 50 04             	lea    0x4(%eax),%edx
  8007dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e0:	8b 30                	mov    (%eax),%esi
  8007e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007e5:	89 f0                	mov    %esi,%eax
  8007e7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fc:	0f 89 80 00 00 00    	jns    800882 <vprintfmt+0x374>
				putch('-', putdat);
  800802:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800806:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80080d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800810:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800813:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800816:	f7 d8                	neg    %eax
  800818:	83 d2 00             	adc    $0x0,%edx
  80081b:	f7 da                	neg    %edx
			}
			base = 10;
  80081d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800822:	eb 5e                	jmp    800882 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800824:	8d 45 14             	lea    0x14(%ebp),%eax
  800827:	e8 63 fc ff ff       	call   80048f <getuint>
			base = 10;
  80082c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800831:	eb 4f                	jmp    800882 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800833:	8d 45 14             	lea    0x14(%ebp),%eax
  800836:	e8 54 fc ff ff       	call   80048f <getuint>
			base =8;
  80083b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800840:	eb 40                	jmp    800882 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800842:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800846:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80084d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800850:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800854:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80085b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80085e:	8b 45 14             	mov    0x14(%ebp),%eax
  800861:	8d 50 04             	lea    0x4(%eax),%edx
  800864:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800867:	8b 00                	mov    (%eax),%eax
  800869:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80086e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800873:	eb 0d                	jmp    800882 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800875:	8d 45 14             	lea    0x14(%ebp),%eax
  800878:	e8 12 fc ff ff       	call   80048f <getuint>
			base = 16;
  80087d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800882:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800886:	89 74 24 10          	mov    %esi,0x10(%esp)
  80088a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80088d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800891:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800895:	89 04 24             	mov    %eax,(%esp)
  800898:	89 54 24 04          	mov    %edx,0x4(%esp)
  80089c:	89 fa                	mov    %edi,%edx
  80089e:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a1:	e8 fa fa ff ff       	call   8003a0 <printnum>
			break;
  8008a6:	e9 88 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008af:	89 04 24             	mov    %eax,(%esp)
  8008b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8008b5:	e9 79 fc ff ff       	jmp    800533 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c8:	89 f3                	mov    %esi,%ebx
  8008ca:	eb 03                	jmp    8008cf <vprintfmt+0x3c1>
  8008cc:	83 eb 01             	sub    $0x1,%ebx
  8008cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008d3:	75 f7                	jne    8008cc <vprintfmt+0x3be>
  8008d5:	e9 59 fc ff ff       	jmp    800533 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008da:	83 c4 3c             	add    $0x3c,%esp
  8008dd:	5b                   	pop    %ebx
  8008de:	5e                   	pop    %esi
  8008df:	5f                   	pop    %edi
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	83 ec 28             	sub    $0x28,%esp
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008ff:	85 c0                	test   %eax,%eax
  800901:	74 30                	je     800933 <vsnprintf+0x51>
  800903:	85 d2                	test   %edx,%edx
  800905:	7e 2c                	jle    800933 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800907:	8b 45 14             	mov    0x14(%ebp),%eax
  80090a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80090e:	8b 45 10             	mov    0x10(%ebp),%eax
  800911:	89 44 24 08          	mov    %eax,0x8(%esp)
  800915:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800918:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091c:	c7 04 24 c9 04 80 00 	movl   $0x8004c9,(%esp)
  800923:	e8 e6 fb ff ff       	call   80050e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800931:	eb 05                	jmp    800938 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800933:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    

0080093a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800940:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800943:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800947:	8b 45 10             	mov    0x10(%ebp),%eax
  80094a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	89 04 24             	mov    %eax,(%esp)
  80095b:	e8 82 ff ff ff       	call   8008e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800960:	c9                   	leave  
  800961:	c3                   	ret    
  800962:	66 90                	xchg   %ax,%ax
  800964:	66 90                	xchg   %ax,%ax
  800966:	66 90                	xchg   %ax,%ax
  800968:	66 90                	xchg   %ax,%ax
  80096a:	66 90                	xchg   %ax,%ax
  80096c:	66 90                	xchg   %ax,%ax
  80096e:	66 90                	xchg   %ax,%ax

00800970 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800970:	55                   	push   %ebp
  800971:	89 e5                	mov    %esp,%ebp
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
  80097b:	eb 03                	jmp    800980 <strlen+0x10>
		n++;
  80097d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800980:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800984:	75 f7                	jne    80097d <strlen+0xd>
		n++;
	return n;
}
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80098e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800991:	b8 00 00 00 00       	mov    $0x0,%eax
  800996:	eb 03                	jmp    80099b <strnlen+0x13>
		n++;
  800998:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80099b:	39 d0                	cmp    %edx,%eax
  80099d:	74 06                	je     8009a5 <strnlen+0x1d>
  80099f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8009a3:	75 f3                	jne    800998 <strnlen+0x10>
		n++;
	return n;
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b1:	89 c2                	mov    %eax,%edx
  8009b3:	83 c2 01             	add    $0x1,%edx
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8009bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009c0:	84 db                	test   %bl,%bl
  8009c2:	75 ef                	jne    8009b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009c4:	5b                   	pop    %ebx
  8009c5:	5d                   	pop    %ebp
  8009c6:	c3                   	ret    

008009c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009c7:	55                   	push   %ebp
  8009c8:	89 e5                	mov    %esp,%ebp
  8009ca:	53                   	push   %ebx
  8009cb:	83 ec 08             	sub    $0x8,%esp
  8009ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009d1:	89 1c 24             	mov    %ebx,(%esp)
  8009d4:	e8 97 ff ff ff       	call   800970 <strlen>
	strcpy(dst + len, src);
  8009d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009e0:	01 d8                	add    %ebx,%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 bd ff ff ff       	call   8009a7 <strcpy>
	return dst;
}
  8009ea:	89 d8                	mov    %ebx,%eax
  8009ec:	83 c4 08             	add    $0x8,%esp
  8009ef:	5b                   	pop    %ebx
  8009f0:	5d                   	pop    %ebp
  8009f1:	c3                   	ret    

008009f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009fd:	89 f3                	mov    %esi,%ebx
  8009ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a02:	89 f2                	mov    %esi,%edx
  800a04:	eb 0f                	jmp    800a15 <strncpy+0x23>
		*dst++ = *src;
  800a06:	83 c2 01             	add    $0x1,%edx
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a0f:	80 39 01             	cmpb   $0x1,(%ecx)
  800a12:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a15:	39 da                	cmp    %ebx,%edx
  800a17:	75 ed                	jne    800a06 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a19:	89 f0                	mov    %esi,%eax
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 75 08             	mov    0x8(%ebp),%esi
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800a2d:	89 f0                	mov    %esi,%eax
  800a2f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	75 0b                	jne    800a42 <strlcpy+0x23>
  800a37:	eb 1d                	jmp    800a56 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a39:	83 c0 01             	add    $0x1,%eax
  800a3c:	83 c2 01             	add    $0x1,%edx
  800a3f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a42:	39 d8                	cmp    %ebx,%eax
  800a44:	74 0b                	je     800a51 <strlcpy+0x32>
  800a46:	0f b6 0a             	movzbl (%edx),%ecx
  800a49:	84 c9                	test   %cl,%cl
  800a4b:	75 ec                	jne    800a39 <strlcpy+0x1a>
  800a4d:	89 c2                	mov    %eax,%edx
  800a4f:	eb 02                	jmp    800a53 <strlcpy+0x34>
  800a51:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a53:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a56:	29 f0                	sub    %esi,%eax
}
  800a58:	5b                   	pop    %ebx
  800a59:	5e                   	pop    %esi
  800a5a:	5d                   	pop    %ebp
  800a5b:	c3                   	ret    

00800a5c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a5c:	55                   	push   %ebp
  800a5d:	89 e5                	mov    %esp,%ebp
  800a5f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a65:	eb 06                	jmp    800a6d <strcmp+0x11>
		p++, q++;
  800a67:	83 c1 01             	add    $0x1,%ecx
  800a6a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a6d:	0f b6 01             	movzbl (%ecx),%eax
  800a70:	84 c0                	test   %al,%al
  800a72:	74 04                	je     800a78 <strcmp+0x1c>
  800a74:	3a 02                	cmp    (%edx),%al
  800a76:	74 ef                	je     800a67 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 c0             	movzbl %al,%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8c:	89 c3                	mov    %eax,%ebx
  800a8e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a91:	eb 06                	jmp    800a99 <strncmp+0x17>
		n--, p++, q++;
  800a93:	83 c0 01             	add    $0x1,%eax
  800a96:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a99:	39 d8                	cmp    %ebx,%eax
  800a9b:	74 15                	je     800ab2 <strncmp+0x30>
  800a9d:	0f b6 08             	movzbl (%eax),%ecx
  800aa0:	84 c9                	test   %cl,%cl
  800aa2:	74 04                	je     800aa8 <strncmp+0x26>
  800aa4:	3a 0a                	cmp    (%edx),%cl
  800aa6:	74 eb                	je     800a93 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa8:	0f b6 00             	movzbl (%eax),%eax
  800aab:	0f b6 12             	movzbl (%edx),%edx
  800aae:	29 d0                	sub    %edx,%eax
  800ab0:	eb 05                	jmp    800ab7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800ab2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab7:	5b                   	pop    %ebx
  800ab8:	5d                   	pop    %ebp
  800ab9:	c3                   	ret    

00800aba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aba:	55                   	push   %ebp
  800abb:	89 e5                	mov    %esp,%ebp
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac4:	eb 07                	jmp    800acd <strchr+0x13>
		if (*s == c)
  800ac6:	38 ca                	cmp    %cl,%dl
  800ac8:	74 0f                	je     800ad9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f2                	jne    800ac6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	eb 07                	jmp    800aee <strfind+0x13>
		if (*s == c)
  800ae7:	38 ca                	cmp    %cl,%dl
  800ae9:	74 0a                	je     800af5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aeb:	83 c0 01             	add    $0x1,%eax
  800aee:	0f b6 10             	movzbl (%eax),%edx
  800af1:	84 d2                	test   %dl,%dl
  800af3:	75 f2                	jne    800ae7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800af5:	5d                   	pop    %ebp
  800af6:	c3                   	ret    

00800af7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800af7:	55                   	push   %ebp
  800af8:	89 e5                	mov    %esp,%ebp
  800afa:	57                   	push   %edi
  800afb:	56                   	push   %esi
  800afc:	53                   	push   %ebx
  800afd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b03:	85 c9                	test   %ecx,%ecx
  800b05:	74 36                	je     800b3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0d:	75 28                	jne    800b37 <memset+0x40>
  800b0f:	f6 c1 03             	test   $0x3,%cl
  800b12:	75 23                	jne    800b37 <memset+0x40>
		c &= 0xFF;
  800b14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b18:	89 d3                	mov    %edx,%ebx
  800b1a:	c1 e3 08             	shl    $0x8,%ebx
  800b1d:	89 d6                	mov    %edx,%esi
  800b1f:	c1 e6 18             	shl    $0x18,%esi
  800b22:	89 d0                	mov    %edx,%eax
  800b24:	c1 e0 10             	shl    $0x10,%eax
  800b27:	09 f0                	or     %esi,%eax
  800b29:	09 c2                	or     %eax,%edx
  800b2b:	89 d0                	mov    %edx,%eax
  800b2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b32:	fc                   	cld    
  800b33:	f3 ab                	rep stos %eax,%es:(%edi)
  800b35:	eb 06                	jmp    800b3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	fc                   	cld    
  800b3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b52:	39 c6                	cmp    %eax,%esi
  800b54:	73 35                	jae    800b8b <memmove+0x47>
  800b56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b59:	39 d0                	cmp    %edx,%eax
  800b5b:	73 2e                	jae    800b8b <memmove+0x47>
		s += n;
		d += n;
  800b5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b60:	89 d6                	mov    %edx,%esi
  800b62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6a:	75 13                	jne    800b7f <memmove+0x3b>
  800b6c:	f6 c1 03             	test   $0x3,%cl
  800b6f:	75 0e                	jne    800b7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b71:	83 ef 04             	sub    $0x4,%edi
  800b74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b7a:	fd                   	std    
  800b7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b7d:	eb 09                	jmp    800b88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b7f:	83 ef 01             	sub    $0x1,%edi
  800b82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b85:	fd                   	std    
  800b86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b88:	fc                   	cld    
  800b89:	eb 1d                	jmp    800ba8 <memmove+0x64>
  800b8b:	89 f2                	mov    %esi,%edx
  800b8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8f:	f6 c2 03             	test   $0x3,%dl
  800b92:	75 0f                	jne    800ba3 <memmove+0x5f>
  800b94:	f6 c1 03             	test   $0x3,%cl
  800b97:	75 0a                	jne    800ba3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b9c:	89 c7                	mov    %eax,%edi
  800b9e:	fc                   	cld    
  800b9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba1:	eb 05                	jmp    800ba8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ba3:	89 c7                	mov    %eax,%edi
  800ba5:	fc                   	cld    
  800ba6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc3:	89 04 24             	mov    %eax,(%esp)
  800bc6:	e8 79 ff ff ff       	call   800b44 <memmove>
}
  800bcb:	c9                   	leave  
  800bcc:	c3                   	ret    

00800bcd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd8:	89 d6                	mov    %edx,%esi
  800bda:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdd:	eb 1a                	jmp    800bf9 <memcmp+0x2c>
		if (*s1 != *s2)
  800bdf:	0f b6 02             	movzbl (%edx),%eax
  800be2:	0f b6 19             	movzbl (%ecx),%ebx
  800be5:	38 d8                	cmp    %bl,%al
  800be7:	74 0a                	je     800bf3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800be9:	0f b6 c0             	movzbl %al,%eax
  800bec:	0f b6 db             	movzbl %bl,%ebx
  800bef:	29 d8                	sub    %ebx,%eax
  800bf1:	eb 0f                	jmp    800c02 <memcmp+0x35>
		s1++, s2++;
  800bf3:	83 c2 01             	add    $0x1,%edx
  800bf6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf9:	39 f2                	cmp    %esi,%edx
  800bfb:	75 e2                	jne    800bdf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c02:	5b                   	pop    %ebx
  800c03:	5e                   	pop    %esi
  800c04:	5d                   	pop    %ebp
  800c05:	c3                   	ret    

00800c06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c06:	55                   	push   %ebp
  800c07:	89 e5                	mov    %esp,%ebp
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c0f:	89 c2                	mov    %eax,%edx
  800c11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c14:	eb 07                	jmp    800c1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c16:	38 08                	cmp    %cl,(%eax)
  800c18:	74 07                	je     800c21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c1a:	83 c0 01             	add    $0x1,%eax
  800c1d:	39 d0                	cmp    %edx,%eax
  800c1f:	72 f5                	jb     800c16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2f:	eb 03                	jmp    800c34 <strtol+0x11>
		s++;
  800c31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c34:	0f b6 0a             	movzbl (%edx),%ecx
  800c37:	80 f9 09             	cmp    $0x9,%cl
  800c3a:	74 f5                	je     800c31 <strtol+0xe>
  800c3c:	80 f9 20             	cmp    $0x20,%cl
  800c3f:	74 f0                	je     800c31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c41:	80 f9 2b             	cmp    $0x2b,%cl
  800c44:	75 0a                	jne    800c50 <strtol+0x2d>
		s++;
  800c46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c49:	bf 00 00 00 00       	mov    $0x0,%edi
  800c4e:	eb 11                	jmp    800c61 <strtol+0x3e>
  800c50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c55:	80 f9 2d             	cmp    $0x2d,%cl
  800c58:	75 07                	jne    800c61 <strtol+0x3e>
		s++, neg = 1;
  800c5a:	8d 52 01             	lea    0x1(%edx),%edx
  800c5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c66:	75 15                	jne    800c7d <strtol+0x5a>
  800c68:	80 3a 30             	cmpb   $0x30,(%edx)
  800c6b:	75 10                	jne    800c7d <strtol+0x5a>
  800c6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c71:	75 0a                	jne    800c7d <strtol+0x5a>
		s += 2, base = 16;
  800c73:	83 c2 02             	add    $0x2,%edx
  800c76:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7b:	eb 10                	jmp    800c8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	75 0c                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c83:	80 3a 30             	cmpb   $0x30,(%edx)
  800c86:	75 05                	jne    800c8d <strtol+0x6a>
		s++, base = 8;
  800c88:	83 c2 01             	add    $0x1,%edx
  800c8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c95:	0f b6 0a             	movzbl (%edx),%ecx
  800c98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c9b:	89 f0                	mov    %esi,%eax
  800c9d:	3c 09                	cmp    $0x9,%al
  800c9f:	77 08                	ja     800ca9 <strtol+0x86>
			dig = *s - '0';
  800ca1:	0f be c9             	movsbl %cl,%ecx
  800ca4:	83 e9 30             	sub    $0x30,%ecx
  800ca7:	eb 20                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ca9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800cac:	89 f0                	mov    %esi,%eax
  800cae:	3c 19                	cmp    $0x19,%al
  800cb0:	77 08                	ja     800cba <strtol+0x97>
			dig = *s - 'a' + 10;
  800cb2:	0f be c9             	movsbl %cl,%ecx
  800cb5:	83 e9 57             	sub    $0x57,%ecx
  800cb8:	eb 0f                	jmp    800cc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800cba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800cbd:	89 f0                	mov    %esi,%eax
  800cbf:	3c 19                	cmp    $0x19,%al
  800cc1:	77 16                	ja     800cd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800cc3:	0f be c9             	movsbl %cl,%ecx
  800cc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800ccc:	7d 0f                	jge    800cdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800cce:	83 c2 01             	add    $0x1,%edx
  800cd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800cd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800cd7:	eb bc                	jmp    800c95 <strtol+0x72>
  800cd9:	89 d8                	mov    %ebx,%eax
  800cdb:	eb 02                	jmp    800cdf <strtol+0xbc>
  800cdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800cdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ce3:	74 05                	je     800cea <strtol+0xc7>
		*endptr = (char *) s;
  800ce5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ce8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cea:	f7 d8                	neg    %eax
  800cec:	85 ff                	test   %edi,%edi
  800cee:	0f 44 c3             	cmove  %ebx,%eax
}
  800cf1:	5b                   	pop    %ebx
  800cf2:	5e                   	pop    %esi
  800cf3:	5f                   	pop    %edi
  800cf4:	5d                   	pop    %ebp
  800cf5:	c3                   	ret    

00800cf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	57                   	push   %edi
  800cfa:	56                   	push   %esi
  800cfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800d01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	89 c3                	mov    %eax,%ebx
  800d09:	89 c7                	mov    %eax,%edi
  800d0b:	89 c6                	mov    %eax,%esi
  800d0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d0f:	5b                   	pop    %ebx
  800d10:	5e                   	pop    %esi
  800d11:	5f                   	pop    %edi
  800d12:	5d                   	pop    %ebp
  800d13:	c3                   	ret    

00800d14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d14:	55                   	push   %ebp
  800d15:	89 e5                	mov    %esp,%ebp
  800d17:	57                   	push   %edi
  800d18:	56                   	push   %esi
  800d19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800d24:	89 d1                	mov    %edx,%ecx
  800d26:	89 d3                	mov    %edx,%ebx
  800d28:	89 d7                	mov    %edx,%edi
  800d2a:	89 d6                	mov    %edx,%esi
  800d2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d2e:	5b                   	pop    %ebx
  800d2f:	5e                   	pop    %esi
  800d30:	5f                   	pop    %edi
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	57                   	push   %edi
  800d37:	56                   	push   %esi
  800d38:	53                   	push   %ebx
  800d39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d41:	b8 03 00 00 00       	mov    $0x3,%eax
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 cb                	mov    %ecx,%ebx
  800d4b:	89 cf                	mov    %ecx,%edi
  800d4d:	89 ce                	mov    %ecx,%esi
  800d4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d51:	85 c0                	test   %eax,%eax
  800d53:	7e 28                	jle    800d7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d60:	00 
  800d61:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800d68:	00 
  800d69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d70:	00 
  800d71:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800d78:	e8 0c f5 ff ff       	call   800289 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7d:	83 c4 2c             	add    $0x2c,%esp
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	57                   	push   %edi
  800d89:	56                   	push   %esi
  800d8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d90:	b8 02 00 00 00       	mov    $0x2,%eax
  800d95:	89 d1                	mov    %edx,%ecx
  800d97:	89 d3                	mov    %edx,%ebx
  800d99:	89 d7                	mov    %edx,%edi
  800d9b:	89 d6                	mov    %edx,%esi
  800d9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    

00800da4 <sys_yield>:

void
sys_yield(void)
{
  800da4:	55                   	push   %ebp
  800da5:	89 e5                	mov    %esp,%ebp
  800da7:	57                   	push   %edi
  800da8:	56                   	push   %esi
  800da9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	ba 00 00 00 00       	mov    $0x0,%edx
  800daf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800db4:	89 d1                	mov    %edx,%ecx
  800db6:	89 d3                	mov    %edx,%ebx
  800db8:	89 d7                	mov    %edx,%edi
  800dba:	89 d6                	mov    %edx,%esi
  800dbc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dbe:	5b                   	pop    %ebx
  800dbf:	5e                   	pop    %esi
  800dc0:	5f                   	pop    %edi
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	57                   	push   %edi
  800dc7:	56                   	push   %esi
  800dc8:	53                   	push   %ebx
  800dc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcc:	be 00 00 00 00       	mov    $0x0,%esi
  800dd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ddf:	89 f7                	mov    %esi,%edi
  800de1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800de3:	85 c0                	test   %eax,%eax
  800de5:	7e 28                	jle    800e0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800deb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800df2:	00 
  800df3:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800dfa:	00 
  800dfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e02:	00 
  800e03:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800e0a:	e8 7a f4 ff ff       	call   800289 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800e0f:	83 c4 2c             	add    $0x2c,%esp
  800e12:	5b                   	pop    %ebx
  800e13:	5e                   	pop    %esi
  800e14:	5f                   	pop    %edi
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	57                   	push   %edi
  800e1b:	56                   	push   %esi
  800e1c:	53                   	push   %ebx
  800e1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e20:	b8 05 00 00 00       	mov    $0x5,%eax
  800e25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e28:	8b 55 08             	mov    0x8(%ebp),%edx
  800e2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e31:	8b 75 18             	mov    0x18(%ebp),%esi
  800e34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e36:	85 c0                	test   %eax,%eax
  800e38:	7e 28                	jle    800e62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e45:	00 
  800e46:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800e4d:	00 
  800e4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e55:	00 
  800e56:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800e5d:	e8 27 f4 ff ff       	call   800289 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e62:	83 c4 2c             	add    $0x2c,%esp
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e6a:	55                   	push   %ebp
  800e6b:	89 e5                	mov    %esp,%ebp
  800e6d:	57                   	push   %edi
  800e6e:	56                   	push   %esi
  800e6f:	53                   	push   %ebx
  800e70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e78:	b8 06 00 00 00       	mov    $0x6,%eax
  800e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e80:	8b 55 08             	mov    0x8(%ebp),%edx
  800e83:	89 df                	mov    %ebx,%edi
  800e85:	89 de                	mov    %ebx,%esi
  800e87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e89:	85 c0                	test   %eax,%eax
  800e8b:	7e 28                	jle    800eb5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800eb0:	e8 d4 f3 ff ff       	call   800289 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	57                   	push   %edi
  800ec1:	56                   	push   %esi
  800ec2:	53                   	push   %ebx
  800ec3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ecb:	b8 08 00 00 00       	mov    $0x8,%eax
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed6:	89 df                	mov    %ebx,%edi
  800ed8:	89 de                	mov    %ebx,%esi
  800eda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800edc:	85 c0                	test   %eax,%eax
  800ede:	7e 28                	jle    800f08 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800f03:	e8 81 f3 ff ff       	call   800289 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	57                   	push   %edi
  800f14:	56                   	push   %esi
  800f15:	53                   	push   %ebx
  800f16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1e:	b8 09 00 00 00       	mov    $0x9,%eax
  800f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f26:	8b 55 08             	mov    0x8(%ebp),%edx
  800f29:	89 df                	mov    %ebx,%edi
  800f2b:	89 de                	mov    %ebx,%esi
  800f2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f2f:	85 c0                	test   %eax,%eax
  800f31:	7e 28                	jle    800f5b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f37:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800f46:	00 
  800f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f4e:	00 
  800f4f:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800f56:	e8 2e f3 ff ff       	call   800289 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f5b:	83 c4 2c             	add    $0x2c,%esp
  800f5e:	5b                   	pop    %ebx
  800f5f:	5e                   	pop    %esi
  800f60:	5f                   	pop    %edi
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	57                   	push   %edi
  800f67:	56                   	push   %esi
  800f68:	53                   	push   %ebx
  800f69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	89 df                	mov    %ebx,%edi
  800f7e:	89 de                	mov    %ebx,%esi
  800f80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f82:	85 c0                	test   %eax,%eax
  800f84:	7e 28                	jle    800fae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f91:	00 
  800f92:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  800f99:	00 
  800f9a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa1:	00 
  800fa2:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  800fa9:	e8 db f2 ff ff       	call   800289 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fae:	83 c4 2c             	add    $0x2c,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbc:	be 00 00 00 00       	mov    $0x0,%esi
  800fc1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fcf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fd2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fd4:	5b                   	pop    %ebx
  800fd5:	5e                   	pop    %esi
  800fd6:	5f                   	pop    %edi
  800fd7:	5d                   	pop    %ebp
  800fd8:	c3                   	ret    

00800fd9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fd9:	55                   	push   %ebp
  800fda:	89 e5                	mov    %esp,%ebp
  800fdc:	57                   	push   %edi
  800fdd:	56                   	push   %esi
  800fde:	53                   	push   %ebx
  800fdf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	89 cb                	mov    %ecx,%ebx
  800ff1:	89 cf                	mov    %ecx,%edi
  800ff3:	89 ce                	mov    %ecx,%esi
  800ff5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ff7:	85 c0                	test   %eax,%eax
  800ff9:	7e 28                	jle    801023 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801006:	00 
  801007:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  80100e:	00 
  80100f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801016:	00 
  801017:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  80101e:	e8 66 f2 ff ff       	call   800289 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801023:	83 c4 2c             	add    $0x2c,%esp
  801026:	5b                   	pop    %ebx
  801027:	5e                   	pop    %esi
  801028:	5f                   	pop    %edi
  801029:	5d                   	pop    %ebp
  80102a:	c3                   	ret    

0080102b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  80102b:	55                   	push   %ebp
  80102c:	89 e5                	mov    %esp,%ebp
  80102e:	57                   	push   %edi
  80102f:	56                   	push   %esi
  801030:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801031:	ba 00 00 00 00       	mov    $0x0,%edx
  801036:	b8 0e 00 00 00       	mov    $0xe,%eax
  80103b:	89 d1                	mov    %edx,%ecx
  80103d:	89 d3                	mov    %edx,%ebx
  80103f:	89 d7                	mov    %edx,%edi
  801041:	89 d6                	mov    %edx,%esi
  801043:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801045:	5b                   	pop    %ebx
  801046:	5e                   	pop    %esi
  801047:	5f                   	pop    %edi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	57                   	push   %edi
  80104e:	56                   	push   %esi
  80104f:	53                   	push   %ebx
  801050:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801053:	bb 00 00 00 00       	mov    $0x0,%ebx
  801058:	b8 0f 00 00 00       	mov    $0xf,%eax
  80105d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801060:	8b 55 08             	mov    0x8(%ebp),%edx
  801063:	89 df                	mov    %ebx,%edi
  801065:	89 de                	mov    %ebx,%esi
  801067:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801069:	85 c0                	test   %eax,%eax
  80106b:	7e 28                	jle    801095 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80106d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801071:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801078:	00 
  801079:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  801080:	00 
  801081:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801088:	00 
  801089:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  801090:	e8 f4 f1 ff ff       	call   800289 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801095:	83 c4 2c             	add    $0x2c,%esp
  801098:	5b                   	pop    %ebx
  801099:	5e                   	pop    %esi
  80109a:	5f                   	pop    %edi
  80109b:	5d                   	pop    %ebp
  80109c:	c3                   	ret    

0080109d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
  8010a3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8010b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b6:	89 df                	mov    %ebx,%edi
  8010b8:	89 de                	mov    %ebx,%esi
  8010ba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	7e 28                	jle    8010e8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 08 9f 2f 80 	movl   $0x802f9f,0x8(%esp)
  8010d3:	00 
  8010d4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010db:	00 
  8010dc:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  8010e3:	e8 a1 f1 ff ff       	call   800289 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8010e8:	83 c4 2c             	add    $0x2c,%esp
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	53                   	push   %ebx
  8010f4:	83 ec 24             	sub    $0x24,%esp
  8010f7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  8010fa:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  8010fc:	89 d3                	mov    %edx,%ebx
  8010fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801104:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801108:	74 1a                	je     801124 <pgfault+0x34>
  80110a:	c1 ea 0c             	shr    $0xc,%edx
  80110d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801114:	a8 01                	test   $0x1,%al
  801116:	74 0c                	je     801124 <pgfault+0x34>
  801118:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80111f:	f6 c4 08             	test   $0x8,%ah
  801122:	75 1c                	jne    801140 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801124:	c7 44 24 08 cc 2f 80 	movl   $0x802fcc,0x8(%esp)
  80112b:	00 
  80112c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801133:	00 
  801134:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  80113b:	e8 49 f1 ff ff       	call   800289 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801140:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801147:	00 
  801148:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80114f:	00 
  801150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801157:	e8 67 fc ff ff       	call   800dc3 <sys_page_alloc>
  80115c:	85 c0                	test   %eax,%eax
  80115e:	79 1c                	jns    80117c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801160:	c7 44 24 08 10 30 80 	movl   $0x803010,0x8(%esp)
  801167:	00 
  801168:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80116f:	00 
  801170:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  801177:	e8 0d f1 ff ff       	call   800289 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80117c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801183:	00 
  801184:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801188:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80118f:	e8 18 fa ff ff       	call   800bac <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801194:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80119b:	00 
  80119c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011a7:	00 
  8011a8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011af:	00 
  8011b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b7:	e8 5b fc ff ff       	call   800e17 <sys_page_map>
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 1c                	je     8011dc <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8011c0:	c7 44 24 08 26 31 80 	movl   $0x803126,0x8(%esp)
  8011c7:	00 
  8011c8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8011cf:	00 
  8011d0:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  8011d7:	e8 ad f0 ff ff       	call   800289 <_panic>
    sys_page_unmap(0,PFTEMP);
  8011dc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011e3:	00 
  8011e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011eb:	e8 7a fc ff ff       	call   800e6a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  8011f0:	83 c4 24             	add    $0x24,%esp
  8011f3:	5b                   	pop    %ebx
  8011f4:	5d                   	pop    %ebp
  8011f5:	c3                   	ret    

008011f6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011f6:	55                   	push   %ebp
  8011f7:	89 e5                	mov    %esp,%ebp
  8011f9:	57                   	push   %edi
  8011fa:	56                   	push   %esi
  8011fb:	53                   	push   %ebx
  8011fc:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  8011ff:	c7 04 24 f0 10 80 00 	movl   $0x8010f0,(%esp)
  801206:	e8 3b 16 00 00       	call   802846 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80120b:	b8 07 00 00 00       	mov    $0x7,%eax
  801210:	cd 30                	int    $0x30
  801212:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801215:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801217:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121c:	85 c0                	test   %eax,%eax
  80121e:	75 21                	jne    801241 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801220:	e8 60 fb ff ff       	call   800d85 <sys_getenvid>
  801225:	25 ff 03 00 00       	and    $0x3ff,%eax
  80122a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80122d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801232:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801237:	b8 00 00 00 00       	mov    $0x0,%eax
  80123c:	e9 de 01 00 00       	jmp    80141f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801241:	89 d8                	mov    %ebx,%eax
  801243:	c1 e8 16             	shr    $0x16,%eax
  801246:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124d:	a8 01                	test   $0x1,%al
  80124f:	0f 84 58 01 00 00    	je     8013ad <fork+0x1b7>
  801255:	89 de                	mov    %ebx,%esi
  801257:	c1 ee 0c             	shr    $0xc,%esi
  80125a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801261:	83 e0 05             	and    $0x5,%eax
  801264:	83 f8 05             	cmp    $0x5,%eax
  801267:	0f 85 40 01 00 00    	jne    8013ad <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80126d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801274:	f6 c4 04             	test   $0x4,%ah
  801277:	74 4f                	je     8012c8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801279:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801280:	c1 e6 0c             	shl    $0xc,%esi
  801283:	25 07 0e 00 00       	and    $0xe07,%eax
  801288:	89 44 24 10          	mov    %eax,0x10(%esp)
  80128c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801290:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801294:	89 74 24 04          	mov    %esi,0x4(%esp)
  801298:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80129f:	e8 73 fb ff ff       	call   800e17 <sys_page_map>
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	0f 89 01 01 00 00    	jns    8013ad <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8012ac:	c7 44 24 08 30 30 80 	movl   $0x803030,0x8(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8012bb:	00 
  8012bc:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  8012c3:	e8 c1 ef ff ff       	call   800289 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8012c8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012cf:	a8 02                	test   $0x2,%al
  8012d1:	75 10                	jne    8012e3 <fork+0xed>
  8012d3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012da:	f6 c4 08             	test   $0x8,%ah
  8012dd:	0f 84 87 00 00 00    	je     80136a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  8012e3:	c1 e6 0c             	shl    $0xc,%esi
  8012e6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012ed:	00 
  8012ee:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801301:	e8 11 fb ff ff       	call   800e17 <sys_page_map>
  801306:	85 c0                	test   %eax,%eax
  801308:	79 1c                	jns    801326 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80130a:	c7 44 24 08 68 30 80 	movl   $0x803068,0x8(%esp)
  801311:	00 
  801312:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801319:	00 
  80131a:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  801321:	e8 63 ef ff ff       	call   800289 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801326:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80132d:	00 
  80132e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801332:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801339:	00 
  80133a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80133e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801345:	e8 cd fa ff ff       	call   800e17 <sys_page_map>
  80134a:	85 c0                	test   %eax,%eax
  80134c:	79 5f                	jns    8013ad <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80134e:	c7 44 24 08 a0 30 80 	movl   $0x8030a0,0x8(%esp)
  801355:	00 
  801356:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80135d:	00 
  80135e:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  801365:	e8 1f ef ff ff       	call   800289 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80136a:	c1 e6 0c             	shl    $0xc,%esi
  80136d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801374:	00 
  801375:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801379:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80137d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801381:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801388:	e8 8a fa ff ff       	call   800e17 <sys_page_map>
  80138d:	85 c0                	test   %eax,%eax
  80138f:	74 1c                	je     8013ad <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801391:	c7 44 24 08 c8 30 80 	movl   $0x8030c8,0x8(%esp)
  801398:	00 
  801399:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  8013a8:	e8 dc ee ff ff       	call   800289 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8013ad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013b3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8013b9:	0f 85 82 fe ff ff    	jne    801241 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8013bf:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013c6:	00 
  8013c7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013ce:	ee 
  8013cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d2:	89 04 24             	mov    %eax,(%esp)
  8013d5:	e8 e9 f9 ff ff       	call   800dc3 <sys_page_alloc>
  8013da:	85 c0                	test   %eax,%eax
  8013dc:	79 1c                	jns    8013fa <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8013de:	c7 44 24 08 fc 30 80 	movl   $0x8030fc,0x8(%esp)
  8013e5:	00 
  8013e6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  8013ed:	00 
  8013ee:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  8013f5:	e8 8f ee ff ff       	call   800289 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  8013fa:	c7 44 24 04 b7 28 80 	movl   $0x8028b7,0x4(%esp)
  801401:	00 
  801402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801405:	89 3c 24             	mov    %edi,(%esp)
  801408:	e8 56 fb ff ff       	call   800f63 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80140d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801414:	00 
  801415:	89 3c 24             	mov    %edi,(%esp)
  801418:	e8 a0 fa ff ff       	call   800ebd <sys_env_set_status>
		return child;
  80141d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80141f:	83 c4 2c             	add    $0x2c,%esp
  801422:	5b                   	pop    %ebx
  801423:	5e                   	pop    %esi
  801424:	5f                   	pop    %edi
  801425:	5d                   	pop    %ebp
  801426:	c3                   	ret    

00801427 <sfork>:

// Challenge!
int
sfork(void)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80142d:	c7 44 24 08 44 31 80 	movl   $0x803144,0x8(%esp)
  801434:	00 
  801435:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80143c:	00 
  80143d:	c7 04 24 1b 31 80 00 	movl   $0x80311b,(%esp)
  801444:	e8 40 ee ff ff       	call   800289 <_panic>

00801449 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	56                   	push   %esi
  80144d:	53                   	push   %ebx
  80144e:	83 ec 10             	sub    $0x10,%esp
  801451:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801454:	8b 45 0c             	mov    0xc(%ebp),%eax
  801457:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80145a:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80145c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801461:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  801464:	89 04 24             	mov    %eax,(%esp)
  801467:	e8 6d fb ff ff       	call   800fd9 <sys_ipc_recv>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	75 1e                	jne    80148e <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  801470:	85 db                	test   %ebx,%ebx
  801472:	74 0a                	je     80147e <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  801474:	a1 08 50 80 00       	mov    0x805008,%eax
  801479:	8b 40 74             	mov    0x74(%eax),%eax
  80147c:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80147e:	85 f6                	test   %esi,%esi
  801480:	74 22                	je     8014a4 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  801482:	a1 08 50 80 00       	mov    0x805008,%eax
  801487:	8b 40 78             	mov    0x78(%eax),%eax
  80148a:	89 06                	mov    %eax,(%esi)
  80148c:	eb 16                	jmp    8014a4 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80148e:	85 f6                	test   %esi,%esi
  801490:	74 06                	je     801498 <ipc_recv+0x4f>
				*perm_store = 0;
  801492:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  801498:	85 db                	test   %ebx,%ebx
  80149a:	74 10                	je     8014ac <ipc_recv+0x63>
				*from_env_store=0;
  80149c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014a2:	eb 08                	jmp    8014ac <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8014a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8014a9:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8014ac:	83 c4 10             	add    $0x10,%esp
  8014af:	5b                   	pop    %ebx
  8014b0:	5e                   	pop    %esi
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	57                   	push   %edi
  8014b7:	56                   	push   %esi
  8014b8:	53                   	push   %ebx
  8014b9:	83 ec 1c             	sub    $0x1c,%esp
  8014bc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014c2:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8014c5:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8014c7:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8014cc:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8014cf:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	89 04 24             	mov    %eax,(%esp)
  8014e1:	e8 d0 fa ff ff       	call   800fb6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8014e6:	eb 1c                	jmp    801504 <ipc_send+0x51>
	{
		sys_yield();
  8014e8:	e8 b7 f8 ff ff       	call   800da4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8014ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8014f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	89 04 24             	mov    %eax,(%esp)
  8014ff:	e8 b2 fa ff ff       	call   800fb6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801504:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801507:	74 df                	je     8014e8 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801509:	83 c4 1c             	add    $0x1c,%esp
  80150c:	5b                   	pop    %ebx
  80150d:	5e                   	pop    %esi
  80150e:	5f                   	pop    %edi
  80150f:	5d                   	pop    %ebp
  801510:	c3                   	ret    

00801511 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801517:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80151c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80151f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801525:	8b 52 50             	mov    0x50(%edx),%edx
  801528:	39 ca                	cmp    %ecx,%edx
  80152a:	75 0d                	jne    801539 <ipc_find_env+0x28>
			return envs[i].env_id;
  80152c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80152f:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801534:	8b 40 40             	mov    0x40(%eax),%eax
  801537:	eb 0e                	jmp    801547 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801539:	83 c0 01             	add    $0x1,%eax
  80153c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801541:	75 d9                	jne    80151c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801543:	66 b8 00 00          	mov    $0x0,%ax
}
  801547:	5d                   	pop    %ebp
  801548:	c3                   	ret    
  801549:	66 90                	xchg   %ax,%ax
  80154b:	66 90                	xchg   %ax,%ax
  80154d:	66 90                	xchg   %ax,%ax
  80154f:	90                   	nop

00801550 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801553:	8b 45 08             	mov    0x8(%ebp),%eax
  801556:	05 00 00 00 30       	add    $0x30000000,%eax
  80155b:	c1 e8 0c             	shr    $0xc,%eax
}
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80156b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801570:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801575:	5d                   	pop    %ebp
  801576:	c3                   	ret    

00801577 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80157d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801582:	89 c2                	mov    %eax,%edx
  801584:	c1 ea 16             	shr    $0x16,%edx
  801587:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80158e:	f6 c2 01             	test   $0x1,%dl
  801591:	74 11                	je     8015a4 <fd_alloc+0x2d>
  801593:	89 c2                	mov    %eax,%edx
  801595:	c1 ea 0c             	shr    $0xc,%edx
  801598:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80159f:	f6 c2 01             	test   $0x1,%dl
  8015a2:	75 09                	jne    8015ad <fd_alloc+0x36>
			*fd_store = fd;
  8015a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ab:	eb 17                	jmp    8015c4 <fd_alloc+0x4d>
  8015ad:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8015b2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015b7:	75 c9                	jne    801582 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015b9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015bf:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8015c4:	5d                   	pop    %ebp
  8015c5:	c3                   	ret    

008015c6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015cc:	83 f8 1f             	cmp    $0x1f,%eax
  8015cf:	77 36                	ja     801607 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015d1:	c1 e0 0c             	shl    $0xc,%eax
  8015d4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	c1 ea 16             	shr    $0x16,%edx
  8015de:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015e5:	f6 c2 01             	test   $0x1,%dl
  8015e8:	74 24                	je     80160e <fd_lookup+0x48>
  8015ea:	89 c2                	mov    %eax,%edx
  8015ec:	c1 ea 0c             	shr    $0xc,%edx
  8015ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f6:	f6 c2 01             	test   $0x1,%dl
  8015f9:	74 1a                	je     801615 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015fe:	89 02                	mov    %eax,(%edx)
	return 0;
  801600:	b8 00 00 00 00       	mov    $0x0,%eax
  801605:	eb 13                	jmp    80161a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801607:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80160c:	eb 0c                	jmp    80161a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80160e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801613:	eb 05                	jmp    80161a <fd_lookup+0x54>
  801615:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	83 ec 18             	sub    $0x18,%esp
  801622:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801625:	ba 00 00 00 00       	mov    $0x0,%edx
  80162a:	eb 13                	jmp    80163f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80162c:	39 08                	cmp    %ecx,(%eax)
  80162e:	75 0c                	jne    80163c <dev_lookup+0x20>
			*dev = devtab[i];
  801630:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801633:	89 01                	mov    %eax,(%ecx)
			return 0;
  801635:	b8 00 00 00 00       	mov    $0x0,%eax
  80163a:	eb 38                	jmp    801674 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80163c:	83 c2 01             	add    $0x1,%edx
  80163f:	8b 04 95 d8 31 80 00 	mov    0x8031d8(,%edx,4),%eax
  801646:	85 c0                	test   %eax,%eax
  801648:	75 e2                	jne    80162c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80164a:	a1 08 50 80 00       	mov    0x805008,%eax
  80164f:	8b 40 48             	mov    0x48(%eax),%eax
  801652:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801656:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165a:	c7 04 24 5c 31 80 00 	movl   $0x80315c,(%esp)
  801661:	e8 1c ed ff ff       	call   800382 <cprintf>
	*dev = 0;
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80166f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	56                   	push   %esi
  80167a:	53                   	push   %ebx
  80167b:	83 ec 20             	sub    $0x20,%esp
  80167e:	8b 75 08             	mov    0x8(%ebp),%esi
  801681:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801684:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801687:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80168b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801691:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801694:	89 04 24             	mov    %eax,(%esp)
  801697:	e8 2a ff ff ff       	call   8015c6 <fd_lookup>
  80169c:	85 c0                	test   %eax,%eax
  80169e:	78 05                	js     8016a5 <fd_close+0x2f>
	    || fd != fd2)
  8016a0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016a3:	74 0c                	je     8016b1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8016a5:	84 db                	test   %bl,%bl
  8016a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ac:	0f 44 c2             	cmove  %edx,%eax
  8016af:	eb 3f                	jmp    8016f0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b8:	8b 06                	mov    (%esi),%eax
  8016ba:	89 04 24             	mov    %eax,(%esp)
  8016bd:	e8 5a ff ff ff       	call   80161c <dev_lookup>
  8016c2:	89 c3                	mov    %eax,%ebx
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 16                	js     8016de <fd_close+0x68>
		if (dev->dev_close)
  8016c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8016ce:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 07                	je     8016de <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8016d7:	89 34 24             	mov    %esi,(%esp)
  8016da:	ff d0                	call   *%eax
  8016dc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e9:	e8 7c f7 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  8016ee:	89 d8                	mov    %ebx,%eax
}
  8016f0:	83 c4 20             	add    $0x20,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801700:	89 44 24 04          	mov    %eax,0x4(%esp)
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	89 04 24             	mov    %eax,(%esp)
  80170a:	e8 b7 fe ff ff       	call   8015c6 <fd_lookup>
  80170f:	89 c2                	mov    %eax,%edx
  801711:	85 d2                	test   %edx,%edx
  801713:	78 13                	js     801728 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801715:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80171c:	00 
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	89 04 24             	mov    %eax,(%esp)
  801723:	e8 4e ff ff ff       	call   801676 <fd_close>
}
  801728:	c9                   	leave  
  801729:	c3                   	ret    

0080172a <close_all>:

void
close_all(void)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801731:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801736:	89 1c 24             	mov    %ebx,(%esp)
  801739:	e8 b9 ff ff ff       	call   8016f7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80173e:	83 c3 01             	add    $0x1,%ebx
  801741:	83 fb 20             	cmp    $0x20,%ebx
  801744:	75 f0                	jne    801736 <close_all+0xc>
		close(i);
}
  801746:	83 c4 14             	add    $0x14,%esp
  801749:	5b                   	pop    %ebx
  80174a:	5d                   	pop    %ebp
  80174b:	c3                   	ret    

0080174c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	57                   	push   %edi
  801750:	56                   	push   %esi
  801751:	53                   	push   %ebx
  801752:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801755:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801758:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	89 04 24             	mov    %eax,(%esp)
  801762:	e8 5f fe ff ff       	call   8015c6 <fd_lookup>
  801767:	89 c2                	mov    %eax,%edx
  801769:	85 d2                	test   %edx,%edx
  80176b:	0f 88 e1 00 00 00    	js     801852 <dup+0x106>
		return r;
	close(newfdnum);
  801771:	8b 45 0c             	mov    0xc(%ebp),%eax
  801774:	89 04 24             	mov    %eax,(%esp)
  801777:	e8 7b ff ff ff       	call   8016f7 <close>

	newfd = INDEX2FD(newfdnum);
  80177c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80177f:	c1 e3 0c             	shl    $0xc,%ebx
  801782:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80178b:	89 04 24             	mov    %eax,(%esp)
  80178e:	e8 cd fd ff ff       	call   801560 <fd2data>
  801793:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801795:	89 1c 24             	mov    %ebx,(%esp)
  801798:	e8 c3 fd ff ff       	call   801560 <fd2data>
  80179d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80179f:	89 f0                	mov    %esi,%eax
  8017a1:	c1 e8 16             	shr    $0x16,%eax
  8017a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017ab:	a8 01                	test   $0x1,%al
  8017ad:	74 43                	je     8017f2 <dup+0xa6>
  8017af:	89 f0                	mov    %esi,%eax
  8017b1:	c1 e8 0c             	shr    $0xc,%eax
  8017b4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017bb:	f6 c2 01             	test   $0x1,%dl
  8017be:	74 32                	je     8017f2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017c7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8017d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017db:	00 
  8017dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e7:	e8 2b f6 ff ff       	call   800e17 <sys_page_map>
  8017ec:	89 c6                	mov    %eax,%esi
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 3e                	js     801830 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017f5:	89 c2                	mov    %eax,%edx
  8017f7:	c1 ea 0c             	shr    $0xc,%edx
  8017fa:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801801:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801807:	89 54 24 10          	mov    %edx,0x10(%esp)
  80180b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80180f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801816:	00 
  801817:	89 44 24 04          	mov    %eax,0x4(%esp)
  80181b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801822:	e8 f0 f5 ff ff       	call   800e17 <sys_page_map>
  801827:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801829:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80182c:	85 f6                	test   %esi,%esi
  80182e:	79 22                	jns    801852 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801830:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801834:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183b:	e8 2a f6 ff ff       	call   800e6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801840:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184b:	e8 1a f6 ff ff       	call   800e6a <sys_page_unmap>
	return r;
  801850:	89 f0                	mov    %esi,%eax
}
  801852:	83 c4 3c             	add    $0x3c,%esp
  801855:	5b                   	pop    %ebx
  801856:	5e                   	pop    %esi
  801857:	5f                   	pop    %edi
  801858:	5d                   	pop    %ebp
  801859:	c3                   	ret    

0080185a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80185a:	55                   	push   %ebp
  80185b:	89 e5                	mov    %esp,%ebp
  80185d:	53                   	push   %ebx
  80185e:	83 ec 24             	sub    $0x24,%esp
  801861:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801864:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801867:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186b:	89 1c 24             	mov    %ebx,(%esp)
  80186e:	e8 53 fd ff ff       	call   8015c6 <fd_lookup>
  801873:	89 c2                	mov    %eax,%edx
  801875:	85 d2                	test   %edx,%edx
  801877:	78 6d                	js     8018e6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801879:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801883:	8b 00                	mov    (%eax),%eax
  801885:	89 04 24             	mov    %eax,(%esp)
  801888:	e8 8f fd ff ff       	call   80161c <dev_lookup>
  80188d:	85 c0                	test   %eax,%eax
  80188f:	78 55                	js     8018e6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	8b 50 08             	mov    0x8(%eax),%edx
  801897:	83 e2 03             	and    $0x3,%edx
  80189a:	83 fa 01             	cmp    $0x1,%edx
  80189d:	75 23                	jne    8018c2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80189f:	a1 08 50 80 00       	mov    0x805008,%eax
  8018a4:	8b 40 48             	mov    0x48(%eax),%eax
  8018a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	c7 04 24 9d 31 80 00 	movl   $0x80319d,(%esp)
  8018b6:	e8 c7 ea ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  8018bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c0:	eb 24                	jmp    8018e6 <read+0x8c>
	}
	if (!dev->dev_read)
  8018c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018c5:	8b 52 08             	mov    0x8(%edx),%edx
  8018c8:	85 d2                	test   %edx,%edx
  8018ca:	74 15                	je     8018e1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018da:	89 04 24             	mov    %eax,(%esp)
  8018dd:	ff d2                	call   *%edx
  8018df:	eb 05                	jmp    8018e6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8018e1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8018e6:	83 c4 24             	add    $0x24,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5d                   	pop    %ebp
  8018eb:	c3                   	ret    

008018ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018ec:	55                   	push   %ebp
  8018ed:	89 e5                	mov    %esp,%ebp
  8018ef:	57                   	push   %edi
  8018f0:	56                   	push   %esi
  8018f1:	53                   	push   %ebx
  8018f2:	83 ec 1c             	sub    $0x1c,%esp
  8018f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801900:	eb 23                	jmp    801925 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801902:	89 f0                	mov    %esi,%eax
  801904:	29 d8                	sub    %ebx,%eax
  801906:	89 44 24 08          	mov    %eax,0x8(%esp)
  80190a:	89 d8                	mov    %ebx,%eax
  80190c:	03 45 0c             	add    0xc(%ebp),%eax
  80190f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801913:	89 3c 24             	mov    %edi,(%esp)
  801916:	e8 3f ff ff ff       	call   80185a <read>
		if (m < 0)
  80191b:	85 c0                	test   %eax,%eax
  80191d:	78 10                	js     80192f <readn+0x43>
			return m;
		if (m == 0)
  80191f:	85 c0                	test   %eax,%eax
  801921:	74 0a                	je     80192d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801923:	01 c3                	add    %eax,%ebx
  801925:	39 f3                	cmp    %esi,%ebx
  801927:	72 d9                	jb     801902 <readn+0x16>
  801929:	89 d8                	mov    %ebx,%eax
  80192b:	eb 02                	jmp    80192f <readn+0x43>
  80192d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80192f:	83 c4 1c             	add    $0x1c,%esp
  801932:	5b                   	pop    %ebx
  801933:	5e                   	pop    %esi
  801934:	5f                   	pop    %edi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	53                   	push   %ebx
  80193b:	83 ec 24             	sub    $0x24,%esp
  80193e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801941:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801944:	89 44 24 04          	mov    %eax,0x4(%esp)
  801948:	89 1c 24             	mov    %ebx,(%esp)
  80194b:	e8 76 fc ff ff       	call   8015c6 <fd_lookup>
  801950:	89 c2                	mov    %eax,%edx
  801952:	85 d2                	test   %edx,%edx
  801954:	78 68                	js     8019be <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801959:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801960:	8b 00                	mov    (%eax),%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 b2 fc ff ff       	call   80161c <dev_lookup>
  80196a:	85 c0                	test   %eax,%eax
  80196c:	78 50                	js     8019be <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80196e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801971:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801975:	75 23                	jne    80199a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801977:	a1 08 50 80 00       	mov    0x805008,%eax
  80197c:	8b 40 48             	mov    0x48(%eax),%eax
  80197f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801983:	89 44 24 04          	mov    %eax,0x4(%esp)
  801987:	c7 04 24 b9 31 80 00 	movl   $0x8031b9,(%esp)
  80198e:	e8 ef e9 ff ff       	call   800382 <cprintf>
		return -E_INVAL;
  801993:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801998:	eb 24                	jmp    8019be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80199a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199d:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a0:	85 d2                	test   %edx,%edx
  8019a2:	74 15                	je     8019b9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8019ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ae:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8019b2:	89 04 24             	mov    %eax,(%esp)
  8019b5:	ff d2                	call   *%edx
  8019b7:	eb 05                	jmp    8019be <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8019b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8019be:	83 c4 24             	add    $0x24,%esp
  8019c1:	5b                   	pop    %ebx
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    

008019c4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ca:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d4:	89 04 24             	mov    %eax,(%esp)
  8019d7:	e8 ea fb ff ff       	call   8015c6 <fd_lookup>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 0e                	js     8019ee <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 24             	sub    $0x24,%esp
  8019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019fa:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	89 1c 24             	mov    %ebx,(%esp)
  801a04:	e8 bd fb ff ff       	call   8015c6 <fd_lookup>
  801a09:	89 c2                	mov    %eax,%edx
  801a0b:	85 d2                	test   %edx,%edx
  801a0d:	78 61                	js     801a70 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a19:	8b 00                	mov    (%eax),%eax
  801a1b:	89 04 24             	mov    %eax,(%esp)
  801a1e:	e8 f9 fb ff ff       	call   80161c <dev_lookup>
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 49                	js     801a70 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a2e:	75 23                	jne    801a53 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801a30:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a35:	8b 40 48             	mov    0x48(%eax),%eax
  801a38:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a40:	c7 04 24 7c 31 80 00 	movl   $0x80317c,(%esp)
  801a47:	e8 36 e9 ff ff       	call   800382 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  801a4c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a51:	eb 1d                	jmp    801a70 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a56:	8b 52 18             	mov    0x18(%edx),%edx
  801a59:	85 d2                	test   %edx,%edx
  801a5b:	74 0e                	je     801a6b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a60:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801a64:	89 04 24             	mov    %eax,(%esp)
  801a67:	ff d2                	call   *%edx
  801a69:	eb 05                	jmp    801a70 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  801a6b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801a70:	83 c4 24             	add    $0x24,%esp
  801a73:	5b                   	pop    %ebx
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	53                   	push   %ebx
  801a7a:	83 ec 24             	sub    $0x24,%esp
  801a7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a80:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	89 04 24             	mov    %eax,(%esp)
  801a8d:	e8 34 fb ff ff       	call   8015c6 <fd_lookup>
  801a92:	89 c2                	mov    %eax,%edx
  801a94:	85 d2                	test   %edx,%edx
  801a96:	78 52                	js     801aea <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a98:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa2:	8b 00                	mov    (%eax),%eax
  801aa4:	89 04 24             	mov    %eax,(%esp)
  801aa7:	e8 70 fb ff ff       	call   80161c <dev_lookup>
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 3a                	js     801aea <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801ab7:	74 2c                	je     801ae5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ab9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801abc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801ac3:	00 00 00 
	stat->st_isdir = 0;
  801ac6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801acd:	00 00 00 
	stat->st_dev = dev;
  801ad0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ada:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801add:	89 14 24             	mov    %edx,(%esp)
  801ae0:	ff 50 14             	call   *0x14(%eax)
  801ae3:	eb 05                	jmp    801aea <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801ae5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801aea:	83 c4 24             	add    $0x24,%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	56                   	push   %esi
  801af4:	53                   	push   %ebx
  801af5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801af8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aff:	00 
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	89 04 24             	mov    %eax,(%esp)
  801b06:	e8 28 02 00 00       	call   801d33 <open>
  801b0b:	89 c3                	mov    %eax,%ebx
  801b0d:	85 db                	test   %ebx,%ebx
  801b0f:	78 1b                	js     801b2c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b18:	89 1c 24             	mov    %ebx,(%esp)
  801b1b:	e8 56 ff ff ff       	call   801a76 <fstat>
  801b20:	89 c6                	mov    %eax,%esi
	close(fd);
  801b22:	89 1c 24             	mov    %ebx,(%esp)
  801b25:	e8 cd fb ff ff       	call   8016f7 <close>
	return r;
  801b2a:	89 f0                	mov    %esi,%eax
}
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    

00801b33 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
  801b36:	56                   	push   %esi
  801b37:	53                   	push   %ebx
  801b38:	83 ec 10             	sub    $0x10,%esp
  801b3b:	89 c6                	mov    %eax,%esi
  801b3d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b3f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801b46:	75 11                	jne    801b59 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801b4f:	e8 bd f9 ff ff       	call   801511 <ipc_find_env>
  801b54:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b59:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b60:	00 
  801b61:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801b68:	00 
  801b69:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b6d:	a1 00 50 80 00       	mov    0x805000,%eax
  801b72:	89 04 24             	mov    %eax,(%esp)
  801b75:	e8 39 f9 ff ff       	call   8014b3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b7a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b81:	00 
  801b82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b86:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b8d:	e8 b7 f8 ff ff       	call   801449 <ipc_recv>
}
  801b92:	83 c4 10             	add    $0x10,%esp
  801b95:	5b                   	pop    %ebx
  801b96:	5e                   	pop    %esi
  801b97:	5d                   	pop    %ebp
  801b98:	c3                   	ret    

00801b99 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
  801b9c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bad:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801bb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb7:	b8 02 00 00 00       	mov    $0x2,%eax
  801bbc:	e8 72 ff ff ff       	call   801b33 <fsipc>
}
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	8b 40 0c             	mov    0xc(%eax),%eax
  801bcf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801bd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bde:	e8 50 ff ff ff       	call   801b33 <fsipc>
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	53                   	push   %ebx
  801be9:	83 ec 14             	sub    $0x14,%esp
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  801bf5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bfa:	ba 00 00 00 00       	mov    $0x0,%edx
  801bff:	b8 05 00 00 00       	mov    $0x5,%eax
  801c04:	e8 2a ff ff ff       	call   801b33 <fsipc>
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	85 d2                	test   %edx,%edx
  801c0d:	78 2b                	js     801c3a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c0f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c16:	00 
  801c17:	89 1c 24             	mov    %ebx,(%esp)
  801c1a:	e8 88 ed ff ff       	call   8009a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c1f:	a1 80 60 80 00       	mov    0x806080,%eax
  801c24:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c2a:	a1 84 60 80 00       	mov    0x806084,%eax
  801c2f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3a:	83 c4 14             	add    $0x14,%esp
  801c3d:	5b                   	pop    %ebx
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	83 ec 18             	sub    $0x18,%esp
  801c46:	8b 45 10             	mov    0x10(%ebp),%eax
  801c49:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c4e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801c53:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801c56:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c5b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c5e:	8b 52 0c             	mov    0xc(%edx),%edx
  801c61:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801c67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c72:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801c79:	e8 c6 ee ff ff       	call   800b44 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c83:	b8 04 00 00 00       	mov    $0x4,%eax
  801c88:	e8 a6 fe ff ff       	call   801b33 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    

00801c8f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 10             	sub    $0x10,%esp
  801c97:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9d:	8b 40 0c             	mov    0xc(%eax),%eax
  801ca0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801ca5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801cab:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb5:	e8 79 fe ff ff       	call   801b33 <fsipc>
  801cba:	89 c3                	mov    %eax,%ebx
  801cbc:	85 c0                	test   %eax,%eax
  801cbe:	78 6a                	js     801d2a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801cc0:	39 c6                	cmp    %eax,%esi
  801cc2:	73 24                	jae    801ce8 <devfile_read+0x59>
  801cc4:	c7 44 24 0c ec 31 80 	movl   $0x8031ec,0xc(%esp)
  801ccb:	00 
  801ccc:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801cd3:	00 
  801cd4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801cdb:	00 
  801cdc:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801ce3:	e8 a1 e5 ff ff       	call   800289 <_panic>
	assert(r <= PGSIZE);
  801ce8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ced:	7e 24                	jle    801d13 <devfile_read+0x84>
  801cef:	c7 44 24 0c 13 32 80 	movl   $0x803213,0xc(%esp)
  801cf6:	00 
  801cf7:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  801cfe:	00 
  801cff:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801d06:	00 
  801d07:	c7 04 24 08 32 80 00 	movl   $0x803208,(%esp)
  801d0e:	e8 76 e5 ff ff       	call   800289 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801d13:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d17:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801d1e:	00 
  801d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d22:	89 04 24             	mov    %eax,(%esp)
  801d25:	e8 1a ee ff ff       	call   800b44 <memmove>
	return r;
}
  801d2a:	89 d8                	mov    %ebx,%eax
  801d2c:	83 c4 10             	add    $0x10,%esp
  801d2f:	5b                   	pop    %ebx
  801d30:	5e                   	pop    %esi
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	53                   	push   %ebx
  801d37:	83 ec 24             	sub    $0x24,%esp
  801d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801d3d:	89 1c 24             	mov    %ebx,(%esp)
  801d40:	e8 2b ec ff ff       	call   800970 <strlen>
  801d45:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d4a:	7f 60                	jg     801dac <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801d4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 20 f8 ff ff       	call   801577 <fd_alloc>
  801d57:	89 c2                	mov    %eax,%edx
  801d59:	85 d2                	test   %edx,%edx
  801d5b:	78 54                	js     801db1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801d5d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d61:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801d68:	e8 3a ec ff ff       	call   8009a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d70:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d78:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7d:	e8 b1 fd ff ff       	call   801b33 <fsipc>
  801d82:	89 c3                	mov    %eax,%ebx
  801d84:	85 c0                	test   %eax,%eax
  801d86:	79 17                	jns    801d9f <open+0x6c>
		fd_close(fd, 0);
  801d88:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d8f:	00 
  801d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 db f8 ff ff       	call   801676 <fd_close>
		return r;
  801d9b:	89 d8                	mov    %ebx,%eax
  801d9d:	eb 12                	jmp    801db1 <open+0x7e>
	}

	return fd2num(fd);
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	89 04 24             	mov    %eax,(%esp)
  801da5:	e8 a6 f7 ff ff       	call   801550 <fd2num>
  801daa:	eb 05                	jmp    801db1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801dac:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801db1:	83 c4 24             	add    $0x24,%esp
  801db4:	5b                   	pop    %ebx
  801db5:	5d                   	pop    %ebp
  801db6:	c3                   	ret    

00801db7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	b8 08 00 00 00       	mov    $0x8,%eax
  801dc7:	e8 67 fd ff ff       	call   801b33 <fsipc>
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dd4:	89 d0                	mov    %edx,%eax
  801dd6:	c1 e8 16             	shr    $0x16,%eax
  801dd9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801de5:	f6 c1 01             	test   $0x1,%cl
  801de8:	74 1d                	je     801e07 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  801dea:	c1 ea 0c             	shr    $0xc,%edx
  801ded:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  801df4:	f6 c2 01             	test   $0x1,%dl
  801df7:	74 0e                	je     801e07 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801df9:	c1 ea 0c             	shr    $0xc,%edx
  801dfc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  801e03:	ef 
  801e04:	0f b7 c0             	movzwl %ax,%eax
}
  801e07:	5d                   	pop    %ebp
  801e08:	c3                   	ret    
  801e09:	66 90                	xchg   %ax,%ax
  801e0b:	66 90                	xchg   %ax,%ax
  801e0d:	66 90                	xchg   %ax,%ax
  801e0f:	90                   	nop

00801e10 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e16:	c7 44 24 04 1f 32 80 	movl   $0x80321f,0x4(%esp)
  801e1d:	00 
  801e1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e21:	89 04 24             	mov    %eax,(%esp)
  801e24:	e8 7e eb ff ff       	call   8009a7 <strcpy>
	return 0;
}
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	53                   	push   %ebx
  801e34:	83 ec 14             	sub    $0x14,%esp
  801e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801e3a:	89 1c 24             	mov    %ebx,(%esp)
  801e3d:	e8 8c ff ff ff       	call   801dce <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801e42:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801e47:	83 f8 01             	cmp    $0x1,%eax
  801e4a:	75 0d                	jne    801e59 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801e4c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 29 03 00 00       	call   802180 <nsipc_close>
  801e57:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801e59:	89 d0                	mov    %edx,%eax
  801e5b:	83 c4 14             	add    $0x14,%esp
  801e5e:	5b                   	pop    %ebx
  801e5f:	5d                   	pop    %ebp
  801e60:	c3                   	ret    

00801e61 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801e67:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6e:	00 
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e80:	8b 40 0c             	mov    0xc(%eax),%eax
  801e83:	89 04 24             	mov    %eax,(%esp)
  801e86:	e8 f0 03 00 00       	call   80227b <nsipc_send>
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801e93:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e9a:	00 
  801e9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  801eac:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaf:	89 04 24             	mov    %eax,(%esp)
  801eb2:	e8 44 03 00 00       	call   8021fb <nsipc_recv>
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ebf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec6:	89 04 24             	mov    %eax,(%esp)
  801ec9:	e8 f8 f6 ff ff       	call   8015c6 <fd_lookup>
  801ece:	85 c0                	test   %eax,%eax
  801ed0:	78 17                	js     801ee9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801edb:	39 08                	cmp    %ecx,(%eax)
  801edd:	75 05                	jne    801ee4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801edf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee2:	eb 05                	jmp    801ee9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801ee4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801ee9:	c9                   	leave  
  801eea:	c3                   	ret    

00801eeb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801eeb:	55                   	push   %ebp
  801eec:	89 e5                	mov    %esp,%ebp
  801eee:	56                   	push   %esi
  801eef:	53                   	push   %ebx
  801ef0:	83 ec 20             	sub    $0x20,%esp
  801ef3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ef5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef8:	89 04 24             	mov    %eax,(%esp)
  801efb:	e8 77 f6 ff ff       	call   801577 <fd_alloc>
  801f00:	89 c3                	mov    %eax,%ebx
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 21                	js     801f27 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801f06:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f0d:	00 
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1c:	e8 a2 ee ff ff       	call   800dc3 <sys_page_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	85 c0                	test   %eax,%eax
  801f25:	79 0c                	jns    801f33 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801f27:	89 34 24             	mov    %esi,(%esp)
  801f2a:	e8 51 02 00 00       	call   802180 <nsipc_close>
		return r;
  801f2f:	89 d8                	mov    %ebx,%eax
  801f31:	eb 20                	jmp    801f53 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f33:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f41:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801f48:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801f4b:	89 14 24             	mov    %edx,(%esp)
  801f4e:	e8 fd f5 ff ff       	call   801550 <fd2num>
}
  801f53:	83 c4 20             	add    $0x20,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5e                   	pop    %esi
  801f58:	5d                   	pop    %ebp
  801f59:	c3                   	ret    

00801f5a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	e8 51 ff ff ff       	call   801eb9 <fd2sockid>
		return r;
  801f68:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f6a:	85 c0                	test   %eax,%eax
  801f6c:	78 23                	js     801f91 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f6e:	8b 55 10             	mov    0x10(%ebp),%edx
  801f71:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f75:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f78:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f7c:	89 04 24             	mov    %eax,(%esp)
  801f7f:	e8 45 01 00 00       	call   8020c9 <nsipc_accept>
		return r;
  801f84:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801f86:	85 c0                	test   %eax,%eax
  801f88:	78 07                	js     801f91 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801f8a:	e8 5c ff ff ff       	call   801eeb <alloc_sockfd>
  801f8f:	89 c1                	mov    %eax,%ecx
}
  801f91:	89 c8                	mov    %ecx,%eax
  801f93:	c9                   	leave  
  801f94:	c3                   	ret    

00801f95 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9e:	e8 16 ff ff ff       	call   801eb9 <fd2sockid>
  801fa3:	89 c2                	mov    %eax,%edx
  801fa5:	85 d2                	test   %edx,%edx
  801fa7:	78 16                	js     801fbf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801fa9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fac:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fb7:	89 14 24             	mov    %edx,(%esp)
  801fba:	e8 60 01 00 00       	call   80211f <nsipc_bind>
}
  801fbf:	c9                   	leave  
  801fc0:	c3                   	ret    

00801fc1 <shutdown>:

int
shutdown(int s, int how)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	e8 ea fe ff ff       	call   801eb9 <fd2sockid>
  801fcf:	89 c2                	mov    %eax,%edx
  801fd1:	85 d2                	test   %edx,%edx
  801fd3:	78 0f                	js     801fe4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fdc:	89 14 24             	mov    %edx,(%esp)
  801fdf:	e8 7a 01 00 00       	call   80215e <nsipc_shutdown>
}
  801fe4:	c9                   	leave  
  801fe5:	c3                   	ret    

00801fe6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe6:	55                   	push   %ebp
  801fe7:	89 e5                	mov    %esp,%ebp
  801fe9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fec:	8b 45 08             	mov    0x8(%ebp),%eax
  801fef:	e8 c5 fe ff ff       	call   801eb9 <fd2sockid>
  801ff4:	89 c2                	mov    %eax,%edx
  801ff6:	85 d2                	test   %edx,%edx
  801ff8:	78 16                	js     802010 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802001:	8b 45 0c             	mov    0xc(%ebp),%eax
  802004:	89 44 24 04          	mov    %eax,0x4(%esp)
  802008:	89 14 24             	mov    %edx,(%esp)
  80200b:	e8 8a 01 00 00       	call   80219a <nsipc_connect>
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <listen>:

int
listen(int s, int backlog)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802018:	8b 45 08             	mov    0x8(%ebp),%eax
  80201b:	e8 99 fe ff ff       	call   801eb9 <fd2sockid>
  802020:	89 c2                	mov    %eax,%edx
  802022:	85 d2                	test   %edx,%edx
  802024:	78 0f                	js     802035 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  802026:	8b 45 0c             	mov    0xc(%ebp),%eax
  802029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202d:	89 14 24             	mov    %edx,(%esp)
  802030:	e8 a4 01 00 00       	call   8021d9 <nsipc_listen>
}
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80203d:	8b 45 10             	mov    0x10(%ebp),%eax
  802040:	89 44 24 08          	mov    %eax,0x8(%esp)
  802044:	8b 45 0c             	mov    0xc(%ebp),%eax
  802047:	89 44 24 04          	mov    %eax,0x4(%esp)
  80204b:	8b 45 08             	mov    0x8(%ebp),%eax
  80204e:	89 04 24             	mov    %eax,(%esp)
  802051:	e8 98 02 00 00       	call   8022ee <nsipc_socket>
  802056:	89 c2                	mov    %eax,%edx
  802058:	85 d2                	test   %edx,%edx
  80205a:	78 05                	js     802061 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  80205c:	e8 8a fe ff ff       	call   801eeb <alloc_sockfd>
}
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	53                   	push   %ebx
  802067:	83 ec 14             	sub    $0x14,%esp
  80206a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  80206c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  802073:	75 11                	jne    802086 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  802075:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  80207c:	e8 90 f4 ff ff       	call   801511 <ipc_find_env>
  802081:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802086:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80208d:	00 
  80208e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  802095:	00 
  802096:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80209a:	a1 04 50 80 00       	mov    0x805004,%eax
  80209f:	89 04 24             	mov    %eax,(%esp)
  8020a2:	e8 0c f4 ff ff       	call   8014b3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ae:	00 
  8020af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020b6:	00 
  8020b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020be:	e8 86 f3 ff ff       	call   801449 <ipc_recv>
}
  8020c3:	83 c4 14             	add    $0x14,%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	56                   	push   %esi
  8020cd:	53                   	push   %ebx
  8020ce:	83 ec 10             	sub    $0x10,%esp
  8020d1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  8020d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  8020dc:	8b 06                	mov    (%esi),%eax
  8020de:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8020e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8020e8:	e8 76 ff ff ff       	call   802063 <nsipc>
  8020ed:	89 c3                	mov    %eax,%ebx
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 23                	js     802116 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8020f3:	a1 10 70 80 00       	mov    0x807010,%eax
  8020f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020fc:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802103:	00 
  802104:	8b 45 0c             	mov    0xc(%ebp),%eax
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	e8 35 ea ff ff       	call   800b44 <memmove>
		*addrlen = ret->ret_addrlen;
  80210f:	a1 10 70 80 00       	mov    0x807010,%eax
  802114:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802116:	89 d8                	mov    %ebx,%eax
  802118:	83 c4 10             	add    $0x10,%esp
  80211b:	5b                   	pop    %ebx
  80211c:	5e                   	pop    %esi
  80211d:	5d                   	pop    %ebp
  80211e:	c3                   	ret    

0080211f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	53                   	push   %ebx
  802123:	83 ec 14             	sub    $0x14,%esp
  802126:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802129:	8b 45 08             	mov    0x8(%ebp),%eax
  80212c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802131:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802135:	8b 45 0c             	mov    0xc(%ebp),%eax
  802138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80213c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802143:	e8 fc e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802148:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80214e:	b8 02 00 00 00       	mov    $0x2,%eax
  802153:	e8 0b ff ff ff       	call   802063 <nsipc>
}
  802158:	83 c4 14             	add    $0x14,%esp
  80215b:	5b                   	pop    %ebx
  80215c:	5d                   	pop    %ebp
  80215d:	c3                   	ret    

0080215e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80215e:	55                   	push   %ebp
  80215f:	89 e5                	mov    %esp,%ebp
  802161:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802164:	8b 45 08             	mov    0x8(%ebp),%eax
  802167:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802174:	b8 03 00 00 00       	mov    $0x3,%eax
  802179:	e8 e5 fe ff ff       	call   802063 <nsipc>
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    

00802180 <nsipc_close>:

int
nsipc_close(int s)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80218e:	b8 04 00 00 00       	mov    $0x4,%eax
  802193:	e8 cb fe ff ff       	call   802063 <nsipc>
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	53                   	push   %ebx
  80219e:	83 ec 14             	sub    $0x14,%esp
  8021a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8021ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8021be:	e8 81 e9 ff ff       	call   800b44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8021c3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8021c9:	b8 05 00 00 00       	mov    $0x5,%eax
  8021ce:	e8 90 fe ff ff       	call   802063 <nsipc>
}
  8021d3:	83 c4 14             	add    $0x14,%esp
  8021d6:	5b                   	pop    %ebx
  8021d7:	5d                   	pop    %ebp
  8021d8:	c3                   	ret    

008021d9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8021d9:	55                   	push   %ebp
  8021da:	89 e5                	mov    %esp,%ebp
  8021dc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8021e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ea:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8021ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8021f4:	e8 6a fe ff ff       	call   802063 <nsipc>
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 10             	sub    $0x10,%esp
  802203:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80220e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802214:	8b 45 14             	mov    0x14(%ebp),%eax
  802217:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80221c:	b8 07 00 00 00       	mov    $0x7,%eax
  802221:	e8 3d fe ff ff       	call   802063 <nsipc>
  802226:	89 c3                	mov    %eax,%ebx
  802228:	85 c0                	test   %eax,%eax
  80222a:	78 46                	js     802272 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80222c:	39 f0                	cmp    %esi,%eax
  80222e:	7f 07                	jg     802237 <nsipc_recv+0x3c>
  802230:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802235:	7e 24                	jle    80225b <nsipc_recv+0x60>
  802237:	c7 44 24 0c 2b 32 80 	movl   $0x80322b,0xc(%esp)
  80223e:	00 
  80223f:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  802246:	00 
  802247:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80224e:	00 
  80224f:	c7 04 24 40 32 80 00 	movl   $0x803240,(%esp)
  802256:	e8 2e e0 ff ff       	call   800289 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80225b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80225f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802266:	00 
  802267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226a:	89 04 24             	mov    %eax,(%esp)
  80226d:	e8 d2 e8 ff ff       	call   800b44 <memmove>
	}

	return r;
}
  802272:	89 d8                	mov    %ebx,%eax
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	5b                   	pop    %ebx
  802278:	5e                   	pop    %esi
  802279:	5d                   	pop    %ebp
  80227a:	c3                   	ret    

0080227b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	53                   	push   %ebx
  80227f:	83 ec 14             	sub    $0x14,%esp
  802282:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80228d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802293:	7e 24                	jle    8022b9 <nsipc_send+0x3e>
  802295:	c7 44 24 0c 4c 32 80 	movl   $0x80324c,0xc(%esp)
  80229c:	00 
  80229d:	c7 44 24 08 f3 31 80 	movl   $0x8031f3,0x8(%esp)
  8022a4:	00 
  8022a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8022ac:	00 
  8022ad:	c7 04 24 40 32 80 00 	movl   $0x803240,(%esp)
  8022b4:	e8 d0 df ff ff       	call   800289 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8022cb:	e8 74 e8 ff ff       	call   800b44 <memmove>
	nsipcbuf.send.req_size = size;
  8022d0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8022d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8022de:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e3:	e8 7b fd ff ff       	call   802063 <nsipc>
}
  8022e8:	83 c4 14             	add    $0x14,%esp
  8022eb:	5b                   	pop    %ebx
  8022ec:	5d                   	pop    %ebp
  8022ed:	c3                   	ret    

008022ee <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8022fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ff:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802304:	8b 45 10             	mov    0x10(%ebp),%eax
  802307:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80230c:	b8 09 00 00 00       	mov    $0x9,%eax
  802311:	e8 4d fd ff ff       	call   802063 <nsipc>
}
  802316:	c9                   	leave  
  802317:	c3                   	ret    

00802318 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802318:	55                   	push   %ebp
  802319:	89 e5                	mov    %esp,%ebp
  80231b:	56                   	push   %esi
  80231c:	53                   	push   %ebx
  80231d:	83 ec 10             	sub    $0x10,%esp
  802320:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	89 04 24             	mov    %eax,(%esp)
  802329:	e8 32 f2 ff ff       	call   801560 <fd2data>
  80232e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802330:	c7 44 24 04 58 32 80 	movl   $0x803258,0x4(%esp)
  802337:	00 
  802338:	89 1c 24             	mov    %ebx,(%esp)
  80233b:	e8 67 e6 ff ff       	call   8009a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802340:	8b 46 04             	mov    0x4(%esi),%eax
  802343:	2b 06                	sub    (%esi),%eax
  802345:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80234b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802352:	00 00 00 
	stat->st_dev = &devpipe;
  802355:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80235c:	40 80 00 
	return 0;
}
  80235f:	b8 00 00 00 00       	mov    $0x0,%eax
  802364:	83 c4 10             	add    $0x10,%esp
  802367:	5b                   	pop    %ebx
  802368:	5e                   	pop    %esi
  802369:	5d                   	pop    %ebp
  80236a:	c3                   	ret    

0080236b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80236b:	55                   	push   %ebp
  80236c:	89 e5                	mov    %esp,%ebp
  80236e:	53                   	push   %ebx
  80236f:	83 ec 14             	sub    $0x14,%esp
  802372:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802375:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802380:	e8 e5 ea ff ff       	call   800e6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802385:	89 1c 24             	mov    %ebx,(%esp)
  802388:	e8 d3 f1 ff ff       	call   801560 <fd2data>
  80238d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802391:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802398:	e8 cd ea ff ff       	call   800e6a <sys_page_unmap>
}
  80239d:	83 c4 14             	add    $0x14,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5d                   	pop    %ebp
  8023a2:	c3                   	ret    

008023a3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	57                   	push   %edi
  8023a7:	56                   	push   %esi
  8023a8:	53                   	push   %ebx
  8023a9:	83 ec 2c             	sub    $0x2c,%esp
  8023ac:	89 c6                	mov    %eax,%esi
  8023ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8023b1:	a1 08 50 80 00       	mov    0x805008,%eax
  8023b6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023b9:	89 34 24             	mov    %esi,(%esp)
  8023bc:	e8 0d fa ff ff       	call   801dce <pageref>
  8023c1:	89 c7                	mov    %eax,%edi
  8023c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023c6:	89 04 24             	mov    %eax,(%esp)
  8023c9:	e8 00 fa ff ff       	call   801dce <pageref>
  8023ce:	39 c7                	cmp    %eax,%edi
  8023d0:	0f 94 c2             	sete   %dl
  8023d3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8023d6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8023dc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8023df:	39 fb                	cmp    %edi,%ebx
  8023e1:	74 21                	je     802404 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8023e3:	84 d2                	test   %dl,%dl
  8023e5:	74 ca                	je     8023b1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e7:	8b 51 58             	mov    0x58(%ecx),%edx
  8023ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023ee:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f6:	c7 04 24 5f 32 80 00 	movl   $0x80325f,(%esp)
  8023fd:	e8 80 df ff ff       	call   800382 <cprintf>
  802402:	eb ad                	jmp    8023b1 <_pipeisclosed+0xe>
	}
}
  802404:	83 c4 2c             	add    $0x2c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    

0080240c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	57                   	push   %edi
  802410:	56                   	push   %esi
  802411:	53                   	push   %ebx
  802412:	83 ec 1c             	sub    $0x1c,%esp
  802415:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802418:	89 34 24             	mov    %esi,(%esp)
  80241b:	e8 40 f1 ff ff       	call   801560 <fd2data>
  802420:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802422:	bf 00 00 00 00       	mov    $0x0,%edi
  802427:	eb 45                	jmp    80246e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802429:	89 da                	mov    %ebx,%edx
  80242b:	89 f0                	mov    %esi,%eax
  80242d:	e8 71 ff ff ff       	call   8023a3 <_pipeisclosed>
  802432:	85 c0                	test   %eax,%eax
  802434:	75 41                	jne    802477 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802436:	e8 69 e9 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80243b:	8b 43 04             	mov    0x4(%ebx),%eax
  80243e:	8b 0b                	mov    (%ebx),%ecx
  802440:	8d 51 20             	lea    0x20(%ecx),%edx
  802443:	39 d0                	cmp    %edx,%eax
  802445:	73 e2                	jae    802429 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802447:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80244a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80244e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802451:	99                   	cltd   
  802452:	c1 ea 1b             	shr    $0x1b,%edx
  802455:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802458:	83 e1 1f             	and    $0x1f,%ecx
  80245b:	29 d1                	sub    %edx,%ecx
  80245d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802461:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802465:	83 c0 01             	add    $0x1,%eax
  802468:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80246b:	83 c7 01             	add    $0x1,%edi
  80246e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802471:	75 c8                	jne    80243b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802473:	89 f8                	mov    %edi,%eax
  802475:	eb 05                	jmp    80247c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802477:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80247c:	83 c4 1c             	add    $0x1c,%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    

00802484 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802484:	55                   	push   %ebp
  802485:	89 e5                	mov    %esp,%ebp
  802487:	57                   	push   %edi
  802488:	56                   	push   %esi
  802489:	53                   	push   %ebx
  80248a:	83 ec 1c             	sub    $0x1c,%esp
  80248d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802490:	89 3c 24             	mov    %edi,(%esp)
  802493:	e8 c8 f0 ff ff       	call   801560 <fd2data>
  802498:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80249a:	be 00 00 00 00       	mov    $0x0,%esi
  80249f:	eb 3d                	jmp    8024de <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8024a1:	85 f6                	test   %esi,%esi
  8024a3:	74 04                	je     8024a9 <devpipe_read+0x25>
				return i;
  8024a5:	89 f0                	mov    %esi,%eax
  8024a7:	eb 43                	jmp    8024ec <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8024a9:	89 da                	mov    %ebx,%edx
  8024ab:	89 f8                	mov    %edi,%eax
  8024ad:	e8 f1 fe ff ff       	call   8023a3 <_pipeisclosed>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	75 31                	jne    8024e7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8024b6:	e8 e9 e8 ff ff       	call   800da4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8024bb:	8b 03                	mov    (%ebx),%eax
  8024bd:	3b 43 04             	cmp    0x4(%ebx),%eax
  8024c0:	74 df                	je     8024a1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024c2:	99                   	cltd   
  8024c3:	c1 ea 1b             	shr    $0x1b,%edx
  8024c6:	01 d0                	add    %edx,%eax
  8024c8:	83 e0 1f             	and    $0x1f,%eax
  8024cb:	29 d0                	sub    %edx,%eax
  8024cd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8024d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024d5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8024d8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024db:	83 c6 01             	add    $0x1,%esi
  8024de:	3b 75 10             	cmp    0x10(%ebp),%esi
  8024e1:	75 d8                	jne    8024bb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8024e3:	89 f0                	mov    %esi,%eax
  8024e5:	eb 05                	jmp    8024ec <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8024e7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8024ec:	83 c4 1c             	add    $0x1c,%esp
  8024ef:	5b                   	pop    %ebx
  8024f0:	5e                   	pop    %esi
  8024f1:	5f                   	pop    %edi
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    

008024f4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8024f4:	55                   	push   %ebp
  8024f5:	89 e5                	mov    %esp,%ebp
  8024f7:	56                   	push   %esi
  8024f8:	53                   	push   %ebx
  8024f9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8024fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024ff:	89 04 24             	mov    %eax,(%esp)
  802502:	e8 70 f0 ff ff       	call   801577 <fd_alloc>
  802507:	89 c2                	mov    %eax,%edx
  802509:	85 d2                	test   %edx,%edx
  80250b:	0f 88 4d 01 00 00    	js     80265e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802511:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802518:	00 
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802520:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802527:	e8 97 e8 ff ff       	call   800dc3 <sys_page_alloc>
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	85 d2                	test   %edx,%edx
  802530:	0f 88 28 01 00 00    	js     80265e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 36 f0 ff ff       	call   801577 <fd_alloc>
  802541:	89 c3                	mov    %eax,%ebx
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 88 fe 00 00 00    	js     802649 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802552:	00 
  802553:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802556:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802561:	e8 5d e8 ff ff       	call   800dc3 <sys_page_alloc>
  802566:	89 c3                	mov    %eax,%ebx
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 88 d9 00 00 00    	js     802649 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	89 04 24             	mov    %eax,(%esp)
  802576:	e8 e5 ef ff ff       	call   801560 <fd2data>
  80257b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80257d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802584:	00 
  802585:	89 44 24 04          	mov    %eax,0x4(%esp)
  802589:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802590:	e8 2e e8 ff ff       	call   800dc3 <sys_page_alloc>
  802595:	89 c3                	mov    %eax,%ebx
  802597:	85 c0                	test   %eax,%eax
  802599:	0f 88 97 00 00 00    	js     802636 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80259f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025a2:	89 04 24             	mov    %eax,(%esp)
  8025a5:	e8 b6 ef ff ff       	call   801560 <fd2data>
  8025aa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8025b1:	00 
  8025b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025bd:	00 
  8025be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c9:	e8 49 e8 ff ff       	call   800e17 <sys_page_map>
  8025ce:	89 c3                	mov    %eax,%ebx
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	78 52                	js     802626 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8025d4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8025e9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	89 04 24             	mov    %eax,(%esp)
  802604:	e8 47 ef ff ff       	call   801550 <fd2num>
  802609:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80260c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80260e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802611:	89 04 24             	mov    %eax,(%esp)
  802614:	e8 37 ef ff ff       	call   801550 <fd2num>
  802619:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80261c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80261f:	b8 00 00 00 00       	mov    $0x0,%eax
  802624:	eb 38                	jmp    80265e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802626:	89 74 24 04          	mov    %esi,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 34 e8 ff ff       	call   800e6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802639:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802644:	e8 21 e8 ff ff       	call   800e6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802650:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802657:	e8 0e e8 ff ff       	call   800e6a <sys_page_unmap>
  80265c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80265e:	83 c4 30             	add    $0x30,%esp
  802661:	5b                   	pop    %ebx
  802662:	5e                   	pop    %esi
  802663:	5d                   	pop    %ebp
  802664:	c3                   	ret    

00802665 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802665:	55                   	push   %ebp
  802666:	89 e5                	mov    %esp,%ebp
  802668:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80266b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80266e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802672:	8b 45 08             	mov    0x8(%ebp),%eax
  802675:	89 04 24             	mov    %eax,(%esp)
  802678:	e8 49 ef ff ff       	call   8015c6 <fd_lookup>
  80267d:	89 c2                	mov    %eax,%edx
  80267f:	85 d2                	test   %edx,%edx
  802681:	78 15                	js     802698 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 d2 ee ff ff       	call   801560 <fd2data>
	return _pipeisclosed(fd, p);
  80268e:	89 c2                	mov    %eax,%edx
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	e8 0b fd ff ff       	call   8023a3 <_pipeisclosed>
}
  802698:	c9                   	leave  
  802699:	c3                   	ret    
  80269a:	66 90                	xchg   %ax,%ax
  80269c:	66 90                	xchg   %ax,%ax
  80269e:	66 90                	xchg   %ax,%ax

008026a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8026a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026a8:	5d                   	pop    %ebp
  8026a9:	c3                   	ret    

008026aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8026b0:	c7 44 24 04 77 32 80 	movl   $0x803277,0x4(%esp)
  8026b7:	00 
  8026b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bb:	89 04 24             	mov    %eax,(%esp)
  8026be:	e8 e4 e2 ff ff       	call   8009a7 <strcpy>
	return 0;
}
  8026c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026c8:	c9                   	leave  
  8026c9:	c3                   	ret    

008026ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026ca:	55                   	push   %ebp
  8026cb:	89 e5                	mov    %esp,%ebp
  8026cd:	57                   	push   %edi
  8026ce:	56                   	push   %esi
  8026cf:	53                   	push   %ebx
  8026d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026d6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026db:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8026e1:	eb 31                	jmp    802714 <devcons_write+0x4a>
		m = n - tot;
  8026e3:	8b 75 10             	mov    0x10(%ebp),%esi
  8026e6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8026e8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8026eb:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8026f0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8026f3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026f7:	03 45 0c             	add    0xc(%ebp),%eax
  8026fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026fe:	89 3c 24             	mov    %edi,(%esp)
  802701:	e8 3e e4 ff ff       	call   800b44 <memmove>
		sys_cputs(buf, m);
  802706:	89 74 24 04          	mov    %esi,0x4(%esp)
  80270a:	89 3c 24             	mov    %edi,(%esp)
  80270d:	e8 e4 e5 ff ff       	call   800cf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802712:	01 f3                	add    %esi,%ebx
  802714:	89 d8                	mov    %ebx,%eax
  802716:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802719:	72 c8                	jb     8026e3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80271b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802721:	5b                   	pop    %ebx
  802722:	5e                   	pop    %esi
  802723:	5f                   	pop    %edi
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802735:	75 07                	jne    80273e <devcons_read+0x18>
  802737:	eb 2a                	jmp    802763 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802739:	e8 66 e6 ff ff       	call   800da4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80273e:	66 90                	xchg   %ax,%ax
  802740:	e8 cf e5 ff ff       	call   800d14 <sys_cgetc>
  802745:	85 c0                	test   %eax,%eax
  802747:	74 f0                	je     802739 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802749:	85 c0                	test   %eax,%eax
  80274b:	78 16                	js     802763 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80274d:	83 f8 04             	cmp    $0x4,%eax
  802750:	74 0c                	je     80275e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802752:	8b 55 0c             	mov    0xc(%ebp),%edx
  802755:	88 02                	mov    %al,(%edx)
	return 1;
  802757:	b8 01 00 00 00       	mov    $0x1,%eax
  80275c:	eb 05                	jmp    802763 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802771:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802778:	00 
  802779:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80277c:	89 04 24             	mov    %eax,(%esp)
  80277f:	e8 72 e5 ff ff       	call   800cf6 <sys_cputs>
}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <getchar>:

int
getchar(void)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80278c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802793:	00 
  802794:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80279b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027a2:	e8 b3 f0 ff ff       	call   80185a <read>
	if (r < 0)
  8027a7:	85 c0                	test   %eax,%eax
  8027a9:	78 0f                	js     8027ba <getchar+0x34>
		return r;
	if (r < 1)
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	7e 06                	jle    8027b5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8027af:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8027b3:	eb 05                	jmp    8027ba <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8027b5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8027ba:	c9                   	leave  
  8027bb:	c3                   	ret    

008027bc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8027bc:	55                   	push   %ebp
  8027bd:	89 e5                	mov    %esp,%ebp
  8027bf:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8027c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	89 04 24             	mov    %eax,(%esp)
  8027cf:	e8 f2 ed ff ff       	call   8015c6 <fd_lookup>
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	78 11                	js     8027e9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8027e1:	39 10                	cmp    %edx,(%eax)
  8027e3:	0f 94 c0             	sete   %al
  8027e6:	0f b6 c0             	movzbl %al,%eax
}
  8027e9:	c9                   	leave  
  8027ea:	c3                   	ret    

008027eb <opencons>:

int
opencons(void)
{
  8027eb:	55                   	push   %ebp
  8027ec:	89 e5                	mov    %esp,%ebp
  8027ee:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8027f4:	89 04 24             	mov    %eax,(%esp)
  8027f7:	e8 7b ed ff ff       	call   801577 <fd_alloc>
		return r;
  8027fc:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8027fe:	85 c0                	test   %eax,%eax
  802800:	78 40                	js     802842 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802802:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802809:	00 
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802811:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802818:	e8 a6 e5 ff ff       	call   800dc3 <sys_page_alloc>
		return r;
  80281d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80281f:	85 c0                	test   %eax,%eax
  802821:	78 1f                	js     802842 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802823:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802838:	89 04 24             	mov    %eax,(%esp)
  80283b:	e8 10 ed ff ff       	call   801550 <fd2num>
  802840:	89 c2                	mov    %eax,%edx
}
  802842:	89 d0                	mov    %edx,%eax
  802844:	c9                   	leave  
  802845:	c3                   	ret    

00802846 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80284c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802853:	75 58                	jne    8028ad <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802855:	a1 08 50 80 00       	mov    0x805008,%eax
  80285a:	8b 40 48             	mov    0x48(%eax),%eax
  80285d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802864:	00 
  802865:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80286c:	ee 
  80286d:	89 04 24             	mov    %eax,(%esp)
  802870:	e8 4e e5 ff ff       	call   800dc3 <sys_page_alloc>
		if(return_code!=0)
  802875:	85 c0                	test   %eax,%eax
  802877:	74 1c                	je     802895 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802879:	c7 44 24 08 84 32 80 	movl   $0x803284,0x8(%esp)
  802880:	00 
  802881:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802888:	00 
  802889:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  802890:	e8 f4 d9 ff ff       	call   800289 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802895:	a1 08 50 80 00       	mov    0x805008,%eax
  80289a:	8b 40 48             	mov    0x48(%eax),%eax
  80289d:	c7 44 24 04 b7 28 80 	movl   $0x8028b7,0x4(%esp)
  8028a4:	00 
  8028a5:	89 04 24             	mov    %eax,(%esp)
  8028a8:	e8 b6 e6 ff ff       	call   800f63 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8028b5:	c9                   	leave  
  8028b6:	c3                   	ret    

008028b7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8028b7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8028b8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8028bd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8028bf:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8028c2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8028c4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8028c8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8028cc:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8028cd:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8028cf:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8028d1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8028d5:	58                   	pop    %eax
	popl %eax;
  8028d6:	58                   	pop    %eax
	popal;
  8028d7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8028d8:	83 c4 04             	add    $0x4,%esp
	popfl;
  8028db:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8028dc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8028dd:	c3                   	ret    
  8028de:	66 90                	xchg   %ax,%ax

008028e0 <__udivdi3>:
  8028e0:	55                   	push   %ebp
  8028e1:	57                   	push   %edi
  8028e2:	56                   	push   %esi
  8028e3:	83 ec 0c             	sub    $0xc,%esp
  8028e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ea:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028ee:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028f2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028fc:	89 ea                	mov    %ebp,%edx
  8028fe:	89 0c 24             	mov    %ecx,(%esp)
  802901:	75 2d                	jne    802930 <__udivdi3+0x50>
  802903:	39 e9                	cmp    %ebp,%ecx
  802905:	77 61                	ja     802968 <__udivdi3+0x88>
  802907:	85 c9                	test   %ecx,%ecx
  802909:	89 ce                	mov    %ecx,%esi
  80290b:	75 0b                	jne    802918 <__udivdi3+0x38>
  80290d:	b8 01 00 00 00       	mov    $0x1,%eax
  802912:	31 d2                	xor    %edx,%edx
  802914:	f7 f1                	div    %ecx
  802916:	89 c6                	mov    %eax,%esi
  802918:	31 d2                	xor    %edx,%edx
  80291a:	89 e8                	mov    %ebp,%eax
  80291c:	f7 f6                	div    %esi
  80291e:	89 c5                	mov    %eax,%ebp
  802920:	89 f8                	mov    %edi,%eax
  802922:	f7 f6                	div    %esi
  802924:	89 ea                	mov    %ebp,%edx
  802926:	83 c4 0c             	add    $0xc,%esp
  802929:	5e                   	pop    %esi
  80292a:	5f                   	pop    %edi
  80292b:	5d                   	pop    %ebp
  80292c:	c3                   	ret    
  80292d:	8d 76 00             	lea    0x0(%esi),%esi
  802930:	39 e8                	cmp    %ebp,%eax
  802932:	77 24                	ja     802958 <__udivdi3+0x78>
  802934:	0f bd e8             	bsr    %eax,%ebp
  802937:	83 f5 1f             	xor    $0x1f,%ebp
  80293a:	75 3c                	jne    802978 <__udivdi3+0x98>
  80293c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802940:	39 34 24             	cmp    %esi,(%esp)
  802943:	0f 86 9f 00 00 00    	jbe    8029e8 <__udivdi3+0x108>
  802949:	39 d0                	cmp    %edx,%eax
  80294b:	0f 82 97 00 00 00    	jb     8029e8 <__udivdi3+0x108>
  802951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802958:	31 d2                	xor    %edx,%edx
  80295a:	31 c0                	xor    %eax,%eax
  80295c:	83 c4 0c             	add    $0xc,%esp
  80295f:	5e                   	pop    %esi
  802960:	5f                   	pop    %edi
  802961:	5d                   	pop    %ebp
  802962:	c3                   	ret    
  802963:	90                   	nop
  802964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802968:	89 f8                	mov    %edi,%eax
  80296a:	f7 f1                	div    %ecx
  80296c:	31 d2                	xor    %edx,%edx
  80296e:	83 c4 0c             	add    $0xc,%esp
  802971:	5e                   	pop    %esi
  802972:	5f                   	pop    %edi
  802973:	5d                   	pop    %ebp
  802974:	c3                   	ret    
  802975:	8d 76 00             	lea    0x0(%esi),%esi
  802978:	89 e9                	mov    %ebp,%ecx
  80297a:	8b 3c 24             	mov    (%esp),%edi
  80297d:	d3 e0                	shl    %cl,%eax
  80297f:	89 c6                	mov    %eax,%esi
  802981:	b8 20 00 00 00       	mov    $0x20,%eax
  802986:	29 e8                	sub    %ebp,%eax
  802988:	89 c1                	mov    %eax,%ecx
  80298a:	d3 ef                	shr    %cl,%edi
  80298c:	89 e9                	mov    %ebp,%ecx
  80298e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802992:	8b 3c 24             	mov    (%esp),%edi
  802995:	09 74 24 08          	or     %esi,0x8(%esp)
  802999:	89 d6                	mov    %edx,%esi
  80299b:	d3 e7                	shl    %cl,%edi
  80299d:	89 c1                	mov    %eax,%ecx
  80299f:	89 3c 24             	mov    %edi,(%esp)
  8029a2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029a6:	d3 ee                	shr    %cl,%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	d3 e2                	shl    %cl,%edx
  8029ac:	89 c1                	mov    %eax,%ecx
  8029ae:	d3 ef                	shr    %cl,%edi
  8029b0:	09 d7                	or     %edx,%edi
  8029b2:	89 f2                	mov    %esi,%edx
  8029b4:	89 f8                	mov    %edi,%eax
  8029b6:	f7 74 24 08          	divl   0x8(%esp)
  8029ba:	89 d6                	mov    %edx,%esi
  8029bc:	89 c7                	mov    %eax,%edi
  8029be:	f7 24 24             	mull   (%esp)
  8029c1:	39 d6                	cmp    %edx,%esi
  8029c3:	89 14 24             	mov    %edx,(%esp)
  8029c6:	72 30                	jb     8029f8 <__udivdi3+0x118>
  8029c8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8029cc:	89 e9                	mov    %ebp,%ecx
  8029ce:	d3 e2                	shl    %cl,%edx
  8029d0:	39 c2                	cmp    %eax,%edx
  8029d2:	73 05                	jae    8029d9 <__udivdi3+0xf9>
  8029d4:	3b 34 24             	cmp    (%esp),%esi
  8029d7:	74 1f                	je     8029f8 <__udivdi3+0x118>
  8029d9:	89 f8                	mov    %edi,%eax
  8029db:	31 d2                	xor    %edx,%edx
  8029dd:	e9 7a ff ff ff       	jmp    80295c <__udivdi3+0x7c>
  8029e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029e8:	31 d2                	xor    %edx,%edx
  8029ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8029ef:	e9 68 ff ff ff       	jmp    80295c <__udivdi3+0x7c>
  8029f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029fb:	31 d2                	xor    %edx,%edx
  8029fd:	83 c4 0c             	add    $0xc,%esp
  802a00:	5e                   	pop    %esi
  802a01:	5f                   	pop    %edi
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
  802a04:	66 90                	xchg   %ax,%ax
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	66 90                	xchg   %ax,%ax
  802a0a:	66 90                	xchg   %ax,%ax
  802a0c:	66 90                	xchg   %ax,%ax
  802a0e:	66 90                	xchg   %ax,%ax

00802a10 <__umoddi3>:
  802a10:	55                   	push   %ebp
  802a11:	57                   	push   %edi
  802a12:	56                   	push   %esi
  802a13:	83 ec 14             	sub    $0x14,%esp
  802a16:	8b 44 24 28          	mov    0x28(%esp),%eax
  802a1a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802a1e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802a22:	89 c7                	mov    %eax,%edi
  802a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a28:	8b 44 24 30          	mov    0x30(%esp),%eax
  802a2c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a30:	89 34 24             	mov    %esi,(%esp)
  802a33:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a37:	85 c0                	test   %eax,%eax
  802a39:	89 c2                	mov    %eax,%edx
  802a3b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a3f:	75 17                	jne    802a58 <__umoddi3+0x48>
  802a41:	39 fe                	cmp    %edi,%esi
  802a43:	76 4b                	jbe    802a90 <__umoddi3+0x80>
  802a45:	89 c8                	mov    %ecx,%eax
  802a47:	89 fa                	mov    %edi,%edx
  802a49:	f7 f6                	div    %esi
  802a4b:	89 d0                	mov    %edx,%eax
  802a4d:	31 d2                	xor    %edx,%edx
  802a4f:	83 c4 14             	add    $0x14,%esp
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	39 f8                	cmp    %edi,%eax
  802a5a:	77 54                	ja     802ab0 <__umoddi3+0xa0>
  802a5c:	0f bd e8             	bsr    %eax,%ebp
  802a5f:	83 f5 1f             	xor    $0x1f,%ebp
  802a62:	75 5c                	jne    802ac0 <__umoddi3+0xb0>
  802a64:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a68:	39 3c 24             	cmp    %edi,(%esp)
  802a6b:	0f 87 e7 00 00 00    	ja     802b58 <__umoddi3+0x148>
  802a71:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a75:	29 f1                	sub    %esi,%ecx
  802a77:	19 c7                	sbb    %eax,%edi
  802a79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a7d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a81:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a85:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a89:	83 c4 14             	add    $0x14,%esp
  802a8c:	5e                   	pop    %esi
  802a8d:	5f                   	pop    %edi
  802a8e:	5d                   	pop    %ebp
  802a8f:	c3                   	ret    
  802a90:	85 f6                	test   %esi,%esi
  802a92:	89 f5                	mov    %esi,%ebp
  802a94:	75 0b                	jne    802aa1 <__umoddi3+0x91>
  802a96:	b8 01 00 00 00       	mov    $0x1,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f6                	div    %esi
  802a9f:	89 c5                	mov    %eax,%ebp
  802aa1:	8b 44 24 04          	mov    0x4(%esp),%eax
  802aa5:	31 d2                	xor    %edx,%edx
  802aa7:	f7 f5                	div    %ebp
  802aa9:	89 c8                	mov    %ecx,%eax
  802aab:	f7 f5                	div    %ebp
  802aad:	eb 9c                	jmp    802a4b <__umoddi3+0x3b>
  802aaf:	90                   	nop
  802ab0:	89 c8                	mov    %ecx,%eax
  802ab2:	89 fa                	mov    %edi,%edx
  802ab4:	83 c4 14             	add    $0x14,%esp
  802ab7:	5e                   	pop    %esi
  802ab8:	5f                   	pop    %edi
  802ab9:	5d                   	pop    %ebp
  802aba:	c3                   	ret    
  802abb:	90                   	nop
  802abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac0:	8b 04 24             	mov    (%esp),%eax
  802ac3:	be 20 00 00 00       	mov    $0x20,%esi
  802ac8:	89 e9                	mov    %ebp,%ecx
  802aca:	29 ee                	sub    %ebp,%esi
  802acc:	d3 e2                	shl    %cl,%edx
  802ace:	89 f1                	mov    %esi,%ecx
  802ad0:	d3 e8                	shr    %cl,%eax
  802ad2:	89 e9                	mov    %ebp,%ecx
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	8b 04 24             	mov    (%esp),%eax
  802adb:	09 54 24 04          	or     %edx,0x4(%esp)
  802adf:	89 fa                	mov    %edi,%edx
  802ae1:	d3 e0                	shl    %cl,%eax
  802ae3:	89 f1                	mov    %esi,%ecx
  802ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ae9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802aed:	d3 ea                	shr    %cl,%edx
  802aef:	89 e9                	mov    %ebp,%ecx
  802af1:	d3 e7                	shl    %cl,%edi
  802af3:	89 f1                	mov    %esi,%ecx
  802af5:	d3 e8                	shr    %cl,%eax
  802af7:	89 e9                	mov    %ebp,%ecx
  802af9:	09 f8                	or     %edi,%eax
  802afb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802aff:	f7 74 24 04          	divl   0x4(%esp)
  802b03:	d3 e7                	shl    %cl,%edi
  802b05:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802b09:	89 d7                	mov    %edx,%edi
  802b0b:	f7 64 24 08          	mull   0x8(%esp)
  802b0f:	39 d7                	cmp    %edx,%edi
  802b11:	89 c1                	mov    %eax,%ecx
  802b13:	89 14 24             	mov    %edx,(%esp)
  802b16:	72 2c                	jb     802b44 <__umoddi3+0x134>
  802b18:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802b1c:	72 22                	jb     802b40 <__umoddi3+0x130>
  802b1e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802b22:	29 c8                	sub    %ecx,%eax
  802b24:	19 d7                	sbb    %edx,%edi
  802b26:	89 e9                	mov    %ebp,%ecx
  802b28:	89 fa                	mov    %edi,%edx
  802b2a:	d3 e8                	shr    %cl,%eax
  802b2c:	89 f1                	mov    %esi,%ecx
  802b2e:	d3 e2                	shl    %cl,%edx
  802b30:	89 e9                	mov    %ebp,%ecx
  802b32:	d3 ef                	shr    %cl,%edi
  802b34:	09 d0                	or     %edx,%eax
  802b36:	89 fa                	mov    %edi,%edx
  802b38:	83 c4 14             	add    $0x14,%esp
  802b3b:	5e                   	pop    %esi
  802b3c:	5f                   	pop    %edi
  802b3d:	5d                   	pop    %ebp
  802b3e:	c3                   	ret    
  802b3f:	90                   	nop
  802b40:	39 d7                	cmp    %edx,%edi
  802b42:	75 da                	jne    802b1e <__umoddi3+0x10e>
  802b44:	8b 14 24             	mov    (%esp),%edx
  802b47:	89 c1                	mov    %eax,%ecx
  802b49:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b4d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b51:	eb cb                	jmp    802b1e <__umoddi3+0x10e>
  802b53:	90                   	nop
  802b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b58:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b5c:	0f 82 0f ff ff ff    	jb     802a71 <__umoddi3+0x61>
  802b62:	e9 1a ff ff ff       	jmp    802a81 <__umoddi3+0x71>
