
obj/user/testtime.debug:     file format elf32-i386


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
  80002c:	e8 e5 00 00 00       	call   800116 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <sleep>:
#include <inc/lib.h>
#include <inc/x86.h>

void
sleep(int sec)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	unsigned now = sys_time_msec();
  800047:	e8 df 0e 00 00       	call   800f2b <sys_time_msec>
	unsigned end = now + sec * 1000;
  80004c:	69 5d 08 e8 03 00 00 	imul   $0x3e8,0x8(%ebp),%ebx
  800053:	01 c3                	add    %eax,%ebx
	if ((int)now < 0 && (int)now > -MAXERROR)
  800055:	83 f8 f1             	cmp    $0xfffffff1,%eax
  800058:	7c 29                	jl     800083 <sleep+0x43>
  80005a:	89 c2                	mov    %eax,%edx
  80005c:	c1 ea 1f             	shr    $0x1f,%edx
  80005f:	84 d2                	test   %dl,%dl
  800061:	74 20                	je     800083 <sleep+0x43>
		panic("sys_time_msec: %e", (int)now);
  800063:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800067:	c7 44 24 08 80 26 80 	movl   $0x802680,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 92 26 80 00 	movl   $0x802692,(%esp)
  80007e:	e8 fe 00 00 00       	call   800181 <_panic>
	if (end < now)
  800083:	39 d8                	cmp    %ebx,%eax
  800085:	76 21                	jbe    8000a8 <sleep+0x68>
		panic("sleep: wrap");
  800087:	c7 44 24 08 a2 26 80 	movl   $0x8026a2,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 92 26 80 00 	movl   $0x802692,(%esp)
  80009e:	e8 de 00 00 00       	call   800181 <_panic>

	while (sys_time_msec() < end)
		sys_yield();
  8000a3:	e8 fc 0b 00 00       	call   800ca4 <sys_yield>
	if ((int)now < 0 && (int)now > -MAXERROR)
		panic("sys_time_msec: %e", (int)now);
	if (end < now)
		panic("sleep: wrap");

	while (sys_time_msec() < end)
  8000a8:	e8 7e 0e 00 00       	call   800f2b <sys_time_msec>
  8000ad:	39 c3                	cmp    %eax,%ebx
  8000af:	90                   	nop
  8000b0:	77 f1                	ja     8000a3 <sleep+0x63>
		sys_yield();
}
  8000b2:	83 c4 14             	add    $0x14,%esp
  8000b5:	5b                   	pop    %ebx
  8000b6:	5d                   	pop    %ebp
  8000b7:	c3                   	ret    

008000b8 <umain>:

void
umain(int argc, char **argv)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	53                   	push   %ebx
  8000bc:	83 ec 14             	sub    $0x14,%esp
  8000bf:	bb 32 00 00 00       	mov    $0x32,%ebx
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();
  8000c4:	e8 db 0b 00 00       	call   800ca4 <sys_yield>
umain(int argc, char **argv)
{
	int i;

	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
  8000c9:	83 eb 01             	sub    $0x1,%ebx
  8000cc:	75 f6                	jne    8000c4 <umain+0xc>
		sys_yield();

	cprintf("starting count down: ");
  8000ce:	c7 04 24 ae 26 80 00 	movl   $0x8026ae,(%esp)
  8000d5:	e8 a0 01 00 00       	call   80027a <cprintf>
	for (i = 5; i >= 0; i--) {
  8000da:	bb 05 00 00 00       	mov    $0x5,%ebx
		cprintf("%d ", i);
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	c7 04 24 c4 26 80 00 	movl   $0x8026c4,(%esp)
  8000ea:	e8 8b 01 00 00       	call   80027a <cprintf>
		sleep(1);
  8000ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000f6:	e8 45 ff ff ff       	call   800040 <sleep>
	// Wait for the console to calm down
	for (i = 0; i < 50; i++)
		sys_yield();

	cprintf("starting count down: ");
	for (i = 5; i >= 0; i--) {
  8000fb:	83 eb 01             	sub    $0x1,%ebx
  8000fe:	83 fb ff             	cmp    $0xffffffff,%ebx
  800101:	75 dc                	jne    8000df <umain+0x27>
		cprintf("%d ", i);
		sleep(1);
	}
	cprintf("\n");
  800103:	c7 04 24 44 2b 80 00 	movl   $0x802b44,(%esp)
  80010a:	e8 6b 01 00 00       	call   80027a <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  80010f:	cc                   	int3   
	breakpoint();
}
  800110:	83 c4 14             	add    $0x14,%esp
  800113:	5b                   	pop    %ebx
  800114:	5d                   	pop    %ebp
  800115:	c3                   	ret    

00800116 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800116:	55                   	push   %ebp
  800117:	89 e5                	mov    %esp,%ebp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	83 ec 10             	sub    $0x10,%esp
  80011e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800121:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800124:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80012b:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  80012e:	e8 52 0b 00 00       	call   800c85 <sys_getenvid>
  800133:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800138:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80013b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800140:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800145:	85 db                	test   %ebx,%ebx
  800147:	7e 07                	jle    800150 <libmain+0x3a>
		binaryname = argv[0];
  800149:	8b 06                	mov    (%esi),%eax
  80014b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800150:	89 74 24 04          	mov    %esi,0x4(%esp)
  800154:	89 1c 24             	mov    %ebx,(%esp)
  800157:	e8 5c ff ff ff       	call   8000b8 <umain>

	// exit gracefully
	exit();
  80015c:	e8 07 00 00 00       	call   800168 <exit>
}
  800161:	83 c4 10             	add    $0x10,%esp
  800164:	5b                   	pop    %ebx
  800165:	5e                   	pop    %esi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80016e:	e8 57 10 00 00       	call   8011ca <close_all>
	sys_env_destroy(0);
  800173:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80017a:	e8 b4 0a 00 00       	call   800c33 <sys_env_destroy>
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800189:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80018c:	8b 35 00 30 80 00    	mov    0x803000,%esi
  800192:	e8 ee 0a 00 00       	call   800c85 <sys_getenvid>
  800197:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019a:	89 54 24 10          	mov    %edx,0x10(%esp)
  80019e:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001a5:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ad:	c7 04 24 d4 26 80 00 	movl   $0x8026d4,(%esp)
  8001b4:	e8 c1 00 00 00       	call   80027a <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c0:	89 04 24             	mov    %eax,(%esp)
  8001c3:	e8 51 00 00 00       	call   800219 <vcprintf>
	cprintf("\n");
  8001c8:	c7 04 24 44 2b 80 00 	movl   $0x802b44,(%esp)
  8001cf:	e8 a6 00 00 00       	call   80027a <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001d4:	cc                   	int3   
  8001d5:	eb fd                	jmp    8001d4 <_panic+0x53>

008001d7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d7:	55                   	push   %ebp
  8001d8:	89 e5                	mov    %esp,%ebp
  8001da:	53                   	push   %ebx
  8001db:	83 ec 14             	sub    $0x14,%esp
  8001de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e1:	8b 13                	mov    (%ebx),%edx
  8001e3:	8d 42 01             	lea    0x1(%edx),%eax
  8001e6:	89 03                	mov    %eax,(%ebx)
  8001e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001eb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ef:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001f4:	75 19                	jne    80020f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001f6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001fd:	00 
  8001fe:	8d 43 08             	lea    0x8(%ebx),%eax
  800201:	89 04 24             	mov    %eax,(%esp)
  800204:	e8 ed 09 00 00       	call   800bf6 <sys_cputs>
		b->idx = 0;
  800209:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80020f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800213:	83 c4 14             	add    $0x14,%esp
  800216:	5b                   	pop    %ebx
  800217:	5d                   	pop    %ebp
  800218:	c3                   	ret    

00800219 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800222:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800229:	00 00 00 
	b.cnt = 0;
  80022c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800233:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800236:	8b 45 0c             	mov    0xc(%ebp),%eax
  800239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023d:	8b 45 08             	mov    0x8(%ebp),%eax
  800240:	89 44 24 08          	mov    %eax,0x8(%esp)
  800244:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80024a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024e:	c7 04 24 d7 01 80 00 	movl   $0x8001d7,(%esp)
  800255:	e8 b4 01 00 00       	call   80040e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80025a:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800260:	89 44 24 04          	mov    %eax,0x4(%esp)
  800264:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80026a:	89 04 24             	mov    %eax,(%esp)
  80026d:	e8 84 09 00 00       	call   800bf6 <sys_cputs>

	return b.cnt;
}
  800272:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800278:	c9                   	leave  
  800279:	c3                   	ret    

0080027a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800280:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800283:	89 44 24 04          	mov    %eax,0x4(%esp)
  800287:	8b 45 08             	mov    0x8(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 87 ff ff ff       	call   800219 <vcprintf>
	va_end(ap);

	return cnt;
}
  800292:	c9                   	leave  
  800293:	c3                   	ret    
  800294:	66 90                	xchg   %ax,%ax
  800296:	66 90                	xchg   %ax,%ax
  800298:	66 90                	xchg   %ax,%ax
  80029a:	66 90                	xchg   %ax,%ax
  80029c:	66 90                	xchg   %ax,%ax
  80029e:	66 90                	xchg   %ax,%ax

008002a0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	57                   	push   %edi
  8002a4:	56                   	push   %esi
  8002a5:	53                   	push   %ebx
  8002a6:	83 ec 3c             	sub    $0x3c,%esp
  8002a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ac:	89 d7                	mov    %edx,%edi
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b7:	89 c3                	mov    %eax,%ebx
  8002b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ca:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002cd:	39 d9                	cmp    %ebx,%ecx
  8002cf:	72 05                	jb     8002d6 <printnum+0x36>
  8002d1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002d4:	77 69                	ja     80033f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002d9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002dd:	83 ee 01             	sub    $0x1,%esi
  8002e0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002ec:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002f0:	89 c3                	mov    %eax,%ebx
  8002f2:	89 d6                	mov    %edx,%esi
  8002f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002f7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002fa:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002fe:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800302:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800305:	89 04 24             	mov    %eax,(%esp)
  800308:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80030b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030f:	e8 dc 20 00 00       	call   8023f0 <__udivdi3>
  800314:	89 d9                	mov    %ebx,%ecx
  800316:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80031a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80031e:	89 04 24             	mov    %eax,(%esp)
  800321:	89 54 24 04          	mov    %edx,0x4(%esp)
  800325:	89 fa                	mov    %edi,%edx
  800327:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80032a:	e8 71 ff ff ff       	call   8002a0 <printnum>
  80032f:	eb 1b                	jmp    80034c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800331:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800335:	8b 45 18             	mov    0x18(%ebp),%eax
  800338:	89 04 24             	mov    %eax,(%esp)
  80033b:	ff d3                	call   *%ebx
  80033d:	eb 03                	jmp    800342 <printnum+0xa2>
  80033f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800342:	83 ee 01             	sub    $0x1,%esi
  800345:	85 f6                	test   %esi,%esi
  800347:	7f e8                	jg     800331 <printnum+0x91>
  800349:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80034c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800350:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800354:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800357:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80035a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80035e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800365:	89 04 24             	mov    %eax,(%esp)
  800368:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80036b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036f:	e8 ac 21 00 00       	call   802520 <__umoddi3>
  800374:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800378:	0f be 80 f7 26 80 00 	movsbl 0x8026f7(%eax),%eax
  80037f:	89 04 24             	mov    %eax,(%esp)
  800382:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800385:	ff d0                	call   *%eax
}
  800387:	83 c4 3c             	add    $0x3c,%esp
  80038a:	5b                   	pop    %ebx
  80038b:	5e                   	pop    %esi
  80038c:	5f                   	pop    %edi
  80038d:	5d                   	pop    %ebp
  80038e:	c3                   	ret    

0080038f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800392:	83 fa 01             	cmp    $0x1,%edx
  800395:	7e 0e                	jle    8003a5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800397:	8b 10                	mov    (%eax),%edx
  800399:	8d 4a 08             	lea    0x8(%edx),%ecx
  80039c:	89 08                	mov    %ecx,(%eax)
  80039e:	8b 02                	mov    (%edx),%eax
  8003a0:	8b 52 04             	mov    0x4(%edx),%edx
  8003a3:	eb 22                	jmp    8003c7 <getuint+0x38>
	else if (lflag)
  8003a5:	85 d2                	test   %edx,%edx
  8003a7:	74 10                	je     8003b9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003b7:	eb 0e                	jmp    8003c7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003b9:	8b 10                	mov    (%eax),%edx
  8003bb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003be:	89 08                	mov    %ecx,(%eax)
  8003c0:	8b 02                	mov    (%edx),%eax
  8003c2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003c7:	5d                   	pop    %ebp
  8003c8:	c3                   	ret    

008003c9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c9:	55                   	push   %ebp
  8003ca:	89 e5                	mov    %esp,%ebp
  8003cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003cf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003d3:	8b 10                	mov    (%eax),%edx
  8003d5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003d8:	73 0a                	jae    8003e4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003da:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003dd:	89 08                	mov    %ecx,(%eax)
  8003df:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e2:	88 02                	mov    %al,(%edx)
}
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
  8003e9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003ec:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800401:	8b 45 08             	mov    0x8(%ebp),%eax
  800404:	89 04 24             	mov    %eax,(%esp)
  800407:	e8 02 00 00 00       	call   80040e <vprintfmt>
	va_end(ap);
}
  80040c:	c9                   	leave  
  80040d:	c3                   	ret    

