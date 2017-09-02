
obj/user/stresssched.debug:     file format elf32-i386


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
  80002c:	e8 e0 00 00 00       	call   800111 <libmain>
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

volatile int counter;

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();
  800048:	e8 28 0c 00 00       	call   800c75 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi

	// Fork several environments
	for (i = 0; i < 20; i++)
  80004f:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (fork() == 0)
  800054:	e8 8d 10 00 00       	call   8010e6 <fork>
  800059:	85 c0                	test   %eax,%eax
  80005b:	74 0a                	je     800067 <umain+0x27>
	int i, j;
	int seen;
	envid_t parent = sys_getenvid();

	// Fork several environments
	for (i = 0; i < 20; i++)
  80005d:	83 c3 01             	add    $0x1,%ebx
  800060:	83 fb 14             	cmp    $0x14,%ebx
  800063:	75 ef                	jne    800054 <umain+0x14>
  800065:	eb 16                	jmp    80007d <umain+0x3d>
		if (fork() == 0)
			break;
	if (i == 20) {
  800067:	83 fb 14             	cmp    $0x14,%ebx
  80006a:	74 11                	je     80007d <umain+0x3d>
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  80006c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800072:	6b d6 7c             	imul   $0x7c,%esi,%edx
  800075:	81 c2 04 00 c0 ee    	add    $0xeec00004,%edx
  80007b:	eb 0c                	jmp    800089 <umain+0x49>
	// Fork several environments
	for (i = 0; i < 20; i++)
		if (fork() == 0)
			break;
	if (i == 20) {
		sys_yield();
  80007d:	e8 12 0c 00 00       	call   800c94 <sys_yield>
		return;
  800082:	e9 83 00 00 00       	jmp    80010a <umain+0xca>
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");
  800087:	f3 90                	pause  
		sys_yield();
		return;
	}

	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
  800089:	8b 42 50             	mov    0x50(%edx),%eax
  80008c:	85 c0                	test   %eax,%eax
  80008e:	66 90                	xchg   %ax,%ax
  800090:	75 f5                	jne    800087 <umain+0x47>
  800092:	bb 0a 00 00 00       	mov    $0xa,%ebx
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
  800097:	e8 f8 0b 00 00       	call   800c94 <sys_yield>
  80009c:	b8 10 27 00 00       	mov    $0x2710,%eax
		for (j = 0; j < 10000; j++)
			counter++;
  8000a1:	8b 15 08 50 80 00    	mov    0x805008,%edx
  8000a7:	83 c2 01             	add    $0x1,%edx
  8000aa:	89 15 08 50 80 00    	mov    %edx,0x805008
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
		sys_yield();
		for (j = 0; j < 10000; j++)
  8000b0:	83 e8 01             	sub    $0x1,%eax
  8000b3:	75 ec                	jne    8000a1 <umain+0x61>
	// Wait for the parent to finish forking
	while (envs[ENVX(parent)].env_status != ENV_FREE)
		asm volatile("pause");

	// Check that one environment doesn't run on two CPUs at once
	for (i = 0; i < 10; i++) {
  8000b5:	83 eb 01             	sub    $0x1,%ebx
  8000b8:	75 dd                	jne    800097 <umain+0x57>
		sys_yield();
		for (j = 0; j < 10000; j++)
			counter++;
	}

	if (counter != 10*10000)
  8000ba:	a1 08 50 80 00       	mov    0x805008,%eax
  8000bf:	3d a0 86 01 00       	cmp    $0x186a0,%eax
  8000c4:	74 25                	je     8000eb <umain+0xab>
		panic("ran on two CPUs at once (counter is %d)", counter);
  8000c6:	a1 08 50 80 00       	mov    0x805008,%eax
  8000cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000cf:	c7 44 24 08 60 2a 80 	movl   $0x802a60,0x8(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8000de:	00 
  8000df:	c7 04 24 88 2a 80 00 	movl   $0x802a88,(%esp)
  8000e6:	e8 91 00 00 00       	call   80017c <_panic>

	// Check that we see environments running on different CPUs
	cprintf("[%08x] stresssched on CPU %d\n", thisenv->env_id, thisenv->env_cpunum);
  8000eb:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8000f0:	8b 50 5c             	mov    0x5c(%eax),%edx
  8000f3:	8b 40 48             	mov    0x48(%eax),%eax
  8000f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000fe:	c7 04 24 9b 2a 80 00 	movl   $0x802a9b,(%esp)
  800105:	e8 6b 01 00 00       	call   800275 <cprintf>

}
  80010a:	83 c4 10             	add    $0x10,%esp
  80010d:	5b                   	pop    %ebx
  80010e:	5e                   	pop    %esi
  80010f:	5d                   	pop    %ebp
  800110:	c3                   	ret    

00800111 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800111:	55                   	push   %ebp
  800112:	89 e5                	mov    %esp,%ebp
  800114:	56                   	push   %esi
  800115:	53                   	push   %ebx
  800116:	83 ec 10             	sub    $0x10,%esp
  800119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80011c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  80011f:	c7 05 0c 50 80 00 00 	movl   $0x0,0x80500c
  800126:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800129:	e8 47 0b 00 00       	call   800c75 <sys_getenvid>
  80012e:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  800133:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800136:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80013b:	a3 0c 50 80 00       	mov    %eax,0x80500c


	// save the name of the program so that panic() can use it
	if (argc > 0)
  800140:	85 db                	test   %ebx,%ebx
  800142:	7e 07                	jle    80014b <libmain+0x3a>
		binaryname = argv[0];
  800144:	8b 06                	mov    (%esi),%eax
  800146:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  80014b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80014f:	89 1c 24             	mov    %ebx,(%esp)
  800152:	e8 e9 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800157:	e8 07 00 00 00       	call   800163 <exit>
}
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	5b                   	pop    %ebx
  800160:	5e                   	pop    %esi
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    

00800163 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800163:	55                   	push   %ebp
  800164:	89 e5                	mov    %esp,%ebp
  800166:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800169:	e8 ac 13 00 00       	call   80151a <close_all>
	sys_env_destroy(0);
  80016e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800175:	e8 a9 0a 00 00       	call   800c23 <sys_env_destroy>
}
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    

0080017c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80017c:	55                   	push   %ebp
  80017d:	89 e5                	mov    %esp,%ebp
  80017f:	56                   	push   %esi
  800180:	53                   	push   %ebx
  800181:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  800184:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  800187:	8b 35 00 40 80 00    	mov    0x804000,%esi
  80018d:	e8 e3 0a 00 00       	call   800c75 <sys_getenvid>
  800192:	8b 55 0c             	mov    0xc(%ebp),%edx
  800195:	89 54 24 10          	mov    %edx,0x10(%esp)
  800199:	8b 55 08             	mov    0x8(%ebp),%edx
  80019c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8001a0:	89 74 24 08          	mov    %esi,0x8(%esp)
  8001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a8:	c7 04 24 c4 2a 80 00 	movl   $0x802ac4,(%esp)
  8001af:	e8 c1 00 00 00       	call   800275 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8001b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8001bb:	89 04 24             	mov    %eax,(%esp)
  8001be:	e8 51 00 00 00       	call   800214 <vcprintf>
	cprintf("\n");
  8001c3:	c7 04 24 b7 2a 80 00 	movl   $0x802ab7,(%esp)
  8001ca:	e8 a6 00 00 00       	call   800275 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001cf:	cc                   	int3   
  8001d0:	eb fd                	jmp    8001cf <_panic+0x53>

008001d2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 14             	sub    $0x14,%esp
  8001d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001dc:	8b 13                	mov    (%ebx),%edx
  8001de:	8d 42 01             	lea    0x1(%edx),%eax
  8001e1:	89 03                	mov    %eax,(%ebx)
  8001e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001e6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001ea:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001ef:	75 19                	jne    80020a <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001f1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8001f8:	00 
  8001f9:	8d 43 08             	lea    0x8(%ebx),%eax
  8001fc:	89 04 24             	mov    %eax,(%esp)
  8001ff:	e8 e2 09 00 00       	call   800be6 <sys_cputs>
		b->idx = 0;
  800204:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80020a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80020e:	83 c4 14             	add    $0x14,%esp
  800211:	5b                   	pop    %ebx
  800212:	5d                   	pop    %ebp
  800213:	c3                   	ret    

00800214 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80021d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800224:	00 00 00 
	b.cnt = 0;
  800227:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	c7 04 24 d2 01 80 00 	movl   $0x8001d2,(%esp)
  800250:	e8 a9 01 00 00       	call   8003fe <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800255:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800265:	89 04 24             	mov    %eax,(%esp)
  800268:	e8 79 09 00 00       	call   800be6 <sys_cputs>

	return b.cnt;
}
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80027b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80027e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	e8 87 ff ff ff       	call   800214 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    
  80028f:	90                   	nop

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 3c             	sub    $0x3c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d7                	mov    %edx,%edi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a7:	89 c3                	mov    %eax,%ebx
  8002a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8002ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8002af:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002ba:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8002bd:	39 d9                	cmp    %ebx,%ecx
  8002bf:	72 05                	jb     8002c6 <printnum+0x36>
  8002c1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8002c4:	77 69                	ja     80032f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8002c9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8002cd:	83 ee 01             	sub    $0x1,%esi
  8002d0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8002dc:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8002e0:	89 c3                	mov    %eax,%ebx
  8002e2:	89 d6                	mov    %edx,%esi
  8002e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8002ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  8002ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 cc 24 00 00       	call   8027d0 <__udivdi3>
  800304:	89 d9                	mov    %ebx,%ecx
  800306:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80030e:	89 04 24             	mov    %eax,(%esp)
  800311:	89 54 24 04          	mov    %edx,0x4(%esp)
  800315:	89 fa                	mov    %edi,%edx
  800317:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031a:	e8 71 ff ff ff       	call   800290 <printnum>
  80031f:	eb 1b                	jmp    80033c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800321:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800325:	8b 45 18             	mov    0x18(%ebp),%eax
  800328:	89 04 24             	mov    %eax,(%esp)
  80032b:	ff d3                	call   *%ebx
  80032d:	eb 03                	jmp    800332 <printnum+0xa2>
  80032f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800332:	83 ee 01             	sub    $0x1,%esi
  800335:	85 f6                	test   %esi,%esi
  800337:	7f e8                	jg     800321 <printnum+0x91>
  800339:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80033c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800340:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800344:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800347:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80034a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80034e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800352:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800355:	89 04 24             	mov    %eax,(%esp)
  800358:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80035b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035f:	e8 9c 25 00 00       	call   802900 <__umoddi3>
  800364:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800368:	0f be 80 e7 2a 80 00 	movsbl 0x802ae7(%eax),%eax
  80036f:	89 04 24             	mov    %eax,(%esp)
  800372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800375:	ff d0                	call   *%eax
}
  800377:	83 c4 3c             	add    $0x3c,%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    

0080037f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800382:	83 fa 01             	cmp    $0x1,%edx
  800385:	7e 0e                	jle    800395 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800387:	8b 10                	mov    (%eax),%edx
  800389:	8d 4a 08             	lea    0x8(%edx),%ecx
  80038c:	89 08                	mov    %ecx,(%eax)
  80038e:	8b 02                	mov    (%edx),%eax
  800390:	8b 52 04             	mov    0x4(%edx),%edx
  800393:	eb 22                	jmp    8003b7 <getuint+0x38>
	else if (lflag)
  800395:	85 d2                	test   %edx,%edx
  800397:	74 10                	je     8003a9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800399:	8b 10                	mov    (%eax),%edx
  80039b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80039e:	89 08                	mov    %ecx,(%eax)
  8003a0:	8b 02                	mov    (%edx),%eax
  8003a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8003a7:	eb 0e                	jmp    8003b7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a9:	8b 10                	mov    (%eax),%edx
  8003ab:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003ae:	89 08                	mov    %ecx,(%eax)
  8003b0:	8b 02                	mov    (%edx),%eax
  8003b2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003b7:	5d                   	pop    %ebp
  8003b8:	c3                   	ret    

008003b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003bf:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003c3:	8b 10                	mov    (%eax),%edx
  8003c5:	3b 50 04             	cmp    0x4(%eax),%edx
  8003c8:	73 0a                	jae    8003d4 <sprintputch+0x1b>
		*b->buf++ = ch;
  8003ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8003cd:	89 08                	mov    %ecx,(%eax)
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	88 02                	mov    %al,(%edx)
}
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
  8003d9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8003dc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	e8 02 00 00 00       	call   8003fe <vprintfmt>
	va_end(ap);
}
  8003fc:	c9                   	leave  
  8003fd:	c3                   	ret    

