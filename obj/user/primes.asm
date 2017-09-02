
obj/user/primes.debug:     file format elf32-i386


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
  80002c:	e8 17 01 00 00       	call   800148 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003c:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80003f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800046:	00 
  800047:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004e:	00 
  80004f:	89 34 24             	mov    %esi,(%esp)
  800052:	e8 22 13 00 00       	call   801379 <ipc_recv>
  800057:	89 c3                	mov    %eax,%ebx
	cprintf("CPU %d: %d ", thisenv->env_cpunum, p);
  800059:	a1 08 50 80 00       	mov    0x805008,%eax
  80005e:	8b 40 5c             	mov    0x5c(%eax),%eax
  800061:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800065:	89 44 24 04          	mov    %eax,0x4(%esp)
  800069:	c7 04 24 a0 2a 80 00 	movl   $0x802aa0,(%esp)
  800070:	e8 37 02 00 00       	call   8002ac <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  800075:	e8 ac 10 00 00       	call   801126 <fork>
  80007a:	89 c7                	mov    %eax,%edi
  80007c:	85 c0                	test   %eax,%eax
  80007e:	79 20                	jns    8000a0 <primeproc+0x6d>
		panic("fork: %e", id);
  800080:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800084:	c7 44 24 08 ac 2a 80 	movl   $0x802aac,0x8(%esp)
  80008b:	00 
  80008c:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800093:	00 
  800094:	c7 04 24 b5 2a 80 00 	movl   $0x802ab5,(%esp)
  80009b:	e8 13 01 00 00       	call   8001b3 <_panic>
	if (id == 0)
  8000a0:	85 c0                	test   %eax,%eax
  8000a2:	74 9b                	je     80003f <primeproc+0xc>
		goto top;

	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  8000a4:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  8000a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ae:	00 
  8000af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000b6:	00 
  8000b7:	89 34 24             	mov    %esi,(%esp)
  8000ba:	e8 ba 12 00 00       	call   801379 <ipc_recv>
  8000bf:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000c1:	99                   	cltd   
  8000c2:	f7 fb                	idiv   %ebx
  8000c4:	85 d2                	test   %edx,%edx
  8000c6:	74 df                	je     8000a7 <primeproc+0x74>
			ipc_send(id, i, 0, 0);
  8000c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000cf:	00 
  8000d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d7:	00 
  8000d8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000dc:	89 3c 24             	mov    %edi,(%esp)
  8000df:	e8 ff 12 00 00       	call   8013e3 <ipc_send>
  8000e4:	eb c1                	jmp    8000a7 <primeproc+0x74>

008000e6 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000ee:	e8 33 10 00 00       	call   801126 <fork>
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	85 c0                	test   %eax,%eax
  8000f7:	79 20                	jns    800119 <umain+0x33>
		panic("fork: %e", id);
  8000f9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000fd:	c7 44 24 08 ac 2a 80 	movl   $0x802aac,0x8(%esp)
  800104:	00 
  800105:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  80010c:	00 
  80010d:	c7 04 24 b5 2a 80 00 	movl   $0x802ab5,(%esp)
  800114:	e8 9a 00 00 00       	call   8001b3 <_panic>
	if (id == 0)
  800119:	bb 02 00 00 00       	mov    $0x2,%ebx
  80011e:	85 c0                	test   %eax,%eax
  800120:	75 05                	jne    800127 <umain+0x41>
		primeproc();
  800122:	e8 0c ff ff ff       	call   800033 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800127:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80012e:	00 
  80012f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800136:	00 
  800137:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80013b:	89 34 24             	mov    %esi,(%esp)
  80013e:	e8 a0 12 00 00       	call   8013e3 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  800143:	83 c3 01             	add    $0x1,%ebx
  800146:	eb df                	jmp    800127 <umain+0x41>

00800148 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	56                   	push   %esi
  80014c:	53                   	push   %ebx
  80014d:	83 ec 10             	sub    $0x10,%esp
  800150:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800153:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800156:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  80015d:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800160:	e8 50 0b 00 00       	call   800cb5 <sys_getenvid>
  800165:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80016a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80016d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800172:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800177:	85 db                	test   %ebx,%ebx
  800179:	7e 07                	jle    800182 <libmain+0x3a>
		binaryname = argv[0];
  80017b:	8b 06                	mov    (%esi),%eax
  80017d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800182:	89 74 24 04          	mov    %esi,0x4(%esp)
  800186:	89 1c 24             	mov    %ebx,(%esp)
  800189:	e8 58 ff ff ff       	call   8000e6 <umain>

	// exit gracefully
	exit();
  80018e:	e8 07 00 00 00       	call   80019a <exit>
}
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	5b                   	pop    %ebx
  800197:	5e                   	pop    %esi
  800198:	5d                   	pop    %ebp
  800199:	c3                   	ret    

0080019a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001a0:	e8 b5 14 00 00       	call   80165a <close_all>
	sys_env_destroy(0);
  8001a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ac:	e8 b2 0a 00 00       	call   800c63 <sys_env_destroy>
}
  8001b1:	c9                   	leave  
  8001b2:	c3                   	ret    

008001b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	56                   	push   %esi
  8001b7:	53                   	push   %ebx
  8001b8:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8001bb:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8001be:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8001c4:	e8 ec 0a 00 00       	call   800cb5 <sys_getenvid>
  8001c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001cc:	89 54 24 10          	mov    %edx,0x10(%esp)
  8001d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d3:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001d7:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	c7 04 24 d0 2a 80 00 	movl   $0x802ad0,(%esp)
  8001e6:	e8 c1 00 00 00       	call   8002ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8001f2:	89 04 24             	mov    %eax,(%esp)
  8001f5:	e8 51 00 00 00       	call   80024b <vcprintf>
	cprintf("\n");
  8001fa:	c7 04 24 d0 30 80 00 	movl   $0x8030d0,(%esp)
  800201:	e8 a6 00 00 00       	call   8002ac <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800206:	cc                   	int3   
  800207:	eb fd                	jmp    800206 <_panic+0x53>

00800209 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	53                   	push   %ebx
  80020d:	83 ec 14             	sub    $0x14,%esp
  800210:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800213:	8b 13                	mov    (%ebx),%edx
  800215:	8d 42 01             	lea    0x1(%edx),%eax
  800218:	89 03                	mov    %eax,(%ebx)
  80021a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80021d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800221:	3d ff 00 00 00       	cmp    $0xff,%eax
  800226:	75 19                	jne    800241 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800228:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80022f:	00 
  800230:	8d 43 08             	lea    0x8(%ebx),%eax
  800233:	89 04 24             	mov    %eax,(%esp)
  800236:	e8 eb 09 00 00       	call   800c26 <sys_cputs>
		b->idx = 0;
  80023b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800241:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800245:	83 c4 14             	add    $0x14,%esp
  800248:	5b                   	pop    %ebx
  800249:	5d                   	pop    %ebp
  80024a:	c3                   	ret    

0080024b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80024b:	55                   	push   %ebp
  80024c:	89 e5                	mov    %esp,%ebp
  80024e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800254:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80025b:	00 00 00 
	b.cnt = 0;
  80025e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800265:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800268:	8b 45 0c             	mov    0xc(%ebp),%eax
  80026b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80026f:	8b 45 08             	mov    0x8(%ebp),%eax
  800272:	89 44 24 08          	mov    %eax,0x8(%esp)
  800276:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80027c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800280:	c7 04 24 09 02 80 00 	movl   $0x800209,(%esp)
  800287:	e8 b2 01 00 00       	call   80043e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80028c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800292:	89 44 24 04          	mov    %eax,0x4(%esp)
  800296:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80029c:	89 04 24             	mov    %eax,(%esp)
  80029f:	e8 82 09 00 00       	call   800c26 <sys_cputs>

	return b.cnt;
}
  8002a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002aa:	c9                   	leave  
  8002ab:	c3                   	ret    

008002ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8002b2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8002b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002bc:	89 04 24             	mov    %eax,(%esp)
  8002bf:	e8 87 ff ff ff       	call   80024b <vcprintf>
	va_end(ap);

	return cnt;
}
  8002c4:	c9                   	leave  
  8002c5:	c3                   	ret    
  8002c6:	66 90                	xchg   %ax,%ax
  8002c8:	66 90                	xchg   %ax,%ax
  8002ca:	66 90                	xchg   %ax,%ax
  8002cc:	66 90                	xchg   %ax,%ax
  8002ce:	66 90                	xchg   %ax,%ax

008002d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 3c             	sub    $0x3c,%esp
  8002d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002dc:	89 d7                	mov    %edx,%edi
  8002de:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002e7:	89 c3                	mov    %eax,%ebx
  8002e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002fd:	39 d9                	cmp    %ebx,%ecx
  8002ff:	72 05                	jb     800306 <printnum+0x36>
  800301:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800304:	77 69                	ja     80036f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800306:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800309:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80030d:	83 ee 01             	sub    $0x1,%esi
  800310:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800314:	89 44 24 08          	mov    %eax,0x8(%esp)
  800318:	8b 44 24 08          	mov    0x8(%esp),%eax
  80031c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800320:	89 c3                	mov    %eax,%ebx
  800322:	89 d6                	mov    %edx,%esi
  800324:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800327:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80032a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80032e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800332:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800335:	89 04 24             	mov    %eax,(%esp)
  800338:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80033b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033f:	e8 cc 24 00 00       	call   802810 <__udivdi3>
  800344:	89 d9                	mov    %ebx,%ecx
  800346:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80034a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80034e:	89 04 24             	mov    %eax,(%esp)
  800351:	89 54 24 04          	mov    %edx,0x4(%esp)
  800355:	89 fa                	mov    %edi,%edx
  800357:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80035a:	e8 71 ff ff ff       	call   8002d0 <printnum>
  80035f:	eb 1b                	jmp    80037c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800361:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800365:	8b 45 18             	mov    0x18(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	ff d3                	call   *%ebx
  80036d:	eb 03                	jmp    800372 <printnum+0xa2>
  80036f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800372:	83 ee 01             	sub    $0x1,%esi
  800375:	85 f6                	test   %esi,%esi
  800377:	7f e8                	jg     800361 <printnum+0x91>
  800379:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80037c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800380:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800384:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800387:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80038a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80039b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039f:	e8 9c 25 00 00       	call   802940 <__umoddi3>
  8003a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003a8:	0f be 80 f3 2a 80 00 	movsbl 0x802af3(%eax),%eax
  8003af:	89 04 24             	mov    %eax,(%esp)
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	ff d0                	call   *%eax
}
  8003b7:	83 c4 3c             	add    $0x3c,%esp
  8003ba:	5b                   	pop    %ebx
  8003bb:	5e                   	pop    %esi
  8003bc:	5f                   	pop    %edi
  8003bd:	5d                   	pop    %ebp
  8003be:	c3                   	ret    

008003bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003c2:	83 fa 01             	cmp    $0x1,%edx
  8003c5:	7e 0e                	jle    8003d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003c7:	8b 10                	mov    (%eax),%edx
  8003c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003cc:	89 08                	mov    %ecx,(%eax)
  8003ce:	8b 02                	mov    (%edx),%eax
  8003d0:	8b 52 04             	mov    0x4(%edx),%edx
  8003d3:	eb 22                	jmp    8003f7 <getuint+0x38>
	else if (lflag)
  8003d5:	85 d2                	test   %edx,%edx
  8003d7:	74 10                	je     8003e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003d9:	8b 10                	mov    (%eax),%edx
  8003db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003de:	89 08                	mov    %ecx,(%eax)
  8003e0:	8b 02                	mov    (%edx),%eax
  8003e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003e7:	eb 0e                	jmp    8003f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003e9:	8b 10                	mov    (%eax),%edx
  8003eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ee:	89 08                	mov    %ecx,(%eax)
  8003f0:	8b 02                	mov    (%edx),%eax
  8003f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003f7:	5d                   	pop    %ebp
  8003f8:	c3                   	ret    

008003f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003f9:	55                   	push   %ebp
  8003fa:	89 e5                	mov    %esp,%ebp
  8003fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800403:	8b 10                	mov    (%eax),%edx
  800405:	3b 50 04             	cmp    0x4(%eax),%edx
  800408:	73 0a                	jae    800414 <sprintputch+0x1b>
		*b->buf++ = ch;
  80040a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80040d:	89 08                	mov    %ecx,(%eax)
  80040f:	8b 45 08             	mov    0x8(%ebp),%eax
  800412:	88 02                	mov    %al,(%edx)
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80041c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80041f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800423:	8b 45 10             	mov    0x10(%ebp),%eax
  800426:	89 44 24 08          	mov    %eax,0x8(%esp)
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800431:	8b 45 08             	mov    0x8(%ebp),%eax
  800434:	89 04 24             	mov    %eax,(%esp)
  800437:	e8 02 00 00 00       	call   80043e <vprintfmt>
	va_end(ap);
}
  80043c:	c9                   	leave  
  80043d:	c3                   	ret    