0080040e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80040e:	55                   	push   %ebp
  80040f:	89 e5                	mov    %esp,%ebp
  800411:	57                   	push   %edi
  800412:	56                   	push   %esi
  800413:	53                   	push   %ebx
  800414:	83 ec 3c             	sub    $0x3c,%esp
  800417:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80041a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80041d:	eb 14                	jmp    800433 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80041f:	85 c0                	test   %eax,%eax
  800421:	0f 84 b3 03 00 00    	je     8007da <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800427:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042b:	89 04 24             	mov    %eax,(%esp)
  80042e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800431:	89 f3                	mov    %esi,%ebx
  800433:	8d 73 01             	lea    0x1(%ebx),%esi
  800436:	0f b6 03             	movzbl (%ebx),%eax
  800439:	83 f8 25             	cmp    $0x25,%eax
  80043c:	75 e1                	jne    80041f <vprintfmt+0x11>
  80043e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800442:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800449:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800450:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800457:	ba 00 00 00 00       	mov    $0x0,%edx
  80045c:	eb 1d                	jmp    80047b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80045e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800460:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800464:	eb 15                	jmp    80047b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800466:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800468:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80046c:	eb 0d                	jmp    80047b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80046e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800471:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800474:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80047b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80047e:	0f b6 0e             	movzbl (%esi),%ecx
  800481:	0f b6 c1             	movzbl %cl,%eax
  800484:	83 e9 23             	sub    $0x23,%ecx
  800487:	80 f9 55             	cmp    $0x55,%cl
  80048a:	0f 87 2a 03 00 00    	ja     8007ba <vprintfmt+0x3ac>
  800490:	0f b6 c9             	movzbl %cl,%ecx
  800493:	ff 24 8d 40 28 80 00 	jmp    *0x802840(,%ecx,4)
  80049a:	89 de                	mov    %ebx,%esi
  80049c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004a1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004a4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8004a8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8004ab:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8004ae:	83 fb 09             	cmp    $0x9,%ebx
  8004b1:	77 36                	ja     8004e9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004b3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004b6:	eb e9                	jmp    8004a1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bb:	8d 48 04             	lea    0x4(%eax),%ecx
  8004be:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004c6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004c8:	eb 22                	jmp    8004ec <vprintfmt+0xde>
  8004ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004cd:	85 c9                	test   %ecx,%ecx
  8004cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d4:	0f 49 c1             	cmovns %ecx,%eax
  8004d7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	89 de                	mov    %ebx,%esi
  8004dc:	eb 9d                	jmp    80047b <vprintfmt+0x6d>
  8004de:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004e0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004e7:	eb 92                	jmp    80047b <vprintfmt+0x6d>
  8004e9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004ec:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004f0:	79 89                	jns    80047b <vprintfmt+0x6d>
  8004f2:	e9 77 ff ff ff       	jmp    80046e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004f7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004fc:	e9 7a ff ff ff       	jmp    80047b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800501:	8b 45 14             	mov    0x14(%ebp),%eax
  800504:	8d 50 04             	lea    0x4(%eax),%edx
  800507:	89 55 14             	mov    %edx,0x14(%ebp)
  80050a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80050e:	8b 00                	mov    (%eax),%eax
  800510:	89 04 24             	mov    %eax,(%esp)
  800513:	ff 55 08             	call   *0x8(%ebp)
			break;
  800516:	e9 18 ff ff ff       	jmp    800433 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80051b:	8b 45 14             	mov    0x14(%ebp),%eax
  80051e:	8d 50 04             	lea    0x4(%eax),%edx
  800521:	89 55 14             	mov    %edx,0x14(%ebp)
  800524:	8b 00                	mov    (%eax),%eax
  800526:	99                   	cltd   
  800527:	31 d0                	xor    %edx,%eax
  800529:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80052b:	83 f8 0f             	cmp    $0xf,%eax
  80052e:	7f 0b                	jg     80053b <vprintfmt+0x12d>
  800530:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  800537:	85 d2                	test   %edx,%edx
  800539:	75 20                	jne    80055b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80053b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80053f:	c7 44 24 08 0f 27 80 	movl   $0x80270f,0x8(%esp)
  800546:	00 
  800547:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80054b:	8b 45 08             	mov    0x8(%ebp),%eax
  80054e:	89 04 24             	mov    %eax,(%esp)
  800551:	e8 90 fe ff ff       	call   8003e6 <printfmt>
  800556:	e9 d8 fe ff ff       	jmp    800433 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80055b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80055f:	c7 44 24 08 d9 2a 80 	movl   $0x802ad9,0x8(%esp)
  800566:	00 
  800567:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	89 04 24             	mov    %eax,(%esp)
  800571:	e8 70 fe ff ff       	call   8003e6 <printfmt>
  800576:	e9 b8 fe ff ff       	jmp    800433 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80057b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80057e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800581:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800584:	8b 45 14             	mov    0x14(%ebp),%eax
  800587:	8d 50 04             	lea    0x4(%eax),%edx
  80058a:	89 55 14             	mov    %edx,0x14(%ebp)
  80058d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80058f:	85 f6                	test   %esi,%esi
  800591:	b8 08 27 80 00       	mov    $0x802708,%eax
  800596:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800599:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80059d:	0f 84 97 00 00 00    	je     80063a <vprintfmt+0x22c>
  8005a3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005a7:	0f 8e 9b 00 00 00    	jle    800648 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b1:	89 34 24             	mov    %esi,(%esp)
  8005b4:	e8 cf 02 00 00       	call   800888 <strnlen>
  8005b9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005bc:	29 c2                	sub    %eax,%edx
  8005be:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005c1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005c5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005c8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005cb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ce:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d3:	eb 0f                	jmp    8005e4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005dc:	89 04 24             	mov    %eax,(%esp)
  8005df:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e1:	83 eb 01             	sub    $0x1,%ebx
  8005e4:	85 db                	test   %ebx,%ebx
  8005e6:	7f ed                	jg     8005d5 <vprintfmt+0x1c7>
  8005e8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ee:	85 d2                	test   %edx,%edx
  8005f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005f5:	0f 49 c2             	cmovns %edx,%eax
  8005f8:	29 c2                	sub    %eax,%edx
  8005fa:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005fd:	89 d7                	mov    %edx,%edi
  8005ff:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800602:	eb 50                	jmp    800654 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800604:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800608:	74 1e                	je     800628 <vprintfmt+0x21a>
  80060a:	0f be d2             	movsbl %dl,%edx
  80060d:	83 ea 20             	sub    $0x20,%edx
  800610:	83 fa 5e             	cmp    $0x5e,%edx
  800613:	76 13                	jbe    800628 <vprintfmt+0x21a>
					putch('?', putdat);
  800615:	8b 45 0c             	mov    0xc(%ebp),%eax
  800618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800623:	ff 55 08             	call   *0x8(%ebp)
  800626:	eb 0d                	jmp    800635 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800628:	8b 55 0c             	mov    0xc(%ebp),%edx
  80062b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80062f:	89 04 24             	mov    %eax,(%esp)
  800632:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800635:	83 ef 01             	sub    $0x1,%edi
  800638:	eb 1a                	jmp    800654 <vprintfmt+0x246>
  80063a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800640:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800643:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800646:	eb 0c                	jmp    800654 <vprintfmt+0x246>
  800648:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80064b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80064e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800651:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800654:	83 c6 01             	add    $0x1,%esi
  800657:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80065b:	0f be c2             	movsbl %dl,%eax
  80065e:	85 c0                	test   %eax,%eax
  800660:	74 27                	je     800689 <vprintfmt+0x27b>
  800662:	85 db                	test   %ebx,%ebx
  800664:	78 9e                	js     800604 <vprintfmt+0x1f6>
  800666:	83 eb 01             	sub    $0x1,%ebx
  800669:	79 99                	jns    800604 <vprintfmt+0x1f6>
  80066b:	89 f8                	mov    %edi,%eax
  80066d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800670:	8b 75 08             	mov    0x8(%ebp),%esi
  800673:	89 c3                	mov    %eax,%ebx
  800675:	eb 1a                	jmp    800691 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800677:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80067b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800682:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800684:	83 eb 01             	sub    $0x1,%ebx
  800687:	eb 08                	jmp    800691 <vprintfmt+0x283>
  800689:	89 fb                	mov    %edi,%ebx
  80068b:	8b 75 08             	mov    0x8(%ebp),%esi
  80068e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800691:	85 db                	test   %ebx,%ebx
  800693:	7f e2                	jg     800677 <vprintfmt+0x269>
  800695:	89 75 08             	mov    %esi,0x8(%ebp)
  800698:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80069b:	e9 93 fd ff ff       	jmp    800433 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006a0:	83 fa 01             	cmp    $0x1,%edx
  8006a3:	7e 16                	jle    8006bb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 50 08             	lea    0x8(%eax),%edx
  8006ab:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ae:	8b 50 04             	mov    0x4(%eax),%edx
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b9:	eb 32                	jmp    8006ed <vprintfmt+0x2df>
	else if (lflag)
  8006bb:	85 d2                	test   %edx,%edx
  8006bd:	74 18                	je     8006d7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 50 04             	lea    0x4(%eax),%edx
  8006c5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c8:	8b 30                	mov    (%eax),%esi
  8006ca:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006cd:	89 f0                	mov    %esi,%eax
  8006cf:	c1 f8 1f             	sar    $0x1f,%eax
  8006d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d5:	eb 16                	jmp    8006ed <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 30                	mov    (%eax),%esi
  8006e2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006e5:	89 f0                	mov    %esi,%eax
  8006e7:	c1 f8 1f             	sar    $0x1f,%eax
  8006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fc:	0f 89 80 00 00 00    	jns    800782 <vprintfmt+0x374>
				putch('-', putdat);
  800702:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800706:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80070d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800710:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800713:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800716:	f7 d8                	neg    %eax
  800718:	83 d2 00             	adc    $0x0,%edx
  80071b:	f7 da                	neg    %edx
			}
			base = 10;
  80071d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800722:	eb 5e                	jmp    800782 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800724:	8d 45 14             	lea    0x14(%ebp),%eax
  800727:	e8 63 fc ff ff       	call   80038f <getuint>
			base = 10;
  80072c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800731:	eb 4f                	jmp    800782 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800733:	8d 45 14             	lea    0x14(%ebp),%eax
  800736:	e8 54 fc ff ff       	call   80038f <getuint>
			base =8;
  80073b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800740:	eb 40                	jmp    800782 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800742:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800746:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80074d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800750:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800754:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80075b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 50 04             	lea    0x4(%eax),%edx
  800764:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800767:	8b 00                	mov    (%eax),%eax
  800769:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80076e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800773:	eb 0d                	jmp    800782 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800775:	8d 45 14             	lea    0x14(%ebp),%eax
  800778:	e8 12 fc ff ff       	call   80038f <getuint>
			base = 16;
  80077d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800782:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800786:	89 74 24 10          	mov    %esi,0x10(%esp)
  80078a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80078d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800791:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800795:	89 04 24             	mov    %eax,(%esp)
  800798:	89 54 24 04          	mov    %edx,0x4(%esp)
  80079c:	89 fa                	mov    %edi,%edx
  80079e:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a1:	e8 fa fa ff ff       	call   8002a0 <printnum>
			break;
  8007a6:	e9 88 fc ff ff       	jmp    800433 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ab:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007b5:	e9 79 fc ff ff       	jmp    800433 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007ba:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007be:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007c5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007c8:	89 f3                	mov    %esi,%ebx
  8007ca:	eb 03                	jmp    8007cf <vprintfmt+0x3c1>
  8007cc:	83 eb 01             	sub    $0x1,%ebx
  8007cf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007d3:	75 f7                	jne    8007cc <vprintfmt+0x3be>
  8007d5:	e9 59 fc ff ff       	jmp    800433 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007da:	83 c4 3c             	add    $0x3c,%esp
  8007dd:	5b                   	pop    %ebx
  8007de:	5e                   	pop    %esi
  8007df:	5f                   	pop    %edi
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	83 ec 28             	sub    $0x28,%esp
  8007e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007f1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007f5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ff:	85 c0                	test   %eax,%eax
  800801:	74 30                	je     800833 <vsnprintf+0x51>
  800803:	85 d2                	test   %edx,%edx
  800805:	7e 2c                	jle    800833 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080e:	8b 45 10             	mov    0x10(%ebp),%eax
  800811:	89 44 24 08          	mov    %eax,0x8(%esp)
  800815:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	c7 04 24 c9 03 80 00 	movl   $0x8003c9,(%esp)
  800823:	e8 e6 fb ff ff       	call   80040e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800828:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80082b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80082e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800831:	eb 05                	jmp    800838 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800833:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800838:	c9                   	leave  
  800839:	c3                   	ret    

0080083a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800840:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800843:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800847:	8b 45 10             	mov    0x10(%ebp),%eax
  80084a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80084e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800851:	89 44 24 04          	mov    %eax,0x4(%esp)
  800855:	8b 45 08             	mov    0x8(%ebp),%eax
  800858:	89 04 24             	mov    %eax,(%esp)
  80085b:	e8 82 ff ff ff       	call   8007e2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800860:	c9                   	leave  
  800861:	c3                   	ret    
  800862:	66 90                	xchg   %ax,%ax
  800864:	66 90                	xchg   %ax,%ax
  800866:	66 90                	xchg   %ax,%ax
  800868:	66 90                	xchg   %ax,%ax
  80086a:	66 90                	xchg   %ax,%ax
  80086c:	66 90                	xchg   %ax,%ax
  80086e:	66 90                	xchg   %ax,%ax

00800870 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800876:	b8 00 00 00 00       	mov    $0x0,%eax
  80087b:	eb 03                	jmp    800880 <strlen+0x10>
		n++;
  80087d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800880:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800884:	75 f7                	jne    80087d <strlen+0xd>
		n++;
	return n;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80088e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800891:	b8 00 00 00 00       	mov    $0x0,%eax
  800896:	eb 03                	jmp    80089b <strnlen+0x13>
		n++;
  800898:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80089b:	39 d0                	cmp    %edx,%eax
  80089d:	74 06                	je     8008a5 <strnlen+0x1d>
  80089f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8008a3:	75 f3                	jne    800898 <strnlen+0x10>
		n++;
	return n;
}
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	53                   	push   %ebx
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b1:	89 c2                	mov    %eax,%edx
  8008b3:	83 c2 01             	add    $0x1,%edx
  8008b6:	83 c1 01             	add    $0x1,%ecx
  8008b9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008bd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008c0:	84 db                	test   %bl,%bl
  8008c2:	75 ef                	jne    8008b3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008c4:	5b                   	pop    %ebx
  8008c5:	5d                   	pop    %ebp
  8008c6:	c3                   	ret    

008008c7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008c7:	55                   	push   %ebp
  8008c8:	89 e5                	mov    %esp,%ebp
  8008ca:	53                   	push   %ebx
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008d1:	89 1c 24             	mov    %ebx,(%esp)
  8008d4:	e8 97 ff ff ff       	call   800870 <strlen>
	strcpy(dst + len, src);
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008e0:	01 d8                	add    %ebx,%eax
  8008e2:	89 04 24             	mov    %eax,(%esp)
  8008e5:	e8 bd ff ff ff       	call   8008a7 <strcpy>
	return dst;
}
  8008ea:	89 d8                	mov    %ebx,%eax
  8008ec:	83 c4 08             	add    $0x8,%esp
  8008ef:	5b                   	pop    %ebx
  8008f0:	5d                   	pop    %ebp
  8008f1:	c3                   	ret    

008008f2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008f2:	55                   	push   %ebp
  8008f3:	89 e5                	mov    %esp,%ebp
  8008f5:	56                   	push   %esi
  8008f6:	53                   	push   %ebx
  8008f7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008fd:	89 f3                	mov    %esi,%ebx
  8008ff:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800902:	89 f2                	mov    %esi,%edx
  800904:	eb 0f                	jmp    800915 <strncpy+0x23>
		*dst++ = *src;
  800906:	83 c2 01             	add    $0x1,%edx
  800909:	0f b6 01             	movzbl (%ecx),%eax
  80090c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80090f:	80 39 01             	cmpb   $0x1,(%ecx)
  800912:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800915:	39 da                	cmp    %ebx,%edx
  800917:	75 ed                	jne    800906 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800919:	89 f0                	mov    %esi,%eax
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	56                   	push   %esi
  800923:	53                   	push   %ebx
  800924:	8b 75 08             	mov    0x8(%ebp),%esi
  800927:	8b 55 0c             	mov    0xc(%ebp),%edx
  80092a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80092d:	89 f0                	mov    %esi,%eax
  80092f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800933:	85 c9                	test   %ecx,%ecx
  800935:	75 0b                	jne    800942 <strlcpy+0x23>
  800937:	eb 1d                	jmp    800956 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800939:	83 c0 01             	add    $0x1,%eax
  80093c:	83 c2 01             	add    $0x1,%edx
  80093f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800942:	39 d8                	cmp    %ebx,%eax
  800944:	74 0b                	je     800951 <strlcpy+0x32>
  800946:	0f b6 0a             	movzbl (%edx),%ecx
  800949:	84 c9                	test   %cl,%cl
  80094b:	75 ec                	jne    800939 <strlcpy+0x1a>
  80094d:	89 c2                	mov    %eax,%edx
  80094f:	eb 02                	jmp    800953 <strlcpy+0x34>
  800951:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800953:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800956:	29 f0                	sub    %esi,%eax
}
  800958:	5b                   	pop    %ebx
  800959:	5e                   	pop    %esi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800965:	eb 06                	jmp    80096d <strcmp+0x11>
		p++, q++;
  800967:	83 c1 01             	add    $0x1,%ecx
  80096a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80096d:	0f b6 01             	movzbl (%ecx),%eax
  800970:	84 c0                	test   %al,%al
  800972:	74 04                	je     800978 <strcmp+0x1c>
  800974:	3a 02                	cmp    (%edx),%al
  800976:	74 ef                	je     800967 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800978:	0f b6 c0             	movzbl %al,%eax
  80097b:	0f b6 12             	movzbl (%edx),%edx
  80097e:	29 d0                	sub    %edx,%eax
}
  800980:	5d                   	pop    %ebp
  800981:	c3                   	ret    

