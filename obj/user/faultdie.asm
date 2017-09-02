
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 61 00 00 00       	call   800092 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
  800033:	66 90                	xchg   %ax,%ax
  800035:	66 90                	xchg   %ax,%ax
  800037:	66 90                	xchg   %ax,%ax
  800039:	66 90                	xchg   %ax,%ax
  80003b:	66 90                	xchg   %ax,%ax
  80003d:	66 90                	xchg   %ax,%ax
  80003f:	90                   	nop

00800040 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
  800046:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  800049:	8b 50 04             	mov    0x4(%eax),%edx
  80004c:	83 e2 07             	and    $0x7,%edx
  80004f:	89 54 24 08          	mov    %edx,0x8(%esp)
  800053:	8b 00                	mov    (%eax),%eax
  800055:	89 44 24 04          	mov    %eax,0x4(%esp)
  800059:	c7 04 24 a0 26 80 00 	movl   $0x8026a0,(%esp)
  800060:	e8 3b 01 00 00       	call   8001a0 <cprintf>
	sys_env_destroy(sys_getenvid());
  800065:	e8 3b 0b 00 00       	call   800ba5 <sys_getenvid>
  80006a:	89 04 24             	mov    %eax,(%esp)
  80006d:	e8 e1 0a 00 00       	call   800b53 <sys_env_destroy>
}
  800072:	c9                   	leave  
  800073:	c3                   	ret    

00800074 <umain>:

void
umain(int argc, char **argv)
{
  800074:	55                   	push   %ebp
  800075:	89 e5                	mov    %esp,%ebp
  800077:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80007a:	c7 04 24 40 00 80 00 	movl   $0x800040,(%esp)
  800081:	e8 8a 0e 00 00       	call   800f10 <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800086:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  80008d:	00 00 00 
}
  800090:	c9                   	leave  
  800091:	c3                   	ret    

00800092 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800092:	55                   	push   %ebp
  800093:	89 e5                	mov    %esp,%ebp
  800095:	56                   	push   %esi
  800096:	53                   	push   %ebx
  800097:	83 ec 10             	sub    $0x10,%esp
  80009a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80009d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000a0:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000a7:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8000aa:	e8 f6 0a 00 00       	call   800ba5 <sys_getenvid>
  8000af:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8000b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000bc:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000c1:	85 db                	test   %ebx,%ebx
  8000c3:	7e 07                	jle    8000cc <libmain+0x3a>
		binaryname = argv[0];
  8000c5:	8b 06                	mov    (%esi),%eax
  8000c7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000cc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000d0:	89 1c 24             	mov    %ebx,(%esp)
  8000d3:	e8 9c ff ff ff       	call   800074 <umain>

	// exit gracefully
	exit();
  8000d8:	e8 07 00 00 00       	call   8000e4 <exit>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    

008000e4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000ea:	e8 9b 10 00 00       	call   80118a <close_all>
	sys_env_destroy(0);
  8000ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000f6:	e8 58 0a 00 00       	call   800b53 <sys_env_destroy>
}
  8000fb:	c9                   	leave  
  8000fc:	c3                   	ret    

008000fd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000fd:	55                   	push   %ebp
  8000fe:	89 e5                	mov    %esp,%ebp
  800100:	53                   	push   %ebx
  800101:	83 ec 14             	sub    $0x14,%esp
  800104:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800107:	8b 13                	mov    (%ebx),%edx
  800109:	8d 42 01             	lea    0x1(%edx),%eax
  80010c:	89 03                	mov    %eax,(%ebx)
  80010e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800111:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800115:	3d ff 00 00 00       	cmp    $0xff,%eax
  80011a:	75 19                	jne    800135 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80011c:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800123:	00 
  800124:	8d 43 08             	lea    0x8(%ebx),%eax
  800127:	89 04 24             	mov    %eax,(%esp)
  80012a:	e8 e7 09 00 00       	call   800b16 <sys_cputs>
		b->idx = 0;
  80012f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800135:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800139:	83 c4 14             	add    $0x14,%esp
  80013c:	5b                   	pop    %ebx
  80013d:	5d                   	pop    %ebp
  80013e:	c3                   	ret    

0080013f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80013f:	55                   	push   %ebp
  800140:	89 e5                	mov    %esp,%ebp
  800142:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800148:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80014f:	00 00 00 
	b.cnt = 0;
  800152:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800159:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80015c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80015f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800163:	8b 45 08             	mov    0x8(%ebp),%eax
  800166:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800170:	89 44 24 04          	mov    %eax,0x4(%esp)
  800174:	c7 04 24 fd 00 80 00 	movl   $0x8000fd,(%esp)
  80017b:	e8 ae 01 00 00       	call   80032e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800180:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800186:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800190:	89 04 24             	mov    %eax,(%esp)
  800193:	e8 7e 09 00 00       	call   800b16 <sys_cputs>

	return b.cnt;
}
  800198:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001a6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b0:	89 04 24             	mov    %eax,(%esp)
  8001b3:	e8 87 ff ff ff       	call   80013f <vcprintf>
	va_end(ap);

	return cnt;
}
  8001b8:	c9                   	leave  
  8001b9:	c3                   	ret    
  8001ba:	66 90                	xchg   %ax,%ax
  8001bc:	66 90                	xchg   %ax,%ax
  8001be:	66 90                	xchg   %ax,%ax

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 3c             	sub    $0x3c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d7                	mov    %edx,%edi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d7:	89 c3                	mov    %eax,%ebx
  8001d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8001df:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001ea:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001ed:	39 d9                	cmp    %ebx,%ecx
  8001ef:	72 05                	jb     8001f6 <printnum+0x36>
  8001f1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001f4:	77 69                	ja     80025f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f6:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8001f9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8001fd:	83 ee 01             	sub    $0x1,%esi
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	89 44 24 08          	mov    %eax,0x8(%esp)
  800208:	8b 44 24 08          	mov    0x8(%esp),%eax
  80020c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800210:	89 c3                	mov    %eax,%ebx
  800212:	89 d6                	mov    %edx,%esi
  800214:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800217:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80021a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80021e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800222:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80022b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80022f:	e8 cc 21 00 00       	call   802400 <__udivdi3>
  800234:	89 d9                	mov    %ebx,%ecx
  800236:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80023a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80023e:	89 04 24             	mov    %eax,(%esp)
  800241:	89 54 24 04          	mov    %edx,0x4(%esp)
  800245:	89 fa                	mov    %edi,%edx
  800247:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80024a:	e8 71 ff ff ff       	call   8001c0 <printnum>
  80024f:	eb 1b                	jmp    80026c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800251:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800255:	8b 45 18             	mov    0x18(%ebp),%eax
  800258:	89 04 24             	mov    %eax,(%esp)
  80025b:	ff d3                	call   *%ebx
  80025d:	eb 03                	jmp    800262 <printnum+0xa2>
  80025f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800262:	83 ee 01             	sub    $0x1,%esi
  800265:	85 f6                	test   %esi,%esi
  800267:	7f e8                	jg     800251 <printnum+0x91>
  800269:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800270:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800274:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800277:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80027a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80027e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800282:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	e8 9c 22 00 00       	call   802530 <__umoddi3>
  800294:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800298:	0f be 80 c6 26 80 00 	movsbl 0x8026c6(%eax),%eax
  80029f:	89 04 24             	mov    %eax,(%esp)
  8002a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002a5:	ff d0                	call   *%eax
}
  8002a7:	83 c4 3c             	add    $0x3c,%esp
  8002aa:	5b                   	pop    %ebx
  8002ab:	5e                   	pop    %esi
  8002ac:	5f                   	pop    %edi
  8002ad:	5d                   	pop    %ebp
  8002ae:	c3                   	ret    

008002af <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b2:	83 fa 01             	cmp    $0x1,%edx
  8002b5:	7e 0e                	jle    8002c5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002b7:	8b 10                	mov    (%eax),%edx
  8002b9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002bc:	89 08                	mov    %ecx,(%eax)
  8002be:	8b 02                	mov    (%edx),%eax
  8002c0:	8b 52 04             	mov    0x4(%edx),%edx
  8002c3:	eb 22                	jmp    8002e7 <getuint+0x38>
	else if (lflag)
  8002c5:	85 d2                	test   %edx,%edx
  8002c7:	74 10                	je     8002d9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002c9:	8b 10                	mov    (%eax),%edx
  8002cb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ce:	89 08                	mov    %ecx,(%eax)
  8002d0:	8b 02                	mov    (%edx),%eax
  8002d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002d7:	eb 0e                	jmp    8002e7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002de:	89 08                	mov    %ecx,(%eax)
  8002e0:	8b 02                	mov    (%edx),%eax
  8002e2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f3:	8b 10                	mov    (%eax),%edx
  8002f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f8:	73 0a                	jae    800304 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fd:	89 08                	mov    %ecx,(%eax)
  8002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800302:	88 02                	mov    %al,(%edx)
}
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80030c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800313:	8b 45 10             	mov    0x10(%ebp),%eax
  800316:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
  800324:	89 04 24             	mov    %eax,(%esp)
  800327:	e8 02 00 00 00       	call   80032e <vprintfmt>
	va_end(ap);
}
  80032c:	c9                   	leave  
  80032d:	c3                   	ret    

0080032e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80032e:	55                   	push   %ebp
  80032f:	89 e5                	mov    %esp,%ebp
  800331:	57                   	push   %edi
  800332:	56                   	push   %esi
  800333:	53                   	push   %ebx
  800334:	83 ec 3c             	sub    $0x3c,%esp
  800337:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80033a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80033d:	eb 14                	jmp    800353 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80033f:	85 c0                	test   %eax,%eax
  800341:	0f 84 b3 03 00 00    	je     8006fa <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800347:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80034b:	89 04 24             	mov    %eax,(%esp)
  80034e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800351:	89 f3                	mov    %esi,%ebx
  800353:	8d 73 01             	lea    0x1(%ebx),%esi
  800356:	0f b6 03             	movzbl (%ebx),%eax
  800359:	83 f8 25             	cmp    $0x25,%eax
  80035c:	75 e1                	jne    80033f <vprintfmt+0x11>
  80035e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800362:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800369:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800370:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800377:	ba 00 00 00 00       	mov    $0x0,%edx
  80037c:	eb 1d                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800380:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800384:	eb 15                	jmp    80039b <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800386:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800388:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80038c:	eb 0d                	jmp    80039b <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80038e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800391:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800394:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80039b:	8d 5e 01             	lea    0x1(%esi),%ebx
  80039e:	0f b6 0e             	movzbl (%esi),%ecx
  8003a1:	0f b6 c1             	movzbl %cl,%eax
  8003a4:	83 e9 23             	sub    $0x23,%ecx
  8003a7:	80 f9 55             	cmp    $0x55,%cl
  8003aa:	0f 87 2a 03 00 00    	ja     8006da <vprintfmt+0x3ac>
  8003b0:	0f b6 c9             	movzbl %cl,%ecx
  8003b3:	ff 24 8d 00 28 80 00 	jmp    *0x802800(,%ecx,4)
  8003ba:	89 de                	mov    %ebx,%esi
  8003bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003c1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003c4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003c8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003cb:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003ce:	83 fb 09             	cmp    $0x9,%ebx
  8003d1:	77 36                	ja     800409 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003d3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003d6:	eb e9                	jmp    8003c1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 48 04             	lea    0x4(%eax),%ecx
  8003de:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003e1:	8b 00                	mov    (%eax),%eax
  8003e3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003e6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003e8:	eb 22                	jmp    80040c <vprintfmt+0xde>
  8003ea:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003ed:	85 c9                	test   %ecx,%ecx
  8003ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f4:	0f 49 c1             	cmovns %ecx,%eax
  8003f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	89 de                	mov    %ebx,%esi
  8003fc:	eb 9d                	jmp    80039b <vprintfmt+0x6d>
  8003fe:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800400:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800407:	eb 92                	jmp    80039b <vprintfmt+0x6d>
  800409:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80040c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800410:	79 89                	jns    80039b <vprintfmt+0x6d>
  800412:	e9 77 ff ff ff       	jmp    80038e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800417:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80041a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80041c:	e9 7a ff ff ff       	jmp    80039b <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800421:	8b 45 14             	mov    0x14(%ebp),%eax
  800424:	8d 50 04             	lea    0x4(%eax),%edx
  800427:	89 55 14             	mov    %edx,0x14(%ebp)
  80042a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80042e:	8b 00                	mov    (%eax),%eax
  800430:	89 04 24             	mov    %eax,(%esp)
  800433:	ff 55 08             	call   *0x8(%ebp)
			break;
  800436:	e9 18 ff ff ff       	jmp    800353 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80043b:	8b 45 14             	mov    0x14(%ebp),%eax
  80043e:	8d 50 04             	lea    0x4(%eax),%edx
  800441:	89 55 14             	mov    %edx,0x14(%ebp)
  800444:	8b 00                	mov    (%eax),%eax
  800446:	99                   	cltd   
  800447:	31 d0                	xor    %edx,%eax
  800449:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80044b:	83 f8 0f             	cmp    $0xf,%eax
  80044e:	7f 0b                	jg     80045b <vprintfmt+0x12d>
  800450:	8b 14 85 60 29 80 00 	mov    0x802960(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 de 26 80 	movl   $0x8026de,0x8(%esp)
  800466:	00 
  800467:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80046b:	8b 45 08             	mov    0x8(%ebp),%eax
  80046e:	89 04 24             	mov    %eax,(%esp)
  800471:	e8 90 fe ff ff       	call   800306 <printfmt>
  800476:	e9 d8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 fd 2a 80 	movl   $0x802afd,0x8(%esp)
  800486:	00 
  800487:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80048b:	8b 45 08             	mov    0x8(%ebp),%eax
  80048e:	89 04 24             	mov    %eax,(%esp)
  800491:	e8 70 fe ff ff       	call   800306 <printfmt>
  800496:	e9 b8 fe ff ff       	jmp    800353 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  80049e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a7:	8d 50 04             	lea    0x4(%eax),%edx
  8004aa:	89 55 14             	mov    %edx,0x14(%ebp)
  8004ad:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004af:	85 f6                	test   %esi,%esi
  8004b1:	b8 d7 26 80 00       	mov    $0x8026d7,%eax
  8004b6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004b9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004bd:	0f 84 97 00 00 00    	je     80055a <vprintfmt+0x22c>
  8004c3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004c7:	0f 8e 9b 00 00 00    	jle    800568 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004d1:	89 34 24             	mov    %esi,(%esp)
  8004d4:	e8 cf 02 00 00       	call   8007a8 <strnlen>
  8004d9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004dc:	29 c2                	sub    %eax,%edx
  8004de:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004e5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004e8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004ee:	89 5d 10             	mov    %ebx,0x10(%ebp)
  8004f1:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f3:	eb 0f                	jmp    800504 <vprintfmt+0x1d6>
					putch(padc, putdat);
  8004f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8004f9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004fc:	89 04 24             	mov    %eax,(%esp)
  8004ff:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800501:	83 eb 01             	sub    $0x1,%ebx
  800504:	85 db                	test   %ebx,%ebx
  800506:	7f ed                	jg     8004f5 <vprintfmt+0x1c7>
  800508:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80050b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80050e:	85 d2                	test   %edx,%edx
  800510:	b8 00 00 00 00       	mov    $0x0,%eax
  800515:	0f 49 c2             	cmovns %edx,%eax
  800518:	29 c2                	sub    %eax,%edx
  80051a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80051d:	89 d7                	mov    %edx,%edi
  80051f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800522:	eb 50                	jmp    800574 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800524:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800528:	74 1e                	je     800548 <vprintfmt+0x21a>
  80052a:	0f be d2             	movsbl %dl,%edx
  80052d:	83 ea 20             	sub    $0x20,%edx
  800530:	83 fa 5e             	cmp    $0x5e,%edx
  800533:	76 13                	jbe    800548 <vprintfmt+0x21a>
					putch('?', putdat);
  800535:	8b 45 0c             	mov    0xc(%ebp),%eax
  800538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800543:	ff 55 08             	call   *0x8(%ebp)
  800546:	eb 0d                	jmp    800555 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80054f:	89 04 24             	mov    %eax,(%esp)
  800552:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800555:	83 ef 01             	sub    $0x1,%edi
  800558:	eb 1a                	jmp    800574 <vprintfmt+0x246>
  80055a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80055d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800560:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800563:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800566:	eb 0c                	jmp    800574 <vprintfmt+0x246>
  800568:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80056e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800571:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800574:	83 c6 01             	add    $0x1,%esi
  800577:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80057b:	0f be c2             	movsbl %dl,%eax
  80057e:	85 c0                	test   %eax,%eax
  800580:	74 27                	je     8005a9 <vprintfmt+0x27b>
  800582:	85 db                	test   %ebx,%ebx
  800584:	78 9e                	js     800524 <vprintfmt+0x1f6>
  800586:	83 eb 01             	sub    $0x1,%ebx
  800589:	79 99                	jns    800524 <vprintfmt+0x1f6>
  80058b:	89 f8                	mov    %edi,%eax
  80058d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800590:	8b 75 08             	mov    0x8(%ebp),%esi
  800593:	89 c3                	mov    %eax,%ebx
  800595:	eb 1a                	jmp    8005b1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800597:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80059b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005a2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005a4:	83 eb 01             	sub    $0x1,%ebx
  8005a7:	eb 08                	jmp    8005b1 <vprintfmt+0x283>
  8005a9:	89 fb                	mov    %edi,%ebx
  8005ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ae:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f e2                	jg     800597 <vprintfmt+0x269>
  8005b5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005bb:	e9 93 fd ff ff       	jmp    800353 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c0:	83 fa 01             	cmp    $0x1,%edx
  8005c3:	7e 16                	jle    8005db <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 50 08             	lea    0x8(%eax),%edx
  8005cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ce:	8b 50 04             	mov    0x4(%eax),%edx
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005d9:	eb 32                	jmp    80060d <vprintfmt+0x2df>
	else if (lflag)
  8005db:	85 d2                	test   %edx,%edx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 30                	mov    (%eax),%esi
  8005ea:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005ed:	89 f0                	mov    %esi,%eax
  8005ef:	c1 f8 1f             	sar    $0x1f,%eax
  8005f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 30                	mov    (%eax),%esi
  800602:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800605:	89 f0                	mov    %esi,%eax
  800607:	c1 f8 1f             	sar    $0x1f,%eax
  80060a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800610:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800613:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800618:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80061c:	0f 89 80 00 00 00    	jns    8006a2 <vprintfmt+0x374>
				putch('-', putdat);
  800622:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800626:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800633:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800636:	f7 d8                	neg    %eax
  800638:	83 d2 00             	adc    $0x0,%edx
  80063b:	f7 da                	neg    %edx
			}
			base = 10;
  80063d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800642:	eb 5e                	jmp    8006a2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800644:	8d 45 14             	lea    0x14(%ebp),%eax
  800647:	e8 63 fc ff ff       	call   8002af <getuint>
			base = 10;
  80064c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800651:	eb 4f                	jmp    8006a2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800653:	8d 45 14             	lea    0x14(%ebp),%eax
  800656:	e8 54 fc ff ff       	call   8002af <getuint>
			base =8;
  80065b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800660:	eb 40                	jmp    8006a2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800662:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800666:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80066d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800670:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800674:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80067b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8d 50 04             	lea    0x4(%eax),%edx
  800684:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80068e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  800693:	eb 0d                	jmp    8006a2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800695:	8d 45 14             	lea    0x14(%ebp),%eax
  800698:	e8 12 fc ff ff       	call   8002af <getuint>
			base = 16;
  80069d:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006a2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006aa:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006ad:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006b5:	89 04 24             	mov    %eax,(%esp)
  8006b8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006bc:	89 fa                	mov    %edi,%edx
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	e8 fa fa ff ff       	call   8001c0 <printnum>
			break;
  8006c6:	e9 88 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006cb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006d5:	e9 79 fc ff ff       	jmp    800353 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006da:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006de:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006e5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006e8:	89 f3                	mov    %esi,%ebx
  8006ea:	eb 03                	jmp    8006ef <vprintfmt+0x3c1>
  8006ec:	83 eb 01             	sub    $0x1,%ebx
  8006ef:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  8006f3:	75 f7                	jne    8006ec <vprintfmt+0x3be>
  8006f5:	e9 59 fc ff ff       	jmp    800353 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  8006fa:	83 c4 3c             	add    $0x3c,%esp
  8006fd:	5b                   	pop    %ebx
  8006fe:	5e                   	pop    %esi
  8006ff:	5f                   	pop    %edi
  800700:	5d                   	pop    %ebp
  800701:	c3                   	ret    

