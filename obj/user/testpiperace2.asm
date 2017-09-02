
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 b9 01 00 00       	call   8001ea <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	c7 04 24 40 2b 80 00 	movl   $0x802b40,(%esp)
  800043:	e8 06 03 00 00       	call   80034e <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 31 23 00 00       	call   802384 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x44>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 8e 2b 80 	movl   $0x802b8e,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 97 2b 80 00 	movl   $0x802b97,(%esp)
  800072:	e8 de 01 00 00       	call   800255 <_panic>
	if ((r = fork()) < 0)
  800077:	e8 4a 11 00 00       	call   8011c6 <fork>
  80007c:	89 c7                	mov    %eax,%edi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6f>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 ac 2b 80 	movl   $0x802bac,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 97 2b 80 00 	movl   $0x802b97,(%esp)
  80009d:	e8 b3 01 00 00       	call   800255 <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 75                	jne    80011b <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 16 15 00 00       	call   8015c7 <close>
		for (i = 0; i < 200; i++) {
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
			if (i % 10 == 0)
  8000b6:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bb:	89 d8                	mov    %ebx,%eax
  8000bd:	f7 ee                	imul   %esi
  8000bf:	c1 fa 02             	sar    $0x2,%edx
  8000c2:	89 d8                	mov    %ebx,%eax
  8000c4:	c1 f8 1f             	sar    $0x1f,%eax
  8000c7:	29 c2                	sub    %eax,%edx
  8000c9:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cc:	01 c0                	add    %eax,%eax
  8000ce:	39 c3                	cmp    %eax,%ebx
  8000d0:	75 10                	jne    8000e2 <umain+0xaf>
				cprintf("%d.", i);
  8000d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d6:	c7 04 24 b5 2b 80 00 	movl   $0x802bb5,(%esp)
  8000dd:	e8 6c 02 00 00       	call   80034e <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e2:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000e9:	00 
  8000ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 27 15 00 00       	call   80161c <dup>
			sys_yield();
  8000f5:	e8 7a 0c 00 00       	call   800d74 <sys_yield>
			close(10);
  8000fa:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800101:	e8 c1 14 00 00       	call   8015c7 <close>
			sys_yield();
  800106:	e8 69 0c 00 00       	call   800d74 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010b:	83 c3 01             	add    $0x1,%ebx
  80010e:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800114:	75 a5                	jne    8000bb <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800116:	e8 21 01 00 00       	call   80023c <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011b:	89 fb                	mov    %edi,%ebx
  80011d:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800123:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800126:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012c:	eb 28                	jmp    800156 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800131:	89 04 24             	mov    %eax,(%esp)
  800134:	e8 bc 23 00 00       	call   8024f5 <pipeisclosed>
  800139:	85 c0                	test   %eax,%eax
  80013b:	74 19                	je     800156 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013d:	c7 04 24 b9 2b 80 00 	movl   $0x802bb9,(%esp)
  800144:	e8 05 02 00 00       	call   80034e <cprintf>
			sys_env_destroy(r);
  800149:	89 3c 24             	mov    %edi,(%esp)
  80014c:	e8 b2 0b 00 00       	call   800d03 <sys_env_destroy>
			exit();
  800151:	e8 e6 00 00 00       	call   80023c <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800156:	8b 43 54             	mov    0x54(%ebx),%eax
  800159:	83 f8 02             	cmp    $0x2,%eax
  80015c:	74 d0                	je     80012e <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015e:	c7 04 24 d5 2b 80 00 	movl   $0x802bd5,(%esp)
  800165:	e8 e4 01 00 00       	call   80034e <cprintf>
	if (pipeisclosed(p[0]))
  80016a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016d:	89 04 24             	mov    %eax,(%esp)
  800170:	e8 80 23 00 00       	call   8024f5 <pipeisclosed>
  800175:	85 c0                	test   %eax,%eax
  800177:	74 1c                	je     800195 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  800179:	c7 44 24 08 64 2b 80 	movl   $0x802b64,0x8(%esp)
  800180:	00 
  800181:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800188:	00 
  800189:	c7 04 24 97 2b 80 00 	movl   $0x802b97,(%esp)
  800190:	e8 c0 00 00 00       	call   800255 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800195:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	89 04 24             	mov    %eax,(%esp)
  8001a2:	e8 ef 12 00 00       	call   801496 <fd_lookup>
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	79 20                	jns    8001cb <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001af:	c7 44 24 08 eb 2b 80 	movl   $0x802beb,0x8(%esp)
  8001b6:	00 
  8001b7:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001be:	00 
  8001bf:	c7 04 24 97 2b 80 00 	movl   $0x802b97,(%esp)
  8001c6:	e8 8a 00 00 00       	call   800255 <_panic>
	(void) fd2data(fd);
  8001cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ce:	89 04 24             	mov    %eax,(%esp)
  8001d1:	e8 5a 12 00 00       	call   801430 <fd2data>
	cprintf("race didn't happen\n");
  8001d6:	c7 04 24 03 2c 80 00 	movl   $0x802c03,(%esp)
  8001dd:	e8 6c 01 00 00       	call   80034e <cprintf>
}
  8001e2:	83 c4 2c             	add    $0x2c,%esp
  8001e5:	5b                   	pop    %ebx
  8001e6:	5e                   	pop    %esi
  8001e7:	5f                   	pop    %edi
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	83 ec 10             	sub    $0x10,%esp
  8001f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001f5:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8001f8:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  8001ff:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800202:	e8 4e 0b 00 00       	call   800d55 <sys_getenvid>
  800207:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80020c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800214:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800219:	85 db                	test   %ebx,%ebx
  80021b:	7e 07                	jle    800224 <libmain+0x3a>
		binaryname = argv[0];
  80021d:	8b 06                	mov    (%esi),%eax
  80021f:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800224:	89 74 24 04          	mov    %esi,0x4(%esp)
  800228:	89 1c 24             	mov    %ebx,(%esp)
  80022b:	e8 03 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800230:	e8 07 00 00 00       	call   80023c <exit>
}
  800235:	83 c4 10             	add    $0x10,%esp
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800242:	e8 b3 13 00 00       	call   8015fa <close_all>
	sys_env_destroy(0);
  800247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024e:	e8 b0 0a 00 00       	call   800d03 <sys_env_destroy>
}
  800253:	c9                   	leave  
  800254:	c3                   	ret    

00800255 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800255:	55                   	push   %ebp
  800256:	89 e5                	mov    %esp,%ebp
  800258:	56                   	push   %esi
  800259:	53                   	push   %ebx
  80025a:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80025d:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800260:	8b 35 00 40 80 00    	mov    0x804000,%esi
  800266:	e8 ea 0a 00 00       	call   800d55 <sys_getenvid>
  80026b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80026e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800272:	8b 55 08             	mov    0x8(%ebp),%edx
  800275:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800279:	89 74 24 08          	mov    %esi,0x8(%esp)
  80027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800281:	c7 04 24 24 2c 80 00 	movl   $0x802c24,(%esp)
  800288:	e8 c1 00 00 00       	call   80034e <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80028d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800291:	8b 45 10             	mov    0x10(%ebp),%eax
  800294:	89 04 24             	mov    %eax,(%esp)
  800297:	e8 51 00 00 00       	call   8002ed <vcprintf>
	cprintf("\n");
  80029c:	c7 04 24 10 32 80 00 	movl   $0x803210,(%esp)
  8002a3:	e8 a6 00 00 00       	call   80034e <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a8:	cc                   	int3   
  8002a9:	eb fd                	jmp    8002a8 <_panic+0x53>

008002ab <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 14             	sub    $0x14,%esp
  8002b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b5:	8b 13                	mov    (%ebx),%edx
  8002b7:	8d 42 01             	lea    0x1(%edx),%eax
  8002ba:	89 03                	mov    %eax,(%ebx)
  8002bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002bf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c8:	75 19                	jne    8002e3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ca:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002d1:	00 
  8002d2:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d5:	89 04 24             	mov    %eax,(%esp)
  8002d8:	e8 e9 09 00 00       	call   800cc6 <sys_cputs>
		b->idx = 0;
  8002dd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002e3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002e7:	83 c4 14             	add    $0x14,%esp
  8002ea:	5b                   	pop    %ebx
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002f6:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002fd:	00 00 00 
	b.cnt = 0;
  800300:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800307:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800311:	8b 45 08             	mov    0x8(%ebp),%eax
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800322:	c7 04 24 ab 02 80 00 	movl   $0x8002ab,(%esp)
  800329:	e8 b0 01 00 00       	call   8004de <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80032e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800334:	89 44 24 04          	mov    %eax,0x4(%esp)
  800338:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80033e:	89 04 24             	mov    %eax,(%esp)
  800341:	e8 80 09 00 00       	call   800cc6 <sys_cputs>

	return b.cnt;
}
  800346:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80034c:	c9                   	leave  
  80034d:	c3                   	ret    

0080034e <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80034e:	55                   	push   %ebp
  80034f:	89 e5                	mov    %esp,%ebp
  800351:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800354:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800357:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035b:	8b 45 08             	mov    0x8(%ebp),%eax
  80035e:	89 04 24             	mov    %eax,(%esp)
  800361:	e8 87 ff ff ff       	call   8002ed <vcprintf>
	va_end(ap);

	return cnt;
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    
  800368:	66 90                	xchg   %ax,%ax
  80036a:	66 90                	xchg   %ax,%ax
  80036c:	66 90                	xchg   %ax,%ax
  80036e:	66 90                	xchg   %ax,%ax

00800370 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800370:	55                   	push   %ebp
  800371:	89 e5                	mov    %esp,%ebp
  800373:	57                   	push   %edi
  800374:	56                   	push   %esi
  800375:	53                   	push   %ebx
  800376:	83 ec 3c             	sub    $0x3c,%esp
  800379:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80037c:	89 d7                	mov    %edx,%edi
  80037e:	8b 45 08             	mov    0x8(%ebp),%eax
  800381:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800384:	8b 45 0c             	mov    0xc(%ebp),%eax
  800387:	89 c3                	mov    %eax,%ebx
  800389:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80038c:	8b 45 10             	mov    0x10(%ebp),%eax
  80038f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800392:	b9 00 00 00 00       	mov    $0x0,%ecx
  800397:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80039a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80039d:	39 d9                	cmp    %ebx,%ecx
  80039f:	72 05                	jb     8003a6 <printnum+0x36>
  8003a1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003a4:	77 69                	ja     80040f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8003a9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8003ad:	83 ee 01             	sub    $0x1,%esi
  8003b0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8003bc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8003c0:	89 c3                	mov    %eax,%ebx
  8003c2:	89 d6                	mov    %edx,%esi
  8003c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ca:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003ce:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8003d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d5:	89 04 24             	mov    %eax,(%esp)
  8003d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003df:	e8 cc 24 00 00       	call   8028b0 <__udivdi3>
  8003e4:	89 d9                	mov    %ebx,%ecx
  8003e6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ea:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8003ee:	89 04 24             	mov    %eax,(%esp)
  8003f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f5:	89 fa                	mov    %edi,%edx
  8003f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fa:	e8 71 ff ff ff       	call   800370 <printnum>
  8003ff:	eb 1b                	jmp    80041c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800401:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800405:	8b 45 18             	mov    0x18(%ebp),%eax
  800408:	89 04 24             	mov    %eax,(%esp)
  80040b:	ff d3                	call   *%ebx
  80040d:	eb 03                	jmp    800412 <printnum+0xa2>
  80040f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800412:	83 ee 01             	sub    $0x1,%esi
  800415:	85 f6                	test   %esi,%esi
  800417:	7f e8                	jg     800401 <printnum+0x91>
  800419:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80041c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800420:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800424:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800427:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80042a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800435:	89 04 24             	mov    %eax,(%esp)
  800438:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80043b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043f:	e8 9c 25 00 00       	call   8029e0 <__umoddi3>
  800444:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800448:	0f be 80 47 2c 80 00 	movsbl 0x802c47(%eax),%eax
  80044f:	89 04 24             	mov    %eax,(%esp)
  800452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800455:	ff d0                	call   *%eax
}
  800457:	83 c4 3c             	add    $0x3c,%esp
  80045a:	5b                   	pop    %ebx
  80045b:	5e                   	pop    %esi
  80045c:	5f                   	pop    %edi
  80045d:	5d                   	pop    %ebp
  80045e:	c3                   	ret    

0080045f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800462:	83 fa 01             	cmp    $0x1,%edx
  800465:	7e 0e                	jle    800475 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800467:	8b 10                	mov    (%eax),%edx
  800469:	8d 4a 08             	lea    0x8(%edx),%ecx
  80046c:	89 08                	mov    %ecx,(%eax)
  80046e:	8b 02                	mov    (%edx),%eax
  800470:	8b 52 04             	mov    0x4(%edx),%edx
  800473:	eb 22                	jmp    800497 <getuint+0x38>
	else if (lflag)
  800475:	85 d2                	test   %edx,%edx
  800477:	74 10                	je     800489 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800479:	8b 10                	mov    (%eax),%edx
  80047b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80047e:	89 08                	mov    %ecx,(%eax)
  800480:	8b 02                	mov    (%edx),%eax
  800482:	ba 00 00 00 00       	mov    $0x0,%edx
  800487:	eb 0e                	jmp    800497 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800489:	8b 10                	mov    (%eax),%edx
  80048b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80048e:	89 08                	mov    %ecx,(%eax)
  800490:	8b 02                	mov    (%edx),%eax
  800492:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800497:	5d                   	pop    %ebp
  800498:	c3                   	ret    

00800499 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800499:	55                   	push   %ebp
  80049a:	89 e5                	mov    %esp,%ebp
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80049f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004a3:	8b 10                	mov    (%eax),%edx
  8004a5:	3b 50 04             	cmp    0x4(%eax),%edx
  8004a8:	73 0a                	jae    8004b4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8004aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8004ad:	89 08                	mov    %ecx,(%eax)
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	88 02                	mov    %al,(%edx)
}
  8004b4:	5d                   	pop    %ebp
  8004b5:	c3                   	ret    

008004b6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8004b6:	55                   	push   %ebp
  8004b7:	89 e5                	mov    %esp,%ebp
  8004b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8004bc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8004bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d4:	89 04 24             	mov    %eax,(%esp)
  8004d7:	e8 02 00 00 00       	call   8004de <vprintfmt>
	va_end(ap);
}
  8004dc:	c9                   	leave  
  8004dd:	c3                   	ret    