00800982 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	53                   	push   %ebx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 c3                	mov    %eax,%ebx
  80098e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800991:	eb 06                	jmp    800999 <strncmp+0x17>
		n--, p++, q++;
  800993:	83 c0 01             	add    $0x1,%eax
  800996:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800999:	39 d8                	cmp    %ebx,%eax
  80099b:	74 15                	je     8009b2 <strncmp+0x30>
  80099d:	0f b6 08             	movzbl (%eax),%ecx
  8009a0:	84 c9                	test   %cl,%cl
  8009a2:	74 04                	je     8009a8 <strncmp+0x26>
  8009a4:	3a 0a                	cmp    (%edx),%cl
  8009a6:	74 eb                	je     800993 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a8:	0f b6 00             	movzbl (%eax),%eax
  8009ab:	0f b6 12             	movzbl (%edx),%edx
  8009ae:	29 d0                	sub    %edx,%eax
  8009b0:	eb 05                	jmp    8009b7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5d                   	pop    %ebp
  8009b9:	c3                   	ret    

008009ba <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009c4:	eb 07                	jmp    8009cd <strchr+0x13>
		if (*s == c)
  8009c6:	38 ca                	cmp    %cl,%dl
  8009c8:	74 0f                	je     8009d9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	0f b6 10             	movzbl (%eax),%edx
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	75 f2                	jne    8009c6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e5:	eb 07                	jmp    8009ee <strfind+0x13>
		if (*s == c)
  8009e7:	38 ca                	cmp    %cl,%dl
  8009e9:	74 0a                	je     8009f5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009eb:	83 c0 01             	add    $0x1,%eax
  8009ee:	0f b6 10             	movzbl (%eax),%edx
  8009f1:	84 d2                	test   %dl,%dl
  8009f3:	75 f2                	jne    8009e7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    

008009f7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009f7:	55                   	push   %ebp
  8009f8:	89 e5                	mov    %esp,%ebp
  8009fa:	57                   	push   %edi
  8009fb:	56                   	push   %esi
  8009fc:	53                   	push   %ebx
  8009fd:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a00:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a03:	85 c9                	test   %ecx,%ecx
  800a05:	74 36                	je     800a3d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a07:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a0d:	75 28                	jne    800a37 <memset+0x40>
  800a0f:	f6 c1 03             	test   $0x3,%cl
  800a12:	75 23                	jne    800a37 <memset+0x40>
		c &= 0xFF;
  800a14:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a18:	89 d3                	mov    %edx,%ebx
  800a1a:	c1 e3 08             	shl    $0x8,%ebx
  800a1d:	89 d6                	mov    %edx,%esi
  800a1f:	c1 e6 18             	shl    $0x18,%esi
  800a22:	89 d0                	mov    %edx,%eax
  800a24:	c1 e0 10             	shl    $0x10,%eax
  800a27:	09 f0                	or     %esi,%eax
  800a29:	09 c2                	or     %eax,%edx
  800a2b:	89 d0                	mov    %edx,%eax
  800a2d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a2f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a32:	fc                   	cld    
  800a33:	f3 ab                	rep stos %eax,%es:(%edi)
  800a35:	eb 06                	jmp    800a3d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3a:	fc                   	cld    
  800a3b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a3d:	89 f8                	mov    %edi,%eax
  800a3f:	5b                   	pop    %ebx
  800a40:	5e                   	pop    %esi
  800a41:	5f                   	pop    %edi
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    

00800a44 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	57                   	push   %edi
  800a48:	56                   	push   %esi
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a52:	39 c6                	cmp    %eax,%esi
  800a54:	73 35                	jae    800a8b <memmove+0x47>
  800a56:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a59:	39 d0                	cmp    %edx,%eax
  800a5b:	73 2e                	jae    800a8b <memmove+0x47>
		s += n;
		d += n;
  800a5d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a60:	89 d6                	mov    %edx,%esi
  800a62:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a64:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a6a:	75 13                	jne    800a7f <memmove+0x3b>
  800a6c:	f6 c1 03             	test   $0x3,%cl
  800a6f:	75 0e                	jne    800a7f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a71:	83 ef 04             	sub    $0x4,%edi
  800a74:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a77:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a7a:	fd                   	std    
  800a7b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a7d:	eb 09                	jmp    800a88 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a7f:	83 ef 01             	sub    $0x1,%edi
  800a82:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a85:	fd                   	std    
  800a86:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a88:	fc                   	cld    
  800a89:	eb 1d                	jmp    800aa8 <memmove+0x64>
  800a8b:	89 f2                	mov    %esi,%edx
  800a8d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8f:	f6 c2 03             	test   $0x3,%dl
  800a92:	75 0f                	jne    800aa3 <memmove+0x5f>
  800a94:	f6 c1 03             	test   $0x3,%cl
  800a97:	75 0a                	jne    800aa3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a99:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a9c:	89 c7                	mov    %eax,%edi
  800a9e:	fc                   	cld    
  800a9f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aa1:	eb 05                	jmp    800aa8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800aa3:	89 c7                	mov    %eax,%edi
  800aa5:	fc                   	cld    
  800aa6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800aa8:	5e                   	pop    %esi
  800aa9:	5f                   	pop    %edi
  800aaa:	5d                   	pop    %ebp
  800aab:	c3                   	ret    

00800aac <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ab2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	89 04 24             	mov    %eax,(%esp)
  800ac6:	e8 79 ff ff ff       	call   800a44 <memmove>
}
  800acb:	c9                   	leave  
  800acc:	c3                   	ret    

00800acd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800acd:	55                   	push   %ebp
  800ace:	89 e5                	mov    %esp,%ebp
  800ad0:	56                   	push   %esi
  800ad1:	53                   	push   %ebx
  800ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ad5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ad8:	89 d6                	mov    %edx,%esi
  800ada:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800add:	eb 1a                	jmp    800af9 <memcmp+0x2c>
		if (*s1 != *s2)
  800adf:	0f b6 02             	movzbl (%edx),%eax
  800ae2:	0f b6 19             	movzbl (%ecx),%ebx
  800ae5:	38 d8                	cmp    %bl,%al
  800ae7:	74 0a                	je     800af3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ae9:	0f b6 c0             	movzbl %al,%eax
  800aec:	0f b6 db             	movzbl %bl,%ebx
  800aef:	29 d8                	sub    %ebx,%eax
  800af1:	eb 0f                	jmp    800b02 <memcmp+0x35>
		s1++, s2++;
  800af3:	83 c2 01             	add    $0x1,%edx
  800af6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800af9:	39 f2                	cmp    %esi,%edx
  800afb:	75 e2                	jne    800adf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b02:	5b                   	pop    %ebx
  800b03:	5e                   	pop    %esi
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b0f:	89 c2                	mov    %eax,%edx
  800b11:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b14:	eb 07                	jmp    800b1d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b16:	38 08                	cmp    %cl,(%eax)
  800b18:	74 07                	je     800b21 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	39 d0                	cmp    %edx,%eax
  800b1f:	72 f5                	jb     800b16 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b21:	5d                   	pop    %ebp
  800b22:	c3                   	ret    

00800b23 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b23:	55                   	push   %ebp
  800b24:	89 e5                	mov    %esp,%ebp
  800b26:	57                   	push   %edi
  800b27:	56                   	push   %esi
  800b28:	53                   	push   %ebx
  800b29:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b2f:	eb 03                	jmp    800b34 <strtol+0x11>
		s++;
  800b31:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b34:	0f b6 0a             	movzbl (%edx),%ecx
  800b37:	80 f9 09             	cmp    $0x9,%cl
  800b3a:	74 f5                	je     800b31 <strtol+0xe>
  800b3c:	80 f9 20             	cmp    $0x20,%cl
  800b3f:	74 f0                	je     800b31 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b41:	80 f9 2b             	cmp    $0x2b,%cl
  800b44:	75 0a                	jne    800b50 <strtol+0x2d>
		s++;
  800b46:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b49:	bf 00 00 00 00       	mov    $0x0,%edi
  800b4e:	eb 11                	jmp    800b61 <strtol+0x3e>
  800b50:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b55:	80 f9 2d             	cmp    $0x2d,%cl
  800b58:	75 07                	jne    800b61 <strtol+0x3e>
		s++, neg = 1;
  800b5a:	8d 52 01             	lea    0x1(%edx),%edx
  800b5d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b61:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b66:	75 15                	jne    800b7d <strtol+0x5a>
  800b68:	80 3a 30             	cmpb   $0x30,(%edx)
  800b6b:	75 10                	jne    800b7d <strtol+0x5a>
  800b6d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b71:	75 0a                	jne    800b7d <strtol+0x5a>
		s += 2, base = 16;
  800b73:	83 c2 02             	add    $0x2,%edx
  800b76:	b8 10 00 00 00       	mov    $0x10,%eax
  800b7b:	eb 10                	jmp    800b8d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b7d:	85 c0                	test   %eax,%eax
  800b7f:	75 0c                	jne    800b8d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b81:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b83:	80 3a 30             	cmpb   $0x30,(%edx)
  800b86:	75 05                	jne    800b8d <strtol+0x6a>
		s++, base = 8;
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b92:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b95:	0f b6 0a             	movzbl (%edx),%ecx
  800b98:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b9b:	89 f0                	mov    %esi,%eax
  800b9d:	3c 09                	cmp    $0x9,%al
  800b9f:	77 08                	ja     800ba9 <strtol+0x86>
			dig = *s - '0';
  800ba1:	0f be c9             	movsbl %cl,%ecx
  800ba4:	83 e9 30             	sub    $0x30,%ecx
  800ba7:	eb 20                	jmp    800bc9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ba9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	3c 19                	cmp    $0x19,%al
  800bb0:	77 08                	ja     800bba <strtol+0x97>
			dig = *s - 'a' + 10;
  800bb2:	0f be c9             	movsbl %cl,%ecx
  800bb5:	83 e9 57             	sub    $0x57,%ecx
  800bb8:	eb 0f                	jmp    800bc9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800bba:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bbd:	89 f0                	mov    %esi,%eax
  800bbf:	3c 19                	cmp    $0x19,%al
  800bc1:	77 16                	ja     800bd9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bc3:	0f be c9             	movsbl %cl,%ecx
  800bc6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bc9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bcc:	7d 0f                	jge    800bdd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bce:	83 c2 01             	add    $0x1,%edx
  800bd1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bd5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bd7:	eb bc                	jmp    800b95 <strtol+0x72>
  800bd9:	89 d8                	mov    %ebx,%eax
  800bdb:	eb 02                	jmp    800bdf <strtol+0xbc>
  800bdd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bdf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be3:	74 05                	je     800bea <strtol+0xc7>
		*endptr = (char *) s;
  800be5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800be8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bea:	f7 d8                	neg    %eax
  800bec:	85 ff                	test   %edi,%edi
  800bee:	0f 44 c3             	cmove  %ebx,%eax
}
  800bf1:	5b                   	pop    %ebx
  800bf2:	5e                   	pop    %esi
  800bf3:	5f                   	pop    %edi
  800bf4:	5d                   	pop    %ebp
  800bf5:	c3                   	ret    

00800bf6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	57                   	push   %edi
  800bfa:	56                   	push   %esi
  800bfb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
  800c01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c04:	8b 55 08             	mov    0x8(%ebp),%edx
  800c07:	89 c3                	mov    %eax,%ebx
  800c09:	89 c7                	mov    %eax,%edi
  800c0b:	89 c6                	mov    %eax,%esi
  800c0d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    

00800c14 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	57                   	push   %edi
  800c18:	56                   	push   %esi
  800c19:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c24:	89 d1                	mov    %edx,%ecx
  800c26:	89 d3                	mov    %edx,%ebx
  800c28:	89 d7                	mov    %edx,%edi
  800c2a:	89 d6                	mov    %edx,%esi
  800c2c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c2e:	5b                   	pop    %ebx
  800c2f:	5e                   	pop    %esi
  800c30:	5f                   	pop    %edi
  800c31:	5d                   	pop    %ebp
  800c32:	c3                   	ret    

00800c33 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c41:	b8 03 00 00 00       	mov    $0x3,%eax
  800c46:	8b 55 08             	mov    0x8(%ebp),%edx
  800c49:	89 cb                	mov    %ecx,%ebx
  800c4b:	89 cf                	mov    %ecx,%edi
  800c4d:	89 ce                	mov    %ecx,%esi
  800c4f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c51:	85 c0                	test   %eax,%eax
  800c53:	7e 28                	jle    800c7d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c55:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c59:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c60:	00 
  800c61:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800c68:	00 
  800c69:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c70:	00 
  800c71:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800c78:	e8 04 f5 ff ff       	call   800181 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7d:	83 c4 2c             	add    $0x2c,%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c90:	b8 02 00 00 00       	mov    $0x2,%eax
  800c95:	89 d1                	mov    %edx,%ecx
  800c97:	89 d3                	mov    %edx,%ebx
  800c99:	89 d7                	mov    %edx,%edi
  800c9b:	89 d6                	mov    %edx,%esi
  800c9d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c9f:	5b                   	pop    %ebx
  800ca0:	5e                   	pop    %esi
  800ca1:	5f                   	pop    %edi
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    

00800ca4 <sys_yield>:

void
sys_yield(void)
{
  800ca4:	55                   	push   %ebp
  800ca5:	89 e5                	mov    %esp,%ebp
  800ca7:	57                   	push   %edi
  800ca8:	56                   	push   %esi
  800ca9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800caa:	ba 00 00 00 00       	mov    $0x0,%edx
  800caf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb4:	89 d1                	mov    %edx,%ecx
  800cb6:	89 d3                	mov    %edx,%ebx
  800cb8:	89 d7                	mov    %edx,%edi
  800cba:	89 d6                	mov    %edx,%esi
  800cbc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cbe:	5b                   	pop    %ebx
  800cbf:	5e                   	pop    %esi
  800cc0:	5f                   	pop    %edi
  800cc1:	5d                   	pop    %ebp
  800cc2:	c3                   	ret    

00800cc3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ccc:	be 00 00 00 00       	mov    $0x0,%esi
  800cd1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cdf:	89 f7                	mov    %esi,%edi
  800ce1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ce3:	85 c0                	test   %eax,%eax
  800ce5:	7e 28                	jle    800d0f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ceb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800cf2:	00 
  800cf3:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800cfa:	00 
  800cfb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d02:	00 
  800d03:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800d0a:	e8 72 f4 ff ff       	call   800181 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0f:	83 c4 2c             	add    $0x2c,%esp
  800d12:	5b                   	pop    %ebx
  800d13:	5e                   	pop    %esi
  800d14:	5f                   	pop    %edi
  800d15:	5d                   	pop    %ebp
  800d16:	c3                   	ret    

00800d17 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d20:	b8 05 00 00 00       	mov    $0x5,%eax
  800d25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d2e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d31:	8b 75 18             	mov    0x18(%ebp),%esi
  800d34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7e 28                	jle    800d62 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d3e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d45:	00 
  800d46:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800d4d:	00 
  800d4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d55:	00 
  800d56:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800d5d:	e8 1f f4 ff ff       	call   800181 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d62:	83 c4 2c             	add    $0x2c,%esp
  800d65:	5b                   	pop    %ebx
  800d66:	5e                   	pop    %esi
  800d67:	5f                   	pop    %edi
  800d68:	5d                   	pop    %ebp
  800d69:	c3                   	ret    

00800d6a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
  800d6d:	57                   	push   %edi
  800d6e:	56                   	push   %esi
  800d6f:	53                   	push   %ebx
  800d70:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d78:	b8 06 00 00 00       	mov    $0x6,%eax
  800d7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d80:	8b 55 08             	mov    0x8(%ebp),%edx
  800d83:	89 df                	mov    %ebx,%edi
  800d85:	89 de                	mov    %ebx,%esi
  800d87:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d89:	85 c0                	test   %eax,%eax
  800d8b:	7e 28                	jle    800db5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d91:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d98:	00 
  800d99:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800da0:	00 
  800da1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800da8:	00 
  800da9:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800db0:	e8 cc f3 ff ff       	call   800181 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800db5:	83 c4 2c             	add    $0x2c,%esp
  800db8:	5b                   	pop    %ebx
  800db9:	5e                   	pop    %esi
  800dba:	5f                   	pop    %edi
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
  800dc3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	89 df                	mov    %ebx,%edi
  800dd8:	89 de                	mov    %ebx,%esi
  800dda:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	7e 28                	jle    800e08 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800deb:	00 
  800dec:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800df3:	00 
  800df4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfb:	00 
  800dfc:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800e03:	e8 79 f3 ff ff       	call   800181 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e08:	83 c4 2c             	add    $0x2c,%esp
  800e0b:	5b                   	pop    %ebx
  800e0c:	5e                   	pop    %esi
  800e0d:	5f                   	pop    %edi
  800e0e:	5d                   	pop    %ebp
  800e0f:	c3                   	ret    

00800e10 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e10:	55                   	push   %ebp
  800e11:	89 e5                	mov    %esp,%ebp
  800e13:	57                   	push   %edi
  800e14:	56                   	push   %esi
  800e15:	53                   	push   %ebx
  800e16:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e19:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e26:	8b 55 08             	mov    0x8(%ebp),%edx
  800e29:	89 df                	mov    %ebx,%edi
  800e2b:	89 de                	mov    %ebx,%esi
  800e2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	7e 28                	jle    800e5b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e37:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e3e:	00 
  800e3f:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800e46:	00 
  800e47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4e:	00 
  800e4f:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800e56:	e8 26 f3 ff ff       	call   800181 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5b:	83 c4 2c             	add    $0x2c,%esp
  800e5e:	5b                   	pop    %ebx
  800e5f:	5e                   	pop    %esi
  800e60:	5f                   	pop    %edi
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
  800e66:	57                   	push   %edi
  800e67:	56                   	push   %esi
  800e68:	53                   	push   %ebx
  800e69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e71:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	89 df                	mov    %ebx,%edi
  800e7e:	89 de                	mov    %ebx,%esi
  800e80:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	7e 28                	jle    800eae <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e86:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e91:	00 
  800e92:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800e99:	00 
  800e9a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea1:	00 
  800ea2:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800ea9:	e8 d3 f2 ff ff       	call   800181 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eae:	83 c4 2c             	add    $0x2c,%esp
  800eb1:	5b                   	pop    %ebx
  800eb2:	5e                   	pop    %esi
  800eb3:	5f                   	pop    %edi
  800eb4:	5d                   	pop    %ebp
  800eb5:	c3                   	ret    

00800eb6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	57                   	push   %edi
  800eba:	56                   	push   %esi
  800ebb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ebc:	be 00 00 00 00       	mov    $0x0,%esi
  800ec1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ecf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed4:	5b                   	pop    %ebx
  800ed5:	5e                   	pop    %esi
  800ed6:	5f                   	pop    %edi
  800ed7:	5d                   	pop    %ebp
  800ed8:	c3                   	ret    

00800ed9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ed9:	55                   	push   %ebp
  800eda:	89 e5                	mov    %esp,%ebp
  800edc:	57                   	push   %edi
  800edd:	56                   	push   %esi
  800ede:	53                   	push   %ebx
  800edf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	89 cb                	mov    %ecx,%ebx
  800ef1:	89 cf                	mov    %ecx,%edi
  800ef3:	89 ce                	mov    %ecx,%esi
  800ef5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7e 28                	jle    800f23 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eff:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f06:	00 
  800f07:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f16:	00 
  800f17:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800f1e:	e8 5e f2 ff ff       	call   800181 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f23:	83 c4 2c             	add    $0x2c,%esp
  800f26:	5b                   	pop    %ebx
  800f27:	5e                   	pop    %esi
  800f28:	5f                   	pop    %edi
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f31:	ba 00 00 00 00       	mov    $0x0,%edx
  800f36:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f3b:	89 d1                	mov    %edx,%ecx
  800f3d:	89 d3                	mov    %edx,%ebx
  800f3f:	89 d7                	mov    %edx,%edi
  800f41:	89 d6                	mov    %edx,%esi
  800f43:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
  800f50:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f58:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f60:	8b 55 08             	mov    0x8(%ebp),%edx
  800f63:	89 df                	mov    %ebx,%edi
  800f65:	89 de                	mov    %ebx,%esi
  800f67:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f69:	85 c0                	test   %eax,%eax
  800f6b:	7e 28                	jle    800f95 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f6d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f71:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f78:	00 
  800f79:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800f80:	00 
  800f81:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f88:	00 
  800f89:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800f90:	e8 ec f1 ff ff       	call   800181 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f95:	83 c4 2c             	add    $0x2c,%esp
  800f98:	5b                   	pop    %ebx
  800f99:	5e                   	pop    %esi
  800f9a:	5f                   	pop    %edi
  800f9b:	5d                   	pop    %ebp
  800f9c:	c3                   	ret    

00800f9d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
  800fa3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fab:	b8 10 00 00 00       	mov    $0x10,%eax
  800fb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb6:	89 df                	mov    %ebx,%edi
  800fb8:	89 de                	mov    %ebx,%esi
  800fba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	7e 28                	jle    800fe8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 08 ff 29 80 	movl   $0x8029ff,0x8(%esp)
  800fd3:	00 
  800fd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdb:	00 
  800fdc:	c7 04 24 1c 2a 80 00 	movl   $0x802a1c,(%esp)
  800fe3:	e8 99 f1 ff ff       	call   800181 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800fe8:	83 c4 2c             	add    $0x2c,%esp
  800feb:	5b                   	pop    %ebx
  800fec:	5e                   	pop    %esi
  800fed:	5f                   	pop    %edi
  800fee:	5d                   	pop    %ebp
  800fef:	c3                   	ret    

00800ff0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ff0:	55                   	push   %ebp
  800ff1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	05 00 00 00 30       	add    $0x30000000,%eax
  800ffb:	c1 e8 0c             	shr    $0xc,%eax
}
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80100b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801010:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801015:	5d                   	pop    %ebp
  801016:	c3                   	ret    

00801017 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801022:	89 c2                	mov    %eax,%edx
  801024:	c1 ea 16             	shr    $0x16,%edx
  801027:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80102e:	f6 c2 01             	test   $0x1,%dl
  801031:	74 11                	je     801044 <fd_alloc+0x2d>
  801033:	89 c2                	mov    %eax,%edx
  801035:	c1 ea 0c             	shr    $0xc,%edx
  801038:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80103f:	f6 c2 01             	test   $0x1,%dl
  801042:	75 09                	jne    80104d <fd_alloc+0x36>
			*fd_store = fd;
  801044:	89 01                	mov    %eax,(%ecx)
			return 0;
  801046:	b8 00 00 00 00       	mov    $0x0,%eax
  80104b:	eb 17                	jmp    801064 <fd_alloc+0x4d>
  80104d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801052:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801057:	75 c9                	jne    801022 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801059:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80105f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801064:	5d                   	pop    %ebp
  801065:	c3                   	ret    

00801066 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80106c:	83 f8 1f             	cmp    $0x1f,%eax
  80106f:	77 36                	ja     8010a7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801071:	c1 e0 0c             	shl    $0xc,%eax
  801074:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801079:	89 c2                	mov    %eax,%edx
  80107b:	c1 ea 16             	shr    $0x16,%edx
  80107e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801085:	f6 c2 01             	test   $0x1,%dl
  801088:	74 24                	je     8010ae <fd_lookup+0x48>
  80108a:	89 c2                	mov    %eax,%edx
  80108c:	c1 ea 0c             	shr    $0xc,%edx
  80108f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801096:	f6 c2 01             	test   $0x1,%dl
  801099:	74 1a                	je     8010b5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80109b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109e:	89 02                	mov    %eax,(%edx)
	return 0;
  8010a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8010a5:	eb 13                	jmp    8010ba <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010a7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ac:	eb 0c                	jmp    8010ba <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8010ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b3:	eb 05                	jmp    8010ba <fd_lookup+0x54>
  8010b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	83 ec 18             	sub    $0x18,%esp
  8010c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8010c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ca:	eb 13                	jmp    8010df <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8010cc:	39 08                	cmp    %ecx,(%eax)
  8010ce:	75 0c                	jne    8010dc <dev_lookup+0x20>
			*dev = devtab[i];
  8010d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8010da:	eb 38                	jmp    801114 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8010dc:	83 c2 01             	add    $0x1,%edx
  8010df:	8b 04 95 ac 2a 80 00 	mov    0x802aac(,%edx,4),%eax
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	75 e2                	jne    8010cc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ea:	a1 08 40 80 00       	mov    0x804008,%eax
  8010ef:	8b 40 48             	mov    0x48(%eax),%eax
  8010f2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010fa:	c7 04 24 2c 2a 80 00 	movl   $0x802a2c,(%esp)
  801101:	e8 74 f1 ff ff       	call   80027a <cprintf>
	*dev = 0;
  801106:	8b 45 0c             	mov    0xc(%ebp),%eax
  801109:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	56                   	push   %esi
  80111a:	53                   	push   %ebx
  80111b:	83 ec 20             	sub    $0x20,%esp
  80111e:	8b 75 08             	mov    0x8(%ebp),%esi
  801121:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801124:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801127:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801131:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801134:	89 04 24             	mov    %eax,(%esp)
  801137:	e8 2a ff ff ff       	call   801066 <fd_lookup>
  80113c:	85 c0                	test   %eax,%eax
  80113e:	78 05                	js     801145 <fd_close+0x2f>
	    || fd != fd2)
  801140:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801143:	74 0c                	je     801151 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801145:	84 db                	test   %bl,%bl
  801147:	ba 00 00 00 00       	mov    $0x0,%edx
  80114c:	0f 44 c2             	cmove  %edx,%eax
  80114f:	eb 3f                	jmp    801190 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801151:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801154:	89 44 24 04          	mov    %eax,0x4(%esp)
  801158:	8b 06                	mov    (%esi),%eax
  80115a:	89 04 24             	mov    %eax,(%esp)
  80115d:	e8 5a ff ff ff       	call   8010bc <dev_lookup>
  801162:	89 c3                	mov    %eax,%ebx
  801164:	85 c0                	test   %eax,%eax
  801166:	78 16                	js     80117e <fd_close+0x68>
		if (dev->dev_close)
  801168:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80116b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80116e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801173:	85 c0                	test   %eax,%eax
  801175:	74 07                	je     80117e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801177:	89 34 24             	mov    %esi,(%esp)
  80117a:	ff d0                	call   *%eax
  80117c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80117e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801182:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801189:	e8 dc fb ff ff       	call   800d6a <sys_page_unmap>
	return r;
  80118e:	89 d8                	mov    %ebx,%eax
}
  801190:	83 c4 20             	add    $0x20,%esp
  801193:	5b                   	pop    %ebx
  801194:	5e                   	pop    %esi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80119d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	89 04 24             	mov    %eax,(%esp)
  8011aa:	e8 b7 fe ff ff       	call   801066 <fd_lookup>
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	85 d2                	test   %edx,%edx
  8011b3:	78 13                	js     8011c8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8011b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8011bc:	00 
  8011bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011c0:	89 04 24             	mov    %eax,(%esp)
  8011c3:	e8 4e ff ff ff       	call   801116 <fd_close>
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <close_all>:

void
close_all(void)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d6:	89 1c 24             	mov    %ebx,(%esp)
  8011d9:	e8 b9 ff ff ff       	call   801197 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8011de:	83 c3 01             	add    $0x1,%ebx
  8011e1:	83 fb 20             	cmp    $0x20,%ebx
  8011e4:	75 f0                	jne    8011d6 <close_all+0xc>
		close(i);
}
  8011e6:	83 c4 14             	add    $0x14,%esp
  8011e9:	5b                   	pop    %ebx
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    

008011ec <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	57                   	push   %edi
  8011f0:	56                   	push   %esi
  8011f1:	53                   	push   %ebx
  8011f2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	89 04 24             	mov    %eax,(%esp)
  801202:	e8 5f fe ff ff       	call   801066 <fd_lookup>
  801207:	89 c2                	mov    %eax,%edx
  801209:	85 d2                	test   %edx,%edx
  80120b:	0f 88 e1 00 00 00    	js     8012f2 <dup+0x106>
		return r;
	close(newfdnum);
  801211:	8b 45 0c             	mov    0xc(%ebp),%eax
  801214:	89 04 24             	mov    %eax,(%esp)
  801217:	e8 7b ff ff ff       	call   801197 <close>

	newfd = INDEX2FD(newfdnum);
  80121c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80121f:	c1 e3 0c             	shl    $0xc,%ebx
  801222:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801228:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80122b:	89 04 24             	mov    %eax,(%esp)
  80122e:	e8 cd fd ff ff       	call   801000 <fd2data>
  801233:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801235:	89 1c 24             	mov    %ebx,(%esp)
  801238:	e8 c3 fd ff ff       	call   801000 <fd2data>
  80123d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80123f:	89 f0                	mov    %esi,%eax
  801241:	c1 e8 16             	shr    $0x16,%eax
  801244:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124b:	a8 01                	test   $0x1,%al
  80124d:	74 43                	je     801292 <dup+0xa6>
  80124f:	89 f0                	mov    %esi,%eax
  801251:	c1 e8 0c             	shr    $0xc,%eax
  801254:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125b:	f6 c2 01             	test   $0x1,%dl
  80125e:	74 32                	je     801292 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801260:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801267:	25 07 0e 00 00       	and    $0xe07,%eax
  80126c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801270:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801274:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80127b:	00 
  80127c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801280:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801287:	e8 8b fa ff ff       	call   800d17 <sys_page_map>
  80128c:	89 c6                	mov    %eax,%esi
  80128e:	85 c0                	test   %eax,%eax
  801290:	78 3e                	js     8012d0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801292:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801295:	89 c2                	mov    %eax,%edx
  801297:	c1 ea 0c             	shr    $0xc,%edx
  80129a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012a1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8012a7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8012af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012b6:	00 
  8012b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012c2:	e8 50 fa ff ff       	call   800d17 <sys_page_map>
  8012c7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8012c9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012cc:	85 f6                	test   %esi,%esi
  8012ce:	79 22                	jns    8012f2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8012d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012db:	e8 8a fa ff ff       	call   800d6a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012eb:	e8 7a fa ff ff       	call   800d6a <sys_page_unmap>
	return r;
  8012f0:	89 f0                	mov    %esi,%eax
}
  8012f2:	83 c4 3c             	add    $0x3c,%esp
  8012f5:	5b                   	pop    %ebx
  8012f6:	5e                   	pop    %esi
  8012f7:	5f                   	pop    %edi
  8012f8:	5d                   	pop    %ebp
  8012f9:	c3                   	ret    

