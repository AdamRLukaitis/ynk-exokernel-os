
obj/user/pingpong.debug:     file format elf32-i386


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
  80002c:	e8 ca 00 00 00       	call   8000fb <libmain>
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
	envid_t who;

	if ((who = fork()) != 0) {
  80003c:	e8 45 10 00 00       	call   801086 <fork>
  800041:	89 c3                	mov    %eax,%ebx
  800043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800046:	85 c0                	test   %eax,%eax
  800048:	75 05                	jne    80004f <umain+0x1c>
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
		ipc_send(who, 0, 0, 0);
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80004a:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80004d:	eb 3e                	jmp    80008d <umain+0x5a>
{
	envid_t who;

	if ((who = fork()) != 0) {
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004f:	e8 c1 0b 00 00       	call   800c15 <sys_getenvid>
  800054:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005c:	c7 04 24 60 2a 80 00 	movl   $0x802a60,(%esp)
  800063:	e8 a1 01 00 00       	call   800209 <cprintf>
		ipc_send(who, 0, 0, 0);
  800068:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006f:	00 
  800070:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800077:	00 
  800078:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007f:	00 
  800080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800083:	89 04 24             	mov    %eax,(%esp)
  800086:	e8 b8 12 00 00       	call   801343 <ipc_send>
  80008b:	eb bd                	jmp    80004a <umain+0x17>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  80008d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800094:	00 
  800095:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80009c:	00 
  80009d:	89 34 24             	mov    %esi,(%esp)
  8000a0:	e8 34 12 00 00       	call   8012d9 <ipc_recv>
  8000a5:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8000aa:	e8 66 0b 00 00       	call   800c15 <sys_getenvid>
  8000af:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bb:	c7 04 24 76 2a 80 00 	movl   $0x802a76,(%esp)
  8000c2:	e8 42 01 00 00       	call   800209 <cprintf>
		if (i == 10)
  8000c7:	83 fb 0a             	cmp    $0xa,%ebx
  8000ca:	74 27                	je     8000f3 <umain+0xc0>
			return;
		i++;
  8000cc:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cf:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d6:	00 
  8000d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000de:	00 
  8000df:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e6:	89 04 24             	mov    %eax,(%esp)
  8000e9:	e8 55 12 00 00       	call   801343 <ipc_send>
		if (i == 10)
  8000ee:	83 fb 0a             	cmp    $0xa,%ebx
  8000f1:	75 9a                	jne    80008d <umain+0x5a>
			return;
	}

}
  8000f3:	83 c4 2c             	add    $0x2c,%esp
  8000f6:	5b                   	pop    %ebx
  8000f7:	5e                   	pop    %esi
  8000f8:	5f                   	pop    %edi
  8000f9:	5d                   	pop    %ebp
  8000fa:	c3                   	ret    

008000fb <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000fb:	55                   	push   %ebp
  8000fc:	89 e5                	mov    %esp,%ebp
  8000fe:	56                   	push   %esi
  8000ff:	53                   	push   %ebx
  800100:	83 ec 10             	sub    $0x10,%esp
  800103:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800106:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  800109:	c7 05 08 50 80 00 00 	movl   $0x0,0x805008
  800110:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  800113:	e8 fd 0a 00 00       	call   800c15 <sys_getenvid>
  800118:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  80011d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800120:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800125:	a3 08 50 80 00       	mov    %eax,0x805008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  80012a:	85 db                	test   %ebx,%ebx
  80012c:	7e 07                	jle    800135 <libmain+0x3a>
		binaryname = argv[0];
  80012e:	8b 06                	mov    (%esi),%eax
  800130:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800135:	89 74 24 04          	mov    %esi,0x4(%esp)
  800139:	89 1c 24             	mov    %ebx,(%esp)
  80013c:	e8 f2 fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800141:	e8 07 00 00 00       	call   80014d <exit>
}
  800146:	83 c4 10             	add    $0x10,%esp
  800149:	5b                   	pop    %ebx
  80014a:	5e                   	pop    %esi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800153:	e8 62 14 00 00       	call   8015ba <close_all>
	sys_env_destroy(0);
  800158:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015f:	e8 5f 0a 00 00       	call   800bc3 <sys_env_destroy>
}
  800164:	c9                   	leave  
  800165:	c3                   	ret    

00800166 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800166:	55                   	push   %ebp
  800167:	89 e5                	mov    %esp,%ebp
  800169:	53                   	push   %ebx
  80016a:	83 ec 14             	sub    $0x14,%esp
  80016d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800170:	8b 13                	mov    (%ebx),%edx
  800172:	8d 42 01             	lea    0x1(%edx),%eax
  800175:	89 03                	mov    %eax,(%ebx)
  800177:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80017a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80017e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800183:	75 19                	jne    80019e <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800185:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80018c:	00 
  80018d:	8d 43 08             	lea    0x8(%ebx),%eax
  800190:	89 04 24             	mov    %eax,(%esp)
  800193:	e8 ee 09 00 00       	call   800b86 <sys_cputs>
		b->idx = 0;
  800198:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80019e:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001a2:	83 c4 14             	add    $0x14,%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5d                   	pop    %ebp
  8001a7:	c3                   	ret    

008001a8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a8:	55                   	push   %ebp
  8001a9:	89 e5                	mov    %esp,%ebp
  8001ab:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b8:	00 00 00 
	b.cnt = 0;
  8001bb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001c2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8001cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001dd:	c7 04 24 66 01 80 00 	movl   $0x800166,(%esp)
  8001e4:	e8 b5 01 00 00       	call   80039e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001e9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001f9:	89 04 24             	mov    %eax,(%esp)
  8001fc:	e8 85 09 00 00       	call   800b86 <sys_cputs>

	return b.cnt;
}
  800201:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800207:	c9                   	leave  
  800208:	c3                   	ret    

00800209 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80020f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800212:	89 44 24 04          	mov    %eax,0x4(%esp)
  800216:	8b 45 08             	mov    0x8(%ebp),%eax
  800219:	89 04 24             	mov    %eax,(%esp)
  80021c:	e8 87 ff ff ff       	call   8001a8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800221:	c9                   	leave  
  800222:	c3                   	ret    
  800223:	66 90                	xchg   %ax,%ax
  800225:	66 90                	xchg   %ax,%ax
  800227:	66 90                	xchg   %ax,%ax
  800229:	66 90                	xchg   %ax,%ax
  80022b:	66 90                	xchg   %ax,%ax
  80022d:	66 90                	xchg   %ax,%ax
  80022f:	90                   	nop

00800230 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 3c             	sub    $0x3c,%esp
  800239:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80023c:	89 d7                	mov    %edx,%edi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800244:	8b 45 0c             	mov    0xc(%ebp),%eax
  800247:	89 c3                	mov    %eax,%ebx
  800249:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  80024c:	8b 45 10             	mov    0x10(%ebp),%eax
  80024f:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800252:	b9 00 00 00 00       	mov    $0x0,%ecx
  800257:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80025a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80025d:	39 d9                	cmp    %ebx,%ecx
  80025f:	72 05                	jb     800266 <printnum+0x36>
  800261:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800264:	77 69                	ja     8002cf <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800266:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800269:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80026d:	83 ee 01             	sub    $0x1,%esi
  800270:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800274:	89 44 24 08          	mov    %eax,0x8(%esp)
  800278:	8b 44 24 08          	mov    0x8(%esp),%eax
  80027c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800280:	89 c3                	mov    %eax,%ebx
  800282:	89 d6                	mov    %edx,%esi
  800284:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800287:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80028a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80028e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800292:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80029b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029f:	e8 1c 25 00 00       	call   8027c0 <__udivdi3>
  8002a4:	89 d9                	mov    %ebx,%ecx
  8002a6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002aa:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8002ae:	89 04 24             	mov    %eax,(%esp)
  8002b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002b5:	89 fa                	mov    %edi,%edx
  8002b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002ba:	e8 71 ff ff ff       	call   800230 <printnum>
  8002bf:	eb 1b                	jmp    8002dc <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002c1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002c5:	8b 45 18             	mov    0x18(%ebp),%eax
  8002c8:	89 04 24             	mov    %eax,(%esp)
  8002cb:	ff d3                	call   *%ebx
  8002cd:	eb 03                	jmp    8002d2 <printnum+0xa2>
  8002cf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002d2:	83 ee 01             	sub    $0x1,%esi
  8002d5:	85 f6                	test   %esi,%esi
  8002d7:	7f e8                	jg     8002c1 <printnum+0x91>
  8002d9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002dc:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002e0:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8002e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002e7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8002ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002ee:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8002f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002f5:	89 04 24             	mov    %eax,(%esp)
  8002f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002ff:	e8 ec 25 00 00       	call   8028f0 <__umoddi3>
  800304:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800308:	0f be 80 93 2a 80 00 	movsbl 0x802a93(%eax),%eax
  80030f:	89 04 24             	mov    %eax,(%esp)
  800312:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800315:	ff d0                	call   *%eax
}
  800317:	83 c4 3c             	add    $0x3c,%esp
  80031a:	5b                   	pop    %ebx
  80031b:	5e                   	pop    %esi
  80031c:	5f                   	pop    %edi
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800322:	83 fa 01             	cmp    $0x1,%edx
  800325:	7e 0e                	jle    800335 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800327:	8b 10                	mov    (%eax),%edx
  800329:	8d 4a 08             	lea    0x8(%edx),%ecx
  80032c:	89 08                	mov    %ecx,(%eax)
  80032e:	8b 02                	mov    (%edx),%eax
  800330:	8b 52 04             	mov    0x4(%edx),%edx
  800333:	eb 22                	jmp    800357 <getuint+0x38>
	else if (lflag)
  800335:	85 d2                	test   %edx,%edx
  800337:	74 10                	je     800349 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800339:	8b 10                	mov    (%eax),%edx
  80033b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80033e:	89 08                	mov    %ecx,(%eax)
  800340:	8b 02                	mov    (%edx),%eax
  800342:	ba 00 00 00 00       	mov    $0x0,%edx
  800347:	eb 0e                	jmp    800357 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800349:	8b 10                	mov    (%eax),%edx
  80034b:	8d 4a 04             	lea    0x4(%edx),%ecx
  80034e:	89 08                	mov    %ecx,(%eax)
  800350:	8b 02                	mov    (%edx),%eax
  800352:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800357:	5d                   	pop    %ebp
  800358:	c3                   	ret    

00800359 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800363:	8b 10                	mov    (%eax),%edx
  800365:	3b 50 04             	cmp    0x4(%eax),%edx
  800368:	73 0a                	jae    800374 <sprintputch+0x1b>
		*b->buf++ = ch;
  80036a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80036d:	89 08                	mov    %ecx,(%eax)
  80036f:	8b 45 08             	mov    0x8(%ebp),%eax
  800372:	88 02                	mov    %al,(%edx)
}
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80037c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800383:	8b 45 10             	mov    0x10(%ebp),%eax
  800386:	89 44 24 08          	mov    %eax,0x8(%esp)
  80038a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	89 04 24             	mov    %eax,(%esp)
  800397:	e8 02 00 00 00       	call   80039e <vprintfmt>
	va_end(ap);
}
  80039c:	c9                   	leave  
  80039d:	c3                   	ret    