0080043e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043e:	55                   	push   %ebp
  80043f:	89 e5                	mov    %esp,%ebp
  800441:	57                   	push   %edi
  800442:	56                   	push   %esi
  800443:	53                   	push   %ebx
  800444:	83 ec 3c             	sub    $0x3c,%esp
  800447:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80044a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80044d:	eb 14                	jmp    800463 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80044f:	85 c0                	test   %eax,%eax
  800451:	0f 84 b3 03 00 00    	je     80080a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800457:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80045b:	89 04 24             	mov    %eax,(%esp)
  80045e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800461:	89 f3                	mov    %esi,%ebx
  800463:	8d 73 01             	lea    0x1(%ebx),%esi
  800466:	0f b6 03             	movzbl (%ebx),%eax
  800469:	83 f8 25             	cmp    $0x25,%eax
  80046c:	75 e1                	jne    80044f <vprintfmt+0x11>
  80046e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800472:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800479:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800480:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800487:	ba 00 00 00 00       	mov    $0x0,%edx
  80048c:	eb 1d                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800490:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800494:	eb 15                	jmp    8004ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800496:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800498:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80049c:	eb 0d                	jmp    8004ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80049e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8004a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8004ae:	0f b6 0e             	movzbl (%esi),%ecx
  8004b1:	0f b6 c1             	movzbl %cl,%eax
  8004b4:	83 e9 23             	sub    $0x23,%ecx
  8004b7:	80 f9 55             	cmp    $0x55,%cl
  8004ba:	0f 87 2a 03 00 00    	ja     8007ea <vprintfmt+0x3ac>
  8004c0:	0f b6 c9             	movzbl %cl,%ecx
  8004c3:	ff 24 8d 40 2c 80 00 	jmp    *0x802c40(,%ecx,4)
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004de:	83 fb 09             	cmp    $0x9,%ebx
  8004e1:	77 36                	ja     800519 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004e6:	eb e9                	jmp    8004d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004f1:	8b 00                	mov    (%eax),%eax
  8004f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004f8:	eb 22                	jmp    80051c <vprintfmt+0xde>
  8004fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004fd:	85 c9                	test   %ecx,%ecx
  8004ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800504:	0f 49 c1             	cmovns %ecx,%eax
  800507:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	89 de                	mov    %ebx,%esi
  80050c:	eb 9d                	jmp    8004ab <vprintfmt+0x6d>
  80050e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800510:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800517:	eb 92                	jmp    8004ab <vprintfmt+0x6d>
  800519:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80051c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800520:	79 89                	jns    8004ab <vprintfmt+0x6d>
  800522:	e9 77 ff ff ff       	jmp    80049e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800527:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80052c:	e9 7a ff ff ff       	jmp    8004ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 50 04             	lea    0x4(%eax),%edx
  800537:	89 55 14             	mov    %edx,0x14(%ebp)
  80053a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
			break;
  800546:	e9 18 ff ff ff       	jmp    800463 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80054b:	8b 45 14             	mov    0x14(%ebp),%eax
  80054e:	8d 50 04             	lea    0x4(%eax),%edx
  800551:	89 55 14             	mov    %edx,0x14(%ebp)
  800554:	8b 00                	mov    (%eax),%eax
  800556:	99                   	cltd   
  800557:	31 d0                	xor    %edx,%eax
  800559:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80055b:	83 f8 0f             	cmp    $0xf,%eax
  80055e:	7f 0b                	jg     80056b <vprintfmt+0x12d>
  800560:	8b 14 85 a0 2d 80 00 	mov    0x802da0(,%eax,4),%edx
  800567:	85 d2                	test   %edx,%edx
  800569:	75 20                	jne    80058b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80056b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80056f:	c7 44 24 08 0b 2b 80 	movl   $0x802b0b,0x8(%esp)
  800576:	00 
  800577:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80057b:	8b 45 08             	mov    0x8(%ebp),%eax
  80057e:	89 04 24             	mov    %eax,(%esp)
  800581:	e8 90 fe ff ff       	call   800416 <printfmt>
  800586:	e9 d8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80058b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80058f:	c7 44 24 08 65 30 80 	movl   $0x803065,0x8(%esp)
  800596:	00 
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	8b 45 08             	mov    0x8(%ebp),%eax
  80059e:	89 04 24             	mov    %eax,(%esp)
  8005a1:	e8 70 fe ff ff       	call   800416 <printfmt>
  8005a6:	e9 b8 fe ff ff       	jmp    800463 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8005ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b7:	8d 50 04             	lea    0x4(%eax),%edx
  8005ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8005bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8005bf:	85 f6                	test   %esi,%esi
  8005c1:	b8 04 2b 80 00       	mov    $0x802b04,%eax
  8005c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8005c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8005cd:	0f 84 97 00 00 00    	je     80066a <vprintfmt+0x22c>
  8005d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005d7:	0f 8e 9b 00 00 00    	jle    800678 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005e1:	89 34 24             	mov    %esi,(%esp)
  8005e4:	e8 cf 02 00 00       	call   8008b8 <strnlen>
  8005e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ec:	29 c2                	sub    %eax,%edx
  8005ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800601:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800603:	eb 0f                	jmp    800614 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060c:	89 04 24             	mov    %eax,(%esp)
  80060f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	83 eb 01             	sub    $0x1,%ebx
  800614:	85 db                	test   %ebx,%ebx
  800616:	7f ed                	jg     800605 <vprintfmt+0x1c7>
  800618:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80061b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061e:	85 d2                	test   %edx,%edx
  800620:	b8 00 00 00 00       	mov    $0x0,%eax
  800625:	0f 49 c2             	cmovns %edx,%eax
  800628:	29 c2                	sub    %eax,%edx
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	89 d7                	mov    %edx,%edi
  80062f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800632:	eb 50                	jmp    800684 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800638:	74 1e                	je     800658 <vprintfmt+0x21a>
  80063a:	0f be d2             	movsbl %dl,%edx
  80063d:	83 ea 20             	sub    $0x20,%edx
  800640:	83 fa 5e             	cmp    $0x5e,%edx
  800643:	76 13                	jbe    800658 <vprintfmt+0x21a>
					putch('?', putdat);
  800645:	8b 45 0c             	mov    0xc(%ebp),%eax
  800648:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800653:	ff 55 08             	call   *0x8(%ebp)
  800656:	eb 0d                	jmp    800665 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800658:	8b 55 0c             	mov    0xc(%ebp),%edx
  80065b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800665:	83 ef 01             	sub    $0x1,%edi
  800668:	eb 1a                	jmp    800684 <vprintfmt+0x246>
  80066a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80066d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800670:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800673:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800676:	eb 0c                	jmp    800684 <vprintfmt+0x246>
  800678:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80067b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80067e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800681:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800684:	83 c6 01             	add    $0x1,%esi
  800687:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80068b:	0f be c2             	movsbl %dl,%eax
  80068e:	85 c0                	test   %eax,%eax
  800690:	74 27                	je     8006b9 <vprintfmt+0x27b>
  800692:	85 db                	test   %ebx,%ebx
  800694:	78 9e                	js     800634 <vprintfmt+0x1f6>
  800696:	83 eb 01             	sub    $0x1,%ebx
  800699:	79 99                	jns    800634 <vprintfmt+0x1f6>
  80069b:	89 f8                	mov    %edi,%eax
  80069d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8006a3:	89 c3                	mov    %eax,%ebx
  8006a5:	eb 1a                	jmp    8006c1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006b2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b4:	83 eb 01             	sub    $0x1,%ebx
  8006b7:	eb 08                	jmp    8006c1 <vprintfmt+0x283>
  8006b9:	89 fb                	mov    %edi,%ebx
  8006bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8006be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8006c1:	85 db                	test   %ebx,%ebx
  8006c3:	7f e2                	jg     8006a7 <vprintfmt+0x269>
  8006c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8006c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8006cb:	e9 93 fd ff ff       	jmp    800463 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006d0:	83 fa 01             	cmp    $0x1,%edx
  8006d3:	7e 16                	jle    8006eb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d8:	8d 50 08             	lea    0x8(%eax),%edx
  8006db:	89 55 14             	mov    %edx,0x14(%ebp)
  8006de:	8b 50 04             	mov    0x4(%eax),%edx
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e9:	eb 32                	jmp    80071d <vprintfmt+0x2df>
	else if (lflag)
  8006eb:	85 d2                	test   %edx,%edx
  8006ed:	74 18                	je     800707 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 50 04             	lea    0x4(%eax),%edx
  8006f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f8:	8b 30                	mov    (%eax),%esi
  8006fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006fd:	89 f0                	mov    %esi,%eax
  8006ff:	c1 f8 1f             	sar    $0x1f,%eax
  800702:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800705:	eb 16                	jmp    80071d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	89 55 14             	mov    %edx,0x14(%ebp)
  800710:	8b 30                	mov    (%eax),%esi
  800712:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800715:	89 f0                	mov    %esi,%eax
  800717:	c1 f8 1f             	sar    $0x1f,%eax
  80071a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80071d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800720:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800723:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800728:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072c:	0f 89 80 00 00 00    	jns    8007b2 <vprintfmt+0x374>
				putch('-', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800740:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800743:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800746:	f7 d8                	neg    %eax
  800748:	83 d2 00             	adc    $0x0,%edx
  80074b:	f7 da                	neg    %edx
			}
			base = 10;
  80074d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800752:	eb 5e                	jmp    8007b2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800754:	8d 45 14             	lea    0x14(%ebp),%eax
  800757:	e8 63 fc ff ff       	call   8003bf <getuint>
			base = 10;
  80075c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800761:	eb 4f                	jmp    8007b2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800763:	8d 45 14             	lea    0x14(%ebp),%eax
  800766:	e8 54 fc ff ff       	call   8003bf <getuint>
			base =8;
  80076b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800770:	eb 40                	jmp    8007b2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800772:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800776:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80077d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800780:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800784:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80078b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8d 50 04             	lea    0x4(%eax),%edx
  800794:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800797:	8b 00                	mov    (%eax),%eax
  800799:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80079e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8007a3:	eb 0d                	jmp    8007b2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8007a8:	e8 12 fc ff ff       	call   8003bf <getuint>
			base = 16;
  8007ad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007b2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8007b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8007ba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8007bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007c5:	89 04 24             	mov    %eax,(%esp)
  8007c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007cc:	89 fa                	mov    %edi,%edx
  8007ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d1:	e8 fa fa ff ff       	call   8002d0 <printnum>
			break;
  8007d6:	e9 88 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007e5:	e9 79 fc ff ff       	jmp    800463 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007f5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007f8:	89 f3                	mov    %esi,%ebx
  8007fa:	eb 03                	jmp    8007ff <vprintfmt+0x3c1>
  8007fc:	83 eb 01             	sub    $0x1,%ebx
  8007ff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800803:	75 f7                	jne    8007fc <vprintfmt+0x3be>
  800805:	e9 59 fc ff ff       	jmp    800463 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80080a:	83 c4 3c             	add    $0x3c,%esp
  80080d:	5b                   	pop    %ebx
  80080e:	5e                   	pop    %esi
  80080f:	5f                   	pop    %edi
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	83 ec 28             	sub    $0x28,%esp
  800818:	8b 45 08             	mov    0x8(%ebp),%eax
  80081b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80081e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800821:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800825:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800828:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 30                	je     800863 <vsnprintf+0x51>
  800833:	85 d2                	test   %edx,%edx
  800835:	7e 2c                	jle    800863 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800837:	8b 45 14             	mov    0x14(%ebp),%eax
  80083a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 44 24 08          	mov    %eax,0x8(%esp)
  800845:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	c7 04 24 f9 03 80 00 	movl   $0x8003f9,(%esp)
  800853:	e8 e6 fb ff ff       	call   80043e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800858:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80085b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800861:	eb 05                	jmp    800868 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800863:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800870:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800873:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800877:	8b 45 10             	mov    0x10(%ebp),%eax
  80087a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800881:	89 44 24 04          	mov    %eax,0x4(%esp)
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	89 04 24             	mov    %eax,(%esp)
  80088b:	e8 82 ff ff ff       	call   800812 <vsnprintf>
	va_end(ap);

	return rc;
}
  800890:	c9                   	leave  
  800891:	c3                   	ret    
  800892:	66 90                	xchg   %ax,%ax
  800894:	66 90                	xchg   %ax,%ax
  800896:	66 90                	xchg   %ax,%ax
  800898:	66 90                	xchg   %ax,%ax
  80089a:	66 90                	xchg   %ax,%ax
  80089c:	66 90                	xchg   %ax,%ax
  80089e:	66 90                	xchg   %ax,%ax

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	eb 03                	jmp    8008b0 <strlen+0x10>
		n++;
  8008ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b4:	75 f7                	jne    8008ad <strlen+0xd>
		n++;
	return n;
}
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	eb 03                	jmp    8008cb <strnlen+0x13>
		n++;
  8008c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008cb:	39 d0                	cmp    %edx,%eax
  8008cd:	74 06                	je     8008d5 <strnlen+0x1d>
  8008cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008d3:	75 f3                	jne    8008c8 <strnlen+0x10>
		n++;
	return n;
}
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	53                   	push   %ebx
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e1:	89 c2                	mov    %eax,%edx
  8008e3:	83 c2 01             	add    $0x1,%edx
  8008e6:	83 c1 01             	add    $0x1,%ecx
  8008e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008f0:	84 db                	test   %bl,%bl
  8008f2:	75 ef                	jne    8008e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	83 ec 08             	sub    $0x8,%esp
  8008fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800901:	89 1c 24             	mov    %ebx,(%esp)
  800904:	e8 97 ff ff ff       	call   8008a0 <strlen>
	strcpy(dst + len, src);
  800909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800910:	01 d8                	add    %ebx,%eax
  800912:	89 04 24             	mov    %eax,(%esp)
  800915:	e8 bd ff ff ff       	call   8008d7 <strcpy>
	return dst;
}
  80091a:	89 d8                	mov    %ebx,%eax
  80091c:	83 c4 08             	add    $0x8,%esp
  80091f:	5b                   	pop    %ebx
  800920:	5d                   	pop    %ebp
  800921:	c3                   	ret    

00800922 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800922:	55                   	push   %ebp
  800923:	89 e5                	mov    %esp,%ebp
  800925:	56                   	push   %esi
  800926:	53                   	push   %ebx
  800927:	8b 75 08             	mov    0x8(%ebp),%esi
  80092a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80092d:	89 f3                	mov    %esi,%ebx
  80092f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800932:	89 f2                	mov    %esi,%edx
  800934:	eb 0f                	jmp    800945 <strncpy+0x23>
		*dst++ = *src;
  800936:	83 c2 01             	add    $0x1,%edx
  800939:	0f b6 01             	movzbl (%ecx),%eax
  80093c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093f:	80 39 01             	cmpb   $0x1,(%ecx)
  800942:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800945:	39 da                	cmp    %ebx,%edx
  800947:	75 ed                	jne    800936 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800949:	89 f0                	mov    %esi,%eax
  80094b:	5b                   	pop    %ebx
  80094c:	5e                   	pop    %esi
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	56                   	push   %esi
  800953:	53                   	push   %ebx
  800954:	8b 75 08             	mov    0x8(%ebp),%esi
  800957:	8b 55 0c             	mov    0xc(%ebp),%edx
  80095a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800963:	85 c9                	test   %ecx,%ecx
  800965:	75 0b                	jne    800972 <strlcpy+0x23>
  800967:	eb 1d                	jmp    800986 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800969:	83 c0 01             	add    $0x1,%eax
  80096c:	83 c2 01             	add    $0x1,%edx
  80096f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800972:	39 d8                	cmp    %ebx,%eax
  800974:	74 0b                	je     800981 <strlcpy+0x32>
  800976:	0f b6 0a             	movzbl (%edx),%ecx
  800979:	84 c9                	test   %cl,%cl
  80097b:	75 ec                	jne    800969 <strlcpy+0x1a>
  80097d:	89 c2                	mov    %eax,%edx
  80097f:	eb 02                	jmp    800983 <strlcpy+0x34>
  800981:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800983:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800986:	29 f0                	sub    %esi,%eax
}
  800988:	5b                   	pop    %ebx
  800989:	5e                   	pop    %esi
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800995:	eb 06                	jmp    80099d <strcmp+0x11>
		p++, q++;
  800997:	83 c1 01             	add    $0x1,%ecx
  80099a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80099d:	0f b6 01             	movzbl (%ecx),%eax
  8009a0:	84 c0                	test   %al,%al
  8009a2:	74 04                	je     8009a8 <strcmp+0x1c>
  8009a4:	3a 02                	cmp    (%edx),%al
  8009a6:	74 ef                	je     800997 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 c0             	movzbl %al,%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
}
  8009b0:	5d                   	pop    %ebp
  8009b1:	c3                   	ret    

008009b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b2:	55                   	push   %ebp
  8009b3:	89 e5                	mov    %esp,%ebp
  8009b5:	53                   	push   %ebx
  8009b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bc:	89 c3                	mov    %eax,%ebx
  8009be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c1:	eb 06                	jmp    8009c9 <strncmp+0x17>
		n--, p++, q++;
  8009c3:	83 c0 01             	add    $0x1,%eax
  8009c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009c9:	39 d8                	cmp    %ebx,%eax
  8009cb:	74 15                	je     8009e2 <strncmp+0x30>
  8009cd:	0f b6 08             	movzbl (%eax),%ecx
  8009d0:	84 c9                	test   %cl,%cl
  8009d2:	74 04                	je     8009d8 <strncmp+0x26>
  8009d4:	3a 0a                	cmp    (%edx),%cl
  8009d6:	74 eb                	je     8009c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d8:	0f b6 00             	movzbl (%eax),%eax
  8009db:	0f b6 12             	movzbl (%edx),%edx
  8009de:	29 d0                	sub    %edx,%eax
  8009e0:	eb 05                	jmp    8009e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f4:	eb 07                	jmp    8009fd <strchr+0x13>
		if (*s == c)
  8009f6:	38 ca                	cmp    %cl,%dl
  8009f8:	74 0f                	je     800a09 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 f2                	jne    8009f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	eb 07                	jmp    800a1e <strfind+0x13>
		if (*s == c)
  800a17:	38 ca                	cmp    %cl,%dl
  800a19:	74 0a                	je     800a25 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a1b:	83 c0 01             	add    $0x1,%eax
  800a1e:	0f b6 10             	movzbl (%eax),%edx
  800a21:	84 d2                	test   %dl,%dl
  800a23:	75 f2                	jne    800a17 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800a25:	5d                   	pop    %ebp
  800a26:	c3                   	ret    

00800a27 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a27:	55                   	push   %ebp
  800a28:	89 e5                	mov    %esp,%ebp
  800a2a:	57                   	push   %edi
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a30:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a33:	85 c9                	test   %ecx,%ecx
  800a35:	74 36                	je     800a6d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a37:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a3d:	75 28                	jne    800a67 <memset+0x40>
  800a3f:	f6 c1 03             	test   $0x3,%cl
  800a42:	75 23                	jne    800a67 <memset+0x40>
		c &= 0xFF;
  800a44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a48:	89 d3                	mov    %edx,%ebx
  800a4a:	c1 e3 08             	shl    $0x8,%ebx
  800a4d:	89 d6                	mov    %edx,%esi
  800a4f:	c1 e6 18             	shl    $0x18,%esi
  800a52:	89 d0                	mov    %edx,%eax
  800a54:	c1 e0 10             	shl    $0x10,%eax
  800a57:	09 f0                	or     %esi,%eax
  800a59:	09 c2                	or     %eax,%edx
  800a5b:	89 d0                	mov    %edx,%eax
  800a5d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a62:	fc                   	cld    
  800a63:	f3 ab                	rep stos %eax,%es:(%edi)
  800a65:	eb 06                	jmp    800a6d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6d:	89 f8                	mov    %edi,%eax
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a82:	39 c6                	cmp    %eax,%esi
  800a84:	73 35                	jae    800abb <memmove+0x47>
  800a86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a89:	39 d0                	cmp    %edx,%eax
  800a8b:	73 2e                	jae    800abb <memmove+0x47>
		s += n;
		d += n;
  800a8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a90:	89 d6                	mov    %edx,%esi
  800a92:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a94:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9a:	75 13                	jne    800aaf <memmove+0x3b>
  800a9c:	f6 c1 03             	test   $0x3,%cl
  800a9f:	75 0e                	jne    800aaf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aa1:	83 ef 04             	sub    $0x4,%edi
  800aa4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800aaa:	fd                   	std    
  800aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aad:	eb 09                	jmp    800ab8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aaf:	83 ef 01             	sub    $0x1,%edi
  800ab2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ab5:	fd                   	std    
  800ab6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab8:	fc                   	cld    
  800ab9:	eb 1d                	jmp    800ad8 <memmove+0x64>
  800abb:	89 f2                	mov    %esi,%edx
  800abd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800abf:	f6 c2 03             	test   $0x3,%dl
  800ac2:	75 0f                	jne    800ad3 <memmove+0x5f>
  800ac4:	f6 c1 03             	test   $0x3,%cl
  800ac7:	75 0a                	jne    800ad3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800acc:	89 c7                	mov    %eax,%edi
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ad1:	eb 05                	jmp    800ad8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	89 c7                	mov    %eax,%edi
  800ad5:	fc                   	cld    
  800ad6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad8:	5e                   	pop    %esi
  800ad9:	5f                   	pop    %edi
  800ada:	5d                   	pop    %ebp
  800adb:	c3                   	ret    