008004de <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004de:	55                   	push   %ebp
  8004df:	89 e5                	mov    %esp,%ebp
  8004e1:	57                   	push   %edi
  8004e2:	56                   	push   %esi
  8004e3:	53                   	push   %ebx
  8004e4:	83 ec 3c             	sub    $0x3c,%esp
  8004e7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8004ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004ed:	eb 14                	jmp    800503 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004ef:	85 c0                	test   %eax,%eax
  8004f1:	0f 84 b3 03 00 00    	je     8008aa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8004f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fb:	89 04 24             	mov    %eax,(%esp)
  8004fe:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800501:	89 f3                	mov    %esi,%ebx
  800503:	8d 73 01             	lea    0x1(%ebx),%esi
  800506:	0f b6 03             	movzbl (%ebx),%eax
  800509:	83 f8 25             	cmp    $0x25,%eax
  80050c:	75 e1                	jne    8004ef <vprintfmt+0x11>
  80050e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800512:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800519:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800520:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800527:	ba 00 00 00 00       	mov    $0x0,%edx
  80052c:	eb 1d                	jmp    80054b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800530:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800534:	eb 15                	jmp    80054b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800536:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800538:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80053c:	eb 0d                	jmp    80054b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80053e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800541:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800544:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80054b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80054e:	0f b6 0e             	movzbl (%esi),%ecx
  800551:	0f b6 c1             	movzbl %cl,%eax
  800554:	83 e9 23             	sub    $0x23,%ecx
  800557:	80 f9 55             	cmp    $0x55,%cl
  80055a:	0f 87 2a 03 00 00    	ja     80088a <vprintfmt+0x3ac>
  800560:	0f b6 c9             	movzbl %cl,%ecx
  800563:	ff 24 8d 80 2d 80 00 	jmp    *0x802d80(,%ecx,4)
  80056a:	89 de                	mov    %ebx,%esi
  80056c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800571:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800574:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800578:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80057b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80057e:	83 fb 09             	cmp    $0x9,%ebx
  800581:	77 36                	ja     8005b9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800583:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800586:	eb e9                	jmp    800571 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 48 04             	lea    0x4(%eax),%ecx
  80058e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800591:	8b 00                	mov    (%eax),%eax
  800593:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800596:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800598:	eb 22                	jmp    8005bc <vprintfmt+0xde>
  80059a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80059d:	85 c9                	test   %ecx,%ecx
  80059f:	b8 00 00 00 00       	mov    $0x0,%eax
  8005a4:	0f 49 c1             	cmovns %ecx,%eax
  8005a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	89 de                	mov    %ebx,%esi
  8005ac:	eb 9d                	jmp    80054b <vprintfmt+0x6d>
  8005ae:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8005b0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8005b7:	eb 92                	jmp    80054b <vprintfmt+0x6d>
  8005b9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8005bc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005c0:	79 89                	jns    80054b <vprintfmt+0x6d>
  8005c2:	e9 77 ff ff ff       	jmp    80053e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005c7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ca:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8005cc:	e9 7a ff ff ff       	jmp    80054b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d4:	8d 50 04             	lea    0x4(%eax),%edx
  8005d7:	89 55 14             	mov    %edx,0x14(%ebp)
  8005da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005de:	8b 00                	mov    (%eax),%eax
  8005e0:	89 04 24             	mov    %eax,(%esp)
  8005e3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8005e6:	e9 18 ff ff ff       	jmp    800503 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ee:	8d 50 04             	lea    0x4(%eax),%edx
  8005f1:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f4:	8b 00                	mov    (%eax),%eax
  8005f6:	99                   	cltd   
  8005f7:	31 d0                	xor    %edx,%eax
  8005f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8005fb:	83 f8 0f             	cmp    $0xf,%eax
  8005fe:	7f 0b                	jg     80060b <vprintfmt+0x12d>
  800600:	8b 14 85 e0 2e 80 00 	mov    0x802ee0(,%eax,4),%edx
  800607:	85 d2                	test   %edx,%edx
  800609:	75 20                	jne    80062b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80060b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80060f:	c7 44 24 08 5f 2c 80 	movl   $0x802c5f,0x8(%esp)
  800616:	00 
  800617:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80061b:	8b 45 08             	mov    0x8(%ebp),%eax
  80061e:	89 04 24             	mov    %eax,(%esp)
  800621:	e8 90 fe ff ff       	call   8004b6 <printfmt>
  800626:	e9 d8 fe ff ff       	jmp    800503 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80062b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80062f:	c7 44 24 08 a5 31 80 	movl   $0x8031a5,0x8(%esp)
  800636:	00 
  800637:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	89 04 24             	mov    %eax,(%esp)
  800641:	e8 70 fe ff ff       	call   8004b6 <printfmt>
  800646:	e9 b8 fe ff ff       	jmp    800503 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80064b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80064e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800651:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8d 50 04             	lea    0x4(%eax),%edx
  80065a:	89 55 14             	mov    %edx,0x14(%ebp)
  80065d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80065f:	85 f6                	test   %esi,%esi
  800661:	b8 58 2c 80 00       	mov    $0x802c58,%eax
  800666:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800669:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80066d:	0f 84 97 00 00 00    	je     80070a <vprintfmt+0x22c>
  800673:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800677:	0f 8e 9b 00 00 00    	jle    800718 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80067d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800681:	89 34 24             	mov    %esi,(%esp)
  800684:	e8 cf 02 00 00       	call   800958 <strnlen>
  800689:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80068c:	29 c2                	sub    %eax,%edx
  80068e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800691:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800695:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800698:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80069b:	8b 75 08             	mov    0x8(%ebp),%esi
  80069e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8006a1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a3:	eb 0f                	jmp    8006b4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8006a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ac:	89 04 24             	mov    %eax,(%esp)
  8006af:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b1:	83 eb 01             	sub    $0x1,%ebx
  8006b4:	85 db                	test   %ebx,%ebx
  8006b6:	7f ed                	jg     8006a5 <vprintfmt+0x1c7>
  8006b8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8006bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006be:	85 d2                	test   %edx,%edx
  8006c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c5:	0f 49 c2             	cmovns %edx,%eax
  8006c8:	29 c2                	sub    %eax,%edx
  8006ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8006cd:	89 d7                	mov    %edx,%edi
  8006cf:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006d2:	eb 50                	jmp    800724 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006d8:	74 1e                	je     8006f8 <vprintfmt+0x21a>
  8006da:	0f be d2             	movsbl %dl,%edx
  8006dd:	83 ea 20             	sub    $0x20,%edx
  8006e0:	83 fa 5e             	cmp    $0x5e,%edx
  8006e3:	76 13                	jbe    8006f8 <vprintfmt+0x21a>
					putch('?', putdat);
  8006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ec:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006f3:	ff 55 08             	call   *0x8(%ebp)
  8006f6:	eb 0d                	jmp    800705 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8006f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	83 ef 01             	sub    $0x1,%edi
  800708:	eb 1a                	jmp    800724 <vprintfmt+0x246>
  80070a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80070d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800710:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800713:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800716:	eb 0c                	jmp    800724 <vprintfmt+0x246>
  800718:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80071b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80071e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800721:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800724:	83 c6 01             	add    $0x1,%esi
  800727:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80072b:	0f be c2             	movsbl %dl,%eax
  80072e:	85 c0                	test   %eax,%eax
  800730:	74 27                	je     800759 <vprintfmt+0x27b>
  800732:	85 db                	test   %ebx,%ebx
  800734:	78 9e                	js     8006d4 <vprintfmt+0x1f6>
  800736:	83 eb 01             	sub    $0x1,%ebx
  800739:	79 99                	jns    8006d4 <vprintfmt+0x1f6>
  80073b:	89 f8                	mov    %edi,%eax
  80073d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800740:	8b 75 08             	mov    0x8(%ebp),%esi
  800743:	89 c3                	mov    %eax,%ebx
  800745:	eb 1a                	jmp    800761 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800747:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800752:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800754:	83 eb 01             	sub    $0x1,%ebx
  800757:	eb 08                	jmp    800761 <vprintfmt+0x283>
  800759:	89 fb                	mov    %edi,%ebx
  80075b:	8b 75 08             	mov    0x8(%ebp),%esi
  80075e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800761:	85 db                	test   %ebx,%ebx
  800763:	7f e2                	jg     800747 <vprintfmt+0x269>
  800765:	89 75 08             	mov    %esi,0x8(%ebp)
  800768:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80076b:	e9 93 fd ff ff       	jmp    800503 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800770:	83 fa 01             	cmp    $0x1,%edx
  800773:	7e 16                	jle    80078b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800775:	8b 45 14             	mov    0x14(%ebp),%eax
  800778:	8d 50 08             	lea    0x8(%eax),%edx
  80077b:	89 55 14             	mov    %edx,0x14(%ebp)
  80077e:	8b 50 04             	mov    0x4(%eax),%edx
  800781:	8b 00                	mov    (%eax),%eax
  800783:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800786:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800789:	eb 32                	jmp    8007bd <vprintfmt+0x2df>
	else if (lflag)
  80078b:	85 d2                	test   %edx,%edx
  80078d:	74 18                	je     8007a7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 50 04             	lea    0x4(%eax),%edx
  800795:	89 55 14             	mov    %edx,0x14(%ebp)
  800798:	8b 30                	mov    (%eax),%esi
  80079a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80079d:	89 f0                	mov    %esi,%eax
  80079f:	c1 f8 1f             	sar    $0x1f,%eax
  8007a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a5:	eb 16                	jmp    8007bd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b0:	8b 30                	mov    (%eax),%esi
  8007b2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8007b5:	89 f0                	mov    %esi,%eax
  8007b7:	c1 f8 1f             	sar    $0x1f,%eax
  8007ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8007c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8007c8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007cc:	0f 89 80 00 00 00    	jns    800852 <vprintfmt+0x374>
				putch('-', putdat);
  8007d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007dd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8007e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007e6:	f7 d8                	neg    %eax
  8007e8:	83 d2 00             	adc    $0x0,%edx
  8007eb:	f7 da                	neg    %edx
			}
			base = 10;
  8007ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8007f2:	eb 5e                	jmp    800852 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007f4:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f7:	e8 63 fc ff ff       	call   80045f <getuint>
			base = 10;
  8007fc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800801:	eb 4f                	jmp    800852 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	e8 54 fc ff ff       	call   80045f <getuint>
			base =8;
  80080b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800810:	eb 40                	jmp    800852 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800812:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800816:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80081d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800820:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800824:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80082b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8d 50 04             	lea    0x4(%eax),%edx
  800834:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800837:	8b 00                	mov    (%eax),%eax
  800839:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80083e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800843:	eb 0d                	jmp    800852 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800845:	8d 45 14             	lea    0x14(%ebp),%eax
  800848:	e8 12 fc ff ff       	call   80045f <getuint>
			base = 16;
  80084d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800852:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800856:	89 74 24 10          	mov    %esi,0x10(%esp)
  80085a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80085d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800861:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800865:	89 04 24             	mov    %eax,(%esp)
  800868:	89 54 24 04          	mov    %edx,0x4(%esp)
  80086c:	89 fa                	mov    %edi,%edx
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	e8 fa fa ff ff       	call   800370 <printnum>
			break;
  800876:	e9 88 fc ff ff       	jmp    800503 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	ff 55 08             	call   *0x8(%ebp)
			break;
  800885:	e9 79 fc ff ff       	jmp    800503 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80088e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800895:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800898:	89 f3                	mov    %esi,%ebx
  80089a:	eb 03                	jmp    80089f <vprintfmt+0x3c1>
  80089c:	83 eb 01             	sub    $0x1,%ebx
  80089f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8008a3:	75 f7                	jne    80089c <vprintfmt+0x3be>
  8008a5:	e9 59 fc ff ff       	jmp    800503 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8008aa:	83 c4 3c             	add    $0x3c,%esp
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5f                   	pop    %edi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	83 ec 28             	sub    $0x28,%esp
  8008b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008be:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cf:	85 c0                	test   %eax,%eax
  8008d1:	74 30                	je     800903 <vsnprintf+0x51>
  8008d3:	85 d2                	test   %edx,%edx
  8008d5:	7e 2c                	jle    800903 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008de:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ec:	c7 04 24 99 04 80 00 	movl   $0x800499,(%esp)
  8008f3:	e8 e6 fb ff ff       	call   8004de <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008fb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800901:	eb 05                	jmp    800908 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800903:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800910:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800913:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800917:	8b 45 10             	mov    0x10(%ebp),%eax
  80091a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800921:	89 44 24 04          	mov    %eax,0x4(%esp)
  800925:	8b 45 08             	mov    0x8(%ebp),%eax
  800928:	89 04 24             	mov    %eax,(%esp)
  80092b:	e8 82 ff ff ff       	call   8008b2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800930:	c9                   	leave  
  800931:	c3                   	ret    
  800932:	66 90                	xchg   %ax,%ax
  800934:	66 90                	xchg   %ax,%ax
  800936:	66 90                	xchg   %ax,%ax
  800938:	66 90                	xchg   %ax,%ax
  80093a:	66 90                	xchg   %ax,%ax
  80093c:	66 90                	xchg   %ax,%ax
  80093e:	66 90                	xchg   %ax,%ax

00800940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	eb 03                	jmp    800950 <strlen+0x10>
		n++;
  80094d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800950:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800954:	75 f7                	jne    80094d <strlen+0xd>
		n++;
	return n;
}
  800956:	5d                   	pop    %ebp
  800957:	c3                   	ret    

00800958 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80095e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	eb 03                	jmp    80096b <strnlen+0x13>
		n++;
  800968:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80096b:	39 d0                	cmp    %edx,%eax
  80096d:	74 06                	je     800975 <strnlen+0x1d>
  80096f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800973:	75 f3                	jne    800968 <strnlen+0x10>
		n++;
	return n;
}
  800975:	5d                   	pop    %ebp
  800976:	c3                   	ret    

00800977 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800977:	55                   	push   %ebp
  800978:	89 e5                	mov    %esp,%ebp
  80097a:	53                   	push   %ebx
  80097b:	8b 45 08             	mov    0x8(%ebp),%eax
  80097e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800981:	89 c2                	mov    %eax,%edx
  800983:	83 c2 01             	add    $0x1,%edx
  800986:	83 c1 01             	add    $0x1,%ecx
  800989:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80098d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800990:	84 db                	test   %bl,%bl
  800992:	75 ef                	jne    800983 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800994:	5b                   	pop    %ebx
  800995:	5d                   	pop    %ebp
  800996:	c3                   	ret    

00800997 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800997:	55                   	push   %ebp
  800998:	89 e5                	mov    %esp,%ebp
  80099a:	53                   	push   %ebx
  80099b:	83 ec 08             	sub    $0x8,%esp
  80099e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009a1:	89 1c 24             	mov    %ebx,(%esp)
  8009a4:	e8 97 ff ff ff       	call   800940 <strlen>
	strcpy(dst + len, src);
  8009a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009b0:	01 d8                	add    %ebx,%eax
  8009b2:	89 04 24             	mov    %eax,(%esp)
  8009b5:	e8 bd ff ff ff       	call   800977 <strcpy>
	return dst;
}
  8009ba:	89 d8                	mov    %ebx,%eax
  8009bc:	83 c4 08             	add    $0x8,%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5d                   	pop    %ebp
  8009c1:	c3                   	ret    

008009c2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	56                   	push   %esi
  8009c6:	53                   	push   %ebx
  8009c7:	8b 75 08             	mov    0x8(%ebp),%esi
  8009ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009cd:	89 f3                	mov    %esi,%ebx
  8009cf:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d2:	89 f2                	mov    %esi,%edx
  8009d4:	eb 0f                	jmp    8009e5 <strncpy+0x23>
		*dst++ = *src;
  8009d6:	83 c2 01             	add    $0x1,%edx
  8009d9:	0f b6 01             	movzbl (%ecx),%eax
  8009dc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009df:	80 39 01             	cmpb   $0x1,(%ecx)
  8009e2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e5:	39 da                	cmp    %ebx,%edx
  8009e7:	75 ed                	jne    8009d6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009e9:	89 f0                	mov    %esi,%eax
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009fa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8009fd:	89 f0                	mov    %esi,%eax
  8009ff:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a03:	85 c9                	test   %ecx,%ecx
  800a05:	75 0b                	jne    800a12 <strlcpy+0x23>
  800a07:	eb 1d                	jmp    800a26 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a09:	83 c0 01             	add    $0x1,%eax
  800a0c:	83 c2 01             	add    $0x1,%edx
  800a0f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a12:	39 d8                	cmp    %ebx,%eax
  800a14:	74 0b                	je     800a21 <strlcpy+0x32>
  800a16:	0f b6 0a             	movzbl (%edx),%ecx
  800a19:	84 c9                	test   %cl,%cl
  800a1b:	75 ec                	jne    800a09 <strlcpy+0x1a>
  800a1d:	89 c2                	mov    %eax,%edx
  800a1f:	eb 02                	jmp    800a23 <strlcpy+0x34>
  800a21:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800a23:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800a26:	29 f0                	sub    %esi,%eax
}
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a32:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a35:	eb 06                	jmp    800a3d <strcmp+0x11>
		p++, q++;
  800a37:	83 c1 01             	add    $0x1,%ecx
  800a3a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a3d:	0f b6 01             	movzbl (%ecx),%eax
  800a40:	84 c0                	test   %al,%al
  800a42:	74 04                	je     800a48 <strcmp+0x1c>
  800a44:	3a 02                	cmp    (%edx),%al
  800a46:	74 ef                	je     800a37 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a48:	0f b6 c0             	movzbl %al,%eax
  800a4b:	0f b6 12             	movzbl (%edx),%edx
  800a4e:	29 d0                	sub    %edx,%eax
}
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	53                   	push   %ebx
  800a56:	8b 45 08             	mov    0x8(%ebp),%eax
  800a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5c:	89 c3                	mov    %eax,%ebx
  800a5e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a61:	eb 06                	jmp    800a69 <strncmp+0x17>
		n--, p++, q++;
  800a63:	83 c0 01             	add    $0x1,%eax
  800a66:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a69:	39 d8                	cmp    %ebx,%eax
  800a6b:	74 15                	je     800a82 <strncmp+0x30>
  800a6d:	0f b6 08             	movzbl (%eax),%ecx
  800a70:	84 c9                	test   %cl,%cl
  800a72:	74 04                	je     800a78 <strncmp+0x26>
  800a74:	3a 0a                	cmp    (%edx),%cl
  800a76:	74 eb                	je     800a63 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a78:	0f b6 00             	movzbl (%eax),%eax
  800a7b:	0f b6 12             	movzbl (%edx),%edx
  800a7e:	29 d0                	sub    %edx,%eax
  800a80:	eb 05                	jmp    800a87 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800a82:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a87:	5b                   	pop    %ebx
  800a88:	5d                   	pop    %ebp
  800a89:	c3                   	ret    

00800a8a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a94:	eb 07                	jmp    800a9d <strchr+0x13>
		if (*s == c)
  800a96:	38 ca                	cmp    %cl,%dl
  800a98:	74 0f                	je     800aa9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	0f b6 10             	movzbl (%eax),%edx
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	75 f2                	jne    800a96 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab5:	eb 07                	jmp    800abe <strfind+0x13>
		if (*s == c)
  800ab7:	38 ca                	cmp    %cl,%dl
  800ab9:	74 0a                	je     800ac5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800abb:	83 c0 01             	add    $0x1,%eax
  800abe:	0f b6 10             	movzbl (%eax),%edx
  800ac1:	84 d2                	test   %dl,%dl
  800ac3:	75 f2                	jne    800ab7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800ac5:	5d                   	pop    %ebp
  800ac6:	c3                   	ret    