008012fa <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	53                   	push   %ebx
  8012fe:	83 ec 24             	sub    $0x24,%esp
  801301:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801304:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801307:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130b:	89 1c 24             	mov    %ebx,(%esp)
  80130e:	e8 53 fd ff ff       	call   801066 <fd_lookup>
  801313:	89 c2                	mov    %eax,%edx
  801315:	85 d2                	test   %edx,%edx
  801317:	78 6d                	js     801386 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801319:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801320:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801323:	8b 00                	mov    (%eax),%eax
  801325:	89 04 24             	mov    %eax,(%esp)
  801328:	e8 8f fd ff ff       	call   8010bc <dev_lookup>
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 55                	js     801386 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801334:	8b 50 08             	mov    0x8(%eax),%edx
  801337:	83 e2 03             	and    $0x3,%edx
  80133a:	83 fa 01             	cmp    $0x1,%edx
  80133d:	75 23                	jne    801362 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80133f:	a1 08 40 80 00       	mov    0x804008,%eax
  801344:	8b 40 48             	mov    0x48(%eax),%eax
  801347:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80134b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134f:	c7 04 24 70 2a 80 00 	movl   $0x802a70,(%esp)
  801356:	e8 1f ef ff ff       	call   80027a <cprintf>
		return -E_INVAL;
  80135b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801360:	eb 24                	jmp    801386 <read+0x8c>
	}
	if (!dev->dev_read)
  801362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801365:	8b 52 08             	mov    0x8(%edx),%edx
  801368:	85 d2                	test   %edx,%edx
  80136a:	74 15                	je     801381 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80136c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80136f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801373:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801376:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80137a:	89 04 24             	mov    %eax,(%esp)
  80137d:	ff d2                	call   *%edx
  80137f:	eb 05                	jmp    801386 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801381:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801386:	83 c4 24             	add    $0x24,%esp
  801389:	5b                   	pop    %ebx
  80138a:	5d                   	pop    %ebp
  80138b:	c3                   	ret    

0080138c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	57                   	push   %edi
  801390:	56                   	push   %esi
  801391:	53                   	push   %ebx
  801392:	83 ec 1c             	sub    $0x1c,%esp
  801395:	8b 7d 08             	mov    0x8(%ebp),%edi
  801398:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80139b:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a0:	eb 23                	jmp    8013c5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013a2:	89 f0                	mov    %esi,%eax
  8013a4:	29 d8                	sub    %ebx,%eax
  8013a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013aa:	89 d8                	mov    %ebx,%eax
  8013ac:	03 45 0c             	add    0xc(%ebp),%eax
  8013af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b3:	89 3c 24             	mov    %edi,(%esp)
  8013b6:	e8 3f ff ff ff       	call   8012fa <read>
		if (m < 0)
  8013bb:	85 c0                	test   %eax,%eax
  8013bd:	78 10                	js     8013cf <readn+0x43>
			return m;
		if (m == 0)
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	74 0a                	je     8013cd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013c3:	01 c3                	add    %eax,%ebx
  8013c5:	39 f3                	cmp    %esi,%ebx
  8013c7:	72 d9                	jb     8013a2 <readn+0x16>
  8013c9:	89 d8                	mov    %ebx,%eax
  8013cb:	eb 02                	jmp    8013cf <readn+0x43>
  8013cd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8013cf:	83 c4 1c             	add    $0x1c,%esp
  8013d2:	5b                   	pop    %ebx
  8013d3:	5e                   	pop    %esi
  8013d4:	5f                   	pop    %edi
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	53                   	push   %ebx
  8013db:	83 ec 24             	sub    $0x24,%esp
  8013de:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e8:	89 1c 24             	mov    %ebx,(%esp)
  8013eb:	e8 76 fc ff ff       	call   801066 <fd_lookup>
  8013f0:	89 c2                	mov    %eax,%edx
  8013f2:	85 d2                	test   %edx,%edx
  8013f4:	78 68                	js     80145e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	8b 00                	mov    (%eax),%eax
  801402:	89 04 24             	mov    %eax,(%esp)
  801405:	e8 b2 fc ff ff       	call   8010bc <dev_lookup>
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 50                	js     80145e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801411:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801415:	75 23                	jne    80143a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801417:	a1 08 40 80 00       	mov    0x804008,%eax
  80141c:	8b 40 48             	mov    0x48(%eax),%eax
  80141f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
  801427:	c7 04 24 8c 2a 80 00 	movl   $0x802a8c,(%esp)
  80142e:	e8 47 ee ff ff       	call   80027a <cprintf>
		return -E_INVAL;
  801433:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801438:	eb 24                	jmp    80145e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80143a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80143d:	8b 52 0c             	mov    0xc(%edx),%edx
  801440:	85 d2                	test   %edx,%edx
  801442:	74 15                	je     801459 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801444:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801447:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80144b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80144e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801452:	89 04 24             	mov    %eax,(%esp)
  801455:	ff d2                	call   *%edx
  801457:	eb 05                	jmp    80145e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801459:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80145e:	83 c4 24             	add    $0x24,%esp
  801461:	5b                   	pop    %ebx
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    

00801464 <seek>:

int
seek(int fdnum, off_t offset)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	89 04 24             	mov    %eax,(%esp)
  801477:	e8 ea fb ff ff       	call   801066 <fd_lookup>
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 0e                	js     80148e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801480:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801483:	8b 55 0c             	mov    0xc(%ebp),%edx
  801486:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801489:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148e:	c9                   	leave  
  80148f:	c3                   	ret    

00801490 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801490:	55                   	push   %ebp
  801491:	89 e5                	mov    %esp,%ebp
  801493:	53                   	push   %ebx
  801494:	83 ec 24             	sub    $0x24,%esp
  801497:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a1:	89 1c 24             	mov    %ebx,(%esp)
  8014a4:	e8 bd fb ff ff       	call   801066 <fd_lookup>
  8014a9:	89 c2                	mov    %eax,%edx
  8014ab:	85 d2                	test   %edx,%edx
  8014ad:	78 61                	js     801510 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b9:	8b 00                	mov    (%eax),%eax
  8014bb:	89 04 24             	mov    %eax,(%esp)
  8014be:	e8 f9 fb ff ff       	call   8010bc <dev_lookup>
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 49                	js     801510 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ce:	75 23                	jne    8014f3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8014d0:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d5:	8b 40 48             	mov    0x48(%eax),%eax
  8014d8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e0:	c7 04 24 4c 2a 80 00 	movl   $0x802a4c,(%esp)
  8014e7:	e8 8e ed ff ff       	call   80027a <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014f1:	eb 1d                	jmp    801510 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014f6:	8b 52 18             	mov    0x18(%edx),%edx
  8014f9:	85 d2                	test   %edx,%edx
  8014fb:	74 0e                	je     80150b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801500:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	ff d2                	call   *%edx
  801509:	eb 05                	jmp    801510 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80150b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801510:	83 c4 24             	add    $0x24,%esp
  801513:	5b                   	pop    %ebx
  801514:	5d                   	pop    %ebp
  801515:	c3                   	ret    

00801516 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801516:	55                   	push   %ebp
  801517:	89 e5                	mov    %esp,%ebp
  801519:	53                   	push   %ebx
  80151a:	83 ec 24             	sub    $0x24,%esp
  80151d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801520:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801523:	89 44 24 04          	mov    %eax,0x4(%esp)
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	89 04 24             	mov    %eax,(%esp)
  80152d:	e8 34 fb ff ff       	call   801066 <fd_lookup>
  801532:	89 c2                	mov    %eax,%edx
  801534:	85 d2                	test   %edx,%edx
  801536:	78 52                	js     80158a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	8b 00                	mov    (%eax),%eax
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 70 fb ff ff       	call   8010bc <dev_lookup>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 3a                	js     80158a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801557:	74 2c                	je     801585 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801559:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80155c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801563:	00 00 00 
	stat->st_isdir = 0;
  801566:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80156d:	00 00 00 
	stat->st_dev = dev;
  801570:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801576:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80157a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157d:	89 14 24             	mov    %edx,(%esp)
  801580:	ff 50 14             	call   *0x14(%eax)
  801583:	eb 05                	jmp    80158a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801585:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80158a:	83 c4 24             	add    $0x24,%esp
  80158d:	5b                   	pop    %ebx
  80158e:	5d                   	pop    %ebp
  80158f:	c3                   	ret    

00801590 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	56                   	push   %esi
  801594:	53                   	push   %ebx
  801595:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801598:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80159f:	00 
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	89 04 24             	mov    %eax,(%esp)
  8015a6:	e8 28 02 00 00       	call   8017d3 <open>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	85 db                	test   %ebx,%ebx
  8015af:	78 1b                	js     8015cc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b8:	89 1c 24             	mov    %ebx,(%esp)
  8015bb:	e8 56 ff ff ff       	call   801516 <fstat>
  8015c0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015c2:	89 1c 24             	mov    %ebx,(%esp)
  8015c5:	e8 cd fb ff ff       	call   801197 <close>
	return r;
  8015ca:	89 f0                	mov    %esi,%eax
}
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	5b                   	pop    %ebx
  8015d0:	5e                   	pop    %esi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	56                   	push   %esi
  8015d7:	53                   	push   %ebx
  8015d8:	83 ec 10             	sub    $0x10,%esp
  8015db:	89 c6                	mov    %eax,%esi
  8015dd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015df:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015e6:	75 11                	jne    8015f9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015ef:	e8 7a 0d 00 00       	call   80236e <ipc_find_env>
  8015f4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015f9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801600:	00 
  801601:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801608:	00 
  801609:	89 74 24 04          	mov    %esi,0x4(%esp)
  80160d:	a1 00 40 80 00       	mov    0x804000,%eax
  801612:	89 04 24             	mov    %eax,(%esp)
  801615:	e8 f6 0c 00 00       	call   802310 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80161a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801621:	00 
  801622:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801626:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80162d:	e8 74 0c 00 00       	call   8022a6 <ipc_recv>
}
  801632:	83 c4 10             	add    $0x10,%esp
  801635:	5b                   	pop    %ebx
  801636:	5e                   	pop    %esi
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8b 40 0c             	mov    0xc(%eax),%eax
  801645:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80164a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801652:	ba 00 00 00 00       	mov    $0x0,%edx
  801657:	b8 02 00 00 00       	mov    $0x2,%eax
  80165c:	e8 72 ff ff ff       	call   8015d3 <fsipc>
}
  801661:	c9                   	leave  
  801662:	c3                   	ret    

00801663 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801669:	8b 45 08             	mov    0x8(%ebp),%eax
  80166c:	8b 40 0c             	mov    0xc(%eax),%eax
  80166f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801674:	ba 00 00 00 00       	mov    $0x0,%edx
  801679:	b8 06 00 00 00       	mov    $0x6,%eax
  80167e:	e8 50 ff ff ff       	call   8015d3 <fsipc>
}
  801683:	c9                   	leave  
  801684:	c3                   	ret    

00801685 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801685:	55                   	push   %ebp
  801686:	89 e5                	mov    %esp,%ebp
  801688:	53                   	push   %ebx
  801689:	83 ec 14             	sub    $0x14,%esp
  80168c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	8b 40 0c             	mov    0xc(%eax),%eax
  801695:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	b8 05 00 00 00       	mov    $0x5,%eax
  8016a4:	e8 2a ff ff ff       	call   8015d3 <fsipc>
  8016a9:	89 c2                	mov    %eax,%edx
  8016ab:	85 d2                	test   %edx,%edx
  8016ad:	78 2b                	js     8016da <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016af:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016b6:	00 
  8016b7:	89 1c 24             	mov    %ebx,(%esp)
  8016ba:	e8 e8 f1 ff ff       	call   8008a7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016bf:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ca:	a1 84 50 80 00       	mov    0x805084,%eax
  8016cf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	83 c4 14             	add    $0x14,%esp
  8016dd:	5b                   	pop    %ebx
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	83 ec 18             	sub    $0x18,%esp
  8016e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016ee:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016f3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8016f6:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	8b 52 0c             	mov    0xc(%edx),%edx
  801701:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801707:	89 44 24 08          	mov    %eax,0x8(%esp)
  80170b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80170e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801712:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801719:	e8 26 f3 ff ff       	call   800a44 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80171e:	ba 00 00 00 00       	mov    $0x0,%edx
  801723:	b8 04 00 00 00       	mov    $0x4,%eax
  801728:	e8 a6 fe ff ff       	call   8015d3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
  801734:	83 ec 10             	sub    $0x10,%esp
  801737:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801745:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	b8 03 00 00 00       	mov    $0x3,%eax
  801755:	e8 79 fe ff ff       	call   8015d3 <fsipc>
  80175a:	89 c3                	mov    %eax,%ebx
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 6a                	js     8017ca <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801760:	39 c6                	cmp    %eax,%esi
  801762:	73 24                	jae    801788 <devfile_read+0x59>
  801764:	c7 44 24 0c c0 2a 80 	movl   $0x802ac0,0xc(%esp)
  80176b:	00 
  80176c:	c7 44 24 08 c7 2a 80 	movl   $0x802ac7,0x8(%esp)
  801773:	00 
  801774:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80177b:	00 
  80177c:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  801783:	e8 f9 e9 ff ff       	call   800181 <_panic>
	assert(r <= PGSIZE);
  801788:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80178d:	7e 24                	jle    8017b3 <devfile_read+0x84>
  80178f:	c7 44 24 0c e7 2a 80 	movl   $0x802ae7,0xc(%esp)
  801796:	00 
  801797:	c7 44 24 08 c7 2a 80 	movl   $0x802ac7,0x8(%esp)
  80179e:	00 
  80179f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8017a6:	00 
  8017a7:	c7 04 24 dc 2a 80 00 	movl   $0x802adc,(%esp)
  8017ae:	e8 ce e9 ff ff       	call   800181 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017b7:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8017be:	00 
  8017bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c2:	89 04 24             	mov    %eax,(%esp)
  8017c5:	e8 7a f2 ff ff       	call   800a44 <memmove>
	return r;
}
  8017ca:	89 d8                	mov    %ebx,%eax
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	5b                   	pop    %ebx
  8017d0:	5e                   	pop    %esi
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 24             	sub    $0x24,%esp
  8017da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  8017dd:	89 1c 24             	mov    %ebx,(%esp)
  8017e0:	e8 8b f0 ff ff       	call   800870 <strlen>
  8017e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017ea:	7f 60                	jg     80184c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ef:	89 04 24             	mov    %eax,(%esp)
  8017f2:	e8 20 f8 ff ff       	call   801017 <fd_alloc>
  8017f7:	89 c2                	mov    %eax,%edx
  8017f9:	85 d2                	test   %edx,%edx
  8017fb:	78 54                	js     801851 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801801:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801808:	e8 9a f0 ff ff       	call   8008a7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80180d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801810:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801815:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801818:	b8 01 00 00 00       	mov    $0x1,%eax
  80181d:	e8 b1 fd ff ff       	call   8015d3 <fsipc>
  801822:	89 c3                	mov    %eax,%ebx
  801824:	85 c0                	test   %eax,%eax
  801826:	79 17                	jns    80183f <open+0x6c>
		fd_close(fd, 0);
  801828:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80182f:	00 
  801830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801833:	89 04 24             	mov    %eax,(%esp)
  801836:	e8 db f8 ff ff       	call   801116 <fd_close>
		return r;
  80183b:	89 d8                	mov    %ebx,%eax
  80183d:	eb 12                	jmp    801851 <open+0x7e>
	}

	return fd2num(fd);
  80183f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	e8 a6 f7 ff ff       	call   800ff0 <fd2num>
  80184a:	eb 05                	jmp    801851 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80184c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801851:	83 c4 24             	add    $0x24,%esp
  801854:	5b                   	pop    %ebx
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    