00800adc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aec:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	89 04 24             	mov    %eax,(%esp)
  800af6:	e8 79 ff ff ff       	call   800a74 <memmove>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 55 08             	mov    0x8(%ebp),%edx
  800b05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b08:	89 d6                	mov    %edx,%esi
  800b0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0d:	eb 1a                	jmp    800b29 <memcmp+0x2c>
		if (*s1 != *s2)
  800b0f:	0f b6 02             	movzbl (%edx),%eax
  800b12:	0f b6 19             	movzbl (%ecx),%ebx
  800b15:	38 d8                	cmp    %bl,%al
  800b17:	74 0a                	je     800b23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800b19:	0f b6 c0             	movzbl %al,%eax
  800b1c:	0f b6 db             	movzbl %bl,%ebx
  800b1f:	29 d8                	sub    %ebx,%eax
  800b21:	eb 0f                	jmp    800b32 <memcmp+0x35>
		s1++, s2++;
  800b23:	83 c2 01             	add    $0x1,%edx
  800b26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b29:	39 f2                	cmp    %esi,%edx
  800b2b:	75 e2                	jne    800b0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b44:	eb 07                	jmp    800b4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b46:	38 08                	cmp    %cl,(%eax)
  800b48:	74 07                	je     800b51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	39 d0                	cmp    %edx,%eax
  800b4f:	72 f5                	jb     800b46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5f:	eb 03                	jmp    800b64 <strtol+0x11>
		s++;
  800b61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b64:	0f b6 0a             	movzbl (%edx),%ecx
  800b67:	80 f9 09             	cmp    $0x9,%cl
  800b6a:	74 f5                	je     800b61 <strtol+0xe>
  800b6c:	80 f9 20             	cmp    $0x20,%cl
  800b6f:	74 f0                	je     800b61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b71:	80 f9 2b             	cmp    $0x2b,%cl
  800b74:	75 0a                	jne    800b80 <strtol+0x2d>
		s++;
  800b76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b79:	bf 00 00 00 00       	mov    $0x0,%edi
  800b7e:	eb 11                	jmp    800b91 <strtol+0x3e>
  800b80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b85:	80 f9 2d             	cmp    $0x2d,%cl
  800b88:	75 07                	jne    800b91 <strtol+0x3e>
		s++, neg = 1;
  800b8a:	8d 52 01             	lea    0x1(%edx),%edx
  800b8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b96:	75 15                	jne    800bad <strtol+0x5a>
  800b98:	80 3a 30             	cmpb   $0x30,(%edx)
  800b9b:	75 10                	jne    800bad <strtol+0x5a>
  800b9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ba1:	75 0a                	jne    800bad <strtol+0x5a>
		s += 2, base = 16;
  800ba3:	83 c2 02             	add    $0x2,%edx
  800ba6:	b8 10 00 00 00       	mov    $0x10,%eax
  800bab:	eb 10                	jmp    800bbd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800bad:	85 c0                	test   %eax,%eax
  800baf:	75 0c                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	80 3a 30             	cmpb   $0x30,(%edx)
  800bb6:	75 05                	jne    800bbd <strtol+0x6a>
		s++, base = 8;
  800bb8:	83 c2 01             	add    $0x1,%edx
  800bbb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bc2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800bc5:	0f b6 0a             	movzbl (%edx),%ecx
  800bc8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800bcb:	89 f0                	mov    %esi,%eax
  800bcd:	3c 09                	cmp    $0x9,%al
  800bcf:	77 08                	ja     800bd9 <strtol+0x86>
			dig = *s - '0';
  800bd1:	0f be c9             	movsbl %cl,%ecx
  800bd4:	83 e9 30             	sub    $0x30,%ecx
  800bd7:	eb 20                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800bd9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bdc:	89 f0                	mov    %esi,%eax
  800bde:	3c 19                	cmp    $0x19,%al
  800be0:	77 08                	ja     800bea <strtol+0x97>
			dig = *s - 'a' + 10;
  800be2:	0f be c9             	movsbl %cl,%ecx
  800be5:	83 e9 57             	sub    $0x57,%ecx
  800be8:	eb 0f                	jmp    800bf9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bed:	89 f0                	mov    %esi,%eax
  800bef:	3c 19                	cmp    $0x19,%al
  800bf1:	77 16                	ja     800c09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bf3:	0f be c9             	movsbl %cl,%ecx
  800bf6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bf9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bfc:	7d 0f                	jge    800c0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800c05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800c07:	eb bc                	jmp    800bc5 <strtol+0x72>
  800c09:	89 d8                	mov    %ebx,%eax
  800c0b:	eb 02                	jmp    800c0f <strtol+0xbc>
  800c0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800c0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c13:	74 05                	je     800c1a <strtol+0xc7>
		*endptr = (char *) s;
  800c15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800c1a:	f7 d8                	neg    %eax
  800c1c:	85 ff                	test   %edi,%edi
  800c1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	57                   	push   %edi
  800c2a:	56                   	push   %esi
  800c2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	89 c3                	mov    %eax,%ebx
  800c39:	89 c7                	mov    %eax,%edi
  800c3b:	89 c6                	mov    %eax,%esi
  800c3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c3f:	5b                   	pop    %ebx
  800c40:	5e                   	pop    %esi
  800c41:	5f                   	pop    %edi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	57                   	push   %edi
  800c48:	56                   	push   %esi
  800c49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c54:	89 d1                	mov    %edx,%ecx
  800c56:	89 d3                	mov    %edx,%ebx
  800c58:	89 d7                	mov    %edx,%edi
  800c5a:	89 d6                	mov    %edx,%esi
  800c5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c5e:	5b                   	pop    %ebx
  800c5f:	5e                   	pop    %esi
  800c60:	5f                   	pop    %edi
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	57                   	push   %edi
  800c67:	56                   	push   %esi
  800c68:	53                   	push   %ebx
  800c69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	8b 55 08             	mov    0x8(%ebp),%edx
  800c79:	89 cb                	mov    %ecx,%ebx
  800c7b:	89 cf                	mov    %ecx,%edi
  800c7d:	89 ce                	mov    %ecx,%esi
  800c7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c81:	85 c0                	test   %eax,%eax
  800c83:	7e 28                	jle    800cad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c90:	00 
  800c91:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800c98:	00 
  800c99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ca0:	00 
  800ca1:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ca8:	e8 06 f5 ff ff       	call   8001b3 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cad:	83 c4 2c             	add    $0x2c,%esp
  800cb0:	5b                   	pop    %ebx
  800cb1:	5e                   	pop    %esi
  800cb2:	5f                   	pop    %edi
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	57                   	push   %edi
  800cb9:	56                   	push   %esi
  800cba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800cc5:	89 d1                	mov    %edx,%ecx
  800cc7:	89 d3                	mov    %edx,%ebx
  800cc9:	89 d7                	mov    %edx,%edi
  800ccb:	89 d6                	mov    %edx,%esi
  800ccd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ccf:	5b                   	pop    %ebx
  800cd0:	5e                   	pop    %esi
  800cd1:	5f                   	pop    %edi
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <sys_yield>:

void
sys_yield(void)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	57                   	push   %edi
  800cd8:	56                   	push   %esi
  800cd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cda:	ba 00 00 00 00       	mov    $0x0,%edx
  800cdf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce4:	89 d1                	mov    %edx,%ecx
  800ce6:	89 d3                	mov    %edx,%ebx
  800ce8:	89 d7                	mov    %edx,%edi
  800cea:	89 d6                	mov    %edx,%esi
  800cec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cee:	5b                   	pop    %ebx
  800cef:	5e                   	pop    %esi
  800cf0:	5f                   	pop    %edi
  800cf1:	5d                   	pop    %ebp
  800cf2:	c3                   	ret    

00800cf3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	57                   	push   %edi
  800cf7:	56                   	push   %esi
  800cf8:	53                   	push   %ebx
  800cf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cfc:	be 00 00 00 00       	mov    $0x0,%esi
  800d01:	b8 04 00 00 00       	mov    $0x4,%eax
  800d06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d09:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0f:	89 f7                	mov    %esi,%edi
  800d11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d13:	85 c0                	test   %eax,%eax
  800d15:	7e 28                	jle    800d3f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800d22:	00 
  800d23:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800d2a:	00 
  800d2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d32:	00 
  800d33:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800d3a:	e8 74 f4 ff ff       	call   8001b3 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d3f:	83 c4 2c             	add    $0x2c,%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d50:	b8 05 00 00 00       	mov    $0x5,%eax
  800d55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d58:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d61:	8b 75 18             	mov    0x18(%ebp),%esi
  800d64:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d66:	85 c0                	test   %eax,%eax
  800d68:	7e 28                	jle    800d92 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d6e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d75:	00 
  800d76:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800d7d:	00 
  800d7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d85:	00 
  800d86:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800d8d:	e8 21 f4 ff ff       	call   8001b3 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d92:	83 c4 2c             	add    $0x2c,%esp
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
  800da0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	b8 06 00 00 00       	mov    $0x6,%eax
  800dad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db0:	8b 55 08             	mov    0x8(%ebp),%edx
  800db3:	89 df                	mov    %ebx,%edi
  800db5:	89 de                	mov    %ebx,%esi
  800db7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db9:	85 c0                	test   %eax,%eax
  800dbb:	7e 28                	jle    800de5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800dc8:	00 
  800dc9:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800dd0:	00 
  800dd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd8:	00 
  800dd9:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800de0:	e8 ce f3 ff ff       	call   8001b3 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	83 c4 2c             	add    $0x2c,%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    

00800ded <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	57                   	push   %edi
  800df1:	56                   	push   %esi
  800df2:	53                   	push   %ebx
  800df3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	89 df                	mov    %ebx,%edi
  800e08:	89 de                	mov    %ebx,%esi
  800e0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	7e 28                	jle    800e38 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800e1b:	00 
  800e1c:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800e23:	00 
  800e24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2b:	00 
  800e2c:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e33:	e8 7b f3 ff ff       	call   8001b3 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e38:	83 c4 2c             	add    $0x2c,%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5e                   	pop    %esi
  800e3d:	5f                   	pop    %edi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	57                   	push   %edi
  800e44:	56                   	push   %esi
  800e45:	53                   	push   %ebx
  800e46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e56:	8b 55 08             	mov    0x8(%ebp),%edx
  800e59:	89 df                	mov    %ebx,%edi
  800e5b:	89 de                	mov    %ebx,%esi
  800e5d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e5f:	85 c0                	test   %eax,%eax
  800e61:	7e 28                	jle    800e8b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e67:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e6e:	00 
  800e6f:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800e76:	00 
  800e77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7e:	00 
  800e7f:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e86:	e8 28 f3 ff ff       	call   8001b3 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8b:	83 c4 2c             	add    $0x2c,%esp
  800e8e:	5b                   	pop    %ebx
  800e8f:	5e                   	pop    %esi
  800e90:	5f                   	pop    %edi
  800e91:	5d                   	pop    %ebp
  800e92:	c3                   	ret    

00800e93 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e93:	55                   	push   %ebp
  800e94:	89 e5                	mov    %esp,%ebp
  800e96:	57                   	push   %edi
  800e97:	56                   	push   %esi
  800e98:	53                   	push   %ebx
  800e99:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eac:	89 df                	mov    %ebx,%edi
  800eae:	89 de                	mov    %ebx,%esi
  800eb0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eb2:	85 c0                	test   %eax,%eax
  800eb4:	7e 28                	jle    800ede <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ec1:	00 
  800ec2:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800ec9:	00 
  800eca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed1:	00 
  800ed2:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ed9:	e8 d5 f2 ff ff       	call   8001b3 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ede:	83 c4 2c             	add    $0x2c,%esp
  800ee1:	5b                   	pop    %ebx
  800ee2:	5e                   	pop    %esi
  800ee3:	5f                   	pop    %edi
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	57                   	push   %edi
  800eea:	56                   	push   %esi
  800eeb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eec:	be 00 00 00 00       	mov    $0x0,%esi
  800ef1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef9:	8b 55 08             	mov    0x8(%ebp),%edx
  800efc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f02:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    

00800f09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f09:	55                   	push   %ebp
  800f0a:	89 e5                	mov    %esp,%ebp
  800f0c:	57                   	push   %edi
  800f0d:	56                   	push   %esi
  800f0e:	53                   	push   %ebx
  800f0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	89 cb                	mov    %ecx,%ebx
  800f21:	89 cf                	mov    %ecx,%edi
  800f23:	89 ce                	mov    %ecx,%esi
  800f25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f27:	85 c0                	test   %eax,%eax
  800f29:	7e 28                	jle    800f53 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f2f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f36:	00 
  800f37:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800f3e:	00 
  800f3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f46:	00 
  800f47:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800f4e:	e8 60 f2 ff ff       	call   8001b3 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f53:	83 c4 2c             	add    $0x2c,%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f61:	ba 00 00 00 00       	mov    $0x0,%edx
  800f66:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6b:	89 d1                	mov    %edx,%ecx
  800f6d:	89 d3                	mov    %edx,%ebx
  800f6f:	89 d7                	mov    %edx,%edi
  800f71:	89 d6                	mov    %edx,%esi
  800f73:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f75:	5b                   	pop    %ebx
  800f76:	5e                   	pop    %esi
  800f77:	5f                   	pop    %edi
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    

00800f7a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
  800f7d:	57                   	push   %edi
  800f7e:	56                   	push   %esi
  800f7f:	53                   	push   %ebx
  800f80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f88:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	8b 55 08             	mov    0x8(%ebp),%edx
  800f93:	89 df                	mov    %ebx,%edi
  800f95:	89 de                	mov    %ebx,%esi
  800f97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	7e 28                	jle    800fc5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fa8:	00 
  800fa9:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800fb0:	00 
  800fb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb8:	00 
  800fb9:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800fc0:	e8 ee f1 ff ff       	call   8001b3 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800fc5:	83 c4 2c             	add    $0x2c,%esp
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7e 28                	jle    801018 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801003:	00 
  801004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100b:	00 
  80100c:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801013:	e8 9b f1 ff ff       	call   8001b3 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  801018:	83 c4 2c             	add    $0x2c,%esp
  80101b:	5b                   	pop    %ebx
  80101c:	5e                   	pop    %esi
  80101d:	5f                   	pop    %edi
  80101e:	5d                   	pop    %ebp
  80101f:	c3                   	ret    