0080039e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	57                   	push   %edi
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
  8003a4:	83 ec 3c             	sub    $0x3c,%esp
  8003a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8003aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003ad:	eb 14                	jmp    8003c3 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003af:	85 c0                	test   %eax,%eax
  8003b1:	0f 84 b3 03 00 00    	je     80076a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  8003b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8003bb:	89 04 24             	mov    %eax,(%esp)
  8003be:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003c1:	89 f3                	mov    %esi,%ebx
  8003c3:	8d 73 01             	lea    0x1(%ebx),%esi
  8003c6:	0f b6 03             	movzbl (%ebx),%eax
  8003c9:	83 f8 25             	cmp    $0x25,%eax
  8003cc:	75 e1                	jne    8003af <vprintfmt+0x11>
  8003ce:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  8003d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003d9:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  8003e0:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  8003e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ec:	eb 1d                	jmp    80040b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ee:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  8003f0:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  8003f4:	eb 15                	jmp    80040b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8003f8:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  8003fc:	eb 0d                	jmp    80040b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  8003fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800401:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800404:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80040e:	0f b6 0e             	movzbl (%esi),%ecx
  800411:	0f b6 c1             	movzbl %cl,%eax
  800414:	83 e9 23             	sub    $0x23,%ecx
  800417:	80 f9 55             	cmp    $0x55,%cl
  80041a:	0f 87 2a 03 00 00    	ja     80074a <vprintfmt+0x3ac>
  800420:	0f b6 c9             	movzbl %cl,%ecx
  800423:	ff 24 8d e0 2b 80 00 	jmp    *0x802be0(,%ecx,4)
  80042a:	89 de                	mov    %ebx,%esi
  80042c:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800431:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800434:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  800438:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  80043b:	8d 58 d0             	lea    -0x30(%eax),%ebx
  80043e:	83 fb 09             	cmp    $0x9,%ebx
  800441:	77 36                	ja     800479 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800443:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800446:	eb e9                	jmp    800431 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800448:	8b 45 14             	mov    0x14(%ebp),%eax
  80044b:	8d 48 04             	lea    0x4(%eax),%ecx
  80044e:	89 4d 14             	mov    %ecx,0x14(%ebp)
  800451:	8b 00                	mov    (%eax),%eax
  800453:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800456:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  800458:	eb 22                	jmp    80047c <vprintfmt+0xde>
  80045a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80045d:	85 c9                	test   %ecx,%ecx
  80045f:	b8 00 00 00 00       	mov    $0x0,%eax
  800464:	0f 49 c1             	cmovns %ecx,%eax
  800467:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80046a:	89 de                	mov    %ebx,%esi
  80046c:	eb 9d                	jmp    80040b <vprintfmt+0x6d>
  80046e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800470:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800477:	eb 92                	jmp    80040b <vprintfmt+0x6d>
  800479:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80047c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800480:	79 89                	jns    80040b <vprintfmt+0x6d>
  800482:	e9 77 ff ff ff       	jmp    8003fe <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800487:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80048c:	e9 7a ff ff ff       	jmp    80040b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8d 50 04             	lea    0x4(%eax),%edx
  800497:	89 55 14             	mov    %edx,0x14(%ebp)
  80049a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049e:	8b 00                	mov    (%eax),%eax
  8004a0:	89 04 24             	mov    %eax,(%esp)
  8004a3:	ff 55 08             	call   *0x8(%ebp)
			break;
  8004a6:	e9 18 ff ff ff       	jmp    8003c3 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ae:	8d 50 04             	lea    0x4(%eax),%edx
  8004b1:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	99                   	cltd   
  8004b7:	31 d0                	xor    %edx,%eax
  8004b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004bb:	83 f8 0f             	cmp    $0xf,%eax
  8004be:	7f 0b                	jg     8004cb <vprintfmt+0x12d>
  8004c0:	8b 14 85 40 2d 80 00 	mov    0x802d40(,%eax,4),%edx
  8004c7:	85 d2                	test   %edx,%edx
  8004c9:	75 20                	jne    8004eb <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  8004cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004cf:	c7 44 24 08 ab 2a 80 	movl   $0x802aab,0x8(%esp)
  8004d6:	00 
  8004d7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004db:	8b 45 08             	mov    0x8(%ebp),%eax
  8004de:	89 04 24             	mov    %eax,(%esp)
  8004e1:	e8 90 fe ff ff       	call   800376 <printfmt>
  8004e6:	e9 d8 fe ff ff       	jmp    8003c3 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  8004eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ef:	c7 44 24 08 05 30 80 	movl   $0x803005,0x8(%esp)
  8004f6:	00 
  8004f7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fe:	89 04 24             	mov    %eax,(%esp)
  800501:	e8 70 fe ff ff       	call   800376 <printfmt>
  800506:	e9 b8 fe ff ff       	jmp    8003c3 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80050e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800511:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800514:	8b 45 14             	mov    0x14(%ebp),%eax
  800517:	8d 50 04             	lea    0x4(%eax),%edx
  80051a:	89 55 14             	mov    %edx,0x14(%ebp)
  80051d:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  80051f:	85 f6                	test   %esi,%esi
  800521:	b8 a4 2a 80 00       	mov    $0x802aa4,%eax
  800526:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  800529:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  80052d:	0f 84 97 00 00 00    	je     8005ca <vprintfmt+0x22c>
  800533:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800537:	0f 8e 9b 00 00 00    	jle    8005d8 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800541:	89 34 24             	mov    %esi,(%esp)
  800544:	e8 cf 02 00 00       	call   800818 <strnlen>
  800549:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80054c:	29 c2                	sub    %eax,%edx
  80054e:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  800551:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  800555:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800558:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80055b:	8b 75 08             	mov    0x8(%ebp),%esi
  80055e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800561:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800563:	eb 0f                	jmp    800574 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800565:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800569:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80056c:	89 04 24             	mov    %eax,(%esp)
  80056f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800571:	83 eb 01             	sub    $0x1,%ebx
  800574:	85 db                	test   %ebx,%ebx
  800576:	7f ed                	jg     800565 <vprintfmt+0x1c7>
  800578:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80057b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80057e:	85 d2                	test   %edx,%edx
  800580:	b8 00 00 00 00       	mov    $0x0,%eax
  800585:	0f 49 c2             	cmovns %edx,%eax
  800588:	29 c2                	sub    %eax,%edx
  80058a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80058d:	89 d7                	mov    %edx,%edi
  80058f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800592:	eb 50                	jmp    8005e4 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800594:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800598:	74 1e                	je     8005b8 <vprintfmt+0x21a>
  80059a:	0f be d2             	movsbl %dl,%edx
  80059d:	83 ea 20             	sub    $0x20,%edx
  8005a0:	83 fa 5e             	cmp    $0x5e,%edx
  8005a3:	76 13                	jbe    8005b8 <vprintfmt+0x21a>
					putch('?', putdat);
  8005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ac:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b3:	ff 55 08             	call   *0x8(%ebp)
  8005b6:	eb 0d                	jmp    8005c5 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  8005b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005bf:	89 04 24             	mov    %eax,(%esp)
  8005c2:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005c5:	83 ef 01             	sub    $0x1,%edi
  8005c8:	eb 1a                	jmp    8005e4 <vprintfmt+0x246>
  8005ca:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005cd:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005d0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005d3:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005d6:	eb 0c                	jmp    8005e4 <vprintfmt+0x246>
  8005d8:	89 7d 0c             	mov    %edi,0xc(%ebp)
  8005db:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005de:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8005e1:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005e4:	83 c6 01             	add    $0x1,%esi
  8005e7:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  8005eb:	0f be c2             	movsbl %dl,%eax
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	74 27                	je     800619 <vprintfmt+0x27b>
  8005f2:	85 db                	test   %ebx,%ebx
  8005f4:	78 9e                	js     800594 <vprintfmt+0x1f6>
  8005f6:	83 eb 01             	sub    $0x1,%ebx
  8005f9:	79 99                	jns    800594 <vprintfmt+0x1f6>
  8005fb:	89 f8                	mov    %edi,%eax
  8005fd:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800600:	8b 75 08             	mov    0x8(%ebp),%esi
  800603:	89 c3                	mov    %eax,%ebx
  800605:	eb 1a                	jmp    800621 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800607:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80060b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800612:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800614:	83 eb 01             	sub    $0x1,%ebx
  800617:	eb 08                	jmp    800621 <vprintfmt+0x283>
  800619:	89 fb                	mov    %edi,%ebx
  80061b:	8b 75 08             	mov    0x8(%ebp),%esi
  80061e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800621:	85 db                	test   %ebx,%ebx
  800623:	7f e2                	jg     800607 <vprintfmt+0x269>
  800625:	89 75 08             	mov    %esi,0x8(%ebp)
  800628:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80062b:	e9 93 fd ff ff       	jmp    8003c3 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800630:	83 fa 01             	cmp    $0x1,%edx
  800633:	7e 16                	jle    80064b <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 50 08             	lea    0x8(%eax),%edx
  80063b:	89 55 14             	mov    %edx,0x14(%ebp)
  80063e:	8b 50 04             	mov    0x4(%eax),%edx
  800641:	8b 00                	mov    (%eax),%eax
  800643:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800646:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800649:	eb 32                	jmp    80067d <vprintfmt+0x2df>
	else if (lflag)
  80064b:	85 d2                	test   %edx,%edx
  80064d:	74 18                	je     800667 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 50 04             	lea    0x4(%eax),%edx
  800655:	89 55 14             	mov    %edx,0x14(%ebp)
  800658:	8b 30                	mov    (%eax),%esi
  80065a:	89 75 e0             	mov    %esi,-0x20(%ebp)
  80065d:	89 f0                	mov    %esi,%eax
  80065f:	c1 f8 1f             	sar    $0x1f,%eax
  800662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800665:	eb 16                	jmp    80067d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 50 04             	lea    0x4(%eax),%edx
  80066d:	89 55 14             	mov    %edx,0x14(%ebp)
  800670:	8b 30                	mov    (%eax),%esi
  800672:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800675:	89 f0                	mov    %esi,%eax
  800677:	c1 f8 1f             	sar    $0x1f,%eax
  80067a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80067d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800683:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800688:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068c:	0f 89 80 00 00 00    	jns    800712 <vprintfmt+0x374>
				putch('-', putdat);
  800692:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800696:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80069d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  8006a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a6:	f7 d8                	neg    %eax
  8006a8:	83 d2 00             	adc    $0x0,%edx
  8006ab:	f7 da                	neg    %edx
			}
			base = 10;
  8006ad:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8006b2:	eb 5e                	jmp    800712 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b4:	8d 45 14             	lea    0x14(%ebp),%eax
  8006b7:	e8 63 fc ff ff       	call   80031f <getuint>
			base = 10;
  8006bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  8006c1:	eb 4f                	jmp    800712 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  8006c3:	8d 45 14             	lea    0x14(%ebp),%eax
  8006c6:	e8 54 fc ff ff       	call   80031f <getuint>
			base =8;
  8006cb:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  8006d0:	eb 40                	jmp    800712 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  8006d2:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d6:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8006dd:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  8006e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006eb:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  8006ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f1:	8d 50 04             	lea    0x4(%eax),%edx
  8006f4:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  8006fe:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800703:	eb 0d                	jmp    800712 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800705:	8d 45 14             	lea    0x14(%ebp),%eax
  800708:	e8 12 fc ff ff       	call   80031f <getuint>
			base = 16;
  80070d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  800712:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  800716:	89 74 24 10          	mov    %esi,0x10(%esp)
  80071a:	8b 75 dc             	mov    -0x24(%ebp),%esi
  80071d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800721:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800725:	89 04 24             	mov    %eax,(%esp)
  800728:	89 54 24 04          	mov    %edx,0x4(%esp)
  80072c:	89 fa                	mov    %edi,%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	e8 fa fa ff ff       	call   800230 <printnum>
			break;
  800736:	e9 88 fc ff ff       	jmp    8003c3 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80073b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80073f:	89 04 24             	mov    %eax,(%esp)
  800742:	ff 55 08             	call   *0x8(%ebp)
			break;
  800745:	e9 79 fc ff ff       	jmp    8003c3 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80074a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80074e:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800755:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  800758:	89 f3                	mov    %esi,%ebx
  80075a:	eb 03                	jmp    80075f <vprintfmt+0x3c1>
  80075c:	83 eb 01             	sub    $0x1,%ebx
  80075f:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800763:	75 f7                	jne    80075c <vprintfmt+0x3be>
  800765:	e9 59 fc ff ff       	jmp    8003c3 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80076a:	83 c4 3c             	add    $0x3c,%esp
  80076d:	5b                   	pop    %ebx
  80076e:	5e                   	pop    %esi
  80076f:	5f                   	pop    %edi
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	83 ec 28             	sub    $0x28,%esp
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80077e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800781:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800785:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800788:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80078f:	85 c0                	test   %eax,%eax
  800791:	74 30                	je     8007c3 <vsnprintf+0x51>
  800793:	85 d2                	test   %edx,%edx
  800795:	7e 2c                	jle    8007c3 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80079e:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ac:	c7 04 24 59 03 80 00 	movl   $0x800359,(%esp)
  8007b3:	e8 e6 fb ff ff       	call   80039e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007bb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007c1:	eb 05                	jmp    8007c8 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  8007c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  8007c8:	c9                   	leave  
  8007c9:	c3                   	ret    

008007ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007ca:	55                   	push   %ebp
  8007cb:	89 e5                	mov    %esp,%ebp
  8007cd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	89 04 24             	mov    %eax,(%esp)
  8007eb:	e8 82 ff ff ff       	call   800772 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    
  8007f2:	66 90                	xchg   %ax,%ax
  8007f4:	66 90                	xchg   %ax,%ax
  8007f6:	66 90                	xchg   %ax,%ax
  8007f8:	66 90                	xchg   %ax,%ax
  8007fa:	66 90                	xchg   %ax,%ax
  8007fc:	66 90                	xchg   %ax,%ax
  8007fe:	66 90                	xchg   %ax,%ax

00800800 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800806:	b8 00 00 00 00       	mov    $0x0,%eax
  80080b:	eb 03                	jmp    800810 <strlen+0x10>
		n++;
  80080d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800810:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800814:	75 f7                	jne    80080d <strlen+0xd>
		n++;
	return n;
}
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
  80081b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081e:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800821:	b8 00 00 00 00       	mov    $0x0,%eax
  800826:	eb 03                	jmp    80082b <strnlen+0x13>
		n++;
  800828:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80082b:	39 d0                	cmp    %edx,%eax
  80082d:	74 06                	je     800835 <strnlen+0x1d>
  80082f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800833:	75 f3                	jne    800828 <strnlen+0x10>
		n++;
	return n;
}
  800835:	5d                   	pop    %ebp
  800836:	c3                   	ret    

00800837 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	53                   	push   %ebx
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800841:	89 c2                	mov    %eax,%edx
  800843:	83 c2 01             	add    $0x1,%edx
  800846:	83 c1 01             	add    $0x1,%ecx
  800849:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  80084d:	88 5a ff             	mov    %bl,-0x1(%edx)
  800850:	84 db                	test   %bl,%bl
  800852:	75 ef                	jne    800843 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800854:	5b                   	pop    %ebx
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	83 ec 08             	sub    $0x8,%esp
  80085e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800861:	89 1c 24             	mov    %ebx,(%esp)
  800864:	e8 97 ff ff ff       	call   800800 <strlen>
	strcpy(dst + len, src);
  800869:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800870:	01 d8                	add    %ebx,%eax
  800872:	89 04 24             	mov    %eax,(%esp)
  800875:	e8 bd ff ff ff       	call   800837 <strcpy>
	return dst;
}
  80087a:	89 d8                	mov    %ebx,%eax
  80087c:	83 c4 08             	add    $0x8,%esp
  80087f:	5b                   	pop    %ebx
  800880:	5d                   	pop    %ebp
  800881:	c3                   	ret    

00800882 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	56                   	push   %esi
  800886:	53                   	push   %ebx
  800887:	8b 75 08             	mov    0x8(%ebp),%esi
  80088a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80088d:	89 f3                	mov    %esi,%ebx
  80088f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800892:	89 f2                	mov    %esi,%edx
  800894:	eb 0f                	jmp    8008a5 <strncpy+0x23>
		*dst++ = *src;
  800896:	83 c2 01             	add    $0x1,%edx
  800899:	0f b6 01             	movzbl (%ecx),%eax
  80089c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80089f:	80 39 01             	cmpb   $0x1,(%ecx)
  8008a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a5:	39 da                	cmp    %ebx,%edx
  8008a7:	75 ed                	jne    800896 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008a9:	89 f0                	mov    %esi,%eax
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5d                   	pop    %ebp
  8008ae:	c3                   	ret    

008008af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008af:	55                   	push   %ebp
  8008b0:	89 e5                	mov    %esp,%ebp
  8008b2:	56                   	push   %esi
  8008b3:	53                   	push   %ebx
  8008b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008bd:	89 f0                	mov    %esi,%eax
  8008bf:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008c3:	85 c9                	test   %ecx,%ecx
  8008c5:	75 0b                	jne    8008d2 <strlcpy+0x23>
  8008c7:	eb 1d                	jmp    8008e6 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008c9:	83 c0 01             	add    $0x1,%eax
  8008cc:	83 c2 01             	add    $0x1,%edx
  8008cf:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008d2:	39 d8                	cmp    %ebx,%eax
  8008d4:	74 0b                	je     8008e1 <strlcpy+0x32>
  8008d6:	0f b6 0a             	movzbl (%edx),%ecx
  8008d9:	84 c9                	test   %cl,%cl
  8008db:	75 ec                	jne    8008c9 <strlcpy+0x1a>
  8008dd:	89 c2                	mov    %eax,%edx
  8008df:	eb 02                	jmp    8008e3 <strlcpy+0x34>
  8008e1:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  8008e3:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  8008e6:	29 f0                	sub    %esi,%eax
}
  8008e8:	5b                   	pop    %ebx
  8008e9:	5e                   	pop    %esi
  8008ea:	5d                   	pop    %ebp
  8008eb:	c3                   	ret    

008008ec <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008f2:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008f5:	eb 06                	jmp    8008fd <strcmp+0x11>
		p++, q++;
  8008f7:	83 c1 01             	add    $0x1,%ecx
  8008fa:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008fd:	0f b6 01             	movzbl (%ecx),%eax
  800900:	84 c0                	test   %al,%al
  800902:	74 04                	je     800908 <strcmp+0x1c>
  800904:	3a 02                	cmp    (%edx),%al
  800906:	74 ef                	je     8008f7 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800908:	0f b6 c0             	movzbl %al,%eax
  80090b:	0f b6 12             	movzbl (%edx),%edx
  80090e:	29 d0                	sub    %edx,%eax
}
  800910:	5d                   	pop    %ebp
  800911:	c3                   	ret    

00800912 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	53                   	push   %ebx
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091c:	89 c3                	mov    %eax,%ebx
  80091e:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800921:	eb 06                	jmp    800929 <strncmp+0x17>
		n--, p++, q++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800929:	39 d8                	cmp    %ebx,%eax
  80092b:	74 15                	je     800942 <strncmp+0x30>
  80092d:	0f b6 08             	movzbl (%eax),%ecx
  800930:	84 c9                	test   %cl,%cl
  800932:	74 04                	je     800938 <strncmp+0x26>
  800934:	3a 0a                	cmp    (%edx),%cl
  800936:	74 eb                	je     800923 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800938:	0f b6 00             	movzbl (%eax),%eax
  80093b:	0f b6 12             	movzbl (%edx),%edx
  80093e:	29 d0                	sub    %edx,%eax
  800940:	eb 05                	jmp    800947 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  800942:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800947:	5b                   	pop    %ebx
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800954:	eb 07                	jmp    80095d <strchr+0x13>
		if (*s == c)
  800956:	38 ca                	cmp    %cl,%dl
  800958:	74 0f                	je     800969 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	0f b6 10             	movzbl (%eax),%edx
  800960:	84 d2                	test   %dl,%dl
  800962:	75 f2                	jne    800956 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800975:	eb 07                	jmp    80097e <strfind+0x13>
		if (*s == c)
  800977:	38 ca                	cmp    %cl,%dl
  800979:	74 0a                	je     800985 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80097b:	83 c0 01             	add    $0x1,%eax
  80097e:	0f b6 10             	movzbl (%eax),%edx
  800981:	84 d2                	test   %dl,%dl
  800983:	75 f2                	jne    800977 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    

00800987 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	57                   	push   %edi
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800990:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800993:	85 c9                	test   %ecx,%ecx
  800995:	74 36                	je     8009cd <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800997:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80099d:	75 28                	jne    8009c7 <memset+0x40>
  80099f:	f6 c1 03             	test   $0x3,%cl
  8009a2:	75 23                	jne    8009c7 <memset+0x40>
		c &= 0xFF;
  8009a4:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009a8:	89 d3                	mov    %edx,%ebx
  8009aa:	c1 e3 08             	shl    $0x8,%ebx
  8009ad:	89 d6                	mov    %edx,%esi
  8009af:	c1 e6 18             	shl    $0x18,%esi
  8009b2:	89 d0                	mov    %edx,%eax
  8009b4:	c1 e0 10             	shl    $0x10,%eax
  8009b7:	09 f0                	or     %esi,%eax
  8009b9:	09 c2                	or     %eax,%edx
  8009bb:	89 d0                	mov    %edx,%eax
  8009bd:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  8009bf:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  8009c2:	fc                   	cld    
  8009c3:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c5:	eb 06                	jmp    8009cd <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ca:	fc                   	cld    
  8009cb:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009cd:	89 f8                	mov    %edi,%eax
  8009cf:	5b                   	pop    %ebx
  8009d0:	5e                   	pop    %esi
  8009d1:	5f                   	pop    %edi
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	57                   	push   %edi
  8009d8:	56                   	push   %esi
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009df:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009e2:	39 c6                	cmp    %eax,%esi
  8009e4:	73 35                	jae    800a1b <memmove+0x47>
  8009e6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009e9:	39 d0                	cmp    %edx,%eax
  8009eb:	73 2e                	jae    800a1b <memmove+0x47>
		s += n;
		d += n;
  8009ed:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  8009f0:	89 d6                	mov    %edx,%esi
  8009f2:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009f4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009fa:	75 13                	jne    800a0f <memmove+0x3b>
  8009fc:	f6 c1 03             	test   $0x3,%cl
  8009ff:	75 0e                	jne    800a0f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a01:	83 ef 04             	sub    $0x4,%edi
  800a04:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a07:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  800a0a:	fd                   	std    
  800a0b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0d:	eb 09                	jmp    800a18 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a0f:	83 ef 01             	sub    $0x1,%edi
  800a12:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a15:	fd                   	std    
  800a16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a18:	fc                   	cld    
  800a19:	eb 1d                	jmp    800a38 <memmove+0x64>
  800a1b:	89 f2                	mov    %esi,%edx
  800a1d:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1f:	f6 c2 03             	test   $0x3,%dl
  800a22:	75 0f                	jne    800a33 <memmove+0x5f>
  800a24:	f6 c1 03             	test   $0x3,%cl
  800a27:	75 0a                	jne    800a33 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a29:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  800a2c:	89 c7                	mov    %eax,%edi
  800a2e:	fc                   	cld    
  800a2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a31:	eb 05                	jmp    800a38 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a33:	89 c7                	mov    %eax,%edi
  800a35:	fc                   	cld    
  800a36:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a38:	5e                   	pop    %esi
  800a39:	5f                   	pop    %edi
  800a3a:	5d                   	pop    %ebp
  800a3b:	c3                   	ret    

00800a3c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a3c:	55                   	push   %ebp
  800a3d:	89 e5                	mov    %esp,%ebp
  800a3f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a42:	8b 45 10             	mov    0x10(%ebp),%eax
  800a45:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a50:	8b 45 08             	mov    0x8(%ebp),%eax
  800a53:	89 04 24             	mov    %eax,(%esp)
  800a56:	e8 79 ff ff ff       	call   8009d4 <memmove>
}
  800a5b:	c9                   	leave  
  800a5c:	c3                   	ret    