00800702 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 28             	sub    $0x28,%esp
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80070e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800711:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800715:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800718:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80071f:	85 c0                	test   %eax,%eax
  800721:	74 30                	je     800753 <vsnprintf+0x51>
  800723:	85 d2                	test   %edx,%edx
  800725:	7e 2c                	jle    800753 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	89 44 24 08          	mov    %eax,0x8(%esp)
  800735:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073c:	c7 04 24 e9 02 80 00 	movl   $0x8002e9,(%esp)
  800743:	e8 e6 fb ff ff       	call   80032e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800748:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80074b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80074e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800751:	eb 05                	jmp    800758 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800753:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800758:	c9                   	leave  
  800759:	c3                   	ret    

0080075a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80075a:	55                   	push   %ebp
  80075b:	89 e5                	mov    %esp,%ebp
  80075d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800760:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800763:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800767:	8b 45 10             	mov    0x10(%ebp),%eax
  80076a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80076e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800771:	89 44 24 04          	mov    %eax,0x4(%esp)
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 04 24             	mov    %eax,(%esp)
  80077b:	e8 82 ff ff ff       	call   800702 <vsnprintf>
	va_end(ap);

	return rc;
}
  800780:	c9                   	leave  
  800781:	c3                   	ret    
  800782:	66 90                	xchg   %ax,%ax
  800784:	66 90                	xchg   %ax,%ax
  800786:	66 90                	xchg   %ax,%ax
  800788:	66 90                	xchg   %ax,%ax
  80078a:	66 90                	xchg   %ax,%ax
  80078c:	66 90                	xchg   %ax,%ax
  80078e:	66 90                	xchg   %ax,%ax

00800790 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800796:	b8 00 00 00 00       	mov    $0x0,%eax
  80079b:	eb 03                	jmp    8007a0 <strlen+0x10>
		n++;
  80079d:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007a4:	75 f7                	jne    80079d <strlen+0xd>
		n++;
	return n;
}
  8007a6:	5d                   	pop    %ebp
  8007a7:	c3                   	ret    

008007a8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007a8:	55                   	push   %ebp
  8007a9:	89 e5                	mov    %esp,%ebp
  8007ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ae:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007b6:	eb 03                	jmp    8007bb <strnlen+0x13>
		n++;
  8007b8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007bb:	39 d0                	cmp    %edx,%eax
  8007bd:	74 06                	je     8007c5 <strnlen+0x1d>
  8007bf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007c3:	75 f3                	jne    8007b8 <strnlen+0x10>
		n++;
	return n;
}
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	53                   	push   %ebx
  8007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007d1:	89 c2                	mov    %eax,%edx
  8007d3:	83 c2 01             	add    $0x1,%edx
  8007d6:	83 c1 01             	add    $0x1,%ecx
  8007d9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007dd:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007e0:	84 db                	test   %bl,%bl
  8007e2:	75 ef                	jne    8007d3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007e4:	5b                   	pop    %ebx
  8007e5:	5d                   	pop    %ebp
  8007e6:	c3                   	ret    

008007e7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007e7:	55                   	push   %ebp
  8007e8:	89 e5                	mov    %esp,%ebp
  8007ea:	53                   	push   %ebx
  8007eb:	83 ec 08             	sub    $0x8,%esp
  8007ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007f1:	89 1c 24             	mov    %ebx,(%esp)
  8007f4:	e8 97 ff ff ff       	call   800790 <strlen>
	strcpy(dst + len, src);
  8007f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  800800:	01 d8                	add    %ebx,%eax
  800802:	89 04 24             	mov    %eax,(%esp)
  800805:	e8 bd ff ff ff       	call   8007c7 <strcpy>
	return dst;
}
  80080a:	89 d8                	mov    %ebx,%eax
  80080c:	83 c4 08             	add    $0x8,%esp
  80080f:	5b                   	pop    %ebx
  800810:	5d                   	pop    %ebp
  800811:	c3                   	ret    

00800812 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800812:	55                   	push   %ebp
  800813:	89 e5                	mov    %esp,%ebp
  800815:	56                   	push   %esi
  800816:	53                   	push   %ebx
  800817:	8b 75 08             	mov    0x8(%ebp),%esi
  80081a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80081d:	89 f3                	mov    %esi,%ebx
  80081f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800822:	89 f2                	mov    %esi,%edx
  800824:	eb 0f                	jmp    800835 <strncpy+0x23>
		*dst++ = *src;
  800826:	83 c2 01             	add    $0x1,%edx
  800829:	0f b6 01             	movzbl (%ecx),%eax
  80082c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80082f:	80 39 01             	cmpb   $0x1,(%ecx)
  800832:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800835:	39 da                	cmp    %ebx,%edx
  800837:	75 ed                	jne    800826 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800839:	89 f0                	mov    %esi,%eax
  80083b:	5b                   	pop    %ebx
  80083c:	5e                   	pop    %esi
  80083d:	5d                   	pop    %ebp
  80083e:	c3                   	ret    

0080083f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80083f:	55                   	push   %ebp
  800840:	89 e5                	mov    %esp,%ebp
  800842:	56                   	push   %esi
  800843:	53                   	push   %ebx
  800844:	8b 75 08             	mov    0x8(%ebp),%esi
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800853:	85 c9                	test   %ecx,%ecx
  800855:	75 0b                	jne    800862 <strlcpy+0x23>
  800857:	eb 1d                	jmp    800876 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800859:	83 c0 01             	add    $0x1,%eax
  80085c:	83 c2 01             	add    $0x1,%edx
  80085f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800862:	39 d8                	cmp    %ebx,%eax
  800864:	74 0b                	je     800871 <strlcpy+0x32>
  800866:	0f b6 0a             	movzbl (%edx),%ecx
  800869:	84 c9                	test   %cl,%cl
  80086b:	75 ec                	jne    800859 <strlcpy+0x1a>
  80086d:	89 c2                	mov    %eax,%edx
  80086f:	eb 02                	jmp    800873 <strlcpy+0x34>
  800871:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800873:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800876:	29 f0                	sub    %esi,%eax
}
  800878:	5b                   	pop    %ebx
  800879:	5e                   	pop    %esi
  80087a:	5d                   	pop    %ebp
  80087b:	c3                   	ret    

0080087c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80087c:	55                   	push   %ebp
  80087d:	89 e5                	mov    %esp,%ebp
  80087f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800882:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800885:	eb 06                	jmp    80088d <strcmp+0x11>
		p++, q++;
  800887:	83 c1 01             	add    $0x1,%ecx
  80088a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80088d:	0f b6 01             	movzbl (%ecx),%eax
  800890:	84 c0                	test   %al,%al
  800892:	74 04                	je     800898 <strcmp+0x1c>
  800894:	3a 02                	cmp    (%edx),%al
  800896:	74 ef                	je     800887 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800898:	0f b6 c0             	movzbl %al,%eax
  80089b:	0f b6 12             	movzbl (%edx),%edx
  80089e:	29 d0                	sub    %edx,%eax
}
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ac:	89 c3                	mov    %eax,%ebx
  8008ae:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b1:	eb 06                	jmp    8008b9 <strncmp+0x17>
		n--, p++, q++;
  8008b3:	83 c0 01             	add    $0x1,%eax
  8008b6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 15                	je     8008d2 <strncmp+0x30>
  8008bd:	0f b6 08             	movzbl (%eax),%ecx
  8008c0:	84 c9                	test   %cl,%cl
  8008c2:	74 04                	je     8008c8 <strncmp+0x26>
  8008c4:	3a 0a                	cmp    (%edx),%cl
  8008c6:	74 eb                	je     8008b3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c8:	0f b6 00             	movzbl (%eax),%eax
  8008cb:	0f b6 12             	movzbl (%edx),%edx
  8008ce:	29 d0                	sub    %edx,%eax
  8008d0:	eb 05                	jmp    8008d7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008e4:	eb 07                	jmp    8008ed <strchr+0x13>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 0f                	je     8008f9 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008ea:	83 c0 01             	add    $0x1,%eax
  8008ed:	0f b6 10             	movzbl (%eax),%edx
  8008f0:	84 d2                	test   %dl,%dl
  8008f2:	75 f2                	jne    8008e6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  8008f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f9:	5d                   	pop    %ebp
  8008fa:	c3                   	ret    

008008fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800901:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800905:	eb 07                	jmp    80090e <strfind+0x13>
		if (*s == c)
  800907:	38 ca                	cmp    %cl,%dl
  800909:	74 0a                	je     800915 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80090b:	83 c0 01             	add    $0x1,%eax
  80090e:	0f b6 10             	movzbl (%eax),%edx
  800911:	84 d2                	test   %dl,%dl
  800913:	75 f2                	jne    800907 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	57                   	push   %edi
  80091b:	56                   	push   %esi
  80091c:	53                   	push   %ebx
  80091d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800920:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800923:	85 c9                	test   %ecx,%ecx
  800925:	74 36                	je     80095d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800927:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80092d:	75 28                	jne    800957 <memset+0x40>
  80092f:	f6 c1 03             	test   $0x3,%cl
  800932:	75 23                	jne    800957 <memset+0x40>
		c &= 0xFF;
  800934:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800938:	89 d3                	mov    %edx,%ebx
  80093a:	c1 e3 08             	shl    $0x8,%ebx
  80093d:	89 d6                	mov    %edx,%esi
  80093f:	c1 e6 18             	shl    $0x18,%esi
  800942:	89 d0                	mov    %edx,%eax
  800944:	c1 e0 10             	shl    $0x10,%eax
  800947:	09 f0                	or     %esi,%eax
  800949:	09 c2                	or     %eax,%edx
  80094b:	89 d0                	mov    %edx,%eax
  80094d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800952:	fc                   	cld    
  800953:	f3 ab                	rep stos %eax,%es:(%edi)
  800955:	eb 06                	jmp    80095d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	fc                   	cld    
  80095b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80095d:	89 f8                	mov    %edi,%eax
  80095f:	5b                   	pop    %ebx
  800960:	5e                   	pop    %esi
  800961:	5f                   	pop    %edi
  800962:	5d                   	pop    %ebp
  800963:	c3                   	ret    