00801020 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801020:	55                   	push   %ebp
  801021:	89 e5                	mov    %esp,%ebp
  801023:	53                   	push   %ebx
  801024:	83 ec 24             	sub    $0x24,%esp
  801027:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  80102a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  80102c:	89 d3                	mov    %edx,%ebx
  80102e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  801034:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801038:	74 1a                	je     801054 <pgfault+0x34>
  80103a:	c1 ea 0c             	shr    $0xc,%edx
  80103d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801044:	a8 01                	test   $0x1,%al
  801046:	74 0c                	je     801054 <pgfault+0x34>
  801048:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80104f:	f6 c4 08             	test   $0x8,%ah
  801052:	75 1c                	jne    801070 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801054:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  80106b:	e8 43 f1 ff ff       	call   8001b3 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801070:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801077:	00 
  801078:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80107f:	00 
  801080:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801087:	e8 67 fc ff ff       	call   800cf3 <sys_page_alloc>
  80108c:	85 c0                	test   %eax,%eax
  80108e:	79 1c                	jns    8010ac <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801090:	c7 44 24 08 70 2e 80 	movl   $0x802e70,0x8(%esp)
  801097:	00 
  801098:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80109f:	00 
  8010a0:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  8010a7:	e8 07 f1 ff ff       	call   8001b3 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  8010ac:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8010b3:	00 
  8010b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010b8:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8010bf:	e8 18 fa ff ff       	call   800adc <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  8010c4:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8010cb:	00 
  8010cc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8010d0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010d7:	00 
  8010d8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010df:	00 
  8010e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010e7:	e8 5b fc ff ff       	call   800d47 <sys_page_map>
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	74 1c                	je     80110c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8010f0:	c7 44 24 08 86 2f 80 	movl   $0x802f86,0x8(%esp)
  8010f7:	00 
  8010f8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8010ff:	00 
  801100:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  801107:	e8 a7 f0 ff ff       	call   8001b3 <_panic>
    sys_page_unmap(0,PFTEMP);
  80110c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80111b:	e8 7a fc ff ff       	call   800d9a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801120:	83 c4 24             	add    $0x24,%esp
  801123:	5b                   	pop    %ebx
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
  80112c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80112f:	c7 04 24 20 10 80 00 	movl   $0x801020,(%esp)
  801136:	e8 fb 15 00 00       	call   802736 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80113b:	b8 07 00 00 00       	mov    $0x7,%eax
  801140:	cd 30                	int    $0x30
  801142:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801145:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801147:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114c:	85 c0                	test   %eax,%eax
  80114e:	75 21                	jne    801171 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801150:	e8 60 fb ff ff       	call   800cb5 <sys_getenvid>
  801155:	25 ff 03 00 00       	and    $0x3ff,%eax
  80115a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80115d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801162:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  801167:	b8 00 00 00 00       	mov    $0x0,%eax
  80116c:	e9 de 01 00 00       	jmp    80134f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801171:	89 d8                	mov    %ebx,%eax
  801173:	c1 e8 16             	shr    $0x16,%eax
  801176:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80117d:	a8 01                	test   $0x1,%al
  80117f:	0f 84 58 01 00 00    	je     8012dd <fork+0x1b7>
  801185:	89 de                	mov    %ebx,%esi
  801187:	c1 ee 0c             	shr    $0xc,%esi
  80118a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801191:	83 e0 05             	and    $0x5,%eax
  801194:	83 f8 05             	cmp    $0x5,%eax
  801197:	0f 85 40 01 00 00    	jne    8012dd <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80119d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011a4:	f6 c4 04             	test   $0x4,%ah
  8011a7:	74 4f                	je     8011f8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  8011a9:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011b0:	c1 e6 0c             	shl    $0xc,%esi
  8011b3:	25 07 0e 00 00       	and    $0xe07,%eax
  8011b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bc:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011cf:	e8 73 fb ff ff       	call   800d47 <sys_page_map>
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	0f 89 01 01 00 00    	jns    8012dd <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  8011dc:	c7 44 24 08 90 2e 80 	movl   $0x802e90,0x8(%esp)
  8011e3:	00 
  8011e4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8011eb:	00 
  8011ec:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  8011f3:	e8 bb ef ff ff       	call   8001b3 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8011f8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ff:	a8 02                	test   $0x2,%al
  801201:	75 10                	jne    801213 <fork+0xed>
  801203:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80120a:	f6 c4 08             	test   $0x8,%ah
  80120d:	0f 84 87 00 00 00    	je     80129a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801213:	c1 e6 0c             	shl    $0xc,%esi
  801216:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80121d:	00 
  80121e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801222:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801226:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801231:	e8 11 fb ff ff       	call   800d47 <sys_page_map>
  801236:	85 c0                	test   %eax,%eax
  801238:	79 1c                	jns    801256 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80123a:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801241:	00 
  801242:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801249:	00 
  80124a:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  801251:	e8 5d ef ff ff       	call   8001b3 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801256:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80125d:	00 
  80125e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801262:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801269:	00 
  80126a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801275:	e8 cd fa ff ff       	call   800d47 <sys_page_map>
  80127a:	85 c0                	test   %eax,%eax
  80127c:	79 5f                	jns    8012dd <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80127e:	c7 44 24 08 00 2f 80 	movl   $0x802f00,0x8(%esp)
  801285:	00 
  801286:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80128d:	00 
  80128e:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  801295:	e8 19 ef ff ff       	call   8001b3 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80129a:	c1 e6 0c             	shl    $0xc,%esi
  80129d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  8012a4:	00 
  8012a5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012a9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8012ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b8:	e8 8a fa ff ff       	call   800d47 <sys_page_map>
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	74 1c                	je     8012dd <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  8012c1:	c7 44 24 08 28 2f 80 	movl   $0x802f28,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  8012d8:	e8 d6 ee ff ff       	call   8001b3 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  8012dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012e3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012e9:	0f 85 82 fe ff ff    	jne    801171 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8012ef:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012f6:	00 
  8012f7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012fe:	ee 
  8012ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801302:	89 04 24             	mov    %eax,(%esp)
  801305:	e8 e9 f9 ff ff       	call   800cf3 <sys_page_alloc>
  80130a:	85 c0                	test   %eax,%eax
  80130c:	79 1c                	jns    80132a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80130e:	c7 44 24 08 5c 2f 80 	movl   $0x802f5c,0x8(%esp)
  801315:	00 
  801316:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80131d:	00 
  80131e:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  801325:	e8 89 ee ff ff       	call   8001b3 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80132a:	c7 44 24 04 a7 27 80 	movl   $0x8027a7,0x4(%esp)
  801331:	00 
  801332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801335:	89 3c 24             	mov    %edi,(%esp)
  801338:	e8 56 fb ff ff       	call   800e93 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80133d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801344:	00 
  801345:	89 3c 24             	mov    %edi,(%esp)
  801348:	e8 a0 fa ff ff       	call   800ded <sys_env_set_status>
		return child;
  80134d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80134f:	83 c4 2c             	add    $0x2c,%esp
  801352:	5b                   	pop    %ebx
  801353:	5e                   	pop    %esi
  801354:	5f                   	pop    %edi
  801355:	5d                   	pop    %ebp
  801356:	c3                   	ret    

00801357 <sfork>:

// Challenge!
int
sfork(void)
{
  801357:	55                   	push   %ebp
  801358:	89 e5                	mov    %esp,%ebp
  80135a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80135d:	c7 44 24 08 a4 2f 80 	movl   $0x802fa4,0x8(%esp)
  801364:	00 
  801365:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80136c:	00 
  80136d:	c7 04 24 7b 2f 80 00 	movl   $0x802f7b,(%esp)
  801374:	e8 3a ee ff ff       	call   8001b3 <_panic>

00801379 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801379:	55                   	push   %ebp
  80137a:	89 e5                	mov    %esp,%ebp
  80137c:	56                   	push   %esi
  80137d:	53                   	push   %ebx
  80137e:	83 ec 10             	sub    $0x10,%esp
  801381:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801384:	8b 45 0c             	mov    0xc(%ebp),%eax
  801387:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80138a:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80138c:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  801391:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  801394:	89 04 24             	mov    %eax,(%esp)
  801397:	e8 6d fb ff ff       	call   800f09 <sys_ipc_recv>
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 1e                	jne    8013be <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8013a0:	85 db                	test   %ebx,%ebx
  8013a2:	74 0a                	je     8013ae <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8013a4:	a1 08 50 80 00       	mov    0x805008,%eax
  8013a9:	8b 40 74             	mov    0x74(%eax),%eax
  8013ac:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8013ae:	85 f6                	test   %esi,%esi
  8013b0:	74 22                	je     8013d4 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8013b2:	a1 08 50 80 00       	mov    0x805008,%eax
  8013b7:	8b 40 78             	mov    0x78(%eax),%eax
  8013ba:	89 06                	mov    %eax,(%esi)
  8013bc:	eb 16                	jmp    8013d4 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8013be:	85 f6                	test   %esi,%esi
  8013c0:	74 06                	je     8013c8 <ipc_recv+0x4f>
				*perm_store = 0;
  8013c2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8013c8:	85 db                	test   %ebx,%ebx
  8013ca:	74 10                	je     8013dc <ipc_recv+0x63>
				*from_env_store=0;
  8013cc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013d2:	eb 08                	jmp    8013dc <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8013d4:	a1 08 50 80 00       	mov    0x805008,%eax
  8013d9:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8013dc:	83 c4 10             	add    $0x10,%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	57                   	push   %edi
  8013e7:	56                   	push   %esi
  8013e8:	53                   	push   %ebx
  8013e9:	83 ec 1c             	sub    $0x1c,%esp
  8013ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013ef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013f2:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8013f5:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8013f7:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8013fc:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8013ff:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801403:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801407:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140b:	8b 45 08             	mov    0x8(%ebp),%eax
  80140e:	89 04 24             	mov    %eax,(%esp)
  801411:	e8 d0 fa ff ff       	call   800ee6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  801416:	eb 1c                	jmp    801434 <ipc_send+0x51>
	{
		sys_yield();
  801418:	e8 b7 f8 ff ff       	call   800cd4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80141d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801421:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801425:	89 74 24 04          	mov    %esi,0x4(%esp)
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	89 04 24             	mov    %eax,(%esp)
  80142f:	e8 b2 fa ff ff       	call   800ee6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801434:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801437:	74 df                	je     801418 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801439:	83 c4 1c             	add    $0x1c,%esp
  80143c:	5b                   	pop    %ebx
  80143d:	5e                   	pop    %esi
  80143e:	5f                   	pop    %edi
  80143f:	5d                   	pop    %ebp
  801440:	c3                   	ret    

00801441 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801441:	55                   	push   %ebp
  801442:	89 e5                	mov    %esp,%ebp
  801444:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801447:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80144c:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80144f:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801455:	8b 52 50             	mov    0x50(%edx),%edx
  801458:	39 ca                	cmp    %ecx,%edx
  80145a:	75 0d                	jne    801469 <ipc_find_env+0x28>
			return envs[i].env_id;
  80145c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80145f:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  801464:	8b 40 40             	mov    0x40(%eax),%eax
  801467:	eb 0e                	jmp    801477 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  801469:	83 c0 01             	add    $0x1,%eax
  80146c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801471:	75 d9                	jne    80144c <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  801473:	66 b8 00 00          	mov    $0x0,%ax
}
  801477:	5d                   	pop    %ebp
  801478:	c3                   	ret    
  801479:	66 90                	xchg   %ax,%ax
  80147b:	66 90                	xchg   %ax,%ax
  80147d:	66 90                	xchg   %ax,%ax
  80147f:	90                   	nop

00801480 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	05 00 00 00 30       	add    $0x30000000,%eax
  80148b:	c1 e8 0c             	shr    $0xc,%eax
}
  80148e:	5d                   	pop    %ebp
  80148f:	c3                   	ret    

00801490 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801493:	8b 45 08             	mov    0x8(%ebp),%eax
  801496:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80149b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8014a5:	5d                   	pop    %ebp
  8014a6:	c3                   	ret    

008014a7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014a7:	55                   	push   %ebp
  8014a8:	89 e5                	mov    %esp,%ebp
  8014aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014ad:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8014b2:	89 c2                	mov    %eax,%edx
  8014b4:	c1 ea 16             	shr    $0x16,%edx
  8014b7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014be:	f6 c2 01             	test   $0x1,%dl
  8014c1:	74 11                	je     8014d4 <fd_alloc+0x2d>
  8014c3:	89 c2                	mov    %eax,%edx
  8014c5:	c1 ea 0c             	shr    $0xc,%edx
  8014c8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014cf:	f6 c2 01             	test   $0x1,%dl
  8014d2:	75 09                	jne    8014dd <fd_alloc+0x36>
			*fd_store = fd;
  8014d4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014db:	eb 17                	jmp    8014f4 <fd_alloc+0x4d>
  8014dd:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014e2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014e7:	75 c9                	jne    8014b2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014e9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8014ef:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8014f4:	5d                   	pop    %ebp
  8014f5:	c3                   	ret    

008014f6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014fc:	83 f8 1f             	cmp    $0x1f,%eax
  8014ff:	77 36                	ja     801537 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801501:	c1 e0 0c             	shl    $0xc,%eax
  801504:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801509:	89 c2                	mov    %eax,%edx
  80150b:	c1 ea 16             	shr    $0x16,%edx
  80150e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801515:	f6 c2 01             	test   $0x1,%dl
  801518:	74 24                	je     80153e <fd_lookup+0x48>
  80151a:	89 c2                	mov    %eax,%edx
  80151c:	c1 ea 0c             	shr    $0xc,%edx
  80151f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801526:	f6 c2 01             	test   $0x1,%dl
  801529:	74 1a                	je     801545 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80152b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80152e:	89 02                	mov    %eax,(%edx)
	return 0;
  801530:	b8 00 00 00 00       	mov    $0x0,%eax
  801535:	eb 13                	jmp    80154a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801537:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80153c:	eb 0c                	jmp    80154a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80153e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801543:	eb 05                	jmp    80154a <fd_lookup+0x54>
  801545:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80154a:	5d                   	pop    %ebp
  80154b:	c3                   	ret    

0080154c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80154c:	55                   	push   %ebp
  80154d:	89 e5                	mov    %esp,%ebp
  80154f:	83 ec 18             	sub    $0x18,%esp
  801552:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801555:	ba 00 00 00 00       	mov    $0x0,%edx
  80155a:	eb 13                	jmp    80156f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80155c:	39 08                	cmp    %ecx,(%eax)
  80155e:	75 0c                	jne    80156c <dev_lookup+0x20>
			*dev = devtab[i];
  801560:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801563:	89 01                	mov    %eax,(%ecx)
			return 0;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
  80156a:	eb 38                	jmp    8015a4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80156c:	83 c2 01             	add    $0x1,%edx
  80156f:	8b 04 95 38 30 80 00 	mov    0x803038(,%edx,4),%eax
  801576:	85 c0                	test   %eax,%eax
  801578:	75 e2                	jne    80155c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80157a:	a1 08 50 80 00       	mov    0x805008,%eax
  80157f:	8b 40 48             	mov    0x48(%eax),%eax
  801582:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158a:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  801591:	e8 16 ed ff ff       	call   8002ac <cprintf>
	*dev = 0;
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80159f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015a4:	c9                   	leave  
  8015a5:	c3                   	ret    

008015a6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	56                   	push   %esi
  8015aa:	53                   	push   %ebx
  8015ab:	83 ec 20             	sub    $0x20,%esp
  8015ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8015b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8015bb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8015c1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015c4:	89 04 24             	mov    %eax,(%esp)
  8015c7:	e8 2a ff ff ff       	call   8014f6 <fd_lookup>
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 05                	js     8015d5 <fd_close+0x2f>
	    || fd != fd2)
  8015d0:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015d3:	74 0c                	je     8015e1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  8015d5:	84 db                	test   %bl,%bl
  8015d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dc:	0f 44 c2             	cmove  %edx,%eax
  8015df:	eb 3f                	jmp    801620 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8015e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e8:	8b 06                	mov    (%esi),%eax
  8015ea:	89 04 24             	mov    %eax,(%esp)
  8015ed:	e8 5a ff ff ff       	call   80154c <dev_lookup>
  8015f2:	89 c3                	mov    %eax,%ebx
  8015f4:	85 c0                	test   %eax,%eax
  8015f6:	78 16                	js     80160e <fd_close+0x68>
		if (dev->dev_close)
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8015fe:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801603:	85 c0                	test   %eax,%eax
  801605:	74 07                	je     80160e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801607:	89 34 24             	mov    %esi,(%esp)
  80160a:	ff d0                	call   *%eax
  80160c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80160e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801612:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801619:	e8 7c f7 ff ff       	call   800d9a <sys_page_unmap>
	return r;
  80161e:	89 d8                	mov    %ebx,%eax
}
  801620:	83 c4 20             	add    $0x20,%esp
  801623:	5b                   	pop    %ebx
  801624:	5e                   	pop    %esi
  801625:	5d                   	pop    %ebp
  801626:	c3                   	ret    

00801627 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801627:	55                   	push   %ebp
  801628:	89 e5                	mov    %esp,%ebp
  80162a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80162d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801630:	89 44 24 04          	mov    %eax,0x4(%esp)
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	89 04 24             	mov    %eax,(%esp)
  80163a:	e8 b7 fe ff ff       	call   8014f6 <fd_lookup>
  80163f:	89 c2                	mov    %eax,%edx
  801641:	85 d2                	test   %edx,%edx
  801643:	78 13                	js     801658 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801645:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80164c:	00 
  80164d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801650:	89 04 24             	mov    %eax,(%esp)
  801653:	e8 4e ff ff ff       	call   8015a6 <fd_close>
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <close_all>:

void
close_all(void)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801661:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801666:	89 1c 24             	mov    %ebx,(%esp)
  801669:	e8 b9 ff ff ff       	call   801627 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80166e:	83 c3 01             	add    $0x1,%ebx
  801671:	83 fb 20             	cmp    $0x20,%ebx
  801674:	75 f0                	jne    801666 <close_all+0xc>
		close(i);
}
  801676:	83 c4 14             	add    $0x14,%esp
  801679:	5b                   	pop    %ebx
  80167a:	5d                   	pop    %ebp
  80167b:	c3                   	ret    

0080167c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801685:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801688:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168c:	8b 45 08             	mov    0x8(%ebp),%eax
  80168f:	89 04 24             	mov    %eax,(%esp)
  801692:	e8 5f fe ff ff       	call   8014f6 <fd_lookup>
  801697:	89 c2                	mov    %eax,%edx
  801699:	85 d2                	test   %edx,%edx
  80169b:	0f 88 e1 00 00 00    	js     801782 <dup+0x106>
		return r;
	close(newfdnum);
  8016a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a4:	89 04 24             	mov    %eax,(%esp)
  8016a7:	e8 7b ff ff ff       	call   801627 <close>

	newfd = INDEX2FD(newfdnum);
  8016ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8016af:	c1 e3 0c             	shl    $0xc,%ebx
  8016b2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8016b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016bb:	89 04 24             	mov    %eax,(%esp)
  8016be:	e8 cd fd ff ff       	call   801490 <fd2data>
  8016c3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8016c5:	89 1c 24             	mov    %ebx,(%esp)
  8016c8:	e8 c3 fd ff ff       	call   801490 <fd2data>
  8016cd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8016cf:	89 f0                	mov    %esi,%eax
  8016d1:	c1 e8 16             	shr    $0x16,%eax
  8016d4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8016db:	a8 01                	test   $0x1,%al
  8016dd:	74 43                	je     801722 <dup+0xa6>
  8016df:	89 f0                	mov    %esi,%eax
  8016e1:	c1 e8 0c             	shr    $0xc,%eax
  8016e4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8016eb:	f6 c2 01             	test   $0x1,%dl
  8016ee:	74 32                	je     801722 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016f0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8016fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  801700:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801704:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80170b:	00 
  80170c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801717:	e8 2b f6 ff ff       	call   800d47 <sys_page_map>
  80171c:	89 c6                	mov    %eax,%esi
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 3e                	js     801760 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801725:	89 c2                	mov    %eax,%edx
  801727:	c1 ea 0c             	shr    $0xc,%edx
  80172a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801731:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801737:	89 54 24 10          	mov    %edx,0x10(%esp)
  80173b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80173f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801746:	00 
  801747:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801752:	e8 f0 f5 ff ff       	call   800d47 <sys_page_map>
  801757:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801759:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80175c:	85 f6                	test   %esi,%esi
  80175e:	79 22                	jns    801782 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801764:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80176b:	e8 2a f6 ff ff       	call   800d9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801770:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801774:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80177b:	e8 1a f6 ff ff       	call   800d9a <sys_page_unmap>
	return r;
  801780:	89 f0                	mov    %esi,%eax
}
  801782:	83 c4 3c             	add    $0x3c,%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 24             	sub    $0x24,%esp
  801791:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801794:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	89 1c 24             	mov    %ebx,(%esp)
  80179e:	e8 53 fd ff ff       	call   8014f6 <fd_lookup>
  8017a3:	89 c2                	mov    %eax,%edx
  8017a5:	85 d2                	test   %edx,%edx
  8017a7:	78 6d                	js     801816 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	8b 00                	mov    (%eax),%eax
  8017b5:	89 04 24             	mov    %eax,(%esp)
  8017b8:	e8 8f fd ff ff       	call   80154c <dev_lookup>
  8017bd:	85 c0                	test   %eax,%eax
  8017bf:	78 55                	js     801816 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c4:	8b 50 08             	mov    0x8(%eax),%edx
  8017c7:	83 e2 03             	and    $0x3,%edx
  8017ca:	83 fa 01             	cmp    $0x1,%edx
  8017cd:	75 23                	jne    8017f2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8017cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8017d4:	8b 40 48             	mov    0x48(%eax),%eax
  8017d7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017df:	c7 04 24 fd 2f 80 00 	movl   $0x802ffd,(%esp)
  8017e6:	e8 c1 ea ff ff       	call   8002ac <cprintf>
		return -E_INVAL;
  8017eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f0:	eb 24                	jmp    801816 <read+0x8c>
	}
	if (!dev->dev_read)
  8017f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f5:	8b 52 08             	mov    0x8(%edx),%edx
  8017f8:	85 d2                	test   %edx,%edx
  8017fa:	74 15                	je     801811 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017fc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801803:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801806:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80180a:	89 04 24             	mov    %eax,(%esp)
  80180d:	ff d2                	call   *%edx
  80180f:	eb 05                	jmp    801816 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801811:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801816:	83 c4 24             	add    $0x24,%esp
  801819:	5b                   	pop    %ebx
  80181a:	5d                   	pop    %ebp
  80181b:	c3                   	ret    

0080181c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80181c:	55                   	push   %ebp
  80181d:	89 e5                	mov    %esp,%ebp
  80181f:	57                   	push   %edi
  801820:	56                   	push   %esi
  801821:	53                   	push   %ebx
  801822:	83 ec 1c             	sub    $0x1c,%esp
  801825:	8b 7d 08             	mov    0x8(%ebp),%edi
  801828:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80182b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801830:	eb 23                	jmp    801855 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801832:	89 f0                	mov    %esi,%eax
  801834:	29 d8                	sub    %ebx,%eax
  801836:	89 44 24 08          	mov    %eax,0x8(%esp)
  80183a:	89 d8                	mov    %ebx,%eax
  80183c:	03 45 0c             	add    0xc(%ebp),%eax
  80183f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801843:	89 3c 24             	mov    %edi,(%esp)
  801846:	e8 3f ff ff ff       	call   80178a <read>
		if (m < 0)
  80184b:	85 c0                	test   %eax,%eax
  80184d:	78 10                	js     80185f <readn+0x43>
			return m;
		if (m == 0)
  80184f:	85 c0                	test   %eax,%eax
  801851:	74 0a                	je     80185d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801853:	01 c3                	add    %eax,%ebx
  801855:	39 f3                	cmp    %esi,%ebx
  801857:	72 d9                	jb     801832 <readn+0x16>
  801859:	89 d8                	mov    %ebx,%eax
  80185b:	eb 02                	jmp    80185f <readn+0x43>
  80185d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80185f:	83 c4 1c             	add    $0x1c,%esp
  801862:	5b                   	pop    %ebx
  801863:	5e                   	pop    %esi
  801864:	5f                   	pop    %edi
  801865:	5d                   	pop    %ebp
  801866:	c3                   	ret    

00801867 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 24             	sub    $0x24,%esp
  80186e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801871:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801874:	89 44 24 04          	mov    %eax,0x4(%esp)
  801878:	89 1c 24             	mov    %ebx,(%esp)
  80187b:	e8 76 fc ff ff       	call   8014f6 <fd_lookup>
  801880:	89 c2                	mov    %eax,%edx
  801882:	85 d2                	test   %edx,%edx
  801884:	78 68                	js     8018ee <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801886:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801889:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801890:	8b 00                	mov    (%eax),%eax
  801892:	89 04 24             	mov    %eax,(%esp)
  801895:	e8 b2 fc ff ff       	call   80154c <dev_lookup>
  80189a:	85 c0                	test   %eax,%eax
  80189c:	78 50                	js     8018ee <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80189e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018a5:	75 23                	jne    8018ca <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8018a7:	a1 08 50 80 00       	mov    0x805008,%eax
  8018ac:	8b 40 48             	mov    0x48(%eax),%eax
  8018af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b7:	c7 04 24 19 30 80 00 	movl   $0x803019,(%esp)
  8018be:	e8 e9 e9 ff ff       	call   8002ac <cprintf>
		return -E_INVAL;
  8018c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018c8:	eb 24                	jmp    8018ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018cd:	8b 52 0c             	mov    0xc(%edx),%edx
  8018d0:	85 d2                	test   %edx,%edx
  8018d2:	74 15                	je     8018e9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018d4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8018db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018de:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018e2:	89 04 24             	mov    %eax,(%esp)
  8018e5:	ff d2                	call   *%edx
  8018e7:	eb 05                	jmp    8018ee <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8018e9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8018ee:	83 c4 24             	add    $0x24,%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5d                   	pop    %ebp
  8018f3:	c3                   	ret    

008018f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801901:	8b 45 08             	mov    0x8(%ebp),%eax
  801904:	89 04 24             	mov    %eax,(%esp)
  801907:	e8 ea fb ff ff       	call   8014f6 <fd_lookup>
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 0e                	js     80191e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801913:	8b 55 0c             	mov    0xc(%ebp),%edx
  801916:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80191e:	c9                   	leave  
  80191f:	c3                   	ret    

00801920 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801920:	55                   	push   %ebp
  801921:	89 e5                	mov    %esp,%ebp
  801923:	53                   	push   %ebx
  801924:	83 ec 24             	sub    $0x24,%esp
  801927:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80192a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	89 1c 24             	mov    %ebx,(%esp)
  801934:	e8 bd fb ff ff       	call   8014f6 <fd_lookup>
  801939:	89 c2                	mov    %eax,%edx
  80193b:	85 d2                	test   %edx,%edx
  80193d:	78 61                	js     8019a0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80193f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801942:	89 44 24 04          	mov    %eax,0x4(%esp)
  801946:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801949:	8b 00                	mov    (%eax),%eax
  80194b:	89 04 24             	mov    %eax,(%esp)
  80194e:	e8 f9 fb ff ff       	call   80154c <dev_lookup>
  801953:	85 c0                	test   %eax,%eax
  801955:	78 49                	js     8019a0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80195e:	75 23                	jne    801983 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801960:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801965:	8b 40 48             	mov    0x48(%eax),%eax
  801968:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80196c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801970:	c7 04 24 dc 2f 80 00 	movl   $0x802fdc,(%esp)
  801977:	e8 30 e9 ff ff       	call   8002ac <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80197c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801981:	eb 1d                	jmp    8019a0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801983:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801986:	8b 52 18             	mov    0x18(%edx),%edx
  801989:	85 d2                	test   %edx,%edx
  80198b:	74 0e                	je     80199b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80198d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801990:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801994:	89 04 24             	mov    %eax,(%esp)
  801997:	ff d2                	call   *%edx
  801999:	eb 05                	jmp    8019a0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80199b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8019a0:	83 c4 24             	add    $0x24,%esp
  8019a3:	5b                   	pop    %ebx
  8019a4:	5d                   	pop    %ebp
  8019a5:	c3                   	ret    

008019a6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	53                   	push   %ebx
  8019aa:	83 ec 24             	sub    $0x24,%esp
  8019ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	89 04 24             	mov    %eax,(%esp)
  8019bd:	e8 34 fb ff ff       	call   8014f6 <fd_lookup>
  8019c2:	89 c2                	mov    %eax,%edx
  8019c4:	85 d2                	test   %edx,%edx
  8019c6:	78 52                	js     801a1a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019d2:	8b 00                	mov    (%eax),%eax
  8019d4:	89 04 24             	mov    %eax,(%esp)
  8019d7:	e8 70 fb ff ff       	call   80154c <dev_lookup>
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 3a                	js     801a1a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8019e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8019e7:	74 2c                	je     801a15 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019f3:	00 00 00 
	stat->st_isdir = 0;
  8019f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019fd:	00 00 00 
	stat->st_dev = dev;
  801a00:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a06:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0d:	89 14 24             	mov    %edx,(%esp)
  801a10:	ff 50 14             	call   *0x14(%eax)
  801a13:	eb 05                	jmp    801a1a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801a15:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  801a1a:	83 c4 24             	add    $0x24,%esp
  801a1d:	5b                   	pop    %ebx
  801a1e:	5d                   	pop    %ebp
  801a1f:	c3                   	ret    

00801a20 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	56                   	push   %esi
  801a24:	53                   	push   %ebx
  801a25:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a2f:	00 
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	89 04 24             	mov    %eax,(%esp)
  801a36:	e8 28 02 00 00       	call   801c63 <open>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	85 db                	test   %ebx,%ebx
  801a3f:	78 1b                	js     801a5c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801a41:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a48:	89 1c 24             	mov    %ebx,(%esp)
  801a4b:	e8 56 ff ff ff       	call   8019a6 <fstat>
  801a50:	89 c6                	mov    %eax,%esi
	close(fd);
  801a52:	89 1c 24             	mov    %ebx,(%esp)
  801a55:	e8 cd fb ff ff       	call   801627 <close>
	return r;
  801a5a:	89 f0                	mov    %esi,%eax
}
  801a5c:	83 c4 10             	add    $0x10,%esp
  801a5f:	5b                   	pop    %ebx
  801a60:	5e                   	pop    %esi
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	83 ec 10             	sub    $0x10,%esp
  801a6b:	89 c6                	mov    %eax,%esi
  801a6d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a6f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801a76:	75 11                	jne    801a89 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801a78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801a7f:	e8 bd f9 ff ff       	call   801441 <ipc_find_env>
  801a84:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a89:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a90:	00 
  801a91:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a98:	00 
  801a99:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a9d:	a1 00 50 80 00       	mov    0x805000,%eax
  801aa2:	89 04 24             	mov    %eax,(%esp)
  801aa5:	e8 39 f9 ff ff       	call   8013e3 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aaa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ab1:	00 
  801ab2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ab6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801abd:	e8 b7 f8 ff ff       	call   801379 <ipc_recv>
}
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    

00801ac9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ad5:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  801add:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ae2:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae7:	b8 02 00 00 00       	mov    $0x2,%eax
  801aec:	e8 72 ff ff ff       	call   801a63 <fsipc>
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
  801af6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	8b 40 0c             	mov    0xc(%eax),%eax
  801aff:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b04:	ba 00 00 00 00       	mov    $0x0,%edx
  801b09:	b8 06 00 00 00       	mov    $0x6,%eax
  801b0e:	e8 50 ff ff ff       	call   801a63 <fsipc>
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	53                   	push   %ebx
  801b19:	83 ec 14             	sub    $0x14,%esp
  801b1c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b22:	8b 40 0c             	mov    0xc(%eax),%eax
  801b25:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b2a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2f:	b8 05 00 00 00       	mov    $0x5,%eax
  801b34:	e8 2a ff ff ff       	call   801a63 <fsipc>
  801b39:	89 c2                	mov    %eax,%edx
  801b3b:	85 d2                	test   %edx,%edx
  801b3d:	78 2b                	js     801b6a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b3f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b46:	00 
  801b47:	89 1c 24             	mov    %ebx,(%esp)
  801b4a:	e8 88 ed ff ff       	call   8008d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b4f:	a1 80 60 80 00       	mov    0x806080,%eax
  801b54:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b5a:	a1 84 60 80 00       	mov    0x806084,%eax
  801b5f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b6a:	83 c4 14             	add    $0x14,%esp
  801b6d:	5b                   	pop    %ebx
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 18             	sub    $0x18,%esp
  801b76:	8b 45 10             	mov    0x10(%ebp),%eax
  801b79:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b7e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801b83:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801b86:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801b8e:	8b 52 0c             	mov    0xc(%edx),%edx
  801b91:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801b97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba2:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801ba9:	e8 c6 ee ff ff       	call   800a74 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801bae:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb3:	b8 04 00 00 00       	mov    $0x4,%eax
  801bb8:	e8 a6 fe ff ff       	call   801a63 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 10             	sub    $0x10,%esp
  801bc7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bca:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcd:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801bd5:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801bdb:	ba 00 00 00 00       	mov    $0x0,%edx
  801be0:	b8 03 00 00 00       	mov    $0x3,%eax
  801be5:	e8 79 fe ff ff       	call   801a63 <fsipc>
  801bea:	89 c3                	mov    %eax,%ebx
  801bec:	85 c0                	test   %eax,%eax
  801bee:	78 6a                	js     801c5a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801bf0:	39 c6                	cmp    %eax,%esi
  801bf2:	73 24                	jae    801c18 <devfile_read+0x59>
  801bf4:	c7 44 24 0c 4c 30 80 	movl   $0x80304c,0xc(%esp)
  801bfb:	00 
  801bfc:	c7 44 24 08 53 30 80 	movl   $0x803053,0x8(%esp)
  801c03:	00 
  801c04:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801c0b:	00 
  801c0c:	c7 04 24 68 30 80 00 	movl   $0x803068,(%esp)
  801c13:	e8 9b e5 ff ff       	call   8001b3 <_panic>
	assert(r <= PGSIZE);
  801c18:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c1d:	7e 24                	jle    801c43 <devfile_read+0x84>
  801c1f:	c7 44 24 0c 73 30 80 	movl   $0x803073,0xc(%esp)
  801c26:	00 
  801c27:	c7 44 24 08 53 30 80 	movl   $0x803053,0x8(%esp)
  801c2e:	00 
  801c2f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801c36:	00 
  801c37:	c7 04 24 68 30 80 00 	movl   $0x803068,(%esp)
  801c3e:	e8 70 e5 ff ff       	call   8001b3 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c47:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c4e:	00 
  801c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c52:	89 04 24             	mov    %eax,(%esp)
  801c55:	e8 1a ee ff ff       	call   800a74 <memmove>
	return r;
}
  801c5a:	89 d8                	mov    %ebx,%eax
  801c5c:	83 c4 10             	add    $0x10,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    