00800a5d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a5d:	55                   	push   %ebp
  800a5e:	89 e5                	mov    %esp,%ebp
  800a60:	56                   	push   %esi
  800a61:	53                   	push   %ebx
  800a62:	8b 55 08             	mov    0x8(%ebp),%edx
  800a65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a68:	89 d6                	mov    %edx,%esi
  800a6a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a6d:	eb 1a                	jmp    800a89 <memcmp+0x2c>
		if (*s1 != *s2)
  800a6f:	0f b6 02             	movzbl (%edx),%eax
  800a72:	0f b6 19             	movzbl (%ecx),%ebx
  800a75:	38 d8                	cmp    %bl,%al
  800a77:	74 0a                	je     800a83 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a79:	0f b6 c0             	movzbl %al,%eax
  800a7c:	0f b6 db             	movzbl %bl,%ebx
  800a7f:	29 d8                	sub    %ebx,%eax
  800a81:	eb 0f                	jmp    800a92 <memcmp+0x35>
		s1++, s2++;
  800a83:	83 c2 01             	add    $0x1,%edx
  800a86:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a89:	39 f2                	cmp    %esi,%edx
  800a8b:	75 e2                	jne    800a6f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a92:	5b                   	pop    %ebx
  800a93:	5e                   	pop    %esi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a9f:	89 c2                	mov    %eax,%edx
  800aa1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aa4:	eb 07                	jmp    800aad <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800aa6:	38 08                	cmp    %cl,(%eax)
  800aa8:	74 07                	je     800ab1 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	39 d0                	cmp    %edx,%eax
  800aaf:	72 f5                	jb     800aa6 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ab1:	5d                   	pop    %ebp
  800ab2:	c3                   	ret    

00800ab3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ab3:	55                   	push   %ebp
  800ab4:	89 e5                	mov    %esp,%ebp
  800ab6:	57                   	push   %edi
  800ab7:	56                   	push   %esi
  800ab8:	53                   	push   %ebx
  800ab9:	8b 55 08             	mov    0x8(%ebp),%edx
  800abc:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800abf:	eb 03                	jmp    800ac4 <strtol+0x11>
		s++;
  800ac1:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ac4:	0f b6 0a             	movzbl (%edx),%ecx
  800ac7:	80 f9 09             	cmp    $0x9,%cl
  800aca:	74 f5                	je     800ac1 <strtol+0xe>
  800acc:	80 f9 20             	cmp    $0x20,%cl
  800acf:	74 f0                	je     800ac1 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ad1:	80 f9 2b             	cmp    $0x2b,%cl
  800ad4:	75 0a                	jne    800ae0 <strtol+0x2d>
		s++;
  800ad6:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800ad9:	bf 00 00 00 00       	mov    $0x0,%edi
  800ade:	eb 11                	jmp    800af1 <strtol+0x3e>
  800ae0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800ae5:	80 f9 2d             	cmp    $0x2d,%cl
  800ae8:	75 07                	jne    800af1 <strtol+0x3e>
		s++, neg = 1;
  800aea:	8d 52 01             	lea    0x1(%edx),%edx
  800aed:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800af1:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800af6:	75 15                	jne    800b0d <strtol+0x5a>
  800af8:	80 3a 30             	cmpb   $0x30,(%edx)
  800afb:	75 10                	jne    800b0d <strtol+0x5a>
  800afd:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b01:	75 0a                	jne    800b0d <strtol+0x5a>
		s += 2, base = 16;
  800b03:	83 c2 02             	add    $0x2,%edx
  800b06:	b8 10 00 00 00       	mov    $0x10,%eax
  800b0b:	eb 10                	jmp    800b1d <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800b0d:	85 c0                	test   %eax,%eax
  800b0f:	75 0c                	jne    800b1d <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b11:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b13:	80 3a 30             	cmpb   $0x30,(%edx)
  800b16:	75 05                	jne    800b1d <strtol+0x6a>
		s++, base = 8;
  800b18:	83 c2 01             	add    $0x1,%edx
  800b1b:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800b1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b22:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b25:	0f b6 0a             	movzbl (%edx),%ecx
  800b28:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800b2b:	89 f0                	mov    %esi,%eax
  800b2d:	3c 09                	cmp    $0x9,%al
  800b2f:	77 08                	ja     800b39 <strtol+0x86>
			dig = *s - '0';
  800b31:	0f be c9             	movsbl %cl,%ecx
  800b34:	83 e9 30             	sub    $0x30,%ecx
  800b37:	eb 20                	jmp    800b59 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800b39:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800b3c:	89 f0                	mov    %esi,%eax
  800b3e:	3c 19                	cmp    $0x19,%al
  800b40:	77 08                	ja     800b4a <strtol+0x97>
			dig = *s - 'a' + 10;
  800b42:	0f be c9             	movsbl %cl,%ecx
  800b45:	83 e9 57             	sub    $0x57,%ecx
  800b48:	eb 0f                	jmp    800b59 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800b4a:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800b4d:	89 f0                	mov    %esi,%eax
  800b4f:	3c 19                	cmp    $0x19,%al
  800b51:	77 16                	ja     800b69 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800b53:	0f be c9             	movsbl %cl,%ecx
  800b56:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800b59:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800b5c:	7d 0f                	jge    800b6d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800b5e:	83 c2 01             	add    $0x1,%edx
  800b61:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b65:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b67:	eb bc                	jmp    800b25 <strtol+0x72>
  800b69:	89 d8                	mov    %ebx,%eax
  800b6b:	eb 02                	jmp    800b6f <strtol+0xbc>
  800b6d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b6f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b73:	74 05                	je     800b7a <strtol+0xc7>
		*endptr = (char *) s;
  800b75:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b78:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b7a:	f7 d8                	neg    %eax
  800b7c:	85 ff                	test   %edi,%edi
  800b7e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b81:	5b                   	pop    %ebx
  800b82:	5e                   	pop    %esi
  800b83:	5f                   	pop    %edi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	57                   	push   %edi
  800b8a:	56                   	push   %esi
  800b8b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b94:	8b 55 08             	mov    0x8(%ebp),%edx
  800b97:	89 c3                	mov    %eax,%ebx
  800b99:	89 c7                	mov    %eax,%edi
  800b9b:	89 c6                	mov    %eax,%esi
  800b9d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800baa:	ba 00 00 00 00       	mov    $0x0,%edx
  800baf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bb4:	89 d1                	mov    %edx,%ecx
  800bb6:	89 d3                	mov    %edx,%ebx
  800bb8:	89 d7                	mov    %edx,%edi
  800bba:	89 d6                	mov    %edx,%esi
  800bbc:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bbe:	5b                   	pop    %ebx
  800bbf:	5e                   	pop    %esi
  800bc0:	5f                   	pop    %edi
  800bc1:	5d                   	pop    %ebp
  800bc2:	c3                   	ret    

00800bc3 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bc3:	55                   	push   %ebp
  800bc4:	89 e5                	mov    %esp,%ebp
  800bc6:	57                   	push   %edi
  800bc7:	56                   	push   %esi
  800bc8:	53                   	push   %ebx
  800bc9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bcc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd1:	b8 03 00 00 00       	mov    $0x3,%eax
  800bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd9:	89 cb                	mov    %ecx,%ebx
  800bdb:	89 cf                	mov    %ecx,%edi
  800bdd:	89 ce                	mov    %ecx,%esi
  800bdf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800be1:	85 c0                	test   %eax,%eax
  800be3:	7e 28                	jle    800c0d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800be5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800be9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800bf0:	00 
  800bf1:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800bf8:	00 
  800bf9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c00:	00 
  800c01:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800c08:	e8 89 1a 00 00       	call   802696 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c0d:	83 c4 2c             	add    $0x2c,%esp
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	57                   	push   %edi
  800c19:	56                   	push   %esi
  800c1a:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c20:	b8 02 00 00 00       	mov    $0x2,%eax
  800c25:	89 d1                	mov    %edx,%ecx
  800c27:	89 d3                	mov    %edx,%ebx
  800c29:	89 d7                	mov    %edx,%edi
  800c2b:	89 d6                	mov    %edx,%esi
  800c2d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c2f:	5b                   	pop    %ebx
  800c30:	5e                   	pop    %esi
  800c31:	5f                   	pop    %edi
  800c32:	5d                   	pop    %ebp
  800c33:	c3                   	ret    

00800c34 <sys_yield>:

void
sys_yield(void)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	57                   	push   %edi
  800c38:	56                   	push   %esi
  800c39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c44:	89 d1                	mov    %edx,%ecx
  800c46:	89 d3                	mov    %edx,%ebx
  800c48:	89 d7                	mov    %edx,%edi
  800c4a:	89 d6                	mov    %edx,%esi
  800c4c:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4e:	5b                   	pop    %ebx
  800c4f:	5e                   	pop    %esi
  800c50:	5f                   	pop    %edi
  800c51:	5d                   	pop    %ebp
  800c52:	c3                   	ret    

00800c53 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	57                   	push   %edi
  800c57:	56                   	push   %esi
  800c58:	53                   	push   %ebx
  800c59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c5c:	be 00 00 00 00       	mov    $0x0,%esi
  800c61:	b8 04 00 00 00       	mov    $0x4,%eax
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6f:	89 f7                	mov    %esi,%edi
  800c71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c73:	85 c0                	test   %eax,%eax
  800c75:	7e 28                	jle    800c9f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c7b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c82:	00 
  800c83:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800c8a:	00 
  800c8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c92:	00 
  800c93:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800c9a:	e8 f7 19 00 00       	call   802696 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c9f:	83 c4 2c             	add    $0x2c,%esp
  800ca2:	5b                   	pop    %ebx
  800ca3:	5e                   	pop    %esi
  800ca4:	5f                   	pop    %edi
  800ca5:	5d                   	pop    %ebp
  800ca6:	c3                   	ret    

00800ca7 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	57                   	push   %edi
  800cab:	56                   	push   %esi
  800cac:	53                   	push   %ebx
  800cad:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb0:	b8 05 00 00 00       	mov    $0x5,%eax
  800cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cbe:	8b 7d 14             	mov    0x14(%ebp),%edi
  800cc1:	8b 75 18             	mov    0x18(%ebp),%esi
  800cc4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cc6:	85 c0                	test   %eax,%eax
  800cc8:	7e 28                	jle    800cf2 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cca:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cce:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800cd5:	00 
  800cd6:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800cdd:	00 
  800cde:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ce5:	00 
  800ce6:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800ced:	e8 a4 19 00 00       	call   802696 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cf2:	83 c4 2c             	add    $0x2c,%esp
  800cf5:	5b                   	pop    %ebx
  800cf6:	5e                   	pop    %esi
  800cf7:	5f                   	pop    %edi
  800cf8:	5d                   	pop    %ebp
  800cf9:	c3                   	ret    

00800cfa <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	57                   	push   %edi
  800cfe:	56                   	push   %esi
  800cff:	53                   	push   %ebx
  800d00:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d03:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d08:	b8 06 00 00 00       	mov    $0x6,%eax
  800d0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d10:	8b 55 08             	mov    0x8(%ebp),%edx
  800d13:	89 df                	mov    %ebx,%edi
  800d15:	89 de                	mov    %ebx,%esi
  800d17:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d19:	85 c0                	test   %eax,%eax
  800d1b:	7e 28                	jle    800d45 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d21:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800d28:	00 
  800d29:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800d30:	00 
  800d31:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d38:	00 
  800d39:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800d40:	e8 51 19 00 00       	call   802696 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d45:	83 c4 2c             	add    $0x2c,%esp
  800d48:	5b                   	pop    %ebx
  800d49:	5e                   	pop    %esi
  800d4a:	5f                   	pop    %edi
  800d4b:	5d                   	pop    %ebp
  800d4c:	c3                   	ret    

00800d4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5b:	b8 08 00 00 00       	mov    $0x8,%eax
  800d60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
  800d66:	89 df                	mov    %ebx,%edi
  800d68:	89 de                	mov    %ebx,%esi
  800d6a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7e 28                	jle    800d98 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d74:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d7b:	00 
  800d7c:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800d83:	00 
  800d84:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d8b:	00 
  800d8c:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800d93:	e8 fe 18 00 00       	call   802696 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d98:	83 c4 2c             	add    $0x2c,%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	57                   	push   %edi
  800da4:	56                   	push   %esi
  800da5:	53                   	push   %ebx
  800da6:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dae:	b8 09 00 00 00       	mov    $0x9,%eax
  800db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db6:	8b 55 08             	mov    0x8(%ebp),%edx
  800db9:	89 df                	mov    %ebx,%edi
  800dbb:	89 de                	mov    %ebx,%esi
  800dbd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7e 28                	jle    800deb <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc7:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800dce:	00 
  800dcf:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dde:	00 
  800ddf:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800de6:	e8 ab 18 00 00       	call   802696 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800deb:	83 c4 2c             	add    $0x2c,%esp
  800dee:	5b                   	pop    %ebx
  800def:	5e                   	pop    %esi
  800df0:	5f                   	pop    %edi
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	57                   	push   %edi
  800df7:	56                   	push   %esi
  800df8:	53                   	push   %ebx
  800df9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 df                	mov    %ebx,%edi
  800e0e:	89 de                	mov    %ebx,%esi
  800e10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e12:	85 c0                	test   %eax,%eax
  800e14:	7e 28                	jle    800e3e <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e16:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1a:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e21:	00 
  800e22:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800e29:	00 
  800e2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e31:	00 
  800e32:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800e39:	e8 58 18 00 00       	call   802696 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e3e:	83 c4 2c             	add    $0x2c,%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    