00800964 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800964:	55                   	push   %ebp
  800965:	89 e5                	mov    %esp,%ebp
  800967:	57                   	push   %edi
  800968:	56                   	push   %esi
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80096f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800972:	39 c6                	cmp    %eax,%esi
  800974:	73 35                	jae    8009ab <memmove+0x47>
  800976:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800979:	39 d0                	cmp    %edx,%eax
  80097b:	73 2e                	jae    8009ab <memmove+0x47>
		s += n;
		d += n;
  80097d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800980:	89 d6                	mov    %edx,%esi
  800982:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800984:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80098a:	75 13                	jne    80099f <memmove+0x3b>
  80098c:	f6 c1 03             	test   $0x3,%cl
  80098f:	75 0e                	jne    80099f <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800991:	83 ef 04             	sub    $0x4,%edi
  800994:	8d 72 fc             	lea    -0x4(%edx),%esi
  800997:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  80099a:	fd                   	std    
  80099b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80099d:	eb 09                	jmp    8009a8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80099f:	83 ef 01             	sub    $0x1,%edi
  8009a2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009a5:	fd                   	std    
  8009a6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009a8:	fc                   	cld    
  8009a9:	eb 1d                	jmp    8009c8 <memmove+0x64>
  8009ab:	89 f2                	mov    %esi,%edx
  8009ad:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009af:	f6 c2 03             	test   $0x3,%dl
  8009b2:	75 0f                	jne    8009c3 <memmove+0x5f>
  8009b4:	f6 c1 03             	test   $0x3,%cl
  8009b7:	75 0a                	jne    8009c3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009bc:	89 c7                	mov    %eax,%edi
  8009be:	fc                   	cld    
  8009bf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009c1:	eb 05                	jmp    8009c8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009c3:	89 c7                	mov    %eax,%edi
  8009c5:	fc                   	cld    
  8009c6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009c8:	5e                   	pop    %esi
  8009c9:	5f                   	pop    %edi
  8009ca:	5d                   	pop    %ebp
  8009cb:	c3                   	ret    

008009cc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	89 04 24             	mov    %eax,(%esp)
  8009e6:	e8 79 ff ff ff       	call   800964 <memmove>
}
  8009eb:	c9                   	leave  
  8009ec:	c3                   	ret    

008009ed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	56                   	push   %esi
  8009f1:	53                   	push   %ebx
  8009f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8009f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009f8:	89 d6                	mov    %edx,%esi
  8009fa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8009fd:	eb 1a                	jmp    800a19 <memcmp+0x2c>
		if (*s1 != *s2)
  8009ff:	0f b6 02             	movzbl (%edx),%eax
  800a02:	0f b6 19             	movzbl (%ecx),%ebx
  800a05:	38 d8                	cmp    %bl,%al
  800a07:	74 0a                	je     800a13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a09:	0f b6 c0             	movzbl %al,%eax
  800a0c:	0f b6 db             	movzbl %bl,%ebx
  800a0f:	29 d8                	sub    %ebx,%eax
  800a11:	eb 0f                	jmp    800a22 <memcmp+0x35>
		s1++, s2++;
  800a13:	83 c2 01             	add    $0x1,%edx
  800a16:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a19:	39 f2                	cmp    %esi,%edx
  800a1b:	75 e2                	jne    8009ff <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a22:	5b                   	pop    %ebx
  800a23:	5e                   	pop    %esi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2f:	89 c2                	mov    %eax,%edx
  800a31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a34:	eb 07                	jmp    800a3d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a36:	38 08                	cmp    %cl,(%eax)
  800a38:	74 07                	je     800a41 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	39 d0                	cmp    %edx,%eax
  800a3f:	72 f5                	jb     800a36 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a41:	5d                   	pop    %ebp
  800a42:	c3                   	ret    

00800a43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	57                   	push   %edi
  800a47:	56                   	push   %esi
  800a48:	53                   	push   %ebx
  800a49:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a4f:	eb 03                	jmp    800a54 <strtol+0x11>
		s++;
  800a51:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a54:	0f b6 0a             	movzbl (%edx),%ecx
  800a57:	80 f9 09             	cmp    $0x9,%cl
  800a5a:	74 f5                	je     800a51 <strtol+0xe>
  800a5c:	80 f9 20             	cmp    $0x20,%cl
  800a5f:	74 f0                	je     800a51 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a61:	80 f9 2b             	cmp    $0x2b,%cl
  800a64:	75 0a                	jne    800a70 <strtol+0x2d>
		s++;
  800a66:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a69:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6e:	eb 11                	jmp    800a81 <strtol+0x3e>
  800a70:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a75:	80 f9 2d             	cmp    $0x2d,%cl
  800a78:	75 07                	jne    800a81 <strtol+0x3e>
		s++, neg = 1;
  800a7a:	8d 52 01             	lea    0x1(%edx),%edx
  800a7d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a81:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a86:	75 15                	jne    800a9d <strtol+0x5a>
  800a88:	80 3a 30             	cmpb   $0x30,(%edx)
  800a8b:	75 10                	jne    800a9d <strtol+0x5a>
  800a8d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800a91:	75 0a                	jne    800a9d <strtol+0x5a>
		s += 2, base = 16;
  800a93:	83 c2 02             	add    $0x2,%edx
  800a96:	b8 10 00 00 00       	mov    $0x10,%eax
  800a9b:	eb 10                	jmp    800aad <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	75 0c                	jne    800aad <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800aa3:	80 3a 30             	cmpb   $0x30,(%edx)
  800aa6:	75 05                	jne    800aad <strtol+0x6a>
		s++, base = 8;
  800aa8:	83 c2 01             	add    $0x1,%edx
  800aab:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800aad:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ab5:	0f b6 0a             	movzbl (%edx),%ecx
  800ab8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800abb:	89 f0                	mov    %esi,%eax
  800abd:	3c 09                	cmp    $0x9,%al
  800abf:	77 08                	ja     800ac9 <strtol+0x86>
			dig = *s - '0';
  800ac1:	0f be c9             	movsbl %cl,%ecx
  800ac4:	83 e9 30             	sub    $0x30,%ecx
  800ac7:	eb 20                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ac9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800acc:	89 f0                	mov    %esi,%eax
  800ace:	3c 19                	cmp    $0x19,%al
  800ad0:	77 08                	ja     800ada <strtol+0x97>
			dig = *s - 'a' + 10;
  800ad2:	0f be c9             	movsbl %cl,%ecx
  800ad5:	83 e9 57             	sub    $0x57,%ecx
  800ad8:	eb 0f                	jmp    800ae9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800ada:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800add:	89 f0                	mov    %esi,%eax
  800adf:	3c 19                	cmp    $0x19,%al
  800ae1:	77 16                	ja     800af9 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800ae3:	0f be c9             	movsbl %cl,%ecx
  800ae6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ae9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800aec:	7d 0f                	jge    800afd <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800aee:	83 c2 01             	add    $0x1,%edx
  800af1:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800af5:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800af7:	eb bc                	jmp    800ab5 <strtol+0x72>
  800af9:	89 d8                	mov    %ebx,%eax
  800afb:	eb 02                	jmp    800aff <strtol+0xbc>
  800afd:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800aff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b03:	74 05                	je     800b0a <strtol+0xc7>
		*endptr = (char *) s;
  800b05:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b08:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b0a:	f7 d8                	neg    %eax
  800b0c:	85 ff                	test   %edi,%edi
  800b0e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5f                   	pop    %edi
  800b14:	5d                   	pop    %ebp
  800b15:	c3                   	ret    

00800b16 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b16:	55                   	push   %ebp
  800b17:	89 e5                	mov    %esp,%ebp
  800b19:	57                   	push   %edi
  800b1a:	56                   	push   %esi
  800b1b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b24:	8b 55 08             	mov    0x8(%ebp),%edx
  800b27:	89 c3                	mov    %eax,%ebx
  800b29:	89 c7                	mov    %eax,%edi
  800b2b:	89 c6                	mov    %eax,%esi
  800b2d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b2f:	5b                   	pop    %ebx
  800b30:	5e                   	pop    %esi
  800b31:	5f                   	pop    %edi
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    

00800b34 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	57                   	push   %edi
  800b38:	56                   	push   %esi
  800b39:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b3a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b3f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b44:	89 d1                	mov    %edx,%ecx
  800b46:	89 d3                	mov    %edx,%ebx
  800b48:	89 d7                	mov    %edx,%edi
  800b4a:	89 d6                	mov    %edx,%esi
  800b4c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b4e:	5b                   	pop    %ebx
  800b4f:	5e                   	pop    %esi
  800b50:	5f                   	pop    %edi
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b61:	b8 03 00 00 00       	mov    $0x3,%eax
  800b66:	8b 55 08             	mov    0x8(%ebp),%edx
  800b69:	89 cb                	mov    %ecx,%ebx
  800b6b:	89 cf                	mov    %ecx,%edi
  800b6d:	89 ce                	mov    %ecx,%esi
  800b6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b71:	85 c0                	test   %eax,%eax
  800b73:	7e 28                	jle    800b9d <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b75:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b79:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b80:	00 
  800b81:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800b88:	00 
  800b89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b90:	00 
  800b91:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800b98:	e8 c9 16 00 00       	call   802266 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b9d:	83 c4 2c             	add    $0x2c,%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    

00800ba5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ba5:	55                   	push   %ebp
  800ba6:	89 e5                	mov    %esp,%ebp
  800ba8:	57                   	push   %edi
  800ba9:	56                   	push   %esi
  800baa:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bab:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bb5:	89 d1                	mov    %edx,%ecx
  800bb7:	89 d3                	mov    %edx,%ebx
  800bb9:	89 d7                	mov    %edx,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bbf:	5b                   	pop    %ebx
  800bc0:	5e                   	pop    %esi
  800bc1:	5f                   	pop    %edi
  800bc2:	5d                   	pop    %ebp
  800bc3:	c3                   	ret    

00800bc4 <sys_yield>:

void
sys_yield(void)
{
  800bc4:	55                   	push   %ebp
  800bc5:	89 e5                	mov    %esp,%ebp
  800bc7:	57                   	push   %edi
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bca:	ba 00 00 00 00       	mov    $0x0,%edx
  800bcf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bd4:	89 d1                	mov    %edx,%ecx
  800bd6:	89 d3                	mov    %edx,%ebx
  800bd8:	89 d7                	mov    %edx,%edi
  800bda:	89 d6                	mov    %edx,%esi
  800bdc:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bde:	5b                   	pop    %ebx
  800bdf:	5e                   	pop    %esi
  800be0:	5f                   	pop    %edi
  800be1:	5d                   	pop    %ebp
  800be2:	c3                   	ret    

00800be3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be3:	55                   	push   %ebp
  800be4:	89 e5                	mov    %esp,%ebp
  800be6:	57                   	push   %edi
  800be7:	56                   	push   %esi
  800be8:	53                   	push   %ebx
  800be9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bec:	be 00 00 00 00       	mov    $0x0,%esi
  800bf1:	b8 04 00 00 00       	mov    $0x4,%eax
  800bf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bff:	89 f7                	mov    %esi,%edi
  800c01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c03:	85 c0                	test   %eax,%eax
  800c05:	7e 28                	jle    800c2f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c0b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c12:	00 
  800c13:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800c1a:	00 
  800c1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c22:	00 
  800c23:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800c2a:	e8 37 16 00 00       	call   802266 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c2f:	83 c4 2c             	add    $0x2c,%esp
  800c32:	5b                   	pop    %ebx
  800c33:	5e                   	pop    %esi
  800c34:	5f                   	pop    %edi
  800c35:	5d                   	pop    %ebp
  800c36:	c3                   	ret    

00800c37 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c37:	55                   	push   %ebp
  800c38:	89 e5                	mov    %esp,%ebp
  800c3a:	57                   	push   %edi
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c40:	b8 05 00 00 00       	mov    $0x5,%eax
  800c45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c48:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c51:	8b 75 18             	mov    0x18(%ebp),%esi
  800c54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c56:	85 c0                	test   %eax,%eax
  800c58:	7e 28                	jle    800c82 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c5e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c65:	00 
  800c66:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800c6d:	00 
  800c6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c75:	00 
  800c76:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800c7d:	e8 e4 15 00 00       	call   802266 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c82:	83 c4 2c             	add    $0x2c,%esp
  800c85:	5b                   	pop    %ebx
  800c86:	5e                   	pop    %esi
  800c87:	5f                   	pop    %edi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
  800c90:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c98:	b8 06 00 00 00       	mov    $0x6,%eax
  800c9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca3:	89 df                	mov    %ebx,%edi
  800ca5:	89 de                	mov    %ebx,%esi
  800ca7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800ca9:	85 c0                	test   %eax,%eax
  800cab:	7e 28                	jle    800cd5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cad:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cb1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cb8:	00 
  800cb9:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800cc0:	00 
  800cc1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cc8:	00 
  800cc9:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800cd0:	e8 91 15 00 00       	call   802266 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cd5:	83 c4 2c             	add    $0x2c,%esp
  800cd8:	5b                   	pop    %ebx
  800cd9:	5e                   	pop    %esi
  800cda:	5f                   	pop    %edi
  800cdb:	5d                   	pop    %ebp
  800cdc:	c3                   	ret    

00800cdd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	57                   	push   %edi
  800ce1:	56                   	push   %esi
  800ce2:	53                   	push   %ebx
  800ce3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ceb:	b8 08 00 00 00       	mov    $0x8,%eax
  800cf0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	89 df                	mov    %ebx,%edi
  800cf8:	89 de                	mov    %ebx,%esi
  800cfa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	7e 28                	jle    800d28 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d04:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d0b:	00 
  800d0c:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800d13:	00 
  800d14:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d1b:	00 
  800d1c:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800d23:	e8 3e 15 00 00       	call   802266 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d28:	83 c4 2c             	add    $0x2c,%esp
  800d2b:	5b                   	pop    %ebx
  800d2c:	5e                   	pop    %esi
  800d2d:	5f                   	pop    %edi
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
  800d33:	57                   	push   %edi
  800d34:	56                   	push   %esi
  800d35:	53                   	push   %ebx
  800d36:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d39:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d3e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	89 df                	mov    %ebx,%edi
  800d4b:	89 de                	mov    %ebx,%esi
  800d4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7e 28                	jle    800d7b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d57:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800d76:	e8 eb 14 00 00       	call   802266 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d7b:	83 c4 2c             	add    $0x2c,%esp
  800d7e:	5b                   	pop    %ebx
  800d7f:	5e                   	pop    %esi
  800d80:	5f                   	pop    %edi
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	57                   	push   %edi
  800d87:	56                   	push   %esi
  800d88:	53                   	push   %ebx
  800d89:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d8c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 df                	mov    %ebx,%edi
  800d9e:	89 de                	mov    %ebx,%esi
  800da0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800da2:	85 c0                	test   %eax,%eax
  800da4:	7e 28                	jle    800dce <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800daa:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800db1:	00 
  800db2:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800db9:	00 
  800dba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dc1:	00 
  800dc2:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800dc9:	e8 98 14 00 00       	call   802266 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dce:	83 c4 2c             	add    $0x2c,%esp
  800dd1:	5b                   	pop    %ebx
  800dd2:	5e                   	pop    %esi
  800dd3:	5f                   	pop    %edi
  800dd4:	5d                   	pop    %ebp
  800dd5:	c3                   	ret    

00800dd6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	57                   	push   %edi
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddc:	be 00 00 00 00       	mov    $0x0,%esi
  800de1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800def:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df2:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    

00800df9 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
  800dff:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e02:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e07:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	89 cb                	mov    %ecx,%ebx
  800e11:	89 cf                	mov    %ecx,%edi
  800e13:	89 ce                	mov    %ecx,%esi
  800e15:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	7e 28                	jle    800e43 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e1f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e26:	00 
  800e27:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800e2e:	00 
  800e2f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e36:	00 
  800e37:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800e3e:	e8 23 14 00 00       	call   802266 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e43:	83 c4 2c             	add    $0x2c,%esp
  800e46:	5b                   	pop    %ebx
  800e47:	5e                   	pop    %esi
  800e48:	5f                   	pop    %edi
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	57                   	push   %edi
  800e4f:	56                   	push   %esi
  800e50:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e51:	ba 00 00 00 00       	mov    $0x0,%edx
  800e56:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e5b:	89 d1                	mov    %edx,%ecx
  800e5d:	89 d3                	mov    %edx,%ebx
  800e5f:	89 d7                	mov    %edx,%edi
  800e61:	89 d6                	mov    %edx,%esi
  800e63:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e65:	5b                   	pop    %ebx
  800e66:	5e                   	pop    %esi
  800e67:	5f                   	pop    %edi
  800e68:	5d                   	pop    %ebp
  800e69:	c3                   	ret    

00800e6a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
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
  800e78:	b8 0f 00 00 00       	mov    $0xf,%eax
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
  800e8b:	7e 28                	jle    800eb5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e91:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e98:	00 
  800e99:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800ea0:	00 
  800ea1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea8:	00 
  800ea9:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800eb0:	e8 b1 13 00 00       	call   802266 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800eb5:	83 c4 2c             	add    $0x2c,%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
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
  800ecb:	b8 10 00 00 00       	mov    $0x10,%eax
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
  800ede:	7e 28                	jle    800f08 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800eeb:	00 
  800eec:	c7 44 24 08 bf 29 80 	movl   $0x8029bf,0x8(%esp)
  800ef3:	00 
  800ef4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efb:	00 
  800efc:	c7 04 24 dc 29 80 00 	movl   $0x8029dc,(%esp)
  800f03:	e8 5e 13 00 00       	call   802266 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800f08:	83 c4 2c             	add    $0x2c,%esp
  800f0b:	5b                   	pop    %ebx
  800f0c:	5e                   	pop    %esi
  800f0d:	5f                   	pop    %edi
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  800f16:	83 3d 0c 40 80 00 00 	cmpl   $0x0,0x80400c
  800f1d:	75 58                	jne    800f77 <set_pgfault_handler+0x67>
		// First time through!
		// LAB 4: Your code here.

		int return_code = sys_page_alloc(thisenv->env_id,(void*)(UXSTACKTOP-PGSIZE),PTE_W|PTE_U|PTE_P);
  800f1f:	a1 08 40 80 00       	mov    0x804008,%eax
  800f24:	8b 40 48             	mov    0x48(%eax),%eax
  800f27:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f2e:	00 
  800f2f:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  800f36:	ee 
  800f37:	89 04 24             	mov    %eax,(%esp)
  800f3a:	e8 a4 fc ff ff       	call   800be3 <sys_page_alloc>
		if(return_code!=0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	74 1c                	je     800f5f <set_pgfault_handler+0x4f>
			panic("Error in registering handler, tried to allocate a page in UserException stack but failed");
  800f43:	c7 44 24 08 ec 29 80 	movl   $0x8029ec,0x8(%esp)
  800f4a:	00 
  800f4b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f52:	00 
  800f53:	c7 04 24 45 2a 80 00 	movl   $0x802a45,(%esp)
  800f5a:	e8 07 13 00 00       	call   802266 <_panic>
		sys_env_set_pgfault_upcall(thisenv->env_id,_pgfault_upcall);
  800f5f:	a1 08 40 80 00       	mov    0x804008,%eax
  800f64:	8b 40 48             	mov    0x48(%eax),%eax
  800f67:	c7 44 24 04 81 0f 80 	movl   $0x800f81,0x4(%esp)
  800f6e:	00 
  800f6f:	89 04 24             	mov    %eax,(%esp)
  800f72:	e8 0c fe ff ff       	call   800d83 <sys_env_set_pgfault_upcall>


	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	a3 0c 40 80 00       	mov    %eax,0x80400c
}
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800f81:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800f82:	a1 0c 40 80 00       	mov    0x80400c,%eax
	call *%eax
  800f87:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800f89:	83 c4 04             	add    $0x4,%esp
	// LAB 4: Your code here.


	//Stack is going to change
	
	movl %esp,%ebp;
  800f8c:	89 e5                	mov    %esp,%ebp

	//Retrieve Trap time eip value

	movl 0x28(%esp),%eax;
  800f8e:	8b 44 24 28          	mov    0x28(%esp),%eax

	//Move to userstack to pushin the traptime eip value in the userstack

	movl 0x30(%esp),%esp;
  800f92:	8b 64 24 30          	mov    0x30(%esp),%esp

	//push in the traptime eip value to the userstack

	push %eax;
  800f96:	50                   	push   %eax

	//temporarily store esp value in a register

	movl %esp,%ebx;
  800f97:	89 e3                	mov    %esp,%ebx

	//return back to the userexception stack to complete register restore , use value in ebp register to move back to the user exception stack

	movl %ebp,%esp;
  800f99:	89 ec                	mov    %ebp,%esp

	//update the trap-time esp value to reflect the new esp value containing the traptime eip

	movl %ebx,0x30(%esp);
  800f9b:	89 5c 24 30          	mov    %ebx,0x30(%esp)
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.


	popl %eax;
  800f9f:	58                   	pop    %eax
	popl %eax;
  800fa0:	58                   	pop    %eax
	popal;
  800fa1:	61                   	popa   

	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4,%esp;
  800fa2:	83 c4 04             	add    $0x4,%esp
	popfl;
  800fa5:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp;
  800fa6:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	ret;
  800fa7:	c3                   	ret    
  800fa8:	66 90                	xchg   %ax,%ax
  800faa:	66 90                	xchg   %ax,%ax
  800fac:	66 90                	xchg   %ax,%ax
  800fae:	66 90                	xchg   %ax,%ax

00800fb0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	05 00 00 00 30       	add    $0x30000000,%eax
  800fbb:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc6:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800fcb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fd0:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fdd:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fe2:	89 c2                	mov    %eax,%edx
  800fe4:	c1 ea 16             	shr    $0x16,%edx
  800fe7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fee:	f6 c2 01             	test   $0x1,%dl
  800ff1:	74 11                	je     801004 <fd_alloc+0x2d>
  800ff3:	89 c2                	mov    %eax,%edx
  800ff5:	c1 ea 0c             	shr    $0xc,%edx
  800ff8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fff:	f6 c2 01             	test   $0x1,%dl
  801002:	75 09                	jne    80100d <fd_alloc+0x36>
			*fd_store = fd;
  801004:	89 01                	mov    %eax,(%ecx)
			return 0;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	eb 17                	jmp    801024 <fd_alloc+0x4d>
  80100d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801012:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801017:	75 c9                	jne    800fe2 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801019:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80101f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80102c:	83 f8 1f             	cmp    $0x1f,%eax
  80102f:	77 36                	ja     801067 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801031:	c1 e0 0c             	shl    $0xc,%eax
  801034:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801039:	89 c2                	mov    %eax,%edx
  80103b:	c1 ea 16             	shr    $0x16,%edx
  80103e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801045:	f6 c2 01             	test   $0x1,%dl
  801048:	74 24                	je     80106e <fd_lookup+0x48>
  80104a:	89 c2                	mov    %eax,%edx
  80104c:	c1 ea 0c             	shr    $0xc,%edx
  80104f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801056:	f6 c2 01             	test   $0x1,%dl
  801059:	74 1a                	je     801075 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80105b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80105e:	89 02                	mov    %eax,(%edx)
	return 0;
  801060:	b8 00 00 00 00       	mov    $0x0,%eax
  801065:	eb 13                	jmp    80107a <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  801067:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106c:	eb 0c                	jmp    80107a <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  80106e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801073:	eb 05                	jmp    80107a <fd_lookup+0x54>
  801075:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	83 ec 18             	sub    $0x18,%esp
  801082:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  801085:	ba 00 00 00 00       	mov    $0x0,%edx
  80108a:	eb 13                	jmp    80109f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  80108c:	39 08                	cmp    %ecx,(%eax)
  80108e:	75 0c                	jne    80109c <dev_lookup+0x20>
			*dev = devtab[i];
  801090:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801093:	89 01                	mov    %eax,(%ecx)
			return 0;
  801095:	b8 00 00 00 00       	mov    $0x0,%eax
  80109a:	eb 38                	jmp    8010d4 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80109c:	83 c2 01             	add    $0x1,%edx
  80109f:	8b 04 95 d0 2a 80 00 	mov    0x802ad0(,%edx,4),%eax
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	75 e2                	jne    80108c <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8010af:	8b 40 48             	mov    0x48(%eax),%eax
  8010b2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8010b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010ba:	c7 04 24 54 2a 80 00 	movl   $0x802a54,(%esp)
  8010c1:	e8 da f0 ff ff       	call   8001a0 <cprintf>
	*dev = 0;
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	56                   	push   %esi
  8010da:	53                   	push   %ebx
  8010db:	83 ec 20             	sub    $0x20,%esp
  8010de:	8b 75 08             	mov    0x8(%ebp),%esi
  8010e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010e7:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010eb:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010f1:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f4:	89 04 24             	mov    %eax,(%esp)
  8010f7:	e8 2a ff ff ff       	call   801026 <fd_lookup>
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	78 05                	js     801105 <fd_close+0x2f>
	    || fd != fd2)
  801100:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801103:	74 0c                	je     801111 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801105:	84 db                	test   %bl,%bl
  801107:	ba 00 00 00 00       	mov    $0x0,%edx
  80110c:	0f 44 c2             	cmove  %edx,%eax
  80110f:	eb 3f                	jmp    801150 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801111:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801114:	89 44 24 04          	mov    %eax,0x4(%esp)
  801118:	8b 06                	mov    (%esi),%eax
  80111a:	89 04 24             	mov    %eax,(%esp)
  80111d:	e8 5a ff ff ff       	call   80107c <dev_lookup>
  801122:	89 c3                	mov    %eax,%ebx
  801124:	85 c0                	test   %eax,%eax
  801126:	78 16                	js     80113e <fd_close+0x68>
		if (dev->dev_close)
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80112e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  801133:	85 c0                	test   %eax,%eax
  801135:	74 07                	je     80113e <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  801137:	89 34 24             	mov    %esi,(%esp)
  80113a:	ff d0                	call   *%eax
  80113c:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  80113e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801149:	e8 3c fb ff ff       	call   800c8a <sys_page_unmap>
	return r;
  80114e:	89 d8                	mov    %ebx,%eax
}
  801150:	83 c4 20             	add    $0x20,%esp
  801153:	5b                   	pop    %ebx
  801154:	5e                   	pop    %esi
  801155:	5d                   	pop    %ebp
  801156:	c3                   	ret    

00801157 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801160:	89 44 24 04          	mov    %eax,0x4(%esp)
  801164:	8b 45 08             	mov    0x8(%ebp),%eax
  801167:	89 04 24             	mov    %eax,(%esp)
  80116a:	e8 b7 fe ff ff       	call   801026 <fd_lookup>
  80116f:	89 c2                	mov    %eax,%edx
  801171:	85 d2                	test   %edx,%edx
  801173:	78 13                	js     801188 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  801175:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80117c:	00 
  80117d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801180:	89 04 24             	mov    %eax,(%esp)
  801183:	e8 4e ff ff ff       	call   8010d6 <fd_close>
}
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <close_all>:

void
close_all(void)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	53                   	push   %ebx
  80118e:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801191:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801196:	89 1c 24             	mov    %ebx,(%esp)
  801199:	e8 b9 ff ff ff       	call   801157 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80119e:	83 c3 01             	add    $0x1,%ebx
  8011a1:	83 fb 20             	cmp    $0x20,%ebx
  8011a4:	75 f0                	jne    801196 <close_all+0xc>
		close(i);
}
  8011a6:	83 c4 14             	add    $0x14,%esp
  8011a9:	5b                   	pop    %ebx
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    

008011ac <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	57                   	push   %edi
  8011b0:	56                   	push   %esi
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bf:	89 04 24             	mov    %eax,(%esp)
  8011c2:	e8 5f fe ff ff       	call   801026 <fd_lookup>
  8011c7:	89 c2                	mov    %eax,%edx
  8011c9:	85 d2                	test   %edx,%edx
  8011cb:	0f 88 e1 00 00 00    	js     8012b2 <dup+0x106>
		return r;
	close(newfdnum);
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	89 04 24             	mov    %eax,(%esp)
  8011d7:	e8 7b ff ff ff       	call   801157 <close>

	newfd = INDEX2FD(newfdnum);
  8011dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011df:	c1 e3 0c             	shl    $0xc,%ebx
  8011e2:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  8011e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011eb:	89 04 24             	mov    %eax,(%esp)
  8011ee:	e8 cd fd ff ff       	call   800fc0 <fd2data>
  8011f3:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  8011f5:	89 1c 24             	mov    %ebx,(%esp)
  8011f8:	e8 c3 fd ff ff       	call   800fc0 <fd2data>
  8011fd:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011ff:	89 f0                	mov    %esi,%eax
  801201:	c1 e8 16             	shr    $0x16,%eax
  801204:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80120b:	a8 01                	test   $0x1,%al
  80120d:	74 43                	je     801252 <dup+0xa6>
  80120f:	89 f0                	mov    %esi,%eax
  801211:	c1 e8 0c             	shr    $0xc,%eax
  801214:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80121b:	f6 c2 01             	test   $0x1,%dl
  80121e:	74 32                	je     801252 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801220:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801227:	25 07 0e 00 00       	and    $0xe07,%eax
  80122c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801230:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801234:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80123b:	00 
  80123c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801240:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801247:	e8 eb f9 ff ff       	call   800c37 <sys_page_map>
  80124c:	89 c6                	mov    %eax,%esi
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 3e                	js     801290 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801255:	89 c2                	mov    %eax,%edx
  801257:	c1 ea 0c             	shr    $0xc,%edx
  80125a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801261:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801267:	89 54 24 10          	mov    %edx,0x10(%esp)
  80126b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80126f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801276:	00 
  801277:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801282:	e8 b0 f9 ff ff       	call   800c37 <sys_page_map>
  801287:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80128c:	85 f6                	test   %esi,%esi
  80128e:	79 22                	jns    8012b2 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801290:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801294:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80129b:	e8 ea f9 ff ff       	call   800c8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012a0:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8012a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012ab:	e8 da f9 ff ff       	call   800c8a <sys_page_unmap>
	return r;
  8012b0:	89 f0                	mov    %esi,%eax
}
  8012b2:	83 c4 3c             	add    $0x3c,%esp
  8012b5:	5b                   	pop    %ebx
  8012b6:	5e                   	pop    %esi
  8012b7:	5f                   	pop    %edi
  8012b8:	5d                   	pop    %ebp
  8012b9:	c3                   	ret    