00801c63 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	53                   	push   %ebx
  801c67:	83 ec 24             	sub    $0x24,%esp
  801c6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801c6d:	89 1c 24             	mov    %ebx,(%esp)
  801c70:	e8 2b ec ff ff       	call   8008a0 <strlen>
  801c75:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801c7a:	7f 60                	jg     801cdc <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 20 f8 ff ff       	call   8014a7 <fd_alloc>
  801c87:	89 c2                	mov    %eax,%edx
  801c89:	85 d2                	test   %edx,%edx
  801c8b:	78 54                	js     801ce1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c91:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801c98:	e8 3a ec ff ff       	call   8008d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca0:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ca5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ca8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cad:	e8 b1 fd ff ff       	call   801a63 <fsipc>
  801cb2:	89 c3                	mov    %eax,%ebx
  801cb4:	85 c0                	test   %eax,%eax
  801cb6:	79 17                	jns    801ccf <open+0x6c>
		fd_close(fd, 0);
  801cb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cbf:	00 
  801cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc3:	89 04 24             	mov    %eax,(%esp)
  801cc6:	e8 db f8 ff ff       	call   8015a6 <fd_close>
		return r;
  801ccb:	89 d8                	mov    %ebx,%eax
  801ccd:	eb 12                	jmp    801ce1 <open+0x7e>
	}

	return fd2num(fd);
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 a6 f7 ff ff       	call   801480 <fd2num>
  801cda:	eb 05                	jmp    801ce1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801cdc:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ce1:	83 c4 24             	add    $0x24,%esp
  801ce4:	5b                   	pop    %ebx
  801ce5:	5d                   	pop    %ebp
  801ce6:	c3                   	ret    

00801ce7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
  801cea:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ced:	ba 00 00 00 00       	mov    $0x0,%edx
  801cf2:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf7:	e8 67 fd ff ff       	call   801a63 <fsipc>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    
  801cfe:	66 90                	xchg   %ax,%ax

00801d00 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801d06:	c7 44 24 04 7f 30 80 	movl   $0x80307f,0x4(%esp)
  801d0d:	00 
  801d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d11:	89 04 24             	mov    %eax,(%esp)
  801d14:	e8 be eb ff ff       	call   8008d7 <strcpy>
	return 0;
}
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	53                   	push   %ebx
  801d24:	83 ec 14             	sub    $0x14,%esp
  801d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801d2a:	89 1c 24             	mov    %ebx,(%esp)
  801d2d:	e8 9c 0a 00 00       	call   8027ce <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801d32:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801d37:	83 f8 01             	cmp    $0x1,%eax
  801d3a:	75 0d                	jne    801d49 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801d3c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801d3f:	89 04 24             	mov    %eax,(%esp)
  801d42:	e8 29 03 00 00       	call   802070 <nsipc_close>
  801d47:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801d49:	89 d0                	mov    %edx,%eax
  801d4b:	83 c4 14             	add    $0x14,%esp
  801d4e:	5b                   	pop    %ebx
  801d4f:	5d                   	pop    %ebp
  801d50:	c3                   	ret    

00801d51 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801d57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d5e:	00 
  801d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d70:	8b 40 0c             	mov    0xc(%eax),%eax
  801d73:	89 04 24             	mov    %eax,(%esp)
  801d76:	e8 f0 03 00 00       	call   80216b <nsipc_send>
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d83:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d8a:	00 
  801d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d99:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801d9f:	89 04 24             	mov    %eax,(%esp)
  801da2:	e8 44 03 00 00       	call   8020eb <nsipc_recv>
}
  801da7:	c9                   	leave  
  801da8:	c3                   	ret    

00801da9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801da9:	55                   	push   %ebp
  801daa:	89 e5                	mov    %esp,%ebp
  801dac:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801daf:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db2:	89 54 24 04          	mov    %edx,0x4(%esp)
  801db6:	89 04 24             	mov    %eax,(%esp)
  801db9:	e8 38 f7 ff ff       	call   8014f6 <fd_lookup>
  801dbe:	85 c0                	test   %eax,%eax
  801dc0:	78 17                	js     801dd9 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801dcb:	39 08                	cmp    %ecx,(%eax)
  801dcd:	75 05                	jne    801dd4 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dcf:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd2:	eb 05                	jmp    801dd9 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801dd4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	56                   	push   %esi
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 20             	sub    $0x20,%esp
  801de3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de8:	89 04 24             	mov    %eax,(%esp)
  801deb:	e8 b7 f6 ff ff       	call   8014a7 <fd_alloc>
  801df0:	89 c3                	mov    %eax,%ebx
  801df2:	85 c0                	test   %eax,%eax
  801df4:	78 21                	js     801e17 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801df6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801dfd:	00 
  801dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e05:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e0c:	e8 e2 ee ff ff       	call   800cf3 <sys_page_alloc>
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	85 c0                	test   %eax,%eax
  801e15:	79 0c                	jns    801e23 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801e17:	89 34 24             	mov    %esi,(%esp)
  801e1a:	e8 51 02 00 00       	call   802070 <nsipc_close>
		return r;
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	eb 20                	jmp    801e43 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801e23:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e2c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e31:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801e38:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801e3b:	89 14 24             	mov    %edx,(%esp)
  801e3e:	e8 3d f6 ff ff       	call   801480 <fd2num>
}
  801e43:	83 c4 20             	add    $0x20,%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5d                   	pop    %ebp
  801e49:	c3                   	ret    

00801e4a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e4a:	55                   	push   %ebp
  801e4b:	89 e5                	mov    %esp,%ebp
  801e4d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e50:	8b 45 08             	mov    0x8(%ebp),%eax
  801e53:	e8 51 ff ff ff       	call   801da9 <fd2sockid>
		return r;
  801e58:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e5a:	85 c0                	test   %eax,%eax
  801e5c:	78 23                	js     801e81 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e5e:	8b 55 10             	mov    0x10(%ebp),%edx
  801e61:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e6c:	89 04 24             	mov    %eax,(%esp)
  801e6f:	e8 45 01 00 00       	call   801fb9 <nsipc_accept>
		return r;
  801e74:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 07                	js     801e81 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801e7a:	e8 5c ff ff ff       	call   801ddb <alloc_sockfd>
  801e7f:	89 c1                	mov    %eax,%ecx
}
  801e81:	89 c8                	mov    %ecx,%eax
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	e8 16 ff ff ff       	call   801da9 <fd2sockid>
  801e93:	89 c2                	mov    %eax,%edx
  801e95:	85 d2                	test   %edx,%edx
  801e97:	78 16                	js     801eaf <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801e99:	8b 45 10             	mov    0x10(%ebp),%eax
  801e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea7:	89 14 24             	mov    %edx,(%esp)
  801eaa:	e8 60 01 00 00       	call   80200f <nsipc_bind>
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <shutdown>:

int
shutdown(int s, int how)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	e8 ea fe ff ff       	call   801da9 <fd2sockid>
  801ebf:	89 c2                	mov    %eax,%edx
  801ec1:	85 d2                	test   %edx,%edx
  801ec3:	78 0f                	js     801ed4 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ecc:	89 14 24             	mov    %edx,(%esp)
  801ecf:	e8 7a 01 00 00       	call   80204e <nsipc_shutdown>
}
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	e8 c5 fe ff ff       	call   801da9 <fd2sockid>
  801ee4:	89 c2                	mov    %eax,%edx
  801ee6:	85 d2                	test   %edx,%edx
  801ee8:	78 16                	js     801f00 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801eea:	8b 45 10             	mov    0x10(%ebp),%eax
  801eed:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ef1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef8:	89 14 24             	mov    %edx,(%esp)
  801efb:	e8 8a 01 00 00       	call   80208a <nsipc_connect>
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <listen>:

int
listen(int s, int backlog)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
  801f05:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801f08:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0b:	e8 99 fe ff ff       	call   801da9 <fd2sockid>
  801f10:	89 c2                	mov    %eax,%edx
  801f12:	85 d2                	test   %edx,%edx
  801f14:	78 0f                	js     801f25 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f19:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f1d:	89 14 24             	mov    %edx,(%esp)
  801f20:	e8 a4 01 00 00       	call   8020c9 <nsipc_listen>
}
  801f25:	c9                   	leave  
  801f26:	c3                   	ret    

00801f27 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f27:	55                   	push   %ebp
  801f28:	89 e5                	mov    %esp,%ebp
  801f2a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f2d:	8b 45 10             	mov    0x10(%ebp),%eax
  801f30:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	89 04 24             	mov    %eax,(%esp)
  801f41:	e8 98 02 00 00       	call   8021de <nsipc_socket>
  801f46:	89 c2                	mov    %eax,%edx
  801f48:	85 d2                	test   %edx,%edx
  801f4a:	78 05                	js     801f51 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801f4c:	e8 8a fe ff ff       	call   801ddb <alloc_sockfd>
}
  801f51:	c9                   	leave  
  801f52:	c3                   	ret    

00801f53 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	53                   	push   %ebx
  801f57:	83 ec 14             	sub    $0x14,%esp
  801f5a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801f5c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801f63:	75 11                	jne    801f76 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801f65:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801f6c:	e8 d0 f4 ff ff       	call   801441 <ipc_find_env>
  801f71:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f76:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f7d:	00 
  801f7e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801f85:	00 
  801f86:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f8a:	a1 04 50 80 00       	mov    0x805004,%eax
  801f8f:	89 04 24             	mov    %eax,(%esp)
  801f92:	e8 4c f4 ff ff       	call   8013e3 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f9e:	00 
  801f9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fa6:	00 
  801fa7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fae:	e8 c6 f3 ff ff       	call   801379 <ipc_recv>
}
  801fb3:	83 c4 14             	add    $0x14,%esp
  801fb6:	5b                   	pop    %ebx
  801fb7:	5d                   	pop    %ebp
  801fb8:	c3                   	ret    

00801fb9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	56                   	push   %esi
  801fbd:	53                   	push   %ebx
  801fbe:	83 ec 10             	sub    $0x10,%esp
  801fc1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801fcc:	8b 06                	mov    (%esi),%eax
  801fce:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd8:	e8 76 ff ff ff       	call   801f53 <nsipc>
  801fdd:	89 c3                	mov    %eax,%ebx
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	78 23                	js     802006 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fe3:	a1 10 70 80 00       	mov    0x807010,%eax
  801fe8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fec:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801ff3:	00 
  801ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff7:	89 04 24             	mov    %eax,(%esp)
  801ffa:	e8 75 ea ff ff       	call   800a74 <memmove>
		*addrlen = ret->ret_addrlen;
  801fff:	a1 10 70 80 00       	mov    0x807010,%eax
  802004:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  802006:	89 d8                	mov    %ebx,%eax
  802008:	83 c4 10             	add    $0x10,%esp
  80200b:	5b                   	pop    %ebx
  80200c:	5e                   	pop    %esi
  80200d:	5d                   	pop    %ebp
  80200e:	c3                   	ret    

0080200f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	53                   	push   %ebx
  802013:	83 ec 14             	sub    $0x14,%esp
  802016:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802019:	8b 45 08             	mov    0x8(%ebp),%eax
  80201c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802021:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802025:	8b 45 0c             	mov    0xc(%ebp),%eax
  802028:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  802033:	e8 3c ea ff ff       	call   800a74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802038:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80203e:	b8 02 00 00 00       	mov    $0x2,%eax
  802043:	e8 0b ff ff ff       	call   801f53 <nsipc>
}
  802048:	83 c4 14             	add    $0x14,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5d                   	pop    %ebp
  80204d:	c3                   	ret    

0080204e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802054:	8b 45 08             	mov    0x8(%ebp),%eax
  802057:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80205c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80205f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  802064:	b8 03 00 00 00       	mov    $0x3,%eax
  802069:	e8 e5 fe ff ff       	call   801f53 <nsipc>
}
  80206e:	c9                   	leave  
  80206f:	c3                   	ret    

00802070 <nsipc_close>:

int
nsipc_close(int s)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  80207e:	b8 04 00 00 00       	mov    $0x4,%eax
  802083:	e8 cb fe ff ff       	call   801f53 <nsipc>
}
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
  80208e:	83 ec 14             	sub    $0x14,%esp
  802091:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  80209c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8020ae:	e8 c1 e9 ff ff       	call   800a74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020b3:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  8020b9:	b8 05 00 00 00       	mov    $0x5,%eax
  8020be:	e8 90 fe ff ff       	call   801f53 <nsipc>
}
  8020c3:	83 c4 14             	add    $0x14,%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5d                   	pop    %ebp
  8020c8:	c3                   	ret    

008020c9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8020df:	b8 06 00 00 00       	mov    $0x6,%eax
  8020e4:	e8 6a fe ff ff       	call   801f53 <nsipc>
}
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	83 ec 10             	sub    $0x10,%esp
  8020f3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8020fe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802104:	8b 45 14             	mov    0x14(%ebp),%eax
  802107:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80210c:	b8 07 00 00 00       	mov    $0x7,%eax
  802111:	e8 3d fe ff ff       	call   801f53 <nsipc>
  802116:	89 c3                	mov    %eax,%ebx
  802118:	85 c0                	test   %eax,%eax
  80211a:	78 46                	js     802162 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80211c:	39 f0                	cmp    %esi,%eax
  80211e:	7f 07                	jg     802127 <nsipc_recv+0x3c>
  802120:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802125:	7e 24                	jle    80214b <nsipc_recv+0x60>
  802127:	c7 44 24 0c 8b 30 80 	movl   $0x80308b,0xc(%esp)
  80212e:	00 
  80212f:	c7 44 24 08 53 30 80 	movl   $0x803053,0x8(%esp)
  802136:	00 
  802137:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80213e:	00 
  80213f:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  802146:	e8 68 e0 ff ff       	call   8001b3 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80214b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802156:	00 
  802157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80215a:	89 04 24             	mov    %eax,(%esp)
  80215d:	e8 12 e9 ff ff       	call   800a74 <memmove>
	}

	return r;
}
  802162:	89 d8                	mov    %ebx,%eax
  802164:	83 c4 10             	add    $0x10,%esp
  802167:	5b                   	pop    %ebx
  802168:	5e                   	pop    %esi
  802169:	5d                   	pop    %ebp
  80216a:	c3                   	ret    

0080216b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	53                   	push   %ebx
  80216f:	83 ec 14             	sub    $0x14,%esp
  802172:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80217d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802183:	7e 24                	jle    8021a9 <nsipc_send+0x3e>
  802185:	c7 44 24 0c ac 30 80 	movl   $0x8030ac,0xc(%esp)
  80218c:	00 
  80218d:	c7 44 24 08 53 30 80 	movl   $0x803053,0x8(%esp)
  802194:	00 
  802195:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80219c:	00 
  80219d:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  8021a4:	e8 0a e0 ff ff       	call   8001b3 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b4:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8021bb:	e8 b4 e8 ff ff       	call   800a74 <memmove>
	nsipcbuf.send.req_size = size;
  8021c0:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8021c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8021c9:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8021ce:	b8 08 00 00 00       	mov    $0x8,%eax
  8021d3:	e8 7b fd ff ff       	call   801f53 <nsipc>
}
  8021d8:	83 c4 14             	add    $0x14,%esp
  8021db:	5b                   	pop    %ebx
  8021dc:	5d                   	pop    %ebp
  8021dd:	c3                   	ret    

008021de <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ef:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8021f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8021fc:	b8 09 00 00 00       	mov    $0x9,%eax
  802201:	e8 4d fd ff ff       	call   801f53 <nsipc>
}
  802206:	c9                   	leave  
  802207:	c3                   	ret    