00800e46 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4c:	be 00 00 00 00       	mov    $0x0,%esi
  800e51:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e59:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e62:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e64:	5b                   	pop    %ebx
  800e65:	5e                   	pop    %esi
  800e66:	5f                   	pop    %edi
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	57                   	push   %edi
  800e6d:	56                   	push   %esi
  800e6e:	53                   	push   %ebx
  800e6f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e77:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	89 cb                	mov    %ecx,%ebx
  800e81:	89 cf                	mov    %ecx,%edi
  800e83:	89 ce                	mov    %ecx,%esi
  800e85:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e87:	85 c0                	test   %eax,%eax
  800e89:	7e 28                	jle    800eb3 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e96:	00 
  800e97:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800e9e:	00 
  800e9f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea6:	00 
  800ea7:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800eae:	e8 e3 17 00 00       	call   802696 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb3:	83 c4 2c             	add    $0x2c,%esp
  800eb6:	5b                   	pop    %ebx
  800eb7:	5e                   	pop    %esi
  800eb8:	5f                   	pop    %edi
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec1:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec6:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ecb:	89 d1                	mov    %edx,%ecx
  800ecd:	89 d3                	mov    %edx,%ebx
  800ecf:	89 d7                	mov    %edx,%edi
  800ed1:	89 d6                	mov    %edx,%esi
  800ed3:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
  800ee0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	89 df                	mov    %ebx,%edi
  800ef5:	89 de                	mov    %ebx,%esi
  800ef7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ef9:	85 c0                	test   %eax,%eax
  800efb:	7e 28                	jle    800f25 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800efd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f01:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f08:	00 
  800f09:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800f10:	00 
  800f11:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f18:	00 
  800f19:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800f20:	e8 71 17 00 00       	call   802696 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800f25:	83 c4 2c             	add    $0x2c,%esp
  800f28:	5b                   	pop    %ebx
  800f29:	5e                   	pop    %esi
  800f2a:	5f                   	pop    %edi
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	57                   	push   %edi
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f36:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	89 df                	mov    %ebx,%edi
  800f48:	89 de                	mov    %ebx,%esi
  800f4a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800f4c:	85 c0                	test   %eax,%eax
  800f4e:	7e 28                	jle    800f78 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f50:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f54:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800f5b:	00 
  800f5c:	c7 44 24 08 9f 2d 80 	movl   $0x802d9f,0x8(%esp)
  800f63:	00 
  800f64:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f6b:	00 
  800f6c:	c7 04 24 bc 2d 80 00 	movl   $0x802dbc,(%esp)
  800f73:	e8 1e 17 00 00       	call   802696 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800f78:	83 c4 2c             	add    $0x2c,%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5f                   	pop    %edi
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	53                   	push   %ebx
  800f84:	83 ec 24             	sub    $0x24,%esp
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax

	void *addr = (void *) utf->utf_fault_va;
  800f8a:	8b 10                	mov    (%eax),%edx
	//   You should make three system calls.

	// LAB 4: Your code here.


	uint32_t *pg_aligned_addr = ROUNDDOWN(addr,PGSIZE);
  800f8c:	89 d3                	mov    %edx,%ebx
  800f8e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	uint32_t pg_num = (uint32_t)pg_aligned_addr/PGSIZE;
	if (!((err & FEC_WR) && (uvpt[PGNUM(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW)))
  800f94:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f98:	74 1a                	je     800fb4 <pgfault+0x34>
  800f9a:	c1 ea 0c             	shr    $0xc,%edx
  800f9d:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800fa4:	a8 01                	test   $0x1,%al
  800fa6:	74 0c                	je     800fb4 <pgfault+0x34>
  800fa8:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800faf:	f6 c4 08             	test   $0x8,%ah
  800fb2:	75 1c                	jne    800fd0 <pgfault+0x50>
	{
		panic("Operation was not a write or the page was not a copy on write page");
  800fb4:	c7 44 24 08 cc 2d 80 	movl   $0x802dcc,0x8(%esp)
  800fbb:	00 
  800fbc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  800fc3:	00 
  800fc4:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  800fcb:	e8 c6 16 00 00       	call   802696 <_panic>
	}
	else
	{

		if(sys_page_alloc(0,PFTEMP,PTE_U|PTE_W|PTE_P)<0)
  800fd0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800fd7:	00 
  800fd8:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  800fdf:	00 
  800fe0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fe7:	e8 67 fc ff ff       	call   800c53 <sys_page_alloc>
  800fec:	85 c0                	test   %eax,%eax
  800fee:	79 1c                	jns    80100c <pgfault+0x8c>
      panic("sys_page_alloc fault in pgfault");
  800ff0:	c7 44 24 08 10 2e 80 	movl   $0x802e10,0x8(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800fff:	00 
  801000:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  801007:	e8 8a 16 00 00       	call   802696 <_panic>
		memcpy(PFTEMP,pg_aligned_addr,PGSIZE);
  80100c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801013:	00 
  801014:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801018:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  80101f:	e8 18 fa ff ff       	call   800a3c <memcpy>
		if(sys_page_map(0,PFTEMP,0,pg_aligned_addr,PTE_P|PTE_W|PTE_U))
  801024:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80102b:	00 
  80102c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801030:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801037:	00 
  801038:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80103f:	00 
  801040:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801047:	e8 5b fc ff ff       	call   800ca7 <sys_page_map>
  80104c:	85 c0                	test   %eax,%eax
  80104e:	74 1c                	je     80106c <pgfault+0xec>
      panic("sys_page_map fault in pgfault");
  801050:	c7 44 24 08 26 2f 80 	movl   $0x802f26,0x8(%esp)
  801057:	00 
  801058:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80105f:	00 
  801060:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  801067:	e8 2a 16 00 00       	call   802696 <_panic>
    sys_page_unmap(0,PFTEMP);
  80106c:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801073:	00 
  801074:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80107b:	e8 7a fc ff ff       	call   800cfa <sys_page_unmap>
	}
	//panic("pgfault not implemented");
}
  801080:	83 c4 24             	add    $0x24,%esp
  801083:	5b                   	pop    %ebx
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    

00801086 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	57                   	push   %edi
  80108a:	56                   	push   %esi
  80108b:	53                   	push   %ebx
  80108c:	83 ec 2c             	sub    $0x2c,%esp
	// LAB 4: Your code here.


	unsigned i;
	set_pgfault_handler(pgfault);
  80108f:	c7 04 24 80 0f 80 00 	movl   $0x800f80,(%esp)
  801096:	e8 51 16 00 00       	call   8026ec <set_pgfault_handler>
// This must be inlined.  Exercise for reader: why?
static __inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80109b:	b8 07 00 00 00       	mov    $0x7,%eax
  8010a0:	cd 30                	int    $0x30
  8010a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010a5:	89 c7                	mov    %eax,%edi
	int child ;
	child = sys_exofork();
	if(child==0)
  8010a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ac:	85 c0                	test   %eax,%eax
  8010ae:	75 21                	jne    8010d1 <fork+0x4b>
	{
		thisenv = &envs[ENVX(sys_getenvid())];
  8010b0:	e8 60 fb ff ff       	call   800c15 <sys_getenvid>
  8010b5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010ba:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8010bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8010c2:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8010c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cc:	e9 de 01 00 00       	jmp    8012af <fork+0x229>
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
  8010d1:	89 d8                	mov    %ebx,%eax
  8010d3:	c1 e8 16             	shr    $0x16,%eax
  8010d6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010dd:	a8 01                	test   $0x1,%al
  8010df:	0f 84 58 01 00 00    	je     80123d <fork+0x1b7>
  8010e5:	89 de                	mov    %ebx,%esi
  8010e7:	c1 ee 0c             	shr    $0xc,%esi
  8010ea:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  8010f1:	83 e0 05             	and    $0x5,%eax
  8010f4:	83 f8 05             	cmp    $0x5,%eax
  8010f7:	0f 85 40 01 00 00    	jne    80123d <fork+0x1b7>
{


	//cprintf("in duppage\n");
	int r;	
	if((uvpt[pn]&PTE_SHARE))
  8010fd:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801104:	f6 c4 04             	test   $0x4,%ah
  801107:	74 4f                	je     801158 <fork+0xd2>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),uvpt[pn]&PTE_SYSCALL)<0)
  801109:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  801110:	c1 e6 0c             	shl    $0xc,%esi
  801113:	25 07 0e 00 00       	and    $0xe07,%eax
  801118:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111c:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801120:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801124:	89 74 24 04          	mov    %esi,0x4(%esp)
  801128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80112f:	e8 73 fb ff ff       	call   800ca7 <sys_page_map>
  801134:	85 c0                	test   %eax,%eax
  801136:	0f 89 01 01 00 00    	jns    80123d <fork+0x1b7>
			panic("sys_page_map fault for parent to child map in dupage");
  80113c:	c7 44 24 08 30 2e 80 	movl   $0x802e30,0x8(%esp)
  801143:	00 
  801144:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
  80114b:	00 
  80114c:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  801153:	e8 3e 15 00 00       	call   802696 <_panic>
	}
	else
	{
	if((uvpt[pn]&PTE_W)||(uvpt[pn]&PTE_COW))
  801158:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80115f:	a8 02                	test   $0x2,%al
  801161:	75 10                	jne    801173 <fork+0xed>
  801163:	8b 04 b5 00 00 40 ef 	mov    -0x10c00000(,%esi,4),%eax
  80116a:	f6 c4 08             	test   $0x8,%ah
  80116d:	0f 84 87 00 00 00    	je     8011fa <fork+0x174>
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P )<0)
  801173:	c1 e6 0c             	shl    $0xc,%esi
  801176:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  80117d:	00 
  80117e:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801182:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801186:	89 74 24 04          	mov    %esi,0x4(%esp)
  80118a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801191:	e8 11 fb ff ff       	call   800ca7 <sys_page_map>
  801196:	85 c0                	test   %eax,%eax
  801198:	79 1c                	jns    8011b6 <fork+0x130>
      panic("sys_page_map fault for parent to child map in duppage");
  80119a:	c7 44 24 08 68 2e 80 	movl   $0x802e68,0x8(%esp)
  8011a1:	00 
  8011a2:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8011a9:	00 
  8011aa:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  8011b1:	e8 e0 14 00 00       	call   802696 <_panic>
		if(sys_page_map(0,(void*)(pn*PGSIZE),0,(void*)(pn*PGSIZE),PTE_U | PTE_COW | PTE_P)<0)
  8011b6:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011bd:	00 
  8011be:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011c2:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011c9:	00 
  8011ca:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d5:	e8 cd fa ff ff       	call   800ca7 <sys_page_map>
  8011da:	85 c0                	test   %eax,%eax
  8011dc:	79 5f                	jns    80123d <fork+0x1b7>
      panic("sys_page_map fault for child in dupage");
  8011de:	c7 44 24 08 a0 2e 80 	movl   $0x802ea0,0x8(%esp)
  8011e5:	00 
  8011e6:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
  8011ed:	00 
  8011ee:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  8011f5:	e8 9c 14 00 00       	call   802696 <_panic>
	}

	else
	{
		if(sys_page_map(0,(void*)(pn*PGSIZE),envid,(void*)(pn*PGSIZE),PTE_U|PTE_P))
  8011fa:	c1 e6 0c             	shl    $0xc,%esi
  8011fd:	c7 44 24 10 05 00 00 	movl   $0x5,0x10(%esp)
  801204:	00 
  801205:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801209:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80120d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801211:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801218:	e8 8a fa ff ff       	call   800ca7 <sys_page_map>
  80121d:	85 c0                	test   %eax,%eax
  80121f:	74 1c                	je     80123d <fork+0x1b7>
    {
      panic("sys_page_map fault for readonly page map in dupage\n");
  801221:	c7 44 24 08 c8 2e 80 	movl   $0x802ec8,0x8(%esp)
  801228:	00 
  801229:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801230:	00 
  801231:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  801238:	e8 59 14 00 00       	call   802696 <_panic>
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}
	else
	{
		for(i=0;i<(UTOP-PGSIZE);i=i+PGSIZE)
  80123d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801243:	81 fb 00 f0 bf ee    	cmp    $0xeebff000,%ebx
  801249:	0f 85 82 fe ff ff    	jne    8010d1 <fork+0x4b>
		{
			if(((uvpd[PDX(i)] & PTE_P) == PTE_P)&&((uvpt[i/PGSIZE] & (PTE_P|PTE_U)) == (PTE_P|PTE_U)))
				duppage(child,i/PGSIZE);
		}
		if(sys_page_alloc(child,(void*)(UXSTACKTOP-PGSIZE),PTE_P|PTE_U|PTE_W)<0)
  80124f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801256:	00 
  801257:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80125e:	ee 
  80125f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801262:	89 04 24             	mov    %eax,(%esp)
  801265:	e8 e9 f9 ff ff       	call   800c53 <sys_page_alloc>
  80126a:	85 c0                	test   %eax,%eax
  80126c:	79 1c                	jns    80128a <fork+0x204>
      panic("sys_page_alloc failure in fork");
  80126e:	c7 44 24 08 fc 2e 80 	movl   $0x802efc,0x8(%esp)
  801275:	00 
  801276:	c7 44 24 04 95 00 00 	movl   $0x95,0x4(%esp)
  80127d:	00 
  80127e:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  801285:	e8 0c 14 00 00       	call   802696 <_panic>
		sys_env_set_pgfault_upcall(child, (void*) _pgfault_upcall);
  80128a:	c7 44 24 04 5d 27 80 	movl   $0x80275d,0x4(%esp)
  801291:	00 
  801292:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801295:	89 3c 24             	mov    %edi,(%esp)
  801298:	e8 56 fb ff ff       	call   800df3 <sys_env_set_pgfault_upcall>
		sys_env_set_status(child,ENV_RUNNABLE);
  80129d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  8012a4:	00 
  8012a5:	89 3c 24             	mov    %edi,(%esp)
  8012a8:	e8 a0 fa ff ff       	call   800d4d <sys_env_set_status>
		return child;
  8012ad:	89 f8                	mov    %edi,%eax
	}
	//panic("fork not implemented");

}
  8012af:	83 c4 2c             	add    $0x2c,%esp
  8012b2:	5b                   	pop    %ebx
  8012b3:	5e                   	pop    %esi
  8012b4:	5f                   	pop    %edi
  8012b5:	5d                   	pop    %ebp
  8012b6:	c3                   	ret    

008012b7 <sfork>:

// Challenge!
int
sfork(void)
{
  8012b7:	55                   	push   %ebp
  8012b8:	89 e5                	mov    %esp,%ebp
  8012ba:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012bd:	c7 44 24 08 44 2f 80 	movl   $0x802f44,0x8(%esp)
  8012c4:	00 
  8012c5:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  8012cc:	00 
  8012cd:	c7 04 24 1b 2f 80 00 	movl   $0x802f1b,(%esp)
  8012d4:	e8 bd 13 00 00       	call   802696 <_panic>

008012d9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	56                   	push   %esi
  8012dd:	53                   	push   %ebx
  8012de:	83 ec 10             	sub    $0x10,%esp
  8012e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e7:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8012ea:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8012ec:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8012f1:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8012f4:	89 04 24             	mov    %eax,(%esp)
  8012f7:	e8 6d fb ff ff       	call   800e69 <sys_ipc_recv>
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 1e                	jne    80131e <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  801300:	85 db                	test   %ebx,%ebx
  801302:	74 0a                	je     80130e <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  801304:	a1 08 50 80 00       	mov    0x805008,%eax
  801309:	8b 40 74             	mov    0x74(%eax),%eax
  80130c:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  80130e:	85 f6                	test   %esi,%esi
  801310:	74 22                	je     801334 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  801312:	a1 08 50 80 00       	mov    0x805008,%eax
  801317:	8b 40 78             	mov    0x78(%eax),%eax
  80131a:	89 06                	mov    %eax,(%esi)
  80131c:	eb 16                	jmp    801334 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  80131e:	85 f6                	test   %esi,%esi
  801320:	74 06                	je     801328 <ipc_recv+0x4f>
				*perm_store = 0;
  801322:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  801328:	85 db                	test   %ebx,%ebx
  80132a:	74 10                	je     80133c <ipc_recv+0x63>
				*from_env_store=0;
  80132c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801332:	eb 08                	jmp    80133c <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  801334:	a1 08 50 80 00       	mov    0x805008,%eax
  801339:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80133c:	83 c4 10             	add    $0x10,%esp
  80133f:	5b                   	pop    %ebx
  801340:	5e                   	pop    %esi
  801341:	5d                   	pop    %ebp
  801342:	c3                   	ret    

00801343 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801343:	55                   	push   %ebp
  801344:	89 e5                	mov    %esp,%ebp
  801346:	57                   	push   %edi
  801347:	56                   	push   %esi
  801348:	53                   	push   %ebx
  801349:	83 ec 1c             	sub    $0x1c,%esp
  80134c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80134f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801352:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  801355:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  801357:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80135c:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80135f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801363:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801367:	89 74 24 04          	mov    %esi,0x4(%esp)
  80136b:	8b 45 08             	mov    0x8(%ebp),%eax
  80136e:	89 04 24             	mov    %eax,(%esp)
  801371:	e8 d0 fa ff ff       	call   800e46 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  801376:	eb 1c                	jmp    801394 <ipc_send+0x51>
	{
		sys_yield();
  801378:	e8 b7 f8 ff ff       	call   800c34 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  80137d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801381:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801385:	89 74 24 04          	mov    %esi,0x4(%esp)
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	89 04 24             	mov    %eax,(%esp)
  80138f:	e8 b2 fa ff ff       	call   800e46 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  801394:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801397:	74 df                	je     801378 <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  801399:	83 c4 1c             	add    $0x1c,%esp
  80139c:	5b                   	pop    %ebx
  80139d:	5e                   	pop    %esi
  80139e:	5f                   	pop    %edi
  80139f:	5d                   	pop    %ebp
  8013a0:	c3                   	ret    

008013a1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8013a1:	55                   	push   %ebp
  8013a2:	89 e5                	mov    %esp,%ebp
  8013a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8013a7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8013ac:	6b d0 7c             	imul   $0x7c,%eax,%edx
  8013af:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8013b5:	8b 52 50             	mov    0x50(%edx),%edx
  8013b8:	39 ca                	cmp    %ecx,%edx
  8013ba:	75 0d                	jne    8013c9 <ipc_find_env+0x28>
			return envs[i].env_id;
  8013bc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8013bf:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8013c4:	8b 40 40             	mov    0x40(%eax),%eax
  8013c7:	eb 0e                	jmp    8013d7 <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8013c9:	83 c0 01             	add    $0x1,%eax
  8013cc:	3d 00 04 00 00       	cmp    $0x400,%eax
  8013d1:	75 d9                	jne    8013ac <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8013d3:	66 b8 00 00          	mov    $0x0,%ax
}
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    
  8013d9:	66 90                	xchg   %ax,%ax
  8013db:	66 90                	xchg   %ax,%ax
  8013dd:	66 90                	xchg   %ax,%ax
  8013df:	90                   	nop

008013e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8013eb:	c1 e8 0c             	shr    $0xc,%eax
}
  8013ee:	5d                   	pop    %ebp
  8013ef:	c3                   	ret    

008013f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  8013fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801400:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    

00801407 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80140d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801412:	89 c2                	mov    %eax,%edx
  801414:	c1 ea 16             	shr    $0x16,%edx
  801417:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80141e:	f6 c2 01             	test   $0x1,%dl
  801421:	74 11                	je     801434 <fd_alloc+0x2d>
  801423:	89 c2                	mov    %eax,%edx
  801425:	c1 ea 0c             	shr    $0xc,%edx
  801428:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80142f:	f6 c2 01             	test   $0x1,%dl
  801432:	75 09                	jne    80143d <fd_alloc+0x36>
			*fd_store = fd;
  801434:	89 01                	mov    %eax,(%ecx)
			return 0;
  801436:	b8 00 00 00 00       	mov    $0x0,%eax
  80143b:	eb 17                	jmp    801454 <fd_alloc+0x4d>
  80143d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801442:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801447:	75 c9                	jne    801412 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801449:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80144f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801454:	5d                   	pop    %ebp
  801455:	c3                   	ret    

00801456 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80145c:	83 f8 1f             	cmp    $0x1f,%eax
  80145f:	77 36                	ja     801497 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801461:	c1 e0 0c             	shl    $0xc,%eax
  801464:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801469:	89 c2                	mov    %eax,%edx
  80146b:	c1 ea 16             	shr    $0x16,%edx
  80146e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801475:	f6 c2 01             	test   $0x1,%dl
  801478:	74 24                	je     80149e <fd_lookup+0x48>
  80147a:	89 c2                	mov    %eax,%edx
  80147c:	c1 ea 0c             	shr    $0xc,%edx
  80147f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801486:	f6 c2 01             	test   $0x1,%dl
  801489:	74 1a                	je     8014a5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80148b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148e:	89 02                	mov    %eax,(%edx)
	return 0;
  801490:	b8 00 00 00 00       	mov    $0x0,%eax
  801495:	eb 13                	jmp    8014aa <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801497:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80149c:	eb 0c                	jmp    8014aa <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80149e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014a3:	eb 05                	jmp    8014aa <fd_lookup+0x54>
  8014a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 18             	sub    $0x18,%esp
  8014b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  8014b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ba:	eb 13                	jmp    8014cf <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  8014bc:	39 08                	cmp    %ecx,(%eax)
  8014be:	75 0c                	jne    8014cc <dev_lookup+0x20>
			*dev = devtab[i];
  8014c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	eb 38                	jmp    801504 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  8014cc:	83 c2 01             	add    $0x1,%edx
  8014cf:	8b 04 95 d8 2f 80 00 	mov    0x802fd8(,%edx,4),%eax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 e2                	jne    8014bc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014da:	a1 08 50 80 00       	mov    0x805008,%eax
  8014df:	8b 40 48             	mov    0x48(%eax),%eax
  8014e2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ea:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  8014f1:	e8 13 ed ff ff       	call   800209 <cprintf>
	*dev = 0;
  8014f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801504:	c9                   	leave  
  801505:	c3                   	ret    