00800ac7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac7:	55                   	push   %ebp
  800ac8:	89 e5                	mov    %esp,%ebp
  800aca:	57                   	push   %edi
  800acb:	56                   	push   %esi
  800acc:	53                   	push   %ebx
  800acd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ad0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad3:	85 c9                	test   %ecx,%ecx
  800ad5:	74 36                	je     800b0d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800add:	75 28                	jne    800b07 <memset+0x40>
  800adf:	f6 c1 03             	test   $0x3,%cl
  800ae2:	75 23                	jne    800b07 <memset+0x40>
		c &= 0xFF;
  800ae4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae8:	89 d3                	mov    %edx,%ebx
  800aea:	c1 e3 08             	shl    $0x8,%ebx
  800aed:	89 d6                	mov    %edx,%esi
  800aef:	c1 e6 18             	shl    $0x18,%esi
  800af2:	89 d0                	mov    %edx,%eax
  800af4:	c1 e0 10             	shl    $0x10,%eax
  800af7:	09 f0                	or     %esi,%eax
  800af9:	09 c2                	or     %eax,%edx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800aff:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800b02:	fc                   	cld    
  800b03:	f3 ab                	rep stos %eax,%es:(%edi)
  800b05:	eb 06                	jmp    800b0d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	fc                   	cld    
  800b0b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b0d:	89 f8                	mov    %edi,%eax
  800b0f:	5b                   	pop    %ebx
  800b10:	5e                   	pop    %esi
  800b11:	5f                   	pop    %edi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	57                   	push   %edi
  800b18:	56                   	push   %esi
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b1f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b22:	39 c6                	cmp    %eax,%esi
  800b24:	73 35                	jae    800b5b <memmove+0x47>
  800b26:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b29:	39 d0                	cmp    %edx,%eax
  800b2b:	73 2e                	jae    800b5b <memmove+0x47>
		s += n;
		d += n;
  800b2d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800b30:	89 d6                	mov    %edx,%esi
  800b32:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b34:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b3a:	75 13                	jne    800b4f <memmove+0x3b>
  800b3c:	f6 c1 03             	test   $0x3,%cl
  800b3f:	75 0e                	jne    800b4f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b41:	83 ef 04             	sub    $0x4,%edi
  800b44:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b47:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800b4a:	fd                   	std    
  800b4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b4d:	eb 09                	jmp    800b58 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b4f:	83 ef 01             	sub    $0x1,%edi
  800b52:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b55:	fd                   	std    
  800b56:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b58:	fc                   	cld    
  800b59:	eb 1d                	jmp    800b78 <memmove+0x64>
  800b5b:	89 f2                	mov    %esi,%edx
  800b5d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b5f:	f6 c2 03             	test   $0x3,%dl
  800b62:	75 0f                	jne    800b73 <memmove+0x5f>
  800b64:	f6 c1 03             	test   $0x3,%cl
  800b67:	75 0a                	jne    800b73 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b69:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800b6c:	89 c7                	mov    %eax,%edi
  800b6e:	fc                   	cld    
  800b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b71:	eb 05                	jmp    800b78 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b73:	89 c7                	mov    %eax,%edi
  800b75:	fc                   	cld    
  800b76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b78:	5e                   	pop    %esi
  800b79:	5f                   	pop    %edi
  800b7a:	5d                   	pop    %ebp
  800b7b:	c3                   	ret    

00800b7c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b82:	8b 45 10             	mov    0x10(%ebp),%eax
  800b85:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b90:	8b 45 08             	mov    0x8(%ebp),%eax
  800b93:	89 04 24             	mov    %eax,(%esp)
  800b96:	e8 79 ff ff ff       	call   800b14 <memmove>
}
  800b9b:	c9                   	leave  
  800b9c:	c3                   	ret    

00800b9d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba8:	89 d6                	mov    %edx,%esi
  800baa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bad:	eb 1a                	jmp    800bc9 <memcmp+0x2c>
		if (*s1 != *s2)
  800baf:	0f b6 02             	movzbl (%edx),%eax
  800bb2:	0f b6 19             	movzbl (%ecx),%ebx
  800bb5:	38 d8                	cmp    %bl,%al
  800bb7:	74 0a                	je     800bc3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800bb9:	0f b6 c0             	movzbl %al,%eax
  800bbc:	0f b6 db             	movzbl %bl,%ebx
  800bbf:	29 d8                	sub    %ebx,%eax
  800bc1:	eb 0f                	jmp    800bd2 <memcmp+0x35>
		s1++, s2++;
  800bc3:	83 c2 01             	add    $0x1,%edx
  800bc6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc9:	39 f2                	cmp    %esi,%edx
  800bcb:	75 e2                	jne    800baf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800bcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bd2:	5b                   	pop    %ebx
  800bd3:	5e                   	pop    %esi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bdf:	89 c2                	mov    %eax,%edx
  800be1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be4:	eb 07                	jmp    800bed <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be6:	38 08                	cmp    %cl,(%eax)
  800be8:	74 07                	je     800bf1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	39 d0                	cmp    %edx,%eax
  800bef:	72 f5                	jb     800be6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bff:	eb 03                	jmp    800c04 <strtol+0x11>
		s++;
  800c01:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c04:	0f b6 0a             	movzbl (%edx),%ecx
  800c07:	80 f9 09             	cmp    $0x9,%cl
  800c0a:	74 f5                	je     800c01 <strtol+0xe>
  800c0c:	80 f9 20             	cmp    $0x20,%cl
  800c0f:	74 f0                	je     800c01 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c11:	80 f9 2b             	cmp    $0x2b,%cl
  800c14:	75 0a                	jne    800c20 <strtol+0x2d>
		s++;
  800c16:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800c19:	bf 00 00 00 00       	mov    $0x0,%edi
  800c1e:	eb 11                	jmp    800c31 <strtol+0x3e>
  800c20:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800c25:	80 f9 2d             	cmp    $0x2d,%cl
  800c28:	75 07                	jne    800c31 <strtol+0x3e>
		s++, neg = 1;
  800c2a:	8d 52 01             	lea    0x1(%edx),%edx
  800c2d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c31:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800c36:	75 15                	jne    800c4d <strtol+0x5a>
  800c38:	80 3a 30             	cmpb   $0x30,(%edx)
  800c3b:	75 10                	jne    800c4d <strtol+0x5a>
  800c3d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c41:	75 0a                	jne    800c4d <strtol+0x5a>
		s += 2, base = 16;
  800c43:	83 c2 02             	add    $0x2,%edx
  800c46:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4b:	eb 10                	jmp    800c5d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800c4d:	85 c0                	test   %eax,%eax
  800c4f:	75 0c                	jne    800c5d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c51:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c53:	80 3a 30             	cmpb   $0x30,(%edx)
  800c56:	75 05                	jne    800c5d <strtol+0x6a>
		s++, base = 8;
  800c58:	83 c2 01             	add    $0x1,%edx
  800c5b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800c5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c62:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c65:	0f b6 0a             	movzbl (%edx),%ecx
  800c68:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800c6b:	89 f0                	mov    %esi,%eax
  800c6d:	3c 09                	cmp    $0x9,%al
  800c6f:	77 08                	ja     800c79 <strtol+0x86>
			dig = *s - '0';
  800c71:	0f be c9             	movsbl %cl,%ecx
  800c74:	83 e9 30             	sub    $0x30,%ecx
  800c77:	eb 20                	jmp    800c99 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800c79:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800c7c:	89 f0                	mov    %esi,%eax
  800c7e:	3c 19                	cmp    $0x19,%al
  800c80:	77 08                	ja     800c8a <strtol+0x97>
			dig = *s - 'a' + 10;
  800c82:	0f be c9             	movsbl %cl,%ecx
  800c85:	83 e9 57             	sub    $0x57,%ecx
  800c88:	eb 0f                	jmp    800c99 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800c8a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800c8d:	89 f0                	mov    %esi,%eax
  800c8f:	3c 19                	cmp    $0x19,%al
  800c91:	77 16                	ja     800ca9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800c93:	0f be c9             	movsbl %cl,%ecx
  800c96:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c99:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800c9c:	7d 0f                	jge    800cad <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800ca5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800ca7:	eb bc                	jmp    800c65 <strtol+0x72>
  800ca9:	89 d8                	mov    %ebx,%eax
  800cab:	eb 02                	jmp    800caf <strtol+0xbc>
  800cad:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800caf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb3:	74 05                	je     800cba <strtol+0xc7>
		*endptr = (char *) s;
  800cb5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cb8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800cba:	f7 d8                	neg    %eax
  800cbc:	85 ff                	test   %edi,%edi
  800cbe:	0f 44 c3             	cmove  %ebx,%eax
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5e                   	pop    %esi
  800cc3:	5f                   	pop    %edi
  800cc4:	5d                   	pop    %ebp
  800cc5:	c3                   	ret    

00800cc6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	57                   	push   %edi
  800cca:	56                   	push   %esi
  800ccb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	89 c3                	mov    %eax,%ebx
  800cd9:	89 c7                	mov    %eax,%edi
  800cdb:	89 c6                	mov    %eax,%esi
  800cdd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cdf:	5b                   	pop    %ebx
  800ce0:	5e                   	pop    %esi
  800ce1:	5f                   	pop    %edi
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    

00800ce4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cea:	ba 00 00 00 00       	mov    $0x0,%edx
  800cef:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf4:	89 d1                	mov    %edx,%ecx
  800cf6:	89 d3                	mov    %edx,%ebx
  800cf8:	89 d7                	mov    %edx,%edi
  800cfa:	89 d6                	mov    %edx,%esi
  800cfc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cfe:	5b                   	pop    %ebx
  800cff:	5e                   	pop    %esi
  800d00:	5f                   	pop    %edi
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d0c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d11:	b8 03 00 00 00       	mov    $0x3,%eax
  800d16:	8b 55 08             	mov    0x8(%ebp),%edx
  800d19:	89 cb                	mov    %ecx,%ebx
  800d1b:	89 cf                	mov    %ecx,%edi
  800d1d:	89 ce                	mov    %ecx,%esi
  800d1f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d21:	85 c0                	test   %eax,%eax
  800d23:	7e 28                	jle    800d4d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d25:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d29:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800d30:	00 
  800d31:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800d38:	00 
  800d39:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d40:	00 
  800d41:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800d48:	e8 08 f5 ff ff       	call   800255 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d4d:	83 c4 2c             	add    $0x2c,%esp
  800d50:	5b                   	pop    %ebx
  800d51:	5e                   	pop    %esi
  800d52:	5f                   	pop    %edi
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	57                   	push   %edi
  800d59:	56                   	push   %esi
  800d5a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800d60:	b8 02 00 00 00       	mov    $0x2,%eax
  800d65:	89 d1                	mov    %edx,%ecx
  800d67:	89 d3                	mov    %edx,%ebx
  800d69:	89 d7                	mov    %edx,%edi
  800d6b:	89 d6                	mov    %edx,%esi
  800d6d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    

00800d74 <sys_yield>:

void
sys_yield(void)
{
  800d74:	55                   	push   %ebp
  800d75:	89 e5                	mov    %esp,%ebp
  800d77:	57                   	push   %edi
  800d78:	56                   	push   %esi
  800d79:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7a:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d84:	89 d1                	mov    %edx,%ecx
  800d86:	89 d3                	mov    %edx,%ebx
  800d88:	89 d7                	mov    %edx,%edi
  800d8a:	89 d6                	mov    %edx,%esi
  800d8c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9c:	be 00 00 00 00       	mov    $0x0,%esi
  800da1:	b8 04 00 00 00       	mov    $0x4,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800daf:	89 f7                	mov    %esi,%edi
  800db1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db3:	85 c0                	test   %eax,%eax
  800db5:	7e 28                	jle    800ddf <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dbb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800dc2:	00 
  800dc3:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800dca:	00 
  800dcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd2:	00 
  800dd3:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800dda:	e8 76 f4 ff ff       	call   800255 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ddf:	83 c4 2c             	add    $0x2c,%esp
  800de2:	5b                   	pop    %ebx
  800de3:	5e                   	pop    %esi
  800de4:	5f                   	pop    %edi
  800de5:	5d                   	pop    %ebp
  800de6:	c3                   	ret    

00800de7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800de7:	55                   	push   %ebp
  800de8:	89 e5                	mov    %esp,%ebp
  800dea:	57                   	push   %edi
  800deb:	56                   	push   %esi
  800dec:	53                   	push   %ebx
  800ded:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df0:	b8 05 00 00 00       	mov    $0x5,%eax
  800df5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df8:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dfe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e01:	8b 75 18             	mov    0x18(%ebp),%esi
  800e04:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	7e 28                	jle    800e32 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800e15:	00 
  800e16:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e25:	00 
  800e26:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800e2d:	e8 23 f4 ff ff       	call   800255 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e32:	83 c4 2c             	add    $0x2c,%esp
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5f                   	pop    %edi
  800e38:	5d                   	pop    %ebp
  800e39:	c3                   	ret    

00800e3a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
  800e40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e48:	b8 06 00 00 00       	mov    $0x6,%eax
  800e4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e50:	8b 55 08             	mov    0x8(%ebp),%edx
  800e53:	89 df                	mov    %ebx,%edi
  800e55:	89 de                	mov    %ebx,%esi
  800e57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e59:	85 c0                	test   %eax,%eax
  800e5b:	7e 28                	jle    800e85 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e61:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800e68:	00 
  800e69:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800e70:	00 
  800e71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e78:	00 
  800e79:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800e80:	e8 d0 f3 ff ff       	call   800255 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e85:	83 c4 2c             	add    $0x2c,%esp
  800e88:	5b                   	pop    %ebx
  800e89:	5e                   	pop    %esi
  800e8a:	5f                   	pop    %edi
  800e8b:	5d                   	pop    %ebp
  800e8c:	c3                   	ret    

00800e8d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e8d:	55                   	push   %ebp
  800e8e:	89 e5                	mov    %esp,%ebp
  800e90:	57                   	push   %edi
  800e91:	56                   	push   %esi
  800e92:	53                   	push   %ebx
  800e93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9b:	b8 08 00 00 00       	mov    $0x8,%eax
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea6:	89 df                	mov    %ebx,%edi
  800ea8:	89 de                	mov    %ebx,%esi
  800eaa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	7e 28                	jle    800ed8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ebb:	00 
  800ebc:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800ec3:	00 
  800ec4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecb:	00 
  800ecc:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800ed3:	e8 7d f3 ff ff       	call   800255 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ed8:	83 c4 2c             	add    $0x2c,%esp
  800edb:	5b                   	pop    %ebx
  800edc:	5e                   	pop    %esi
  800edd:	5f                   	pop    %edi
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7e 28                	jle    800f2b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f07:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800f16:	00 
  800f17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1e:	00 
  800f1f:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800f26:	e8 2a f3 ff ff       	call   800255 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f2b:	83 c4 2c             	add    $0x2c,%esp
  800f2e:	5b                   	pop    %ebx
  800f2f:	5e                   	pop    %esi
  800f30:	5f                   	pop    %edi
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	57                   	push   %edi
  800f37:	56                   	push   %esi
  800f38:	53                   	push   %ebx
  800f39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f41:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	89 df                	mov    %ebx,%edi
  800f4e:	89 de                	mov    %ebx,%esi
  800f50:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f52:	85 c0                	test   %eax,%eax
  800f54:	7e 28                	jle    800f7e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f56:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f61:	00 
  800f62:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800f69:	00 
  800f6a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f71:	00 
  800f72:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800f79:	e8 d7 f2 ff ff       	call   800255 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f7e:	83 c4 2c             	add    $0x2c,%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	57                   	push   %edi
  800f8a:	56                   	push   %esi
  800f8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8c:	be 00 00 00 00       	mov    $0x0,%esi
  800f91:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fa2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    

00800fa9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	57                   	push   %edi
  800fad:	56                   	push   %esi
  800fae:	53                   	push   %ebx
  800faf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fb7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbf:	89 cb                	mov    %ecx,%ebx
  800fc1:	89 cf                	mov    %ecx,%edi
  800fc3:	89 ce                	mov    %ecx,%esi
  800fc5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	7e 28                	jle    800ff3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fcb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fcf:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800fd6:	00 
  800fd7:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  800fde:	00 
  800fdf:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe6:	00 
  800fe7:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  800fee:	e8 62 f2 ff ff       	call   800255 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ff3:	83 c4 2c             	add    $0x2c,%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801001:	ba 00 00 00 00       	mov    $0x0,%edx
  801006:	b8 0e 00 00 00       	mov    $0xe,%eax
  80100b:	89 d1                	mov    %edx,%ecx
  80100d:	89 d3                	mov    %edx,%ebx
  80100f:	89 d7                	mov    %edx,%edi
  801011:	89 d6                	mov    %edx,%esi
  801013:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801015:	5b                   	pop    %ebx
  801016:	5e                   	pop    %esi
  801017:	5f                   	pop    %edi
  801018:	5d                   	pop    %ebp
  801019:	c3                   	ret    

0080101a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  80101a:	55                   	push   %ebp
  80101b:	89 e5                	mov    %esp,%ebp
  80101d:	57                   	push   %edi
  80101e:	56                   	push   %esi
  80101f:	53                   	push   %ebx
  801020:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801023:	bb 00 00 00 00       	mov    $0x0,%ebx
  801028:	b8 0f 00 00 00       	mov    $0xf,%eax
  80102d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801030:	8b 55 08             	mov    0x8(%ebp),%edx
  801033:	89 df                	mov    %ebx,%edi
  801035:	89 de                	mov    %ebx,%esi
  801037:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  801039:	85 c0                	test   %eax,%eax
  80103b:	7e 28                	jle    801065 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  80103d:	89 44 24 10          	mov    %eax,0x10(%esp)
  801041:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801048:	00 
  801049:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  801050:	00 
  801051:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801058:	00 
  801059:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  801060:	e8 f0 f1 ff ff       	call   800255 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  801065:	83 c4 2c             	add    $0x2c,%esp
  801068:	5b                   	pop    %ebx
  801069:	5e                   	pop    %esi
  80106a:	5f                   	pop    %edi
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	57                   	push   %edi
  801071:	56                   	push   %esi
  801072:	53                   	push   %ebx
  801073:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801076:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107b:	b8 10 00 00 00       	mov    $0x10,%eax
  801080:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801083:	8b 55 08             	mov    0x8(%ebp),%edx
  801086:	89 df                	mov    %ebx,%edi
  801088:	89 de                	mov    %ebx,%esi
  80108a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  80108c:	85 c0                	test   %eax,%eax
  80108e:	7e 28                	jle    8010b8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  801090:	89 44 24 10          	mov    %eax,0x10(%esp)
  801094:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  80109b:	00 
  80109c:	c7 44 24 08 3f 2f 80 	movl   $0x802f3f,0x8(%esp)
  8010a3:	00 
  8010a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ab:	00 
  8010ac:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8010b3:	e8 9d f1 ff ff       	call   800255 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  8010b8:	83 c4 2c             	add    $0x2c,%esp
  8010bb:	5b                   	pop    %ebx
  8010bc:	5e                   	pop    %esi
  8010bd:	5f                   	pop    %edi
  8010be:	5d                   	pop    %ebp
  8010bf:	c3                   	ret    

008010c0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 24             	sub    $0x24,%esp
  8010c7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  8010ca:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  8010cc:	89 d3                	mov    %edx,%ebx
  8010ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  8010d4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8010d8:	74 1a                	je     8010f4 <pgfault+0x34>
  8010da:	c1 ea 0c             	shr    $0xc,%edx
  8010dd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010e4:	a8 01                	test   $0x1,%al
  8010e6:	74 0c                	je     8010f4 <pgfault+0x34>
  8010e8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010ef:	f6 c4 08             	test   $0x8,%ah
  8010f2:	75 1c                	jne    801110 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  8010f4:	c7 44 24 08 6c 2f 80 	movl   $0x802f6c,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  80110b:	e8 45 f1 ff ff       	call   800255 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801110:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801117:	00 
  801118:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80111f:	00 
  801120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801127:	e8 67 fc ff ff       	call   800d93 <sys_page_alloc>
  80112c:	85 c0                	test   %eax,%eax
  80112e:	79 1c                	jns    80114c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801130:	c7 44 24 08 b0 2f 80 	movl   $0x802fb0,0x8(%esp)
  801137:	00 
  801138:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80113f:	00 
  801140:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  801147:	e8 09 f1 ff ff       	call   800255 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80114c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801153:	00 
  801154:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801158:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80115f:	e8 18 fa ff ff       	call   800b7c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801164:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80116b:	00 
  80116c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801170:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801177:	00 
  801178:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80117f:	00 
  801180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801187:	e8 5b fc ff ff       	call   800de7 <sys_page_map>
  80118c:	85 c0                	test   %eax,%eax
  80118e:	74 1c                	je     8011ac <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801190:	c7 44 24 08 c6 30 80 	movl   $0x8030c6,0x8(%esp)
  801197:	00 
  801198:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80119f:	00 
  8011a0:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  8011a7:	e8 a9 f0 ff ff       	call   800255 <_panic>
    sys_page_unmap(0,PFTEMP);
  8011ac:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8011b3:	00 
  8011b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011bb:	e8 7a fc ff ff       	call   800e3a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  8011c0:	83 c4 24             	add    $0x24,%esp
  8011c3:	5b                   	pop    %ebx
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
  8011cc:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  8011cf:	c7 04 24 c0 10 80 00 	movl   $0x8010c0,(%esp)
  8011d6:	e8 fb 14 00 00       	call   8026d6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8011db:	b8 07 00 00 00       	mov    $0x7,%eax
  8011e0:	cd 30                	int    $0x30
  8011e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8011e5:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  8011e7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ec:	85 c0                	test   %eax,%eax
  8011ee:	75 21                	jne    801211 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8011f0:	e8 60 fb ff ff       	call   800d55 <sys_getenvid>
  8011f5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8011fa:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8011fd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801202:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	e9 de 01 00 00       	jmp    8013ef <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801211:	89 d8                	mov    %ebx,%eax
  801213:	c1 e8 16             	shr    $0x16,%eax
  801216:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121d:	a8 01                	test   $0x1,%al
  80121f:	0f 84 58 01 00 00    	je     80137d <fork+0x1b7>
  801225:	89 de                	mov    %ebx,%esi
  801227:	c1 ee 0c             	shr    $0xc,%esi
  80122a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801231:	83 e0 05             	and    $0x5,%eax
  801234:	83 f8 05             	cmp    $0x5,%eax
  801237:	0f 85 40 01 00 00    	jne    80137d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80123d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801244:	f6 c4 04             	test   $0x4,%ah
  801247:	74 4f                	je     801298 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801249:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801250:	c1 e6 0c             	shl    $0xc,%esi
  801253:	25 07 0e 00 00       	and    $0xe07,%eax
  801258:	89 44 24 10          	mov    %eax,0x10(%esp)
  80125c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801260:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801264:	89 74 24 04          	mov    %esi,0x4(%esp)
  801268:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80126f:	e8 73 fb ff ff       	call   800de7 <sys_page_map>
  801274:	85 c0                	test   %eax,%eax
  801276:	0f 89 01 01 00 00    	jns    80137d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80127c:	c7 44 24 08 d0 2f 80 	movl   $0x802fd0,0x8(%esp)
  801283:	00 
  801284:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80128b:	00 
  80128c:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  801293:	e8 bd ef ff ff       	call   800255 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801298:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80129f:	a8 02                	test   $0x2,%al
  8012a1:	75 10                	jne    8012b3 <fork+0xed>
  8012a3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8012aa:	f6 c4 08             	test   $0x8,%ah
  8012ad:	0f 84 87 00 00 00    	je     80133a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  8012b3:	c1 e6 0c             	shl    $0xc,%esi
  8012b6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012bd:	00 
  8012be:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012c2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012c6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d1:	e8 11 fb ff ff       	call   800de7 <sys_page_map>
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	79 1c                	jns    8012f6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  8012da:	c7 44 24 08 08 30 80 	movl   $0x803008,0x8(%esp)
  8012e1:	00 
  8012e2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8012e9:	00 
  8012ea:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  8012f1:	e8 5f ef ff ff       	call   800255 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8012f6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012fd:	00 
  8012fe:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801302:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801309:	00 
  80130a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80130e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801315:	e8 cd fa ff ff       	call   800de7 <sys_page_map>
  80131a:	85 c0                	test   %eax,%eax
  80131c:	79 5f                	jns    80137d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80131e:	c7 44 24 08 40 30 80 	movl   $0x803040,0x8(%esp)
  801325:	00 
  801326:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80132d:	00 
  80132e:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  801335:	e8 1b ef ff ff       	call   800255 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80133a:	c1 e6 0c             	shl    $0xc,%esi
  80133d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801344:	00 
  801345:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801349:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80134d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801358:	e8 8a fa ff ff       	call   800de7 <sys_page_map>
  80135d:	85 c0                	test   %eax,%eax
  80135f:	74 1c                	je     80137d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801361:	c7 44 24 08 68 30 80 	movl   $0x803068,0x8(%esp)
  801368:	00 
  801369:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801370:	00 
  801371:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  801378:	e8 d8 ee ff ff       	call   800255 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80137d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801383:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801389:	0f 85 82 fe ff ff    	jne    801211 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80138f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801396:	00 
  801397:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80139e:	ee 
  80139f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	e8 e9 f9 ff ff       	call   800d93 <sys_page_alloc>
  8013aa:	85 c0                	test   %eax,%eax
  8013ac:	79 1c                	jns    8013ca <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8013ae:	c7 44 24 08 9c 30 80 	movl   $0x80309c,0x8(%esp)
  8013b5:	00 
  8013b6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  8013bd:	00 
  8013be:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  8013c5:	e8 8b ee ff ff       	call   800255 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  8013ca:	c7 44 24 04 47 27 80 	movl   $0x802747,0x4(%esp)
  8013d1:	00 
  8013d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013d5:	89 3c 24             	mov    %edi,(%esp)
  8013d8:	e8 56 fb ff ff       	call   800f33 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  8013dd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8013e4:	00 
  8013e5:	89 3c 24             	mov    %edi,(%esp)
  8013e8:	e8 a0 fa ff ff       	call   800e8d <sys_env_set_status>
		return child;
  8013ed:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  8013ef:	83 c4 2c             	add    $0x2c,%esp
  8013f2:	5b                   	pop    %ebx
  8013f3:	5e                   	pop    %esi
  8013f4:	5f                   	pop    %edi
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <sfork>:

// Challenge!
int
sfork(void)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013fd:	c7 44 24 08 e4 30 80 	movl   $0x8030e4,0x8(%esp)
  801404:	00 
  801405:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80140c:	00 
  80140d:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  801414:	e8 3c ee ff ff       	call   800255 <_panic>
  801419:	66 90                	xchg   %ax,%ax
  80141b:	66 90                	xchg   %ax,%ax
  80141d:	66 90                	xchg   %ax,%ax
  80141f:	90                   	nop

00801420 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	05 00 00 00 30       	add    $0x30000000,%eax
  80142b:	c1 e8 0c             	shr    $0xc,%eax
}
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    

00801430 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80143b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801440:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801445:	5d                   	pop    %ebp
  801446:	c3                   	ret    

00801447 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801447:	55                   	push   %ebp
  801448:	89 e5                	mov    %esp,%ebp
  80144a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80144d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801452:	89 c2                	mov    %eax,%edx
  801454:	c1 ea 16             	shr    $0x16,%edx
  801457:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80145e:	f6 c2 01             	test   $0x1,%dl
  801461:	74 11                	je     801474 <fd_alloc+0x2d>
  801463:	89 c2                	mov    %eax,%edx
  801465:	c1 ea 0c             	shr    $0xc,%edx
  801468:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80146f:	f6 c2 01             	test   $0x1,%dl
  801472:	75 09                	jne    80147d <fd_alloc+0x36>
			*fd_store = fd;
  801474:	89 01                	mov    %eax,(%ecx)
			return 0;
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 17                	jmp    801494 <fd_alloc+0x4d>
  80147d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801482:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801487:	75 c9                	jne    801452 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801489:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80148f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801494:	5d                   	pop    %ebp
  801495:	c3                   	ret    

00801496 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80149c:	83 f8 1f             	cmp    $0x1f,%eax
  80149f:	77 36                	ja     8014d7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014a1:	c1 e0 0c             	shl    $0xc,%eax
  8014a4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8014a9:	89 c2                	mov    %eax,%edx
  8014ab:	c1 ea 16             	shr    $0x16,%edx
  8014ae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014b5:	f6 c2 01             	test   $0x1,%dl
  8014b8:	74 24                	je     8014de <fd_lookup+0x48>
  8014ba:	89 c2                	mov    %eax,%edx
  8014bc:	c1 ea 0c             	shr    $0xc,%edx
  8014bf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014c6:	f6 c2 01             	test   $0x1,%dl
  8014c9:	74 1a                	je     8014e5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ce:	89 02                	mov    %eax,(%edx)
	return 0;
  8014d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014d5:	eb 13                	jmp    8014ea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014d7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014dc:	eb 0c                	jmp    8014ea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8014de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e3:	eb 05                	jmp    8014ea <fd_lookup+0x54>
  8014e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014ea:	5d                   	pop    %ebp
  8014eb:	c3                   	ret    

008014ec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ec:	55                   	push   %ebp
  8014ed:	89 e5                	mov    %esp,%ebp
  8014ef:	83 ec 18             	sub    $0x18,%esp
  8014f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8014f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fa:	eb 13                	jmp    80150f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8014fc:	39 08                	cmp    %ecx,(%eax)
  8014fe:	75 0c                	jne    80150c <dev_lookup+0x20>
			*dev = devtab[i];
  801500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801503:	89 01                	mov    %eax,(%ecx)
			return 0;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
  80150a:	eb 38                	jmp    801544 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80150c:	83 c2 01             	add    $0x1,%edx
  80150f:	8b 04 95 78 31 80 00 	mov    0x803178(,%edx,4),%eax
  801516:	85 c0                	test   %eax,%eax
  801518:	75 e2                	jne    8014fc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80151a:	a1 08 50 80 00       	mov    0x805008,%eax
  80151f:	8b 40 48             	mov    0x48(%eax),%eax
  801522:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152a:	c7 04 24 fc 30 80 00 	movl   $0x8030fc,(%esp)
  801531:	e8 18 ee ff ff       	call   80034e <cprintf>
	*dev = 0;
  801536:	8b 45 0c             	mov    0xc(%ebp),%eax
  801539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80153f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801544:	c9                   	leave  
  801545:	c3                   	ret    

00801546 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	56                   	push   %esi
  80154a:	53                   	push   %ebx
  80154b:	83 ec 20             	sub    $0x20,%esp
  80154e:	8b 75 08             	mov    0x8(%ebp),%esi
  801551:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801554:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801557:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80155b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801561:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 2a ff ff ff       	call   801496 <fd_lookup>
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 05                	js     801575 <fd_close+0x2f>
	    || fd != fd2)
  801570:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801573:	74 0c                	je     801581 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801575:	84 db                	test   %bl,%bl
  801577:	ba 00 00 00 00       	mov    $0x0,%edx
  80157c:	0f 44 c2             	cmove  %edx,%eax
  80157f:	eb 3f                	jmp    8015c0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801581:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801584:	89 44 24 04          	mov    %eax,0x4(%esp)
  801588:	8b 06                	mov    (%esi),%eax
  80158a:	89 04 24             	mov    %eax,(%esp)
  80158d:	e8 5a ff ff ff       	call   8014ec <dev_lookup>
  801592:	89 c3                	mov    %eax,%ebx
  801594:	85 c0                	test   %eax,%eax
  801596:	78 16                	js     8015ae <fd_close+0x68>
		if (dev->dev_close)
  801598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80159e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	74 07                	je     8015ae <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8015a7:	89 34 24             	mov    %esi,(%esp)
  8015aa:	ff d0                	call   *%eax
  8015ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8015ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015b9:	e8 7c f8 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  8015be:	89 d8                	mov    %ebx,%eax
}
  8015c0:	83 c4 20             	add    $0x20,%esp
  8015c3:	5b                   	pop    %ebx
  8015c4:	5e                   	pop    %esi
  8015c5:	5d                   	pop    %ebp
  8015c6:	c3                   	ret    

008015c7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d7:	89 04 24             	mov    %eax,(%esp)
  8015da:	e8 b7 fe ff ff       	call   801496 <fd_lookup>
  8015df:	89 c2                	mov    %eax,%edx
  8015e1:	85 d2                	test   %edx,%edx
  8015e3:	78 13                	js     8015f8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015ec:	00 
  8015ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f0:	89 04 24             	mov    %eax,(%esp)
  8015f3:	e8 4e ff ff ff       	call   801546 <fd_close>
}
  8015f8:	c9                   	leave  
  8015f9:	c3                   	ret    

008015fa <close_all>:

void
close_all(void)
{
  8015fa:	55                   	push   %ebp
  8015fb:	89 e5                	mov    %esp,%ebp
  8015fd:	53                   	push   %ebx
  8015fe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801601:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801606:	89 1c 24             	mov    %ebx,(%esp)
  801609:	e8 b9 ff ff ff       	call   8015c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80160e:	83 c3 01             	add    $0x1,%ebx
  801611:	83 fb 20             	cmp    $0x20,%ebx
  801614:	75 f0                	jne    801606 <close_all+0xc>
		close(i);
}
  801616:	83 c4 14             	add    $0x14,%esp
  801619:	5b                   	pop    %ebx
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    