00801857 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	b8 08 00 00 00       	mov    $0x8,%eax
  801867:	e8 67 fd ff ff       	call   8015d3 <fsipc>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    
  80186e:	66 90                	xchg   %ax,%ax

00801870 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801876:	c7 44 24 04 f3 2a 80 	movl   $0x802af3,0x4(%esp)
  80187d:	00 
  80187e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801881:	89 04 24             	mov    %eax,(%esp)
  801884:	e8 1e f0 ff ff       	call   8008a7 <strcpy>
	return 0;
}
  801889:	b8 00 00 00 00       	mov    $0x0,%eax
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
  801893:	53                   	push   %ebx
  801894:	83 ec 14             	sub    $0x14,%esp
  801897:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80189a:	89 1c 24             	mov    %ebx,(%esp)
  80189d:	e8 04 0b 00 00       	call   8023a6 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8018a2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8018a7:	83 f8 01             	cmp    $0x1,%eax
  8018aa:	75 0d                	jne    8018b9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8018ac:	8b 43 0c             	mov    0xc(%ebx),%eax
  8018af:	89 04 24             	mov    %eax,(%esp)
  8018b2:	e8 29 03 00 00       	call   801be0 <nsipc_close>
  8018b7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8018b9:	89 d0                	mov    %edx,%eax
  8018bb:	83 c4 14             	add    $0x14,%esp
  8018be:	5b                   	pop    %ebx
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    

008018c1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ce:	00 
  8018cf:	8b 45 10             	mov    0x10(%ebp),%eax
  8018d2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e3:	89 04 24             	mov    %eax,(%esp)
  8018e6:	e8 f0 03 00 00       	call   801cdb <nsipc_send>
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018fa:	00 
  8018fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801902:	8b 45 0c             	mov    0xc(%ebp),%eax
  801905:	89 44 24 04          	mov    %eax,0x4(%esp)
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8b 40 0c             	mov    0xc(%eax),%eax
  80190f:	89 04 24             	mov    %eax,(%esp)
  801912:	e8 44 03 00 00       	call   801c5b <nsipc_recv>
}
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801922:	89 54 24 04          	mov    %edx,0x4(%esp)
  801926:	89 04 24             	mov    %eax,(%esp)
  801929:	e8 38 f7 ff ff       	call   801066 <fd_lookup>
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 17                	js     801949 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801935:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80193b:	39 08                	cmp    %ecx,(%eax)
  80193d:	75 05                	jne    801944 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80193f:	8b 40 0c             	mov    0xc(%eax),%eax
  801942:	eb 05                	jmp    801949 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801944:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	56                   	push   %esi
  80194f:	53                   	push   %ebx
  801950:	83 ec 20             	sub    $0x20,%esp
  801953:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801955:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801958:	89 04 24             	mov    %eax,(%esp)
  80195b:	e8 b7 f6 ff ff       	call   801017 <fd_alloc>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	85 c0                	test   %eax,%eax
  801964:	78 21                	js     801987 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801966:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80196d:	00 
  80196e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801971:	89 44 24 04          	mov    %eax,0x4(%esp)
  801975:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197c:	e8 42 f3 ff ff       	call   800cc3 <sys_page_alloc>
  801981:	89 c3                	mov    %eax,%ebx
  801983:	85 c0                	test   %eax,%eax
  801985:	79 0c                	jns    801993 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801987:	89 34 24             	mov    %esi,(%esp)
  80198a:	e8 51 02 00 00       	call   801be0 <nsipc_close>
		return r;
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	eb 20                	jmp    8019b3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801993:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80199e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8019a8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8019ab:	89 14 24             	mov    %edx,(%esp)
  8019ae:	e8 3d f6 ff ff       	call   800ff0 <fd2num>
}
  8019b3:	83 c4 20             	add    $0x20,%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5e                   	pop    %esi
  8019b8:	5d                   	pop    %ebp
  8019b9:	c3                   	ret    

008019ba <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8019ba:	55                   	push   %ebp
  8019bb:	89 e5                	mov    %esp,%ebp
  8019bd:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c3:	e8 51 ff ff ff       	call   801919 <fd2sockid>
		return r;
  8019c8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	78 23                	js     8019f1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ce:	8b 55 10             	mov    0x10(%ebp),%edx
  8019d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019dc:	89 04 24             	mov    %eax,(%esp)
  8019df:	e8 45 01 00 00       	call   801b29 <nsipc_accept>
		return r;
  8019e4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 07                	js     8019f1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019ea:	e8 5c ff ff ff       	call   80194b <alloc_sockfd>
  8019ef:	89 c1                	mov    %eax,%ecx
}
  8019f1:	89 c8                	mov    %ecx,%eax
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
  8019f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	e8 16 ff ff ff       	call   801919 <fd2sockid>
  801a03:	89 c2                	mov    %eax,%edx
  801a05:	85 d2                	test   %edx,%edx
  801a07:	78 16                	js     801a1f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801a09:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a17:	89 14 24             	mov    %edx,(%esp)
  801a1a:	e8 60 01 00 00       	call   801b7f <nsipc_bind>
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <shutdown>:

int
shutdown(int s, int how)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	e8 ea fe ff ff       	call   801919 <fd2sockid>
  801a2f:	89 c2                	mov    %eax,%edx
  801a31:	85 d2                	test   %edx,%edx
  801a33:	78 0f                	js     801a44 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a3c:	89 14 24             	mov    %edx,(%esp)
  801a3f:	e8 7a 01 00 00       	call   801bbe <nsipc_shutdown>
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	e8 c5 fe ff ff       	call   801919 <fd2sockid>
  801a54:	89 c2                	mov    %eax,%edx
  801a56:	85 d2                	test   %edx,%edx
  801a58:	78 16                	js     801a70 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a68:	89 14 24             	mov    %edx,(%esp)
  801a6b:	e8 8a 01 00 00       	call   801bfa <nsipc_connect>
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <listen>:

int
listen(int s, int backlog)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a78:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7b:	e8 99 fe ff ff       	call   801919 <fd2sockid>
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	85 d2                	test   %edx,%edx
  801a84:	78 0f                	js     801a95 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8d:	89 14 24             	mov    %edx,(%esp)
  801a90:	e8 a4 01 00 00       	call   801c39 <nsipc_listen>
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	89 04 24             	mov    %eax,(%esp)
  801ab1:	e8 98 02 00 00       	call   801d4e <nsipc_socket>
  801ab6:	89 c2                	mov    %eax,%edx
  801ab8:	85 d2                	test   %edx,%edx
  801aba:	78 05                	js     801ac1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801abc:	e8 8a fe ff ff       	call   80194b <alloc_sockfd>
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	53                   	push   %ebx
  801ac7:	83 ec 14             	sub    $0x14,%esp
  801aca:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801acc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801ad3:	75 11                	jne    801ae6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801adc:	e8 8d 08 00 00       	call   80236e <ipc_find_env>
  801ae1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ae6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801aed:	00 
  801aee:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801af5:	00 
  801af6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801afa:	a1 04 40 80 00       	mov    0x804004,%eax
  801aff:	89 04 24             	mov    %eax,(%esp)
  801b02:	e8 09 08 00 00       	call   802310 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b0e:	00 
  801b0f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b16:	00 
  801b17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1e:	e8 83 07 00 00       	call   8022a6 <ipc_recv>
}
  801b23:	83 c4 14             	add    $0x14,%esp
  801b26:	5b                   	pop    %ebx
  801b27:	5d                   	pop    %ebp
  801b28:	c3                   	ret    

00801b29 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b29:	55                   	push   %ebp
  801b2a:	89 e5                	mov    %esp,%ebp
  801b2c:	56                   	push   %esi
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 10             	sub    $0x10,%esp
  801b31:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b3c:	8b 06                	mov    (%esi),%eax
  801b3e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b43:	b8 01 00 00 00       	mov    $0x1,%eax
  801b48:	e8 76 ff ff ff       	call   801ac3 <nsipc>
  801b4d:	89 c3                	mov    %eax,%ebx
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	78 23                	js     801b76 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b53:	a1 10 60 80 00       	mov    0x806010,%eax
  801b58:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b5c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b63:	00 
  801b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b67:	89 04 24             	mov    %eax,(%esp)
  801b6a:	e8 d5 ee ff ff       	call   800a44 <memmove>
		*addrlen = ret->ret_addrlen;
  801b6f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b74:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b76:	89 d8                	mov    %ebx,%eax
  801b78:	83 c4 10             	add    $0x10,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5e                   	pop    %esi
  801b7d:	5d                   	pop    %ebp
  801b7e:	c3                   	ret    

00801b7f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	53                   	push   %ebx
  801b83:	83 ec 14             	sub    $0x14,%esp
  801b86:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b9c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ba3:	e8 9c ee ff ff       	call   800a44 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ba8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bae:	b8 02 00 00 00       	mov    $0x2,%eax
  801bb3:	e8 0b ff ff ff       	call   801ac3 <nsipc>
}
  801bb8:	83 c4 14             	add    $0x14,%esp
  801bbb:	5b                   	pop    %ebx
  801bbc:	5d                   	pop    %ebp
  801bbd:	c3                   	ret    

00801bbe <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
  801bc1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bcf:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bd4:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd9:	e8 e5 fe ff ff       	call   801ac3 <nsipc>
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <nsipc_close>:

int
nsipc_close(int s)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bee:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf3:	e8 cb fe ff ff       	call   801ac3 <nsipc>
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 14             	sub    $0x14,%esp
  801c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c0c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c10:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c17:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801c1e:	e8 21 ee ff ff       	call   800a44 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c23:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c29:	b8 05 00 00 00       	mov    $0x5,%eax
  801c2e:	e8 90 fe ff ff       	call   801ac3 <nsipc>
}
  801c33:	83 c4 14             	add    $0x14,%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c4f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c54:	e8 6a fe ff ff       	call   801ac3 <nsipc>
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 10             	sub    $0x10,%esp
  801c63:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c66:	8b 45 08             	mov    0x8(%ebp),%eax
  801c69:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c6e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c74:	8b 45 14             	mov    0x14(%ebp),%eax
  801c77:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c7c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c81:	e8 3d fe ff ff       	call   801ac3 <nsipc>
  801c86:	89 c3                	mov    %eax,%ebx
  801c88:	85 c0                	test   %eax,%eax
  801c8a:	78 46                	js     801cd2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c8c:	39 f0                	cmp    %esi,%eax
  801c8e:	7f 07                	jg     801c97 <nsipc_recv+0x3c>
  801c90:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c95:	7e 24                	jle    801cbb <nsipc_recv+0x60>
  801c97:	c7 44 24 0c ff 2a 80 	movl   $0x802aff,0xc(%esp)
  801c9e:	00 
  801c9f:	c7 44 24 08 c7 2a 80 	movl   $0x802ac7,0x8(%esp)
  801ca6:	00 
  801ca7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801cae:	00 
  801caf:	c7 04 24 14 2b 80 00 	movl   $0x802b14,(%esp)
  801cb6:	e8 c6 e4 ff ff       	call   800181 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801cbb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbf:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801cc6:	00 
  801cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 72 ed ff ff       	call   800a44 <memmove>
	}

	return r;
}
  801cd2:	89 d8                	mov    %ebx,%eax
  801cd4:	83 c4 10             	add    $0x10,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5d                   	pop    %ebp
  801cda:	c3                   	ret    

00801cdb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cdb:	55                   	push   %ebp
  801cdc:	89 e5                	mov    %esp,%ebp
  801cde:	53                   	push   %ebx
  801cdf:	83 ec 14             	sub    $0x14,%esp
  801ce2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ced:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cf3:	7e 24                	jle    801d19 <nsipc_send+0x3e>
  801cf5:	c7 44 24 0c 20 2b 80 	movl   $0x802b20,0xc(%esp)
  801cfc:	00 
  801cfd:	c7 44 24 08 c7 2a 80 	movl   $0x802ac7,0x8(%esp)
  801d04:	00 
  801d05:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801d0c:	00 
  801d0d:	c7 04 24 14 2b 80 00 	movl   $0x802b14,(%esp)
  801d14:	e8 68 e4 ff ff       	call   800181 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d24:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801d2b:	e8 14 ed ff ff       	call   800a44 <memmove>
	nsipcbuf.send.req_size = size;
  801d30:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d36:	8b 45 14             	mov    0x14(%ebp),%eax
  801d39:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d43:	e8 7b fd ff ff       	call   801ac3 <nsipc>
}
  801d48:	83 c4 14             	add    $0x14,%esp
  801d4b:	5b                   	pop    %ebx
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d54:	8b 45 08             	mov    0x8(%ebp),%eax
  801d57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d5f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d64:	8b 45 10             	mov    0x10(%ebp),%eax
  801d67:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d6c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d71:	e8 4d fd ff ff       	call   801ac3 <nsipc>
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	56                   	push   %esi
  801d7c:	53                   	push   %ebx
  801d7d:	83 ec 10             	sub    $0x10,%esp
  801d80:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 72 f2 ff ff       	call   801000 <fd2data>
  801d8e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d90:	c7 44 24 04 2c 2b 80 	movl   $0x802b2c,0x4(%esp)
  801d97:	00 
  801d98:	89 1c 24             	mov    %ebx,(%esp)
  801d9b:	e8 07 eb ff ff       	call   8008a7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801da0:	8b 46 04             	mov    0x4(%esi),%eax
  801da3:	2b 06                	sub    (%esi),%eax
  801da5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801dab:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801db2:	00 00 00 
	stat->st_dev = &devpipe;
  801db5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801dbc:	30 80 00 
	return 0;
}
  801dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	5b                   	pop    %ebx
  801dc8:	5e                   	pop    %esi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801dd5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de0:	e8 85 ef ff ff       	call   800d6a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801de5:	89 1c 24             	mov    %ebx,(%esp)
  801de8:	e8 13 f2 ff ff       	call   801000 <fd2data>
  801ded:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df8:	e8 6d ef ff ff       	call   800d6a <sys_page_unmap>
}
  801dfd:	83 c4 14             	add    $0x14,%esp
  801e00:	5b                   	pop    %ebx
  801e01:	5d                   	pop    %ebp
  801e02:	c3                   	ret    

00801e03 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	57                   	push   %edi
  801e07:	56                   	push   %esi
  801e08:	53                   	push   %ebx
  801e09:	83 ec 2c             	sub    $0x2c,%esp
  801e0c:	89 c6                	mov    %eax,%esi
  801e0e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801e11:	a1 08 40 80 00       	mov    0x804008,%eax
  801e16:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e19:	89 34 24             	mov    %esi,(%esp)
  801e1c:	e8 85 05 00 00       	call   8023a6 <pageref>
  801e21:	89 c7                	mov    %eax,%edi
  801e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e26:	89 04 24             	mov    %eax,(%esp)
  801e29:	e8 78 05 00 00       	call   8023a6 <pageref>
  801e2e:	39 c7                	cmp    %eax,%edi
  801e30:	0f 94 c2             	sete   %dl
  801e33:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801e36:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801e3c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801e3f:	39 fb                	cmp    %edi,%ebx
  801e41:	74 21                	je     801e64 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e43:	84 d2                	test   %dl,%dl
  801e45:	74 ca                	je     801e11 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e47:	8b 51 58             	mov    0x58(%ecx),%edx
  801e4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e56:	c7 04 24 33 2b 80 00 	movl   $0x802b33,(%esp)
  801e5d:	e8 18 e4 ff ff       	call   80027a <cprintf>
  801e62:	eb ad                	jmp    801e11 <_pipeisclosed+0xe>
	}
}
  801e64:	83 c4 2c             	add    $0x2c,%esp
  801e67:	5b                   	pop    %ebx
  801e68:	5e                   	pop    %esi
  801e69:	5f                   	pop    %edi
  801e6a:	5d                   	pop    %ebp
  801e6b:	c3                   	ret    