00801506 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	56                   	push   %esi
  80150a:	53                   	push   %ebx
  80150b:	83 ec 20             	sub    $0x20,%esp
  80150e:	8b 75 08             	mov    0x8(%ebp),%esi
  801511:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801514:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801517:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80151b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801521:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 2a ff ff ff       	call   801456 <fd_lookup>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 05                	js     801535 <fd_close+0x2f>
	    || fd != fd2)
  801530:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801533:	74 0c                	je     801541 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801535:	84 db                	test   %bl,%bl
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	0f 44 c2             	cmove  %edx,%eax
  80153f:	eb 3f                	jmp    801580 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801541:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801544:	89 44 24 04          	mov    %eax,0x4(%esp)
  801548:	8b 06                	mov    (%esi),%eax
  80154a:	89 04 24             	mov    %eax,(%esp)
  80154d:	e8 5a ff ff ff       	call   8014ac <dev_lookup>
  801552:	89 c3                	mov    %eax,%ebx
  801554:	85 c0                	test   %eax,%eax
  801556:	78 16                	js     80156e <fd_close+0x68>
		if (dev->dev_close)
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80155e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801563:	85 c0                	test   %eax,%eax
  801565:	74 07                	je     80156e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801567:	89 34 24             	mov    %esi,(%esp)
  80156a:	ff d0                	call   *%eax
  80156c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80156e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801572:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801579:	e8 7c f7 ff ff       	call   800cfa <sys_page_unmap>
	return r;
  80157e:	89 d8                	mov    %ebx,%eax
}
  801580:	83 c4 20             	add    $0x20,%esp
  801583:	5b                   	pop    %ebx
  801584:	5e                   	pop    %esi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801590:	89 44 24 04          	mov    %eax,0x4(%esp)
  801594:	8b 45 08             	mov    0x8(%ebp),%eax
  801597:	89 04 24             	mov    %eax,(%esp)
  80159a:	e8 b7 fe ff ff       	call   801456 <fd_lookup>
  80159f:	89 c2                	mov    %eax,%edx
  8015a1:	85 d2                	test   %edx,%edx
  8015a3:	78 13                	js     8015b8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8015a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015ac:	00 
  8015ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b0:	89 04 24             	mov    %eax,(%esp)
  8015b3:	e8 4e ff ff ff       	call   801506 <fd_close>
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <close_all>:

void
close_all(void)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	53                   	push   %ebx
  8015be:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015c6:	89 1c 24             	mov    %ebx,(%esp)
  8015c9:	e8 b9 ff ff ff       	call   801587 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015ce:	83 c3 01             	add    $0x1,%ebx
  8015d1:	83 fb 20             	cmp    $0x20,%ebx
  8015d4:	75 f0                	jne    8015c6 <close_all+0xc>
		close(i);
}
  8015d6:	83 c4 14             	add    $0x14,%esp
  8015d9:	5b                   	pop    %ebx
  8015da:	5d                   	pop    %ebp
  8015db:	c3                   	ret    

008015dc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015dc:	55                   	push   %ebp
  8015dd:	89 e5                	mov    %esp,%ebp
  8015df:	57                   	push   %edi
  8015e0:	56                   	push   %esi
  8015e1:	53                   	push   %ebx
  8015e2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ef:	89 04 24             	mov    %eax,(%esp)
  8015f2:	e8 5f fe ff ff       	call   801456 <fd_lookup>
  8015f7:	89 c2                	mov    %eax,%edx
  8015f9:	85 d2                	test   %edx,%edx
  8015fb:	0f 88 e1 00 00 00    	js     8016e2 <dup+0x106>
		return r;
	close(newfdnum);
  801601:	8b 45 0c             	mov    0xc(%ebp),%eax
  801604:	89 04 24             	mov    %eax,(%esp)
  801607:	e8 7b ff ff ff       	call   801587 <close>

	newfd = INDEX2FD(newfdnum);
  80160c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80160f:	c1 e3 0c             	shl    $0xc,%ebx
  801612:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161b:	89 04 24             	mov    %eax,(%esp)
  80161e:	e8 cd fd ff ff       	call   8013f0 <fd2data>
  801623:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801625:	89 1c 24             	mov    %ebx,(%esp)
  801628:	e8 c3 fd ff ff       	call   8013f0 <fd2data>
  80162d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80162f:	89 f0                	mov    %esi,%eax
  801631:	c1 e8 16             	shr    $0x16,%eax
  801634:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80163b:	a8 01                	test   $0x1,%al
  80163d:	74 43                	je     801682 <dup+0xa6>
  80163f:	89 f0                	mov    %esi,%eax
  801641:	c1 e8 0c             	shr    $0xc,%eax
  801644:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80164b:	f6 c2 01             	test   $0x1,%dl
  80164e:	74 32                	je     801682 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801650:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801657:	25 07 0e 00 00       	and    $0xe07,%eax
  80165c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801660:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801664:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80166b:	00 
  80166c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801670:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801677:	e8 2b f6 ff ff       	call   800ca7 <sys_page_map>
  80167c:	89 c6                	mov    %eax,%esi
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 3e                	js     8016c0 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801685:	89 c2                	mov    %eax,%edx
  801687:	c1 ea 0c             	shr    $0xc,%edx
  80168a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801691:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801697:	89 54 24 10          	mov    %edx,0x10(%esp)
  80169b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80169f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016a6:	00 
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b2:	e8 f0 f5 ff ff       	call   800ca7 <sys_page_map>
  8016b7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8016b9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8016bc:	85 f6                	test   %esi,%esi
  8016be:	79 22                	jns    8016e2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016cb:	e8 2a f6 ff ff       	call   800cfa <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016d0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016db:	e8 1a f6 ff ff       	call   800cfa <sys_page_unmap>
	return r;
  8016e0:	89 f0                	mov    %esi,%eax
}
  8016e2:	83 c4 3c             	add    $0x3c,%esp
  8016e5:	5b                   	pop    %ebx
  8016e6:	5e                   	pop    %esi
  8016e7:	5f                   	pop    %edi
  8016e8:	5d                   	pop    %ebp
  8016e9:	c3                   	ret    

008016ea <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016ea:	55                   	push   %ebp
  8016eb:	89 e5                	mov    %esp,%ebp
  8016ed:	53                   	push   %ebx
  8016ee:	83 ec 24             	sub    $0x24,%esp
  8016f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016fb:	89 1c 24             	mov    %ebx,(%esp)
  8016fe:	e8 53 fd ff ff       	call   801456 <fd_lookup>
  801703:	89 c2                	mov    %eax,%edx
  801705:	85 d2                	test   %edx,%edx
  801707:	78 6d                	js     801776 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801709:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80170c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801713:	8b 00                	mov    (%eax),%eax
  801715:	89 04 24             	mov    %eax,(%esp)
  801718:	e8 8f fd ff ff       	call   8014ac <dev_lookup>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 55                	js     801776 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	8b 50 08             	mov    0x8(%eax),%edx
  801727:	83 e2 03             	and    $0x3,%edx
  80172a:	83 fa 01             	cmp    $0x1,%edx
  80172d:	75 23                	jne    801752 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80172f:	a1 08 50 80 00       	mov    0x805008,%eax
  801734:	8b 40 48             	mov    0x48(%eax),%eax
  801737:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80173b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173f:	c7 04 24 9d 2f 80 00 	movl   $0x802f9d,(%esp)
  801746:	e8 be ea ff ff       	call   800209 <cprintf>
		return -E_INVAL;
  80174b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801750:	eb 24                	jmp    801776 <read+0x8c>
	}
	if (!dev->dev_read)
  801752:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801755:	8b 52 08             	mov    0x8(%edx),%edx
  801758:	85 d2                	test   %edx,%edx
  80175a:	74 15                	je     801771 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80175c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80175f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801763:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801766:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80176a:	89 04 24             	mov    %eax,(%esp)
  80176d:	ff d2                	call   *%edx
  80176f:	eb 05                	jmp    801776 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801771:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801776:	83 c4 24             	add    $0x24,%esp
  801779:	5b                   	pop    %ebx
  80177a:	5d                   	pop    %ebp
  80177b:	c3                   	ret    

0080177c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80177c:	55                   	push   %ebp
  80177d:	89 e5                	mov    %esp,%ebp
  80177f:	57                   	push   %edi
  801780:	56                   	push   %esi
  801781:	53                   	push   %ebx
  801782:	83 ec 1c             	sub    $0x1c,%esp
  801785:	8b 7d 08             	mov    0x8(%ebp),%edi
  801788:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80178b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801790:	eb 23                	jmp    8017b5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801792:	89 f0                	mov    %esi,%eax
  801794:	29 d8                	sub    %ebx,%eax
  801796:	89 44 24 08          	mov    %eax,0x8(%esp)
  80179a:	89 d8                	mov    %ebx,%eax
  80179c:	03 45 0c             	add    0xc(%ebp),%eax
  80179f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a3:	89 3c 24             	mov    %edi,(%esp)
  8017a6:	e8 3f ff ff ff       	call   8016ea <read>
		if (m < 0)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	78 10                	js     8017bf <readn+0x43>
			return m;
		if (m == 0)
  8017af:	85 c0                	test   %eax,%eax
  8017b1:	74 0a                	je     8017bd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017b3:	01 c3                	add    %eax,%ebx
  8017b5:	39 f3                	cmp    %esi,%ebx
  8017b7:	72 d9                	jb     801792 <readn+0x16>
  8017b9:	89 d8                	mov    %ebx,%eax
  8017bb:	eb 02                	jmp    8017bf <readn+0x43>
  8017bd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8017bf:	83 c4 1c             	add    $0x1c,%esp
  8017c2:	5b                   	pop    %ebx
  8017c3:	5e                   	pop    %esi
  8017c4:	5f                   	pop    %edi
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	53                   	push   %ebx
  8017cb:	83 ec 24             	sub    $0x24,%esp
  8017ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	89 1c 24             	mov    %ebx,(%esp)
  8017db:	e8 76 fc ff ff       	call   801456 <fd_lookup>
  8017e0:	89 c2                	mov    %eax,%edx
  8017e2:	85 d2                	test   %edx,%edx
  8017e4:	78 68                	js     80184e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f0:	8b 00                	mov    (%eax),%eax
  8017f2:	89 04 24             	mov    %eax,(%esp)
  8017f5:	e8 b2 fc ff ff       	call   8014ac <dev_lookup>
  8017fa:	85 c0                	test   %eax,%eax
  8017fc:	78 50                	js     80184e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801801:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801805:	75 23                	jne    80182a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801807:	a1 08 50 80 00       	mov    0x805008,%eax
  80180c:	8b 40 48             	mov    0x48(%eax),%eax
  80180f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801813:	89 44 24 04          	mov    %eax,0x4(%esp)
  801817:	c7 04 24 b9 2f 80 00 	movl   $0x802fb9,(%esp)
  80181e:	e8 e6 e9 ff ff       	call   800209 <cprintf>
		return -E_INVAL;
  801823:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801828:	eb 24                	jmp    80184e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80182a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182d:	8b 52 0c             	mov    0xc(%edx),%edx
  801830:	85 d2                	test   %edx,%edx
  801832:	74 15                	je     801849 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801834:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801837:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80183b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801842:	89 04 24             	mov    %eax,(%esp)
  801845:	ff d2                	call   *%edx
  801847:	eb 05                	jmp    80184e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801849:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80184e:	83 c4 24             	add    $0x24,%esp
  801851:	5b                   	pop    %ebx
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    

00801854 <seek>:

int
seek(int fdnum, off_t offset)
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80185a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	89 04 24             	mov    %eax,(%esp)
  801867:	e8 ea fb ff ff       	call   801456 <fd_lookup>
  80186c:	85 c0                	test   %eax,%eax
  80186e:	78 0e                	js     80187e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801870:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801879:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	53                   	push   %ebx
  801884:	83 ec 24             	sub    $0x24,%esp
  801887:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801891:	89 1c 24             	mov    %ebx,(%esp)
  801894:	e8 bd fb ff ff       	call   801456 <fd_lookup>
  801899:	89 c2                	mov    %eax,%edx
  80189b:	85 d2                	test   %edx,%edx
  80189d:	78 61                	js     801900 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80189f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a9:	8b 00                	mov    (%eax),%eax
  8018ab:	89 04 24             	mov    %eax,(%esp)
  8018ae:	e8 f9 fb ff ff       	call   8014ac <dev_lookup>
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	78 49                	js     801900 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ba:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018be:	75 23                	jne    8018e3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  8018c0:	a1 08 50 80 00       	mov    0x805008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018c5:	8b 40 48             	mov    0x48(%eax),%eax
  8018c8:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	c7 04 24 7c 2f 80 00 	movl   $0x802f7c,(%esp)
  8018d7:	e8 2d e9 ff ff       	call   800209 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8018dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018e1:	eb 1d                	jmp    801900 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8018e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018e6:	8b 52 18             	mov    0x18(%edx),%edx
  8018e9:	85 d2                	test   %edx,%edx
  8018eb:	74 0e                	je     8018fb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018f0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8018f4:	89 04 24             	mov    %eax,(%esp)
  8018f7:	ff d2                	call   *%edx
  8018f9:	eb 05                	jmp    801900 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8018fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801900:	83 c4 24             	add    $0x24,%esp
  801903:	5b                   	pop    %ebx
  801904:	5d                   	pop    %ebp
  801905:	c3                   	ret    

00801906 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 24             	sub    $0x24,%esp
  80190d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801910:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801913:	89 44 24 04          	mov    %eax,0x4(%esp)
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	89 04 24             	mov    %eax,(%esp)
  80191d:	e8 34 fb ff ff       	call   801456 <fd_lookup>
  801922:	89 c2                	mov    %eax,%edx
  801924:	85 d2                	test   %edx,%edx
  801926:	78 52                	js     80197a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801932:	8b 00                	mov    (%eax),%eax
  801934:	89 04 24             	mov    %eax,(%esp)
  801937:	e8 70 fb ff ff       	call   8014ac <dev_lookup>
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 3a                	js     80197a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801943:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801947:	74 2c                	je     801975 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801949:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80194c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801953:	00 00 00 
	stat->st_isdir = 0;
  801956:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80195d:	00 00 00 
	stat->st_dev = dev;
  801960:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801966:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80196a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196d:	89 14 24             	mov    %edx,(%esp)
  801970:	ff 50 14             	call   *0x14(%eax)
  801973:	eb 05                	jmp    80197a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801975:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80197a:	83 c4 24             	add    $0x24,%esp
  80197d:	5b                   	pop    %ebx
  80197e:	5d                   	pop    %ebp
  80197f:	c3                   	ret    

00801980 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
  801985:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801988:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80198f:	00 
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	89 04 24             	mov    %eax,(%esp)
  801996:	e8 28 02 00 00       	call   801bc3 <open>
  80199b:	89 c3                	mov    %eax,%ebx
  80199d:	85 db                	test   %ebx,%ebx
  80199f:	78 1b                	js     8019bc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8019a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a8:	89 1c 24             	mov    %ebx,(%esp)
  8019ab:	e8 56 ff ff ff       	call   801906 <fstat>
  8019b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8019b2:	89 1c 24             	mov    %ebx,(%esp)
  8019b5:	e8 cd fb ff ff       	call   801587 <close>
	return r;
  8019ba:	89 f0                	mov    %esi,%eax
}
  8019bc:	83 c4 10             	add    $0x10,%esp
  8019bf:	5b                   	pop    %ebx
  8019c0:	5e                   	pop    %esi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	56                   	push   %esi
  8019c7:	53                   	push   %ebx
  8019c8:	83 ec 10             	sub    $0x10,%esp
  8019cb:	89 c6                	mov    %eax,%esi
  8019cd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8019cf:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8019d6:	75 11                	jne    8019e9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8019df:	e8 bd f9 ff ff       	call   8013a1 <ipc_find_env>
  8019e4:	a3 00 50 80 00       	mov    %eax,0x805000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8019e9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8019f0:	00 
  8019f1:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8019f8:	00 
  8019f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019fd:	a1 00 50 80 00       	mov    0x805000,%eax
  801a02:	89 04 24             	mov    %eax,(%esp)
  801a05:	e8 39 f9 ff ff       	call   801343 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a0a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a11:	00 
  801a12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a1d:	e8 b7 f8 ff ff       	call   8012d9 <ipc_recv>
}
  801a22:	83 c4 10             	add    $0x10,%esp
  801a25:	5b                   	pop    %ebx
  801a26:	5e                   	pop    %esi
  801a27:	5d                   	pop    %ebp
  801a28:	c3                   	ret    

00801a29 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	8b 40 0c             	mov    0xc(%eax),%eax
  801a35:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3d:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801a42:	ba 00 00 00 00       	mov    $0x0,%edx
  801a47:	b8 02 00 00 00       	mov    $0x2,%eax
  801a4c:	e8 72 ff ff ff       	call   8019c3 <fsipc>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	8b 40 0c             	mov    0xc(%eax),%eax
  801a5f:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 06 00 00 00       	mov    $0x6,%eax
  801a6e:	e8 50 ff ff ff       	call   8019c3 <fsipc>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	53                   	push   %ebx
  801a79:	83 ec 14             	sub    $0x14,%esp
  801a7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	8b 40 0c             	mov    0xc(%eax),%eax
  801a85:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801a8f:	b8 05 00 00 00       	mov    $0x5,%eax
  801a94:	e8 2a ff ff ff       	call   8019c3 <fsipc>
  801a99:	89 c2                	mov    %eax,%edx
  801a9b:	85 d2                	test   %edx,%edx
  801a9d:	78 2b                	js     801aca <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a9f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801aa6:	00 
  801aa7:	89 1c 24             	mov    %ebx,(%esp)
  801aaa:	e8 88 ed ff ff       	call   800837 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801aaf:	a1 80 60 80 00       	mov    0x806080,%eax
  801ab4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801aba:	a1 84 60 80 00       	mov    0x806084,%eax
  801abf:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801ac5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801aca:	83 c4 14             	add    $0x14,%esp
  801acd:	5b                   	pop    %ebx
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    