0080161c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80161c:	55                   	push   %ebp
  80161d:	89 e5                	mov    %esp,%ebp
  80161f:	57                   	push   %edi
  801620:	56                   	push   %esi
  801621:	53                   	push   %ebx
  801622:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801625:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801628:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162c:	8b 45 08             	mov    0x8(%ebp),%eax
  80162f:	89 04 24             	mov    %eax,(%esp)
  801632:	e8 5f fe ff ff       	call   801496 <fd_lookup>
  801637:	89 c2                	mov    %eax,%edx
  801639:	85 d2                	test   %edx,%edx
  80163b:	0f 88 e1 00 00 00    	js     801722 <dup+0x106>
		return r;
	close(newfdnum);
  801641:	8b 45 0c             	mov    0xc(%ebp),%eax
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	e8 7b ff ff ff       	call   8015c7 <close>

	newfd = INDEX2FD(newfdnum);
  80164c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80164f:	c1 e3 0c             	shl    $0xc,%ebx
  801652:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801658:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80165b:	89 04 24             	mov    %eax,(%esp)
  80165e:	e8 cd fd ff ff       	call   801430 <fd2data>
  801663:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801665:	89 1c 24             	mov    %ebx,(%esp)
  801668:	e8 c3 fd ff ff       	call   801430 <fd2data>
  80166d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80166f:	89 f0                	mov    %esi,%eax
  801671:	c1 e8 16             	shr    $0x16,%eax
  801674:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80167b:	a8 01                	test   $0x1,%al
  80167d:	74 43                	je     8016c2 <dup+0xa6>
  80167f:	89 f0                	mov    %esi,%eax
  801681:	c1 e8 0c             	shr    $0xc,%eax
  801684:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80168b:	f6 c2 01             	test   $0x1,%dl
  80168e:	74 32                	je     8016c2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801690:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801697:	25 07 0e 00 00       	and    $0xe07,%eax
  80169c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016a0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ab:	00 
  8016ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b7:	e8 2b f7 ff ff       	call   800de7 <sys_page_map>
  8016bc:	89 c6                	mov    %eax,%esi
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 3e                	js     801700 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016c5:	89 c2                	mov    %eax,%edx
  8016c7:	c1 ea 0c             	shr    $0xc,%edx
  8016ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016d1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8016d7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016e6:	00 
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f2:	e8 f0 f6 ff ff       	call   800de7 <sys_page_map>
  8016f7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016fc:	85 f6                	test   %esi,%esi
  8016fe:	79 22                	jns    801722 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801700:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801704:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170b:	e8 2a f7 ff ff       	call   800e3a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801710:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801714:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171b:	e8 1a f7 ff ff       	call   800e3a <sys_page_unmap>
	return r;
  801720:	89 f0                	mov    %esi,%eax
}
  801722:	83 c4 3c             	add    $0x3c,%esp
  801725:	5b                   	pop    %ebx
  801726:	5e                   	pop    %esi
  801727:	5f                   	pop    %edi
  801728:	5d                   	pop    %ebp
  801729:	c3                   	ret    

0080172a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80172a:	55                   	push   %ebp
  80172b:	89 e5                	mov    %esp,%ebp
  80172d:	53                   	push   %ebx
  80172e:	83 ec 24             	sub    $0x24,%esp
  801731:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801734:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801737:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173b:	89 1c 24             	mov    %ebx,(%esp)
  80173e:	e8 53 fd ff ff       	call   801496 <fd_lookup>
  801743:	89 c2                	mov    %eax,%edx
  801745:	85 d2                	test   %edx,%edx
  801747:	78 6d                	js     8017b6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801749:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801753:	8b 00                	mov    (%eax),%eax
  801755:	89 04 24             	mov    %eax,(%esp)
  801758:	e8 8f fd ff ff       	call   8014ec <dev_lookup>
  80175d:	85 c0                	test   %eax,%eax
  80175f:	78 55                	js     8017b6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801764:	8b 50 08             	mov    0x8(%eax),%edx
  801767:	83 e2 03             	and    $0x3,%edx
  80176a:	83 fa 01             	cmp    $0x1,%edx
  80176d:	75 23                	jne    801792 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80176f:	a1 08 50 80 00       	mov    0x805008,%eax
  801774:	8b 40 48             	mov    0x48(%eax),%eax
  801777:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177f:	c7 04 24 3d 31 80 00 	movl   $0x80313d,(%esp)
  801786:	e8 c3 eb ff ff       	call   80034e <cprintf>
		return -E_INVAL;
  80178b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801790:	eb 24                	jmp    8017b6 <read+0x8c>
	}
	if (!dev->dev_read)
  801792:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801795:	8b 52 08             	mov    0x8(%edx),%edx
  801798:	85 d2                	test   %edx,%edx
  80179a:	74 15                	je     8017b1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80179c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80179f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017aa:	89 04 24             	mov    %eax,(%esp)
  8017ad:	ff d2                	call   *%edx
  8017af:	eb 05                	jmp    8017b6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8017b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8017b6:	83 c4 24             	add    $0x24,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d0:	eb 23                	jmp    8017f5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017d2:	89 f0                	mov    %esi,%eax
  8017d4:	29 d8                	sub    %ebx,%eax
  8017d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017da:	89 d8                	mov    %ebx,%eax
  8017dc:	03 45 0c             	add    0xc(%ebp),%eax
  8017df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e3:	89 3c 24             	mov    %edi,(%esp)
  8017e6:	e8 3f ff ff ff       	call   80172a <read>
		if (m < 0)
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	78 10                	js     8017ff <readn+0x43>
			return m;
		if (m == 0)
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	74 0a                	je     8017fd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017f3:	01 c3                	add    %eax,%ebx
  8017f5:	39 f3                	cmp    %esi,%ebx
  8017f7:	72 d9                	jb     8017d2 <readn+0x16>
  8017f9:	89 d8                	mov    %ebx,%eax
  8017fb:	eb 02                	jmp    8017ff <readn+0x43>
  8017fd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017ff:	83 c4 1c             	add    $0x1c,%esp
  801802:	5b                   	pop    %ebx
  801803:	5e                   	pop    %esi
  801804:	5f                   	pop    %edi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    

00801807 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801807:	55                   	push   %ebp
  801808:	89 e5                	mov    %esp,%ebp
  80180a:	53                   	push   %ebx
  80180b:	83 ec 24             	sub    $0x24,%esp
  80180e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801811:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801814:	89 44 24 04          	mov    %eax,0x4(%esp)
  801818:	89 1c 24             	mov    %ebx,(%esp)
  80181b:	e8 76 fc ff ff       	call   801496 <fd_lookup>
  801820:	89 c2                	mov    %eax,%edx
  801822:	85 d2                	test   %edx,%edx
  801824:	78 68                	js     80188e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801826:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801829:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801830:	8b 00                	mov    (%eax),%eax
  801832:	89 04 24             	mov    %eax,(%esp)
  801835:	e8 b2 fc ff ff       	call   8014ec <dev_lookup>
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 50                	js     80188e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80183e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801841:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801845:	75 23                	jne    80186a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801847:	a1 08 50 80 00       	mov    0x805008,%eax
  80184c:	8b 40 48             	mov    0x48(%eax),%eax
  80184f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801853:	89 44 24 04          	mov    %eax,0x4(%esp)
  801857:	c7 04 24 59 31 80 00 	movl   $0x803159,(%esp)
  80185e:	e8 eb ea ff ff       	call   80034e <cprintf>
		return -E_INVAL;
  801863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801868:	eb 24                	jmp    80188e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80186a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80186d:	8b 52 0c             	mov    0xc(%edx),%edx
  801870:	85 d2                	test   %edx,%edx
  801872:	74 15                	je     801889 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801874:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801877:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80187b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801882:	89 04 24             	mov    %eax,(%esp)
  801885:	ff d2                	call   *%edx
  801887:	eb 05                	jmp    80188e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801889:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80188e:	83 c4 24             	add    $0x24,%esp
  801891:	5b                   	pop    %ebx
  801892:	5d                   	pop    %ebp
  801893:	c3                   	ret    

00801894 <seek>:

int
seek(int fdnum, off_t offset)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
  801897:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80189d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	89 04 24             	mov    %eax,(%esp)
  8018a7:	e8 ea fb ff ff       	call   801496 <fd_lookup>
  8018ac:	85 c0                	test   %eax,%eax
  8018ae:	78 0e                	js     8018be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8018b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 24             	sub    $0x24,%esp
  8018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d1:	89 1c 24             	mov    %ebx,(%esp)
  8018d4:	e8 bd fb ff ff       	call   801496 <fd_lookup>
  8018d9:	89 c2                	mov    %eax,%edx
  8018db:	85 d2                	test   %edx,%edx
  8018dd:	78 61                	js     801940 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e9:	8b 00                	mov    (%eax),%eax
  8018eb:	89 04 24             	mov    %eax,(%esp)
  8018ee:	e8 f9 fb ff ff       	call   8014ec <dev_lookup>
  8018f3:	85 c0                	test   %eax,%eax
  8018f5:	78 49                	js     801940 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fe:	75 23                	jne    801923 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801900:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801905:	8b 40 48             	mov    0x48(%eax),%eax
  801908:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80190c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801910:	c7 04 24 1c 31 80 00 	movl   $0x80311c,(%esp)
  801917:	e8 32 ea ff ff       	call   80034e <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80191c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801921:	eb 1d                	jmp    801940 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801923:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801926:	8b 52 18             	mov    0x18(%edx),%edx
  801929:	85 d2                	test   %edx,%edx
  80192b:	74 0e                	je     80193b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80192d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801930:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801934:	89 04 24             	mov    %eax,(%esp)
  801937:	ff d2                	call   *%edx
  801939:	eb 05                	jmp    801940 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80193b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801940:	83 c4 24             	add    $0x24,%esp
  801943:	5b                   	pop    %ebx
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	53                   	push   %ebx
  80194a:	83 ec 24             	sub    $0x24,%esp
  80194d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801950:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	89 04 24             	mov    %eax,(%esp)
  80195d:	e8 34 fb ff ff       	call   801496 <fd_lookup>
  801962:	89 c2                	mov    %eax,%edx
  801964:	85 d2                	test   %edx,%edx
  801966:	78 52                	js     8019ba <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801968:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80196b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801972:	8b 00                	mov    (%eax),%eax
  801974:	89 04 24             	mov    %eax,(%esp)
  801977:	e8 70 fb ff ff       	call   8014ec <dev_lookup>
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 3a                	js     8019ba <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801983:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801987:	74 2c                	je     8019b5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801989:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80198c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801993:	00 00 00 
	stat->st_isdir = 0;
  801996:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80199d:	00 00 00 
	stat->st_dev = dev;
  8019a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ad:	89 14 24             	mov    %edx,(%esp)
  8019b0:	ff 50 14             	call   *0x14(%eax)
  8019b3:	eb 05                	jmp    8019ba <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8019b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8019ba:	83 c4 24             	add    $0x24,%esp
  8019bd:	5b                   	pop    %ebx
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	56                   	push   %esi
  8019c4:	53                   	push   %ebx
  8019c5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8019c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019cf:	00 
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	89 04 24             	mov    %eax,(%esp)
  8019d6:	e8 28 02 00 00       	call   801c03 <open>
  8019db:	89 c3                	mov    %eax,%ebx
  8019dd:	85 db                	test   %ebx,%ebx
  8019df:	78 1b                	js     8019fc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e8:	89 1c 24             	mov    %ebx,(%esp)
  8019eb:	e8 56 ff ff ff       	call   801946 <fstat>
  8019f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019f2:	89 1c 24             	mov    %ebx,(%esp)
  8019f5:	e8 cd fb ff ff       	call   8015c7 <close>
	return r;
  8019fa:	89 f0                	mov    %esi,%eax
}
  8019fc:	83 c4 10             	add    $0x10,%esp
  8019ff:	5b                   	pop    %ebx
  801a00:	5e                   	pop    %esi
  801a01:	5d                   	pop    %ebp
  801a02:	c3                   	ret    

00801a03 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	83 ec 10             	sub    $0x10,%esp
  801a0b:	89 c6                	mov    %eax,%esi
  801a0d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a0f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a16:	75 11                	jne    801a29 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a1f:	e8 12 0e 00 00       	call   802836 <ipc_find_env>
  801a24:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a29:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a30:	00 
  801a31:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a38:	00 
  801a39:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a3d:	a1 00 50 80 00       	mov    0x805000,%eax
  801a42:	89 04 24             	mov    %eax,(%esp)
  801a45:	e8 8e 0d 00 00       	call   8027d8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a51:	00 
  801a52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5d:	e8 0c 0d 00 00       	call   80276e <ipc_recv>
}
  801a62:	83 c4 10             	add    $0x10,%esp
  801a65:	5b                   	pop    %ebx
  801a66:	5e                   	pop    %esi
  801a67:	5d                   	pop    %ebp
  801a68:	c3                   	ret    

00801a69 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
  801a6c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	8b 40 0c             	mov    0xc(%eax),%eax
  801a75:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a7d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a82:	ba 00 00 00 00       	mov    $0x0,%edx
  801a87:	b8 02 00 00 00       	mov    $0x2,%eax
  801a8c:	e8 72 ff ff ff       	call   801a03 <fsipc>
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a99:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a9f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801aa4:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa9:	b8 06 00 00 00       	mov    $0x6,%eax
  801aae:	e8 50 ff ff ff       	call   801a03 <fsipc>
}
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	53                   	push   %ebx
  801ab9:	83 ec 14             	sub    $0x14,%esp
  801abc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aca:	ba 00 00 00 00       	mov    $0x0,%edx
  801acf:	b8 05 00 00 00       	mov    $0x5,%eax
  801ad4:	e8 2a ff ff ff       	call   801a03 <fsipc>
  801ad9:	89 c2                	mov    %eax,%edx
  801adb:	85 d2                	test   %edx,%edx
  801add:	78 2b                	js     801b0a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801adf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801ae6:	00 
  801ae7:	89 1c 24             	mov    %ebx,(%esp)
  801aea:	e8 88 ee ff ff       	call   800977 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aef:	a1 80 60 80 00       	mov    0x806080,%eax
  801af4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801afa:	a1 84 60 80 00       	mov    0x806084,%eax
  801aff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b0a:	83 c4 14             	add    $0x14,%esp
  801b0d:	5b                   	pop    %ebx
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    

00801b10 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 18             	sub    $0x18,%esp
  801b16:	8b 45 10             	mov    0x10(%ebp),%eax
  801b19:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b1e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b23:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801b26:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b2e:	8b 52 0c             	mov    0xc(%edx),%edx
  801b31:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801b37:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b42:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b49:	e8 c6 ef ff ff       	call   800b14 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801b4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b53:	b8 04 00 00 00       	mov    $0x4,%eax
  801b58:	e8 a6 fe ff ff       	call   801a03 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
  801b62:	56                   	push   %esi
  801b63:	53                   	push   %ebx
  801b64:	83 ec 10             	sub    $0x10,%esp
  801b67:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b70:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b75:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b80:	b8 03 00 00 00       	mov    $0x3,%eax
  801b85:	e8 79 fe ff ff       	call   801a03 <fsipc>
  801b8a:	89 c3                	mov    %eax,%ebx
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 6a                	js     801bfa <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b90:	39 c6                	cmp    %eax,%esi
  801b92:	73 24                	jae    801bb8 <devfile_read+0x59>
  801b94:	c7 44 24 0c 8c 31 80 	movl   $0x80318c,0xc(%esp)
  801b9b:	00 
  801b9c:	c7 44 24 08 93 31 80 	movl   $0x803193,0x8(%esp)
  801ba3:	00 
  801ba4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801bab:	00 
  801bac:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  801bb3:	e8 9d e6 ff ff       	call   800255 <_panic>
	assert(r <= PGSIZE);
  801bb8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bbd:	7e 24                	jle    801be3 <devfile_read+0x84>
  801bbf:	c7 44 24 0c b3 31 80 	movl   $0x8031b3,0xc(%esp)
  801bc6:	00 
  801bc7:	c7 44 24 08 93 31 80 	movl   $0x803193,0x8(%esp)
  801bce:	00 
  801bcf:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801bd6:	00 
  801bd7:	c7 04 24 a8 31 80 00 	movl   $0x8031a8,(%esp)
  801bde:	e8 72 e6 ff ff       	call   800255 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801be3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801be7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bee:	00 
  801bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf2:	89 04 24             	mov    %eax,(%esp)
  801bf5:	e8 1a ef ff ff       	call   800b14 <memmove>
	return r;
}
  801bfa:	89 d8                	mov    %ebx,%eax
  801bfc:	83 c4 10             	add    $0x10,%esp
  801bff:	5b                   	pop    %ebx
  801c00:	5e                   	pop    %esi
  801c01:	5d                   	pop    %ebp
  801c02:	c3                   	ret    