008003fe <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003fe:	55                   	push   %ebp
  8003ff:	89 e5                	mov    %esp,%ebp
  800401:	57                   	push   %edi
  800402:	56                   	push   %esi
  800403:	53                   	push   %ebx
  800404:	83 ec 3c             	sub    $0x3c,%esp
  800407:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80040a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80040d:	eb 14                	jmp    800423 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80040f:	85 c0                	test   %eax,%eax
  800411:	0f 84 b3 03 00 00    	je     8007ca <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800417:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80041b:	89 04 24             	mov    %eax,(%esp)
  80041e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800421:	89 f3                	mov    %esi,%ebx
  800423:	8d 73 01             	lea    0x1(%ebx),%esi
  800426:	0f b6 03             	movzbl (%ebx),%eax
  800429:	83 f8 25             	cmp    $0x25,%eax
  80042c:	75 e1                	jne    80040f <vprintfmt+0x11>
  80042e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800432:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800439:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800440:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800447:	ba 00 00 00 00       	mov    $0x0,%edx
  80044c:	eb 1d                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80044e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800450:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800454:	eb 15                	jmp    80046b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800458:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80045c:	eb 0d                	jmp    80046b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80045e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800461:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800464:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80046e:	0f b6 0e             	movzbl (%esi),%ecx
  800471:	0f b6 c1             	movzbl %cl,%eax
  800474:	83 e9 23             	sub    $0x23,%ecx
  800477:	80 f9 55             	cmp    $0x55,%cl
  80047a:	0f 87 2a 03 00 00    	ja     8007aa <vprintfmt+0x3ac>
  800480:	0f b6 c9             	movzbl %cl,%ecx
  800483:	ff 24 8d 20 2c 80 00 	jmp    *0x802c20(,%ecx,4)
  80048a:	89 de                	mov    %ebx,%esi
  80048c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800491:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800494:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800498:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80049b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80049e:	83 fb 09             	cmp    $0x9,%ebx
  8004a1:	77 36                	ja     8004d9 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004a3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ab:	8d 48 04             	lea    0x4(%eax),%ecx
  8004ae:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004b6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8004b8:	eb 22                	jmp    8004dc <vprintfmt+0xde>
  8004ba:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8004bd:	85 c9                	test   %ecx,%ecx
  8004bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8004c4:	0f 49 c1             	cmovns %ecx,%eax
  8004c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ca:	89 de                	mov    %ebx,%esi
  8004cc:	eb 9d                	jmp    80046b <vprintfmt+0x6d>
  8004ce:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  8004d0:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  8004d7:	eb 92                	jmp    80046b <vprintfmt+0x6d>
  8004d9:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  8004dc:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004e0:	79 89                	jns    80046b <vprintfmt+0x6d>
  8004e2:	e9 77 ff ff ff       	jmp    80045e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004e7:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ea:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  8004ec:	e9 7a ff ff ff       	jmp    80046b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004f4:	8d 50 04             	lea    0x4(%eax),%edx
  8004f7:	89 55 14             	mov    %edx,0x14(%ebp)
  8004fa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	89 04 24             	mov    %eax,(%esp)
  800503:	ff 55 08             	call   *0x8(%ebp)
			break;
  800506:	e9 18 ff ff ff       	jmp    800423 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80050b:	8b 45 14             	mov    0x14(%ebp),%eax
  80050e:	8d 50 04             	lea    0x4(%eax),%edx
  800511:	89 55 14             	mov    %edx,0x14(%ebp)
  800514:	8b 00                	mov    (%eax),%eax
  800516:	99                   	cltd   
  800517:	31 d0                	xor    %edx,%eax
  800519:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80051b:	83 f8 0f             	cmp    $0xf,%eax
  80051e:	7f 0b                	jg     80052b <vprintfmt+0x12d>
  800520:	8b 14 85 80 2d 80 00 	mov    0x802d80(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 ff 2a 80 	movl   $0x802aff,0x8(%esp)
  800536:	00 
  800537:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	89 04 24             	mov    %eax,(%esp)
  800541:	e8 90 fe ff ff       	call   8003d6 <printfmt>
  800546:	e9 d8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 45 30 80 	movl   $0x803045,0x8(%esp)
  800556:	00 
  800557:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80055b:	8b 45 08             	mov    0x8(%ebp),%eax
  80055e:	89 04 24             	mov    %eax,(%esp)
  800561:	e8 70 fe ff ff       	call   8003d6 <printfmt>
  800566:	e9 b8 fe ff ff       	jmp    800423 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80056b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80056e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800571:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800574:	8b 45 14             	mov    0x14(%ebp),%eax
  800577:	8d 50 04             	lea    0x4(%eax),%edx
  80057a:	89 55 14             	mov    %edx,0x14(%ebp)
  80057d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80057f:	85 f6                	test   %esi,%esi
  800581:	b8 f8 2a 80 00       	mov    $0x802af8,%eax
  800586:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800589:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80058d:	0f 84 97 00 00 00    	je     80062a <vprintfmt+0x22c>
  800593:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800597:	0f 8e 9b 00 00 00    	jle    800638 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80059d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a1:	89 34 24             	mov    %esi,(%esp)
  8005a4:	e8 cf 02 00 00       	call   800878 <strnlen>
  8005a9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005ac:	29 c2                	sub    %eax,%edx
  8005ae:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8005b1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8005b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005c1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005c3:	eb 0f                	jmp    8005d4 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8005c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cc:	89 04 24             	mov    %eax,(%esp)
  8005cf:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d1:	83 eb 01             	sub    $0x1,%ebx
  8005d4:	85 db                	test   %ebx,%ebx
  8005d6:	7f ed                	jg     8005c5 <vprintfmt+0x1c7>
  8005d8:	8b 75 d8             	mov    -0x28(%ebp),%esi
  8005db:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8005de:	85 d2                	test   %edx,%edx
  8005e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8005e5:	0f 49 c2             	cmovns %edx,%eax
  8005e8:	29 c2                	sub    %eax,%edx
  8005ea:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005ed:	89 d7                	mov    %edx,%edi
  8005ef:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f2:	eb 50                	jmp    800644 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005f8:	74 1e                	je     800618 <vprintfmt+0x21a>
  8005fa:	0f be d2             	movsbl %dl,%edx
  8005fd:	83 ea 20             	sub    $0x20,%edx
  800600:	83 fa 5e             	cmp    $0x5e,%edx
  800603:	76 13                	jbe    800618 <vprintfmt+0x21a>
					putch('?', putdat);
  800605:	8b 45 0c             	mov    0xc(%ebp),%eax
  800608:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800613:	ff 55 08             	call   *0x8(%ebp)
  800616:	eb 0d                	jmp    800625 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800618:	8b 55 0c             	mov    0xc(%ebp),%edx
  80061b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80061f:	89 04 24             	mov    %eax,(%esp)
  800622:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800625:	83 ef 01             	sub    $0x1,%edi
  800628:	eb 1a                	jmp    800644 <vprintfmt+0x246>
  80062a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80062d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800630:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800633:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800636:	eb 0c                	jmp    800644 <vprintfmt+0x246>
  800638:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80063b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80063e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800641:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800644:	83 c6 01             	add    $0x1,%esi
  800647:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80064b:	0f be c2             	movsbl %dl,%eax
  80064e:	85 c0                	test   %eax,%eax
  800650:	74 27                	je     800679 <vprintfmt+0x27b>
  800652:	85 db                	test   %ebx,%ebx
  800654:	78 9e                	js     8005f4 <vprintfmt+0x1f6>
  800656:	83 eb 01             	sub    $0x1,%ebx
  800659:	79 99                	jns    8005f4 <vprintfmt+0x1f6>
  80065b:	89 f8                	mov    %edi,%eax
  80065d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800660:	8b 75 08             	mov    0x8(%ebp),%esi
  800663:	89 c3                	mov    %eax,%ebx
  800665:	eb 1a                	jmp    800681 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800667:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80066b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800672:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800674:	83 eb 01             	sub    $0x1,%ebx
  800677:	eb 08                	jmp    800681 <vprintfmt+0x283>
  800679:	89 fb                	mov    %edi,%ebx
  80067b:	8b 75 08             	mov    0x8(%ebp),%esi
  80067e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800681:	85 db                	test   %ebx,%ebx
  800683:	7f e2                	jg     800667 <vprintfmt+0x269>
  800685:	89 75 08             	mov    %esi,0x8(%ebp)
  800688:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80068b:	e9 93 fd ff ff       	jmp    800423 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800690:	83 fa 01             	cmp    $0x1,%edx
  800693:	7e 16                	jle    8006ab <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 50 04             	mov    0x4(%eax),%edx
  8006a1:	8b 00                	mov    (%eax),%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a9:	eb 32                	jmp    8006dd <vprintfmt+0x2df>
	else if (lflag)
  8006ab:	85 d2                	test   %edx,%edx
  8006ad:	74 18                	je     8006c7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 30                	mov    (%eax),%esi
  8006ba:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006bd:	89 f0                	mov    %esi,%eax
  8006bf:	c1 f8 1f             	sar    $0x1f,%eax
  8006c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 30                	mov    (%eax),%esi
  8006d2:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8006d5:	89 f0                	mov    %esi,%eax
  8006d7:	c1 f8 1f             	sar    $0x1f,%eax
  8006da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  8006e3:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  8006e8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ec:	0f 89 80 00 00 00    	jns    800772 <vprintfmt+0x374>
				putch('-', putdat);
  8006f2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fd:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800703:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800706:	f7 d8                	neg    %eax
  800708:	83 d2 00             	adc    $0x0,%edx
  80070b:	f7 da                	neg    %edx
			}
			base = 10;
  80070d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800712:	eb 5e                	jmp    800772 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800714:	8d 45 14             	lea    0x14(%ebp),%eax
  800717:	e8 63 fc ff ff       	call   80037f <getuint>
			base = 10;
  80071c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800721:	eb 4f                	jmp    800772 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800723:	8d 45 14             	lea    0x14(%ebp),%eax
  800726:	e8 54 fc ff ff       	call   80037f <getuint>
			base =8;
  80072b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800730:	eb 40                	jmp    800772 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800732:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800736:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80073d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800740:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800744:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80074b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 50 04             	lea    0x4(%eax),%edx
  800754:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800757:	8b 00                	mov    (%eax),%eax
  800759:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80075e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800763:	eb 0d                	jmp    800772 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800765:	8d 45 14             	lea    0x14(%ebp),%eax
  800768:	e8 12 fc ff ff       	call   80037f <getuint>
			base = 16;
  80076d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800772:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800776:	89 74 24 10          	mov    %esi,0x10(%esp)
  80077a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80077d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800781:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800785:	89 04 24             	mov    %eax,(%esp)
  800788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078c:	89 fa                	mov    %edi,%edx
  80078e:	8b 45 08             	mov    0x8(%ebp),%eax
  800791:	e8 fa fa ff ff       	call   800290 <printnum>
			break;
  800796:	e9 88 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80079b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80079f:	89 04 24             	mov    %eax,(%esp)
  8007a2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8007a5:	e9 79 fc ff ff       	jmp    800423 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007aa:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007ae:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007b5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007b8:	89 f3                	mov    %esi,%ebx
  8007ba:	eb 03                	jmp    8007bf <vprintfmt+0x3c1>
  8007bc:	83 eb 01             	sub    $0x1,%ebx
  8007bf:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8007c3:	75 f7                	jne    8007bc <vprintfmt+0x3be>
  8007c5:	e9 59 fc ff ff       	jmp    800423 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8007ca:	83 c4 3c             	add    $0x3c,%esp
  8007cd:	5b                   	pop    %ebx
  8007ce:	5e                   	pop    %esi
  8007cf:	5f                   	pop    %edi
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 28             	sub    $0x28,%esp
  8007d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007db:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007e1:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007e5:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ef:	85 c0                	test   %eax,%eax
  8007f1:	74 30                	je     800823 <vsnprintf+0x51>
  8007f3:	85 d2                	test   %edx,%edx
  8007f5:	7e 2c                	jle    800823 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800801:	89 44 24 08          	mov    %eax,0x8(%esp)
  800805:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80080c:	c7 04 24 b9 03 80 00 	movl   $0x8003b9,(%esp)
  800813:	e8 e6 fb ff ff       	call   8003fe <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80081b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80081e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800821:	eb 05                	jmp    800828 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800830:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800833:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800837:	8b 45 10             	mov    0x10(%ebp),%eax
  80083a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800841:	89 44 24 04          	mov    %eax,0x4(%esp)
  800845:	8b 45 08             	mov    0x8(%ebp),%eax
  800848:	89 04 24             	mov    %eax,(%esp)
  80084b:	e8 82 ff ff ff       	call   8007d2 <vsnprintf>
	va_end(ap);

	return rc;
}
  800850:	c9                   	leave  
  800851:	c3                   	ret    
  800852:	66 90                	xchg   %ax,%ax
  800854:	66 90                	xchg   %ax,%ax
  800856:	66 90                	xchg   %ax,%ax
  800858:	66 90                	xchg   %ax,%ax
  80085a:	66 90                	xchg   %ax,%ax
  80085c:	66 90                	xchg   %ax,%ax
  80085e:	66 90                	xchg   %ax,%ax

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	eb 03                	jmp    800870 <strlen+0x10>
		n++;
  80086d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800874:	75 f7                	jne    80086d <strlen+0xd>
		n++;
	return n;
}
  800876:	5d                   	pop    %ebp
  800877:	c3                   	ret    

00800878 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800878:	55                   	push   %ebp
  800879:	89 e5                	mov    %esp,%ebp
  80087b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80087e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800881:	b8 00 00 00 00       	mov    $0x0,%eax
  800886:	eb 03                	jmp    80088b <strnlen+0x13>
		n++;
  800888:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80088b:	39 d0                	cmp    %edx,%eax
  80088d:	74 06                	je     800895 <strnlen+0x1d>
  80088f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800893:	75 f3                	jne    800888 <strnlen+0x10>
		n++;
	return n;
}
  800895:	5d                   	pop    %ebp
  800896:	c3                   	ret    

00800897 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800897:	55                   	push   %ebp
  800898:	89 e5                	mov    %esp,%ebp
  80089a:	53                   	push   %ebx
  80089b:	8b 45 08             	mov    0x8(%ebp),%eax
  80089e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a1:	89 c2                	mov    %eax,%edx
  8008a3:	83 c2 01             	add    $0x1,%edx
  8008a6:	83 c1 01             	add    $0x1,%ecx
  8008a9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8008ad:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b0:	84 db                	test   %bl,%bl
  8008b2:	75 ef                	jne    8008a3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b4:	5b                   	pop    %ebx
  8008b5:	5d                   	pop    %ebp
  8008b6:	c3                   	ret    

008008b7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b7:	55                   	push   %ebp
  8008b8:	89 e5                	mov    %esp,%ebp
  8008ba:	53                   	push   %ebx
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008c1:	89 1c 24             	mov    %ebx,(%esp)
  8008c4:	e8 97 ff ff ff       	call   800860 <strlen>
	strcpy(dst + len, src);
  8008c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8008d0:	01 d8                	add    %ebx,%eax
  8008d2:	89 04 24             	mov    %eax,(%esp)
  8008d5:	e8 bd ff ff ff       	call   800897 <strcpy>
	return dst;
}
  8008da:	89 d8                	mov    %ebx,%eax
  8008dc:	83 c4 08             	add    $0x8,%esp
  8008df:	5b                   	pop    %ebx
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
  8008e5:	56                   	push   %esi
  8008e6:	53                   	push   %ebx
  8008e7:	8b 75 08             	mov    0x8(%ebp),%esi
  8008ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ed:	89 f3                	mov    %esi,%ebx
  8008ef:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008f2:	89 f2                	mov    %esi,%edx
  8008f4:	eb 0f                	jmp    800905 <strncpy+0x23>
		*dst++ = *src;
  8008f6:	83 c2 01             	add    $0x1,%edx
  8008f9:	0f b6 01             	movzbl (%ecx),%eax
  8008fc:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ff:	80 39 01             	cmpb   $0x1,(%ecx)
  800902:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800905:	39 da                	cmp    %ebx,%edx
  800907:	75 ed                	jne    8008f6 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800909:	89 f0                	mov    %esi,%eax
  80090b:	5b                   	pop    %ebx
  80090c:	5e                   	pop    %esi
  80090d:	5d                   	pop    %ebp
  80090e:	c3                   	ret    

0080090f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	56                   	push   %esi
  800913:	53                   	push   %ebx
  800914:	8b 75 08             	mov    0x8(%ebp),%esi
  800917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80091d:	89 f0                	mov    %esi,%eax
  80091f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800923:	85 c9                	test   %ecx,%ecx
  800925:	75 0b                	jne    800932 <strlcpy+0x23>
  800927:	eb 1d                	jmp    800946 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800929:	83 c0 01             	add    $0x1,%eax
  80092c:	83 c2 01             	add    $0x1,%edx
  80092f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800932:	39 d8                	cmp    %ebx,%eax
  800934:	74 0b                	je     800941 <strlcpy+0x32>
  800936:	0f b6 0a             	movzbl (%edx),%ecx
  800939:	84 c9                	test   %cl,%cl
  80093b:	75 ec                	jne    800929 <strlcpy+0x1a>
  80093d:	89 c2                	mov    %eax,%edx
  80093f:	eb 02                	jmp    800943 <strlcpy+0x34>
  800941:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800943:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800946:	29 f0                	sub    %esi,%eax
}
  800948:	5b                   	pop    %ebx
  800949:	5e                   	pop    %esi
  80094a:	5d                   	pop    %ebp
  80094b:	c3                   	ret    

0080094c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800952:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800955:	eb 06                	jmp    80095d <strcmp+0x11>
		p++, q++;
  800957:	83 c1 01             	add    $0x1,%ecx
  80095a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80095d:	0f b6 01             	movzbl (%ecx),%eax
  800960:	84 c0                	test   %al,%al
  800962:	74 04                	je     800968 <strcmp+0x1c>
  800964:	3a 02                	cmp    (%edx),%al
  800966:	74 ef                	je     800957 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800968:	0f b6 c0             	movzbl %al,%eax
  80096b:	0f b6 12             	movzbl (%edx),%edx
  80096e:	29 d0                	sub    %edx,%eax
}
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	53                   	push   %ebx
  800976:	8b 45 08             	mov    0x8(%ebp),%eax
  800979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80097c:	89 c3                	mov    %eax,%ebx
  80097e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800981:	eb 06                	jmp    800989 <strncmp+0x17>
		n--, p++, q++;
  800983:	83 c0 01             	add    $0x1,%eax
  800986:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800989:	39 d8                	cmp    %ebx,%eax
  80098b:	74 15                	je     8009a2 <strncmp+0x30>
  80098d:	0f b6 08             	movzbl (%eax),%ecx
  800990:	84 c9                	test   %cl,%cl
  800992:	74 04                	je     800998 <strncmp+0x26>
  800994:	3a 0a                	cmp    (%edx),%cl
  800996:	74 eb                	je     800983 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800998:	0f b6 00             	movzbl (%eax),%eax
  80099b:	0f b6 12             	movzbl (%edx),%edx
  80099e:	29 d0                	sub    %edx,%eax
  8009a0:	eb 05                	jmp    8009a7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b4:	eb 07                	jmp    8009bd <strchr+0x13>
		if (*s == c)
  8009b6:	38 ca                	cmp    %cl,%dl
  8009b8:	74 0f                	je     8009c9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ba:	83 c0 01             	add    $0x1,%eax
  8009bd:	0f b6 10             	movzbl (%eax),%edx
  8009c0:	84 d2                	test   %dl,%dl
  8009c2:	75 f2                	jne    8009b6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8009c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009d5:	eb 07                	jmp    8009de <strfind+0x13>
		if (*s == c)
  8009d7:	38 ca                	cmp    %cl,%dl
  8009d9:	74 0a                	je     8009e5 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009db:	83 c0 01             	add    $0x1,%eax
  8009de:	0f b6 10             	movzbl (%eax),%edx
  8009e1:	84 d2                	test   %dl,%dl
  8009e3:	75 f2                	jne    8009d7 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	57                   	push   %edi
  8009eb:	56                   	push   %esi
  8009ec:	53                   	push   %ebx
  8009ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009f0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009f3:	85 c9                	test   %ecx,%ecx
  8009f5:	74 36                	je     800a2d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009f7:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009fd:	75 28                	jne    800a27 <memset+0x40>
  8009ff:	f6 c1 03             	test   $0x3,%cl
  800a02:	75 23                	jne    800a27 <memset+0x40>
		c &= 0xFF;
  800a04:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a08:	89 d3                	mov    %edx,%ebx
  800a0a:	c1 e3 08             	shl    $0x8,%ebx
  800a0d:	89 d6                	mov    %edx,%esi
  800a0f:	c1 e6 18             	shl    $0x18,%esi
  800a12:	89 d0                	mov    %edx,%eax
  800a14:	c1 e0 10             	shl    $0x10,%eax
  800a17:	09 f0                	or     %esi,%eax
  800a19:	09 c2                	or     %eax,%edx
  800a1b:	89 d0                	mov    %edx,%eax
  800a1d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a1f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800a22:	fc                   	cld    
  800a23:	f3 ab                	rep stos %eax,%es:(%edi)
  800a25:	eb 06                	jmp    800a2d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	fc                   	cld    
  800a2b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a2d:	89 f8                	mov    %edi,%eax
  800a2f:	5b                   	pop    %ebx
  800a30:	5e                   	pop    %esi
  800a31:	5f                   	pop    %edi
  800a32:	5d                   	pop    %ebp
  800a33:	c3                   	ret    