00801e6c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e6c:	55                   	push   %ebp
  801e6d:	89 e5                	mov    %esp,%ebp
  801e6f:	57                   	push   %edi
  801e70:	56                   	push   %esi
  801e71:	53                   	push   %ebx
  801e72:	83 ec 1c             	sub    $0x1c,%esp
  801e75:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e78:	89 34 24             	mov    %esi,(%esp)
  801e7b:	e8 80 f1 ff ff       	call   801000 <fd2data>
  801e80:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e82:	bf 00 00 00 00       	mov    $0x0,%edi
  801e87:	eb 45                	jmp    801ece <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e89:	89 da                	mov    %ebx,%edx
  801e8b:	89 f0                	mov    %esi,%eax
  801e8d:	e8 71 ff ff ff       	call   801e03 <_pipeisclosed>
  801e92:	85 c0                	test   %eax,%eax
  801e94:	75 41                	jne    801ed7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e96:	e8 09 ee ff ff       	call   800ca4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e9b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e9e:	8b 0b                	mov    (%ebx),%ecx
  801ea0:	8d 51 20             	lea    0x20(%ecx),%edx
  801ea3:	39 d0                	cmp    %edx,%eax
  801ea5:	73 e2                	jae    801e89 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eaa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801eae:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801eb1:	99                   	cltd   
  801eb2:	c1 ea 1b             	shr    $0x1b,%edx
  801eb5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801eb8:	83 e1 1f             	and    $0x1f,%ecx
  801ebb:	29 d1                	sub    %edx,%ecx
  801ebd:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801ec1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801ec5:	83 c0 01             	add    $0x1,%eax
  801ec8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801ecb:	83 c7 01             	add    $0x1,%edi
  801ece:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801ed1:	75 c8                	jne    801e9b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801ed3:	89 f8                	mov    %edi,%eax
  801ed5:	eb 05                	jmp    801edc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801edc:	83 c4 1c             	add    $0x1c,%esp
  801edf:	5b                   	pop    %ebx
  801ee0:	5e                   	pop    %esi
  801ee1:	5f                   	pop    %edi
  801ee2:	5d                   	pop    %ebp
  801ee3:	c3                   	ret    

00801ee4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ee4:	55                   	push   %ebp
  801ee5:	89 e5                	mov    %esp,%ebp
  801ee7:	57                   	push   %edi
  801ee8:	56                   	push   %esi
  801ee9:	53                   	push   %ebx
  801eea:	83 ec 1c             	sub    $0x1c,%esp
  801eed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ef0:	89 3c 24             	mov    %edi,(%esp)
  801ef3:	e8 08 f1 ff ff       	call   801000 <fd2data>
  801ef8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801efa:	be 00 00 00 00       	mov    $0x0,%esi
  801eff:	eb 3d                	jmp    801f3e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f01:	85 f6                	test   %esi,%esi
  801f03:	74 04                	je     801f09 <devpipe_read+0x25>
				return i;
  801f05:	89 f0                	mov    %esi,%eax
  801f07:	eb 43                	jmp    801f4c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801f09:	89 da                	mov    %ebx,%edx
  801f0b:	89 f8                	mov    %edi,%eax
  801f0d:	e8 f1 fe ff ff       	call   801e03 <_pipeisclosed>
  801f12:	85 c0                	test   %eax,%eax
  801f14:	75 31                	jne    801f47 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f16:	e8 89 ed ff ff       	call   800ca4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f1b:	8b 03                	mov    (%ebx),%eax
  801f1d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f20:	74 df                	je     801f01 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f22:	99                   	cltd   
  801f23:	c1 ea 1b             	shr    $0x1b,%edx
  801f26:	01 d0                	add    %edx,%eax
  801f28:	83 e0 1f             	and    $0x1f,%eax
  801f2b:	29 d0                	sub    %edx,%eax
  801f2d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f35:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f38:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f3b:	83 c6 01             	add    $0x1,%esi
  801f3e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f41:	75 d8                	jne    801f1b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f43:	89 f0                	mov    %esi,%eax
  801f45:	eb 05                	jmp    801f4c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f47:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    

00801f54 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f54:	55                   	push   %ebp
  801f55:	89 e5                	mov    %esp,%ebp
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5f:	89 04 24             	mov    %eax,(%esp)
  801f62:	e8 b0 f0 ff ff       	call   801017 <fd_alloc>
  801f67:	89 c2                	mov    %eax,%edx
  801f69:	85 d2                	test   %edx,%edx
  801f6b:	0f 88 4d 01 00 00    	js     8020be <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f71:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f78:	00 
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f87:	e8 37 ed ff ff       	call   800cc3 <sys_page_alloc>
  801f8c:	89 c2                	mov    %eax,%edx
  801f8e:	85 d2                	test   %edx,%edx
  801f90:	0f 88 28 01 00 00    	js     8020be <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f96:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f99:	89 04 24             	mov    %eax,(%esp)
  801f9c:	e8 76 f0 ff ff       	call   801017 <fd_alloc>
  801fa1:	89 c3                	mov    %eax,%ebx
  801fa3:	85 c0                	test   %eax,%eax
  801fa5:	0f 88 fe 00 00 00    	js     8020a9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fab:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb2:	00 
  801fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc1:	e8 fd ec ff ff       	call   800cc3 <sys_page_alloc>
  801fc6:	89 c3                	mov    %eax,%ebx
  801fc8:	85 c0                	test   %eax,%eax
  801fca:	0f 88 d9 00 00 00    	js     8020a9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd3:	89 04 24             	mov    %eax,(%esp)
  801fd6:	e8 25 f0 ff ff       	call   801000 <fd2data>
  801fdb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fdd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fe4:	00 
  801fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff0:	e8 ce ec ff ff       	call   800cc3 <sys_page_alloc>
  801ff5:	89 c3                	mov    %eax,%ebx
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	0f 88 97 00 00 00    	js     802096 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	89 04 24             	mov    %eax,(%esp)
  802005:	e8 f6 ef ff ff       	call   801000 <fd2data>
  80200a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802011:	00 
  802012:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802016:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80201d:	00 
  80201e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802029:	e8 e9 ec ff ff       	call   800d17 <sys_page_map>
  80202e:	89 c3                	mov    %eax,%ebx
  802030:	85 c0                	test   %eax,%eax
  802032:	78 52                	js     802086 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802034:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80203f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802042:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802049:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80204f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802052:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802054:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802057:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 87 ef ff ff       	call   800ff0 <fd2num>
  802069:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80206c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80206e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802071:	89 04 24             	mov    %eax,(%esp)
  802074:	e8 77 ef ff ff       	call   800ff0 <fd2num>
  802079:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80207c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80207f:	b8 00 00 00 00       	mov    $0x0,%eax
  802084:	eb 38                	jmp    8020be <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802086:	89 74 24 04          	mov    %esi,0x4(%esp)
  80208a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802091:	e8 d4 ec ff ff       	call   800d6a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a4:	e8 c1 ec ff ff       	call   800d6a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b7:	e8 ae ec ff ff       	call   800d6a <sys_page_unmap>
  8020bc:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8020be:	83 c4 30             	add    $0x30,%esp
  8020c1:	5b                   	pop    %ebx
  8020c2:	5e                   	pop    %esi
  8020c3:	5d                   	pop    %ebp
  8020c4:	c3                   	ret    

008020c5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 89 ef ff ff       	call   801066 <fd_lookup>
  8020dd:	89 c2                	mov    %eax,%edx
  8020df:	85 d2                	test   %edx,%edx
  8020e1:	78 15                	js     8020f8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e6:	89 04 24             	mov    %eax,(%esp)
  8020e9:	e8 12 ef ff ff       	call   801000 <fd2data>
	return _pipeisclosed(fd, p);
  8020ee:	89 c2                	mov    %eax,%edx
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	e8 0b fd ff ff       	call   801e03 <_pipeisclosed>
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    
  8020fa:	66 90                	xchg   %ax,%ax
  8020fc:	66 90                	xchg   %ax,%ax
  8020fe:	66 90                	xchg   %ax,%ax

00802100 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802103:	b8 00 00 00 00       	mov    $0x0,%eax
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    

0080210a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802110:	c7 44 24 04 4b 2b 80 	movl   $0x802b4b,0x4(%esp)
  802117:	00 
  802118:	8b 45 0c             	mov    0xc(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 84 e7 ff ff       	call   8008a7 <strcpy>
	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	57                   	push   %edi
  80212e:	56                   	push   %esi
  80212f:	53                   	push   %ebx
  802130:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802136:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80213b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802141:	eb 31                	jmp    802174 <devcons_write+0x4a>
		m = n - tot;
  802143:	8b 75 10             	mov    0x10(%ebp),%esi
  802146:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802148:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80214b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802150:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802153:	89 74 24 08          	mov    %esi,0x8(%esp)
  802157:	03 45 0c             	add    0xc(%ebp),%eax
  80215a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215e:	89 3c 24             	mov    %edi,(%esp)
  802161:	e8 de e8 ff ff       	call   800a44 <memmove>
		sys_cputs(buf, m);
  802166:	89 74 24 04          	mov    %esi,0x4(%esp)
  80216a:	89 3c 24             	mov    %edi,(%esp)
  80216d:	e8 84 ea ff ff       	call   800bf6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802172:	01 f3                	add    %esi,%ebx
  802174:	89 d8                	mov    %ebx,%eax
  802176:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802179:	72 c8                	jb     802143 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80217b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5f                   	pop    %edi
  802184:	5d                   	pop    %ebp
  802185:	c3                   	ret    

00802186 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80218c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802191:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802195:	75 07                	jne    80219e <devcons_read+0x18>
  802197:	eb 2a                	jmp    8021c3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802199:	e8 06 eb ff ff       	call   800ca4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	e8 6f ea ff ff       	call   800c14 <sys_cgetc>
  8021a5:	85 c0                	test   %eax,%eax
  8021a7:	74 f0                	je     802199 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8021a9:	85 c0                	test   %eax,%eax
  8021ab:	78 16                	js     8021c3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021ad:	83 f8 04             	cmp    $0x4,%eax
  8021b0:	74 0c                	je     8021be <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8021b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b5:	88 02                	mov    %al,(%edx)
	return 1;
  8021b7:	b8 01 00 00 00       	mov    $0x1,%eax
  8021bc:	eb 05                	jmp    8021c3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8021be:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8021c3:	c9                   	leave  
  8021c4:	c3                   	ret    

008021c5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021c5:	55                   	push   %ebp
  8021c6:	89 e5                	mov    %esp,%ebp
  8021c8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021d8:	00 
  8021d9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021dc:	89 04 24             	mov    %eax,(%esp)
  8021df:	e8 12 ea ff ff       	call   800bf6 <sys_cputs>
}
  8021e4:	c9                   	leave  
  8021e5:	c3                   	ret    

008021e6 <getchar>:

int
getchar(void)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021f3:	00 
  8021f4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802202:	e8 f3 f0 ff ff       	call   8012fa <read>
	if (r < 0)
  802207:	85 c0                	test   %eax,%eax
  802209:	78 0f                	js     80221a <getchar+0x34>
		return r;
	if (r < 1)
  80220b:	85 c0                	test   %eax,%eax
  80220d:	7e 06                	jle    802215 <getchar+0x2f>
		return -E_EOF;
	return c;
  80220f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802213:	eb 05                	jmp    80221a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802215:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80221a:	c9                   	leave  
  80221b:	c3                   	ret    

0080221c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80221c:	55                   	push   %ebp
  80221d:	89 e5                	mov    %esp,%ebp
  80221f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802222:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802225:	89 44 24 04          	mov    %eax,0x4(%esp)
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	89 04 24             	mov    %eax,(%esp)
  80222f:	e8 32 ee ff ff       	call   801066 <fd_lookup>
  802234:	85 c0                	test   %eax,%eax
  802236:	78 11                	js     802249 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802241:	39 10                	cmp    %edx,(%eax)
  802243:	0f 94 c0             	sete   %al
  802246:	0f b6 c0             	movzbl %al,%eax
}
  802249:	c9                   	leave  
  80224a:	c3                   	ret    

0080224b <opencons>:

int
opencons(void)
{
  80224b:	55                   	push   %ebp
  80224c:	89 e5                	mov    %esp,%ebp
  80224e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802251:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802254:	89 04 24             	mov    %eax,(%esp)
  802257:	e8 bb ed ff ff       	call   801017 <fd_alloc>
		return r;
  80225c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 40                	js     8022a2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802262:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802269:	00 
  80226a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802278:	e8 46 ea ff ff       	call   800cc3 <sys_page_alloc>
		return r;
  80227d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80227f:	85 c0                	test   %eax,%eax
  802281:	78 1f                	js     8022a2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802283:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802289:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802291:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802298:	89 04 24             	mov    %eax,(%esp)
  80229b:	e8 50 ed ff ff       	call   800ff0 <fd2num>
  8022a0:	89 c2                	mov    %eax,%edx
}
  8022a2:	89 d0                	mov    %edx,%eax
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	56                   	push   %esi
  8022aa:	53                   	push   %ebx
  8022ab:	83 ec 10             	sub    $0x10,%esp
  8022ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8022b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8022b7:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8022b9:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8022be:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 10 ec ff ff       	call   800ed9 <sys_ipc_recv>
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	75 1e                	jne    8022eb <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8022cd:	85 db                	test   %ebx,%ebx
  8022cf:	74 0a                	je     8022db <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8022d1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d6:	8b 40 74             	mov    0x74(%eax),%eax
  8022d9:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8022db:	85 f6                	test   %esi,%esi
  8022dd:	74 22                	je     802301 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8022df:	a1 08 40 80 00       	mov    0x804008,%eax
  8022e4:	8b 40 78             	mov    0x78(%eax),%eax
  8022e7:	89 06                	mov    %eax,(%esi)
  8022e9:	eb 16                	jmp    802301 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8022eb:	85 f6                	test   %esi,%esi
  8022ed:	74 06                	je     8022f5 <ipc_recv+0x4f>
				*perm_store = 0;
  8022ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8022f5:	85 db                	test   %ebx,%ebx
  8022f7:	74 10                	je     802309 <ipc_recv+0x63>
				*from_env_store=0;
  8022f9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ff:	eb 08                	jmp    802309 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802301:	a1 08 40 80 00       	mov    0x804008,%eax
  802306:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  802309:	83 c4 10             	add    $0x10,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    