00801c03 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
  801c06:	53                   	push   %ebx
  801c07:	83 ec 24             	sub    $0x24,%esp
  801c0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c0d:	89 1c 24             	mov    %ebx,(%esp)
  801c10:	e8 2b ed ff ff       	call   800940 <strlen>
  801c15:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c1a:	7f 60                	jg     801c7c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c1f:	89 04 24             	mov    %eax,(%esp)
  801c22:	e8 20 f8 ff ff       	call   801447 <fd_alloc>
  801c27:	89 c2                	mov    %eax,%edx
  801c29:	85 d2                	test   %edx,%edx
  801c2b:	78 54                	js     801c81 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c2d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c31:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c38:	e8 3a ed ff ff       	call   800977 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c40:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c48:	b8 01 00 00 00       	mov    $0x1,%eax
  801c4d:	e8 b1 fd ff ff       	call   801a03 <fsipc>
  801c52:	89 c3                	mov    %eax,%ebx
  801c54:	85 c0                	test   %eax,%eax
  801c56:	79 17                	jns    801c6f <open+0x6c>
		fd_close(fd, 0);
  801c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c5f:	00 
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	89 04 24             	mov    %eax,(%esp)
  801c66:	e8 db f8 ff ff       	call   801546 <fd_close>
		return r;
  801c6b:	89 d8                	mov    %ebx,%eax
  801c6d:	eb 12                	jmp    801c81 <open+0x7e>
	}

	return fd2num(fd);
  801c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c72:	89 04 24             	mov    %eax,(%esp)
  801c75:	e8 a6 f7 ff ff       	call   801420 <fd2num>
  801c7a:	eb 05                	jmp    801c81 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c7c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c81:	83 c4 24             	add    $0x24,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c8d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c92:	b8 08 00 00 00       	mov    $0x8,%eax
  801c97:	e8 67 fd ff ff       	call   801a03 <fsipc>
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    
  801c9e:	66 90                	xchg   %ax,%ax

00801ca0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ca6:	c7 44 24 04 bf 31 80 	movl   $0x8031bf,0x4(%esp)
  801cad:	00 
  801cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb1:	89 04 24             	mov    %eax,(%esp)
  801cb4:	e8 be ec ff ff       	call   800977 <strcpy>
	return 0;
}
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 14             	sub    $0x14,%esp
  801cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801cca:	89 1c 24             	mov    %ebx,(%esp)
  801ccd:	e8 9c 0b 00 00       	call   80286e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801cd2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801cd7:	83 f8 01             	cmp    $0x1,%eax
  801cda:	75 0d                	jne    801ce9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801cdc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801cdf:	89 04 24             	mov    %eax,(%esp)
  801ce2:	e8 29 03 00 00       	call   802010 <nsipc_close>
  801ce7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	83 c4 14             	add    $0x14,%esp
  801cee:	5b                   	pop    %ebx
  801cef:	5d                   	pop    %ebp
  801cf0:	c3                   	ret    

00801cf1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cf1:	55                   	push   %ebp
  801cf2:	89 e5                	mov    %esp,%ebp
  801cf4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cf7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cfe:	00 
  801cff:	8b 45 10             	mov    0x10(%ebp),%eax
  801d02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d10:	8b 40 0c             	mov    0xc(%eax),%eax
  801d13:	89 04 24             	mov    %eax,(%esp)
  801d16:	e8 f0 03 00 00       	call   80210b <nsipc_send>
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d23:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d2a:	00 
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d32:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d39:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 44 03 00 00       	call   80208b <nsipc_recv>
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d4f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d52:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 38 f7 ff ff       	call   801496 <fd_lookup>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 17                	js     801d79 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d65:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d6b:	39 08                	cmp    %ecx,(%eax)
  801d6d:	75 05                	jne    801d74 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d72:	eb 05                	jmp    801d79 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	56                   	push   %esi
  801d7f:	53                   	push   %ebx
  801d80:	83 ec 20             	sub    $0x20,%esp
  801d83:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d88:	89 04 24             	mov    %eax,(%esp)
  801d8b:	e8 b7 f6 ff ff       	call   801447 <fd_alloc>
  801d90:	89 c3                	mov    %eax,%ebx
  801d92:	85 c0                	test   %eax,%eax
  801d94:	78 21                	js     801db7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d96:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d9d:	00 
  801d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dac:	e8 e2 ef ff ff       	call   800d93 <sys_page_alloc>
  801db1:	89 c3                	mov    %eax,%ebx
  801db3:	85 c0                	test   %eax,%eax
  801db5:	79 0c                	jns    801dc3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801db7:	89 34 24             	mov    %esi,(%esp)
  801dba:	e8 51 02 00 00       	call   802010 <nsipc_close>
		return r;
  801dbf:	89 d8                	mov    %ebx,%eax
  801dc1:	eb 20                	jmp    801de3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801dc3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dcc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dd1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801dd8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801ddb:	89 14 24             	mov    %edx,(%esp)
  801dde:	e8 3d f6 ff ff       	call   801420 <fd2num>
}
  801de3:	83 c4 20             	add    $0x20,%esp
  801de6:	5b                   	pop    %ebx
  801de7:	5e                   	pop    %esi
  801de8:	5d                   	pop    %ebp
  801de9:	c3                   	ret    

00801dea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	e8 51 ff ff ff       	call   801d49 <fd2sockid>
		return r;
  801df8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	78 23                	js     801e21 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dfe:	8b 55 10             	mov    0x10(%ebp),%edx
  801e01:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e08:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e0c:	89 04 24             	mov    %eax,(%esp)
  801e0f:	e8 45 01 00 00       	call   801f59 <nsipc_accept>
		return r;
  801e14:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e16:	85 c0                	test   %eax,%eax
  801e18:	78 07                	js     801e21 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e1a:	e8 5c ff ff ff       	call   801d7b <alloc_sockfd>
  801e1f:	89 c1                	mov    %eax,%ecx
}
  801e21:	89 c8                	mov    %ecx,%eax
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
  801e28:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	e8 16 ff ff ff       	call   801d49 <fd2sockid>
  801e33:	89 c2                	mov    %eax,%edx
  801e35:	85 d2                	test   %edx,%edx
  801e37:	78 16                	js     801e4f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e39:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	89 14 24             	mov    %edx,(%esp)
  801e4a:	e8 60 01 00 00       	call   801faf <nsipc_bind>
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <shutdown>:

int
shutdown(int s, int how)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e57:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5a:	e8 ea fe ff ff       	call   801d49 <fd2sockid>
  801e5f:	89 c2                	mov    %eax,%edx
  801e61:	85 d2                	test   %edx,%edx
  801e63:	78 0f                	js     801e74 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e65:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6c:	89 14 24             	mov    %edx,(%esp)
  801e6f:	e8 7a 01 00 00       	call   801fee <nsipc_shutdown>
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	e8 c5 fe ff ff       	call   801d49 <fd2sockid>
  801e84:	89 c2                	mov    %eax,%edx
  801e86:	85 d2                	test   %edx,%edx
  801e88:	78 16                	js     801ea0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e98:	89 14 24             	mov    %edx,(%esp)
  801e9b:	e8 8a 01 00 00       	call   80202a <nsipc_connect>
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <listen>:

int
listen(int s, int backlog)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
  801ea5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  801eab:	e8 99 fe ff ff       	call   801d49 <fd2sockid>
  801eb0:	89 c2                	mov    %eax,%edx
  801eb2:	85 d2                	test   %edx,%edx
  801eb4:	78 0f                	js     801ec5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebd:	89 14 24             	mov    %edx,(%esp)
  801ec0:	e8 a4 01 00 00       	call   802069 <nsipc_listen>
}
  801ec5:	c9                   	leave  
  801ec6:	c3                   	ret    

00801ec7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ec7:	55                   	push   %ebp
  801ec8:	89 e5                	mov    %esp,%ebp
  801eca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	89 04 24             	mov    %eax,(%esp)
  801ee1:	e8 98 02 00 00       	call   80217e <nsipc_socket>
  801ee6:	89 c2                	mov    %eax,%edx
  801ee8:	85 d2                	test   %edx,%edx
  801eea:	78 05                	js     801ef1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801eec:	e8 8a fe ff ff       	call   801d7b <alloc_sockfd>
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	53                   	push   %ebx
  801ef7:	83 ec 14             	sub    $0x14,%esp
  801efa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801efc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f03:	75 11                	jne    801f16 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f0c:	e8 25 09 00 00       	call   802836 <ipc_find_env>
  801f11:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f16:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f1d:	00 
  801f1e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f25:	00 
  801f26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f2a:	a1 04 50 80 00       	mov    0x805004,%eax
  801f2f:	89 04 24             	mov    %eax,(%esp)
  801f32:	e8 a1 08 00 00       	call   8027d8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f3e:	00 
  801f3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f46:	00 
  801f47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4e:	e8 1b 08 00 00       	call   80276e <ipc_recv>
}
  801f53:	83 c4 14             	add    $0x14,%esp
  801f56:	5b                   	pop    %ebx
  801f57:	5d                   	pop    %ebp
  801f58:	c3                   	ret    

00801f59 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f59:	55                   	push   %ebp
  801f5a:	89 e5                	mov    %esp,%ebp
  801f5c:	56                   	push   %esi
  801f5d:	53                   	push   %ebx
  801f5e:	83 ec 10             	sub    $0x10,%esp
  801f61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f64:	8b 45 08             	mov    0x8(%ebp),%eax
  801f67:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f6c:	8b 06                	mov    (%esi),%eax
  801f6e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f73:	b8 01 00 00 00       	mov    $0x1,%eax
  801f78:	e8 76 ff ff ff       	call   801ef3 <nsipc>
  801f7d:	89 c3                	mov    %eax,%ebx
  801f7f:	85 c0                	test   %eax,%eax
  801f81:	78 23                	js     801fa6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f83:	a1 10 70 80 00       	mov    0x807010,%eax
  801f88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f8c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f93:	00 
  801f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f97:	89 04 24             	mov    %eax,(%esp)
  801f9a:	e8 75 eb ff ff       	call   800b14 <memmove>
		*addrlen = ret->ret_addrlen;
  801f9f:	a1 10 70 80 00       	mov    0x807010,%eax
  801fa4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801fa6:	89 d8                	mov    %ebx,%eax
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5e                   	pop    %esi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	53                   	push   %ebx
  801fb3:	83 ec 14             	sub    $0x14,%esp
  801fb6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fc1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcc:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801fd3:	e8 3c eb ff ff       	call   800b14 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fd8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801fde:	b8 02 00 00 00       	mov    $0x2,%eax
  801fe3:	e8 0b ff ff ff       	call   801ef3 <nsipc>
}
  801fe8:	83 c4 14             	add    $0x14,%esp
  801feb:	5b                   	pop    %ebx
  801fec:	5d                   	pop    %ebp
  801fed:	c3                   	ret    

00801fee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fee:	55                   	push   %ebp
  801fef:	89 e5                	mov    %esp,%ebp
  801ff1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fff:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802004:	b8 03 00 00 00       	mov    $0x3,%eax
  802009:	e8 e5 fe ff ff       	call   801ef3 <nsipc>
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <nsipc_close>:

int
nsipc_close(int s)
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802016:	8b 45 08             	mov    0x8(%ebp),%eax
  802019:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80201e:	b8 04 00 00 00       	mov    $0x4,%eax
  802023:	e8 cb fe ff ff       	call   801ef3 <nsipc>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	53                   	push   %ebx
  80202e:	83 ec 14             	sub    $0x14,%esp
  802031:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80203c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802040:	8b 45 0c             	mov    0xc(%ebp),%eax
  802043:	89 44 24 04          	mov    %eax,0x4(%esp)
  802047:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80204e:	e8 c1 ea ff ff       	call   800b14 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802053:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802059:	b8 05 00 00 00       	mov    $0x5,%eax
  80205e:	e8 90 fe ff ff       	call   801ef3 <nsipc>
}
  802063:	83 c4 14             	add    $0x14,%esp
  802066:	5b                   	pop    %ebx
  802067:	5d                   	pop    %ebp
  802068:	c3                   	ret    

00802069 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802069:	55                   	push   %ebp
  80206a:	89 e5                	mov    %esp,%ebp
  80206c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80206f:	8b 45 08             	mov    0x8(%ebp),%eax
  802072:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802077:	8b 45 0c             	mov    0xc(%ebp),%eax
  80207a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80207f:	b8 06 00 00 00       	mov    $0x6,%eax
  802084:	e8 6a fe ff ff       	call   801ef3 <nsipc>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	56                   	push   %esi
  80208f:	53                   	push   %ebx
  802090:	83 ec 10             	sub    $0x10,%esp
  802093:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80209e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8020a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8020a7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8020ac:	b8 07 00 00 00       	mov    $0x7,%eax
  8020b1:	e8 3d fe ff ff       	call   801ef3 <nsipc>
  8020b6:	89 c3                	mov    %eax,%ebx
  8020b8:	85 c0                	test   %eax,%eax
  8020ba:	78 46                	js     802102 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8020bc:	39 f0                	cmp    %esi,%eax
  8020be:	7f 07                	jg     8020c7 <nsipc_recv+0x3c>
  8020c0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8020c5:	7e 24                	jle    8020eb <nsipc_recv+0x60>
  8020c7:	c7 44 24 0c cb 31 80 	movl   $0x8031cb,0xc(%esp)
  8020ce:	00 
  8020cf:	c7 44 24 08 93 31 80 	movl   $0x803193,0x8(%esp)
  8020d6:	00 
  8020d7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  8020de:	00 
  8020df:	c7 04 24 e0 31 80 00 	movl   $0x8031e0,(%esp)
  8020e6:	e8 6a e1 ff ff       	call   800255 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020ef:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020f6:	00 
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	89 04 24             	mov    %eax,(%esp)
  8020fd:	e8 12 ea ff ff       	call   800b14 <memmove>
	}

	return r;
}
  802102:	89 d8                	mov    %ebx,%eax
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	5b                   	pop    %ebx
  802108:	5e                   	pop    %esi
  802109:	5d                   	pop    %ebp
  80210a:	c3                   	ret    

0080210b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
  80210e:	53                   	push   %ebx
  80210f:	83 ec 14             	sub    $0x14,%esp
  802112:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802115:	8b 45 08             	mov    0x8(%ebp),%eax
  802118:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80211d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802123:	7e 24                	jle    802149 <nsipc_send+0x3e>
  802125:	c7 44 24 0c ec 31 80 	movl   $0x8031ec,0xc(%esp)
  80212c:	00 
  80212d:	c7 44 24 08 93 31 80 	movl   $0x803193,0x8(%esp)
  802134:	00 
  802135:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80213c:	00 
  80213d:	c7 04 24 e0 31 80 00 	movl   $0x8031e0,(%esp)
  802144:	e8 0c e1 ff ff       	call   800255 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802149:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80214d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802150:	89 44 24 04          	mov    %eax,0x4(%esp)
  802154:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80215b:	e8 b4 e9 ff ff       	call   800b14 <memmove>
	nsipcbuf.send.req_size = size;
  802160:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802166:	8b 45 14             	mov    0x14(%ebp),%eax
  802169:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80216e:	b8 08 00 00 00       	mov    $0x8,%eax
  802173:	e8 7b fd ff ff       	call   801ef3 <nsipc>
}
  802178:	83 c4 14             	add    $0x14,%esp
  80217b:	5b                   	pop    %ebx
  80217c:	5d                   	pop    %ebp
  80217d:	c3                   	ret    

0080217e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802184:	8b 45 08             	mov    0x8(%ebp),%eax
  802187:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80218c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80219c:	b8 09 00 00 00       	mov    $0x9,%eax
  8021a1:	e8 4d fd ff ff       	call   801ef3 <nsipc>
}
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	56                   	push   %esi
  8021ac:	53                   	push   %ebx
  8021ad:	83 ec 10             	sub    $0x10,%esp
  8021b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	89 04 24             	mov    %eax,(%esp)
  8021b9:	e8 72 f2 ff ff       	call   801430 <fd2data>
  8021be:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8021c0:	c7 44 24 04 f8 31 80 	movl   $0x8031f8,0x4(%esp)
  8021c7:	00 
  8021c8:	89 1c 24             	mov    %ebx,(%esp)
  8021cb:	e8 a7 e7 ff ff       	call   800977 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021d0:	8b 46 04             	mov    0x4(%esi),%eax
  8021d3:	2b 06                	sub    (%esi),%eax
  8021d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8021db:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021e2:	00 00 00 
	stat->st_dev = &devpipe;
  8021e5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021ec:	40 80 00 
	return 0;
}
  8021ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f4:	83 c4 10             	add    $0x10,%esp
  8021f7:	5b                   	pop    %ebx
  8021f8:	5e                   	pop    %esi
  8021f9:	5d                   	pop    %ebp
  8021fa:	c3                   	ret    