00802208 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802208:	55                   	push   %ebp
  802209:	89 e5                	mov    %esp,%ebp
  80220b:	56                   	push   %esi
  80220c:	53                   	push   %ebx
  80220d:	83 ec 10             	sub    $0x10,%esp
  802210:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	89 04 24             	mov    %eax,(%esp)
  802219:	e8 72 f2 ff ff       	call   801490 <fd2data>
  80221e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802220:	c7 44 24 04 b8 30 80 	movl   $0x8030b8,0x4(%esp)
  802227:	00 
  802228:	89 1c 24             	mov    %ebx,(%esp)
  80222b:	e8 a7 e6 ff ff       	call   8008d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802230:	8b 46 04             	mov    0x4(%esi),%eax
  802233:	2b 06                	sub    (%esi),%eax
  802235:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80223b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802242:	00 00 00 
	stat->st_dev = &devpipe;
  802245:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80224c:	40 80 00 
	return 0;
}
  80224f:	b8 00 00 00 00       	mov    $0x0,%eax
  802254:	83 c4 10             	add    $0x10,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5d                   	pop    %ebp
  80225a:	c3                   	ret    

0080225b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80225b:	55                   	push   %ebp
  80225c:	89 e5                	mov    %esp,%ebp
  80225e:	53                   	push   %ebx
  80225f:	83 ec 14             	sub    $0x14,%esp
  802262:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802265:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802269:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802270:	e8 25 eb ff ff       	call   800d9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802275:	89 1c 24             	mov    %ebx,(%esp)
  802278:	e8 13 f2 ff ff       	call   801490 <fd2data>
  80227d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802281:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802288:	e8 0d eb ff ff       	call   800d9a <sys_page_unmap>
}
  80228d:	83 c4 14             	add    $0x14,%esp
  802290:	5b                   	pop    %ebx
  802291:	5d                   	pop    %ebp
  802292:	c3                   	ret    

00802293 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802293:	55                   	push   %ebp
  802294:	89 e5                	mov    %esp,%ebp
  802296:	57                   	push   %edi
  802297:	56                   	push   %esi
  802298:	53                   	push   %ebx
  802299:	83 ec 2c             	sub    $0x2c,%esp
  80229c:	89 c6                	mov    %eax,%esi
  80229e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  8022a1:	a1 08 50 80 00       	mov    0x805008,%eax
  8022a6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8022a9:	89 34 24             	mov    %esi,(%esp)
  8022ac:	e8 1d 05 00 00       	call   8027ce <pageref>
  8022b1:	89 c7                	mov    %eax,%edi
  8022b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b6:	89 04 24             	mov    %eax,(%esp)
  8022b9:	e8 10 05 00 00       	call   8027ce <pageref>
  8022be:	39 c7                	cmp    %eax,%edi
  8022c0:	0f 94 c2             	sete   %dl
  8022c3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  8022c6:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  8022cc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  8022cf:	39 fb                	cmp    %edi,%ebx
  8022d1:	74 21                	je     8022f4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  8022d3:	84 d2                	test   %dl,%dl
  8022d5:	74 ca                	je     8022a1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8022d7:	8b 51 58             	mov    0x58(%ecx),%edx
  8022da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022de:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022e6:	c7 04 24 bf 30 80 00 	movl   $0x8030bf,(%esp)
  8022ed:	e8 ba df ff ff       	call   8002ac <cprintf>
  8022f2:	eb ad                	jmp    8022a1 <_pipeisclosed+0xe>
	}
}
  8022f4:	83 c4 2c             	add    $0x2c,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    

008022fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022fc:	55                   	push   %ebp
  8022fd:	89 e5                	mov    %esp,%ebp
  8022ff:	57                   	push   %edi
  802300:	56                   	push   %esi
  802301:	53                   	push   %ebx
  802302:	83 ec 1c             	sub    $0x1c,%esp
  802305:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802308:	89 34 24             	mov    %esi,(%esp)
  80230b:	e8 80 f1 ff ff       	call   801490 <fd2data>
  802310:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802312:	bf 00 00 00 00       	mov    $0x0,%edi
  802317:	eb 45                	jmp    80235e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802319:	89 da                	mov    %ebx,%edx
  80231b:	89 f0                	mov    %esi,%eax
  80231d:	e8 71 ff ff ff       	call   802293 <_pipeisclosed>
  802322:	85 c0                	test   %eax,%eax
  802324:	75 41                	jne    802367 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802326:	e8 a9 e9 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80232b:	8b 43 04             	mov    0x4(%ebx),%eax
  80232e:	8b 0b                	mov    (%ebx),%ecx
  802330:	8d 51 20             	lea    0x20(%ecx),%edx
  802333:	39 d0                	cmp    %edx,%eax
  802335:	73 e2                	jae    802319 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80233a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80233e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802341:	99                   	cltd   
  802342:	c1 ea 1b             	shr    $0x1b,%edx
  802345:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802348:	83 e1 1f             	and    $0x1f,%ecx
  80234b:	29 d1                	sub    %edx,%ecx
  80234d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802351:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802355:	83 c0 01             	add    $0x1,%eax
  802358:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80235b:	83 c7 01             	add    $0x1,%edi
  80235e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802361:	75 c8                	jne    80232b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802363:	89 f8                	mov    %edi,%eax
  802365:	eb 05                	jmp    80236c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802367:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80236c:	83 c4 1c             	add    $0x1c,%esp
  80236f:	5b                   	pop    %ebx
  802370:	5e                   	pop    %esi
  802371:	5f                   	pop    %edi
  802372:	5d                   	pop    %ebp
  802373:	c3                   	ret    

00802374 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802374:	55                   	push   %ebp
  802375:	89 e5                	mov    %esp,%ebp
  802377:	57                   	push   %edi
  802378:	56                   	push   %esi
  802379:	53                   	push   %ebx
  80237a:	83 ec 1c             	sub    $0x1c,%esp
  80237d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802380:	89 3c 24             	mov    %edi,(%esp)
  802383:	e8 08 f1 ff ff       	call   801490 <fd2data>
  802388:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80238a:	be 00 00 00 00       	mov    $0x0,%esi
  80238f:	eb 3d                	jmp    8023ce <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802391:	85 f6                	test   %esi,%esi
  802393:	74 04                	je     802399 <devpipe_read+0x25>
				return i;
  802395:	89 f0                	mov    %esi,%eax
  802397:	eb 43                	jmp    8023dc <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802399:	89 da                	mov    %ebx,%edx
  80239b:	89 f8                	mov    %edi,%eax
  80239d:	e8 f1 fe ff ff       	call   802293 <_pipeisclosed>
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	75 31                	jne    8023d7 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8023a6:	e8 29 e9 ff ff       	call   800cd4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8023ab:	8b 03                	mov    (%ebx),%eax
  8023ad:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023b0:	74 df                	je     802391 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8023b2:	99                   	cltd   
  8023b3:	c1 ea 1b             	shr    $0x1b,%edx
  8023b6:	01 d0                	add    %edx,%eax
  8023b8:	83 e0 1f             	and    $0x1f,%eax
  8023bb:	29 d0                	sub    %edx,%eax
  8023bd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8023c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023c5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  8023c8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8023cb:	83 c6 01             	add    $0x1,%esi
  8023ce:	3b 75 10             	cmp    0x10(%ebp),%esi
  8023d1:	75 d8                	jne    8023ab <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023d3:	89 f0                	mov    %esi,%eax
  8023d5:	eb 05                	jmp    8023dc <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8023d7:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  8023dc:	83 c4 1c             	add    $0x1c,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5e                   	pop    %esi
  8023e1:	5f                   	pop    %edi
  8023e2:	5d                   	pop    %ebp
  8023e3:	c3                   	ret    

008023e4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	56                   	push   %esi
  8023e8:	53                   	push   %ebx
  8023e9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ef:	89 04 24             	mov    %eax,(%esp)
  8023f2:	e8 b0 f0 ff ff       	call   8014a7 <fd_alloc>
  8023f7:	89 c2                	mov    %eax,%edx
  8023f9:	85 d2                	test   %edx,%edx
  8023fb:	0f 88 4d 01 00 00    	js     80254e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802401:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802408:	00 
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802417:	e8 d7 e8 ff ff       	call   800cf3 <sys_page_alloc>
  80241c:	89 c2                	mov    %eax,%edx
  80241e:	85 d2                	test   %edx,%edx
  802420:	0f 88 28 01 00 00    	js     80254e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802426:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802429:	89 04 24             	mov    %eax,(%esp)
  80242c:	e8 76 f0 ff ff       	call   8014a7 <fd_alloc>
  802431:	89 c3                	mov    %eax,%ebx
  802433:	85 c0                	test   %eax,%eax
  802435:	0f 88 fe 00 00 00    	js     802539 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802442:	00 
  802443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80244a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802451:	e8 9d e8 ff ff       	call   800cf3 <sys_page_alloc>
  802456:	89 c3                	mov    %eax,%ebx
  802458:	85 c0                	test   %eax,%eax
  80245a:	0f 88 d9 00 00 00    	js     802539 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	89 04 24             	mov    %eax,(%esp)
  802466:	e8 25 f0 ff ff       	call   801490 <fd2data>
  80246b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80246d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802474:	00 
  802475:	89 44 24 04          	mov    %eax,0x4(%esp)
  802479:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802480:	e8 6e e8 ff ff       	call   800cf3 <sys_page_alloc>
  802485:	89 c3                	mov    %eax,%ebx
  802487:	85 c0                	test   %eax,%eax
  802489:	0f 88 97 00 00 00    	js     802526 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	89 04 24             	mov    %eax,(%esp)
  802495:	e8 f6 ef ff ff       	call   801490 <fd2data>
  80249a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024a1:	00 
  8024a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024ad:	00 
  8024ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024b9:	e8 89 e8 ff ff       	call   800d47 <sys_page_map>
  8024be:	89 c3                	mov    %eax,%ebx
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	78 52                	js     802516 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024c4:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  8024d9:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8024df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	89 04 24             	mov    %eax,(%esp)
  8024f4:	e8 87 ef ff ff       	call   801480 <fd2num>
  8024f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024fc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	89 04 24             	mov    %eax,(%esp)
  802504:	e8 77 ef ff ff       	call   801480 <fd2num>
  802509:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80250c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80250f:	b8 00 00 00 00       	mov    $0x0,%eax
  802514:	eb 38                	jmp    80254e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802516:	89 74 24 04          	mov    %esi,0x4(%esp)
  80251a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802521:	e8 74 e8 ff ff       	call   800d9a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802526:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802529:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802534:	e8 61 e8 ff ff       	call   800d9a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802540:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802547:	e8 4e e8 ff ff       	call   800d9a <sys_page_unmap>
  80254c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80254e:	83 c4 30             	add    $0x30,%esp
  802551:	5b                   	pop    %ebx
  802552:	5e                   	pop    %esi
  802553:	5d                   	pop    %ebp
  802554:	c3                   	ret    

00802555 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802555:	55                   	push   %ebp
  802556:	89 e5                	mov    %esp,%ebp
  802558:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80255b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802562:	8b 45 08             	mov    0x8(%ebp),%eax
  802565:	89 04 24             	mov    %eax,(%esp)
  802568:	e8 89 ef ff ff       	call   8014f6 <fd_lookup>
  80256d:	89 c2                	mov    %eax,%edx
  80256f:	85 d2                	test   %edx,%edx
  802571:	78 15                	js     802588 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	89 04 24             	mov    %eax,(%esp)
  802579:	e8 12 ef ff ff       	call   801490 <fd2data>
	return _pipeisclosed(fd, p);
  80257e:	89 c2                	mov    %eax,%edx
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	e8 0b fd ff ff       	call   802293 <_pipeisclosed>
}
  802588:	c9                   	leave  
  802589:	c3                   	ret    
  80258a:	66 90                	xchg   %ax,%ax
  80258c:	66 90                	xchg   %ax,%ax
  80258e:	66 90                	xchg   %ax,%ax

00802590 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802593:	b8 00 00 00 00       	mov    $0x0,%eax
  802598:	5d                   	pop    %ebp
  802599:	c3                   	ret    

0080259a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80259a:	55                   	push   %ebp
  80259b:	89 e5                	mov    %esp,%ebp
  80259d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8025a0:	c7 44 24 04 d7 30 80 	movl   $0x8030d7,0x4(%esp)
  8025a7:	00 
  8025a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ab:	89 04 24             	mov    %eax,(%esp)
  8025ae:	e8 24 e3 ff ff       	call   8008d7 <strcpy>
	return 0;
}
  8025b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	57                   	push   %edi
  8025be:	56                   	push   %esi
  8025bf:	53                   	push   %ebx
  8025c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025c6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025cb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025d1:	eb 31                	jmp    802604 <devcons_write+0x4a>
		m = n - tot;
  8025d3:	8b 75 10             	mov    0x10(%ebp),%esi
  8025d6:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  8025d8:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025db:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8025e0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025e3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8025e7:	03 45 0c             	add    0xc(%ebp),%eax
  8025ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ee:	89 3c 24             	mov    %edi,(%esp)
  8025f1:	e8 7e e4 ff ff       	call   800a74 <memmove>
		sys_cputs(buf, m);
  8025f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025fa:	89 3c 24             	mov    %edi,(%esp)
  8025fd:	e8 24 e6 ff ff       	call   800c26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802602:	01 f3                	add    %esi,%ebx
  802604:	89 d8                	mov    %ebx,%eax
  802606:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802609:	72 c8                	jb     8025d3 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80260b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    

00802616 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80261c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802621:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802625:	75 07                	jne    80262e <devcons_read+0x18>
  802627:	eb 2a                	jmp    802653 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802629:	e8 a6 e6 ff ff       	call   800cd4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80262e:	66 90                	xchg   %ax,%ax
  802630:	e8 0f e6 ff ff       	call   800c44 <sys_cgetc>
  802635:	85 c0                	test   %eax,%eax
  802637:	74 f0                	je     802629 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802639:	85 c0                	test   %eax,%eax
  80263b:	78 16                	js     802653 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80263d:	83 f8 04             	cmp    $0x4,%eax
  802640:	74 0c                	je     80264e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802642:	8b 55 0c             	mov    0xc(%ebp),%edx
  802645:	88 02                	mov    %al,(%edx)
	return 1;
  802647:	b8 01 00 00 00       	mov    $0x1,%eax
  80264c:	eb 05                	jmp    802653 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80264e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802653:	c9                   	leave  
  802654:	c3                   	ret    

00802655 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80265b:	8b 45 08             	mov    0x8(%ebp),%eax
  80265e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802661:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802668:	00 
  802669:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80266c:	89 04 24             	mov    %eax,(%esp)
  80266f:	e8 b2 e5 ff ff       	call   800c26 <sys_cputs>
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <getchar>:

int
getchar(void)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80267c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802683:	00 
  802684:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802687:	89 44 24 04          	mov    %eax,0x4(%esp)
  80268b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802692:	e8 f3 f0 ff ff       	call   80178a <read>
	if (r < 0)
  802697:	85 c0                	test   %eax,%eax
  802699:	78 0f                	js     8026aa <getchar+0x34>
		return r;
	if (r < 1)
  80269b:	85 c0                	test   %eax,%eax
  80269d:	7e 06                	jle    8026a5 <getchar+0x2f>
		return -E_EOF;
	return c;
  80269f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8026a3:	eb 05                	jmp    8026aa <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8026a5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bc:	89 04 24             	mov    %eax,(%esp)
  8026bf:	e8 32 ee ff ff       	call   8014f6 <fd_lookup>
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	78 11                	js     8026d9 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cb:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8026d1:	39 10                	cmp    %edx,(%eax)
  8026d3:	0f 94 c0             	sete   %al
  8026d6:	0f b6 c0             	movzbl %al,%eax
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    

008026db <opencons>:

int
opencons(void)
{
  8026db:	55                   	push   %ebp
  8026dc:	89 e5                	mov    %esp,%ebp
  8026de:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026e4:	89 04 24             	mov    %eax,(%esp)
  8026e7:	e8 bb ed ff ff       	call   8014a7 <fd_alloc>
		return r;
  8026ec:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8026ee:	85 c0                	test   %eax,%eax
  8026f0:	78 40                	js     802732 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8026f2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026f9:	00 
  8026fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802701:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802708:	e8 e6 e5 ff ff       	call   800cf3 <sys_page_alloc>
		return r;
  80270d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80270f:	85 c0                	test   %eax,%eax
  802711:	78 1f                	js     802732 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802713:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802728:	89 04 24             	mov    %eax,(%esp)
  80272b:	e8 50 ed ff ff       	call   801480 <fd2num>
  802730:	89 c2                	mov    %eax,%edx
}
  802732:	89 d0                	mov    %edx,%eax
  802734:	c9                   	leave  
  802735:	c3                   	ret    