00802310 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	57                   	push   %edi
  802314:	56                   	push   %esi
  802315:	53                   	push   %ebx
  802316:	83 ec 1c             	sub    $0x1c,%esp
  802319:	8b 75 0c             	mov    0xc(%ebp),%esi
  80231c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80231f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802322:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  802324:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802329:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80232c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802330:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802334:	89 74 24 04          	mov    %esi,0x4(%esp)
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 73 eb ff ff       	call   800eb6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802343:	eb 1c                	jmp    802361 <ipc_send+0x51>
	{
		sys_yield();
  802345:	e8 5a e9 ff ff       	call   800ca4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80234a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80234e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802352:	89 74 24 04          	mov    %esi,0x4(%esp)
  802356:	8b 45 08             	mov    0x8(%ebp),%eax
  802359:	89 04 24             	mov    %eax,(%esp)
  80235c:	e8 55 eb ff ff       	call   800eb6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802361:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802364:	74 df                	je     802345 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  802366:	83 c4 1c             	add    $0x1c,%esp
  802369:	5b                   	pop    %ebx
  80236a:	5e                   	pop    %esi
  80236b:	5f                   	pop    %edi
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    

0080236e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80236e:	55                   	push   %ebp
  80236f:	89 e5                	mov    %esp,%ebp
  802371:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802374:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802379:	6b d0 7c             	imul   $0x7c,%eax,%edx
  80237c:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802382:	8b 52 50             	mov    0x50(%edx),%edx
  802385:	39 ca                	cmp    %ecx,%edx
  802387:	75 0d                	jne    802396 <ipc_find_env+0x28>
			return envs[i].env_id;
  802389:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80238c:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802391:	8b 40 40             	mov    0x40(%eax),%eax
  802394:	eb 0e                	jmp    8023a4 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  802396:	83 c0 01             	add    $0x1,%eax
  802399:	3d 00 04 00 00       	cmp    $0x400,%eax
  80239e:	75 d9                	jne    802379 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023a0:	66 b8 00 00          	mov    $0x0,%ax
}
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    

008023a6 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023ac:	89 d0                	mov    %edx,%eax
  8023ae:	c1 e8 16             	shr    $0x16,%eax
  8023b1:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023b8:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023bd:	f6 c1 01             	test   $0x1,%cl
  8023c0:	74 1d                	je     8023df <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023c2:	c1 ea 0c             	shr    $0xc,%edx
  8023c5:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023cc:	f6 c2 01             	test   $0x1,%dl
  8023cf:	74 0e                	je     8023df <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023d1:	c1 ea 0c             	shr    $0xc,%edx
  8023d4:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023db:	ef 
  8023dc:	0f b7 c0             	movzwl %ax,%eax
}
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	66 90                	xchg   %ax,%ax
  8023e3:	66 90                	xchg   %ax,%ax
  8023e5:	66 90                	xchg   %ax,%ax
  8023e7:	66 90                	xchg   %ax,%ax
  8023e9:	66 90                	xchg   %ax,%ax
  8023eb:	66 90                	xchg   %ax,%ax
  8023ed:	66 90                	xchg   %ax,%ax
  8023ef:	90                   	nop

008023f0 <__udivdi3>:
  8023f0:	55                   	push   %ebp
  8023f1:	57                   	push   %edi
  8023f2:	56                   	push   %esi
  8023f3:	83 ec 0c             	sub    $0xc,%esp
  8023f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8023fa:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8023fe:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802402:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802406:	85 c0                	test   %eax,%eax
  802408:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80240c:	89 ea                	mov    %ebp,%edx
  80240e:	89 0c 24             	mov    %ecx,(%esp)
  802411:	75 2d                	jne    802440 <__udivdi3+0x50>
  802413:	39 e9                	cmp    %ebp,%ecx
  802415:	77 61                	ja     802478 <__udivdi3+0x88>
  802417:	85 c9                	test   %ecx,%ecx
  802419:	89 ce                	mov    %ecx,%esi
  80241b:	75 0b                	jne    802428 <__udivdi3+0x38>
  80241d:	b8 01 00 00 00       	mov    $0x1,%eax
  802422:	31 d2                	xor    %edx,%edx
  802424:	f7 f1                	div    %ecx
  802426:	89 c6                	mov    %eax,%esi
  802428:	31 d2                	xor    %edx,%edx
  80242a:	89 e8                	mov    %ebp,%eax
  80242c:	f7 f6                	div    %esi
  80242e:	89 c5                	mov    %eax,%ebp
  802430:	89 f8                	mov    %edi,%eax
  802432:	f7 f6                	div    %esi
  802434:	89 ea                	mov    %ebp,%edx
  802436:	83 c4 0c             	add    $0xc,%esp
  802439:	5e                   	pop    %esi
  80243a:	5f                   	pop    %edi
  80243b:	5d                   	pop    %ebp
  80243c:	c3                   	ret    
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	39 e8                	cmp    %ebp,%eax
  802442:	77 24                	ja     802468 <__udivdi3+0x78>
  802444:	0f bd e8             	bsr    %eax,%ebp
  802447:	83 f5 1f             	xor    $0x1f,%ebp
  80244a:	75 3c                	jne    802488 <__udivdi3+0x98>
  80244c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802450:	39 34 24             	cmp    %esi,(%esp)
  802453:	0f 86 9f 00 00 00    	jbe    8024f8 <__udivdi3+0x108>
  802459:	39 d0                	cmp    %edx,%eax
  80245b:	0f 82 97 00 00 00    	jb     8024f8 <__udivdi3+0x108>
  802461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802468:	31 d2                	xor    %edx,%edx
  80246a:	31 c0                	xor    %eax,%eax
  80246c:	83 c4 0c             	add    $0xc,%esp
  80246f:	5e                   	pop    %esi
  802470:	5f                   	pop    %edi
  802471:	5d                   	pop    %ebp
  802472:	c3                   	ret    
  802473:	90                   	nop
  802474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 f8                	mov    %edi,%eax
  80247a:	f7 f1                	div    %ecx
  80247c:	31 d2                	xor    %edx,%edx
  80247e:	83 c4 0c             	add    $0xc,%esp
  802481:	5e                   	pop    %esi
  802482:	5f                   	pop    %edi
  802483:	5d                   	pop    %ebp
  802484:	c3                   	ret    
  802485:	8d 76 00             	lea    0x0(%esi),%esi
  802488:	89 e9                	mov    %ebp,%ecx
  80248a:	8b 3c 24             	mov    (%esp),%edi
  80248d:	d3 e0                	shl    %cl,%eax
  80248f:	89 c6                	mov    %eax,%esi
  802491:	b8 20 00 00 00       	mov    $0x20,%eax
  802496:	29 e8                	sub    %ebp,%eax
  802498:	89 c1                	mov    %eax,%ecx
  80249a:	d3 ef                	shr    %cl,%edi
  80249c:	89 e9                	mov    %ebp,%ecx
  80249e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024a2:	8b 3c 24             	mov    (%esp),%edi
  8024a5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024a9:	89 d6                	mov    %edx,%esi
  8024ab:	d3 e7                	shl    %cl,%edi
  8024ad:	89 c1                	mov    %eax,%ecx
  8024af:	89 3c 24             	mov    %edi,(%esp)
  8024b2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024b6:	d3 ee                	shr    %cl,%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	d3 e2                	shl    %cl,%edx
  8024bc:	89 c1                	mov    %eax,%ecx
  8024be:	d3 ef                	shr    %cl,%edi
  8024c0:	09 d7                	or     %edx,%edi
  8024c2:	89 f2                	mov    %esi,%edx
  8024c4:	89 f8                	mov    %edi,%eax
  8024c6:	f7 74 24 08          	divl   0x8(%esp)
  8024ca:	89 d6                	mov    %edx,%esi
  8024cc:	89 c7                	mov    %eax,%edi
  8024ce:	f7 24 24             	mull   (%esp)
  8024d1:	39 d6                	cmp    %edx,%esi
  8024d3:	89 14 24             	mov    %edx,(%esp)
  8024d6:	72 30                	jb     802508 <__udivdi3+0x118>
  8024d8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024dc:	89 e9                	mov    %ebp,%ecx
  8024de:	d3 e2                	shl    %cl,%edx
  8024e0:	39 c2                	cmp    %eax,%edx
  8024e2:	73 05                	jae    8024e9 <__udivdi3+0xf9>
  8024e4:	3b 34 24             	cmp    (%esp),%esi
  8024e7:	74 1f                	je     802508 <__udivdi3+0x118>
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	31 d2                	xor    %edx,%edx
  8024ed:	e9 7a ff ff ff       	jmp    80246c <__udivdi3+0x7c>
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	31 d2                	xor    %edx,%edx
  8024fa:	b8 01 00 00 00       	mov    $0x1,%eax
  8024ff:	e9 68 ff ff ff       	jmp    80246c <__udivdi3+0x7c>
  802504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802508:	8d 47 ff             	lea    -0x1(%edi),%eax
  80250b:	31 d2                	xor    %edx,%edx
  80250d:	83 c4 0c             	add    $0xc,%esp
  802510:	5e                   	pop    %esi
  802511:	5f                   	pop    %edi
  802512:	5d                   	pop    %ebp
  802513:	c3                   	ret    
  802514:	66 90                	xchg   %ax,%ax
  802516:	66 90                	xchg   %ax,%ax
  802518:	66 90                	xchg   %ax,%ax
  80251a:	66 90                	xchg   %ax,%ax
  80251c:	66 90                	xchg   %ax,%ax
  80251e:	66 90                	xchg   %ax,%ax

00802520 <__umoddi3>:
  802520:	55                   	push   %ebp
  802521:	57                   	push   %edi
  802522:	56                   	push   %esi
  802523:	83 ec 14             	sub    $0x14,%esp
  802526:	8b 44 24 28          	mov    0x28(%esp),%eax
  80252a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80252e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802532:	89 c7                	mov    %eax,%edi
  802534:	89 44 24 04          	mov    %eax,0x4(%esp)
  802538:	8b 44 24 30          	mov    0x30(%esp),%eax
  80253c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802540:	89 34 24             	mov    %esi,(%esp)
  802543:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802547:	85 c0                	test   %eax,%eax
  802549:	89 c2                	mov    %eax,%edx
  80254b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80254f:	75 17                	jne    802568 <__umoddi3+0x48>
  802551:	39 fe                	cmp    %edi,%esi
  802553:	76 4b                	jbe    8025a0 <__umoddi3+0x80>
  802555:	89 c8                	mov    %ecx,%eax
  802557:	89 fa                	mov    %edi,%edx
  802559:	f7 f6                	div    %esi
  80255b:	89 d0                	mov    %edx,%eax
  80255d:	31 d2                	xor    %edx,%edx
  80255f:	83 c4 14             	add    $0x14,%esp
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	66 90                	xchg   %ax,%ax
  802568:	39 f8                	cmp    %edi,%eax
  80256a:	77 54                	ja     8025c0 <__umoddi3+0xa0>
  80256c:	0f bd e8             	bsr    %eax,%ebp
  80256f:	83 f5 1f             	xor    $0x1f,%ebp
  802572:	75 5c                	jne    8025d0 <__umoddi3+0xb0>
  802574:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802578:	39 3c 24             	cmp    %edi,(%esp)
  80257b:	0f 87 e7 00 00 00    	ja     802668 <__umoddi3+0x148>
  802581:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802585:	29 f1                	sub    %esi,%ecx
  802587:	19 c7                	sbb    %eax,%edi
  802589:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80258d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802591:	8b 44 24 08          	mov    0x8(%esp),%eax
  802595:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802599:	83 c4 14             	add    $0x14,%esp
  80259c:	5e                   	pop    %esi
  80259d:	5f                   	pop    %edi
  80259e:	5d                   	pop    %ebp
  80259f:	c3                   	ret    
  8025a0:	85 f6                	test   %esi,%esi
  8025a2:	89 f5                	mov    %esi,%ebp
  8025a4:	75 0b                	jne    8025b1 <__umoddi3+0x91>
  8025a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ab:	31 d2                	xor    %edx,%edx
  8025ad:	f7 f6                	div    %esi
  8025af:	89 c5                	mov    %eax,%ebp
  8025b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025b5:	31 d2                	xor    %edx,%edx
  8025b7:	f7 f5                	div    %ebp
  8025b9:	89 c8                	mov    %ecx,%eax
  8025bb:	f7 f5                	div    %ebp
  8025bd:	eb 9c                	jmp    80255b <__umoddi3+0x3b>
  8025bf:	90                   	nop
  8025c0:	89 c8                	mov    %ecx,%eax
  8025c2:	89 fa                	mov    %edi,%edx
  8025c4:	83 c4 14             	add    $0x14,%esp
  8025c7:	5e                   	pop    %esi
  8025c8:	5f                   	pop    %edi
  8025c9:	5d                   	pop    %ebp
  8025ca:	c3                   	ret    
  8025cb:	90                   	nop
  8025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025d0:	8b 04 24             	mov    (%esp),%eax
  8025d3:	be 20 00 00 00       	mov    $0x20,%esi
  8025d8:	89 e9                	mov    %ebp,%ecx
  8025da:	29 ee                	sub    %ebp,%esi
  8025dc:	d3 e2                	shl    %cl,%edx
  8025de:	89 f1                	mov    %esi,%ecx
  8025e0:	d3 e8                	shr    %cl,%eax
  8025e2:	89 e9                	mov    %ebp,%ecx
  8025e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e8:	8b 04 24             	mov    (%esp),%eax
  8025eb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025ef:	89 fa                	mov    %edi,%edx
  8025f1:	d3 e0                	shl    %cl,%eax
  8025f3:	89 f1                	mov    %esi,%ecx
  8025f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025f9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8025fd:	d3 ea                	shr    %cl,%edx
  8025ff:	89 e9                	mov    %ebp,%ecx
  802601:	d3 e7                	shl    %cl,%edi
  802603:	89 f1                	mov    %esi,%ecx
  802605:	d3 e8                	shr    %cl,%eax
  802607:	89 e9                	mov    %ebp,%ecx
  802609:	09 f8                	or     %edi,%eax
  80260b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80260f:	f7 74 24 04          	divl   0x4(%esp)
  802613:	d3 e7                	shl    %cl,%edi
  802615:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802619:	89 d7                	mov    %edx,%edi
  80261b:	f7 64 24 08          	mull   0x8(%esp)
  80261f:	39 d7                	cmp    %edx,%edi
  802621:	89 c1                	mov    %eax,%ecx
  802623:	89 14 24             	mov    %edx,(%esp)
  802626:	72 2c                	jb     802654 <__umoddi3+0x134>
  802628:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80262c:	72 22                	jb     802650 <__umoddi3+0x130>
  80262e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802632:	29 c8                	sub    %ecx,%eax
  802634:	19 d7                	sbb    %edx,%edi
  802636:	89 e9                	mov    %ebp,%ecx
  802638:	89 fa                	mov    %edi,%edx
  80263a:	d3 e8                	shr    %cl,%eax
  80263c:	89 f1                	mov    %esi,%ecx
  80263e:	d3 e2                	shl    %cl,%edx
  802640:	89 e9                	mov    %ebp,%ecx
  802642:	d3 ef                	shr    %cl,%edi
  802644:	09 d0                	or     %edx,%eax
  802646:	89 fa                	mov    %edi,%edx
  802648:	83 c4 14             	add    $0x14,%esp
  80264b:	5e                   	pop    %esi
  80264c:	5f                   	pop    %edi
  80264d:	5d                   	pop    %ebp
  80264e:	c3                   	ret    
  80264f:	90                   	nop
  802650:	39 d7                	cmp    %edx,%edi
  802652:	75 da                	jne    80262e <__umoddi3+0x10e>
  802654:	8b 14 24             	mov    (%esp),%edx
  802657:	89 c1                	mov    %eax,%ecx
  802659:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80265d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802661:	eb cb                	jmp    80262e <__umoddi3+0x10e>
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80266c:	0f 82 0f ff ff ff    	jb     802581 <__umoddi3+0x61>
  802672:	e9 1a ff ff ff       	jmp    802591 <__umoddi3+0x71>