008021fb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
  8021fe:	53                   	push   %ebx
  8021ff:	83 ec 14             	sub    $0x14,%esp
  802202:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802205:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802209:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802210:	e8 25 ec ff ff       	call   800e3a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802215:	89 1c 24             	mov    %ebx,(%esp)
  802218:	e8 13 f2 ff ff       	call   801430 <fd2data>
  80221d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802221:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802228:	e8 0d ec ff ff       	call   800e3a <sys_page_unmap>
}
  80222d:	83 c4 14             	add    $0x14,%esp
  802230:	5b                   	pop    %ebx
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    

00802233 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	57                   	push   %edi
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
  802239:	83 ec 2c             	sub    $0x2c,%esp
  80223c:	89 c6                	mov    %eax,%esi
  80223e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802241:	a1 08 50 80 00       	mov    0x805008,%eax
  802246:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802249:	89 34 24             	mov    %esi,(%esp)
  80224c:	e8 1d 06 00 00       	call   80286e <pageref>
  802251:	89 c7                	mov    %eax,%edi
  802253:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 10 06 00 00       	call   80286e <pageref>
  80225e:	39 c7                	cmp    %eax,%edi
  802260:	0f 94 c2             	sete   %dl
  802263:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802266:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80226c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80226f:	39 fb                	cmp    %edi,%ebx
  802271:	74 21                	je     802294 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802273:	84 d2                	test   %dl,%dl
  802275:	74 ca                	je     802241 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802277:	8b 51 58             	mov    0x58(%ecx),%edx
  80227a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80227e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802286:	c7 04 24 ff 31 80 00 	movl   $0x8031ff,(%esp)
  80228d:	e8 bc e0 ff ff       	call   80034e <cprintf>
  802292:	eb ad                	jmp    802241 <_pipeisclosed+0xe>
	}
}
  802294:	83 c4 2c             	add    $0x2c,%esp
  802297:	5b                   	pop    %ebx
  802298:	5e                   	pop    %esi
  802299:	5f                   	pop    %edi
  80229a:	5d                   	pop    %ebp
  80229b:	c3                   	ret    

0080229c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	57                   	push   %edi
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 1c             	sub    $0x1c,%esp
  8022a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022a8:	89 34 24             	mov    %esi,(%esp)
  8022ab:	e8 80 f1 ff ff       	call   801430 <fd2data>
  8022b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b7:	eb 45                	jmp    8022fe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022b9:	89 da                	mov    %ebx,%edx
  8022bb:	89 f0                	mov    %esi,%eax
  8022bd:	e8 71 ff ff ff       	call   802233 <_pipeisclosed>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	75 41                	jne    802307 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022c6:	e8 a9 ea ff ff       	call   800d74 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8022ce:	8b 0b                	mov    (%ebx),%ecx
  8022d0:	8d 51 20             	lea    0x20(%ecx),%edx
  8022d3:	39 d0                	cmp    %edx,%eax
  8022d5:	73 e2                	jae    8022b9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022da:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8022de:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022e1:	99                   	cltd   
  8022e2:	c1 ea 1b             	shr    $0x1b,%edx
  8022e5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8022e8:	83 e1 1f             	and    $0x1f,%ecx
  8022eb:	29 d1                	sub    %edx,%ecx
  8022ed:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022f1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022f5:	83 c0 01             	add    $0x1,%eax
  8022f8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fb:	83 c7 01             	add    $0x1,%edi
  8022fe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802301:	75 c8                	jne    8022cb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802303:	89 f8                	mov    %edi,%eax
  802305:	eb 05                	jmp    80230c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80230c:	83 c4 1c             	add    $0x1c,%esp
  80230f:	5b                   	pop    %ebx
  802310:	5e                   	pop    %esi
  802311:	5f                   	pop    %edi
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    

00802314 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802314:	55                   	push   %ebp
  802315:	89 e5                	mov    %esp,%ebp
  802317:	57                   	push   %edi
  802318:	56                   	push   %esi
  802319:	53                   	push   %ebx
  80231a:	83 ec 1c             	sub    $0x1c,%esp
  80231d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802320:	89 3c 24             	mov    %edi,(%esp)
  802323:	e8 08 f1 ff ff       	call   801430 <fd2data>
  802328:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232a:	be 00 00 00 00       	mov    $0x0,%esi
  80232f:	eb 3d                	jmp    80236e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802331:	85 f6                	test   %esi,%esi
  802333:	74 04                	je     802339 <devpipe_read+0x25>
				return i;
  802335:	89 f0                	mov    %esi,%eax
  802337:	eb 43                	jmp    80237c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802339:	89 da                	mov    %ebx,%edx
  80233b:	89 f8                	mov    %edi,%eax
  80233d:	e8 f1 fe ff ff       	call   802233 <_pipeisclosed>
  802342:	85 c0                	test   %eax,%eax
  802344:	75 31                	jne    802377 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802346:	e8 29 ea ff ff       	call   800d74 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80234b:	8b 03                	mov    (%ebx),%eax
  80234d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802350:	74 df                	je     802331 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802352:	99                   	cltd   
  802353:	c1 ea 1b             	shr    $0x1b,%edx
  802356:	01 d0                	add    %edx,%eax
  802358:	83 e0 1f             	and    $0x1f,%eax
  80235b:	29 d0                	sub    %edx,%eax
  80235d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802362:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802365:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802368:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80236b:	83 c6 01             	add    $0x1,%esi
  80236e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802371:	75 d8                	jne    80234b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802373:	89 f0                	mov    %esi,%eax
  802375:	eb 05                	jmp    80237c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802377:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	56                   	push   %esi
  802388:	53                   	push   %ebx
  802389:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80238c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80238f:	89 04 24             	mov    %eax,(%esp)
  802392:	e8 b0 f0 ff ff       	call   801447 <fd_alloc>
  802397:	89 c2                	mov    %eax,%edx
  802399:	85 d2                	test   %edx,%edx
  80239b:	0f 88 4d 01 00 00    	js     8024ee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023a1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a8:	00 
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b7:	e8 d7 e9 ff ff       	call   800d93 <sys_page_alloc>
  8023bc:	89 c2                	mov    %eax,%edx
  8023be:	85 d2                	test   %edx,%edx
  8023c0:	0f 88 28 01 00 00    	js     8024ee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023c9:	89 04 24             	mov    %eax,(%esp)
  8023cc:	e8 76 f0 ff ff       	call   801447 <fd_alloc>
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	85 c0                	test   %eax,%eax
  8023d5:	0f 88 fe 00 00 00    	js     8024d9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023db:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023e2:	00 
  8023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f1:	e8 9d e9 ff ff       	call   800d93 <sys_page_alloc>
  8023f6:	89 c3                	mov    %eax,%ebx
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	0f 88 d9 00 00 00    	js     8024d9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	89 04 24             	mov    %eax,(%esp)
  802406:	e8 25 f0 ff ff       	call   801430 <fd2data>
  80240b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802414:	00 
  802415:	89 44 24 04          	mov    %eax,0x4(%esp)
  802419:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802420:	e8 6e e9 ff ff       	call   800d93 <sys_page_alloc>
  802425:	89 c3                	mov    %eax,%ebx
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 88 97 00 00 00    	js     8024c6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 f6 ef ff ff       	call   801430 <fd2data>
  80243a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802441:	00 
  802442:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802446:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80244d:	00 
  80244e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802452:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802459:	e8 89 e9 ff ff       	call   800de7 <sys_page_map>
  80245e:	89 c3                	mov    %eax,%ebx
  802460:	85 c0                	test   %eax,%eax
  802462:	78 52                	js     8024b6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802464:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802479:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802487:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	89 04 24             	mov    %eax,(%esp)
  802494:	e8 87 ef ff ff       	call   801420 <fd2num>
  802499:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80249c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	89 04 24             	mov    %eax,(%esp)
  8024a4:	e8 77 ef ff ff       	call   801420 <fd2num>
  8024a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8024af:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b4:	eb 38                	jmp    8024ee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8024b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024c1:	e8 74 e9 ff ff       	call   800e3a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d4:	e8 61 e9 ff ff       	call   800e3a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e7:	e8 4e e9 ff ff       	call   800e3a <sys_page_unmap>
  8024ec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8024ee:	83 c4 30             	add    $0x30,%esp
  8024f1:	5b                   	pop    %ebx
  8024f2:	5e                   	pop    %esi
  8024f3:	5d                   	pop    %ebp
  8024f4:	c3                   	ret    

008024f5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802502:	8b 45 08             	mov    0x8(%ebp),%eax
  802505:	89 04 24             	mov    %eax,(%esp)
  802508:	e8 89 ef ff ff       	call   801496 <fd_lookup>
  80250d:	89 c2                	mov    %eax,%edx
  80250f:	85 d2                	test   %edx,%edx
  802511:	78 15                	js     802528 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	89 04 24             	mov    %eax,(%esp)
  802519:	e8 12 ef ff ff       	call   801430 <fd2data>
	return _pipeisclosed(fd, p);
  80251e:	89 c2                	mov    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	e8 0b fd ff ff       	call   802233 <_pipeisclosed>
}
  802528:	c9                   	leave  
  802529:	c3                   	ret    
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    

0080253a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802540:	c7 44 24 04 17 32 80 	movl   $0x803217,0x4(%esp)
  802547:	00 
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	89 04 24             	mov    %eax,(%esp)
  80254e:	e8 24 e4 ff ff       	call   800977 <strcpy>
	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802566:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80256b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802571:	eb 31                	jmp    8025a4 <devcons_write+0x4a>
		m = n - tot;
  802573:	8b 75 10             	mov    0x10(%ebp),%esi
  802576:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802578:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80257b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802580:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802583:	89 74 24 08          	mov    %esi,0x8(%esp)
  802587:	03 45 0c             	add    0xc(%ebp),%eax
  80258a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258e:	89 3c 24             	mov    %edi,(%esp)
  802591:	e8 7e e5 ff ff       	call   800b14 <memmove>
		sys_cputs(buf, m);
  802596:	89 74 24 04          	mov    %esi,0x4(%esp)
  80259a:	89 3c 24             	mov    %edi,(%esp)
  80259d:	e8 24 e7 ff ff       	call   800cc6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025a2:	01 f3                	add    %esi,%ebx
  8025a4:	89 d8                	mov    %ebx,%eax
  8025a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8025a9:	72 c8                	jb     802573 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8025bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8025c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025c5:	75 07                	jne    8025ce <devcons_read+0x18>
  8025c7:	eb 2a                	jmp    8025f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025c9:	e8 a6 e7 ff ff       	call   800d74 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025ce:	66 90                	xchg   %ax,%ax
  8025d0:	e8 0f e7 ff ff       	call   800ce4 <sys_cgetc>
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	74 f0                	je     8025c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	78 16                	js     8025f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8025dd:	83 f8 04             	cmp    $0x4,%eax
  8025e0:	74 0c                	je     8025ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8025e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025e5:	88 02                	mov    %al,(%edx)
	return 1;
  8025e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ec:	eb 05                	jmp    8025f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802601:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802608:	00 
  802609:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80260c:	89 04 24             	mov    %eax,(%esp)
  80260f:	e8 b2 e6 ff ff       	call   800cc6 <sys_cputs>
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <getchar>:

int
getchar(void)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80261c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802623:	00 
  802624:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802632:	e8 f3 f0 ff ff       	call   80172a <read>
	if (r < 0)
  802637:	85 c0                	test   %eax,%eax
  802639:	78 0f                	js     80264a <getchar+0x34>
		return r;
	if (r < 1)
  80263b:	85 c0                	test   %eax,%eax
  80263d:	7e 06                	jle    802645 <getchar+0x2f>
		return -E_EOF;
	return c;
  80263f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802643:	eb 05                	jmp    80264a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802645:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80264a:	c9                   	leave  
  80264b:	c3                   	ret    

0080264c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802652:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802655:	89 44 24 04          	mov    %eax,0x4(%esp)
  802659:	8b 45 08             	mov    0x8(%ebp),%eax
  80265c:	89 04 24             	mov    %eax,(%esp)
  80265f:	e8 32 ee ff ff       	call   801496 <fd_lookup>
  802664:	85 c0                	test   %eax,%eax
  802666:	78 11                	js     802679 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802668:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802671:	39 10                	cmp    %edx,(%eax)
  802673:	0f 94 c0             	sete   %al
  802676:	0f b6 c0             	movzbl %al,%eax
}
  802679:	c9                   	leave  
  80267a:	c3                   	ret    

0080267b <opencons>:

int
opencons(void)
{
  80267b:	55                   	push   %ebp
  80267c:	89 e5                	mov    %esp,%ebp
  80267e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802681:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802684:	89 04 24             	mov    %eax,(%esp)
  802687:	e8 bb ed ff ff       	call   801447 <fd_alloc>
		return r;
  80268c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 40                	js     8026d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802692:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802699:	00 
  80269a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a8:	e8 e6 e6 ff ff       	call   800d93 <sys_page_alloc>
		return r;
  8026ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	78 1f                	js     8026d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8026b3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026c8:	89 04 24             	mov    %eax,(%esp)
  8026cb:	e8 50 ed ff ff       	call   801420 <fd2num>
  8026d0:	89 c2                	mov    %eax,%edx
}
  8026d2:	89 d0                	mov    %edx,%eax
  8026d4:	c9                   	leave  
  8026d5:	c3                   	ret    

008026d6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026d6:	55                   	push   %ebp
  8026d7:	89 e5                	mov    %esp,%ebp
  8026d9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026dc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026e3:	75 58                	jne    80273d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8026e5:	a1 08 50 80 00       	mov    0x805008,%eax
  8026ea:	8b 40 48             	mov    0x48(%eax),%eax
  8026ed:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8026f4:	00 
  8026f5:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8026fc:	ee 
  8026fd:	89 04 24             	mov    %eax,(%esp)
  802700:	e8 8e e6 ff ff       	call   800d93 <sys_page_alloc>
		if(return_code!=0)
  802705:	85 c0                	test   %eax,%eax
  802707:	74 1c                	je     802725 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802709:	c7 44 24 08 24 32 80 	movl   $0x803224,0x8(%esp)
  802710:	00 
  802711:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802718:	00 
  802719:	c7 04 24 80 32 80 00 	movl   $0x803280,(%esp)
  802720:	e8 30 db ff ff       	call   800255 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802725:	a1 08 50 80 00       	mov    0x805008,%eax
  80272a:	8b 40 48             	mov    0x48(%eax),%eax
  80272d:	c7 44 24 04 47 27 80 	movl   $0x802747,0x4(%esp)
  802734:	00 
  802735:	89 04 24             	mov    %eax,(%esp)
  802738:	e8 f6 e7 ff ff       	call   800f33 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80273d:	8b 45 08             	mov    0x8(%ebp),%eax
  802740:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802747:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802748:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80274d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80274f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802752:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802754:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802758:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  80275c:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  80275d:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  80275f:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802761:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802765:	58                   	pop    %eax
	popl %eax;
  802766:	58                   	pop    %eax
	popal;
  802767:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802768:	83 c4 04             	add    $0x4,%esp
	popfl;
  80276b:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  80276c:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  80276d:	c3                   	ret    

0080276e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	56                   	push   %esi
  802772:	53                   	push   %ebx
  802773:	83 ec 10             	sub    $0x10,%esp
  802776:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802779:	8b 45 0c             	mov    0xc(%ebp),%eax
  80277c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80277f:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  802781:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802786:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802789:	89 04 24             	mov    %eax,(%esp)
  80278c:	e8 18 e8 ff ff       	call   800fa9 <sys_ipc_recv>
  802791:	85 c0                	test   %eax,%eax
  802793:	75 1e                	jne    8027b3 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802795:	85 db                	test   %ebx,%ebx
  802797:	74 0a                	je     8027a3 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802799:	a1 08 50 80 00       	mov    0x805008,%eax
  80279e:	8b 40 74             	mov    0x74(%eax),%eax
  8027a1:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8027a3:	85 f6                	test   %esi,%esi
  8027a5:	74 22                	je     8027c9 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8027a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ac:	8b 40 78             	mov    0x78(%eax),%eax
  8027af:	89 06                	mov    %eax,(%esi)
  8027b1:	eb 16                	jmp    8027c9 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8027b3:	85 f6                	test   %esi,%esi
  8027b5:	74 06                	je     8027bd <ipc_recv+0x4f>
				*perm_store = 0;
  8027b7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8027bd:	85 db                	test   %ebx,%ebx
  8027bf:	74 10                	je     8027d1 <ipc_recv+0x63>
				*from_env_store=0;
  8027c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8027c7:	eb 08                	jmp    8027d1 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8027c9:	a1 08 50 80 00       	mov    0x805008,%eax
  8027ce:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8027d1:	83 c4 10             	add    $0x10,%esp
  8027d4:	5b                   	pop    %ebx
  8027d5:	5e                   	pop    %esi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    