008012ba <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ba:	55                   	push   %ebp
  8012bb:	89 e5                	mov    %esp,%ebp
  8012bd:	53                   	push   %ebx
  8012be:	83 ec 24             	sub    $0x24,%esp
  8012c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012cb:	89 1c 24             	mov    %ebx,(%esp)
  8012ce:	e8 53 fd ff ff       	call   801026 <fd_lookup>
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	85 d2                	test   %edx,%edx
  8012d7:	78 6d                	js     801346 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	89 04 24             	mov    %eax,(%esp)
  8012e8:	e8 8f fd ff ff       	call   80107c <dev_lookup>
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 55                	js     801346 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f4:	8b 50 08             	mov    0x8(%eax),%edx
  8012f7:	83 e2 03             	and    $0x3,%edx
  8012fa:	83 fa 01             	cmp    $0x1,%edx
  8012fd:	75 23                	jne    801322 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012ff:	a1 08 40 80 00       	mov    0x804008,%eax
  801304:	8b 40 48             	mov    0x48(%eax),%eax
  801307:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80130b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130f:	c7 04 24 95 2a 80 00 	movl   $0x802a95,(%esp)
  801316:	e8 85 ee ff ff       	call   8001a0 <cprintf>
		return -E_INVAL;
  80131b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801320:	eb 24                	jmp    801346 <read+0x8c>
	}
	if (!dev->dev_read)
  801322:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801325:	8b 52 08             	mov    0x8(%edx),%edx
  801328:	85 d2                	test   %edx,%edx
  80132a:	74 15                	je     801341 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80132c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80132f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801333:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80133a:	89 04 24             	mov    %eax,(%esp)
  80133d:	ff d2                	call   *%edx
  80133f:	eb 05                	jmp    801346 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  801341:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  801346:	83 c4 24             	add    $0x24,%esp
  801349:	5b                   	pop    %ebx
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	57                   	push   %edi
  801350:	56                   	push   %esi
  801351:	53                   	push   %ebx
  801352:	83 ec 1c             	sub    $0x1c,%esp
  801355:	8b 7d 08             	mov    0x8(%ebp),%edi
  801358:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80135b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801360:	eb 23                	jmp    801385 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801362:	89 f0                	mov    %esi,%eax
  801364:	29 d8                	sub    %ebx,%eax
  801366:	89 44 24 08          	mov    %eax,0x8(%esp)
  80136a:	89 d8                	mov    %ebx,%eax
  80136c:	03 45 0c             	add    0xc(%ebp),%eax
  80136f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801373:	89 3c 24             	mov    %edi,(%esp)
  801376:	e8 3f ff ff ff       	call   8012ba <read>
		if (m < 0)
  80137b:	85 c0                	test   %eax,%eax
  80137d:	78 10                	js     80138f <readn+0x43>
			return m;
		if (m == 0)
  80137f:	85 c0                	test   %eax,%eax
  801381:	74 0a                	je     80138d <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801383:	01 c3                	add    %eax,%ebx
  801385:	39 f3                	cmp    %esi,%ebx
  801387:	72 d9                	jb     801362 <readn+0x16>
  801389:	89 d8                	mov    %ebx,%eax
  80138b:	eb 02                	jmp    80138f <readn+0x43>
  80138d:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  80138f:	83 c4 1c             	add    $0x1c,%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	53                   	push   %ebx
  80139b:	83 ec 24             	sub    $0x24,%esp
  80139e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a8:	89 1c 24             	mov    %ebx,(%esp)
  8013ab:	e8 76 fc ff ff       	call   801026 <fd_lookup>
  8013b0:	89 c2                	mov    %eax,%edx
  8013b2:	85 d2                	test   %edx,%edx
  8013b4:	78 68                	js     80141e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	89 04 24             	mov    %eax,(%esp)
  8013c5:	e8 b2 fc ff ff       	call   80107c <dev_lookup>
  8013ca:	85 c0                	test   %eax,%eax
  8013cc:	78 50                	js     80141e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013d5:	75 23                	jne    8013fa <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8013dc:	8b 40 48             	mov    0x48(%eax),%eax
  8013df:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e7:	c7 04 24 b1 2a 80 00 	movl   $0x802ab1,(%esp)
  8013ee:	e8 ad ed ff ff       	call   8001a0 <cprintf>
		return -E_INVAL;
  8013f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013f8:	eb 24                	jmp    80141e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013fd:	8b 52 0c             	mov    0xc(%edx),%edx
  801400:	85 d2                	test   %edx,%edx
  801402:	74 15                	je     801419 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801404:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801407:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80140b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80140e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801412:	89 04 24             	mov    %eax,(%esp)
  801415:	ff d2                	call   *%edx
  801417:	eb 05                	jmp    80141e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801419:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80141e:	83 c4 24             	add    $0x24,%esp
  801421:	5b                   	pop    %ebx
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <seek>:

int
seek(int fdnum, off_t offset)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80142a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80142d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	e8 ea fb ff ff       	call   801026 <fd_lookup>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 0e                	js     80144e <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801440:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801443:	8b 55 0c             	mov    0xc(%ebp),%edx
  801446:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801449:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	53                   	push   %ebx
  801454:	83 ec 24             	sub    $0x24,%esp
  801457:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801461:	89 1c 24             	mov    %ebx,(%esp)
  801464:	e8 bd fb ff ff       	call   801026 <fd_lookup>
  801469:	89 c2                	mov    %eax,%edx
  80146b:	85 d2                	test   %edx,%edx
  80146d:	78 61                	js     8014d0 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801472:	89 44 24 04          	mov    %eax,0x4(%esp)
  801476:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801479:	8b 00                	mov    (%eax),%eax
  80147b:	89 04 24             	mov    %eax,(%esp)
  80147e:	e8 f9 fb ff ff       	call   80107c <dev_lookup>
  801483:	85 c0                	test   %eax,%eax
  801485:	78 49                	js     8014d0 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801487:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148e:	75 23                	jne    8014b3 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801490:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801495:	8b 40 48             	mov    0x48(%eax),%eax
  801498:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a0:	c7 04 24 74 2a 80 00 	movl   $0x802a74,(%esp)
  8014a7:	e8 f4 ec ff ff       	call   8001a0 <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  8014ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014b1:	eb 1d                	jmp    8014d0 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  8014b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b6:	8b 52 18             	mov    0x18(%edx),%edx
  8014b9:	85 d2                	test   %edx,%edx
  8014bb:	74 0e                	je     8014cb <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c0:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8014c4:	89 04 24             	mov    %eax,(%esp)
  8014c7:	ff d2                	call   *%edx
  8014c9:	eb 05                	jmp    8014d0 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  8014cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  8014d0:	83 c4 24             	add    $0x24,%esp
  8014d3:	5b                   	pop    %ebx
  8014d4:	5d                   	pop    %ebp
  8014d5:	c3                   	ret    

008014d6 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	53                   	push   %ebx
  8014da:	83 ec 24             	sub    $0x24,%esp
  8014dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	89 04 24             	mov    %eax,(%esp)
  8014ed:	e8 34 fb ff ff       	call   801026 <fd_lookup>
  8014f2:	89 c2                	mov    %eax,%edx
  8014f4:	85 d2                	test   %edx,%edx
  8014f6:	78 52                	js     80154a <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	89 04 24             	mov    %eax,(%esp)
  801507:	e8 70 fb ff ff       	call   80107c <dev_lookup>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 3a                	js     80154a <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801513:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801517:	74 2c                	je     801545 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801519:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80151c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801523:	00 00 00 
	stat->st_isdir = 0;
  801526:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80152d:	00 00 00 
	stat->st_dev = dev;
  801530:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801536:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80153a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80153d:	89 14 24             	mov    %edx,(%esp)
  801540:	ff 50 14             	call   *0x14(%eax)
  801543:	eb 05                	jmp    80154a <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  801545:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  80154a:	83 c4 24             	add    $0x24,%esp
  80154d:	5b                   	pop    %ebx
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	56                   	push   %esi
  801554:	53                   	push   %ebx
  801555:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801558:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80155f:	00 
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	89 04 24             	mov    %eax,(%esp)
  801566:	e8 28 02 00 00       	call   801793 <open>
  80156b:	89 c3                	mov    %eax,%ebx
  80156d:	85 db                	test   %ebx,%ebx
  80156f:	78 1b                	js     80158c <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	89 44 24 04          	mov    %eax,0x4(%esp)
  801578:	89 1c 24             	mov    %ebx,(%esp)
  80157b:	e8 56 ff ff ff       	call   8014d6 <fstat>
  801580:	89 c6                	mov    %eax,%esi
	close(fd);
  801582:	89 1c 24             	mov    %ebx,(%esp)
  801585:	e8 cd fb ff ff       	call   801157 <close>
	return r;
  80158a:	89 f0                	mov    %esi,%eax
}
  80158c:	83 c4 10             	add    $0x10,%esp
  80158f:	5b                   	pop    %ebx
  801590:	5e                   	pop    %esi
  801591:	5d                   	pop    %ebp
  801592:	c3                   	ret    

00801593 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	56                   	push   %esi
  801597:	53                   	push   %ebx
  801598:	83 ec 10             	sub    $0x10,%esp
  80159b:	89 c6                	mov    %eax,%esi
  80159d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80159f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a6:	75 11                	jne    8015b9 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8015af:	e8 d0 0d 00 00       	call   802384 <ipc_find_env>
  8015b4:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015b9:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015c0:	00 
  8015c1:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015c8:	00 
  8015c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015cd:	a1 00 40 80 00       	mov    0x804000,%eax
  8015d2:	89 04 24             	mov    %eax,(%esp)
  8015d5:	e8 4c 0d 00 00       	call   802326 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015da:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015e1:	00 
  8015e2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ed:	e8 ca 0c 00 00       	call   8022bc <ipc_recv>
}
  8015f2:	83 c4 10             	add    $0x10,%esp
  8015f5:	5b                   	pop    %ebx
  8015f6:	5e                   	pop    %esi
  8015f7:	5d                   	pop    %ebp
  8015f8:	c3                   	ret    

008015f9 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f9:	55                   	push   %ebp
  8015fa:	89 e5                	mov    %esp,%ebp
  8015fc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801602:	8b 40 0c             	mov    0xc(%eax),%eax
  801605:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80160a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80160d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801612:	ba 00 00 00 00       	mov    $0x0,%edx
  801617:	b8 02 00 00 00       	mov    $0x2,%eax
  80161c:	e8 72 ff ff ff       	call   801593 <fsipc>
}
  801621:	c9                   	leave  
  801622:	c3                   	ret    

00801623 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801629:	8b 45 08             	mov    0x8(%ebp),%eax
  80162c:	8b 40 0c             	mov    0xc(%eax),%eax
  80162f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	b8 06 00 00 00       	mov    $0x6,%eax
  80163e:	e8 50 ff ff ff       	call   801593 <fsipc>
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	53                   	push   %ebx
  801649:	83 ec 14             	sub    $0x14,%esp
  80164c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	8b 40 0c             	mov    0xc(%eax),%eax
  801655:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	b8 05 00 00 00       	mov    $0x5,%eax
  801664:	e8 2a ff ff ff       	call   801593 <fsipc>
  801669:	89 c2                	mov    %eax,%edx
  80166b:	85 d2                	test   %edx,%edx
  80166d:	78 2b                	js     80169a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80166f:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801676:	00 
  801677:	89 1c 24             	mov    %ebx,(%esp)
  80167a:	e8 48 f1 ff ff       	call   8007c7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80167f:	a1 80 50 80 00       	mov    0x805080,%eax
  801684:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80168a:	a1 84 50 80 00       	mov    0x805084,%eax
  80168f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801695:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169a:	83 c4 14             	add    $0x14,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5d                   	pop    %ebp
  80169f:	c3                   	ret    

008016a0 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 18             	sub    $0x18,%esp
  8016a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a9:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8016ae:	ba f8 0f 00 00       	mov    $0xff8,%edx
  8016b3:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  8016b6:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016be:	8b 52 0c             	mov    0xc(%edx),%edx
  8016c1:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  8016c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d2:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  8016d9:	e8 86 f2 ff ff       	call   800964 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  8016de:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e3:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e8:	e8 a6 fe ff ff       	call   801593 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	56                   	push   %esi
  8016f3:	53                   	push   %ebx
  8016f4:	83 ec 10             	sub    $0x10,%esp
  8016f7:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801700:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801705:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80170b:	ba 00 00 00 00       	mov    $0x0,%edx
  801710:	b8 03 00 00 00       	mov    $0x3,%eax
  801715:	e8 79 fe ff ff       	call   801593 <fsipc>
  80171a:	89 c3                	mov    %eax,%ebx
  80171c:	85 c0                	test   %eax,%eax
  80171e:	78 6a                	js     80178a <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801720:	39 c6                	cmp    %eax,%esi
  801722:	73 24                	jae    801748 <devfile_read+0x59>
  801724:	c7 44 24 0c e4 2a 80 	movl   $0x802ae4,0xc(%esp)
  80172b:	00 
  80172c:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801733:	00 
  801734:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  80173b:	00 
  80173c:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  801743:	e8 1e 0b 00 00       	call   802266 <_panic>
	assert(r <= PGSIZE);
  801748:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174d:	7e 24                	jle    801773 <devfile_read+0x84>
  80174f:	c7 44 24 0c 0b 2b 80 	movl   $0x802b0b,0xc(%esp)
  801756:	00 
  801757:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  80175e:	00 
  80175f:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  801766:	00 
  801767:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  80176e:	e8 f3 0a 00 00       	call   802266 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801773:	89 44 24 08          	mov    %eax,0x8(%esp)
  801777:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80177e:	00 
  80177f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801782:	89 04 24             	mov    %eax,(%esp)
  801785:	e8 da f1 ff ff       	call   800964 <memmove>
	return r;
}
  80178a:	89 d8                	mov    %ebx,%eax
  80178c:	83 c4 10             	add    $0x10,%esp
  80178f:	5b                   	pop    %ebx
  801790:	5e                   	pop    %esi
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	53                   	push   %ebx
  801797:	83 ec 24             	sub    $0x24,%esp
  80179a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80179d:	89 1c 24             	mov    %ebx,(%esp)
  8017a0:	e8 eb ef ff ff       	call   800790 <strlen>
  8017a5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017aa:	7f 60                	jg     80180c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  8017ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017af:	89 04 24             	mov    %eax,(%esp)
  8017b2:	e8 20 f8 ff ff       	call   800fd7 <fd_alloc>
  8017b7:	89 c2                	mov    %eax,%edx
  8017b9:	85 d2                	test   %edx,%edx
  8017bb:	78 54                	js     801811 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  8017bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c1:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8017c8:	e8 fa ef ff ff       	call   8007c7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d0:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d8:	b8 01 00 00 00       	mov    $0x1,%eax
  8017dd:	e8 b1 fd ff ff       	call   801593 <fsipc>
  8017e2:	89 c3                	mov    %eax,%ebx
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	79 17                	jns    8017ff <open+0x6c>
		fd_close(fd, 0);
  8017e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017ef:	00 
  8017f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f3:	89 04 24             	mov    %eax,(%esp)
  8017f6:	e8 db f8 ff ff       	call   8010d6 <fd_close>
		return r;
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	eb 12                	jmp    801811 <open+0x7e>
	}

	return fd2num(fd);
  8017ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801802:	89 04 24             	mov    %eax,(%esp)
  801805:	e8 a6 f7 ff ff       	call   800fb0 <fd2num>
  80180a:	eb 05                	jmp    801811 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80180c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801811:	83 c4 24             	add    $0x24,%esp
  801814:	5b                   	pop    %ebx
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	b8 08 00 00 00       	mov    $0x8,%eax
  801827:	e8 67 fd ff ff       	call   801593 <fsipc>
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    
  80182e:	66 90                	xchg   %ax,%ax

00801830 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801836:	c7 44 24 04 17 2b 80 	movl   $0x802b17,0x4(%esp)
  80183d:	00 
  80183e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801841:	89 04 24             	mov    %eax,(%esp)
  801844:	e8 7e ef ff ff       	call   8007c7 <strcpy>
	return 0;
}
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	53                   	push   %ebx
  801854:	83 ec 14             	sub    $0x14,%esp
  801857:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80185a:	89 1c 24             	mov    %ebx,(%esp)
  80185d:	e8 5a 0b 00 00       	call   8023bc <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  801867:	83 f8 01             	cmp    $0x1,%eax
  80186a:	75 0d                	jne    801879 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  80186c:	8b 43 0c             	mov    0xc(%ebx),%eax
  80186f:	89 04 24             	mov    %eax,(%esp)
  801872:	e8 29 03 00 00       	call   801ba0 <nsipc_close>
  801877:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  801879:	89 d0                	mov    %edx,%eax
  80187b:	83 c4 14             	add    $0x14,%esp
  80187e:	5b                   	pop    %ebx
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    