00800a34 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a34:	55                   	push   %ebp
  800a35:	89 e5                	mov    %esp,%ebp
  800a37:	57                   	push   %edi
  800a38:	56                   	push   %esi
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a3f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a42:	39 c6                	cmp    %eax,%esi
  800a44:	73 35                	jae    800a7b <memmove+0x47>
  800a46:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a49:	39 d0                	cmp    %edx,%eax
  800a4b:	73 2e                	jae    800a7b <memmove+0x47>
		s += n;
		d += n;
  800a4d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800a50:	89 d6                	mov    %edx,%esi
  800a52:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a54:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a5a:	75 13                	jne    800a6f <memmove+0x3b>
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 0e                	jne    800a6f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a61:	83 ef 04             	sub    $0x4,%edi
  800a64:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a67:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a6a:	fd                   	std    
  800a6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a6d:	eb 09                	jmp    800a78 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a6f:	83 ef 01             	sub    $0x1,%edi
  800a72:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a75:	fd                   	std    
  800a76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a78:	fc                   	cld    
  800a79:	eb 1d                	jmp    800a98 <memmove+0x64>
  800a7b:	89 f2                	mov    %esi,%edx
  800a7d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a7f:	f6 c2 03             	test   $0x3,%dl
  800a82:	75 0f                	jne    800a93 <memmove+0x5f>
  800a84:	f6 c1 03             	test   $0x3,%cl
  800a87:	75 0a                	jne    800a93 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a89:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a8c:	89 c7                	mov    %eax,%edi
  800a8e:	fc                   	cld    
  800a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a91:	eb 05                	jmp    800a98 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a93:	89 c7                	mov    %eax,%edi
  800a95:	fc                   	cld    
  800a96:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a98:	5e                   	pop    %esi
  800a99:	5f                   	pop    %edi
  800a9a:	5d                   	pop    %ebp
  800a9b:	c3                   	ret    

00800a9c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a9c:	55                   	push   %ebp
  800a9d:	89 e5                	mov    %esp,%ebp
  800a9f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab3:	89 04 24             	mov    %eax,(%esp)
  800ab6:	e8 79 ff ff ff       	call   800a34 <memmove>
}
  800abb:	c9                   	leave  
  800abc:	c3                   	ret    

00800abd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800abd:	55                   	push   %ebp
  800abe:	89 e5                	mov    %esp,%ebp
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	8b 55 08             	mov    0x8(%ebp),%edx
  800ac5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac8:	89 d6                	mov    %edx,%esi
  800aca:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acd:	eb 1a                	jmp    800ae9 <memcmp+0x2c>
		if (*s1 != *s2)
  800acf:	0f b6 02             	movzbl (%edx),%eax
  800ad2:	0f b6 19             	movzbl (%ecx),%ebx
  800ad5:	38 d8                	cmp    %bl,%al
  800ad7:	74 0a                	je     800ae3 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800ad9:	0f b6 c0             	movzbl %al,%eax
  800adc:	0f b6 db             	movzbl %bl,%ebx
  800adf:	29 d8                	sub    %ebx,%eax
  800ae1:	eb 0f                	jmp    800af2 <memcmp+0x35>
		s1++, s2++;
  800ae3:	83 c2 01             	add    $0x1,%edx
  800ae6:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ae9:	39 f2                	cmp    %esi,%edx
  800aeb:	75 e2                	jne    800acf <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800aed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800af2:	5b                   	pop    %ebx
  800af3:	5e                   	pop    %esi
  800af4:	5d                   	pop    %ebp
  800af5:	c3                   	ret    

00800af6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	8b 45 08             	mov    0x8(%ebp),%eax
  800afc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800aff:	89 c2                	mov    %eax,%edx
  800b01:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b04:	eb 07                	jmp    800b0d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b06:	38 08                	cmp    %cl,(%eax)
  800b08:	74 07                	je     800b11 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	39 d0                	cmp    %edx,%eax
  800b0f:	72 f5                	jb     800b06 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b11:	5d                   	pop    %ebp
  800b12:	c3                   	ret    

00800b13 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b13:	55                   	push   %ebp
  800b14:	89 e5                	mov    %esp,%ebp
  800b16:	57                   	push   %edi
  800b17:	56                   	push   %esi
  800b18:	53                   	push   %ebx
  800b19:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1f:	eb 03                	jmp    800b24 <strtol+0x11>
		s++;
  800b21:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b24:	0f b6 0a             	movzbl (%edx),%ecx
  800b27:	80 f9 09             	cmp    $0x9,%cl
  800b2a:	74 f5                	je     800b21 <strtol+0xe>
  800b2c:	80 f9 20             	cmp    $0x20,%cl
  800b2f:	74 f0                	je     800b21 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b31:	80 f9 2b             	cmp    $0x2b,%cl
  800b34:	75 0a                	jne    800b40 <strtol+0x2d>
		s++;
  800b36:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800b39:	bf 00 00 00 00       	mov    $0x0,%edi
  800b3e:	eb 11                	jmp    800b51 <strtol+0x3e>
  800b40:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800b45:	80 f9 2d             	cmp    $0x2d,%cl
  800b48:	75 07                	jne    800b51 <strtol+0x3e>
		s++, neg = 1;
  800b4a:	8d 52 01             	lea    0x1(%edx),%edx
  800b4d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b51:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800b56:	75 15                	jne    800b6d <strtol+0x5a>
  800b58:	80 3a 30             	cmpb   $0x30,(%edx)
  800b5b:	75 10                	jne    800b6d <strtol+0x5a>
  800b5d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b61:	75 0a                	jne    800b6d <strtol+0x5a>
		s += 2, base = 16;
  800b63:	83 c2 02             	add    $0x2,%edx
  800b66:	b8 10 00 00 00       	mov    $0x10,%eax
  800b6b:	eb 10                	jmp    800b7d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	75 0c                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b71:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b73:	80 3a 30             	cmpb   $0x30,(%edx)
  800b76:	75 05                	jne    800b7d <strtol+0x6a>
		s++, base = 8;
  800b78:	83 c2 01             	add    $0x1,%edx
  800b7b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b82:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b85:	0f b6 0a             	movzbl (%edx),%ecx
  800b88:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b8b:	89 f0                	mov    %esi,%eax
  800b8d:	3c 09                	cmp    $0x9,%al
  800b8f:	77 08                	ja     800b99 <strtol+0x86>
			dig = *s - '0';
  800b91:	0f be c9             	movsbl %cl,%ecx
  800b94:	83 e9 30             	sub    $0x30,%ecx
  800b97:	eb 20                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b99:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b9c:	89 f0                	mov    %esi,%eax
  800b9e:	3c 19                	cmp    $0x19,%al
  800ba0:	77 08                	ja     800baa <strtol+0x97>
			dig = *s - 'a' + 10;
  800ba2:	0f be c9             	movsbl %cl,%ecx
  800ba5:	83 e9 57             	sub    $0x57,%ecx
  800ba8:	eb 0f                	jmp    800bb9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800baa:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800bad:	89 f0                	mov    %esi,%eax
  800baf:	3c 19                	cmp    $0x19,%al
  800bb1:	77 16                	ja     800bc9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800bb3:	0f be c9             	movsbl %cl,%ecx
  800bb6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bb9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800bbc:	7d 0f                	jge    800bcd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800bc5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800bc7:	eb bc                	jmp    800b85 <strtol+0x72>
  800bc9:	89 d8                	mov    %ebx,%eax
  800bcb:	eb 02                	jmp    800bcf <strtol+0xbc>
  800bcd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd3:	74 05                	je     800bda <strtol+0xc7>
		*endptr = (char *) s;
  800bd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bd8:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800bda:	f7 d8                	neg    %eax
  800bdc:	85 ff                	test   %edi,%edi
  800bde:	0f 44 c3             	cmove  %ebx,%eax
}
  800be1:	5b                   	pop    %ebx
  800be2:	5e                   	pop    %esi
  800be3:	5f                   	pop    %edi
  800be4:	5d                   	pop    %ebp
  800be5:	c3                   	ret    

00800be6 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800be6:	55                   	push   %ebp
  800be7:	89 e5                	mov    %esp,%ebp
  800be9:	57                   	push   %edi
  800bea:	56                   	push   %esi
  800beb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf7:	89 c3                	mov    %eax,%ebx
  800bf9:	89 c7                	mov    %eax,%edi
  800bfb:	89 c6                	mov    %eax,%esi
  800bfd:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bff:	5b                   	pop    %ebx
  800c00:	5e                   	pop    %esi
  800c01:	5f                   	pop    %edi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	57                   	push   %edi
  800c08:	56                   	push   %esi
  800c09:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c0f:	b8 01 00 00 00       	mov    $0x1,%eax
  800c14:	89 d1                	mov    %edx,%ecx
  800c16:	89 d3                	mov    %edx,%ebx
  800c18:	89 d7                	mov    %edx,%edi
  800c1a:	89 d6                	mov    %edx,%esi
  800c1c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c1e:	5b                   	pop    %ebx
  800c1f:	5e                   	pop    %esi
  800c20:	5f                   	pop    %edi
  800c21:	5d                   	pop    %ebp
  800c22:	c3                   	ret    

00800c23 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c23:	55                   	push   %ebp
  800c24:	89 e5                	mov    %esp,%ebp
  800c26:	57                   	push   %edi
  800c27:	56                   	push   %esi
  800c28:	53                   	push   %ebx
  800c29:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c2c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c31:	b8 03 00 00 00       	mov    $0x3,%eax
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	89 cb                	mov    %ecx,%ebx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	89 ce                	mov    %ecx,%esi
  800c3f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c41:	85 c0                	test   %eax,%eax
  800c43:	7e 28                	jle    800c6d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c45:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c49:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800c50:	00 
  800c51:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800c68:	e8 0f f5 ff ff       	call   80017c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6d:	83 c4 2c             	add    $0x2c,%esp
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	57                   	push   %edi
  800c79:	56                   	push   %esi
  800c7a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c80:	b8 02 00 00 00       	mov    $0x2,%eax
  800c85:	89 d1                	mov    %edx,%ecx
  800c87:	89 d3                	mov    %edx,%ebx
  800c89:	89 d7                	mov    %edx,%edi
  800c8b:	89 d6                	mov    %edx,%esi
  800c8d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    

00800c94 <sys_yield>:

void
sys_yield(void)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c9a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ca4:	89 d1                	mov    %edx,%ecx
  800ca6:	89 d3                	mov    %edx,%ebx
  800ca8:	89 d7                	mov    %edx,%edi
  800caa:	89 d6                	mov    %edx,%esi
  800cac:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cae:	5b                   	pop    %ebx
  800caf:	5e                   	pop    %esi
  800cb0:	5f                   	pop    %edi
  800cb1:	5d                   	pop    %ebp
  800cb2:	c3                   	ret    

00800cb3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	57                   	push   %edi
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbc:	be 00 00 00 00       	mov    $0x0,%esi
  800cc1:	b8 04 00 00 00       	mov    $0x4,%eax
  800cc6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ccf:	89 f7                	mov    %esi,%edi
  800cd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cd3:	85 c0                	test   %eax,%eax
  800cd5:	7e 28                	jle    800cff <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cdb:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ce2:	00 
  800ce3:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800cea:	00 
  800ceb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cf2:	00 
  800cf3:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800cfa:	e8 7d f4 ff ff       	call   80017c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cff:	83 c4 2c             	add    $0x2c,%esp
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d10:	b8 05 00 00 00       	mov    $0x5,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d21:	8b 75 18             	mov    0x18(%ebp),%esi
  800d24:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d26:	85 c0                	test   %eax,%eax
  800d28:	7e 28                	jle    800d52 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d2e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800d35:	00 
  800d36:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d45:	00 
  800d46:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800d4d:	e8 2a f4 ff ff       	call   80017c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d52:	83 c4 2c             	add    $0x2c,%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d63:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d68:	b8 06 00 00 00       	mov    $0x6,%eax
  800d6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d70:	8b 55 08             	mov    0x8(%ebp),%edx
  800d73:	89 df                	mov    %ebx,%edi
  800d75:	89 de                	mov    %ebx,%esi
  800d77:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d79:	85 c0                	test   %eax,%eax
  800d7b:	7e 28                	jle    800da5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d81:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d88:	00 
  800d89:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800d90:	00 
  800d91:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d98:	00 
  800d99:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800da0:	e8 d7 f3 ff ff       	call   80017c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	83 c4 2c             	add    $0x2c,%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    

00800dad <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800dad:	55                   	push   %ebp
  800dae:	89 e5                	mov    %esp,%ebp
  800db0:	57                   	push   %edi
  800db1:	56                   	push   %esi
  800db2:	53                   	push   %ebx
  800db3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbb:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc6:	89 df                	mov    %ebx,%edi
  800dc8:	89 de                	mov    %ebx,%esi
  800dca:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dcc:	85 c0                	test   %eax,%eax
  800dce:	7e 28                	jle    800df8 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dd4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ddb:	00 
  800ddc:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800de3:	00 
  800de4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800deb:	00 
  800dec:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800df3:	e8 84 f3 ff ff       	call   80017c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800df8:	83 c4 2c             	add    $0x2c,%esp
  800dfb:	5b                   	pop    %ebx
  800dfc:	5e                   	pop    %esi
  800dfd:	5f                   	pop    %edi
  800dfe:	5d                   	pop    %ebp
  800dff:	c3                   	ret    

00800e00 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e00:	55                   	push   %ebp
  800e01:	89 e5                	mov    %esp,%ebp
  800e03:	57                   	push   %edi
  800e04:	56                   	push   %esi
  800e05:	53                   	push   %ebx
  800e06:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	89 df                	mov    %ebx,%edi
  800e1b:	89 de                	mov    %ebx,%esi
  800e1d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e1f:	85 c0                	test   %eax,%eax
  800e21:	7e 28                	jle    800e4b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e23:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e27:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800e36:	00 
  800e37:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e3e:	00 
  800e3f:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800e46:	e8 31 f3 ff ff       	call   80017c <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e4b:	83 c4 2c             	add    $0x2c,%esp
  800e4e:	5b                   	pop    %ebx
  800e4f:	5e                   	pop    %esi
  800e50:	5f                   	pop    %edi
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800e5c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e61:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e69:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6c:	89 df                	mov    %ebx,%edi
  800e6e:	89 de                	mov    %ebx,%esi
  800e70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e72:	85 c0                	test   %eax,%eax
  800e74:	7e 28                	jle    800e9e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e7a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e81:	00 
  800e82:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800e89:	00 
  800e8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e91:	00 
  800e92:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800e99:	e8 de f2 ff ff       	call   80017c <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9e:	83 c4 2c             	add    $0x2c,%esp
  800ea1:	5b                   	pop    %ebx
  800ea2:	5e                   	pop    %esi
  800ea3:	5f                   	pop    %edi
  800ea4:	5d                   	pop    %ebp
  800ea5:	c3                   	ret    

00800ea6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea6:	55                   	push   %ebp
  800ea7:	89 e5                	mov    %esp,%ebp
  800ea9:	57                   	push   %edi
  800eaa:	56                   	push   %esi
  800eab:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eac:	be 00 00 00 00       	mov    $0x0,%esi
  800eb1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800eb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    