008027d8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027d8:	55                   	push   %ebp
  8027d9:	89 e5                	mov    %esp,%ebp
  8027db:	57                   	push   %edi
  8027dc:	56                   	push   %esi
  8027dd:	53                   	push   %ebx
  8027de:	83 ec 1c             	sub    $0x1c,%esp
  8027e1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027e7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8027ea:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8027ec:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8027f1:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8027f4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8027f8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802800:	8b 45 08             	mov    0x8(%ebp),%eax
  802803:	89 04 24             	mov    %eax,(%esp)
  802806:	e8 7b e7 ff ff       	call   800f86 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80280b:	eb 1c                	jmp    802829 <ipc_send+0x51>
	{
		sys_yield();
  80280d:	e8 62 e5 ff ff       	call   800d74 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802812:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802816:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80281a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80281e:	8b 45 08             	mov    0x8(%ebp),%eax
  802821:	89 04 24             	mov    %eax,(%esp)
  802824:	e8 5d e7 ff ff       	call   800f86 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802829:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80282c:	74 df                	je     80280d <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80282e:	83 c4 1c             	add    $0x1c,%esp
  802831:	5b                   	pop    %ebx
  802832:	5e                   	pop    %esi
  802833:	5f                   	pop    %edi
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    

00802836 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80283c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802841:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802844:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80284a:	8b 52 50             	mov    0x50(%edx),%edx
  80284d:	39 ca                	cmp    %ecx,%edx
  80284f:	75 0d                	jne    80285e <ipc_find_env+0x28>
			return envs[i].env_id;
  802851:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802854:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802859:	8b 40 40             	mov    0x40(%eax),%eax
  80285c:	eb 0e                	jmp    80286c <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80285e:	83 c0 01             	add    $0x1,%eax
  802861:	3d 00 04 00 00       	cmp    $0x400,%eax
  802866:	75 d9                	jne    802841 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802868:	66 b8 00 00          	mov    $0x0,%ax
}
  80286c:	5d                   	pop    %ebp
  80286d:	c3                   	ret    

0080286e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80286e:	55                   	push   %ebp
  80286f:	89 e5                	mov    %esp,%ebp
  802871:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802874:	89 d0                	mov    %edx,%eax
  802876:	c1 e8 16             	shr    $0x16,%eax
  802879:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802880:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802885:	f6 c1 01             	test   $0x1,%cl
  802888:	74 1d                	je     8028a7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  80288a:	c1 ea 0c             	shr    $0xc,%edx
  80288d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802894:	f6 c2 01             	test   $0x1,%dl
  802897:	74 0e                	je     8028a7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802899:	c1 ea 0c             	shr    $0xc,%edx
  80289c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8028a3:	ef 
  8028a4:	0f b7 c0             	movzwl %ax,%eax
}
  8028a7:	5d                   	pop    %ebp
  8028a8:	c3                   	ret    
  8028a9:	66 90                	xchg   %ax,%ax
  8028ab:	66 90                	xchg   %ax,%ax
  8028ad:	66 90                	xchg   %ax,%ax
  8028af:	90                   	nop

008028b0 <__udivdi3>:
  8028b0:	55                   	push   %ebp
  8028b1:	57                   	push   %edi
  8028b2:	56                   	push   %esi
  8028b3:	83 ec 0c             	sub    $0xc,%esp
  8028b6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028ba:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8028be:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8028c2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8028cc:	89 ea                	mov    %ebp,%edx
  8028ce:	89 0c 24             	mov    %ecx,(%esp)
  8028d1:	75 2d                	jne    802900 <__udivdi3+0x50>
  8028d3:	39 e9                	cmp    %ebp,%ecx
  8028d5:	77 61                	ja     802938 <__udivdi3+0x88>
  8028d7:	85 c9                	test   %ecx,%ecx
  8028d9:	89 ce                	mov    %ecx,%esi
  8028db:	75 0b                	jne    8028e8 <__udivdi3+0x38>
  8028dd:	b8 01 00 00 00       	mov    $0x1,%eax
  8028e2:	31 d2                	xor    %edx,%edx
  8028e4:	f7 f1                	div    %ecx
  8028e6:	89 c6                	mov    %eax,%esi
  8028e8:	31 d2                	xor    %edx,%edx
  8028ea:	89 e8                	mov    %ebp,%eax
  8028ec:	f7 f6                	div    %esi
  8028ee:	89 c5                	mov    %eax,%ebp
  8028f0:	89 f8                	mov    %edi,%eax
  8028f2:	f7 f6                	div    %esi
  8028f4:	89 ea                	mov    %ebp,%edx
  8028f6:	83 c4 0c             	add    $0xc,%esp
  8028f9:	5e                   	pop    %esi
  8028fa:	5f                   	pop    %edi
  8028fb:	5d                   	pop    %ebp
  8028fc:	c3                   	ret    
  8028fd:	8d 76 00             	lea    0x0(%esi),%esi
  802900:	39 e8                	cmp    %ebp,%eax
  802902:	77 24                	ja     802928 <__udivdi3+0x78>
  802904:	0f bd e8             	bsr    %eax,%ebp
  802907:	83 f5 1f             	xor    $0x1f,%ebp
  80290a:	75 3c                	jne    802948 <__udivdi3+0x98>
  80290c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802910:	39 34 24             	cmp    %esi,(%esp)
  802913:	0f 86 9f 00 00 00    	jbe    8029b8 <__udivdi3+0x108>
  802919:	39 d0                	cmp    %edx,%eax
  80291b:	0f 82 97 00 00 00    	jb     8029b8 <__udivdi3+0x108>
  802921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802928:	31 d2                	xor    %edx,%edx
  80292a:	31 c0                	xor    %eax,%eax
  80292c:	83 c4 0c             	add    $0xc,%esp
  80292f:	5e                   	pop    %esi
  802930:	5f                   	pop    %edi
  802931:	5d                   	pop    %ebp
  802932:	c3                   	ret    
  802933:	90                   	nop
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	89 f8                	mov    %edi,%eax
  80293a:	f7 f1                	div    %ecx
  80293c:	31 d2                	xor    %edx,%edx
  80293e:	83 c4 0c             	add    $0xc,%esp
  802941:	5e                   	pop    %esi
  802942:	5f                   	pop    %edi
  802943:	5d                   	pop    %ebp
  802944:	c3                   	ret    
  802945:	8d 76 00             	lea    0x0(%esi),%esi
  802948:	89 e9                	mov    %ebp,%ecx
  80294a:	8b 3c 24             	mov    (%esp),%edi
  80294d:	d3 e0                	shl    %cl,%eax
  80294f:	89 c6                	mov    %eax,%esi
  802951:	b8 20 00 00 00       	mov    $0x20,%eax
  802956:	29 e8                	sub    %ebp,%eax
  802958:	89 c1                	mov    %eax,%ecx
  80295a:	d3 ef                	shr    %cl,%edi
  80295c:	89 e9                	mov    %ebp,%ecx
  80295e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802962:	8b 3c 24             	mov    (%esp),%edi
  802965:	09 74 24 08          	or     %esi,0x8(%esp)
  802969:	89 d6                	mov    %edx,%esi
  80296b:	d3 e7                	shl    %cl,%edi
  80296d:	89 c1                	mov    %eax,%ecx
  80296f:	89 3c 24             	mov    %edi,(%esp)
  802972:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802976:	d3 ee                	shr    %cl,%esi
  802978:	89 e9                	mov    %ebp,%ecx
  80297a:	d3 e2                	shl    %cl,%edx
  80297c:	89 c1                	mov    %eax,%ecx
  80297e:	d3 ef                	shr    %cl,%edi
  802980:	09 d7                	or     %edx,%edi
  802982:	89 f2                	mov    %esi,%edx
  802984:	89 f8                	mov    %edi,%eax
  802986:	f7 74 24 08          	divl   0x8(%esp)
  80298a:	89 d6                	mov    %edx,%esi
  80298c:	89 c7                	mov    %eax,%edi
  80298e:	f7 24 24             	mull   (%esp)
  802991:	39 d6                	cmp    %edx,%esi
  802993:	89 14 24             	mov    %edx,(%esp)
  802996:	72 30                	jb     8029c8 <__udivdi3+0x118>
  802998:	8b 54 24 04          	mov    0x4(%esp),%edx
  80299c:	89 e9                	mov    %ebp,%ecx
  80299e:	d3 e2                	shl    %cl,%edx
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	73 05                	jae    8029a9 <__udivdi3+0xf9>
  8029a4:	3b 34 24             	cmp    (%esp),%esi
  8029a7:	74 1f                	je     8029c8 <__udivdi3+0x118>
  8029a9:	89 f8                	mov    %edi,%eax
  8029ab:	31 d2                	xor    %edx,%edx
  8029ad:	e9 7a ff ff ff       	jmp    80292c <__udivdi3+0x7c>
  8029b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8029b8:	31 d2                	xor    %edx,%edx
  8029ba:	b8 01 00 00 00       	mov    $0x1,%eax
  8029bf:	e9 68 ff ff ff       	jmp    80292c <__udivdi3+0x7c>
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8029cb:	31 d2                	xor    %edx,%edx
  8029cd:	83 c4 0c             	add    $0xc,%esp
  8029d0:	5e                   	pop    %esi
  8029d1:	5f                   	pop    %edi
  8029d2:	5d                   	pop    %ebp
  8029d3:	c3                   	ret    
  8029d4:	66 90                	xchg   %ax,%ax
  8029d6:	66 90                	xchg   %ax,%ax
  8029d8:	66 90                	xchg   %ax,%ax
  8029da:	66 90                	xchg   %ax,%ax
  8029dc:	66 90                	xchg   %ax,%ax
  8029de:	66 90                	xchg   %ax,%ax

008029e0 <__umoddi3>:
  8029e0:	55                   	push   %ebp
  8029e1:	57                   	push   %edi
  8029e2:	56                   	push   %esi
  8029e3:	83 ec 14             	sub    $0x14,%esp
  8029e6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8029ea:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8029ee:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8029f2:	89 c7                	mov    %eax,%edi
  8029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8029fc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802a00:	89 34 24             	mov    %esi,(%esp)
  802a03:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a07:	85 c0                	test   %eax,%eax
  802a09:	89 c2                	mov    %eax,%edx
  802a0b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a0f:	75 17                	jne    802a28 <__umoddi3+0x48>
  802a11:	39 fe                	cmp    %edi,%esi
  802a13:	76 4b                	jbe    802a60 <__umoddi3+0x80>
  802a15:	89 c8                	mov    %ecx,%eax
  802a17:	89 fa                	mov    %edi,%edx
  802a19:	f7 f6                	div    %esi
  802a1b:	89 d0                	mov    %edx,%eax
  802a1d:	31 d2                	xor    %edx,%edx
  802a1f:	83 c4 14             	add    $0x14,%esp
  802a22:	5e                   	pop    %esi
  802a23:	5f                   	pop    %edi
  802a24:	5d                   	pop    %ebp
  802a25:	c3                   	ret    
  802a26:	66 90                	xchg   %ax,%ax
  802a28:	39 f8                	cmp    %edi,%eax
  802a2a:	77 54                	ja     802a80 <__umoddi3+0xa0>
  802a2c:	0f bd e8             	bsr    %eax,%ebp
  802a2f:	83 f5 1f             	xor    $0x1f,%ebp
  802a32:	75 5c                	jne    802a90 <__umoddi3+0xb0>
  802a34:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a38:	39 3c 24             	cmp    %edi,(%esp)
  802a3b:	0f 87 e7 00 00 00    	ja     802b28 <__umoddi3+0x148>
  802a41:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a45:	29 f1                	sub    %esi,%ecx
  802a47:	19 c7                	sbb    %eax,%edi
  802a49:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802a4d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a51:	8b 44 24 08          	mov    0x8(%esp),%eax
  802a55:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802a59:	83 c4 14             	add    $0x14,%esp
  802a5c:	5e                   	pop    %esi
  802a5d:	5f                   	pop    %edi
  802a5e:	5d                   	pop    %ebp
  802a5f:	c3                   	ret    
  802a60:	85 f6                	test   %esi,%esi
  802a62:	89 f5                	mov    %esi,%ebp
  802a64:	75 0b                	jne    802a71 <__umoddi3+0x91>
  802a66:	b8 01 00 00 00       	mov    $0x1,%eax
  802a6b:	31 d2                	xor    %edx,%edx
  802a6d:	f7 f6                	div    %esi
  802a6f:	89 c5                	mov    %eax,%ebp
  802a71:	8b 44 24 04          	mov    0x4(%esp),%eax
  802a75:	31 d2                	xor    %edx,%edx
  802a77:	f7 f5                	div    %ebp
  802a79:	89 c8                	mov    %ecx,%eax
  802a7b:	f7 f5                	div    %ebp
  802a7d:	eb 9c                	jmp    802a1b <__umoddi3+0x3b>
  802a7f:	90                   	nop
  802a80:	89 c8                	mov    %ecx,%eax
  802a82:	89 fa                	mov    %edi,%edx
  802a84:	83 c4 14             	add    $0x14,%esp
  802a87:	5e                   	pop    %esi
  802a88:	5f                   	pop    %edi
  802a89:	5d                   	pop    %ebp
  802a8a:	c3                   	ret    
  802a8b:	90                   	nop
  802a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a90:	8b 04 24             	mov    (%esp),%eax
  802a93:	be 20 00 00 00       	mov    $0x20,%esi
  802a98:	89 e9                	mov    %ebp,%ecx
  802a9a:	29 ee                	sub    %ebp,%esi
  802a9c:	d3 e2                	shl    %cl,%edx
  802a9e:	89 f1                	mov    %esi,%ecx
  802aa0:	d3 e8                	shr    %cl,%eax
  802aa2:	89 e9                	mov    %ebp,%ecx
  802aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa8:	8b 04 24             	mov    (%esp),%eax
  802aab:	09 54 24 04          	or     %edx,0x4(%esp)
  802aaf:	89 fa                	mov    %edi,%edx
  802ab1:	d3 e0                	shl    %cl,%eax
  802ab3:	89 f1                	mov    %esi,%ecx
  802ab5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802ab9:	8b 44 24 10          	mov    0x10(%esp),%eax
  802abd:	d3 ea                	shr    %cl,%edx
  802abf:	89 e9                	mov    %ebp,%ecx
  802ac1:	d3 e7                	shl    %cl,%edi
  802ac3:	89 f1                	mov    %esi,%ecx
  802ac5:	d3 e8                	shr    %cl,%eax
  802ac7:	89 e9                	mov    %ebp,%ecx
  802ac9:	09 f8                	or     %edi,%eax
  802acb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802acf:	f7 74 24 04          	divl   0x4(%esp)
  802ad3:	d3 e7                	shl    %cl,%edi
  802ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802ad9:	89 d7                	mov    %edx,%edi
  802adb:	f7 64 24 08          	mull   0x8(%esp)
  802adf:	39 d7                	cmp    %edx,%edi
  802ae1:	89 c1                	mov    %eax,%ecx
  802ae3:	89 14 24             	mov    %edx,(%esp)
  802ae6:	72 2c                	jb     802b14 <__umoddi3+0x134>
  802ae8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802aec:	72 22                	jb     802b10 <__umoddi3+0x130>
  802aee:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802af2:	29 c8                	sub    %ecx,%eax
  802af4:	19 d7                	sbb    %edx,%edi
  802af6:	89 e9                	mov    %ebp,%ecx
  802af8:	89 fa                	mov    %edi,%edx
  802afa:	d3 e8                	shr    %cl,%eax
  802afc:	89 f1                	mov    %esi,%ecx
  802afe:	d3 e2                	shl    %cl,%edx
  802b00:	89 e9                	mov    %ebp,%ecx
  802b02:	d3 ef                	shr    %cl,%edi
  802b04:	09 d0                	or     %edx,%eax
  802b06:	89 fa                	mov    %edi,%edx
  802b08:	83 c4 14             	add    $0x14,%esp
  802b0b:	5e                   	pop    %esi
  802b0c:	5f                   	pop    %edi
  802b0d:	5d                   	pop    %ebp
  802b0e:	c3                   	ret    
  802b0f:	90                   	nop
  802b10:	39 d7                	cmp    %edx,%edi
  802b12:	75 da                	jne    802aee <__umoddi3+0x10e>
  802b14:	8b 14 24             	mov    (%esp),%edx
  802b17:	89 c1                	mov    %eax,%ecx
  802b19:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802b1d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802b21:	eb cb                	jmp    802aee <__umoddi3+0x10e>
  802b23:	90                   	nop
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802b2c:	0f 82 0f ff ff ff    	jb     802a41 <__umoddi3+0x61>
  802b32:	e9 1a ff ff ff       	jmp    802a51 <__umoddi3+0x71>