00801ad0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 18             	sub    $0x18,%esp
  801ad6:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801ade:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801ae3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801ae6:	a3 04 60 80 00       	mov    %eax,0x806004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  801aeb:	8b 55 08             	mov    0x8(%ebp),%edx
  801aee:	8b 52 0c             	mov    0xc(%edx),%edx
  801af1:	89 15 00 60 80 00    	mov    %edx,0x806000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b02:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  801b09:	e8 c6 ee ff ff       	call   8009d4 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  801b0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b13:	b8 04 00 00 00       	mov    $0x4,%eax
  801b18:	e8 a6 fe ff ff       	call   8019c3 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 10             	sub    $0x10,%esp
  801b27:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801b30:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801b35:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b3b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b40:	b8 03 00 00 00       	mov    $0x3,%eax
  801b45:	e8 79 fe ff ff       	call   8019c3 <fsipc>
  801b4a:	89 c3                	mov    %eax,%ebx
  801b4c:	85 c0                	test   %eax,%eax
  801b4e:	78 6a                	js     801bba <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801b50:	39 c6                	cmp    %eax,%esi
  801b52:	73 24                	jae    801b78 <devfile_read+0x59>
  801b54:	c7 44 24 0c ec 2f 80 	movl   $0x802fec,0xc(%esp)
  801b5b:	00 
  801b5c:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  801b63:	00 
  801b64:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  801b6b:	00 
  801b6c:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801b73:	e8 1e 0b 00 00       	call   802696 <_panic>
	assert(r <= PGSIZE);
  801b78:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b7d:	7e 24                	jle    801ba3 <devfile_read+0x84>
  801b7f:	c7 44 24 0c 13 30 80 	movl   $0x803013,0xc(%esp)
  801b86:	00 
  801b87:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  801b8e:	00 
  801b8f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801b96:	00 
  801b97:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801b9e:	e8 f3 0a 00 00       	call   802696 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801ba3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bae:	00 
  801baf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb2:	89 04 24             	mov    %eax,(%esp)
  801bb5:	e8 1a ee ff ff       	call   8009d4 <memmove>
	return r;
}
  801bba:	89 d8                	mov    %ebx,%eax
  801bbc:	83 c4 10             	add    $0x10,%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5d                   	pop    %ebp
  801bc2:	c3                   	ret    

00801bc3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 24             	sub    $0x24,%esp
  801bca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  801bcd:	89 1c 24             	mov    %ebx,(%esp)
  801bd0:	e8 2b ec ff ff       	call   800800 <strlen>
  801bd5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bda:	7f 60                	jg     801c3c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  801bdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdf:	89 04 24             	mov    %eax,(%esp)
  801be2:	e8 20 f8 ff ff       	call   801407 <fd_alloc>
  801be7:	89 c2                	mov    %eax,%edx
  801be9:	85 d2                	test   %edx,%edx
  801beb:	78 54                	js     801c41 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  801bed:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bf1:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  801bf8:	e8 3a ec ff ff       	call   800837 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c00:	a3 00 64 80 00       	mov    %eax,0x806400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c08:	b8 01 00 00 00       	mov    $0x1,%eax
  801c0d:	e8 b1 fd ff ff       	call   8019c3 <fsipc>
  801c12:	89 c3                	mov    %eax,%ebx
  801c14:	85 c0                	test   %eax,%eax
  801c16:	79 17                	jns    801c2f <open+0x6c>
		fd_close(fd, 0);
  801c18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c1f:	00 
  801c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c23:	89 04 24             	mov    %eax,(%esp)
  801c26:	e8 db f8 ff ff       	call   801506 <fd_close>
		return r;
  801c2b:	89 d8                	mov    %ebx,%eax
  801c2d:	eb 12                	jmp    801c41 <open+0x7e>
	}

	return fd2num(fd);
  801c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 a6 f7 ff ff       	call   8013e0 <fd2num>
  801c3a:	eb 05                	jmp    801c41 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  801c3c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801c41:	83 c4 24             	add    $0x24,%esp
  801c44:	5b                   	pop    %ebx
  801c45:	5d                   	pop    %ebp
  801c46:	c3                   	ret    

00801c47 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c52:	b8 08 00 00 00       	mov    $0x8,%eax
  801c57:	e8 67 fd ff ff       	call   8019c3 <fsipc>
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    
  801c5e:	66 90                	xchg   %ax,%ax

00801c60 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c60:	55                   	push   %ebp
  801c61:	89 e5                	mov    %esp,%ebp
  801c63:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c66:	c7 44 24 04 1f 30 80 	movl   $0x80301f,0x4(%esp)
  801c6d:	00 
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	89 04 24             	mov    %eax,(%esp)
  801c74:	e8 be eb ff ff       	call   800837 <strcpy>
	return 0;
}
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	c9                   	leave  
  801c7f:	c3                   	ret    

00801c80 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	53                   	push   %ebx
  801c84:	83 ec 14             	sub    $0x14,%esp
  801c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801c8a:	89 1c 24             	mov    %ebx,(%esp)
  801c8d:	e8 f2 0a 00 00       	call   802784 <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801c97:	83 f8 01             	cmp    $0x1,%eax
  801c9a:	75 0d                	jne    801ca9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  801c9c:	8b 43 0c             	mov    0xc(%ebx),%eax
  801c9f:	89 04 24             	mov    %eax,(%esp)
  801ca2:	e8 29 03 00 00       	call   801fd0 <nsipc_close>
  801ca7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801ca9:	89 d0                	mov    %edx,%eax
  801cab:	83 c4 14             	add    $0x14,%esp
  801cae:	5b                   	pop    %ebx
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    

00801cb1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cb7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cbe:	00 
  801cbf:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd0:	8b 40 0c             	mov    0xc(%eax),%eax
  801cd3:	89 04 24             	mov    %eax,(%esp)
  801cd6:	e8 f0 03 00 00       	call   8020cb <nsipc_send>
}
  801cdb:	c9                   	leave  
  801cdc:	c3                   	ret    

00801cdd <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ce3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cea:	00 
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	8b 40 0c             	mov    0xc(%eax),%eax
  801cff:	89 04 24             	mov    %eax,(%esp)
  801d02:	e8 44 03 00 00       	call   80204b <nsipc_recv>
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
  801d0c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d0f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d12:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d16:	89 04 24             	mov    %eax,(%esp)
  801d19:	e8 38 f7 ff ff       	call   801456 <fd_lookup>
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 17                	js     801d39 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d25:	8b 0d 20 40 80 00    	mov    0x804020,%ecx
  801d2b:	39 08                	cmp    %ecx,(%eax)
  801d2d:	75 05                	jne    801d34 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801d32:	eb 05                	jmp    801d39 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801d34:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 20             	sub    $0x20,%esp
  801d43:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d45:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d48:	89 04 24             	mov    %eax,(%esp)
  801d4b:	e8 b7 f6 ff ff       	call   801407 <fd_alloc>
  801d50:	89 c3                	mov    %eax,%ebx
  801d52:	85 c0                	test   %eax,%eax
  801d54:	78 21                	js     801d77 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801d56:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d5d:	00 
  801d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6c:	e8 e2 ee ff ff       	call   800c53 <sys_page_alloc>
  801d71:	89 c3                	mov    %eax,%ebx
  801d73:	85 c0                	test   %eax,%eax
  801d75:	79 0c                	jns    801d83 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801d77:	89 34 24             	mov    %esi,(%esp)
  801d7a:	e8 51 02 00 00       	call   801fd0 <nsipc_close>
		return r;
  801d7f:	89 d8                	mov    %ebx,%eax
  801d81:	eb 20                	jmp    801da3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d83:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d91:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801d98:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  801d9b:	89 14 24             	mov    %edx,(%esp)
  801d9e:	e8 3d f6 ff ff       	call   8013e0 <fd2num>
}
  801da3:	83 c4 20             	add    $0x20,%esp
  801da6:	5b                   	pop    %ebx
  801da7:	5e                   	pop    %esi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    

00801daa <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
  801dad:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801db0:	8b 45 08             	mov    0x8(%ebp),%eax
  801db3:	e8 51 ff ff ff       	call   801d09 <fd2sockid>
		return r;
  801db8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 23                	js     801de1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dbe:	8b 55 10             	mov    0x10(%ebp),%edx
  801dc1:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc8:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dcc:	89 04 24             	mov    %eax,(%esp)
  801dcf:	e8 45 01 00 00       	call   801f19 <nsipc_accept>
		return r;
  801dd4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 07                	js     801de1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  801dda:	e8 5c ff ff ff       	call   801d3b <alloc_sockfd>
  801ddf:	89 c1                	mov    %eax,%ecx
}
  801de1:	89 c8                	mov    %ecx,%eax
  801de3:	c9                   	leave  
  801de4:	c3                   	ret    

00801de5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801deb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dee:	e8 16 ff ff ff       	call   801d09 <fd2sockid>
  801df3:	89 c2                	mov    %eax,%edx
  801df5:	85 d2                	test   %edx,%edx
  801df7:	78 16                	js     801e0f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801df9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e00:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e07:	89 14 24             	mov    %edx,(%esp)
  801e0a:	e8 60 01 00 00       	call   801f6f <nsipc_bind>
}
  801e0f:	c9                   	leave  
  801e10:	c3                   	ret    

00801e11 <shutdown>:

int
shutdown(int s, int how)
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e17:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1a:	e8 ea fe ff ff       	call   801d09 <fd2sockid>
  801e1f:	89 c2                	mov    %eax,%edx
  801e21:	85 d2                	test   %edx,%edx
  801e23:	78 0f                	js     801e34 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801e25:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2c:	89 14 24             	mov    %edx,(%esp)
  801e2f:	e8 7a 01 00 00       	call   801fae <nsipc_shutdown>
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3f:	e8 c5 fe ff ff       	call   801d09 <fd2sockid>
  801e44:	89 c2                	mov    %eax,%edx
  801e46:	85 d2                	test   %edx,%edx
  801e48:	78 16                	js     801e60 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801e4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e58:	89 14 24             	mov    %edx,(%esp)
  801e5b:	e8 8a 01 00 00       	call   801fea <nsipc_connect>
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <listen>:

int
listen(int s, int backlog)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	e8 99 fe ff ff       	call   801d09 <fd2sockid>
  801e70:	89 c2                	mov    %eax,%edx
  801e72:	85 d2                	test   %edx,%edx
  801e74:	78 0f                	js     801e85 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7d:	89 14 24             	mov    %edx,(%esp)
  801e80:	e8 a4 01 00 00       	call   802029 <nsipc_listen>
}
  801e85:	c9                   	leave  
  801e86:	c3                   	ret    

00801e87 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801e87:	55                   	push   %ebp
  801e88:	89 e5                	mov    %esp,%ebp
  801e8a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801e8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801e90:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9e:	89 04 24             	mov    %eax,(%esp)
  801ea1:	e8 98 02 00 00       	call   80213e <nsipc_socket>
  801ea6:	89 c2                	mov    %eax,%edx
  801ea8:	85 d2                	test   %edx,%edx
  801eaa:	78 05                	js     801eb1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801eac:	e8 8a fe ff ff       	call   801d3b <alloc_sockfd>
}
  801eb1:	c9                   	leave  
  801eb2:	c3                   	ret    

00801eb3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eb3:	55                   	push   %ebp
  801eb4:	89 e5                	mov    %esp,%ebp
  801eb6:	53                   	push   %ebx
  801eb7:	83 ec 14             	sub    $0x14,%esp
  801eba:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801ebc:	83 3d 04 50 80 00 00 	cmpl   $0x0,0x805004
  801ec3:	75 11                	jne    801ed6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ec5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801ecc:	e8 d0 f4 ff ff       	call   8013a1 <ipc_find_env>
  801ed1:	a3 04 50 80 00       	mov    %eax,0x805004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ed6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801edd:	00 
  801ede:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  801ee5:	00 
  801ee6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eea:	a1 04 50 80 00       	mov    0x805004,%eax
  801eef:	89 04 24             	mov    %eax,(%esp)
  801ef2:	e8 4c f4 ff ff       	call   801343 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ef7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801efe:	00 
  801eff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f06:	00 
  801f07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f0e:	e8 c6 f3 ff ff       	call   8012d9 <ipc_recv>
}
  801f13:	83 c4 14             	add    $0x14,%esp
  801f16:	5b                   	pop    %ebx
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    

00801f19 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	56                   	push   %esi
  801f1d:	53                   	push   %ebx
  801f1e:	83 ec 10             	sub    $0x10,%esp
  801f21:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801f2c:	8b 06                	mov    (%esi),%eax
  801f2e:	a3 04 70 80 00       	mov    %eax,0x807004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801f33:	b8 01 00 00 00       	mov    $0x1,%eax
  801f38:	e8 76 ff ff ff       	call   801eb3 <nsipc>
  801f3d:	89 c3                	mov    %eax,%ebx
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	78 23                	js     801f66 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801f43:	a1 10 70 80 00       	mov    0x807010,%eax
  801f48:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4c:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  801f53:	00 
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	89 04 24             	mov    %eax,(%esp)
  801f5a:	e8 75 ea ff ff       	call   8009d4 <memmove>
		*addrlen = ret->ret_addrlen;
  801f5f:	a1 10 70 80 00       	mov    0x807010,%eax
  801f64:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801f66:	89 d8                	mov    %ebx,%eax
  801f68:	83 c4 10             	add    $0x10,%esp
  801f6b:	5b                   	pop    %ebx
  801f6c:	5e                   	pop    %esi
  801f6d:	5d                   	pop    %ebp
  801f6e:	c3                   	ret    

00801f6f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f6f:	55                   	push   %ebp
  801f70:	89 e5                	mov    %esp,%ebp
  801f72:	53                   	push   %ebx
  801f73:	83 ec 14             	sub    $0x14,%esp
  801f76:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f79:	8b 45 08             	mov    0x8(%ebp),%eax
  801f7c:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8c:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  801f93:	e8 3c ea ff ff       	call   8009d4 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801f98:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  801f9e:	b8 02 00 00 00       	mov    $0x2,%eax
  801fa3:	e8 0b ff ff ff       	call   801eb3 <nsipc>
}
  801fa8:	83 c4 14             	add    $0x14,%esp
  801fab:	5b                   	pop    %ebx
  801fac:	5d                   	pop    %ebp
  801fad:	c3                   	ret    

00801fae <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb7:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  801fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbf:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  801fc4:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc9:	e8 e5 fe ff ff       	call   801eb3 <nsipc>
}
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <nsipc_close>:

int
nsipc_close(int s)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd9:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  801fde:	b8 04 00 00 00       	mov    $0x4,%eax
  801fe3:	e8 cb fe ff ff       	call   801eb3 <nsipc>
}
  801fe8:	c9                   	leave  
  801fe9:	c3                   	ret    

00801fea <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	53                   	push   %ebx
  801fee:	83 ec 14             	sub    $0x14,%esp
  801ff1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ffc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  80200e:	e8 c1 e9 ff ff       	call   8009d4 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802013:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  802019:	b8 05 00 00 00       	mov    $0x5,%eax
  80201e:	e8 90 fe ff ff       	call   801eb3 <nsipc>
}
  802023:	83 c4 14             	add    $0x14,%esp
  802026:	5b                   	pop    %ebx
  802027:	5d                   	pop    %ebp
  802028:	c3                   	ret    

00802029 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  802037:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203a:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  80203f:	b8 06 00 00 00       	mov    $0x6,%eax
  802044:	e8 6a fe ff ff       	call   801eb3 <nsipc>
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	56                   	push   %esi
  80204f:	53                   	push   %ebx
  802050:	83 ec 10             	sub    $0x10,%esp
  802053:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  80205e:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  802064:	8b 45 14             	mov    0x14(%ebp),%eax
  802067:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  80206c:	b8 07 00 00 00       	mov    $0x7,%eax
  802071:	e8 3d fe ff ff       	call   801eb3 <nsipc>
  802076:	89 c3                	mov    %eax,%ebx
  802078:	85 c0                	test   %eax,%eax
  80207a:	78 46                	js     8020c2 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  80207c:	39 f0                	cmp    %esi,%eax
  80207e:	7f 07                	jg     802087 <nsipc_recv+0x3c>
  802080:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802085:	7e 24                	jle    8020ab <nsipc_recv+0x60>
  802087:	c7 44 24 0c 2b 30 80 	movl   $0x80302b,0xc(%esp)
  80208e:	00 
  80208f:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  802096:	00 
  802097:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  80209e:	00 
  80209f:	c7 04 24 40 30 80 00 	movl   $0x803040,(%esp)
  8020a6:	e8 eb 05 00 00       	call   802696 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020af:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8020b6:	00 
  8020b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ba:	89 04 24             	mov    %eax,(%esp)
  8020bd:	e8 12 e9 ff ff       	call   8009d4 <memmove>
	}

	return r;
}
  8020c2:	89 d8                	mov    %ebx,%eax
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	5b                   	pop    %ebx
  8020c8:	5e                   	pop    %esi
  8020c9:	5d                   	pop    %ebp
  8020ca:	c3                   	ret    