00801881 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801887:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80188e:	00 
  80188f:	8b 45 10             	mov    0x10(%ebp),%eax
  801892:	89 44 24 08          	mov    %eax,0x8(%esp)
  801896:	8b 45 0c             	mov    0xc(%ebp),%eax
  801899:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a3:	89 04 24             	mov    %eax,(%esp)
  8018a6:	e8 f0 03 00 00       	call   801c9b <nsipc_send>
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8018ba:	00 
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cc:	8b 40 0c             	mov    0xc(%eax),%eax
  8018cf:	89 04 24             	mov    %eax,(%esp)
  8018d2:	e8 44 03 00 00       	call   801c1b <nsipc_recv>
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018df:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018e6:	89 04 24             	mov    %eax,(%esp)
  8018e9:	e8 38 f7 ff ff       	call   801026 <fd_lookup>
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	78 17                	js     801909 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f5:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018fb:	39 08                	cmp    %ecx,(%eax)
  8018fd:	75 05                	jne    801904 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8018ff:	8b 40 0c             	mov    0xc(%eax),%eax
  801902:	eb 05                	jmp    801909 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801904:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	56                   	push   %esi
  80190f:	53                   	push   %ebx
  801910:	83 ec 20             	sub    $0x20,%esp
  801913:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801915:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801918:	89 04 24             	mov    %eax,(%esp)
  80191b:	e8 b7 f6 ff ff       	call   800fd7 <fd_alloc>
  801920:	89 c3                	mov    %eax,%ebx
  801922:	85 c0                	test   %eax,%eax
  801924:	78 21                	js     801947 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801926:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80192d:	00 
  80192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801931:	89 44 24 04          	mov    %eax,0x4(%esp)
  801935:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80193c:	e8 a2 f2 ff ff       	call   800be3 <sys_page_alloc>
  801941:	89 c3                	mov    %eax,%ebx
  801943:	85 c0                	test   %eax,%eax
  801945:	79 0c                	jns    801953 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  801947:	89 34 24             	mov    %esi,(%esp)
  80194a:	e8 51 02 00 00       	call   801ba0 <nsipc_close>
		return r;
  80194f:	89 d8                	mov    %ebx,%eax
  801951:	eb 20                	jmp    801973 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801953:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195c:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80195e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801961:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  801968:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  80196b:	89 14 24             	mov    %edx,(%esp)
  80196e:	e8 3d f6 ff ff       	call   800fb0 <fd2num>
}
  801973:	83 c4 20             	add    $0x20,%esp
  801976:	5b                   	pop    %ebx
  801977:	5e                   	pop    %esi
  801978:	5d                   	pop    %ebp
  801979:	c3                   	ret    

0080197a <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
  80197d:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	e8 51 ff ff ff       	call   8018d9 <fd2sockid>
		return r;
  801988:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 23                	js     8019b1 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80198e:	8b 55 10             	mov    0x10(%ebp),%edx
  801991:	89 54 24 08          	mov    %edx,0x8(%esp)
  801995:	8b 55 0c             	mov    0xc(%ebp),%edx
  801998:	89 54 24 04          	mov    %edx,0x4(%esp)
  80199c:	89 04 24             	mov    %eax,(%esp)
  80199f:	e8 45 01 00 00       	call   801ae9 <nsipc_accept>
		return r;
  8019a4:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 07                	js     8019b1 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  8019aa:	e8 5c ff ff ff       	call   80190b <alloc_sockfd>
  8019af:	89 c1                	mov    %eax,%ecx
}
  8019b1:	89 c8                	mov    %ecx,%eax
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	e8 16 ff ff ff       	call   8018d9 <fd2sockid>
  8019c3:	89 c2                	mov    %eax,%edx
  8019c5:	85 d2                	test   %edx,%edx
  8019c7:	78 16                	js     8019df <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  8019c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8019cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d7:	89 14 24             	mov    %edx,(%esp)
  8019da:	e8 60 01 00 00       	call   801b3f <nsipc_bind>
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <shutdown>:

int
shutdown(int s, int how)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	e8 ea fe ff ff       	call   8018d9 <fd2sockid>
  8019ef:	89 c2                	mov    %eax,%edx
  8019f1:	85 d2                	test   %edx,%edx
  8019f3:	78 0f                	js     801a04 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  8019f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fc:	89 14 24             	mov    %edx,(%esp)
  8019ff:	e8 7a 01 00 00       	call   801b7e <nsipc_shutdown>
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	e8 c5 fe ff ff       	call   8018d9 <fd2sockid>
  801a14:	89 c2                	mov    %eax,%edx
  801a16:	85 d2                	test   %edx,%edx
  801a18:	78 16                	js     801a30 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  801a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a21:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a28:	89 14 24             	mov    %edx,(%esp)
  801a2b:	e8 8a 01 00 00       	call   801bba <nsipc_connect>
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <listen>:

int
listen(int s, int backlog)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	e8 99 fe ff ff       	call   8018d9 <fd2sockid>
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	85 d2                	test   %edx,%edx
  801a44:	78 0f                	js     801a55 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  801a46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4d:	89 14 24             	mov    %edx,(%esp)
  801a50:	e8 a4 01 00 00       	call   801bf9 <nsipc_listen>
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a60:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	89 04 24             	mov    %eax,(%esp)
  801a71:	e8 98 02 00 00       	call   801d0e <nsipc_socket>
  801a76:	89 c2                	mov    %eax,%edx
  801a78:	85 d2                	test   %edx,%edx
  801a7a:	78 05                	js     801a81 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  801a7c:	e8 8a fe ff ff       	call   80190b <alloc_sockfd>
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	53                   	push   %ebx
  801a87:	83 ec 14             	sub    $0x14,%esp
  801a8a:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a8c:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a93:	75 11                	jne    801aa6 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a95:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a9c:	e8 e3 08 00 00       	call   802384 <ipc_find_env>
  801aa1:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aa6:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801aad:	00 
  801aae:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801ab5:	00 
  801ab6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aba:	a1 04 40 80 00       	mov    0x804004,%eax
  801abf:	89 04 24             	mov    %eax,(%esp)
  801ac2:	e8 5f 08 00 00       	call   802326 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ace:	00 
  801acf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ad6:	00 
  801ad7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ade:	e8 d9 07 00 00       	call   8022bc <ipc_recv>
}
  801ae3:	83 c4 14             	add    $0x14,%esp
  801ae6:	5b                   	pop    %ebx
  801ae7:	5d                   	pop    %ebp
  801ae8:	c3                   	ret    

00801ae9 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	56                   	push   %esi
  801aed:	53                   	push   %ebx
  801aee:	83 ec 10             	sub    $0x10,%esp
  801af1:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801afc:	8b 06                	mov    (%esi),%eax
  801afe:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b03:	b8 01 00 00 00       	mov    $0x1,%eax
  801b08:	e8 76 ff ff ff       	call   801a83 <nsipc>
  801b0d:	89 c3                	mov    %eax,%ebx
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 23                	js     801b36 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b13:	a1 10 60 80 00       	mov    0x806010,%eax
  801b18:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b1c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801b23:	00 
  801b24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b27:	89 04 24             	mov    %eax,(%esp)
  801b2a:	e8 35 ee ff ff       	call   800964 <memmove>
		*addrlen = ret->ret_addrlen;
  801b2f:	a1 10 60 80 00       	mov    0x806010,%eax
  801b34:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801b36:	89 d8                	mov    %ebx,%eax
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	5b                   	pop    %ebx
  801b3c:	5e                   	pop    %esi
  801b3d:	5d                   	pop    %ebp
  801b3e:	c3                   	ret    

00801b3f <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
  801b42:	53                   	push   %ebx
  801b43:	83 ec 14             	sub    $0x14,%esp
  801b46:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b51:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b63:	e8 fc ed ff ff       	call   800964 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b68:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b6e:	b8 02 00 00 00       	mov    $0x2,%eax
  801b73:	e8 0b ff ff ff       	call   801a83 <nsipc>
}
  801b78:	83 c4 14             	add    $0x14,%esp
  801b7b:	5b                   	pop    %ebx
  801b7c:	5d                   	pop    %ebp
  801b7d:	c3                   	ret    

00801b7e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b84:	8b 45 08             	mov    0x8(%ebp),%eax
  801b87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b94:	b8 03 00 00 00       	mov    $0x3,%eax
  801b99:	e8 e5 fe ff ff       	call   801a83 <nsipc>
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <nsipc_close>:

int
nsipc_close(int s)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
  801ba3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801bae:	b8 04 00 00 00       	mov    $0x4,%eax
  801bb3:	e8 cb fe ff ff       	call   801a83 <nsipc>
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	53                   	push   %ebx
  801bbe:	83 ec 14             	sub    $0x14,%esp
  801bc1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bcc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd7:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801bde:	e8 81 ed ff ff       	call   800964 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801be3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801be9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bee:	e8 90 fe ff ff       	call   801a83 <nsipc>
}
  801bf3:	83 c4 14             	add    $0x14,%esp
  801bf6:	5b                   	pop    %ebx
  801bf7:	5d                   	pop    %ebp
  801bf8:	c3                   	ret    

00801bf9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
  801bfc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bff:	8b 45 08             	mov    0x8(%ebp),%eax
  801c02:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c0f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c14:	e8 6a fe ff ff       	call   801a83 <nsipc>
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	56                   	push   %esi
  801c1f:	53                   	push   %ebx
  801c20:	83 ec 10             	sub    $0x10,%esp
  801c23:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c2e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c34:	8b 45 14             	mov    0x14(%ebp),%eax
  801c37:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c3c:	b8 07 00 00 00       	mov    $0x7,%eax
  801c41:	e8 3d fe ff ff       	call   801a83 <nsipc>
  801c46:	89 c3                	mov    %eax,%ebx
  801c48:	85 c0                	test   %eax,%eax
  801c4a:	78 46                	js     801c92 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801c4c:	39 f0                	cmp    %esi,%eax
  801c4e:	7f 07                	jg     801c57 <nsipc_recv+0x3c>
  801c50:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c55:	7e 24                	jle    801c7b <nsipc_recv+0x60>
  801c57:	c7 44 24 0c 23 2b 80 	movl   $0x802b23,0xc(%esp)
  801c5e:	00 
  801c5f:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801c66:	00 
  801c67:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801c6e:	00 
  801c6f:	c7 04 24 38 2b 80 00 	movl   $0x802b38,(%esp)
  801c76:	e8 eb 05 00 00       	call   802266 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c7b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c7f:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801c86:	00 
  801c87:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8a:	89 04 24             	mov    %eax,(%esp)
  801c8d:	e8 d2 ec ff ff       	call   800964 <memmove>
	}

	return r;
}
  801c92:	89 d8                	mov    %ebx,%eax
  801c94:	83 c4 10             	add    $0x10,%esp
  801c97:	5b                   	pop    %ebx
  801c98:	5e                   	pop    %esi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	53                   	push   %ebx
  801c9f:	83 ec 14             	sub    $0x14,%esp
  801ca2:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cad:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cb3:	7e 24                	jle    801cd9 <nsipc_send+0x3e>
  801cb5:	c7 44 24 0c 44 2b 80 	movl   $0x802b44,0xc(%esp)
  801cbc:	00 
  801cbd:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  801cc4:	00 
  801cc5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801ccc:	00 
  801ccd:	c7 04 24 38 2b 80 00 	movl   $0x802b38,(%esp)
  801cd4:	e8 8d 05 00 00       	call   802266 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cd9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce4:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801ceb:	e8 74 ec ff ff       	call   800964 <memmove>
	nsipcbuf.send.req_size = size;
  801cf0:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801cf6:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf9:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cfe:	b8 08 00 00 00       	mov    $0x8,%eax
  801d03:	e8 7b fd ff ff       	call   801a83 <nsipc>
}
  801d08:	83 c4 14             	add    $0x14,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5d                   	pop    %ebp
  801d0d:	c3                   	ret    

00801d0e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d1f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d24:	8b 45 10             	mov    0x10(%ebp),%eax
  801d27:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d2c:	b8 09 00 00 00       	mov    $0x9,%eax
  801d31:	e8 4d fd ff ff       	call   801a83 <nsipc>
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
  801d3b:	56                   	push   %esi
  801d3c:	53                   	push   %ebx
  801d3d:	83 ec 10             	sub    $0x10,%esp
  801d40:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d43:	8b 45 08             	mov    0x8(%ebp),%eax
  801d46:	89 04 24             	mov    %eax,(%esp)
  801d49:	e8 72 f2 ff ff       	call   800fc0 <fd2data>
  801d4e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d50:	c7 44 24 04 50 2b 80 	movl   $0x802b50,0x4(%esp)
  801d57:	00 
  801d58:	89 1c 24             	mov    %ebx,(%esp)
  801d5b:	e8 67 ea ff ff       	call   8007c7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d60:	8b 46 04             	mov    0x4(%esi),%eax
  801d63:	2b 06                	sub    (%esi),%eax
  801d65:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d6b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d72:	00 00 00 
	stat->st_dev = &devpipe;
  801d75:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d7c:	30 80 00 
	return 0;
}
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	83 c4 10             	add    $0x10,%esp
  801d87:	5b                   	pop    %ebx
  801d88:	5e                   	pop    %esi
  801d89:	5d                   	pop    %ebp
  801d8a:	c3                   	ret    

00801d8b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d8b:	55                   	push   %ebp
  801d8c:	89 e5                	mov    %esp,%ebp
  801d8e:	53                   	push   %ebx
  801d8f:	83 ec 14             	sub    $0x14,%esp
  801d92:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801da0:	e8 e5 ee ff ff       	call   800c8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da5:	89 1c 24             	mov    %ebx,(%esp)
  801da8:	e8 13 f2 ff ff       	call   800fc0 <fd2data>
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db8:	e8 cd ee ff ff       	call   800c8a <sys_page_unmap>
}
  801dbd:	83 c4 14             	add    $0x14,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	57                   	push   %edi
  801dc7:	56                   	push   %esi
  801dc8:	53                   	push   %ebx
  801dc9:	83 ec 2c             	sub    $0x2c,%esp
  801dcc:	89 c6                	mov    %eax,%esi
  801dce:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801dd1:	a1 08 40 80 00       	mov    0x804008,%eax
  801dd6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dd9:	89 34 24             	mov    %esi,(%esp)
  801ddc:	e8 db 05 00 00       	call   8023bc <pageref>
  801de1:	89 c7                	mov    %eax,%edi
  801de3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de6:	89 04 24             	mov    %eax,(%esp)
  801de9:	e8 ce 05 00 00       	call   8023bc <pageref>
  801dee:	39 c7                	cmp    %eax,%edi
  801df0:	0f 94 c2             	sete   %dl
  801df3:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801df6:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801dfc:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801dff:	39 fb                	cmp    %edi,%ebx
  801e01:	74 21                	je     801e24 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801e03:	84 d2                	test   %dl,%dl
  801e05:	74 ca                	je     801dd1 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e07:	8b 51 58             	mov    0x58(%ecx),%edx
  801e0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e0e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e16:	c7 04 24 57 2b 80 00 	movl   $0x802b57,(%esp)
  801e1d:	e8 7e e3 ff ff       	call   8001a0 <cprintf>
  801e22:	eb ad                	jmp    801dd1 <_pipeisclosed+0xe>
	}
}
  801e24:	83 c4 2c             	add    $0x2c,%esp
  801e27:	5b                   	pop    %ebx
  801e28:	5e                   	pop    %esi
  801e29:	5f                   	pop    %edi
  801e2a:	5d                   	pop    %ebp
  801e2b:	c3                   	ret    