00800ec9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
  800ecf:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ed7:	b8 0d 00 00 00       	mov    $0xd,%eax
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	89 cb                	mov    %ecx,%ebx
  800ee1:	89 cf                	mov    %ecx,%edi
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	7e 28                	jle    800f13 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eeb:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eef:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800efe:	00 
  800eff:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f06:	00 
  800f07:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800f0e:	e8 69 f2 ff ff       	call   80017c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	83 c4 2c             	add    $0x2c,%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
  800f40:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f43:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f48:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f50:	8b 55 08             	mov    0x8(%ebp),%edx
  800f53:	89 df                	mov    %ebx,%edi
  800f55:	89 de                	mov    %ebx,%esi
  800f57:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	7e 28                	jle    800f85 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f61:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f68:	00 
  800f69:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800f70:	00 
  800f71:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f78:	00 
  800f79:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800f80:	e8 f7 f1 ff ff       	call   80017c <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f85:	83 c4 2c             	add    $0x2c,%esp
  800f88:	5b                   	pop    %ebx
  800f89:	5e                   	pop    %esi
  800f8a:	5f                   	pop    %edi
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	57                   	push   %edi
  800f91:	56                   	push   %esi
  800f92:	53                   	push   %ebx
  800f93:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9b:	b8 10 00 00 00       	mov    $0x10,%eax
  800fa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	89 df                	mov    %ebx,%edi
  800fa8:	89 de                	mov    %ebx,%esi
  800faa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800fac:	85 c0                	test   %eax,%eax
  800fae:	7e 28                	jle    800fd8 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 08 df 2d 80 	movl   $0x802ddf,0x8(%esp)
  800fc3:	00 
  800fc4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcb:	00 
  800fcc:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800fd3:	e8 a4 f1 ff ff       	call   80017c <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800fd8:	83 c4 2c             	add    $0x2c,%esp
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	53                   	push   %ebx
  800fe4:	83 ec 24             	sub    $0x24,%esp
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  800fea:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  800fec:	89 d3                	mov    %edx,%ebx
  800fee:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800ff4:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800ff8:	74 1a                	je     801014 <pgfault+0x34>
  800ffa:	c1 ea 0c             	shr    $0xc,%edx
  800ffd:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801004:	a8 01                	test   $0x1,%al
  801006:	74 0c                	je     801014 <pgfault+0x34>
  801008:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80100f:	f6 c4 08             	test   $0x8,%ah
  801012:	75 1c                	jne    801030 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  801014:	c7 44 24 08 0c 2e 80 	movl   $0x802e0c,0x8(%esp)
  80101b:	00 
  80101c:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801023:	00 
  801024:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  80102b:	e8 4c f1 ff ff       	call   80017c <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  801030:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801037:	00 
  801038:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80103f:	00 
  801040:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801047:	e8 67 fc ff ff       	call   800cb3 <sys_page_alloc>
  80104c:	85 c0                	test   %eax,%eax
  80104e:	79 1c                	jns    80106c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  801050:	c7 44 24 08 50 2e 80 	movl   $0x802e50,0x8(%esp)
  801057:	00 
  801058:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  80105f:	00 
  801060:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  801067:	e8 10 f1 ff ff       	call   80017c <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80106c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801073:	00 
  801074:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801078:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80107f:	e8 18 fa ff ff       	call   800a9c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801084:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80108b:	00 
  80108c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801090:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801097:	00 
  801098:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80109f:	00 
  8010a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010a7:	e8 5b fc ff ff       	call   800d07 <sys_page_map>
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	74 1c                	je     8010cc <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  8010b0:	c7 44 24 08 66 2f 80 	movl   $0x802f66,0x8(%esp)
  8010b7:	00 
  8010b8:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8010bf:	00 
  8010c0:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  8010c7:	e8 b0 f0 ff ff       	call   80017c <_panic>
    sys_page_unmap(0,PFTEMP);
  8010cc:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010db:	e8 7a fc ff ff       	call   800d5a <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  8010e0:	83 c4 24             	add    $0x24,%esp
  8010e3:	5b                   	pop    %ebx
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	57                   	push   %edi
  8010ea:	56                   	push   %esi
  8010eb:	53                   	push   %ebx
  8010ec:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  8010ef:	c7 04 24 e0 0f 80 00 	movl   $0x800fe0,(%esp)
  8010f6:	e8 fb 14 00 00       	call   8025f6 <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8010fb:	b8 07 00 00 00       	mov    $0x7,%eax
  801100:	cd 30                	int    $0x30
  801102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801105:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  801107:	bb 00 00 00 00       	mov    $0x0,%ebx
  80110c:	85 c0                	test   %eax,%eax
  80110e:	75 21                	jne    801131 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  801110:	e8 60 fb ff ff       	call   800c75 <sys_getenvid>
  801115:	25 ff 03 00 00       	and    $0x3ff,%eax
  80111a:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80111d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801122:	a3 0c 50 80 00       	mov    %eax,0x80500c
		return 0;
  801127:	b8 00 00 00 00       	mov    $0x0,%eax
  80112c:	e9 de 01 00 00       	jmp    80130f <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  801131:	89 d8                	mov    %ebx,%eax
  801133:	c1 e8 16             	shr    $0x16,%eax
  801136:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80113d:	a8 01                	test   $0x1,%al
  80113f:	0f 84 58 01 00 00    	je     80129d <fork+0x1b7>
  801145:	89 de                	mov    %ebx,%esi
  801147:	c1 ee 0c             	shr    $0xc,%esi
  80114a:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801151:	83 e0 05             	and    $0x5,%eax
  801154:	83 f8 05             	cmp    $0x5,%eax
  801157:	0f 85 40 01 00 00    	jne    80129d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  80115d:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801164:	f6 c4 04             	test   $0x4,%ah
  801167:	74 4f                	je     8011b8 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801169:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801170:	c1 e6 0c             	shl    $0xc,%esi
  801173:	25 07 0e 00 00       	and    $0xe07,%eax
  801178:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801180:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801184:	89 74 24 04          	mov    %esi,0x4(%esp)
  801188:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80118f:	e8 73 fb ff ff       	call   800d07 <sys_page_map>
  801194:	85 c0                	test   %eax,%eax
  801196:	0f 89 01 01 00 00    	jns    80129d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80119c:	c7 44 24 08 70 2e 80 	movl   $0x802e70,0x8(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  8011ab:	00 
  8011ac:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  8011b3:	e8 c4 ef ff ff       	call   80017c <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  8011b8:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011bf:	a8 02                	test   $0x2,%al
  8011c1:	75 10                	jne    8011d3 <fork+0xed>
  8011c3:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8011ca:	f6 c4 08             	test   $0x8,%ah
  8011cd:	0f 84 87 00 00 00    	je     80125a <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  8011d3:	c1 e6 0c             	shl    $0xc,%esi
  8011d6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011dd:	00 
  8011de:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011e2:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8011e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f1:	e8 11 fb ff ff       	call   800d07 <sys_page_map>
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 1c                	jns    801216 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  8011fa:	c7 44 24 08 a8 2e 80 	movl   $0x802ea8,0x8(%esp)
  801201:	00 
  801202:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801209:	00 
  80120a:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  801211:	e8 66 ef ff ff       	call   80017c <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  801216:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80121d:	00 
  80121e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801222:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801229:	00 
  80122a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801235:	e8 cd fa ff ff       	call   800d07 <sys_page_map>
  80123a:	85 c0                	test   %eax,%eax
  80123c:	79 5f                	jns    80129d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  80123e:	c7 44 24 08 e0 2e 80 	movl   $0x802ee0,0x8(%esp)
  801245:	00 
  801246:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  80124d:	00 
  80124e:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  801255:	e8 22 ef ff ff       	call   80017c <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  80125a:	c1 e6 0c             	shl    $0xc,%esi
  80125d:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801264:	00 
  801265:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801269:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80126d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801271:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801278:	e8 8a fa ff ff       	call   800d07 <sys_page_map>
  80127d:	85 c0                	test   %eax,%eax
  80127f:	74 1c                	je     80129d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801281:	c7 44 24 08 08 2f 80 	movl   $0x802f08,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  801298:	e8 df ee ff ff       	call   80017c <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80129d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8012a3:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  8012a9:	0f 85 82 fe ff ff    	jne    801131 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  8012af:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8012b6:	00 
  8012b7:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8012be:	ee 
  8012bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012c2:	89 04 24             	mov    %eax,(%esp)
  8012c5:	e8 e9 f9 ff ff       	call   800cb3 <sys_page_alloc>
  8012ca:	85 c0                	test   %eax,%eax
  8012cc:	79 1c                	jns    8012ea <fork+0x204>
      panic("sys_page_alloc failure in fork");
  8012ce:	c7 44 24 08 3c 2f 80 	movl   $0x802f3c,0x8(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  8012dd:	00 
  8012de:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  8012e5:	e8 92 ee ff ff       	call   80017c <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  8012ea:	c7 44 24 04 67 26 80 	movl   $0x802667,0x4(%esp)
  8012f1:	00 
  8012f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8012f5:	89 3c 24             	mov    %edi,(%esp)
  8012f8:	e8 56 fb ff ff       	call   800e53 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  8012fd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  801304:	00 
  801305:	89 3c 24             	mov    %edi,(%esp)
  801308:	e8 a0 fa ff ff       	call   800dad <sys_env_set_status>
		return child;
  80130d:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  80130f:	83 c4 2c             	add    $0x2c,%esp
  801312:	5b                   	pop    %ebx
  801313:	5e                   	pop    %esi
  801314:	5f                   	pop    %edi
  801315:	5d                   	pop    %ebp
  801316:	c3                   	ret    

00801317 <sfork>:

// Challenge!
int
sfork(void)
{
  801317:	55                   	push   %ebp
  801318:	89 e5                	mov    %esp,%ebp
  80131a:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  80131d:	c7 44 24 08 84 2f 80 	movl   $0x802f84,0x8(%esp)
  801324:	00 
  801325:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  80132c:	00 
  80132d:	c7 04 24 5b 2f 80 00 	movl   $0x802f5b,(%esp)
  801334:	e8 43 ee ff ff       	call   80017c <_panic>
  801339:	66 90                	xchg   %ax,%ax
  80133b:	66 90                	xchg   %ax,%ax
  80133d:	66 90                	xchg   %ax,%ax
  80133f:	90                   	nop

00801340 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801343:	8b 45 08             	mov    0x8(%ebp),%eax
  801346:	05 00 00 00 30       	add    $0x30000000,%eax
  80134b:	c1 e8 0c             	shr    $0xc,%eax
}
  80134e:	5d                   	pop    %ebp
  80134f:	c3                   	ret    

00801350 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  80135b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801360:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80136d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801372:	89 c2                	mov    %eax,%edx
  801374:	c1 ea 16             	shr    $0x16,%edx
  801377:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80137e:	f6 c2 01             	test   $0x1,%dl
  801381:	74 11                	je     801394 <fd_alloc+0x2d>
  801383:	89 c2                	mov    %eax,%edx
  801385:	c1 ea 0c             	shr    $0xc,%edx
  801388:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138f:	f6 c2 01             	test   $0x1,%dl
  801392:	75 09                	jne    80139d <fd_alloc+0x36>
			*fd_store = fd;
  801394:	89 01                	mov    %eax,(%ecx)
			return 0;
  801396:	b8 00 00 00 00       	mov    $0x0,%eax
  80139b:	eb 17                	jmp    8013b4 <fd_alloc+0x4d>
  80139d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013a2:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013a7:	75 c9                	jne    801372 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8013af:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  8013b4:	5d                   	pop    %ebp
  8013b5:	c3                   	ret    

008013b6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013bc:	83 f8 1f             	cmp    $0x1f,%eax
  8013bf:	77 36                	ja     8013f7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013c1:	c1 e0 0c             	shl    $0xc,%eax
  8013c4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8013c9:	89 c2                	mov    %eax,%edx
  8013cb:	c1 ea 16             	shr    $0x16,%edx
  8013ce:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013d5:	f6 c2 01             	test   $0x1,%dl
  8013d8:	74 24                	je     8013fe <fd_lookup+0x48>
  8013da:	89 c2                	mov    %eax,%edx
  8013dc:	c1 ea 0c             	shr    $0xc,%edx
  8013df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013e6:	f6 c2 01             	test   $0x1,%dl
  8013e9:	74 1a                	je     801405 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8013eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013ee:	89 02                	mov    %eax,(%edx)
	return 0;
  8013f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8013f5:	eb 13                	jmp    80140a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013fc:	eb 0c                	jmp    80140a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  8013fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801403:	eb 05                	jmp    80140a <fd_lookup+0x54>
  801405:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80140a:	5d                   	pop    %ebp
  80140b:	c3                   	ret    

0080140c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 18             	sub    $0x18,%esp
  801412:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801415:	ba 00 00 00 00       	mov    $0x0,%edx
  80141a:	eb 13                	jmp    80142f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80141c:	39 08                	cmp    %ecx,(%eax)
  80141e:	75 0c                	jne    80142c <dev_lookup+0x20>
			*dev = devtab[i];
  801420:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801423:	89 01                	mov    %eax,(%ecx)
			return 0;
  801425:	b8 00 00 00 00       	mov    $0x0,%eax
  80142a:	eb 38                	jmp    801464 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80142c:	83 c2 01             	add    $0x1,%edx
  80142f:	8b 04 95 18 30 80 00 	mov    0x803018(,%edx,4),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	75 e2                	jne    80141c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80143a:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80143f:	8b 40 48             	mov    0x48(%eax),%eax
  801442:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801446:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144a:	c7 04 24 9c 2f 80 00 	movl   $0x802f9c,(%esp)
  801451:	e8 1f ee ff ff       	call   800275 <cprintf>
	*dev = 0;
  801456:	8b 45 0c             	mov    0xc(%ebp),%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801464:	c9                   	leave  
  801465:	c3                   	ret    

00801466 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	56                   	push   %esi
  80146a:	53                   	push   %ebx
  80146b:	83 ec 20             	sub    $0x20,%esp
  80146e:	8b 75 08             	mov    0x8(%ebp),%esi
  801471:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801474:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801477:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80147b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801481:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801484:	89 04 24             	mov    %eax,(%esp)
  801487:	e8 2a ff ff ff       	call   8013b6 <fd_lookup>
  80148c:	85 c0                	test   %eax,%eax
  80148e:	78 05                	js     801495 <fd_close+0x2f>
	    || fd != fd2)
  801490:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801493:	74 0c                	je     8014a1 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801495:	84 db                	test   %bl,%bl
  801497:	ba 00 00 00 00       	mov    $0x0,%edx
  80149c:	0f 44 c2             	cmove  %edx,%eax
  80149f:	eb 3f                	jmp    8014e0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a8:	8b 06                	mov    (%esi),%eax
  8014aa:	89 04 24             	mov    %eax,(%esp)
  8014ad:	e8 5a ff ff ff       	call   80140c <dev_lookup>
  8014b2:	89 c3                	mov    %eax,%ebx
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 16                	js     8014ce <fd_close+0x68>
		if (dev->dev_close)
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  8014be:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	74 07                	je     8014ce <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8014c7:	89 34 24             	mov    %esi,(%esp)
  8014ca:	ff d0                	call   *%eax
  8014cc:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8014ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014d9:	e8 7c f8 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  8014de:	89 d8                	mov    %ebx,%eax
}
  8014e0:	83 c4 20             	add    $0x20,%esp
  8014e3:	5b                   	pop    %ebx
  8014e4:	5e                   	pop    %esi
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f7:	89 04 24             	mov    %eax,(%esp)
  8014fa:	e8 b7 fe ff ff       	call   8013b6 <fd_lookup>
  8014ff:	89 c2                	mov    %eax,%edx
  801501:	85 d2                	test   %edx,%edx
  801503:	78 13                	js     801518 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801505:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80150c:	00 
  80150d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801510:	89 04 24             	mov    %eax,(%esp)
  801513:	e8 4e ff ff ff       	call   801466 <fd_close>
}
  801518:	c9                   	leave  
  801519:	c3                   	ret    

0080151a <close_all>:

void
close_all(void)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801521:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801526:	89 1c 24             	mov    %ebx,(%esp)
  801529:	e8 b9 ff ff ff       	call   8014e7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80152e:	83 c3 01             	add    $0x1,%ebx
  801531:	83 fb 20             	cmp    $0x20,%ebx
  801534:	75 f0                	jne    801526 <close_all+0xc>
		close(i);
}
  801536:	83 c4 14             	add    $0x14,%esp
  801539:	5b                   	pop    %ebx
  80153a:	5d                   	pop    %ebp
  80153b:	c3                   	ret    