008020cb <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	53                   	push   %ebx
  8020cf:	83 ec 14             	sub    $0x14,%esp
  8020d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  8020dd:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8020e3:	7e 24                	jle    802109 <nsipc_send+0x3e>
  8020e5:	c7 44 24 0c 4c 30 80 	movl   $0x80304c,0xc(%esp)
  8020ec:	00 
  8020ed:	c7 44 24 08 f3 2f 80 	movl   $0x802ff3,0x8(%esp)
  8020f4:	00 
  8020f5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  8020fc:	00 
  8020fd:	c7 04 24 40 30 80 00 	movl   $0x803040,(%esp)
  802104:	e8 8d 05 00 00       	call   802696 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802109:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80210d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802110:	89 44 24 04          	mov    %eax,0x4(%esp)
  802114:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80211b:	e8 b4 e8 ff ff       	call   8009d4 <memmove>
	nsipcbuf.send.req_size = size;
  802120:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  802126:	8b 45 14             	mov    0x14(%ebp),%eax
  802129:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  80212e:	b8 08 00 00 00       	mov    $0x8,%eax
  802133:	e8 7b fd ff ff       	call   801eb3 <nsipc>
}
  802138:	83 c4 14             	add    $0x14,%esp
  80213b:	5b                   	pop    %ebx
  80213c:	5d                   	pop    %ebp
  80213d:	c3                   	ret    

0080213e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  80214c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80214f:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  802154:	8b 45 10             	mov    0x10(%ebp),%eax
  802157:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  80215c:	b8 09 00 00 00       	mov    $0x9,%eax
  802161:	e8 4d fd ff ff       	call   801eb3 <nsipc>
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
  80216d:	83 ec 10             	sub    $0x10,%esp
  802170:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802173:	8b 45 08             	mov    0x8(%ebp),%eax
  802176:	89 04 24             	mov    %eax,(%esp)
  802179:	e8 72 f2 ff ff       	call   8013f0 <fd2data>
  80217e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802180:	c7 44 24 04 58 30 80 	movl   $0x803058,0x4(%esp)
  802187:	00 
  802188:	89 1c 24             	mov    %ebx,(%esp)
  80218b:	e8 a7 e6 ff ff       	call   800837 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802190:	8b 46 04             	mov    0x4(%esi),%eax
  802193:	2b 06                	sub    (%esi),%eax
  802195:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  80219b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8021a2:	00 00 00 
	stat->st_dev = &devpipe;
  8021a5:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  8021ac:	40 80 00 
	return 0;
}
  8021af:	b8 00 00 00 00       	mov    $0x0,%eax
  8021b4:	83 c4 10             	add    $0x10,%esp
  8021b7:	5b                   	pop    %ebx
  8021b8:	5e                   	pop    %esi
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    

008021bb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	53                   	push   %ebx
  8021bf:	83 ec 14             	sub    $0x14,%esp
  8021c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021c5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d0:	e8 25 eb ff ff       	call   800cfa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021d5:	89 1c 24             	mov    %ebx,(%esp)
  8021d8:	e8 13 f2 ff ff       	call   8013f0 <fd2data>
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021e8:	e8 0d eb ff ff       	call   800cfa <sys_page_unmap>
}
  8021ed:	83 c4 14             	add    $0x14,%esp
  8021f0:	5b                   	pop    %ebx
  8021f1:	5d                   	pop    %ebp
  8021f2:	c3                   	ret    

008021f3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	57                   	push   %edi
  8021f7:	56                   	push   %esi
  8021f8:	53                   	push   %ebx
  8021f9:	83 ec 2c             	sub    $0x2c,%esp
  8021fc:	89 c6                	mov    %eax,%esi
  8021fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  802201:	a1 08 50 80 00       	mov    0x805008,%eax
  802206:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802209:	89 34 24             	mov    %esi,(%esp)
  80220c:	e8 73 05 00 00       	call   802784 <pageref>
  802211:	89 c7                	mov    %eax,%edi
  802213:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802216:	89 04 24             	mov    %eax,(%esp)
  802219:	e8 66 05 00 00       	call   802784 <pageref>
  80221e:	39 c7                	cmp    %eax,%edi
  802220:	0f 94 c2             	sete   %dl
  802223:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  802226:	8b 0d 08 50 80 00    	mov    0x805008,%ecx
  80222c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  80222f:	39 fb                	cmp    %edi,%ebx
  802231:	74 21                	je     802254 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  802233:	84 d2                	test   %dl,%dl
  802235:	74 ca                	je     802201 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802237:	8b 51 58             	mov    0x58(%ecx),%edx
  80223a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80223e:	89 54 24 08          	mov    %edx,0x8(%esp)
  802242:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802246:	c7 04 24 5f 30 80 00 	movl   $0x80305f,(%esp)
  80224d:	e8 b7 df ff ff       	call   800209 <cprintf>
  802252:	eb ad                	jmp    802201 <_pipeisclosed+0xe>
	}
}
  802254:	83 c4 2c             	add    $0x2c,%esp
  802257:	5b                   	pop    %ebx
  802258:	5e                   	pop    %esi
  802259:	5f                   	pop    %edi
  80225a:	5d                   	pop    %ebp
  80225b:	c3                   	ret    

0080225c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	57                   	push   %edi
  802260:	56                   	push   %esi
  802261:	53                   	push   %ebx
  802262:	83 ec 1c             	sub    $0x1c,%esp
  802265:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802268:	89 34 24             	mov    %esi,(%esp)
  80226b:	e8 80 f1 ff ff       	call   8013f0 <fd2data>
  802270:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802272:	bf 00 00 00 00       	mov    $0x0,%edi
  802277:	eb 45                	jmp    8022be <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802279:	89 da                	mov    %ebx,%edx
  80227b:	89 f0                	mov    %esi,%eax
  80227d:	e8 71 ff ff ff       	call   8021f3 <_pipeisclosed>
  802282:	85 c0                	test   %eax,%eax
  802284:	75 41                	jne    8022c7 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802286:	e8 a9 e9 ff ff       	call   800c34 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80228b:	8b 43 04             	mov    0x4(%ebx),%eax
  80228e:	8b 0b                	mov    (%ebx),%ecx
  802290:	8d 51 20             	lea    0x20(%ecx),%edx
  802293:	39 d0                	cmp    %edx,%eax
  802295:	73 e2                	jae    802279 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80229a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  80229e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  8022a1:	99                   	cltd   
  8022a2:	c1 ea 1b             	shr    $0x1b,%edx
  8022a5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  8022a8:	83 e1 1f             	and    $0x1f,%ecx
  8022ab:	29 d1                	sub    %edx,%ecx
  8022ad:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  8022b1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  8022b5:	83 c0 01             	add    $0x1,%eax
  8022b8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022bb:	83 c7 01             	add    $0x1,%edi
  8022be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8022c1:	75 c8                	jne    80228b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  8022c3:	89 f8                	mov    %edi,%eax
  8022c5:	eb 05                	jmp    8022cc <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  8022c7:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  8022cc:	83 c4 1c             	add    $0x1c,%esp
  8022cf:	5b                   	pop    %ebx
  8022d0:	5e                   	pop    %esi
  8022d1:	5f                   	pop    %edi
  8022d2:	5d                   	pop    %ebp
  8022d3:	c3                   	ret    

008022d4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	57                   	push   %edi
  8022d8:	56                   	push   %esi
  8022d9:	53                   	push   %ebx
  8022da:	83 ec 1c             	sub    $0x1c,%esp
  8022dd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022e0:	89 3c 24             	mov    %edi,(%esp)
  8022e3:	e8 08 f1 ff ff       	call   8013f0 <fd2data>
  8022e8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022ea:	be 00 00 00 00       	mov    $0x0,%esi
  8022ef:	eb 3d                	jmp    80232e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022f1:	85 f6                	test   %esi,%esi
  8022f3:	74 04                	je     8022f9 <devpipe_read+0x25>
				return i;
  8022f5:	89 f0                	mov    %esi,%eax
  8022f7:	eb 43                	jmp    80233c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8022f9:	89 da                	mov    %ebx,%edx
  8022fb:	89 f8                	mov    %edi,%eax
  8022fd:	e8 f1 fe ff ff       	call   8021f3 <_pipeisclosed>
  802302:	85 c0                	test   %eax,%eax
  802304:	75 31                	jne    802337 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802306:	e8 29 e9 ff ff       	call   800c34 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  80230b:	8b 03                	mov    (%ebx),%eax
  80230d:	3b 43 04             	cmp    0x4(%ebx),%eax
  802310:	74 df                	je     8022f1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802312:	99                   	cltd   
  802313:	c1 ea 1b             	shr    $0x1b,%edx
  802316:	01 d0                	add    %edx,%eax
  802318:	83 e0 1f             	and    $0x1f,%eax
  80231b:	29 d0                	sub    %edx,%eax
  80231d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802325:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  802328:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80232b:	83 c6 01             	add    $0x1,%esi
  80232e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802331:	75 d8                	jne    80230b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802333:	89 f0                	mov    %esi,%eax
  802335:	eb 05                	jmp    80233c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  802337:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  80233c:	83 c4 1c             	add    $0x1c,%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80234c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80234f:	89 04 24             	mov    %eax,(%esp)
  802352:	e8 b0 f0 ff ff       	call   801407 <fd_alloc>
  802357:	89 c2                	mov    %eax,%edx
  802359:	85 d2                	test   %edx,%edx
  80235b:	0f 88 4d 01 00 00    	js     8024ae <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802361:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802368:	00 
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802370:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802377:	e8 d7 e8 ff ff       	call   800c53 <sys_page_alloc>
  80237c:	89 c2                	mov    %eax,%edx
  80237e:	85 d2                	test   %edx,%edx
  802380:	0f 88 28 01 00 00    	js     8024ae <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802386:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802389:	89 04 24             	mov    %eax,(%esp)
  80238c:	e8 76 f0 ff ff       	call   801407 <fd_alloc>
  802391:	89 c3                	mov    %eax,%ebx
  802393:	85 c0                	test   %eax,%eax
  802395:	0f 88 fe 00 00 00    	js     802499 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80239b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023a2:	00 
  8023a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b1:	e8 9d e8 ff ff       	call   800c53 <sys_page_alloc>
  8023b6:	89 c3                	mov    %eax,%ebx
  8023b8:	85 c0                	test   %eax,%eax
  8023ba:	0f 88 d9 00 00 00    	js     802499 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 04 24             	mov    %eax,(%esp)
  8023c6:	e8 25 f0 ff ff       	call   8013f0 <fd2data>
  8023cb:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023cd:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d4:	00 
  8023d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e0:	e8 6e e8 ff ff       	call   800c53 <sys_page_alloc>
  8023e5:	89 c3                	mov    %eax,%ebx
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	0f 88 97 00 00 00    	js     802486 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f2:	89 04 24             	mov    %eax,(%esp)
  8023f5:	e8 f6 ef ff ff       	call   8013f0 <fd2data>
  8023fa:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802401:	00 
  802402:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802406:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80240d:	00 
  80240e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802412:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802419:	e8 89 e8 ff ff       	call   800ca7 <sys_page_map>
  80241e:	89 c3                	mov    %eax,%ebx
  802420:	85 c0                	test   %eax,%eax
  802422:	78 52                	js     802476 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802424:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80242a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80242f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802432:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802439:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	89 04 24             	mov    %eax,(%esp)
  802454:	e8 87 ef ff ff       	call   8013e0 <fd2num>
  802459:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80245c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80245e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 77 ef ff ff       	call   8013e0 <fd2num>
  802469:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80246c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80246f:	b8 00 00 00 00       	mov    $0x0,%eax
  802474:	eb 38                	jmp    8024ae <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802476:	89 74 24 04          	mov    %esi,0x4(%esp)
  80247a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802481:	e8 74 e8 ff ff       	call   800cfa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802494:	e8 61 e8 ff ff       	call   800cfa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a7:	e8 4e e8 ff ff       	call   800cfa <sys_page_unmap>
  8024ac:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  8024ae:	83 c4 30             	add    $0x30,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    

008024b5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c5:	89 04 24             	mov    %eax,(%esp)
  8024c8:	e8 89 ef ff ff       	call   801456 <fd_lookup>
  8024cd:	89 c2                	mov    %eax,%edx
  8024cf:	85 d2                	test   %edx,%edx
  8024d1:	78 15                	js     8024e8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	89 04 24             	mov    %eax,(%esp)
  8024d9:	e8 12 ef ff ff       	call   8013f0 <fd2data>
	return _pipeisclosed(fd, p);
  8024de:	89 c2                	mov    %eax,%edx
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	e8 0b fd ff ff       	call   8021f3 <_pipeisclosed>
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    
  8024ea:	66 90                	xchg   %ax,%ax
  8024ec:	66 90                	xchg   %ax,%ax
  8024ee:	66 90                	xchg   %ax,%ax

008024f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    

008024fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024fa:	55                   	push   %ebp
  8024fb:	89 e5                	mov    %esp,%ebp
  8024fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802500:	c7 44 24 04 77 30 80 	movl   $0x803077,0x4(%esp)
  802507:	00 
  802508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80250b:	89 04 24             	mov    %eax,(%esp)
  80250e:	e8 24 e3 ff ff       	call   800837 <strcpy>
	return 0;
}
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	57                   	push   %edi
  80251e:	56                   	push   %esi
  80251f:	53                   	push   %ebx
  802520:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802526:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80252b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802531:	eb 31                	jmp    802564 <devcons_write+0x4a>
		m = n - tot;
  802533:	8b 75 10             	mov    0x10(%ebp),%esi
  802536:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802538:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80253b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802540:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802543:	89 74 24 08          	mov    %esi,0x8(%esp)
  802547:	03 45 0c             	add    0xc(%ebp),%eax
  80254a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254e:	89 3c 24             	mov    %edi,(%esp)
  802551:	e8 7e e4 ff ff       	call   8009d4 <memmove>
		sys_cputs(buf, m);
  802556:	89 74 24 04          	mov    %esi,0x4(%esp)
  80255a:	89 3c 24             	mov    %edi,(%esp)
  80255d:	e8 24 e6 ff ff       	call   800b86 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802562:	01 f3                	add    %esi,%ebx
  802564:	89 d8                	mov    %ebx,%eax
  802566:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802569:	72 c8                	jb     802533 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80256b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    

00802576 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802581:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802585:	75 07                	jne    80258e <devcons_read+0x18>
  802587:	eb 2a                	jmp    8025b3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802589:	e8 a6 e6 ff ff       	call   800c34 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80258e:	66 90                	xchg   %ax,%ax
  802590:	e8 0f e6 ff ff       	call   800ba4 <sys_cgetc>
  802595:	85 c0                	test   %eax,%eax
  802597:	74 f0                	je     802589 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802599:	85 c0                	test   %eax,%eax
  80259b:	78 16                	js     8025b3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80259d:	83 f8 04             	cmp    $0x4,%eax
  8025a0:	74 0c                	je     8025ae <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8025a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a5:	88 02                	mov    %al,(%edx)
	return 1;
  8025a7:	b8 01 00 00 00       	mov    $0x1,%eax
  8025ac:	eb 05                	jmp    8025b3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8025ae:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8025b3:	c9                   	leave  
  8025b4:	c3                   	ret    

008025b5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025c8:	00 
  8025c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025cc:	89 04 24             	mov    %eax,(%esp)
  8025cf:	e8 b2 e5 ff ff       	call   800b86 <sys_cputs>
}
  8025d4:	c9                   	leave  
  8025d5:	c3                   	ret    

008025d6 <getchar>:

int
getchar(void)
{
  8025d6:	55                   	push   %ebp
  8025d7:	89 e5                	mov    %esp,%ebp
  8025d9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8025dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8025e3:	00 
  8025e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025f2:	e8 f3 f0 ff ff       	call   8016ea <read>
	if (r < 0)
  8025f7:	85 c0                	test   %eax,%eax
  8025f9:	78 0f                	js     80260a <getchar+0x34>
		return r;
	if (r < 1)
  8025fb:	85 c0                	test   %eax,%eax
  8025fd:	7e 06                	jle    802605 <getchar+0x2f>
		return -E_EOF;
	return c;
  8025ff:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802603:	eb 05                	jmp    80260a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802605:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80260a:	c9                   	leave  
  80260b:	c3                   	ret    

0080260c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80260c:	55                   	push   %ebp
  80260d:	89 e5                	mov    %esp,%ebp
  80260f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802612:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802615:	89 44 24 04          	mov    %eax,0x4(%esp)
  802619:	8b 45 08             	mov    0x8(%ebp),%eax
  80261c:	89 04 24             	mov    %eax,(%esp)
  80261f:	e8 32 ee ff ff       	call   801456 <fd_lookup>
  802624:	85 c0                	test   %eax,%eax
  802626:	78 11                	js     802639 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802631:	39 10                	cmp    %edx,(%eax)
  802633:	0f 94 c0             	sete   %al
  802636:	0f b6 c0             	movzbl %al,%eax
}
  802639:	c9                   	leave  
  80263a:	c3                   	ret    

0080263b <opencons>:

int
opencons(void)
{
  80263b:	55                   	push   %ebp
  80263c:	89 e5                	mov    %esp,%ebp
  80263e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802641:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802644:	89 04 24             	mov    %eax,(%esp)
  802647:	e8 bb ed ff ff       	call   801407 <fd_alloc>
		return r;
  80264c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80264e:	85 c0                	test   %eax,%eax
  802650:	78 40                	js     802692 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802652:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802659:	00 
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802661:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802668:	e8 e6 e5 ff ff       	call   800c53 <sys_page_alloc>
		return r;
  80266d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80266f:	85 c0                	test   %eax,%eax
  802671:	78 1f                	js     802692 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802673:	8b 15 58 40 80 00    	mov    0x804058,%edx
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802688:	89 04 24             	mov    %eax,(%esp)
  80268b:	e8 50 ed ff ff       	call   8013e0 <fd2num>
  802690:	89 c2                	mov    %eax,%edx
}
  802692:	89 d0                	mov    %edx,%eax
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	56                   	push   %esi
  80269a:	53                   	push   %ebx
  80269b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80269e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8026a1:	8b 35 00 40 80 00    	mov    0x804000,%esi
  8026a7:	e8 69 e5 ff ff       	call   800c15 <sys_getenvid>
  8026ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026af:	89 54 24 10          	mov    %edx,0x10(%esp)
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8026ba:	89 74 24 08          	mov    %esi,0x8(%esp)
  8026be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c2:	c7 04 24 84 30 80 00 	movl   $0x803084,(%esp)
  8026c9:	e8 3b db ff ff       	call   800209 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8026ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8026d5:	89 04 24             	mov    %eax,(%esp)
  8026d8:	e8 cb da ff ff       	call   8001a8 <vcprintf>
	cprintf("\n");
  8026dd:	c7 04 24 70 30 80 00 	movl   $0x803070,(%esp)
  8026e4:	e8 20 db ff ff       	call   800209 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8026e9:	cc                   	int3   
  8026ea:	eb fd                	jmp    8026e9 <_panic+0x53>

008026ec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026f2:	83 3d 00 80 80 00 00 	cmpl   $0x0,0x808000
  8026f9:	75 58                	jne    802753 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  8026fb:	a1 08 50 80 00       	mov    0x805008,%eax
  802700:	8b 40 48             	mov    0x48(%eax),%eax
  802703:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80270a:	00 
  80270b:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802712:	ee 
  802713:	89 04 24             	mov    %eax,(%esp)
  802716:	e8 38 e5 ff ff       	call   800c53 <sys_page_alloc>
		if(return_code!=0)
  80271b:	85 c0                	test   %eax,%eax
  80271d:	74 1c                	je     80273b <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  80271f:	c7 44 24 08 a8 30 80 	movl   $0x8030a8,0x8(%esp)
  802726:	00 
  802727:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80272e:	00 
  80272f:	c7 04 24 04 31 80 00 	movl   $0x803104,(%esp)
  802736:	e8 5b ff ff ff       	call   802696 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  80273b:	a1 08 50 80 00       	mov    0x805008,%eax
  802740:	8b 40 48             	mov    0x48(%eax),%eax
  802743:	c7 44 24 04 5d 27 80 	movl   $0x80275d,0x4(%esp)
  80274a:	00 
  80274b:	89 04 24             	mov    %eax,(%esp)
  80274e:	e8 a0 e6 ff ff       	call   800df3 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802753:	8b 45 08             	mov    0x8(%ebp),%eax
  802756:	a3 00 80 80 00       	mov    %eax,0x808000
}
  80275b:	c9                   	leave  
  80275c:	c3                   	ret    

0080275d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80275d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80275e:	a1 00 80 80 00       	mov    0x808000,%eax
	call *%eax
  802763:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802765:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  802768:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  80276a:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  80276e:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  802772:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  802773:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  802775:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  802777:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  80277b:	58                   	pop    %eax
	popl %eax;
  80277c:	58                   	pop    %eax
	popal;
  80277d:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  80277e:	83 c4 04             	add    $0x4,%esp
	popfl;
  802781:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  802782:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  802783:	c3                   	ret    

00802784 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802784:	55                   	push   %ebp
  802785:	89 e5                	mov    %esp,%ebp
  802787:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80278a:	89 d0                	mov    %edx,%eax
  80278c:	c1 e8 16             	shr    $0x16,%eax
  80278f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802796:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80279b:	f6 c1 01             	test   $0x1,%cl
  80279e:	74 1d                	je     8027bd <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8027a0:	c1 ea 0c             	shr    $0xc,%edx
  8027a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8027aa:	f6 c2 01             	test   $0x1,%dl
  8027ad:	74 0e                	je     8027bd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8027af:	c1 ea 0c             	shr    $0xc,%edx
  8027b2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8027b9:	ef 
  8027ba:	0f b7 c0             	movzwl %ax,%eax
}
  8027bd:	5d                   	pop    %ebp
  8027be:	c3                   	ret    
  8027bf:	90                   	nop

008027c0 <__udivdi3>:
  8027c0:	55                   	push   %ebp
  8027c1:	57                   	push   %edi
  8027c2:	56                   	push   %esi
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8027ca:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  8027ce:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  8027d2:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8027d6:	85 c0                	test   %eax,%eax
  8027d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8027dc:	89 ea                	mov    %ebp,%edx
  8027de:	89 0c 24             	mov    %ecx,(%esp)
  8027e1:	75 2d                	jne    802810 <__udivdi3+0x50>
  8027e3:	39 e9                	cmp    %ebp,%ecx
  8027e5:	77 61                	ja     802848 <__udivdi3+0x88>
  8027e7:	85 c9                	test   %ecx,%ecx
  8027e9:	89 ce                	mov    %ecx,%esi
  8027eb:	75 0b                	jne    8027f8 <__udivdi3+0x38>
  8027ed:	b8 01 00 00 00       	mov    $0x1,%eax
  8027f2:	31 d2                	xor    %edx,%edx
  8027f4:	f7 f1                	div    %ecx
  8027f6:	89 c6                	mov    %eax,%esi
  8027f8:	31 d2                	xor    %edx,%edx
  8027fa:	89 e8                	mov    %ebp,%eax
  8027fc:	f7 f6                	div    %esi
  8027fe:	89 c5                	mov    %eax,%ebp
  802800:	89 f8                	mov    %edi,%eax
  802802:	f7 f6                	div    %esi
  802804:	89 ea                	mov    %ebp,%edx
  802806:	83 c4 0c             	add    $0xc,%esp
  802809:	5e                   	pop    %esi
  80280a:	5f                   	pop    %edi
  80280b:	5d                   	pop    %ebp
  80280c:	c3                   	ret    
  80280d:	8d 76 00             	lea    0x0(%esi),%esi
  802810:	39 e8                	cmp    %ebp,%eax
  802812:	77 24                	ja     802838 <__udivdi3+0x78>
  802814:	0f bd e8             	bsr    %eax,%ebp
  802817:	83 f5 1f             	xor    $0x1f,%ebp
  80281a:	75 3c                	jne    802858 <__udivdi3+0x98>
  80281c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802820:	39 34 24             	cmp    %esi,(%esp)
  802823:	0f 86 9f 00 00 00    	jbe    8028c8 <__udivdi3+0x108>
  802829:	39 d0                	cmp    %edx,%eax
  80282b:	0f 82 97 00 00 00    	jb     8028c8 <__udivdi3+0x108>
  802831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802838:	31 d2                	xor    %edx,%edx
  80283a:	31 c0                	xor    %eax,%eax
  80283c:	83 c4 0c             	add    $0xc,%esp
  80283f:	5e                   	pop    %esi
  802840:	5f                   	pop    %edi
  802841:	5d                   	pop    %ebp
  802842:	c3                   	ret    
  802843:	90                   	nop
  802844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802848:	89 f8                	mov    %edi,%eax
  80284a:	f7 f1                	div    %ecx
  80284c:	31 d2                	xor    %edx,%edx
  80284e:	83 c4 0c             	add    $0xc,%esp
  802851:	5e                   	pop    %esi
  802852:	5f                   	pop    %edi
  802853:	5d                   	pop    %ebp
  802854:	c3                   	ret    
  802855:	8d 76 00             	lea    0x0(%esi),%esi
  802858:	89 e9                	mov    %ebp,%ecx
  80285a:	8b 3c 24             	mov    (%esp),%edi
  80285d:	d3 e0                	shl    %cl,%eax
  80285f:	89 c6                	mov    %eax,%esi
  802861:	b8 20 00 00 00       	mov    $0x20,%eax
  802866:	29 e8                	sub    %ebp,%eax
  802868:	89 c1                	mov    %eax,%ecx
  80286a:	d3 ef                	shr    %cl,%edi
  80286c:	89 e9                	mov    %ebp,%ecx
  80286e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802872:	8b 3c 24             	mov    (%esp),%edi
  802875:	09 74 24 08          	or     %esi,0x8(%esp)
  802879:	89 d6                	mov    %edx,%esi
  80287b:	d3 e7                	shl    %cl,%edi
  80287d:	89 c1                	mov    %eax,%ecx
  80287f:	89 3c 24             	mov    %edi,(%esp)
  802882:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802886:	d3 ee                	shr    %cl,%esi
  802888:	89 e9                	mov    %ebp,%ecx
  80288a:	d3 e2                	shl    %cl,%edx
  80288c:	89 c1                	mov    %eax,%ecx
  80288e:	d3 ef                	shr    %cl,%edi
  802890:	09 d7                	or     %edx,%edi
  802892:	89 f2                	mov    %esi,%edx
  802894:	89 f8                	mov    %edi,%eax
  802896:	f7 74 24 08          	divl   0x8(%esp)
  80289a:	89 d6                	mov    %edx,%esi
  80289c:	89 c7                	mov    %eax,%edi
  80289e:	f7 24 24             	mull   (%esp)
  8028a1:	39 d6                	cmp    %edx,%esi
  8028a3:	89 14 24             	mov    %edx,(%esp)
  8028a6:	72 30                	jb     8028d8 <__udivdi3+0x118>
  8028a8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028ac:	89 e9                	mov    %ebp,%ecx
  8028ae:	d3 e2                	shl    %cl,%edx
  8028b0:	39 c2                	cmp    %eax,%edx
  8028b2:	73 05                	jae    8028b9 <__udivdi3+0xf9>
  8028b4:	3b 34 24             	cmp    (%esp),%esi
  8028b7:	74 1f                	je     8028d8 <__udivdi3+0x118>
  8028b9:	89 f8                	mov    %edi,%eax
  8028bb:	31 d2                	xor    %edx,%edx
  8028bd:	e9 7a ff ff ff       	jmp    80283c <__udivdi3+0x7c>
  8028c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028c8:	31 d2                	xor    %edx,%edx
  8028ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8028cf:	e9 68 ff ff ff       	jmp    80283c <__udivdi3+0x7c>
  8028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028d8:	8d 47 ff             	lea    -0x1(%edi),%eax
  8028db:	31 d2                	xor    %edx,%edx
  8028dd:	83 c4 0c             	add    $0xc,%esp
  8028e0:	5e                   	pop    %esi
  8028e1:	5f                   	pop    %edi
  8028e2:	5d                   	pop    %ebp
  8028e3:	c3                   	ret    
  8028e4:	66 90                	xchg   %ax,%ax
  8028e6:	66 90                	xchg   %ax,%ax
  8028e8:	66 90                	xchg   %ax,%ax
  8028ea:	66 90                	xchg   %ax,%ax
  8028ec:	66 90                	xchg   %ax,%ax
  8028ee:	66 90                	xchg   %ax,%ax

008028f0 <__umoddi3>:
  8028f0:	55                   	push   %ebp
  8028f1:	57                   	push   %edi
  8028f2:	56                   	push   %esi
  8028f3:	83 ec 14             	sub    $0x14,%esp
  8028f6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8028fa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8028fe:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802902:	89 c7                	mov    %eax,%edi
  802904:	89 44 24 04          	mov    %eax,0x4(%esp)
  802908:	8b 44 24 30          	mov    0x30(%esp),%eax
  80290c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802910:	89 34 24             	mov    %esi,(%esp)
  802913:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802917:	85 c0                	test   %eax,%eax
  802919:	89 c2                	mov    %eax,%edx
  80291b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80291f:	75 17                	jne    802938 <__umoddi3+0x48>
  802921:	39 fe                	cmp    %edi,%esi
  802923:	76 4b                	jbe    802970 <__umoddi3+0x80>
  802925:	89 c8                	mov    %ecx,%eax
  802927:	89 fa                	mov    %edi,%edx
  802929:	f7 f6                	div    %esi
  80292b:	89 d0                	mov    %edx,%eax
  80292d:	31 d2                	xor    %edx,%edx
  80292f:	83 c4 14             	add    $0x14,%esp
  802932:	5e                   	pop    %esi
  802933:	5f                   	pop    %edi
  802934:	5d                   	pop    %ebp
  802935:	c3                   	ret    
  802936:	66 90                	xchg   %ax,%ax
  802938:	39 f8                	cmp    %edi,%eax
  80293a:	77 54                	ja     802990 <__umoddi3+0xa0>
  80293c:	0f bd e8             	bsr    %eax,%ebp
  80293f:	83 f5 1f             	xor    $0x1f,%ebp
  802942:	75 5c                	jne    8029a0 <__umoddi3+0xb0>
  802944:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802948:	39 3c 24             	cmp    %edi,(%esp)
  80294b:	0f 87 e7 00 00 00    	ja     802a38 <__umoddi3+0x148>
  802951:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802955:	29 f1                	sub    %esi,%ecx
  802957:	19 c7                	sbb    %eax,%edi
  802959:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80295d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802961:	8b 44 24 08          	mov    0x8(%esp),%eax
  802965:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802969:	83 c4 14             	add    $0x14,%esp
  80296c:	5e                   	pop    %esi
  80296d:	5f                   	pop    %edi
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    
  802970:	85 f6                	test   %esi,%esi
  802972:	89 f5                	mov    %esi,%ebp
  802974:	75 0b                	jne    802981 <__umoddi3+0x91>
  802976:	b8 01 00 00 00       	mov    $0x1,%eax
  80297b:	31 d2                	xor    %edx,%edx
  80297d:	f7 f6                	div    %esi
  80297f:	89 c5                	mov    %eax,%ebp
  802981:	8b 44 24 04          	mov    0x4(%esp),%eax
  802985:	31 d2                	xor    %edx,%edx
  802987:	f7 f5                	div    %ebp
  802989:	89 c8                	mov    %ecx,%eax
  80298b:	f7 f5                	div    %ebp
  80298d:	eb 9c                	jmp    80292b <__umoddi3+0x3b>
  80298f:	90                   	nop
  802990:	89 c8                	mov    %ecx,%eax
  802992:	89 fa                	mov    %edi,%edx
  802994:	83 c4 14             	add    $0x14,%esp
  802997:	5e                   	pop    %esi
  802998:	5f                   	pop    %edi
  802999:	5d                   	pop    %ebp
  80299a:	c3                   	ret    
  80299b:	90                   	nop
  80299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	8b 04 24             	mov    (%esp),%eax
  8029a3:	be 20 00 00 00       	mov    $0x20,%esi
  8029a8:	89 e9                	mov    %ebp,%ecx
  8029aa:	29 ee                	sub    %ebp,%esi
  8029ac:	d3 e2                	shl    %cl,%edx
  8029ae:	89 f1                	mov    %esi,%ecx
  8029b0:	d3 e8                	shr    %cl,%eax
  8029b2:	89 e9                	mov    %ebp,%ecx
  8029b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b8:	8b 04 24             	mov    (%esp),%eax
  8029bb:	09 54 24 04          	or     %edx,0x4(%esp)
  8029bf:	89 fa                	mov    %edi,%edx
  8029c1:	d3 e0                	shl    %cl,%eax
  8029c3:	89 f1                	mov    %esi,%ecx
  8029c5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029c9:	8b 44 24 10          	mov    0x10(%esp),%eax
  8029cd:	d3 ea                	shr    %cl,%edx
  8029cf:	89 e9                	mov    %ebp,%ecx
  8029d1:	d3 e7                	shl    %cl,%edi
  8029d3:	89 f1                	mov    %esi,%ecx
  8029d5:	d3 e8                	shr    %cl,%eax
  8029d7:	89 e9                	mov    %ebp,%ecx
  8029d9:	09 f8                	or     %edi,%eax
  8029db:	8b 7c 24 10          	mov    0x10(%esp),%edi
  8029df:	f7 74 24 04          	divl   0x4(%esp)
  8029e3:	d3 e7                	shl    %cl,%edi
  8029e5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8029e9:	89 d7                	mov    %edx,%edi
  8029eb:	f7 64 24 08          	mull   0x8(%esp)
  8029ef:	39 d7                	cmp    %edx,%edi
  8029f1:	89 c1                	mov    %eax,%ecx
  8029f3:	89 14 24             	mov    %edx,(%esp)
  8029f6:	72 2c                	jb     802a24 <__umoddi3+0x134>
  8029f8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8029fc:	72 22                	jb     802a20 <__umoddi3+0x130>
  8029fe:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802a02:	29 c8                	sub    %ecx,%eax
  802a04:	19 d7                	sbb    %edx,%edi
  802a06:	89 e9                	mov    %ebp,%ecx
  802a08:	89 fa                	mov    %edi,%edx
  802a0a:	d3 e8                	shr    %cl,%eax
  802a0c:	89 f1                	mov    %esi,%ecx
  802a0e:	d3 e2                	shl    %cl,%edx
  802a10:	89 e9                	mov    %ebp,%ecx
  802a12:	d3 ef                	shr    %cl,%edi
  802a14:	09 d0                	or     %edx,%eax
  802a16:	89 fa                	mov    %edi,%edx
  802a18:	83 c4 14             	add    $0x14,%esp
  802a1b:	5e                   	pop    %esi
  802a1c:	5f                   	pop    %edi
  802a1d:	5d                   	pop    %ebp
  802a1e:	c3                   	ret    
  802a1f:	90                   	nop
  802a20:	39 d7                	cmp    %edx,%edi
  802a22:	75 da                	jne    8029fe <__umoddi3+0x10e>
  802a24:	8b 14 24             	mov    (%esp),%edx
  802a27:	89 c1                	mov    %eax,%ecx
  802a29:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  802a2d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802a31:	eb cb                	jmp    8029fe <__umoddi3+0x10e>
  802a33:	90                   	nop
  802a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a38:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  802a3c:	0f 82 0f ff ff ff    	jb     802951 <__umoddi3+0x61>
  802a42:	e9 1a ff ff ff       	jmp    802961 <__umoddi3+0x71>