00802736 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802736:	55                   	push   %ebp
  802737:	89 e5                	mov    %esp,%ebp
  802739:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  80273c:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802743:	75 58                	jne    80279d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802745:	a1 08 50 80 00       	mov    0x805008,%eax
  80274a:	8b 40 48             	mov    0x48(%eax),%eax
  80274d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802754:	00 
  802755:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80275c:	ee 
  80275d:	89 04 24             	mov    %eax,(%esp)
  802760:	e8 8e e5 ff ff       	call   800cf3 <sys_page_alloc>
		if(return_code!=0)
  802765:	85 c0                	test   %eax,%eax
  802767:	74 1c                	je     802785 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802769:	c7 44 24 08 e4 30 80 	movl   $0x8030e4,0x8(%esp)
  802770:	00 
  802771:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802778:	00 
  802779:	c7 04 24 40 31 80 00 	movl   $0x803140,(%esp)
  802780:	e8 2e da ff ff       	call   8001b3 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802785:	a1 08 50 80 00       	mov    0x805008,%eax
  80278a:	8b 40 48             	mov    0x48(%eax),%eax
  80278d:	c7 44 24 04 a7 27 80 	movl   $0x8027a7,0x4(%esp)
  802794:	00 
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 f6 e6 ff ff       	call   800e93 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80279d:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a0:	a3 00 80 80 00       	mov    %eax,0x808000
}
  8027a5:	c9                   	leave  
  8027a6:	c3                   	ret    

008027a7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8027a7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8027a8:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  8027ad:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8027af:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  8027b2:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  8027b4:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  8027b8:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  8027bc:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  8027bd:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  8027bf:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  8027c1:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  8027c5:	58                   	pop    %eax
	popl %eax;
  8027c6:	58                   	pop    %eax
	popal;
  8027c7:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  8027c8:	83 c4 04             	add    $0x4,%esp
	popfl;
  8027cb:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  8027cc:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  8027cd:	c3                   	ret    

008027ce <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027ce:	55                   	push   %ebp
  8027cf:	89 e5                	mov    %esp,%ebp
  8027d1:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027d4:	89 d0                	mov    %edx,%eax
  8027d6:	c1 e8 16             	shr    $0x16,%eax
  8027d9:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027e0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027e5:	f6 c1 01             	test   $0x1,%cl
  8027e8:	74 1d                	je     802807 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027ea:	c1 ea 0c             	shr    $0xc,%edx
  8027ed:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027f4:	f6 c2 01             	test   $0x1,%dl
  8027f7:	74 0e                	je     802807 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027f9:	c1 ea 0c             	shr    $0xc,%edx
  8027fc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802803:	ef 
  802804:	0f b7 c0             	movzwl %ax,%eax
}
  802807:	5d                   	pop    %ebp
  802808:	c3                   	ret    
  802809:	66 90                	xchg   %ax,%ax
  80280b:	66 90                	xchg   %ax,%ax
  80280d:	66 90                	xchg   %ax,%ax
  80280f:	90                   	nop

00802810 <__udivdi3>:
  802810:	55                   	push   %ebp
  802811:	57                   	push   %edi
  802812:	56                   	push   %esi
  802813:	83 ec 0c             	sub    $0xc,%esp
  802816:	8b 44 24 28          	mov    0x28(%esp),%eax
  80281a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80281e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802822:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802826:	85 c0                	test   %eax,%eax
  802828:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80282c:	89 ea                	mov    %ebp,%edx
  80282e:	89 0c 24             	mov    %ecx,(%esp)
  802831:	75 2d                	jne    802860 <__udivdi3+0x50>
  802833:	39 e9                	cmp    %ebp,%ecx
  802835:	77 61                	ja     802898 <__udivdi3+0x88>
  802837:	85 c9                	test   %ecx,%ecx
  802839:	89 ce                	mov    %ecx,%esi
  80283b:	75 0b                	jne    802848 <__udivdi3+0x38>
  80283d:	b8 01 00 00 00       	mov    $0x1,%eax
  802842:	31 d2                	xor    %edx,%edx
  802844:	f7 f1                	div    %ecx
  802846:	89 c6                	mov    %eax,%esi
  802848:	31 d2                	xor    %edx,%edx
  80284a:	89 e8                	mov    %ebp,%eax
  80284c:	f7 f6                	div    %esi
  80284e:	89 c5                	mov    %eax,%ebp
  802850:	89 f8                	mov    %edi,%eax
  802852:	f7 f6                	div    %esi
  802854:	89 ea                	mov    %ebp,%edx
  802856:	83 c4 0c             	add    $0xc,%esp
  802859:	5e                   	pop    %esi
  80285a:	5f                   	pop    %edi
  80285b:	5d                   	pop    %ebp
  80285c:	c3                   	ret    
  80285d:	8d 76 00             	lea    0x0(%esi),%esi
  802860:	39 e8                	cmp    %ebp,%eax
  802862:	77 24                	ja     802888 <__udivdi3+0x78>
  802864:	0f bd e8             	bsr    %eax,%ebp
  802867:	83 f5 1f             	xor    $0x1f,%ebp
  80286a:	75 3c                	jne    8028a8 <__udivdi3+0x98>
  80286c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802870:	39 34 24             	cmp    %esi,(%esp)
  802873:	0f 86 9f 00 00 00    	jbe    802918 <__udivdi3+0x108>
  802879:	39 d0                	cmp    %edx,%eax
  80287b:	0f 82 97 00 00 00    	jb     802918 <__udivdi3+0x108>
  802881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802888:	31 d2                	xor    %edx,%edx
  80288a:	31 c0                	xor    %eax,%eax
  80288c:	83 c4 0c             	add    $0xc,%esp
  80288f:	5e                   	pop    %esi
  802890:	5f                   	pop    %edi
  802891:	5d                   	pop    %ebp
  802892:	c3                   	ret    
  802893:	90                   	nop
  802894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802898:	89 f8                	mov    %edi,%eax
  80289a:	f7 f1                	div    %ecx
  80289c:	31 d2                	xor    %edx,%edx
  80289e:	83 c4 0c             	add    $0xc,%esp
  8028a1:	5e                   	pop    %esi
  8028a2:	5f                   	pop    %edi
  8028a3:	5d                   	pop    %ebp
  8028a4:	c3                   	ret    
  8028a5:	8d 76 00             	lea    0x0(%esi),%esi
  8028a8:	89 e9                	mov    %ebp,%ecx
  8028aa:	8b 3c 24             	mov    (%esp),%edi
  8028ad:	d3 e0                	shl    %cl,%eax
  8028af:	89 c6                	mov    %eax,%esi
  8028b1:	b8 20 00 00 00       	mov    $0x20,%eax
  8028b6:	29 e8                	sub    %ebp,%eax
  8028b8:	89 c1                	mov    %eax,%ecx
  8028ba:	d3 ef                	shr    %cl,%edi
  8028bc:	89 e9                	mov    %ebp,%ecx
  8028be:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8028c2:	8b 3c 24             	mov    (%esp),%edi
  8028c5:	09 74 24 08          	or     %esi,0x8(%esp)
  8028c9:	89 d6                	mov    %edx,%esi
  8028cb:	d3 e7                	shl    %cl,%edi
  8028cd:	89 c1                	mov    %eax,%ecx
  8028cf:	89 3c 24             	mov    %edi,(%esp)
  8028d2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8028d6:	d3 ee                	shr    %cl,%esi
  8028d8:	89 e9                	mov    %ebp,%ecx
  8028da:	d3 e2                	shl    %cl,%edx
  8028dc:	89 c1                	mov    %eax,%ecx
  8028de:	d3 ef                	shr    %cl,%edi
  8028e0:	09 d7                	or     %edx,%edi
  8028e2:	89 f2                	mov    %esi,%edx
  8028e4:	89 f8                	mov    %edi,%eax
  8028e6:	f7 74 24 08          	divl   0x8(%esp)
  8028ea:	89 d6                	mov    %edx,%esi
  8028ec:	89 c7                	mov    %eax,%edi
  8028ee:	f7 24 24             	mull   (%esp)
  8028f1:	39 d6                	cmp    %edx,%esi
  8028f3:	89 14 24             	mov    %edx,(%esp)
  8028f6:	72 30                	jb     802928 <__udivdi3+0x118>
  8028f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028fc:	89 e9                	mov    %ebp,%ecx
  8028fe:	d3 e2                	shl    %cl,%edx
  802900:	39 c2                	cmp    %eax,%edx
  802902:	73 05                	jae    802909 <__udivdi3+0xf9>
  802904:	3b 34 24             	cmp    (%esp),%esi
  802907:	74 1f                	je     802928 <__udivdi3+0x118>
  802909:	89 f8                	mov    %edi,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	e9 7a ff ff ff       	jmp    80288c <__udivdi3+0x7c>
  802912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802918:	31 d2                	xor    %edx,%edx
  80291a:	b8 01 00 00 00       	mov    $0x1,%eax
  80291f:	e9 68 ff ff ff       	jmp    80288c <__udivdi3+0x7c>
  802924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802928:	8d 47 ff             	lea    -0x1(%edi),%eax
  80292b:	31 d2                	xor    %edx,%edx
  80292d:	83 c4 0c             	add    $0xc,%esp
  802930:	5e                   	pop    %esi
  802931:	5f                   	pop    %edi
  802932:	5d                   	pop    %ebp
  802933:	c3                   	ret    
  802934:	66 90                	xchg   %ax,%ax
  802936:	66 90                	xchg   %ax,%ax
  802938:	66 90                	xchg   %ax,%ax
  80293a:	66 90                	xchg   %ax,%ax
  80293c:	66 90                	xchg   %ax,%ax
  80293e:	66 90                	xchg   %ax,%ax

00802940 <__umoddi3>:
  802940:	55                   	push   %ebp
  802941:	57                   	push   %edi
  802942:	56                   	push   %esi
  802943:	83 ec 14             	sub    $0x14,%esp
  802946:	8b 44 24 28          	mov    0x28(%esp),%eax
  80294a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80294e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802952:	89 c7                	mov    %eax,%edi
  802954:	89 44 24 04          	mov    %eax,0x4(%esp)
  802958:	8b 44 24 30          	mov    0x30(%esp),%eax
  80295c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802960:	89 34 24             	mov    %esi,(%esp)
  802963:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802967:	85 c0                	test   %eax,%eax
  802969:	89 c2                	mov    %eax,%edx
  80296b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80296f:	75 17                	jne    802988 <__umoddi3+0x48>
  802971:	39 fe                	cmp    %edi,%esi
  802973:	76 4b                	jbe    8029c0 <__umoddi3+0x80>
  802975:	89 c8                	mov    %ecx,%eax
  802977:	89 fa                	mov    %edi,%edx
  802979:	f7 f6                	div    %esi
  80297b:	89 d0                	mov    %edx,%eax
  80297d:	31 d2                	xor    %edx,%edx
  80297f:	83 c4 14             	add    $0x14,%esp
  802982:	5e                   	pop    %esi
  802983:	5f                   	pop    %edi
  802984:	5d                   	pop    %ebp
  802985:	c3                   	ret    
  802986:	66 90                	xchg   %ax,%ax
  802988:	39 f8                	cmp    %edi,%eax
  80298a:	77 54                	ja     8029e0 <__umoddi3+0xa0>
  80298c:	0f bd e8             	bsr    %eax,%ebp
  80298f:	83 f5 1f             	xor    $0x1f,%ebp
  802992:	75 5c                	jne    8029f0 <__umoddi3+0xb0>
  802994:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802998:	39 3c 24             	cmp    %edi,(%esp)
  80299b:	0f 87 e7 00 00 00    	ja     802a88 <__umoddi3+0x148>
  8029a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8029a5:	29 f1                	sub    %esi,%ecx
  8029a7:	19 c7                	sbb    %eax,%edi
  8029a9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029b1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8029b5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8029b9:	83 c4 14             	add    $0x14,%esp
  8029bc:	5e                   	pop    %esi
  8029bd:	5f                   	pop    %edi
  8029be:	5d                   	pop    %ebp
  8029bf:	c3                   	ret    
  8029c0:	85 f6                	test   %esi,%esi
  8029c2:	89 f5                	mov    %esi,%ebp
  8029c4:	75 0b                	jne    8029d1 <__umoddi3+0x91>
  8029c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8029cb:	31 d2                	xor    %edx,%edx
  8029cd:	f7 f6                	div    %esi
  8029cf:	89 c5                	mov    %eax,%ebp
  8029d1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8029d5:	31 d2                	xor    %edx,%edx
  8029d7:	f7 f5                	div    %ebp
  8029d9:	89 c8                	mov    %ecx,%eax
  8029db:	f7 f5                	div    %ebp
  8029dd:	eb 9c                	jmp    80297b <__umoddi3+0x3b>
  8029df:	90                   	nop
  8029e0:	89 c8                	mov    %ecx,%eax
  8029e2:	89 fa                	mov    %edi,%edx
  8029e4:	83 c4 14             	add    $0x14,%esp
  8029e7:	5e                   	pop    %esi
  8029e8:	5f                   	pop    %edi
  8029e9:	5d                   	pop    %ebp
  8029ea:	c3                   	ret    
  8029eb:	90                   	nop
  8029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	8b 04 24             	mov    (%esp),%eax
  8029f3:	be 20 00 00 00       	mov    $0x20,%esi
  8029f8:	89 e9                	mov    %ebp,%ecx
  8029fa:	29 ee                	sub    %ebp,%esi
  8029fc:	d3 e2                	shl    %cl,%edx
  8029fe:	89 f1                	mov    %esi,%ecx
  802a00:	d3 e8                	shr    %cl,%eax
  802a02:	89 e9                	mov    %ebp,%ecx
  802a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a08:	8b 04 24             	mov    (%esp),%eax
  802a0b:	09 54 24 04          	or     %edx,0x4(%esp)
  802a0f:	89 fa                	mov    %edi,%edx
  802a11:	d3 e0                	shl    %cl,%eax
  802a13:	89 f1                	mov    %esi,%ecx
  802a15:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a19:	8b 44 24 10          	mov    0x10(%esp),%eax
  802a1d:	d3 ea                	shr    %cl,%edx
  802a1f:	89 e9                	mov    %ebp,%ecx
  802a21:	d3 e7                	shl    %cl,%edi
  802a23:	89 f1                	mov    %esi,%ecx
  802a25:	d3 e8                	shr    %cl,%eax
  802a27:	89 e9                	mov    %ebp,%ecx
  802a29:	09 f8                	or     %edi,%eax
  802a2b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  802a2f:	f7 74 24 04          	divl   0x4(%esp)
  802a33:	d3 e7                	shl    %cl,%edi
  802a35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802a39:	89 d7                	mov    %edx,%edi
  802a3b:	f7 64 24 08          	mull   0x8(%esp)
  802a3f:	39 d7                	cmp    %edx,%edi
  802a41:	89 c1                	mov    %eax,%ecx
  802a43:	89 14 24             	mov    %edx,(%esp)
  802a46:	72 2c                	jb     802a74 <__umoddi3+0x134>
  802a48:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802a4c:	72 22                	jb     802a70 <__umoddi3+0x130>
  802a4e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802a52:	29 c8                	sub    %ecx,%eax
  802a54:	19 d7                	sbb    %edx,%edi
  802a56:	89 e9                	mov    %ebp,%ecx
  802a58:	89 fa                	mov    %edi,%edx
  802a5a:	d3 e8                	shr    %cl,%eax
  802a5c:	89 f1                	mov    %esi,%ecx
  802a5e:	d3 e2                	shl    %cl,%edx
  802a60:	89 e9                	mov    %ebp,%ecx
  802a62:	d3 ef                	shr    %cl,%edi
  802a64:	09 d0                	or     %edx,%eax
  802a66:	89 fa                	mov    %edi,%edx
  802a68:	83 c4 14             	add    $0x14,%esp
  802a6b:	5e                   	pop    %esi
  802a6c:	5f                   	pop    %edi
  802a6d:	5d                   	pop    %ebp
  802a6e:	c3                   	ret    
  802a6f:	90                   	nop
  802a70:	39 d7                	cmp    %edx,%edi
  802a72:	75 da                	jne    802a4e <__umoddi3+0x10e>
  802a74:	8b 14 24             	mov    (%esp),%edx
  802a77:	89 c1                	mov    %eax,%ecx
  802a79:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a7d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a81:	eb cb                	jmp    802a4e <__umoddi3+0x10e>
  802a83:	90                   	nop
  802a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a88:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a8c:	0f 82 0f ff ff ff    	jb     8029a1 <__umoddi3+0x61>
  802a92:	e9 1a ff ff ff       	jmp    8029b1 <__umoddi3+0x71>