0080153c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	57                   	push   %edi
  801540:	56                   	push   %esi
  801541:	53                   	push   %ebx
  801542:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801545:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80154c:	8b 45 08             	mov    0x8(%ebp),%eax
  80154f:	89 04 24             	mov    %eax,(%esp)
  801552:	e8 5f fe ff ff       	call   8013b6 <fd_lookup>
  801557:	89 c2                	mov    %eax,%edx
  801559:	85 d2                	test   %edx,%edx
  80155b:	0f 88 e1 00 00 00    	js     801642 <dup+0x106>
		return r;
	close(newfdnum);
  801561:	8b 45 0c             	mov    0xc(%ebp),%eax
  801564:	89 04 24             	mov    %eax,(%esp)
  801567:	e8 7b ff ff ff       	call   8014e7 <close>

	newfd = INDEX2FD(newfdnum);
  80156c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80156f:	c1 e3 0c             	shl    $0xc,%ebx
  801572:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801578:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80157b:	89 04 24             	mov    %eax,(%esp)
  80157e:	e8 cd fd ff ff       	call   801350 <fd2data>
  801583:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801585:	89 1c 24             	mov    %ebx,(%esp)
  801588:	e8 c3 fd ff ff       	call   801350 <fd2data>
  80158d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80158f:	89 f0                	mov    %esi,%eax
  801591:	c1 e8 16             	shr    $0x16,%eax
  801594:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80159b:	a8 01                	test   $0x1,%al
  80159d:	74 43                	je     8015e2 <dup+0xa6>
  80159f:	89 f0                	mov    %esi,%eax
  8015a1:	c1 e8 0c             	shr    $0xc,%eax
  8015a4:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8015ab:	f6 c2 01             	test   $0x1,%dl
  8015ae:	74 32                	je     8015e2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8015b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b7:	25 07 0e 00 00       	and    $0xe07,%eax
  8015bc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015c0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8015c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015cb:	00 
  8015cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015d7:	e8 2b f7 ff ff       	call   800d07 <sys_page_map>
  8015dc:	89 c6                	mov    %eax,%esi
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 3e                	js     801620 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8015e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015e5:	89 c2                	mov    %eax,%edx
  8015e7:	c1 ea 0c             	shr    $0xc,%edx
  8015ea:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015f1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8015f7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8015fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801606:	00 
  801607:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801612:	e8 f0 f6 ff ff       	call   800d07 <sys_page_map>
  801617:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801619:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80161c:	85 f6                	test   %esi,%esi
  80161e:	79 22                	jns    801642 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801620:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801624:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80162b:	e8 2a f7 ff ff       	call   800d5a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801630:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801634:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80163b:	e8 1a f7 ff ff       	call   800d5a <sys_page_unmap>
	return r;
  801640:	89 f0                	mov    %esi,%eax
}
  801642:	83 c4 3c             	add    $0x3c,%esp
  801645:	5b                   	pop    %ebx
  801646:	5e                   	pop    %esi
  801647:	5f                   	pop    %edi
  801648:	5d                   	pop    %ebp
  801649:	c3                   	ret    

0080164a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80164a:	55                   	push   %ebp
  80164b:	89 e5                	mov    %esp,%ebp
  80164d:	53                   	push   %ebx
  80164e:	83 ec 24             	sub    $0x24,%esp
  801651:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801654:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	89 1c 24             	mov    %ebx,(%esp)
  80165e:	e8 53 fd ff ff       	call   8013b6 <fd_lookup>
  801663:	89 c2                	mov    %eax,%edx
  801665:	85 d2                	test   %edx,%edx
  801667:	78 6d                	js     8016d6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801669:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801670:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801673:	8b 00                	mov    (%eax),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 8f fd ff ff       	call   80140c <dev_lookup>
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 55                	js     8016d6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	8b 50 08             	mov    0x8(%eax),%edx
  801687:	83 e2 03             	and    $0x3,%edx
  80168a:	83 fa 01             	cmp    $0x1,%edx
  80168d:	75 23                	jne    8016b2 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80168f:	a1 0c 50 80 00       	mov    0x80500c,%eax
  801694:	8b 40 48             	mov    0x48(%eax),%eax
  801697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80169b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169f:	c7 04 24 dd 2f 80 00 	movl   $0x802fdd,(%esp)
  8016a6:	e8 ca eb ff ff       	call   800275 <cprintf>
		return -E_INVAL;
  8016ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016b0:	eb 24                	jmp    8016d6 <read+0x8c>
	}
	if (!dev->dev_read)
  8016b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b5:	8b 52 08             	mov    0x8(%edx),%edx
  8016b8:	85 d2                	test   %edx,%edx
  8016ba:	74 15                	je     8016d1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016c6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8016ca:	89 04 24             	mov    %eax,(%esp)
  8016cd:	ff d2                	call   *%edx
  8016cf:	eb 05                	jmp    8016d6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8016d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8016d6:	83 c4 24             	add    $0x24,%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 1c             	sub    $0x1c,%esp
  8016e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f0:	eb 23                	jmp    801715 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016f2:	89 f0                	mov    %esi,%eax
  8016f4:	29 d8                	sub    %ebx,%eax
  8016f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016fa:	89 d8                	mov    %ebx,%eax
  8016fc:	03 45 0c             	add    0xc(%ebp),%eax
  8016ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801703:	89 3c 24             	mov    %edi,(%esp)
  801706:	e8 3f ff ff ff       	call   80164a <read>
		if (m < 0)
  80170b:	85 c0                	test   %eax,%eax
  80170d:	78 10                	js     80171f <readn+0x43>
			return m;
		if (m == 0)
  80170f:	85 c0                	test   %eax,%eax
  801711:	74 0a                	je     80171d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801713:	01 c3                	add    %eax,%ebx
  801715:	39 f3                	cmp    %esi,%ebx
  801717:	72 d9                	jb     8016f2 <readn+0x16>
  801719:	89 d8                	mov    %ebx,%eax
  80171b:	eb 02                	jmp    80171f <readn+0x43>
  80171d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80171f:	83 c4 1c             	add    $0x1c,%esp
  801722:	5b                   	pop    %ebx
  801723:	5e                   	pop    %esi
  801724:	5f                   	pop    %edi
  801725:	5d                   	pop    %ebp
  801726:	c3                   	ret    

00801727 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801727:	55                   	push   %ebp
  801728:	89 e5                	mov    %esp,%ebp
  80172a:	53                   	push   %ebx
  80172b:	83 ec 24             	sub    $0x24,%esp
  80172e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801731:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801734:	89 44 24 04          	mov    %eax,0x4(%esp)
  801738:	89 1c 24             	mov    %ebx,(%esp)
  80173b:	e8 76 fc ff ff       	call   8013b6 <fd_lookup>
  801740:	89 c2                	mov    %eax,%edx
  801742:	85 d2                	test   %edx,%edx
  801744:	78 68                	js     8017ae <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801746:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801749:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801750:	8b 00                	mov    (%eax),%eax
  801752:	89 04 24             	mov    %eax,(%esp)
  801755:	e8 b2 fc ff ff       	call   80140c <dev_lookup>
  80175a:	85 c0                	test   %eax,%eax
  80175c:	78 50                	js     8017ae <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80175e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801761:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801765:	75 23                	jne    80178a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801767:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80176c:	8b 40 48             	mov    0x48(%eax),%eax
  80176f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801773:	89 44 24 04          	mov    %eax,0x4(%esp)
  801777:	c7 04 24 f9 2f 80 00 	movl   $0x802ff9,(%esp)
  80177e:	e8 f2 ea ff ff       	call   800275 <cprintf>
		return -E_INVAL;
  801783:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801788:	eb 24                	jmp    8017ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	8b 52 0c             	mov    0xc(%edx),%edx
  801790:	85 d2                	test   %edx,%edx
  801792:	74 15                	je     8017a9 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801794:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801797:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80179b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8017a2:	89 04 24             	mov    %eax,(%esp)
  8017a5:	ff d2                	call   *%edx
  8017a7:	eb 05                	jmp    8017ae <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  8017a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  8017ae:	83 c4 24             	add    $0x24,%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    

008017b4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017ba:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	89 04 24             	mov    %eax,(%esp)
  8017c7:	e8 ea fb ff ff       	call   8013b6 <fd_lookup>
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	78 0e                	js     8017de <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	53                   	push   %ebx
  8017e4:	83 ec 24             	sub    $0x24,%esp
  8017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f1:	89 1c 24             	mov    %ebx,(%esp)
  8017f4:	e8 bd fb ff ff       	call   8013b6 <fd_lookup>
  8017f9:	89 c2                	mov    %eax,%edx
  8017fb:	85 d2                	test   %edx,%edx
  8017fd:	78 61                	js     801860 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801802:	89 44 24 04          	mov    %eax,0x4(%esp)
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	8b 00                	mov    (%eax),%eax
  80180b:	89 04 24             	mov    %eax,(%esp)
  80180e:	e8 f9 fb ff ff       	call   80140c <dev_lookup>
  801813:	85 c0                	test   %eax,%eax
  801815:	78 49                	js     801860 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80181a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80181e:	75 23                	jne    801843 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801820:	a1 0c 50 80 00       	mov    0x80500c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801825:	8b 40 48             	mov    0x48(%eax),%eax
  801828:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801830:	c7 04 24 bc 2f 80 00 	movl   $0x802fbc,(%esp)
  801837:	e8 39 ea ff ff       	call   800275 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80183c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801841:	eb 1d                	jmp    801860 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801843:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801846:	8b 52 18             	mov    0x18(%edx),%edx
  801849:	85 d2                	test   %edx,%edx
  80184b:	74 0e                	je     80185b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80184d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801850:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801854:	89 04 24             	mov    %eax,(%esp)
  801857:	ff d2                	call   *%edx
  801859:	eb 05                	jmp    801860 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80185b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801860:	83 c4 24             	add    $0x24,%esp
  801863:	5b                   	pop    %ebx
  801864:	5d                   	pop    %ebp
  801865:	c3                   	ret    

00801866 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801866:	55                   	push   %ebp
  801867:	89 e5                	mov    %esp,%ebp
  801869:	53                   	push   %ebx
  80186a:	83 ec 24             	sub    $0x24,%esp
  80186d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801870:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801873:	89 44 24 04          	mov    %eax,0x4(%esp)
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	89 04 24             	mov    %eax,(%esp)
  80187d:	e8 34 fb ff ff       	call   8013b6 <fd_lookup>
  801882:	89 c2                	mov    %eax,%edx
  801884:	85 d2                	test   %edx,%edx
  801886:	78 52                	js     8018da <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801888:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801892:	8b 00                	mov    (%eax),%eax
  801894:	89 04 24             	mov    %eax,(%esp)
  801897:	e8 70 fb ff ff       	call   80140c <dev_lookup>
  80189c:	85 c0                	test   %eax,%eax
  80189e:	78 3a                	js     8018da <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  8018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018a7:	74 2c                	je     8018d5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018a9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018ac:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018b3:	00 00 00 
	stat->st_isdir = 0;
  8018b6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018bd:	00 00 00 
	stat->st_dev = dev;
  8018c0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018c6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018cd:	89 14 24             	mov    %edx,(%esp)
  8018d0:	ff 50 14             	call   *0x14(%eax)
  8018d3:	eb 05                	jmp    8018da <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8018d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8018da:	83 c4 24             	add    $0x24,%esp
  8018dd:	5b                   	pop    %ebx
  8018de:	5d                   	pop    %ebp
  8018df:	c3                   	ret    

008018e0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
  8018e5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018ef:	00 
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	89 04 24             	mov    %eax,(%esp)
  8018f6:	e8 28 02 00 00       	call   801b23 <open>
  8018fb:	89 c3                	mov    %eax,%ebx
  8018fd:	85 db                	test   %ebx,%ebx
  8018ff:	78 1b                	js     80191c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801901:	8b 45 0c             	mov    0xc(%ebp),%eax
  801904:	89 44 24 04          	mov    %eax,0x4(%esp)
  801908:	89 1c 24             	mov    %ebx,(%esp)
  80190b:	e8 56 ff ff ff       	call   801866 <fstat>
  801910:	89 c6                	mov    %eax,%esi
	close(fd);
  801912:	89 1c 24             	mov    %ebx,(%esp)
  801915:	e8 cd fb ff ff       	call   8014e7 <close>
	return r;
  80191a:	89 f0                	mov    %esi,%eax
}
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	5b                   	pop    %ebx
  801920:	5e                   	pop    %esi
  801921:	5d                   	pop    %ebp
  801922:	c3                   	ret    

00801923 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
  801928:	83 ec 10             	sub    $0x10,%esp
  80192b:	89 c6                	mov    %eax,%esi
  80192d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80192f:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801936:	75 11                	jne    801949 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801938:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80193f:	e8 12 0e 00 00       	call   802756 <ipc_find_env>
  801944:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801949:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801950:	00 
  801951:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801958:	00 
  801959:	89 74 24 04          	mov    %esi,0x4(%esp)
  80195d:	a1 00 50 80 00       	mov    0x805000,%eax
  801962:	89 04 24             	mov    %eax,(%esp)
  801965:	e8 8e 0d 00 00       	call   8026f8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80196a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801971:	00 
  801972:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801976:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80197d:	e8 0c 0d 00 00       	call   80268e <ipc_recv>
}
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	5b                   	pop    %ebx
  801986:	5e                   	pop    %esi
  801987:	5d                   	pop    %ebp
  801988:	c3                   	ret    

00801989 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
  80198c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 40 0c             	mov    0xc(%eax),%eax
  801995:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  80199a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a7:	b8 02 00 00 00       	mov    $0x2,%eax
  8019ac:	e8 72 ff ff ff       	call   801923 <fsipc>
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
  8019b6:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8019bf:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8019c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c9:	b8 06 00 00 00       	mov    $0x6,%eax
  8019ce:	e8 50 ff ff ff       	call   801923 <fsipc>
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	53                   	push   %ebx
  8019d9:	83 ec 14             	sub    $0x14,%esp
  8019dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e5:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ef:	b8 05 00 00 00       	mov    $0x5,%eax
  8019f4:	e8 2a ff ff ff       	call   801923 <fsipc>
  8019f9:	89 c2                	mov    %eax,%edx
  8019fb:	85 d2                	test   %edx,%edx
  8019fd:	78 2b                	js     801a2a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019ff:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a06:	00 
  801a07:	89 1c 24             	mov    %ebx,(%esp)
  801a0a:	e8 88 ee ff ff       	call   800897 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a0f:	a1 80 60 80 00       	mov    0x806080,%eax
  801a14:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a1a:	a1 84 60 80 00       	mov    0x806084,%eax
  801a1f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a2a:	83 c4 14             	add    $0x14,%esp
  801a2d:	5b                   	pop    %ebx
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 18             	sub    $0x18,%esp
  801a36:	8b 45 10             	mov    0x10(%ebp),%eax
  801a39:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a3e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801a43:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801a46:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a4b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a4e:	8b 52 0c             	mov    0xc(%edx),%edx
  801a51:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801a57:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a62:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801a69:	e8 c6 ef ff ff       	call   800a34 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a73:	b8 04 00 00 00       	mov    $0x4,%eax
  801a78:	e8 a6 fe ff ff       	call   801923 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
  801a82:	56                   	push   %esi
  801a83:	53                   	push   %ebx
  801a84:	83 ec 10             	sub    $0x10,%esp
  801a87:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a90:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801a95:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801a9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa0:	b8 03 00 00 00       	mov    $0x3,%eax
  801aa5:	e8 79 fe ff ff       	call   801923 <fsipc>
  801aaa:	89 c3                	mov    %eax,%ebx
  801aac:	85 c0                	test   %eax,%eax
  801aae:	78 6a                	js     801b1a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801ab0:	39 c6                	cmp    %eax,%esi
  801ab2:	73 24                	jae    801ad8 <devfile_read+0x59>
  801ab4:	c7 44 24 0c 2c 30 80 	movl   $0x80302c,0xc(%esp)
  801abb:	00 
  801abc:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801ac3:	00 
  801ac4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801acb:	00 
  801acc:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801ad3:	e8 a4 e6 ff ff       	call   80017c <_panic>
	assert(r <= PGSIZE);
  801ad8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801add:	7e 24                	jle    801b03 <devfile_read+0x84>
  801adf:	c7 44 24 0c 53 30 80 	movl   $0x803053,0xc(%esp)
  801ae6:	00 
  801ae7:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801aee:	00 
  801aef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801af6:	00 
  801af7:	c7 04 24 48 30 80 00 	movl   $0x803048,(%esp)
  801afe:	e8 79 e6 ff ff       	call   80017c <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b07:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b0e:	00 
  801b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b12:	89 04 24             	mov    %eax,(%esp)
  801b15:	e8 1a ef ff ff       	call   800a34 <memmove>
	return r;
}
  801b1a:	89 d8                	mov    %ebx,%eax
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	5b                   	pop    %ebx
  801b20:	5e                   	pop    %esi
  801b21:	5d                   	pop    %ebp
  801b22:	c3                   	ret    

00801b23 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	53                   	push   %ebx
  801b27:	83 ec 24             	sub    $0x24,%esp
  801b2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801b2d:	89 1c 24             	mov    %ebx,(%esp)
  801b30:	e8 2b ed ff ff       	call   800860 <strlen>
  801b35:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b3a:	7f 60                	jg     801b9c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3f:	89 04 24             	mov    %eax,(%esp)
  801b42:	e8 20 f8 ff ff       	call   801367 <fd_alloc>
  801b47:	89 c2                	mov    %eax,%edx
  801b49:	85 d2                	test   %edx,%edx
  801b4b:	78 54                	js     801ba1 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801b4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b51:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801b58:	e8 3a ed ff ff       	call   800897 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b60:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b68:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6d:	e8 b1 fd ff ff       	call   801923 <fsipc>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	79 17                	jns    801b8f <open+0x6c>
		fd_close(fd, 0);
  801b78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b7f:	00 
  801b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b83:	89 04 24             	mov    %eax,(%esp)
  801b86:	e8 db f8 ff ff       	call   801466 <fd_close>
		return r;
  801b8b:	89 d8                	mov    %ebx,%eax
  801b8d:	eb 12                	jmp    801ba1 <open+0x7e>
	}

	return fd2num(fd);
  801b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b92:	89 04 24             	mov    %eax,(%esp)
  801b95:	e8 a6 f7 ff ff       	call   801340 <fd2num>
  801b9a:	eb 05                	jmp    801ba1 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801b9c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801ba1:	83 c4 24             	add    $0x24,%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5d                   	pop    %ebp
  801ba6:	c3                   	ret    