00801e2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	57                   	push   %edi
  801e30:	56                   	push   %esi
  801e31:	53                   	push   %ebx
  801e32:	83 ec 1c             	sub    $0x1c,%esp
  801e35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e38:	89 34 24             	mov    %esi,(%esp)
  801e3b:	e8 80 f1 ff ff       	call   800fc0 <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e42:	bf 00 00 00 00       	mov    $0x0,%edi
  801e47:	eb 45                	jmp    801e8e <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e49:	89 da                	mov    %ebx,%edx
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	e8 71 ff ff ff       	call   801dc3 <_pipeisclosed>
  801e52:	85 c0                	test   %eax,%eax
  801e54:	75 41                	jne    801e97 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e56:	e8 69 ed ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e5b:	8b 43 04             	mov    0x4(%ebx),%eax
  801e5e:	8b 0b                	mov    (%ebx),%ecx
  801e60:	8d 51 20             	lea    0x20(%ecx),%edx
  801e63:	39 d0                	cmp    %edx,%eax
  801e65:	73 e2                	jae    801e49 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6a:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e6e:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e71:	99                   	cltd   
  801e72:	c1 ea 1b             	shr    $0x1b,%edx
  801e75:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801e78:	83 e1 1f             	and    $0x1f,%ecx
  801e7b:	29 d1                	sub    %edx,%ecx
  801e7d:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801e81:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801e85:	83 c0 01             	add    $0x1,%eax
  801e88:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e8b:	83 c7 01             	add    $0x1,%edi
  801e8e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e91:	75 c8                	jne    801e5b <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e93:	89 f8                	mov    %edi,%eax
  801e95:	eb 05                	jmp    801e9c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e97:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    

00801ea4 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ea4:	55                   	push   %ebp
  801ea5:	89 e5                	mov    %esp,%ebp
  801ea7:	57                   	push   %edi
  801ea8:	56                   	push   %esi
  801ea9:	53                   	push   %ebx
  801eaa:	83 ec 1c             	sub    $0x1c,%esp
  801ead:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801eb0:	89 3c 24             	mov    %edi,(%esp)
  801eb3:	e8 08 f1 ff ff       	call   800fc0 <fd2data>
  801eb8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eba:	be 00 00 00 00       	mov    $0x0,%esi
  801ebf:	eb 3d                	jmp    801efe <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801ec1:	85 f6                	test   %esi,%esi
  801ec3:	74 04                	je     801ec9 <devpipe_read+0x25>
				return i;
  801ec5:	89 f0                	mov    %esi,%eax
  801ec7:	eb 43                	jmp    801f0c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801ec9:	89 da                	mov    %ebx,%edx
  801ecb:	89 f8                	mov    %edi,%eax
  801ecd:	e8 f1 fe ff ff       	call   801dc3 <_pipeisclosed>
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	75 31                	jne    801f07 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801ed6:	e8 e9 ec ff ff       	call   800bc4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801edb:	8b 03                	mov    (%ebx),%eax
  801edd:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ee0:	74 df                	je     801ec1 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee2:	99                   	cltd   
  801ee3:	c1 ea 1b             	shr    $0x1b,%edx
  801ee6:	01 d0                	add    %edx,%eax
  801ee8:	83 e0 1f             	and    $0x1f,%eax
  801eeb:	29 d0                	sub    %edx,%eax
  801eed:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801ef2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ef5:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ef8:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801efb:	83 c6 01             	add    $0x1,%esi
  801efe:	3b 75 10             	cmp    0x10(%ebp),%esi
  801f01:	75 d8                	jne    801edb <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f03:	89 f0                	mov    %esi,%eax
  801f05:	eb 05                	jmp    801f0c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801f0c:	83 c4 1c             	add    $0x1c,%esp
  801f0f:	5b                   	pop    %ebx
  801f10:	5e                   	pop    %esi
  801f11:	5f                   	pop    %edi
  801f12:	5d                   	pop    %ebp
  801f13:	c3                   	ret    

00801f14 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	56                   	push   %esi
  801f18:	53                   	push   %ebx
  801f19:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f1c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1f:	89 04 24             	mov    %eax,(%esp)
  801f22:	e8 b0 f0 ff ff       	call   800fd7 <fd_alloc>
  801f27:	89 c2                	mov    %eax,%edx
  801f29:	85 d2                	test   %edx,%edx
  801f2b:	0f 88 4d 01 00 00    	js     80207e <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f31:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f38:	00 
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f47:	e8 97 ec ff ff       	call   800be3 <sys_page_alloc>
  801f4c:	89 c2                	mov    %eax,%edx
  801f4e:	85 d2                	test   %edx,%edx
  801f50:	0f 88 28 01 00 00    	js     80207e <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801f56:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f59:	89 04 24             	mov    %eax,(%esp)
  801f5c:	e8 76 f0 ff ff       	call   800fd7 <fd_alloc>
  801f61:	89 c3                	mov    %eax,%ebx
  801f63:	85 c0                	test   %eax,%eax
  801f65:	0f 88 fe 00 00 00    	js     802069 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f6b:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f72:	00 
  801f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f81:	e8 5d ec ff ff       	call   800be3 <sys_page_alloc>
  801f86:	89 c3                	mov    %eax,%ebx
  801f88:	85 c0                	test   %eax,%eax
  801f8a:	0f 88 d9 00 00 00    	js     802069 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	89 04 24             	mov    %eax,(%esp)
  801f96:	e8 25 f0 ff ff       	call   800fc0 <fd2data>
  801f9b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f9d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fa4:	00 
  801fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb0:	e8 2e ec ff ff       	call   800be3 <sys_page_alloc>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	0f 88 97 00 00 00    	js     802056 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	89 04 24             	mov    %eax,(%esp)
  801fc5:	e8 f6 ef ff ff       	call   800fc0 <fd2data>
  801fca:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801fd1:	00 
  801fd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fdd:	00 
  801fde:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe9:	e8 49 ec ff ff       	call   800c37 <sys_page_map>
  801fee:	89 c3                	mov    %eax,%ebx
  801ff0:	85 c0                	test   %eax,%eax
  801ff2:	78 52                	js     802046 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ff4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  802009:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80200f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802012:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  80201e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802021:	89 04 24             	mov    %eax,(%esp)
  802024:	e8 87 ef ff ff       	call   800fb0 <fd2num>
  802029:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80202c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80202e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802031:	89 04 24             	mov    %eax,(%esp)
  802034:	e8 77 ef ff ff       	call   800fb0 <fd2num>
  802039:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80203c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80203f:	b8 00 00 00 00       	mov    $0x0,%eax
  802044:	eb 38                	jmp    80207e <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  802046:	89 74 24 04          	mov    %esi,0x4(%esp)
  80204a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802051:	e8 34 ec ff ff       	call   800c8a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802064:	e8 21 ec ff ff       	call   800c8a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802069:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802070:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802077:	e8 0e ec ff ff       	call   800c8a <sys_page_unmap>
  80207c:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  80207e:	83 c4 30             	add    $0x30,%esp
  802081:	5b                   	pop    %ebx
  802082:	5e                   	pop    %esi
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	89 04 24             	mov    %eax,(%esp)
  802098:	e8 89 ef ff ff       	call   801026 <fd_lookup>
  80209d:	89 c2                	mov    %eax,%edx
  80209f:	85 d2                	test   %edx,%edx
  8020a1:	78 15                	js     8020b8 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	89 04 24             	mov    %eax,(%esp)
  8020a9:	e8 12 ef ff ff       	call   800fc0 <fd2data>
	return _pipeisclosed(fd, p);
  8020ae:	89 c2                	mov    %eax,%edx
  8020b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b3:	e8 0b fd ff ff       	call   801dc3 <_pipeisclosed>
}
  8020b8:	c9                   	leave  
  8020b9:	c3                   	ret    
  8020ba:	66 90                	xchg   %ax,%ax
  8020bc:	66 90                	xchg   %ax,%ax
  8020be:	66 90                	xchg   %ax,%ax

008020c0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c8:	5d                   	pop    %ebp
  8020c9:	c3                   	ret    

008020ca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020ca:	55                   	push   %ebp
  8020cb:	89 e5                	mov    %esp,%ebp
  8020cd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8020d0:	c7 44 24 04 6f 2b 80 	movl   $0x802b6f,0x4(%esp)
  8020d7:	00 
  8020d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 e4 e6 ff ff       	call   8007c7 <strcpy>
	return 0;
}
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	c9                   	leave  
  8020e9:	c3                   	ret    

008020ea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	57                   	push   %edi
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020f6:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8020fb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802101:	eb 31                	jmp    802134 <devcons_write+0x4a>
		m = n - tot;
  802103:	8b 75 10             	mov    0x10(%ebp),%esi
  802106:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802108:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80210b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802110:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802113:	89 74 24 08          	mov    %esi,0x8(%esp)
  802117:	03 45 0c             	add    0xc(%ebp),%eax
  80211a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211e:	89 3c 24             	mov    %edi,(%esp)
  802121:	e8 3e e8 ff ff       	call   800964 <memmove>
		sys_cputs(buf, m);
  802126:	89 74 24 04          	mov    %esi,0x4(%esp)
  80212a:	89 3c 24             	mov    %edi,(%esp)
  80212d:	e8 e4 e9 ff ff       	call   800b16 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802132:	01 f3                	add    %esi,%ebx
  802134:	89 d8                	mov    %ebx,%eax
  802136:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802139:	72 c8                	jb     802103 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  80213b:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802141:	5b                   	pop    %ebx
  802142:	5e                   	pop    %esi
  802143:	5f                   	pop    %edi
  802144:	5d                   	pop    %ebp
  802145:	c3                   	ret    

00802146 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  802151:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802155:	75 07                	jne    80215e <devcons_read+0x18>
  802157:	eb 2a                	jmp    802183 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802159:	e8 66 ea ff ff       	call   800bc4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  80215e:	66 90                	xchg   %ax,%ax
  802160:	e8 cf e9 ff ff       	call   800b34 <sys_cgetc>
  802165:	85 c0                	test   %eax,%eax
  802167:	74 f0                	je     802159 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  802169:	85 c0                	test   %eax,%eax
  80216b:	78 16                	js     802183 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  80216d:	83 f8 04             	cmp    $0x4,%eax
  802170:	74 0c                	je     80217e <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  802172:	8b 55 0c             	mov    0xc(%ebp),%edx
  802175:	88 02                	mov    %al,(%edx)
	return 1;
  802177:	b8 01 00 00 00       	mov    $0x1,%eax
  80217c:	eb 05                	jmp    802183 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  80217e:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802191:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802198:	00 
  802199:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80219c:	89 04 24             	mov    %eax,(%esp)
  80219f:	e8 72 e9 ff ff       	call   800b16 <sys_cputs>
}
  8021a4:	c9                   	leave  
  8021a5:	c3                   	ret    

008021a6 <getchar>:

int
getchar(void)
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8021ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8021b3:	00 
  8021b4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c2:	e8 f3 f0 ff ff       	call   8012ba <read>
	if (r < 0)
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	78 0f                	js     8021da <getchar+0x34>
		return r;
	if (r < 1)
  8021cb:	85 c0                	test   %eax,%eax
  8021cd:	7e 06                	jle    8021d5 <getchar+0x2f>
		return -E_EOF;
	return c;
  8021cf:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  8021d3:	eb 05                	jmp    8021da <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  8021d5:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ec:	89 04 24             	mov    %eax,(%esp)
  8021ef:	e8 32 ee ff ff       	call   801026 <fd_lookup>
  8021f4:	85 c0                	test   %eax,%eax
  8021f6:	78 11                	js     802209 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802201:	39 10                	cmp    %edx,(%eax)
  802203:	0f 94 c0             	sete   %al
  802206:	0f b6 c0             	movzbl %al,%eax
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <opencons>:

int
opencons(void)
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
  80220e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802211:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802214:	89 04 24             	mov    %eax,(%esp)
  802217:	e8 bb ed ff ff       	call   800fd7 <fd_alloc>
		return r;
  80221c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80221e:	85 c0                	test   %eax,%eax
  802220:	78 40                	js     802262 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802222:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802229:	00 
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802231:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802238:	e8 a6 e9 ff ff       	call   800be3 <sys_page_alloc>
		return r;
  80223d:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80223f:	85 c0                	test   %eax,%eax
  802241:	78 1f                	js     802262 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802243:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80224e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802251:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802258:	89 04 24             	mov    %eax,(%esp)
  80225b:	e8 50 ed ff ff       	call   800fb0 <fd2num>
  802260:	89 c2                	mov    %eax,%edx
}
  802262:	89 d0                	mov    %edx,%eax
  802264:	c9                   	leave  
  802265:	c3                   	ret    

00802266 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802266:	55                   	push   %ebp
  802267:	89 e5                	mov    %esp,%ebp
  802269:	56                   	push   %esi
  80226a:	53                   	push   %ebx
  80226b:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  80226e:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802271:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802277:	e8 29 e9 ff ff       	call   800ba5 <sys_getenvid>
  80227c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80227f:	89 54 24 10          	mov    %edx,0x10(%esp)
  802283:	8b 55 08             	mov    0x8(%ebp),%edx
  802286:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80228a:	89 74 24 08          	mov    %esi,0x8(%esp)
  80228e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802292:	c7 04 24 7c 2b 80 00 	movl   $0x802b7c,(%esp)
  802299:	e8 02 df ff ff       	call   8001a0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80229e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a5:	89 04 24             	mov    %eax,(%esp)
  8022a8:	e8 92 de ff ff       	call   80013f <vcprintf>
	cprintf("\n");
  8022ad:	c7 04 24 68 2b 80 00 	movl   $0x802b68,(%esp)
  8022b4:	e8 e7 de ff ff       	call   8001a0 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8022b9:	cc                   	int3   
  8022ba:	eb fd                	jmp    8022b9 <_panic+0x53>

008022bc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	56                   	push   %esi
  8022c0:	53                   	push   %ebx
  8022c1:	83 ec 10             	sub    $0x10,%esp
  8022c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  8022cd:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  8022cf:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  8022d4:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  8022d7:	89 04 24             	mov    %eax,(%esp)
  8022da:	e8 1a eb ff ff       	call   800df9 <sys_ipc_recv>
  8022df:	85 c0                	test   %eax,%eax
  8022e1:	75 1e                	jne    802301 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  8022e3:	85 db                	test   %ebx,%ebx
  8022e5:	74 0a                	je     8022f1 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  8022e7:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ec:	8b 40 74             	mov    0x74(%eax),%eax
  8022ef:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  8022f1:	85 f6                	test   %esi,%esi
  8022f3:	74 22                	je     802317 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  8022f5:	a1 08 40 80 00       	mov    0x804008,%eax
  8022fa:	8b 40 78             	mov    0x78(%eax),%eax
  8022fd:	89 06                	mov    %eax,(%esi)
  8022ff:	eb 16                	jmp    802317 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802301:	85 f6                	test   %esi,%esi
  802303:	74 06                	je     80230b <ipc_recv+0x4f>
				*perm_store = 0;
  802305:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80230b:	85 db                	test   %ebx,%ebx
  80230d:	74 10                	je     80231f <ipc_recv+0x63>
				*from_env_store=0;
  80230f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802315:	eb 08                	jmp    80231f <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802317:	a1 08 40 80 00       	mov    0x804008,%eax
  80231c:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	5b                   	pop    %ebx
  802323:	5e                   	pop    %esi
  802324:	5d                   	pop    %ebp
  802325:	c3                   	ret    