00801ba7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
  801baa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bad:	ba 00 00 00 00       	mov    $0x0,%edx
  801bb2:	b8 08 00 00 00       	mov    $0x8,%eax
  801bb7:	e8 67 fd ff ff       	call   801923 <fsipc>
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    
  801bbe:	66 90                	xchg   %ax,%ax

00801bc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
  801bc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801bc6:	c7 44 24 04 5f 30 80 	movl   $0x80305f,0x4(%esp)
  801bcd:	00 
  801bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd1:	89 04 24             	mov    %eax,(%esp)
  801bd4:	e8 be ec ff ff       	call   800897 <strcpy>
	return 0;
}
  801bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	53                   	push   %ebx
  801be4:	83 ec 14             	sub    $0x14,%esp
  801be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801bea:	89 1c 24             	mov    %ebx,(%esp)
  801bed:	e8 9c 0b 00 00       	call   80278e <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801bf2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801bf7:	83 f8 01             	cmp    $0x1,%eax
  801bfa:	75 0d                	jne    801c09 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801bfc:	8b 43 0c             	mov    0xc(%ebx),%eax
  801bff:	89 04 24             	mov    %eax,(%esp)
  801c02:	e8 29 03 00 00       	call   801f30 <nsipc_close>
  801c07:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801c09:	89 d0                	mov    %edx,%eax
  801c0b:	83 c4 14             	add    $0x14,%esp
  801c0e:	5b                   	pop    %ebx
  801c0f:	5d                   	pop    %ebp
  801c10:	c3                   	ret    

00801c11 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
  801c14:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c17:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c1e:	00 
  801c1f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	8b 40 0c             	mov    0xc(%eax),%eax
  801c33:	89 04 24             	mov    %eax,(%esp)
  801c36:	e8 f0 03 00 00       	call   80202b <nsipc_send>
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c43:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c4a:	00 
  801c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5f:	89 04 24             	mov    %eax,(%esp)
  801c62:	e8 44 03 00 00       	call   801fab <nsipc_recv>
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c6f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c72:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c76:	89 04 24             	mov    %eax,(%esp)
  801c79:	e8 38 f7 ff ff       	call   8013b6 <fd_lookup>
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 17                	js     801c99 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c85:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801c8b:	39 08                	cmp    %ecx,(%eax)
  801c8d:	75 05                	jne    801c94 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c8f:	8b 40 0c             	mov    0xc(%eax),%eax
  801c92:	eb 05                	jmp    801c99 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801c94:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801c99:	c9                   	leave  
  801c9a:	c3                   	ret    

00801c9b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 20             	sub    $0x20,%esp
  801ca3:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ca5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ca8:	89 04 24             	mov    %eax,(%esp)
  801cab:	e8 b7 f6 ff ff       	call   801367 <fd_alloc>
  801cb0:	89 c3                	mov    %eax,%ebx
  801cb2:	85 c0                	test   %eax,%eax
  801cb4:	78 21                	js     801cd7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801cb6:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801cbd:	00 
  801cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ccc:	e8 e2 ef ff ff       	call   800cb3 <sys_page_alloc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	79 0c                	jns    801ce3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801cd7:	89 34 24             	mov    %esi,(%esp)
  801cda:	e8 51 02 00 00       	call   801f30 <nsipc_close>
		return r;
  801cdf:	89 d8                	mov    %ebx,%eax
  801ce1:	eb 20                	jmp    801d03 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ce3:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cec:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801cf8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801cfb:	89 14 24             	mov    %edx,(%esp)
  801cfe:	e8 3d f6 ff ff       	call   801340 <fd2num>
}
  801d03:	83 c4 20             	add    $0x20,%esp
  801d06:	5b                   	pop    %ebx
  801d07:	5e                   	pop    %esi
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    

00801d0a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d10:	8b 45 08             	mov    0x8(%ebp),%eax
  801d13:	e8 51 ff ff ff       	call   801c69 <fd2sockid>
		return r;
  801d18:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d1a:	85 c0                	test   %eax,%eax
  801d1c:	78 23                	js     801d41 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d1e:	8b 55 10             	mov    0x10(%ebp),%edx
  801d21:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d25:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d28:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d2c:	89 04 24             	mov    %eax,(%esp)
  801d2f:	e8 45 01 00 00       	call   801e79 <nsipc_accept>
		return r;
  801d34:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d36:	85 c0                	test   %eax,%eax
  801d38:	78 07                	js     801d41 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801d3a:	e8 5c ff ff ff       	call   801c9b <alloc_sockfd>
  801d3f:	89 c1                	mov    %eax,%ecx
}
  801d41:	89 c8                	mov    %ecx,%eax
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4e:	e8 16 ff ff ff       	call   801c69 <fd2sockid>
  801d53:	89 c2                	mov    %eax,%edx
  801d55:	85 d2                	test   %edx,%edx
  801d57:	78 16                	js     801d6f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801d59:	8b 45 10             	mov    0x10(%ebp),%eax
  801d5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d67:	89 14 24             	mov    %edx,(%esp)
  801d6a:	e8 60 01 00 00       	call   801ecf <nsipc_bind>
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <shutdown>:

int
shutdown(int s, int how)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d77:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7a:	e8 ea fe ff ff       	call   801c69 <fd2sockid>
  801d7f:	89 c2                	mov    %eax,%edx
  801d81:	85 d2                	test   %edx,%edx
  801d83:	78 0f                	js     801d94 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d8c:	89 14 24             	mov    %edx,(%esp)
  801d8f:	e8 7a 01 00 00       	call   801f0e <nsipc_shutdown>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d9f:	e8 c5 fe ff ff       	call   801c69 <fd2sockid>
  801da4:	89 c2                	mov    %eax,%edx
  801da6:	85 d2                	test   %edx,%edx
  801da8:	78 16                	js     801dc0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801daa:	8b 45 10             	mov    0x10(%ebp),%eax
  801dad:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db8:	89 14 24             	mov    %edx,(%esp)
  801dbb:	e8 8a 01 00 00       	call   801f4a <nsipc_connect>
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <listen>:

int
listen(int s, int backlog)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	e8 99 fe ff ff       	call   801c69 <fd2sockid>
  801dd0:	89 c2                	mov    %eax,%edx
  801dd2:	85 d2                	test   %edx,%edx
  801dd4:	78 0f                	js     801de5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddd:	89 14 24             	mov    %edx,(%esp)
  801de0:	e8 a4 01 00 00       	call   801f89 <nsipc_listen>
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 98 02 00 00       	call   80209e <nsipc_socket>
  801e06:	89 c2                	mov    %eax,%edx
  801e08:	85 d2                	test   %edx,%edx
  801e0a:	78 05                	js     801e11 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801e0c:	e8 8a fe ff ff       	call   801c9b <alloc_sockfd>
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	53                   	push   %ebx
  801e17:	83 ec 14             	sub    $0x14,%esp
  801e1a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801e1c:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801e23:	75 11                	jne    801e36 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801e25:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801e2c:	e8 25 09 00 00       	call   802756 <ipc_find_env>
  801e31:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e36:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e3d:	00 
  801e3e:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801e45:	00 
  801e46:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e4a:	a1 04 50 80 00       	mov    0x805004,%eax
  801e4f:	89 04 24             	mov    %eax,(%esp)
  801e52:	e8 a1 08 00 00       	call   8026f8 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e5e:	00 
  801e5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e66:	00 
  801e67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e6e:	e8 1b 08 00 00       	call   80268e <ipc_recv>
}
  801e73:	83 c4 14             	add    $0x14,%esp
  801e76:	5b                   	pop    %ebx
  801e77:	5d                   	pop    %ebp
  801e78:	c3                   	ret    

00801e79 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
  801e7c:	56                   	push   %esi
  801e7d:	53                   	push   %ebx
  801e7e:	83 ec 10             	sub    $0x10,%esp
  801e81:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801e84:	8b 45 08             	mov    0x8(%ebp),%eax
  801e87:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801e8c:	8b 06                	mov    (%esi),%eax
  801e8e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e93:	b8 01 00 00 00       	mov    $0x1,%eax
  801e98:	e8 76 ff ff ff       	call   801e13 <nsipc>
  801e9d:	89 c3                	mov    %eax,%ebx
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 23                	js     801ec6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ea3:	a1 10 70 80 00       	mov    0x807010,%eax
  801ea8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801eac:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801eb3:	00 
  801eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eb7:	89 04 24             	mov    %eax,(%esp)
  801eba:	e8 75 eb ff ff       	call   800a34 <memmove>
		*addrlen = ret->ret_addrlen;
  801ebf:	a1 10 70 80 00       	mov    0x807010,%eax
  801ec4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801ec6:	89 d8                	mov    %ebx,%eax
  801ec8:	83 c4 10             	add    $0x10,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5d                   	pop    %ebp
  801ece:	c3                   	ret    

00801ecf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	53                   	push   %ebx
  801ed3:	83 ec 14             	sub    $0x14,%esp
  801ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  801edc:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ee1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eec:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801ef3:	e8 3c eb ff ff       	call   800a34 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ef8:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801efe:	b8 02 00 00 00       	mov    $0x2,%eax
  801f03:	e8 0b ff ff ff       	call   801e13 <nsipc>
}
  801f08:	83 c4 14             	add    $0x14,%esp
  801f0b:	5b                   	pop    %ebx
  801f0c:	5d                   	pop    %ebp
  801f0d:	c3                   	ret    

00801f0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f14:	8b 45 08             	mov    0x8(%ebp),%eax
  801f17:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801f1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f1f:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801f24:	b8 03 00 00 00       	mov    $0x3,%eax
  801f29:	e8 e5 fe ff ff       	call   801e13 <nsipc>
}
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <nsipc_close>:

int
nsipc_close(int s)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801f3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801f43:	e8 cb fe ff ff       	call   801e13 <nsipc>
}
  801f48:	c9                   	leave  
  801f49:	c3                   	ret    

00801f4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	53                   	push   %ebx
  801f4e:	83 ec 14             	sub    $0x14,%esp
  801f51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f60:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f63:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f67:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801f6e:	e8 c1 ea ff ff       	call   800a34 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f73:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  801f79:	b8 05 00 00 00       	mov    $0x5,%eax
  801f7e:	e8 90 fe ff ff       	call   801e13 <nsipc>
}
  801f83:	83 c4 14             	add    $0x14,%esp
  801f86:	5b                   	pop    %ebx
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    

00801f89 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f92:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  801f97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f9a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  801f9f:	b8 06 00 00 00       	mov    $0x6,%eax
  801fa4:	e8 6a fe ff ff       	call   801e13 <nsipc>
}
  801fa9:	c9                   	leave  
  801faa:	c3                   	ret    

00801fab <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	56                   	push   %esi
  801faf:	53                   	push   %ebx
  801fb0:	83 ec 10             	sub    $0x10,%esp
  801fb3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  801fbe:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  801fc4:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc7:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801fcc:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd1:	e8 3d fe ff ff       	call   801e13 <nsipc>
  801fd6:	89 c3                	mov    %eax,%ebx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	78 46                	js     802022 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801fdc:	39 f0                	cmp    %esi,%eax
  801fde:	7f 07                	jg     801fe7 <nsipc_recv+0x3c>
  801fe0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801fe5:	7e 24                	jle    80200b <nsipc_recv+0x60>
  801fe7:	c7 44 24 0c 6b 30 80 	movl   $0x80306b,0xc(%esp)
  801fee:	00 
  801fef:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  801ff6:	00 
  801ff7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801ffe:	00 
  801fff:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  802006:	e8 71 e1 ff ff       	call   80017c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  80200b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80200f:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  802016:	00 
  802017:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201a:	89 04 24             	mov    %eax,(%esp)
  80201d:	e8 12 ea ff ff       	call   800a34 <memmove>
	}

	return r;
}
  802022:	89 d8                	mov    %ebx,%eax
  802024:	83 c4 10             	add    $0x10,%esp
  802027:	5b                   	pop    %ebx
  802028:	5e                   	pop    %esi
  802029:	5d                   	pop    %ebp
  80202a:	c3                   	ret    

0080202b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
  80202e:	53                   	push   %ebx
  80202f:	83 ec 14             	sub    $0x14,%esp
  802032:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  80203d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802043:	7e 24                	jle    802069 <nsipc_send+0x3e>
  802045:	c7 44 24 0c 8c 30 80 	movl   $0x80308c,0xc(%esp)
  80204c:	00 
  80204d:	c7 44 24 08 33 30 80 	movl   $0x803033,0x8(%esp)
  802054:	00 
  802055:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  80205c:	00 
  80205d:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  802064:	e8 13 e1 ff ff       	call   80017c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802069:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80206d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802070:	89 44 24 04          	mov    %eax,0x4(%esp)
  802074:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80207b:	e8 b4 e9 ff ff       	call   800a34 <memmove>
	nsipcbuf.send.req_size = size;
  802080:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802086:	8b 45 14             	mov    0x14(%ebp),%eax
  802089:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80208e:	b8 08 00 00 00       	mov    $0x8,%eax
  802093:	e8 7b fd ff ff       	call   801e13 <nsipc>
}
  802098:	83 c4 14             	add    $0x14,%esp
  80209b:	5b                   	pop    %ebx
  80209c:	5d                   	pop    %ebp
  80209d:	c3                   	ret    

0080209e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80209e:	55                   	push   %ebp
  80209f:	89 e5                	mov    %esp,%ebp
  8020a1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8020ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020af:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8020bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8020c1:	e8 4d fd ff ff       	call   801e13 <nsipc>
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	83 ec 10             	sub    $0x10,%esp
  8020d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d6:	89 04 24             	mov    %eax,(%esp)
  8020d9:	e8 72 f2 ff ff       	call   801350 <fd2data>
  8020de:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8020e0:	c7 44 24 04 98 30 80 	movl   $0x803098,0x4(%esp)
  8020e7:	00 
  8020e8:	89 1c 24             	mov    %ebx,(%esp)
  8020eb:	e8 a7 e7 ff ff       	call   800897 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020f0:	8b 46 04             	mov    0x4(%esi),%eax
  8020f3:	2b 06                	sub    (%esi),%eax
  8020f5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  8020fb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802102:	00 00 00 
	stat->st_dev = &devpipe;
  802105:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  80210c:	40 80 00 
	return 0;
}
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	83 c4 10             	add    $0x10,%esp
  802117:	5b                   	pop    %ebx
  802118:	5e                   	pop    %esi
  802119:	5d                   	pop    %ebp
  80211a:	c3                   	ret    

0080211b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80211b:	55                   	push   %ebp
  80211c:	89 e5                	mov    %esp,%ebp
  80211e:	53                   	push   %ebx
  80211f:	83 ec 14             	sub    $0x14,%esp
  802122:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802125:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802129:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802130:	e8 25 ec ff ff       	call   800d5a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802135:	89 1c 24             	mov    %ebx,(%esp)
  802138:	e8 13 f2 ff ff       	call   801350 <fd2data>
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802148:	e8 0d ec ff ff       	call   800d5a <sys_page_unmap>
}
  80214d:	83 c4 14             	add    $0x14,%esp
  802150:	5b                   	pop    %ebx
  802151:	5d                   	pop    %ebp
  802152:	c3                   	ret    

00802153 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
  802156:	57                   	push   %edi
  802157:	56                   	push   %esi
  802158:	53                   	push   %ebx
  802159:	83 ec 2c             	sub    $0x2c,%esp
  80215c:	89 c6                	mov    %eax,%esi
  80215e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802161:	a1 0c 50 80 00       	mov    0x80500c,%eax
  802166:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802169:	89 34 24             	mov    %esi,(%esp)
  80216c:	e8 1d 06 00 00       	call   80278e <pageref>
  802171:	89 c7                	mov    %eax,%edi
  802173:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802176:	89 04 24             	mov    %eax,(%esp)
  802179:	e8 10 06 00 00       	call   80278e <pageref>
  80217e:	39 c7                	cmp    %eax,%edi
  802180:	0f 94 c2             	sete   %dl
  802183:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802186:	8b 0d 0c 50 80 00    	mov    0x80500c,%ecx
  80218c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80218f:	39 fb                	cmp    %edi,%ebx
  802191:	74 21                	je     8021b4 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802193:	84 d2                	test   %dl,%dl
  802195:	74 ca                	je     802161 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802197:	8b 51 58             	mov    0x58(%ecx),%edx
  80219a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80219e:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021a6:	c7 04 24 9f 30 80 00 	movl   $0x80309f,(%esp)
  8021ad:	e8 c3 e0 ff ff       	call   800275 <cprintf>
  8021b2:	eb ad                	jmp    802161 <_pipeisclosed+0xe>
	}
}
  8021b4:	83 c4 2c             	add    $0x2c,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5f                   	pop    %edi
  8021ba:	5d                   	pop    %ebp
  8021bb:	c3                   	ret    

008021bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	57                   	push   %edi
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 1c             	sub    $0x1c,%esp
  8021c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8021c8:	89 34 24             	mov    %esi,(%esp)
  8021cb:	e8 80 f1 ff ff       	call   801350 <fd2data>
  8021d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d7:	eb 45                	jmp    80221e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021d9:	89 da                	mov    %ebx,%edx
  8021db:	89 f0                	mov    %esi,%eax
  8021dd:	e8 71 ff ff ff       	call   802153 <_pipeisclosed>
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	75 41                	jne    802227 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8021e6:	e8 a9 ea ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021eb:	8b 43 04             	mov    0x4(%ebx),%eax
  8021ee:	8b 0b                	mov    (%ebx),%ecx
  8021f0:	8d 51 20             	lea    0x20(%ecx),%edx
  8021f3:	39 d0                	cmp    %edx,%eax
  8021f5:	73 e2                	jae    8021d9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8021f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8021fa:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  8021fe:	88 4d e7             	mov    %cl,-0x19(%ebp)
  802201:	99                   	cltd   
  802202:	c1 ea 1b             	shr    $0x1b,%edx
  802205:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  802208:	83 e1 1f             	and    $0x1f,%ecx
  80220b:	29 d1                	sub    %edx,%ecx
  80220d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  802211:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  802215:	83 c0 01             	add    $0x1,%eax
  802218:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80221b:	83 c7 01             	add    $0x1,%edi
  80221e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802221:	75 c8                	jne    8021eb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  802223:	89 f8                	mov    %edi,%eax
  802225:	eb 05                	jmp    80222c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802227:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  80222c:	83 c4 1c             	add    $0x1c,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5e                   	pop    %esi
  802231:	5f                   	pop    %edi
  802232:	5d                   	pop    %ebp
  802233:	c3                   	ret    

00802234 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	57                   	push   %edi
  802238:	56                   	push   %esi
  802239:	53                   	push   %ebx
  80223a:	83 ec 1c             	sub    $0x1c,%esp
  80223d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802240:	89 3c 24             	mov    %edi,(%esp)
  802243:	e8 08 f1 ff ff       	call   801350 <fd2data>
  802248:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80224a:	be 00 00 00 00       	mov    $0x0,%esi
  80224f:	eb 3d                	jmp    80228e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802251:	85 f6                	test   %esi,%esi
  802253:	74 04                	je     802259 <devpipe_read+0x25>
				return i;
  802255:	89 f0                	mov    %esi,%eax
  802257:	eb 43                	jmp    80229c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802259:	89 da                	mov    %ebx,%edx
  80225b:	89 f8                	mov    %edi,%eax
  80225d:	e8 f1 fe ff ff       	call   802153 <_pipeisclosed>
  802262:	85 c0                	test   %eax,%eax
  802264:	75 31                	jne    802297 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802266:	e8 29 ea ff ff       	call   800c94 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80226b:	8b 03                	mov    (%ebx),%eax
  80226d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802270:	74 df                	je     802251 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802272:	99                   	cltd   
  802273:	c1 ea 1b             	shr    $0x1b,%edx
  802276:	01 d0                	add    %edx,%eax
  802278:	83 e0 1f             	and    $0x1f,%eax
  80227b:	29 d0                	sub    %edx,%eax
  80227d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802285:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802288:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80228b:	83 c6 01             	add    $0x1,%esi
  80228e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802291:	75 d8                	jne    80226b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802293:	89 f0                	mov    %esi,%eax
  802295:	eb 05                	jmp    80229c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802297:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80229c:	83 c4 1c             	add    $0x1c,%esp
  80229f:	5b                   	pop    %ebx
  8022a0:	5e                   	pop    %esi
  8022a1:	5f                   	pop    %edi
  8022a2:	5d                   	pop    %ebp
  8022a3:	c3                   	ret    

008022a4 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	56                   	push   %esi
  8022a8:	53                   	push   %ebx
  8022a9:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022af:	89 04 24             	mov    %eax,(%esp)
  8022b2:	e8 b0 f0 ff ff       	call   801367 <fd_alloc>
  8022b7:	89 c2                	mov    %eax,%edx
  8022b9:	85 d2                	test   %edx,%edx
  8022bb:	0f 88 4d 01 00 00    	js     80240e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022c1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022c8:	00 
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022d7:	e8 d7 e9 ff ff       	call   800cb3 <sys_page_alloc>
  8022dc:	89 c2                	mov    %eax,%edx
  8022de:	85 d2                	test   %edx,%edx
  8022e0:	0f 88 28 01 00 00    	js     80240e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022e6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022e9:	89 04 24             	mov    %eax,(%esp)
  8022ec:	e8 76 f0 ff ff       	call   801367 <fd_alloc>
  8022f1:	89 c3                	mov    %eax,%ebx
  8022f3:	85 c0                	test   %eax,%eax
  8022f5:	0f 88 fe 00 00 00    	js     8023f9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022fb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802302:	00 
  802303:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802306:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802311:	e8 9d e9 ff ff       	call   800cb3 <sys_page_alloc>
  802316:	89 c3                	mov    %eax,%ebx
  802318:	85 c0                	test   %eax,%eax
  80231a:	0f 88 d9 00 00 00    	js     8023f9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	89 04 24             	mov    %eax,(%esp)
  802326:	e8 25 f0 ff ff       	call   801350 <fd2data>
  80232b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80232d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802334:	00 
  802335:	89 44 24 04          	mov    %eax,0x4(%esp)
  802339:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802340:	e8 6e e9 ff ff       	call   800cb3 <sys_page_alloc>
  802345:	89 c3                	mov    %eax,%ebx
  802347:	85 c0                	test   %eax,%eax
  802349:	0f 88 97 00 00 00    	js     8023e6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80234f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802352:	89 04 24             	mov    %eax,(%esp)
  802355:	e8 f6 ef ff ff       	call   801350 <fd2data>
  80235a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802361:	00 
  802362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802366:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80236d:	00 
  80236e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802379:	e8 89 e9 ff ff       	call   800d07 <sys_page_map>
  80237e:	89 c3                	mov    %eax,%ebx
  802380:	85 c0                	test   %eax,%eax
  802382:	78 52                	js     8023d6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802384:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80238f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802392:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802399:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80239f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a2:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8023a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 87 ef ff ff       	call   801340 <fd2num>
  8023b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023bc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8023be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023c1:	89 04 24             	mov    %eax,(%esp)
  8023c4:	e8 77 ef ff ff       	call   801340 <fd2num>
  8023c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8023cc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8023cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d4:	eb 38                	jmp    80240e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  8023d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e1:	e8 74 e9 ff ff       	call   800d5a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f4:	e8 61 e9 ff ff       	call   800d5a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  802400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802407:	e8 4e e9 ff ff       	call   800d5a <sys_page_unmap>
  80240c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80240e:	83 c4 30             	add    $0x30,%esp
  802411:	5b                   	pop    %ebx
  802412:	5e                   	pop    %esi
  802413:	5d                   	pop    %ebp
  802414:	c3                   	ret    

00802415 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802415:	55                   	push   %ebp
  802416:	89 e5                	mov    %esp,%ebp
  802418:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80241b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80241e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	89 04 24             	mov    %eax,(%esp)
  802428:	e8 89 ef ff ff       	call   8013b6 <fd_lookup>
  80242d:	89 c2                	mov    %eax,%edx
  80242f:	85 d2                	test   %edx,%edx
  802431:	78 15                	js     802448 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	89 04 24             	mov    %eax,(%esp)
  802439:	e8 12 ef ff ff       	call   801350 <fd2data>
	return _pipeisclosed(fd, p);
  80243e:	89 c2                	mov    %eax,%edx
  802440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802443:	e8 0b fd ff ff       	call   802153 <_pipeisclosed>
}
  802448:	c9                   	leave  
  802449:	c3                   	ret    
  80244a:	66 90                	xchg   %ax,%ax
  80244c:	66 90                	xchg   %ax,%ax
  80244e:	66 90                	xchg   %ax,%ax

00802450 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802453:	b8 00 00 00 00       	mov    $0x0,%eax
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802460:	c7 44 24 04 b7 30 80 	movl   $0x8030b7,0x4(%esp)
  802467:	00 
  802468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80246b:	89 04 24             	mov    %eax,(%esp)
  80246e:	e8 24 e4 ff ff       	call   800897 <strcpy>
	return 0;
}
  802473:	b8 00 00 00 00       	mov    $0x0,%eax
  802478:	c9                   	leave  
  802479:	c3                   	ret    

0080247a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	57                   	push   %edi
  80247e:	56                   	push   %esi
  80247f:	53                   	push   %ebx
  802480:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802486:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80248b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802491:	eb 31                	jmp    8024c4 <devcons_write+0x4a>
		m = n - tot;
  802493:	8b 75 10             	mov    0x10(%ebp),%esi
  802496:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802498:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80249b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  8024a0:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024a3:	89 74 24 08          	mov    %esi,0x8(%esp)
  8024a7:	03 45 0c             	add    0xc(%ebp),%eax
  8024aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ae:	89 3c 24             	mov    %edi,(%esp)
  8024b1:	e8 7e e5 ff ff       	call   800a34 <memmove>
		sys_cputs(buf, m);
  8024b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024ba:	89 3c 24             	mov    %edi,(%esp)
  8024bd:	e8 24 e7 ff ff       	call   800be6 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024c2:	01 f3                	add    %esi,%ebx
  8024c4:	89 d8                	mov    %ebx,%eax
  8024c6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8024c9:	72 c8                	jb     802493 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8024cb:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
  8024d9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8024dc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8024e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024e5:	75 07                	jne    8024ee <devcons_read+0x18>
  8024e7:	eb 2a                	jmp    802513 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024e9:	e8 a6 e7 ff ff       	call   800c94 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024ee:	66 90                	xchg   %ax,%ax
  8024f0:	e8 0f e7 ff ff       	call   800c04 <sys_cgetc>
  8024f5:	85 c0                	test   %eax,%eax
  8024f7:	74 f0                	je     8024e9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	78 16                	js     802513 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024fd:	83 f8 04             	cmp    $0x4,%eax
  802500:	74 0c                	je     80250e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802502:	8b 55 0c             	mov    0xc(%ebp),%edx
  802505:	88 02                	mov    %al,(%edx)
	return 1;
  802507:	b8 01 00 00 00       	mov    $0x1,%eax
  80250c:	eb 05                	jmp    802513 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80250e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802513:	c9                   	leave  
  802514:	c3                   	ret    

00802515 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802515:	55                   	push   %ebp
  802516:	89 e5                	mov    %esp,%ebp
  802518:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80251b:	8b 45 08             	mov    0x8(%ebp),%eax
  80251e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802521:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802528:	00 
  802529:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80252c:	89 04 24             	mov    %eax,(%esp)
  80252f:	e8 b2 e6 ff ff       	call   800be6 <sys_cputs>
}
  802534:	c9                   	leave  
  802535:	c3                   	ret    

00802536 <getchar>:

int
getchar(void)
{
  802536:	55                   	push   %ebp
  802537:	89 e5                	mov    %esp,%ebp
  802539:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80253c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802543:	00 
  802544:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802547:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802552:	e8 f3 f0 ff ff       	call   80164a <read>
	if (r < 0)
  802557:	85 c0                	test   %eax,%eax
  802559:	78 0f                	js     80256a <getchar+0x34>
		return r;
	if (r < 1)
  80255b:	85 c0                	test   %eax,%eax
  80255d:	7e 06                	jle    802565 <getchar+0x2f>
		return -E_EOF;
	return c;
  80255f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802563:	eb 05                	jmp    80256a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802565:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802572:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802575:	89 44 24 04          	mov    %eax,0x4(%esp)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	89 04 24             	mov    %eax,(%esp)
  80257f:	e8 32 ee ff ff       	call   8013b6 <fd_lookup>
  802584:	85 c0                	test   %eax,%eax
  802586:	78 11                	js     802599 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802591:	39 10                	cmp    %edx,(%eax)
  802593:	0f 94 c0             	sete   %al
  802596:	0f b6 c0             	movzbl %al,%eax
}
  802599:	c9                   	leave  
  80259a:	c3                   	ret    

0080259b <opencons>:

int
opencons(void)
{
  80259b:	55                   	push   %ebp
  80259c:	89 e5                	mov    %esp,%ebp
  80259e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025a4:	89 04 24             	mov    %eax,(%esp)
  8025a7:	e8 bb ed ff ff       	call   801367 <fd_alloc>
		return r;
  8025ac:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 40                	js     8025f2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025b2:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025b9:	00 
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025c8:	e8 e6 e6 ff ff       	call   800cb3 <sys_page_alloc>
		return r;
  8025cd:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 1f                	js     8025f2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025d3:	8b 15 58 40 80 00    	mov    0x804058,%edx
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025e8:	89 04 24             	mov    %eax,(%esp)
  8025eb:	e8 50 ed ff ff       	call   801340 <fd2num>
  8025f0:	89 c2                	mov    %eax,%edx
}
  8025f2:	89 d0                	mov    %edx,%eax
  8025f4:	c9                   	leave  
  8025f5:	c3                   	ret    

008025f6 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025f6:	55                   	push   %ebp
  8025f7:	89 e5                	mov    %esp,%ebp
  8025f9:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025fc:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  802603:	75 58                	jne    80265d <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  802605:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80260a:	8b 40 48             	mov    0x48(%eax),%eax
  80260d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802614:	00 
  802615:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80261c:	ee 
  80261d:	89 04 24             	mov    %eax,(%esp)
  802620:	e8 8e e6 ff ff       	call   800cb3 <sys_page_alloc>
		if(return_code!=0)
  802625:	85 c0                	test   %eax,%eax
  802627:	74 1c                	je     802645 <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  802629:	c7 44 24 08 c4 30 80 	movl   $0x8030c4,0x8(%esp)
  802630:	00 
  802631:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802638:	00 
  802639:	c7 04 24 20 31 80 00 	movl   $0x803120,(%esp)
  802640:	e8 37 db ff ff       	call   80017c <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  802645:	a1 0c 50 80 00       	mov    0x80500c,%eax
  80264a:	8b 40 48             	mov    0x48(%eax),%eax
  80264d:	c7 44 24 04 67 26 80 	movl   $0x802667,0x4(%esp)
  802654:	00 
  802655:	89 04 24             	mov    %eax,(%esp)
  802658:	e8 f6 e7 ff ff       	call   800e53 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	a3 00 80 80 00       	mov    %eax,0x808000
}
  802665:	c9                   	leave  
  802666:	c3                   	ret    

00802667 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802667:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802668:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  80266d:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80266f:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802672:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  802674:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  802678:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  80267c:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  80267d:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  80267f:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802681:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  802685:	58                   	pop    %eax
	popl %eax;
  802686:	58                   	pop    %eax
	popal;
  802687:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  802688:	83 c4 04             	add    $0x4,%esp
	popfl;
  80268b:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  80268c:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  80268d:	c3                   	ret    

0080268e <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	56                   	push   %esi
  802692:	53                   	push   %ebx
  802693:	83 ec 10             	sub    $0x10,%esp
  802696:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80269c:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80269f:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8026a1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8026a6:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8026a9:	89 04 24             	mov    %eax,(%esp)
  8026ac:	e8 18 e8 ff ff       	call   800ec9 <sys_ipc_recv>
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	75 1e                	jne    8026d3 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8026b5:	85 db                	test   %ebx,%ebx
  8026b7:	74 0a                	je     8026c3 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8026b9:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8026be:	8b 40 74             	mov    0x74(%eax),%eax
  8026c1:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8026c3:	85 f6                	test   %esi,%esi
  8026c5:	74 22                	je     8026e9 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8026c7:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8026cc:	8b 40 78             	mov    0x78(%eax),%eax
  8026cf:	89 06                	mov    %eax,(%esi)
  8026d1:	eb 16                	jmp    8026e9 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  8026d3:	85 f6                	test   %esi,%esi
  8026d5:	74 06                	je     8026dd <ipc_recv+0x4f>
				*perm_store = 0;
  8026d7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  8026dd:	85 db                	test   %ebx,%ebx
  8026df:	74 10                	je     8026f1 <ipc_recv+0x63>
				*from_env_store=0;
  8026e1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8026e7:	eb 08                	jmp    8026f1 <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  8026e9:	a1 0c 50 80 00       	mov    0x80500c,%eax
  8026ee:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	5b                   	pop    %ebx
  8026f5:	5e                   	pop    %esi
  8026f6:	5d                   	pop    %ebp
  8026f7:	c3                   	ret    