00802326 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802326:	55                   	push   %ebp
  802327:	89 e5                	mov    %esp,%ebp
  802329:	57                   	push   %edi
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	83 ec 1c             	sub    $0x1c,%esp
  80232f:	8b 75 0c             	mov    0xc(%ebp),%esi
  802332:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802335:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  802338:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  80233a:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  80233f:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802342:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802346:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80234a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80234e:	8b 45 08             	mov    0x8(%ebp),%eax
  802351:	89 04 24             	mov    %eax,(%esp)
  802354:	e8 7d ea ff ff       	call   800dd6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  802359:	eb 1c                	jmp    802377 <ipc_send+0x51>
	{
		sys_yield();
  80235b:	e8 64 e8 ff ff       	call   800bc4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  802360:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802364:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802368:	89 74 24 04          	mov    %esi,0x4(%esp)
  80236c:	8b 45 08             	mov    0x8(%ebp),%eax
  80236f:	89 04 24             	mov    %eax,(%esp)
  802372:	e8 5f ea ff ff       	call   800dd6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  802377:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80237a:	74 df                	je     80235b <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80238a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80238f:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802392:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802398:	8b 52 50             	mov    0x50(%edx),%edx
  80239b:	39 ca                	cmp    %ecx,%edx
  80239d:	75 0d                	jne    8023ac <ipc_find_env+0x28>
			return envs[i].env_id;
  80239f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8023a2:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  8023a7:	8b 40 40             	mov    0x40(%eax),%eax
  8023aa:	eb 0e                	jmp    8023ba <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  8023ac:	83 c0 01             	add    $0x1,%eax
  8023af:	3d 00 04 00 00       	cmp    $0x400,%eax
  8023b4:	75 d9                	jne    80238f <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  8023b6:	66 b8 00 00          	mov    $0x0,%ax
}
  8023ba:	5d                   	pop    %ebp
  8023bb:	c3                   	ret    

008023bc <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023c2:	89 d0                	mov    %edx,%eax
  8023c4:	c1 e8 16             	shr    $0x16,%eax
  8023c7:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8023ce:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8023d3:	f6 c1 01             	test   $0x1,%cl
  8023d6:	74 1d                	je     8023f5 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  8023d8:	c1 ea 0c             	shr    $0xc,%edx
  8023db:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023e2:	f6 c2 01             	test   $0x1,%dl
  8023e5:	74 0e                	je     8023f5 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023e7:	c1 ea 0c             	shr    $0xc,%edx
  8023ea:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023f1:	ef 
  8023f2:	0f b7 c0             	movzwl %ax,%eax
}
  8023f5:	5d                   	pop    %ebp
  8023f6:	c3                   	ret    
  8023f7:	66 90                	xchg   %ax,%ax
  8023f9:	66 90                	xchg   %ax,%ax
  8023fb:	66 90                	xchg   %ax,%ax
  8023fd:	66 90                	xchg   %ax,%ax
  8023ff:	90                   	nop

00802400 <__udivdi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	83 ec 0c             	sub    $0xc,%esp
  802406:	8b 44 24 28          	mov    0x28(%esp),%eax
  80240a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80240e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802412:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802416:	85 c0                	test   %eax,%eax
  802418:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80241c:	89 ea                	mov    %ebp,%edx
  80241e:	89 0c 24             	mov    %ecx,(%esp)
  802421:	75 2d                	jne    802450 <__udivdi3+0x50>
  802423:	39 e9                	cmp    %ebp,%ecx
  802425:	77 61                	ja     802488 <__udivdi3+0x88>
  802427:	85 c9                	test   %ecx,%ecx
  802429:	89 ce                	mov    %ecx,%esi
  80242b:	75 0b                	jne    802438 <__udivdi3+0x38>
  80242d:	b8 01 00 00 00       	mov    $0x1,%eax
  802432:	31 d2                	xor    %edx,%edx
  802434:	f7 f1                	div    %ecx
  802436:	89 c6                	mov    %eax,%esi
  802438:	31 d2                	xor    %edx,%edx
  80243a:	89 e8                	mov    %ebp,%eax
  80243c:	f7 f6                	div    %esi
  80243e:	89 c5                	mov    %eax,%ebp
  802440:	89 f8                	mov    %edi,%eax
  802442:	f7 f6                	div    %esi
  802444:	89 ea                	mov    %ebp,%edx
  802446:	83 c4 0c             	add    $0xc,%esp
  802449:	5e                   	pop    %esi
  80244a:	5f                   	pop    %edi
  80244b:	5d                   	pop    %ebp
  80244c:	c3                   	ret    
  80244d:	8d 76 00             	lea    0x0(%esi),%esi
  802450:	39 e8                	cmp    %ebp,%eax
  802452:	77 24                	ja     802478 <__udivdi3+0x78>
  802454:	0f bd e8             	bsr    %eax,%ebp
  802457:	83 f5 1f             	xor    $0x1f,%ebp
  80245a:	75 3c                	jne    802498 <__udivdi3+0x98>
  80245c:	8b 74 24 04          	mov    0x4(%esp),%esi
  802460:	39 34 24             	cmp    %esi,(%esp)
  802463:	0f 86 9f 00 00 00    	jbe    802508 <__udivdi3+0x108>
  802469:	39 d0                	cmp    %edx,%eax
  80246b:	0f 82 97 00 00 00    	jb     802508 <__udivdi3+0x108>
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	31 c0                	xor    %eax,%eax
  80247c:	83 c4 0c             	add    $0xc,%esp
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    
  802483:	90                   	nop
  802484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802488:	89 f8                	mov    %edi,%eax
  80248a:	f7 f1                	div    %ecx
  80248c:	31 d2                	xor    %edx,%edx
  80248e:	83 c4 0c             	add    $0xc,%esp
  802491:	5e                   	pop    %esi
  802492:	5f                   	pop    %edi
  802493:	5d                   	pop    %ebp
  802494:	c3                   	ret    
  802495:	8d 76 00             	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	8b 3c 24             	mov    (%esp),%edi
  80249d:	d3 e0                	shl    %cl,%eax
  80249f:	89 c6                	mov    %eax,%esi
  8024a1:	b8 20 00 00 00       	mov    $0x20,%eax
  8024a6:	29 e8                	sub    %ebp,%eax
  8024a8:	89 c1                	mov    %eax,%ecx
  8024aa:	d3 ef                	shr    %cl,%edi
  8024ac:	89 e9                	mov    %ebp,%ecx
  8024ae:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024b2:	8b 3c 24             	mov    (%esp),%edi
  8024b5:	09 74 24 08          	or     %esi,0x8(%esp)
  8024b9:	89 d6                	mov    %edx,%esi
  8024bb:	d3 e7                	shl    %cl,%edi
  8024bd:	89 c1                	mov    %eax,%ecx
  8024bf:	89 3c 24             	mov    %edi,(%esp)
  8024c2:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8024c6:	d3 ee                	shr    %cl,%esi
  8024c8:	89 e9                	mov    %ebp,%ecx
  8024ca:	d3 e2                	shl    %cl,%edx
  8024cc:	89 c1                	mov    %eax,%ecx
  8024ce:	d3 ef                	shr    %cl,%edi
  8024d0:	09 d7                	or     %edx,%edi
  8024d2:	89 f2                	mov    %esi,%edx
  8024d4:	89 f8                	mov    %edi,%eax
  8024d6:	f7 74 24 08          	divl   0x8(%esp)
  8024da:	89 d6                	mov    %edx,%esi
  8024dc:	89 c7                	mov    %eax,%edi
  8024de:	f7 24 24             	mull   (%esp)
  8024e1:	39 d6                	cmp    %edx,%esi
  8024e3:	89 14 24             	mov    %edx,(%esp)
  8024e6:	72 30                	jb     802518 <__udivdi3+0x118>
  8024e8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024ec:	89 e9                	mov    %ebp,%ecx
  8024ee:	d3 e2                	shl    %cl,%edx
  8024f0:	39 c2                	cmp    %eax,%edx
  8024f2:	73 05                	jae    8024f9 <__udivdi3+0xf9>
  8024f4:	3b 34 24             	cmp    (%esp),%esi
  8024f7:	74 1f                	je     802518 <__udivdi3+0x118>
  8024f9:	89 f8                	mov    %edi,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	e9 7a ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802508:	31 d2                	xor    %edx,%edx
  80250a:	b8 01 00 00 00       	mov    $0x1,%eax
  80250f:	e9 68 ff ff ff       	jmp    80247c <__udivdi3+0x7c>
  802514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802518:	8d 47 ff             	lea    -0x1(%edi),%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	83 c4 0c             	add    $0xc,%esp
  802520:	5e                   	pop    %esi
  802521:	5f                   	pop    %edi
  802522:	5d                   	pop    %ebp
  802523:	c3                   	ret    
  802524:	66 90                	xchg   %ax,%ax
  802526:	66 90                	xchg   %ax,%ax
  802528:	66 90                	xchg   %ax,%ax
  80252a:	66 90                	xchg   %ax,%ax
  80252c:	66 90                	xchg   %ax,%ax
  80252e:	66 90                	xchg   %ax,%ax

00802530 <__umoddi3>:
  802530:	55                   	push   %ebp
  802531:	57                   	push   %edi
  802532:	56                   	push   %esi
  802533:	83 ec 14             	sub    $0x14,%esp
  802536:	8b 44 24 28          	mov    0x28(%esp),%eax
  80253a:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  80253e:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  802542:	89 c7                	mov    %eax,%edi
  802544:	89 44 24 04          	mov    %eax,0x4(%esp)
  802548:	8b 44 24 30          	mov    0x30(%esp),%eax
  80254c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802550:	89 34 24             	mov    %esi,(%esp)
  802553:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802557:	85 c0                	test   %eax,%eax
  802559:	89 c2                	mov    %eax,%edx
  80255b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80255f:	75 17                	jne    802578 <__umoddi3+0x48>
  802561:	39 fe                	cmp    %edi,%esi
  802563:	76 4b                	jbe    8025b0 <__umoddi3+0x80>
  802565:	89 c8                	mov    %ecx,%eax
  802567:	89 fa                	mov    %edi,%edx
  802569:	f7 f6                	div    %esi
  80256b:	89 d0                	mov    %edx,%eax
  80256d:	31 d2                	xor    %edx,%edx
  80256f:	83 c4 14             	add    $0x14,%esp
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    
  802576:	66 90                	xchg   %ax,%ax
  802578:	39 f8                	cmp    %edi,%eax
  80257a:	77 54                	ja     8025d0 <__umoddi3+0xa0>
  80257c:	0f bd e8             	bsr    %eax,%ebp
  80257f:	83 f5 1f             	xor    $0x1f,%ebp
  802582:	75 5c                	jne    8025e0 <__umoddi3+0xb0>
  802584:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802588:	39 3c 24             	cmp    %edi,(%esp)
  80258b:	0f 87 e7 00 00 00    	ja     802678 <__umoddi3+0x148>
  802591:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802595:	29 f1                	sub    %esi,%ecx
  802597:	19 c7                	sbb    %eax,%edi
  802599:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80259d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8025a1:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025a5:	8b 54 24 0c          	mov    0xc(%esp),%edx
  8025a9:	83 c4 14             	add    $0x14,%esp
  8025ac:	5e                   	pop    %esi
  8025ad:	5f                   	pop    %edi
  8025ae:	5d                   	pop    %ebp
  8025af:	c3                   	ret    
  8025b0:	85 f6                	test   %esi,%esi
  8025b2:	89 f5                	mov    %esi,%ebp
  8025b4:	75 0b                	jne    8025c1 <__umoddi3+0x91>
  8025b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8025bb:	31 d2                	xor    %edx,%edx
  8025bd:	f7 f6                	div    %esi
  8025bf:	89 c5                	mov    %eax,%ebp
  8025c1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8025c5:	31 d2                	xor    %edx,%edx
  8025c7:	f7 f5                	div    %ebp
  8025c9:	89 c8                	mov    %ecx,%eax
  8025cb:	f7 f5                	div    %ebp
  8025cd:	eb 9c                	jmp    80256b <__umoddi3+0x3b>
  8025cf:	90                   	nop
  8025d0:	89 c8                	mov    %ecx,%eax
  8025d2:	89 fa                	mov    %edi,%edx
  8025d4:	83 c4 14             	add    $0x14,%esp
  8025d7:	5e                   	pop    %esi
  8025d8:	5f                   	pop    %edi
  8025d9:	5d                   	pop    %ebp
  8025da:	c3                   	ret    
  8025db:	90                   	nop
  8025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e0:	8b 04 24             	mov    (%esp),%eax
  8025e3:	be 20 00 00 00       	mov    $0x20,%esi
  8025e8:	89 e9                	mov    %ebp,%ecx
  8025ea:	29 ee                	sub    %ebp,%esi
  8025ec:	d3 e2                	shl    %cl,%edx
  8025ee:	89 f1                	mov    %esi,%ecx
  8025f0:	d3 e8                	shr    %cl,%eax
  8025f2:	89 e9                	mov    %ebp,%ecx
  8025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f8:	8b 04 24             	mov    (%esp),%eax
  8025fb:	09 54 24 04          	or     %edx,0x4(%esp)
  8025ff:	89 fa                	mov    %edi,%edx
  802601:	d3 e0                	shl    %cl,%eax
  802603:	89 f1                	mov    %esi,%ecx
  802605:	89 44 24 08          	mov    %eax,0x8(%esp)
  802609:	8b 44 24 10          	mov    0x10(%esp),%eax
  80260d:	d3 ea                	shr    %cl,%edx
  80260f:	89 e9                	mov    %ebp,%ecx
  802611:	d3 e7                	shl    %cl,%edi
  802613:	89 f1                	mov    %esi,%ecx
  802615:	d3 e8                	shr    %cl,%eax
  802617:	89 e9                	mov    %ebp,%ecx
  802619:	09 f8                	or     %edi,%eax
  80261b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80261f:	f7 74 24 04          	divl   0x4(%esp)
  802623:	d3 e7                	shl    %cl,%edi
  802625:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802629:	89 d7                	mov    %edx,%edi
  80262b:	f7 64 24 08          	mull   0x8(%esp)
  80262f:	39 d7                	cmp    %edx,%edi
  802631:	89 c1                	mov    %eax,%ecx
  802633:	89 14 24             	mov    %edx,(%esp)
  802636:	72 2c                	jb     802664 <__umoddi3+0x134>
  802638:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  80263c:	72 22                	jb     802660 <__umoddi3+0x130>
  80263e:	8b 44 24 0c          	mov    0xc(%esp),%eax
  802642:	29 c8                	sub    %ecx,%eax
  802644:	19 d7                	sbb    %edx,%edi
  802646:	89 e9                	mov    %ebp,%ecx
  802648:	89 fa                	mov    %edi,%edx
  80264a:	d3 e8                	shr    %cl,%eax
  80264c:	89 f1                	mov    %esi,%ecx
  80264e:	d3 e2                	shl    %cl,%edx
  802650:	89 e9                	mov    %ebp,%ecx
  802652:	d3 ef                	shr    %cl,%edi
  802654:	09 d0                	or     %edx,%eax
  802656:	89 fa                	mov    %edi,%edx
  802658:	83 c4 14             	add    $0x14,%esp
  80265b:	5e                   	pop    %esi
  80265c:	5f                   	pop    %edi
  80265d:	5d                   	pop    %ebp
  80265e:	c3                   	ret    
  80265f:	90                   	nop
  802660:	39 d7                	cmp    %edx,%edi
  802662:	75 da                	jne    80263e <__umoddi3+0x10e>
  802664:	8b 14 24             	mov    (%esp),%edx
  802667:	89 c1                	mov    %eax,%ecx
  802669:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  80266d:	1b 54 24 04          	sbb    0x4(%esp),%edx
  802671:	eb cb                	jmp    80263e <__umoddi3+0x10e>
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  80267c:	0f 82 0f ff ff ff    	jb     802591 <__umoddi3+0x61>
  802682:	e9 1a ff ff ff       	jmp    8025a1 <__umoddi3+0x71>