008026f8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026f8:	55                   	push   %ebp
  8026f9:	89 e5                	mov    %esp,%ebp
  8026fb:	57                   	push   %edi
  8026fc:	56                   	push   %esi
  8026fd:	53                   	push   %ebx
  8026fe:	83 ec 1c             	sub    $0x1c,%esp
  802701:	8b 75 0c             	mov    0xc(%ebp),%esi
  802704:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802707:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  80270a:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80270c:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  802711:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802714:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802718:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80271c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802720:	8b 45 08             	mov    0x8(%ebp),%eax
  802723:	89 04 24             	mov    %eax,(%esp)
  802726:	e8 7b e7 ff ff       	call   800ea6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  80272b:	eb 1c                	jmp    802749 <ipc_send+0x51>
	{
		sys_yield();
  80272d:	e8 62 e5 ff ff       	call   800c94 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802732:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802736:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80273a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80273e:	8b 45 08             	mov    0x8(%ebp),%eax
  802741:	89 04 24             	mov    %eax,(%esp)
  802744:	e8 5d e7 ff ff       	call   800ea6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802749:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80274c:	74 df                	je     80272d <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80274e:	83 c4 1c             	add    $0x1c,%esp
  802751:	5b                   	pop    %ebx
  802752:	5e                   	pop    %esi
  802753:	5f                   	pop    %edi
  802754:	5d                   	pop    %ebp
  802755:	c3                   	ret    

00802756 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802756:	55                   	push   %ebp
  802757:	89 e5                	mov    %esp,%ebp
  802759:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802761:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802764:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80276a:	8b 52 50             	mov    0x50(%edx),%edx
  80276d:	39 ca                	cmp    %ecx,%edx
  80276f:	75 0d                	jne    80277e <ipc_find_env+0x28>
			return envs[i].env_id;
  802771:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802774:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802779:	8b 40 40             	mov    0x40(%eax),%eax
  80277c:	eb 0e                	jmp    80278c <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80277e:	83 c0 01             	add    $0x1,%eax
  802781:	3d 00 04 00 00       	cmp    $0x400,%eax
  802786:	75 d9                	jne    802761 <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802788:	66 b8 00 00          	mov    $0x0,%ax
}
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    

0080278e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802794:	89 d0                	mov    %edx,%eax
  802796:	c1 e8 16             	shr    $0x16,%eax
  802799:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8027a0:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8027a5:	f6 c1 01             	test   $0x1,%cl
  8027a8:	74 1d                	je     8027c7 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027aa:	c1 ea 0c             	shr    $0xc,%edx
  8027ad:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027b4:	f6 c2 01             	test   $0x1,%dl
  8027b7:	74 0e                	je     8027c7 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027b9:	c1 ea 0c             	shr    $0xc,%edx
  8027bc:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027c3:	ef 
  8027c4:	0f b7 c0             	movzwl %ax,%eax
}
  8027c7:	5d                   	pop    %ebp
  8027c8:	c3                   	ret    
  8027c9:	66 90                	xchg   %ax,%ax
  8027cb:	66 90                	xchg   %ax,%ax
  8027cd:	66 90                	xchg   %ax,%ax
  8027cf:	90                   	nop

008027d0 <__udivdi3>:
  8027d0:	55                   	push   %ebp
  8027d1:	57                   	push   %edi
  8027d2:	56                   	push   %esi
  8027d3:	83 ec 0c             	sub    $0xc,%esp
  8027d6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027da:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8027de:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027e2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027e6:	85 c0                	test   %eax,%eax
  8027e8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027ec:	89 ea                	mov    %ebp,%edx
  8027ee:	89 0c 24             	mov    %ecx,(%esp)
  8027f1:	75 2d                	jne    802820 <__udivdi3+0x50>
  8027f3:	39 e9                	cmp    %ebp,%ecx
  8027f5:	77 61                	ja     802858 <__udivdi3+0x88>
  8027f7:	85 c9                	test   %ecx,%ecx
  8027f9:	89 ce                	mov    %ecx,%esi
  8027fb:	75 0b                	jne    802808 <__udivdi3+0x38>
  8027fd:	b8 01 00 00 00       	mov    $0x1,%eax
  802802:	31 d2                	xor    %edx,%edx
  802804:	f7 f1                	div    %ecx
  802806:	89 c6                	mov    %eax,%esi
  802808:	31 d2                	xor    %edx,%edx
  80280a:	89 e8                	mov    %ebp,%eax
  80280c:	f7 f6                	div    %esi
  80280e:	89 c5                	mov    %eax,%ebp
  802810:	89 f8                	mov    %edi,%eax
  802812:	f7 f6                	div    %esi
  802814:	89 ea                	mov    %ebp,%edx
  802816:	83 c4 0c             	add    $0xc,%esp
  802819:	5e                   	pop    %esi
  80281a:	5f                   	pop    %edi
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    
  80281d:	8d 76 00             	lea    0x0(%esi),%esi
  802820:	39 e8                	cmp    %ebp,%eax
  802822:	77 24                	ja     802848 <__udivdi3+0x78>
  802824:	0f bd e8             	bsr    %eax,%ebp
  802827:	83 f5 1f             	xor    $0x1f,%ebp
  80282a:	75 3c                	jne    802868 <__udivdi3+0x98>
  80282c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802830:	39 34 24             	cmp    %esi,(%esp)
  802833:	0f 86 9f 00 00 00    	jbe    8028d8 <__udivdi3+0x108>
  802839:	39 d0                	cmp    %edx,%eax
  80283b:	0f 82 97 00 00 00    	jb     8028d8 <__udivdi3+0x108>
  802841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802848:	31 d2                	xor    %edx,%edx
  80284a:	31 c0                	xor    %eax,%eax
  80284c:	83 c4 0c             	add    $0xc,%esp
  80284f:	5e                   	pop    %esi
  802850:	5f                   	pop    %edi
  802851:	5d                   	pop    %ebp
  802852:	c3                   	ret    
  802853:	90                   	nop
  802854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802858:	89 f8                	mov    %edi,%eax
  80285a:	f7 f1                	div    %ecx
  80285c:	31 d2                	xor    %edx,%edx
  80285e:	83 c4 0c             	add    $0xc,%esp
  802861:	5e                   	pop    %esi
  802862:	5f                   	pop    %edi
  802863:	5d                   	pop    %ebp
  802864:	c3                   	ret    
  802865:	8d 76 00             	lea    0x0(%esi),%esi
  802868:	89 e9                	mov    %ebp,%ecx
  80286a:	8b 3c 24             	mov    (%esp),%edi
  80286d:	d3 e0                	shl    %cl,%eax
  80286f:	89 c6                	mov    %eax,%esi
  802871:	b8 20 00 00 00       	mov    $0x20,%eax
  802876:	29 e8                	sub    %ebp,%eax
  802878:	89 c1                	mov    %eax,%ecx
  80287a:	d3 ef                	shr    %cl,%edi
  80287c:	89 e9                	mov    %ebp,%ecx
  80287e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802882:	8b 3c 24             	mov    (%esp),%edi
  802885:	09 74 24 08          	or     %esi,0x8(%esp)
  802889:	89 d6                	mov    %edx,%esi
  80288b:	d3 e7                	shl    %cl,%edi
  80288d:	89 c1                	mov    %eax,%ecx
  80288f:	89 3c 24             	mov    %edi,(%esp)
  802892:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802896:	d3 ee                	shr    %cl,%esi
  802898:	89 e9                	mov    %ebp,%ecx
  80289a:	d3 e2                	shl    %cl,%edx
  80289c:	89 c1                	mov    %eax,%ecx
  80289e:	d3 ef                	shr    %cl,%edi
  8028a0:	09 d7                	or     %edx,%edi
  8028a2:	89 f2                	mov    %esi,%edx
  8028a4:	89 f8                	mov    %edi,%eax
  8028a6:	f7 74 24 08          	divl   0x8(%esp)
  8028aa:	89 d6                	mov    %edx,%esi
  8028ac:	89 c7                	mov    %eax,%edi
  8028ae:	f7 24 24             	mull   (%esp)
  8028b1:	39 d6                	cmp    %edx,%esi
  8028b3:	89 14 24             	mov    %edx,(%esp)
  8028b6:	72 30                	jb     8028e8 <__udivdi3+0x118>
  8028b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028bc:	89 e9                	mov    %ebp,%ecx
  8028be:	d3 e2                	shl    %cl,%edx
  8028c0:	39 c2                	cmp    %eax,%edx
  8028c2:	73 05                	jae    8028c9 <__udivdi3+0xf9>
  8028c4:	3b 34 24             	cmp    (%esp),%esi
  8028c7:	74 1f                	je     8028e8 <__udivdi3+0x118>
  8028c9:	89 f8                	mov    %edi,%eax
  8028cb:	31 d2                	xor    %edx,%edx
  8028cd:	e9 7a ff ff ff       	jmp    80284c <__udivdi3+0x7c>
  8028d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d8:	31 d2                	xor    %edx,%edx
  8028da:	b8 01 00 00 00       	mov    $0x1,%eax
  8028df:	e9 68 ff ff ff       	jmp    80284c <__udivdi3+0x7c>
  8028e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028e8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028eb:	31 d2                	xor    %edx,%edx
  8028ed:	83 c4 0c             	add    $0xc,%esp
  8028f0:	5e                   	pop    %esi
  8028f1:	5f                   	pop    %edi
  8028f2:	5d                   	pop    %ebp
  8028f3:	c3                   	ret    
  8028f4:	66 90                	xchg   %ax,%ax
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	66 90                	xchg   %ax,%ax
  8028fa:	66 90                	xchg   %ax,%ax
  8028fc:	66 90                	xchg   %ax,%ax
  8028fe:	66 90                	xchg   %ax,%ax

00802900 <__umoddi3>:
  802900:	55                   	push   %ebp
  802901:	57                   	push   %edi
  802902:	56                   	push   %esi
  802903:	83 ec 14             	sub    $0x14,%esp
  802906:	8b 44 24 28          	mov    0x28(%esp),%eax
  80290a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80290e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802912:	89 c7                	mov    %eax,%edi
  802914:	89 44 24 04          	mov    %eax,0x4(%esp)
  802918:	8b 44 24 30          	mov    0x30(%esp),%eax
  80291c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802920:	89 34 24             	mov    %esi,(%esp)
  802923:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802927:	85 c0                	test   %eax,%eax
  802929:	89 c2                	mov    %eax,%edx
  80292b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80292f:	75 17                	jne    802948 <__umoddi3+0x48>
  802931:	39 fe                	cmp    %edi,%esi
  802933:	76 4b                	jbe    802980 <__umoddi3+0x80>
  802935:	89 c8                	mov    %ecx,%eax
  802937:	89 fa                	mov    %edi,%edx
  802939:	f7 f6                	div    %esi
  80293b:	89 d0                	mov    %edx,%eax
  80293d:	31 d2                	xor    %edx,%edx
  80293f:	83 c4 14             	add    $0x14,%esp
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    
  802946:	66 90                	xchg   %ax,%ax
  802948:	39 f8                	cmp    %edi,%eax
  80294a:	77 54                	ja     8029a0 <__umoddi3+0xa0>
  80294c:	0f bd e8             	bsr    %eax,%ebp
  80294f:	83 f5 1f             	xor    $0x1f,%ebp
  802952:	75 5c                	jne    8029b0 <__umoddi3+0xb0>
  802954:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802958:	39 3c 24             	cmp    %edi,(%esp)
  80295b:	0f 87 e7 00 00 00    	ja     802a48 <__umoddi3+0x148>
  802961:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802965:	29 f1                	sub    %esi,%ecx
  802967:	19 c7                	sbb    %eax,%edi
  802969:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80296d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802971:	8b 44 24 08          	mov    0x8(%esp),%eax
  802975:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802979:	83 c4 14             	add    $0x14,%esp
  80297c:	5e                   	pop    %esi
  80297d:	5f                   	pop    %edi
  80297e:	5d                   	pop    %ebp
  80297f:	c3                   	ret    
  802980:	85 f6                	test   %esi,%esi
  802982:	89 f5                	mov    %esi,%ebp
  802984:	75 0b                	jne    802991 <__umoddi3+0x91>
  802986:	b8 01 00 00 00       	mov    $0x1,%eax
  80298b:	31 d2                	xor    %edx,%edx
  80298d:	f7 f6                	div    %esi
  80298f:	89 c5                	mov    %eax,%ebp
  802991:	8b 44 24 04          	mov    0x4(%esp),%eax
  802995:	31 d2                	xor    %edx,%edx
  802997:	f7 f5                	div    %ebp
  802999:	89 c8                	mov    %ecx,%eax
  80299b:	f7 f5                	div    %ebp
  80299d:	eb 9c                	jmp    80293b <__umoddi3+0x3b>
  80299f:	90                   	nop
  8029a0:	89 c8                	mov    %ecx,%eax
  8029a2:	89 fa                	mov    %edi,%edx
  8029a4:	83 c4 14             	add    $0x14,%esp
  8029a7:	5e                   	pop    %esi
  8029a8:	5f                   	pop    %edi
  8029a9:	5d                   	pop    %ebp
  8029aa:	c3                   	ret    
  8029ab:	90                   	nop
  8029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b0:	8b 04 24             	mov    (%esp),%eax
  8029b3:	be 20 00 00 00       	mov    $0x20,%esi
  8029b8:	89 e9                	mov    %ebp,%ecx
  8029ba:	29 ee                	sub    %ebp,%esi
  8029bc:	d3 e2                	shl    %cl,%edx
  8029be:	89 f1                	mov    %esi,%ecx
  8029c0:	d3 e8                	shr    %cl,%eax
  8029c2:	89 e9                	mov    %ebp,%ecx
  8029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c8:	8b 04 24             	mov    (%esp),%eax
  8029cb:	09 54 24 04          	or     %edx,0x4(%esp)
  8029cf:	89 fa                	mov    %edi,%edx
  8029d1:	d3 e0                	shl    %cl,%eax
  8029d3:	89 f1                	mov    %esi,%ecx
  8029d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029d9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8029dd:	d3 ea                	shr    %cl,%edx
  8029df:	89 e9                	mov    %ebp,%ecx
  8029e1:	d3 e7                	shl    %cl,%edi
  8029e3:	89 f1                	mov    %esi,%ecx
  8029e5:	d3 e8                	shr    %cl,%eax
  8029e7:	89 e9                	mov    %ebp,%ecx
  8029e9:	09 f8                	or     %edi,%eax
  8029eb:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029ef:	f7 74 24 04          	divl   0x4(%esp)
  8029f3:	d3 e7                	shl    %cl,%edi
  8029f5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029f9:	89 d7                	mov    %edx,%edi
  8029fb:	f7 64 24 08          	mull   0x8(%esp)
  8029ff:	39 d7                	cmp    %edx,%edi
  802a01:	89 c1                	mov    %eax,%ecx
  802a03:	89 14 24             	mov    %edx,(%esp)
  802a06:	72 2c                	jb     802a34 <__umoddi3+0x134>
  802a08:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  802a0c:	72 22                	jb     802a30 <__umoddi3+0x130>
  802a0e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802a12:	29 c8                	sub    %ecx,%eax
  802a14:	19 d7                	sbb    %edx,%edi
  802a16:	89 e9                	mov    %ebp,%ecx
  802a18:	89 fa                	mov    %edi,%edx
  802a1a:	d3 e8                	shr    %cl,%eax
  802a1c:	89 f1                	mov    %esi,%ecx
  802a1e:	d3 e2                	shl    %cl,%edx
  802a20:	89 e9                	mov    %ebp,%ecx
  802a22:	d3 ef                	shr    %cl,%edi
  802a24:	09 d0                	or     %edx,%eax
  802a26:	89 fa                	mov    %edi,%edx
  802a28:	83 c4 14             	add    $0x14,%esp
  802a2b:	5e                   	pop    %esi
  802a2c:	5f                   	pop    %edi
  802a2d:	5d                   	pop    %ebp
  802a2e:	c3                   	ret    
  802a2f:	90                   	nop
  802a30:	39 d7                	cmp    %edx,%edi
  802a32:	75 da                	jne    802a0e <__umoddi3+0x10e>
  802a34:	8b 14 24             	mov    (%esp),%edx
  802a37:	89 c1                	mov    %eax,%ecx
  802a39:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a3d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a41:	eb cb                	jmp    802a0e <__umoddi3+0x10e>
  802a43:	90                   	nop
  802a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a48:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a4c:	0f 82 0f ff ff ff    	jb     802961 <__umoddi3+0x61>
  802a52:	e9 1a ff ff ff       	jmp    802971 <__umoddi3+0x71>
