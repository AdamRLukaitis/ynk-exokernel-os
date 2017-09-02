
obj/user/yield.debug:     file format elf32-i386


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
  80002c:	e8 6d 00 00 00       	call   80009e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
  80003a:	a1 08 40 80 00       	mov    0x804008,%eax
  80003f:	8b 40 48             	mov    0x48(%eax),%eax
  800042:	89 44 24 04          	mov    %eax,0x4(%esp)
  800046:	c7 04 24 00 26 80 00 	movl   $0x802600,(%esp)
  80004d:	e8 5a 01 00 00       	call   8001ac <cprintf>
	for (i = 0; i < 5; i++) {
  800052:	bb 00 00 00 00       	mov    $0x0,%ebx
		sys_yield();
  800057:	e8 78 0b 00 00       	call   800bd4 <sys_yield>
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
  80005c:	a1 08 40 80 00       	mov    0x804008,%eax
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
  800061:	8b 40 48             	mov    0x48(%eax),%eax
  800064:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800068:	89 44 24 04          	mov    %eax,0x4(%esp)
  80006c:	c7 04 24 20 26 80 00 	movl   $0x802620,(%esp)
  800073:	e8 34 01 00 00       	call   8001ac <cprintf>
umain(int argc, char **argv)
{
	int i;

	cprintf("Hello, I am environment %08x.\n", thisenv->env_id);
	for (i = 0; i < 5; i++) {
  800078:	83 c3 01             	add    $0x1,%ebx
  80007b:	83 fb 05             	cmp    $0x5,%ebx
  80007e:	75 d7                	jne    800057 <umain+0x24>
		sys_yield();
		cprintf("Back in environment %08x, iteration %d.\n",
			thisenv->env_id, i);
	}
	cprintf("All done in environment %08x.\n", thisenv->env_id);
  800080:	a1 08 40 80 00       	mov    0x804008,%eax
  800085:	8b 40 48             	mov    0x48(%eax),%eax
  800088:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008c:	c7 04 24 4c 26 80 00 	movl   $0x80264c,(%esp)
  800093:	e8 14 01 00 00       	call   8001ac <cprintf>
}
  800098:	83 c4 14             	add    $0x14,%esp
  80009b:	5b                   	pop    %ebx
  80009c:	5d                   	pop    %ebp
  80009d:	c3                   	ret    

0080009e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80009e:	55                   	push   %ebp
  80009f:	89 e5                	mov    %esp,%ebp
  8000a1:	56                   	push   %esi
  8000a2:	53                   	push   %ebx
  8000a3:	83 ec 10             	sub    $0x10,%esp
  8000a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = 0;
  8000ac:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000b3:	00 00 00 


	uint32_t env_id = ENVX(sys_getenvid());
  8000b6:	e8 fa 0a 00 00       	call   800bb5 <sys_getenvid>
  8000bb:	25 ff 03 00 00       	and    $0x3ff,%eax
	thisenv = &envs[env_id];
  8000c0:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000c3:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000c8:	a3 08 40 80 00       	mov    %eax,0x804008


	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000cd:	85 db                	test   %ebx,%ebx
  8000cf:	7e 07                	jle    8000d8 <libmain+0x3a>
		binaryname = argv[0];
  8000d1:	8b 06                	mov    (%esi),%eax
  8000d3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000dc:	89 1c 24             	mov    %ebx,(%esp)
  8000df:	e8 4f ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000e4:	e8 07 00 00 00       	call   8000f0 <exit>
}
  8000e9:	83 c4 10             	add    $0x10,%esp
  8000ec:	5b                   	pop    %ebx
  8000ed:	5e                   	pop    %esi
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    

008000f0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000f6:	e8 ff 0f 00 00       	call   8010fa <close_all>
	sys_env_destroy(0);
  8000fb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800102:	e8 5c 0a 00 00       	call   800b63 <sys_env_destroy>
}
  800107:	c9                   	leave  
  800108:	c3                   	ret    

00800109 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	53                   	push   %ebx
  80010d:	83 ec 14             	sub    $0x14,%esp
  800110:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800113:	8b 13                	mov    (%ebx),%edx
  800115:	8d 42 01             	lea    0x1(%edx),%eax
  800118:	89 03                	mov    %eax,(%ebx)
  80011a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80011d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800121:	3d ff 00 00 00       	cmp    $0xff,%eax
  800126:	75 19                	jne    800141 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800128:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80012f:	00 
  800130:	8d 43 08             	lea    0x8(%ebx),%eax
  800133:	89 04 24             	mov    %eax,(%esp)
  800136:	e8 eb 09 00 00       	call   800b26 <sys_cputs>
		b->idx = 0;
  80013b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800141:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800145:	83 c4 14             	add    $0x14,%esp
  800148:	5b                   	pop    %ebx
  800149:	5d                   	pop    %ebp
  80014a:	c3                   	ret    

0080014b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80014b:	55                   	push   %ebp
  80014c:	89 e5                	mov    %esp,%ebp
  80014e:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800154:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80015b:	00 00 00 
	b.cnt = 0;
  80015e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800165:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80016b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016f:	8b 45 08             	mov    0x8(%ebp),%eax
  800172:	89 44 24 08          	mov    %eax,0x8(%esp)
  800176:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	c7 04 24 09 01 80 00 	movl   $0x800109,(%esp)
  800187:	e8 b2 01 00 00       	call   80033e <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80018c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800192:	89 44 24 04          	mov    %eax,0x4(%esp)
  800196:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80019c:	89 04 24             	mov    %eax,(%esp)
  80019f:	e8 82 09 00 00       	call   800b26 <sys_cputs>

	return b.cnt;
}
  8001a4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	89 04 24             	mov    %eax,(%esp)
  8001bf:	e8 87 ff ff ff       	call   80014b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c4:	c9                   	leave  
  8001c5:	c3                   	ret    
  8001c6:	66 90                	xchg   %ax,%ax
  8001c8:	66 90                	xchg   %ax,%ax
  8001ca:	66 90                	xchg   %ax,%ax
  8001cc:	66 90                	xchg   %ax,%ax
  8001ce:	66 90                	xchg   %ax,%ax

008001d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	57                   	push   %edi
  8001d4:	56                   	push   %esi
  8001d5:	53                   	push   %ebx
  8001d6:	83 ec 3c             	sub    $0x3c,%esp
  8001d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001dc:	89 d7                	mov    %edx,%edi
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e7:	89 c3                	mov    %eax,%ebx
  8001e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8001ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8001ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001fa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8001fd:	39 d9                	cmp    %ebx,%ecx
  8001ff:	72 05                	jb     800206 <printnum+0x36>
  800201:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800204:	77 69                	ja     80026f <printnum+0x9f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800206:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800209:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80020d:	83 ee 01             	sub    $0x1,%esi
  800210:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800214:	89 44 24 08          	mov    %eax,0x8(%esp)
  800218:	8b 44 24 08          	mov    0x8(%esp),%eax
  80021c:	8b 54 24 0c          	mov    0xc(%esp),%edx
  800220:	89 c3                	mov    %eax,%ebx
  800222:	89 d6                	mov    %edx,%esi
  800224:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800227:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80022a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80022e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  800232:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800235:	89 04 24             	mov    %eax,(%esp)
  800238:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	e8 2c 21 00 00       	call   802370 <__udivdi3>
  800244:	89 d9                	mov    %ebx,%ecx
  800246:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80024a:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80024e:	89 04 24             	mov    %eax,(%esp)
  800251:	89 54 24 04          	mov    %edx,0x4(%esp)
  800255:	89 fa                	mov    %edi,%edx
  800257:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025a:	e8 71 ff ff ff       	call   8001d0 <printnum>
  80025f:	eb 1b                	jmp    80027c <printnum+0xac>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800261:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800265:	8b 45 18             	mov    0x18(%ebp),%eax
  800268:	89 04 24             	mov    %eax,(%esp)
  80026b:	ff d3                	call   *%ebx
  80026d:	eb 03                	jmp    800272 <printnum+0xa2>
  80026f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800272:	83 ee 01             	sub    $0x1,%esi
  800275:	85 f6                	test   %esi,%esi
  800277:	7f e8                	jg     800261 <printnum+0x91>
  800279:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80027c:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800280:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800284:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800287:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80028a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80028e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800292:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80029b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029f:	e8 fc 21 00 00       	call   8024a0 <__umoddi3>
  8002a4:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8002a8:	0f be 80 75 26 80 00 	movsbl 0x802675(%eax),%eax
  8002af:	89 04 24             	mov    %eax,(%esp)
  8002b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002b5:	ff d0                	call   *%eax
}
  8002b7:	83 c4 3c             	add    $0x3c,%esp
  8002ba:	5b                   	pop    %ebx
  8002bb:	5e                   	pop    %esi
  8002bc:	5f                   	pop    %edi
  8002bd:	5d                   	pop    %ebp
  8002be:	c3                   	ret    

008002bf <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002c2:	83 fa 01             	cmp    $0x1,%edx
  8002c5:	7e 0e                	jle    8002d5 <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002c7:	8b 10                	mov    (%eax),%edx
  8002c9:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002cc:	89 08                	mov    %ecx,(%eax)
  8002ce:	8b 02                	mov    (%edx),%eax
  8002d0:	8b 52 04             	mov    0x4(%edx),%edx
  8002d3:	eb 22                	jmp    8002f7 <getuint+0x38>
	else if (lflag)
  8002d5:	85 d2                	test   %edx,%edx
  8002d7:	74 10                	je     8002e9 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002de:	89 08                	mov    %ecx,(%eax)
  8002e0:	8b 02                	mov    (%edx),%eax
  8002e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8002e7:	eb 0e                	jmp    8002f7 <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002ee:	89 08                	mov    %ecx,(%eax)
  8002f0:	8b 02                	mov    (%edx),%eax
  8002f2:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002f7:	5d                   	pop    %ebp
  8002f8:	c3                   	ret    

008002f9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ff:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800303:	8b 10                	mov    (%eax),%edx
  800305:	3b 50 04             	cmp    0x4(%eax),%edx
  800308:	73 0a                	jae    800314 <sprintputch+0x1b>
		*b->buf++ = ch;
  80030a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80030d:	89 08                	mov    %ecx,(%eax)
  80030f:	8b 45 08             	mov    0x8(%ebp),%eax
  800312:	88 02                	mov    %al,(%edx)
}
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    

00800316 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  80031c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80031f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800323:	8b 45 10             	mov    0x10(%ebp),%eax
  800326:	89 44 24 08          	mov    %eax,0x8(%esp)
  80032a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80032d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800331:	8b 45 08             	mov    0x8(%ebp),%eax
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	e8 02 00 00 00       	call   80033e <vprintfmt>
	va_end(ap);
}
  80033c:	c9                   	leave  
  80033d:	c3                   	ret    

0080033e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	57                   	push   %edi
  800342:	56                   	push   %esi
  800343:	53                   	push   %ebx
  800344:	83 ec 3c             	sub    $0x3c,%esp
  800347:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80034a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034d:	eb 14                	jmp    800363 <vprintfmt+0x25>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 84 b3 03 00 00    	je     80070a <vprintfmt+0x3cc>
				return;
			putch(ch, putdat);
  800357:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80035b:	89 04 24             	mov    %eax,(%esp)
  80035e:	ff 55 08             	call   *0x8(%ebp)
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800361:	89 f3                	mov    %esi,%ebx
  800363:	8d 73 01             	lea    0x1(%ebx),%esi
  800366:	0f b6 03             	movzbl (%ebx),%eax
  800369:	83 f8 25             	cmp    $0x25,%eax
  80036c:	75 e1                	jne    80034f <vprintfmt+0x11>
  80036e:	c6 45 d8 20          	movb   $0x20,-0x28(%ebp)
  800372:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800379:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
  800380:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)
  800387:	ba 00 00 00 00       	mov    $0x0,%edx
  80038c:	eb 1d                	jmp    8003ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80038e:	89 de                	mov    %ebx,%esi

		// flag to pad on the right
		case '-':
			padc = '-';
  800390:	c6 45 d8 2d          	movb   $0x2d,-0x28(%ebp)
  800394:	eb 15                	jmp    8003ab <vprintfmt+0x6d>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800396:	89 de                	mov    %ebx,%esi
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800398:	c6 45 d8 30          	movb   $0x30,-0x28(%ebp)
  80039c:	eb 0d                	jmp    8003ab <vprintfmt+0x6d>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
  80039e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a4:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003ab:	8d 5e 01             	lea    0x1(%esi),%ebx
  8003ae:	0f b6 0e             	movzbl (%esi),%ecx
  8003b1:	0f b6 c1             	movzbl %cl,%eax
  8003b4:	83 e9 23             	sub    $0x23,%ecx
  8003b7:	80 f9 55             	cmp    $0x55,%cl
  8003ba:	0f 87 2a 03 00 00    	ja     8006ea <vprintfmt+0x3ac>
  8003c0:	0f b6 c9             	movzbl %cl,%ecx
  8003c3:	ff 24 8d c0 27 80 00 	jmp    *0x8027c0(,%ecx,4)
  8003ca:	89 de                	mov    %ebx,%esi
  8003cc:	b9 00 00 00 00       	mov    $0x0,%ecx
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8003d1:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003d4:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
				ch = *fmt;
  8003d8:	0f be 06             	movsbl (%esi),%eax
				if (ch < '0' || ch > '9')
  8003db:	8d 58 d0             	lea    -0x30(%eax),%ebx
  8003de:	83 fb 09             	cmp    $0x9,%ebx
  8003e1:	77 36                	ja     800419 <vprintfmt+0xdb>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003e3:	83 c6 01             	add    $0x1,%esi
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8003e6:	eb e9                	jmp    8003d1 <vprintfmt+0x93>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003eb:	8d 48 04             	lea    0x4(%eax),%ecx
  8003ee:	89 4d 14             	mov    %ecx,0x14(%ebp)
  8003f1:	8b 00                	mov    (%eax),%eax
  8003f3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	89 de                	mov    %ebx,%esi
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
  8003f8:	eb 22                	jmp    80041c <vprintfmt+0xde>
  8003fa:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8003fd:	85 c9                	test   %ecx,%ecx
  8003ff:	b8 00 00 00 00       	mov    $0x0,%eax
  800404:	0f 49 c1             	cmovns %ecx,%eax
  800407:	89 45 dc             	mov    %eax,-0x24(%ebp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80040a:	89 de                	mov    %ebx,%esi
  80040c:	eb 9d                	jmp    8003ab <vprintfmt+0x6d>
  80040e:	89 de                	mov    %ebx,%esi
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
  800410:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
			goto reswitch;
  800417:	eb 92                	jmp    8003ab <vprintfmt+0x6d>
  800419:	89 4d d4             	mov    %ecx,-0x2c(%ebp)

		process_precision:
			if (width < 0)
  80041c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800420:	79 89                	jns    8003ab <vprintfmt+0x6d>
  800422:	e9 77 ff ff ff       	jmp    80039e <vprintfmt+0x60>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800427:	83 c2 01             	add    $0x1,%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	89 de                	mov    %ebx,%esi
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
			goto reswitch;
  80042c:	e9 7a ff ff ff       	jmp    8003ab <vprintfmt+0x6d>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800431:	8b 45 14             	mov    0x14(%ebp),%eax
  800434:	8d 50 04             	lea    0x4(%eax),%edx
  800437:	89 55 14             	mov    %edx,0x14(%ebp)
  80043a:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80043e:	8b 00                	mov    (%eax),%eax
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	ff 55 08             	call   *0x8(%ebp)
			break;
  800446:	e9 18 ff ff ff       	jmp    800363 <vprintfmt+0x25>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 50 04             	lea    0x4(%eax),%edx
  800451:	89 55 14             	mov    %edx,0x14(%ebp)
  800454:	8b 00                	mov    (%eax),%eax
  800456:	99                   	cltd   
  800457:	31 d0                	xor    %edx,%eax
  800459:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80045b:	83 f8 0f             	cmp    $0xf,%eax
  80045e:	7f 0b                	jg     80046b <vprintfmt+0x12d>
  800460:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800467:	85 d2                	test   %edx,%edx
  800469:	75 20                	jne    80048b <vprintfmt+0x14d>
				printfmt(putch, putdat, "error %d", err);
  80046b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80046f:	c7 44 24 08 8d 26 80 	movl   $0x80268d,0x8(%esp)
  800476:	00 
  800477:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80047b:	8b 45 08             	mov    0x8(%ebp),%eax
  80047e:	89 04 24             	mov    %eax,(%esp)
  800481:	e8 90 fe ff ff       	call   800316 <printfmt>
  800486:	e9 d8 fe ff ff       	jmp    800363 <vprintfmt+0x25>
			else
				printfmt(putch, putdat, "%s", p);
  80048b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80048f:	c7 44 24 08 55 2a 80 	movl   $0x802a55,0x8(%esp)
  800496:	00 
  800497:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80049b:	8b 45 08             	mov    0x8(%ebp),%eax
  80049e:	89 04 24             	mov    %eax,(%esp)
  8004a1:	e8 70 fe ff ff       	call   800316 <printfmt>
  8004a6:	e9 b8 fe ff ff       	jmp    800363 <vprintfmt+0x25>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ab:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  8004ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b7:	8d 50 04             	lea    0x4(%eax),%edx
  8004ba:	89 55 14             	mov    %edx,0x14(%ebp)
  8004bd:	8b 30                	mov    (%eax),%esi
				p = "(null)";
  8004bf:	85 f6                	test   %esi,%esi
  8004c1:	b8 86 26 80 00       	mov    $0x802686,%eax
  8004c6:	0f 44 f0             	cmove  %eax,%esi
			if (width > 0 && padc != '-')
  8004c9:	80 7d d8 2d          	cmpb   $0x2d,-0x28(%ebp)
  8004cd:	0f 84 97 00 00 00    	je     80056a <vprintfmt+0x22c>
  8004d3:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004d7:	0f 8e 9b 00 00 00    	jle    800578 <vprintfmt+0x23a>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004e1:	89 34 24             	mov    %esi,(%esp)
  8004e4:	e8 cf 02 00 00       	call   8007b8 <strnlen>
  8004e9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004ec:	29 c2                	sub    %eax,%edx
  8004ee:	89 55 d0             	mov    %edx,-0x30(%ebp)
					putch(padc, putdat);
  8004f1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  8004f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004f8:	89 75 d8             	mov    %esi,-0x28(%ebp)
  8004fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fe:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800501:	89 d3                	mov    %edx,%ebx
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800503:	eb 0f                	jmp    800514 <vprintfmt+0x1d6>
					putch(padc, putdat);
  800505:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800509:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050c:	89 04 24             	mov    %eax,(%esp)
  80050f:	ff d6                	call   *%esi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800511:	83 eb 01             	sub    $0x1,%ebx
  800514:	85 db                	test   %ebx,%ebx
  800516:	7f ed                	jg     800505 <vprintfmt+0x1c7>
  800518:	8b 75 d8             	mov    -0x28(%ebp),%esi
  80051b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80051e:	85 d2                	test   %edx,%edx
  800520:	b8 00 00 00 00       	mov    $0x0,%eax
  800525:	0f 49 c2             	cmovns %edx,%eax
  800528:	29 c2                	sub    %eax,%edx
  80052a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80052d:	89 d7                	mov    %edx,%edi
  80052f:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800532:	eb 50                	jmp    800584 <vprintfmt+0x246>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800534:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800538:	74 1e                	je     800558 <vprintfmt+0x21a>
  80053a:	0f be d2             	movsbl %dl,%edx
  80053d:	83 ea 20             	sub    $0x20,%edx
  800540:	83 fa 5e             	cmp    $0x5e,%edx
  800543:	76 13                	jbe    800558 <vprintfmt+0x21a>
					putch('?', putdat);
  800545:	8b 45 0c             	mov    0xc(%ebp),%eax
  800548:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800553:	ff 55 08             	call   *0x8(%ebp)
  800556:	eb 0d                	jmp    800565 <vprintfmt+0x227>
				else
					putch(ch, putdat);
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 54 24 04          	mov    %edx,0x4(%esp)
  80055f:	89 04 24             	mov    %eax,(%esp)
  800562:	ff 55 08             	call   *0x8(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800565:	83 ef 01             	sub    $0x1,%edi
  800568:	eb 1a                	jmp    800584 <vprintfmt+0x246>
  80056a:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80056d:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800570:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800573:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800576:	eb 0c                	jmp    800584 <vprintfmt+0x246>
  800578:	89 7d 0c             	mov    %edi,0xc(%ebp)
  80057b:	8b 7d dc             	mov    -0x24(%ebp),%edi
  80057e:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800581:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800584:	83 c6 01             	add    $0x1,%esi
  800587:	0f b6 56 ff          	movzbl -0x1(%esi),%edx
  80058b:	0f be c2             	movsbl %dl,%eax
  80058e:	85 c0                	test   %eax,%eax
  800590:	74 27                	je     8005b9 <vprintfmt+0x27b>
  800592:	85 db                	test   %ebx,%ebx
  800594:	78 9e                	js     800534 <vprintfmt+0x1f6>
  800596:	83 eb 01             	sub    $0x1,%ebx
  800599:	79 99                	jns    800534 <vprintfmt+0x1f6>
  80059b:	89 f8                	mov    %edi,%eax
  80059d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005a0:	8b 75 08             	mov    0x8(%ebp),%esi
  8005a3:	89 c3                	mov    %eax,%ebx
  8005a5:	eb 1a                	jmp    8005c1 <vprintfmt+0x283>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005ab:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005b2:	ff d6                	call   *%esi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005b4:	83 eb 01             	sub    $0x1,%ebx
  8005b7:	eb 08                	jmp    8005c1 <vprintfmt+0x283>
  8005b9:	89 fb                	mov    %edi,%ebx
  8005bb:	8b 75 08             	mov    0x8(%ebp),%esi
  8005be:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8005c1:	85 db                	test   %ebx,%ebx
  8005c3:	7f e2                	jg     8005a7 <vprintfmt+0x269>
  8005c5:	89 75 08             	mov    %esi,0x8(%ebp)
  8005c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8005cb:	e9 93 fd ff ff       	jmp    800363 <vprintfmt+0x25>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005d0:	83 fa 01             	cmp    $0x1,%edx
  8005d3:	7e 16                	jle    8005eb <vprintfmt+0x2ad>
		return va_arg(*ap, long long);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8d 50 08             	lea    0x8(%eax),%edx
  8005db:	89 55 14             	mov    %edx,0x14(%ebp)
  8005de:	8b 50 04             	mov    0x4(%eax),%edx
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005e9:	eb 32                	jmp    80061d <vprintfmt+0x2df>
	else if (lflag)
  8005eb:	85 d2                	test   %edx,%edx
  8005ed:	74 18                	je     800607 <vprintfmt+0x2c9>
		return va_arg(*ap, long);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 50 04             	lea    0x4(%eax),%edx
  8005f5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005f8:	8b 30                	mov    (%eax),%esi
  8005fa:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8005fd:	89 f0                	mov    %esi,%eax
  8005ff:	c1 f8 1f             	sar    $0x1f,%eax
  800602:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800605:	eb 16                	jmp    80061d <vprintfmt+0x2df>
	else
		return va_arg(*ap, int);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8d 50 04             	lea    0x4(%eax),%edx
  80060d:	89 55 14             	mov    %edx,0x14(%ebp)
  800610:	8b 30                	mov    (%eax),%esi
  800612:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800615:	89 f0                	mov    %esi,%eax
  800617:	c1 f8 1f             	sar    $0x1f,%eax
  80061a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80061d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800620:	8b 55 e4             	mov    -0x1c(%ebp),%edx
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
  800623:	b9 0a 00 00 00       	mov    $0xa,%ecx
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
  800628:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062c:	0f 89 80 00 00 00    	jns    8006b2 <vprintfmt+0x374>
				putch('-', putdat);
  800632:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800636:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80063d:	ff 55 08             	call   *0x8(%ebp)
				num = -(long long) num;
  800640:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800643:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800646:	f7 d8                	neg    %eax
  800648:	83 d2 00             	adc    $0x0,%edx
  80064b:	f7 da                	neg    %edx
			}
			base = 10;
  80064d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800652:	eb 5e                	jmp    8006b2 <vprintfmt+0x374>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800654:	8d 45 14             	lea    0x14(%ebp),%eax
  800657:	e8 63 fc ff ff       	call   8002bf <getuint>
			base = 10;
  80065c:	b9 0a 00 00 00       	mov    $0xa,%ecx
			goto number;
  800661:	eb 4f                	jmp    8006b2 <vprintfmt+0x374>
		// (unsigned) octal
		case 'o':
			// Replace this with your code.


			num = getuint(&ap,lflag);
  800663:	8d 45 14             	lea    0x14(%ebp),%eax
  800666:	e8 54 fc ff ff       	call   8002bf <getuint>
			base =8;
  80066b:	b9 08 00 00 00       	mov    $0x8,%ecx
			goto number;
  800670:	eb 40                	jmp    8006b2 <vprintfmt+0x374>



		// pointer
		case 'p':
			putch('0', putdat);
  800672:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800676:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80067d:	ff 55 08             	call   *0x8(%ebp)
			putch('x', putdat);
  800680:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800684:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80068b:	ff 55 08             	call   *0x8(%ebp)
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8d 50 04             	lea    0x4(%eax),%edx
  800694:	89 55 14             	mov    %edx,0x14(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
				(uintptr_t) va_arg(ap, void *);
			base = 16;
  80069e:	b9 10 00 00 00       	mov    $0x10,%ecx
			goto number;
  8006a3:	eb 0d                	jmp    8006b2 <vprintfmt+0x374>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006a5:	8d 45 14             	lea    0x14(%ebp),%eax
  8006a8:	e8 12 fc ff ff       	call   8002bf <getuint>
			base = 16;
  8006ad:	b9 10 00 00 00       	mov    $0x10,%ecx
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006b2:	0f be 75 d8          	movsbl -0x28(%ebp),%esi
  8006b6:	89 74 24 10          	mov    %esi,0x10(%esp)
  8006ba:	8b 75 dc             	mov    -0x24(%ebp),%esi
  8006bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8006c1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006c5:	89 04 24             	mov    %eax,(%esp)
  8006c8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006cc:	89 fa                	mov    %edi,%edx
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	e8 fa fa ff ff       	call   8001d0 <printnum>
			break;
  8006d6:	e9 88 fc ff ff       	jmp    800363 <vprintfmt+0x25>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8006db:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006df:	89 04 24             	mov    %eax,(%esp)
  8006e2:	ff 55 08             	call   *0x8(%ebp)
			break;
  8006e5:	e9 79 fc ff ff       	jmp    800363 <vprintfmt+0x25>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8006ea:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006ee:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8006f5:	ff 55 08             	call   *0x8(%ebp)
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f8:	89 f3                	mov    %esi,%ebx
  8006fa:	eb 03                	jmp    8006ff <vprintfmt+0x3c1>
  8006fc:	83 eb 01             	sub    $0x1,%ebx
  8006ff:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
  800703:	75 f7                	jne    8006fc <vprintfmt+0x3be>
  800705:	e9 59 fc ff ff       	jmp    800363 <vprintfmt+0x25>
				/* do nothing */;
			break;
		}
	}
}
  80070a:	83 c4 3c             	add    $0x3c,%esp
  80070d:	5b                   	pop    %ebx
  80070e:	5e                   	pop    %esi
  80070f:	5f                   	pop    %edi
  800710:	5d                   	pop    %ebp
  800711:	c3                   	ret    

00800712 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800712:	55                   	push   %ebp
  800713:	89 e5                	mov    %esp,%ebp
  800715:	83 ec 28             	sub    $0x28,%esp
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80071e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800721:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800725:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800728:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80072f:	85 c0                	test   %eax,%eax
  800731:	74 30                	je     800763 <vsnprintf+0x51>
  800733:	85 d2                	test   %edx,%edx
  800735:	7e 2c                	jle    800763 <vsnprintf+0x51>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80073e:	8b 45 10             	mov    0x10(%ebp),%eax
  800741:	89 44 24 08          	mov    %eax,0x8(%esp)
  800745:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800748:	89 44 24 04          	mov    %eax,0x4(%esp)
  80074c:	c7 04 24 f9 02 80 00 	movl   $0x8002f9,(%esp)
  800753:	e8 e6 fb ff ff       	call   80033e <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80075b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80075e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800761:	eb 05                	jmp    800768 <vsnprintf+0x56>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
  800763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
  800768:	c9                   	leave  
  800769:	c3                   	ret    

0080076a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800770:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800773:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800777:	8b 45 10             	mov    0x10(%ebp),%eax
  80077a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800781:	89 44 24 04          	mov    %eax,0x4(%esp)
  800785:	8b 45 08             	mov    0x8(%ebp),%eax
  800788:	89 04 24             	mov    %eax,(%esp)
  80078b:	e8 82 ff ff ff       	call   800712 <vsnprintf>
	va_end(ap);

	return rc;
}
  800790:	c9                   	leave  
  800791:	c3                   	ret    
  800792:	66 90                	xchg   %ax,%ax
  800794:	66 90                	xchg   %ax,%ax
  800796:	66 90                	xchg   %ax,%ax
  800798:	66 90                	xchg   %ax,%ax
  80079a:	66 90                	xchg   %ax,%ax
  80079c:	66 90                	xchg   %ax,%ax
  80079e:	66 90                	xchg   %ax,%ax

008007a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007a0:	55                   	push   %ebp
  8007a1:	89 e5                	mov    %esp,%ebp
  8007a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ab:	eb 03                	jmp    8007b0 <strlen+0x10>
		n++;
  8007ad:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007b4:	75 f7                	jne    8007ad <strlen+0xd>
		n++;
	return n;
}
  8007b6:	5d                   	pop    %ebp
  8007b7:	c3                   	ret    

008007b8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007b8:	55                   	push   %ebp
  8007b9:	89 e5                	mov    %esp,%ebp
  8007bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007c6:	eb 03                	jmp    8007cb <strnlen+0x13>
		n++;
  8007c8:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007cb:	39 d0                	cmp    %edx,%eax
  8007cd:	74 06                	je     8007d5 <strnlen+0x1d>
  8007cf:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007d3:	75 f3                	jne    8007c8 <strnlen+0x10>
		n++;
	return n;
}
  8007d5:	5d                   	pop    %ebp
  8007d6:	c3                   	ret    

008007d7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007d7:	55                   	push   %ebp
  8007d8:	89 e5                	mov    %esp,%ebp
  8007da:	53                   	push   %ebx
  8007db:	8b 45 08             	mov    0x8(%ebp),%eax
  8007de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007e1:	89 c2                	mov    %eax,%edx
  8007e3:	83 c2 01             	add    $0x1,%edx
  8007e6:	83 c1 01             	add    $0x1,%ecx
  8007e9:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8007ed:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f0:	84 db                	test   %bl,%bl
  8007f2:	75 ef                	jne    8007e3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007f4:	5b                   	pop    %ebx
  8007f5:	5d                   	pop    %ebp
  8007f6:	c3                   	ret    

008007f7 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007f7:	55                   	push   %ebp
  8007f8:	89 e5                	mov    %esp,%ebp
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 08             	sub    $0x8,%esp
  8007fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800801:	89 1c 24             	mov    %ebx,(%esp)
  800804:	e8 97 ff ff ff       	call   8007a0 <strlen>
	strcpy(dst + len, src);
  800809:	8b 55 0c             	mov    0xc(%ebp),%edx
  80080c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800810:	01 d8                	add    %ebx,%eax
  800812:	89 04 24             	mov    %eax,(%esp)
  800815:	e8 bd ff ff ff       	call   8007d7 <strcpy>
	return dst;
}
  80081a:	89 d8                	mov    %ebx,%eax
  80081c:	83 c4 08             	add    $0x8,%esp
  80081f:	5b                   	pop    %ebx
  800820:	5d                   	pop    %ebp
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	56                   	push   %esi
  800826:	53                   	push   %ebx
  800827:	8b 75 08             	mov    0x8(%ebp),%esi
  80082a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082d:	89 f3                	mov    %esi,%ebx
  80082f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800832:	89 f2                	mov    %esi,%edx
  800834:	eb 0f                	jmp    800845 <strncpy+0x23>
		*dst++ = *src;
  800836:	83 c2 01             	add    $0x1,%edx
  800839:	0f b6 01             	movzbl (%ecx),%eax
  80083c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083f:	80 39 01             	cmpb   $0x1,(%ecx)
  800842:	83 d9 ff             	sbb    $0xffffffff,%ecx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800845:	39 da                	cmp    %ebx,%edx
  800847:	75 ed                	jne    800836 <strncpy+0x14>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800849:	89 f0                	mov    %esi,%eax
  80084b:	5b                   	pop    %ebx
  80084c:	5e                   	pop    %esi
  80084d:	5d                   	pop    %ebp
  80084e:	c3                   	ret    

0080084f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084f:	55                   	push   %ebp
  800850:	89 e5                	mov    %esp,%ebp
  800852:	56                   	push   %esi
  800853:	53                   	push   %ebx
  800854:	8b 75 08             	mov    0x8(%ebp),%esi
  800857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80085a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80085d:	89 f0                	mov    %esi,%eax
  80085f:	8d 5c 0e ff          	lea    -0x1(%esi,%ecx,1),%ebx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800863:	85 c9                	test   %ecx,%ecx
  800865:	75 0b                	jne    800872 <strlcpy+0x23>
  800867:	eb 1d                	jmp    800886 <strlcpy+0x37>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800869:	83 c0 01             	add    $0x1,%eax
  80086c:	83 c2 01             	add    $0x1,%edx
  80086f:	88 48 ff             	mov    %cl,-0x1(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800872:	39 d8                	cmp    %ebx,%eax
  800874:	74 0b                	je     800881 <strlcpy+0x32>
  800876:	0f b6 0a             	movzbl (%edx),%ecx
  800879:	84 c9                	test   %cl,%cl
  80087b:	75 ec                	jne    800869 <strlcpy+0x1a>
  80087d:	89 c2                	mov    %eax,%edx
  80087f:	eb 02                	jmp    800883 <strlcpy+0x34>
  800881:	89 c2                	mov    %eax,%edx
			*dst++ = *src++;
		*dst = '\0';
  800883:	c6 02 00             	movb   $0x0,(%edx)
	}
	return dst - dst_in;
  800886:	29 f0                	sub    %esi,%eax
}
  800888:	5b                   	pop    %ebx
  800889:	5e                   	pop    %esi
  80088a:	5d                   	pop    %ebp
  80088b:	c3                   	ret    

0080088c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800892:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800895:	eb 06                	jmp    80089d <strcmp+0x11>
		p++, q++;
  800897:	83 c1 01             	add    $0x1,%ecx
  80089a:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80089d:	0f b6 01             	movzbl (%ecx),%eax
  8008a0:	84 c0                	test   %al,%al
  8008a2:	74 04                	je     8008a8 <strcmp+0x1c>
  8008a4:	3a 02                	cmp    (%edx),%al
  8008a6:	74 ef                	je     800897 <strcmp+0xb>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008a8:	0f b6 c0             	movzbl %al,%eax
  8008ab:	0f b6 12             	movzbl (%edx),%edx
  8008ae:	29 d0                	sub    %edx,%eax
}
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    

008008b2 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008b2:	55                   	push   %ebp
  8008b3:	89 e5                	mov    %esp,%ebp
  8008b5:	53                   	push   %ebx
  8008b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008bc:	89 c3                	mov    %eax,%ebx
  8008be:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008c1:	eb 06                	jmp    8008c9 <strncmp+0x17>
		n--, p++, q++;
  8008c3:	83 c0 01             	add    $0x1,%eax
  8008c6:	83 c2 01             	add    $0x1,%edx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8008c9:	39 d8                	cmp    %ebx,%eax
  8008cb:	74 15                	je     8008e2 <strncmp+0x30>
  8008cd:	0f b6 08             	movzbl (%eax),%ecx
  8008d0:	84 c9                	test   %cl,%cl
  8008d2:	74 04                	je     8008d8 <strncmp+0x26>
  8008d4:	3a 0a                	cmp    (%edx),%cl
  8008d6:	74 eb                	je     8008c3 <strncmp+0x11>
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008d8:	0f b6 00             	movzbl (%eax),%eax
  8008db:	0f b6 12             	movzbl (%edx),%edx
  8008de:	29 d0                	sub    %edx,%eax
  8008e0:	eb 05                	jmp    8008e7 <strncmp+0x35>
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008e7:	5b                   	pop    %ebx
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f0:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8008f4:	eb 07                	jmp    8008fd <strchr+0x13>
		if (*s == c)
  8008f6:	38 ca                	cmp    %cl,%dl
  8008f8:	74 0f                	je     800909 <strchr+0x1f>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8008fa:	83 c0 01             	add    $0x1,%eax
  8008fd:	0f b6 10             	movzbl (%eax),%edx
  800900:	84 d2                	test   %dl,%dl
  800902:	75 f2                	jne    8008f6 <strchr+0xc>
		if (*s == c)
			return (char *) s;
	return 0;
  800904:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	8b 45 08             	mov    0x8(%ebp),%eax
  800911:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800915:	eb 07                	jmp    80091e <strfind+0x13>
		if (*s == c)
  800917:	38 ca                	cmp    %cl,%dl
  800919:	74 0a                	je     800925 <strfind+0x1a>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80091b:	83 c0 01             	add    $0x1,%eax
  80091e:	0f b6 10             	movzbl (%eax),%edx
  800921:	84 d2                	test   %dl,%dl
  800923:	75 f2                	jne    800917 <strfind+0xc>
		if (*s == c)
			break;
	return (char *) s;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	57                   	push   %edi
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800930:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800933:	85 c9                	test   %ecx,%ecx
  800935:	74 36                	je     80096d <memset+0x46>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800937:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80093d:	75 28                	jne    800967 <memset+0x40>
  80093f:	f6 c1 03             	test   $0x3,%cl
  800942:	75 23                	jne    800967 <memset+0x40>
		c &= 0xFF;
  800944:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800948:	89 d3                	mov    %edx,%ebx
  80094a:	c1 e3 08             	shl    $0x8,%ebx
  80094d:	89 d6                	mov    %edx,%esi
  80094f:	c1 e6 18             	shl    $0x18,%esi
  800952:	89 d0                	mov    %edx,%eax
  800954:	c1 e0 10             	shl    $0x10,%eax
  800957:	09 f0                	or     %esi,%eax
  800959:	09 c2                	or     %eax,%edx
  80095b:	89 d0                	mov    %edx,%eax
  80095d:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  80095f:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
  800962:	fc                   	cld    
  800963:	f3 ab                	rep stos %eax,%es:(%edi)
  800965:	eb 06                	jmp    80096d <memset+0x46>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	fc                   	cld    
  80096b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80096d:	89 f8                	mov    %edi,%eax
  80096f:	5b                   	pop    %ebx
  800970:	5e                   	pop    %esi
  800971:	5f                   	pop    %edi
  800972:	5d                   	pop    %ebp
  800973:	c3                   	ret    

00800974 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800974:	55                   	push   %ebp
  800975:	89 e5                	mov    %esp,%ebp
  800977:	57                   	push   %edi
  800978:	56                   	push   %esi
  800979:	8b 45 08             	mov    0x8(%ebp),%eax
  80097c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80097f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800982:	39 c6                	cmp    %eax,%esi
  800984:	73 35                	jae    8009bb <memmove+0x47>
  800986:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800989:	39 d0                	cmp    %edx,%eax
  80098b:	73 2e                	jae    8009bb <memmove+0x47>
		s += n;
		d += n;
  80098d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
  800990:	89 d6                	mov    %edx,%esi
  800992:	09 fe                	or     %edi,%esi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800994:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099a:	75 13                	jne    8009af <memmove+0x3b>
  80099c:	f6 c1 03             	test   $0x3,%cl
  80099f:	75 0e                	jne    8009af <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a1:	83 ef 04             	sub    $0x4,%edi
  8009a4:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009a7:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
  8009aa:	fd                   	std    
  8009ab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009ad:	eb 09                	jmp    8009b8 <memmove+0x44>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009af:	83 ef 01             	sub    $0x1,%edi
  8009b2:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8009b5:	fd                   	std    
  8009b6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009b8:	fc                   	cld    
  8009b9:	eb 1d                	jmp    8009d8 <memmove+0x64>
  8009bb:	89 f2                	mov    %esi,%edx
  8009bd:	09 c2                	or     %eax,%edx
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009bf:	f6 c2 03             	test   $0x3,%dl
  8009c2:	75 0f                	jne    8009d3 <memmove+0x5f>
  8009c4:	f6 c1 03             	test   $0x3,%cl
  8009c7:	75 0a                	jne    8009d3 <memmove+0x5f>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009c9:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
  8009cc:	89 c7                	mov    %eax,%edi
  8009ce:	fc                   	cld    
  8009cf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009d1:	eb 05                	jmp    8009d8 <memmove+0x64>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009d3:	89 c7                	mov    %eax,%edi
  8009d5:	fc                   	cld    
  8009d6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d8:	5e                   	pop    %esi
  8009d9:	5f                   	pop    %edi
  8009da:	5d                   	pop    %ebp
  8009db:	c3                   	ret    

008009dc <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009dc:	55                   	push   %ebp
  8009dd:	89 e5                	mov    %esp,%ebp
  8009df:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8009e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	89 04 24             	mov    %eax,(%esp)
  8009f6:	e8 79 ff ff ff       	call   800974 <memmove>
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	56                   	push   %esi
  800a01:	53                   	push   %ebx
  800a02:	8b 55 08             	mov    0x8(%ebp),%edx
  800a05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a08:	89 d6                	mov    %edx,%esi
  800a0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a0d:	eb 1a                	jmp    800a29 <memcmp+0x2c>
		if (*s1 != *s2)
  800a0f:	0f b6 02             	movzbl (%edx),%eax
  800a12:	0f b6 19             	movzbl (%ecx),%ebx
  800a15:	38 d8                	cmp    %bl,%al
  800a17:	74 0a                	je     800a23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
  800a19:	0f b6 c0             	movzbl %al,%eax
  800a1c:	0f b6 db             	movzbl %bl,%ebx
  800a1f:	29 d8                	sub    %ebx,%eax
  800a21:	eb 0f                	jmp    800a32 <memcmp+0x35>
		s1++, s2++;
  800a23:	83 c2 01             	add    $0x1,%edx
  800a26:	83 c1 01             	add    $0x1,%ecx
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800a29:	39 f2                	cmp    %esi,%edx
  800a2b:	75 e2                	jne    800a0f <memcmp+0x12>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a32:	5b                   	pop    %ebx
  800a33:	5e                   	pop    %esi
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a3f:	89 c2                	mov    %eax,%edx
  800a41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a44:	eb 07                	jmp    800a4d <memfind+0x17>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a46:	38 08                	cmp    %cl,(%eax)
  800a48:	74 07                	je     800a51 <memfind+0x1b>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800a4a:	83 c0 01             	add    $0x1,%eax
  800a4d:	39 d0                	cmp    %edx,%eax
  800a4f:	72 f5                	jb     800a46 <memfind+0x10>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800a51:	5d                   	pop    %ebp
  800a52:	c3                   	ret    

00800a53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a53:	55                   	push   %ebp
  800a54:	89 e5                	mov    %esp,%ebp
  800a56:	57                   	push   %edi
  800a57:	56                   	push   %esi
  800a58:	53                   	push   %ebx
  800a59:	8b 55 08             	mov    0x8(%ebp),%edx
  800a5c:	8b 45 10             	mov    0x10(%ebp),%eax
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a5f:	eb 03                	jmp    800a64 <strtol+0x11>
		s++;
  800a61:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a64:	0f b6 0a             	movzbl (%edx),%ecx
  800a67:	80 f9 09             	cmp    $0x9,%cl
  800a6a:	74 f5                	je     800a61 <strtol+0xe>
  800a6c:	80 f9 20             	cmp    $0x20,%cl
  800a6f:	74 f0                	je     800a61 <strtol+0xe>
		s++;

	// plus/minus sign
	if (*s == '+')
  800a71:	80 f9 2b             	cmp    $0x2b,%cl
  800a74:	75 0a                	jne    800a80 <strtol+0x2d>
		s++;
  800a76:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
  800a79:	bf 00 00 00 00       	mov    $0x0,%edi
  800a7e:	eb 11                	jmp    800a91 <strtol+0x3e>
  800a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
  800a85:	80 f9 2d             	cmp    $0x2d,%cl
  800a88:	75 07                	jne    800a91 <strtol+0x3e>
		s++, neg = 1;
  800a8a:	8d 52 01             	lea    0x1(%edx),%edx
  800a8d:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a91:	a9 ef ff ff ff       	test   $0xffffffef,%eax
  800a96:	75 15                	jne    800aad <strtol+0x5a>
  800a98:	80 3a 30             	cmpb   $0x30,(%edx)
  800a9b:	75 10                	jne    800aad <strtol+0x5a>
  800a9d:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800aa1:	75 0a                	jne    800aad <strtol+0x5a>
		s += 2, base = 16;
  800aa3:	83 c2 02             	add    $0x2,%edx
  800aa6:	b8 10 00 00 00       	mov    $0x10,%eax
  800aab:	eb 10                	jmp    800abd <strtol+0x6a>
	else if (base == 0 && s[0] == '0')
  800aad:	85 c0                	test   %eax,%eax
  800aaf:	75 0c                	jne    800abd <strtol+0x6a>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ab1:	b0 0a                	mov    $0xa,%al
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ab3:	80 3a 30             	cmpb   $0x30,(%edx)
  800ab6:	75 05                	jne    800abd <strtol+0x6a>
		s++, base = 8;
  800ab8:	83 c2 01             	add    $0x1,%edx
  800abb:	b0 08                	mov    $0x8,%al
	else if (base == 0)
		base = 10;
  800abd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ac2:	89 45 10             	mov    %eax,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ac5:	0f b6 0a             	movzbl (%edx),%ecx
  800ac8:	8d 71 d0             	lea    -0x30(%ecx),%esi
  800acb:	89 f0                	mov    %esi,%eax
  800acd:	3c 09                	cmp    $0x9,%al
  800acf:	77 08                	ja     800ad9 <strtol+0x86>
			dig = *s - '0';
  800ad1:	0f be c9             	movsbl %cl,%ecx
  800ad4:	83 e9 30             	sub    $0x30,%ecx
  800ad7:	eb 20                	jmp    800af9 <strtol+0xa6>
		else if (*s >= 'a' && *s <= 'z')
  800ad9:	8d 71 9f             	lea    -0x61(%ecx),%esi
  800adc:	89 f0                	mov    %esi,%eax
  800ade:	3c 19                	cmp    $0x19,%al
  800ae0:	77 08                	ja     800aea <strtol+0x97>
			dig = *s - 'a' + 10;
  800ae2:	0f be c9             	movsbl %cl,%ecx
  800ae5:	83 e9 57             	sub    $0x57,%ecx
  800ae8:	eb 0f                	jmp    800af9 <strtol+0xa6>
		else if (*s >= 'A' && *s <= 'Z')
  800aea:	8d 71 bf             	lea    -0x41(%ecx),%esi
  800aed:	89 f0                	mov    %esi,%eax
  800aef:	3c 19                	cmp    $0x19,%al
  800af1:	77 16                	ja     800b09 <strtol+0xb6>
			dig = *s - 'A' + 10;
  800af3:	0f be c9             	movsbl %cl,%ecx
  800af6:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800af9:	3b 4d 10             	cmp    0x10(%ebp),%ecx
  800afc:	7d 0f                	jge    800b0d <strtol+0xba>
			break;
		s++, val = (val * base) + dig;
  800afe:	83 c2 01             	add    $0x1,%edx
  800b01:	0f af 5d 10          	imul   0x10(%ebp),%ebx
  800b05:	01 cb                	add    %ecx,%ebx
		// we don't properly detect overflow!
	}
  800b07:	eb bc                	jmp    800ac5 <strtol+0x72>
  800b09:	89 d8                	mov    %ebx,%eax
  800b0b:	eb 02                	jmp    800b0f <strtol+0xbc>
  800b0d:	89 d8                	mov    %ebx,%eax

	if (endptr)
  800b0f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b13:	74 05                	je     800b1a <strtol+0xc7>
		*endptr = (char *) s;
  800b15:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b18:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
  800b1a:	f7 d8                	neg    %eax
  800b1c:	85 ff                	test   %edi,%edi
  800b1e:	0f 44 c3             	cmove  %ebx,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5f                   	pop    %edi
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	57                   	push   %edi
  800b2a:	56                   	push   %esi
  800b2b:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  800b31:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b34:	8b 55 08             	mov    0x8(%ebp),%edx
  800b37:	89 c3                	mov    %eax,%ebx
  800b39:	89 c7                	mov    %eax,%edi
  800b3b:	89 c6                	mov    %eax,%esi
  800b3d:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b3f:	5b                   	pop    %ebx
  800b40:	5e                   	pop    %esi
  800b41:	5f                   	pop    %edi
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	57                   	push   %edi
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  800b54:	89 d1                	mov    %edx,%ecx
  800b56:	89 d3                	mov    %edx,%ebx
  800b58:	89 d7                	mov    %edx,%edi
  800b5a:	89 d6                	mov    %edx,%esi
  800b5c:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    

00800b63 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
  800b66:	57                   	push   %edi
  800b67:	56                   	push   %esi
  800b68:	53                   	push   %ebx
  800b69:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b6c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	8b 55 08             	mov    0x8(%ebp),%edx
  800b79:	89 cb                	mov    %ecx,%ebx
  800b7b:	89 cf                	mov    %ecx,%edi
  800b7d:	89 ce                	mov    %ecx,%esi
  800b7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800b81:	85 c0                	test   %eax,%eax
  800b83:	7e 28                	jle    800bad <sys_env_destroy+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b85:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b89:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b90:	00 
  800b91:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800b98:	00 
  800b99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ba0:	00 
  800ba1:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ba8:	e8 29 16 00 00       	call   8021d6 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bad:	83 c4 2c             	add    $0x2c,%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc0:	b8 02 00 00 00       	mov    $0x2,%eax
  800bc5:	89 d1                	mov    %edx,%ecx
  800bc7:	89 d3                	mov    %edx,%ebx
  800bc9:	89 d7                	mov    %edx,%edi
  800bcb:	89 d6                	mov    %edx,%esi
  800bcd:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5f                   	pop    %edi
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    

00800bd4 <sys_yield>:

void
sys_yield(void)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	57                   	push   %edi
  800bd8:	56                   	push   %esi
  800bd9:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bda:	ba 00 00 00 00       	mov    $0x0,%edx
  800bdf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800be4:	89 d1                	mov    %edx,%ecx
  800be6:	89 d3                	mov    %edx,%ebx
  800be8:	89 d7                	mov    %edx,%edi
  800bea:	89 d6                	mov    %edx,%esi
  800bec:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bee:	5b                   	pop    %ebx
  800bef:	5e                   	pop    %esi
  800bf0:	5f                   	pop    %edi
  800bf1:	5d                   	pop    %ebp
  800bf2:	c3                   	ret    

00800bf3 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	57                   	push   %edi
  800bf7:	56                   	push   %esi
  800bf8:	53                   	push   %ebx
  800bf9:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800bfc:	be 00 00 00 00       	mov    $0x0,%esi
  800c01:	b8 04 00 00 00       	mov    $0x4,%eax
  800c06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c09:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c0f:	89 f7                	mov    %esi,%edi
  800c11:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c13:	85 c0                	test   %eax,%eax
  800c15:	7e 28                	jle    800c3f <sys_page_alloc+0x4c>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c17:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c1b:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800c22:	00 
  800c23:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800c2a:	00 
  800c2b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c32:	00 
  800c33:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800c3a:	e8 97 15 00 00       	call   8021d6 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c3f:	83 c4 2c             	add    $0x2c,%esp
  800c42:	5b                   	pop    %ebx
  800c43:	5e                   	pop    %esi
  800c44:	5f                   	pop    %edi
  800c45:	5d                   	pop    %ebp
  800c46:	c3                   	ret    

00800c47 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c47:	55                   	push   %ebp
  800c48:	89 e5                	mov    %esp,%ebp
  800c4a:	57                   	push   %edi
  800c4b:	56                   	push   %esi
  800c4c:	53                   	push   %ebx
  800c4d:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c50:	b8 05 00 00 00       	mov    $0x5,%eax
  800c55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c58:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c5e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c61:	8b 75 18             	mov    0x18(%ebp),%esi
  800c64:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800c66:	85 c0                	test   %eax,%eax
  800c68:	7e 28                	jle    800c92 <sys_page_map+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800c6e:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800c75:	00 
  800c76:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800c7d:	00 
  800c7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800c85:	00 
  800c86:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800c8d:	e8 44 15 00 00       	call   8021d6 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c92:	83 c4 2c             	add    $0x2c,%esp
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
  800ca0:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ca8:	b8 06 00 00 00       	mov    $0x6,%eax
  800cad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	89 df                	mov    %ebx,%edi
  800cb5:	89 de                	mov    %ebx,%esi
  800cb7:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800cb9:	85 c0                	test   %eax,%eax
  800cbb:	7e 28                	jle    800ce5 <sys_page_unmap+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbd:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc1:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800cc8:	00 
  800cc9:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800cd0:	00 
  800cd1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cd8:	00 
  800cd9:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ce0:	e8 f1 14 00 00       	call   8021d6 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ce5:	83 c4 2c             	add    $0x2c,%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    

00800ced <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ced:	55                   	push   %ebp
  800cee:	89 e5                	mov    %esp,%ebp
  800cf0:	57                   	push   %edi
  800cf1:	56                   	push   %esi
  800cf2:	53                   	push   %ebx
  800cf3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800d00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d03:	8b 55 08             	mov    0x8(%ebp),%edx
  800d06:	89 df                	mov    %ebx,%edi
  800d08:	89 de                	mov    %ebx,%esi
  800d0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d0c:	85 c0                	test   %eax,%eax
  800d0e:	7e 28                	jle    800d38 <sys_env_set_status+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d10:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d14:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800d1b:	00 
  800d1c:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800d23:	00 
  800d24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d2b:	00 
  800d2c:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800d33:	e8 9e 14 00 00       	call   8021d6 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d38:	83 c4 2c             	add    $0x2c,%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5f                   	pop    %edi
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <sys_env_set_trapframe>:

int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d4e:	b8 09 00 00 00       	mov    $0x9,%eax
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	89 df                	mov    %ebx,%edi
  800d5b:	89 de                	mov    %ebx,%esi
  800d5d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7e 28                	jle    800d8b <sys_env_set_trapframe+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d67:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800d6e:	00 
  800d6f:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800d76:	00 
  800d77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d7e:	00 
  800d7f:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800d86:	e8 4b 14 00 00       	call   8021d6 <_panic>
int

sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d8b:	83 c4 2c             	add    $0x2c,%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5e                   	pop    %esi
  800d90:	5f                   	pop    %edi
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_env_set_pgfault_upcall>:

int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
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
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7e 28                	jle    800dde <sys_env_set_pgfault_upcall+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dba:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800dc1:	00 
  800dc2:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800dc9:	00 
  800dca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dd1:	00 
  800dd2:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800dd9:	e8 f8 13 00 00       	call   8021d6 <_panic>
int

sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dde:	83 c4 2c             	add    $0x2c,%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    

00800de6 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800de6:	55                   	push   %ebp
  800de7:	89 e5                	mov    %esp,%ebp
  800de9:	57                   	push   %edi
  800dea:	56                   	push   %esi
  800deb:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dec:	be 00 00 00 00       	mov    $0x0,%esi
  800df1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dff:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e02:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e04:	5b                   	pop    %ebx
  800e05:	5e                   	pop    %esi
  800e06:	5f                   	pop    %edi
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	57                   	push   %edi
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e12:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e17:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	89 cb                	mov    %ecx,%ebx
  800e21:	89 cf                	mov    %ecx,%edi
  800e23:	89 ce                	mov    %ecx,%esi
  800e25:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7e 28                	jle    800e53 <sys_ipc_recv+0x4a>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e2f:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e36:	00 
  800e37:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800e3e:	00 
  800e3f:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e46:	00 
  800e47:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800e4e:	e8 83 13 00 00       	call   8021d6 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e53:	83 c4 2c             	add    $0x2c,%esp
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <sys_time_msec>:


unsigned int
sys_time_msec(void)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e61:	ba 00 00 00 00       	mov    $0x0,%edx
  800e66:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e6b:	89 d1                	mov    %edx,%ecx
  800e6d:	89 d3                	mov    %edx,%ebx
  800e6f:	89 d7                	mov    %edx,%edi
  800e71:	89 d6                	mov    %edx,%esi
  800e73:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5f                   	pop    %edi
  800e78:	5d                   	pop    %ebp
  800e79:	c3                   	ret    

00800e7a <sys_e1000_transmit>:


int
sys_e1000_transmit(char *data,int len)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	57                   	push   %edi
  800e7e:	56                   	push   %esi
  800e7f:	53                   	push   %ebx
  800e80:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e83:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e88:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e90:	8b 55 08             	mov    0x8(%ebp),%edx
  800e93:	89 df                	mov    %ebx,%edi
  800e95:	89 de                	mov    %ebx,%esi
  800e97:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800e99:	85 c0                	test   %eax,%eax
  800e9b:	7e 28                	jle    800ec5 <sys_e1000_transmit+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea1:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ea8:	00 
  800ea9:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb8:	00 
  800eb9:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800ec0:	e8 11 13 00 00       	call   8021d6 <_panic>

int
sys_e1000_transmit(char *data,int len)
{
	return (int) syscall(SYS_e1000_transmit,1,(uint32_t)data, (uint32_t)len, 0, 0, 0);
}
  800ec5:	83 c4 2c             	add    $0x2c,%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_e1000_recieve>:

int 
sys_e1000_recieve(char *data ,int *len)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 2c             	sub    $0x2c,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ee0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	89 df                	mov    %ebx,%edi
  800ee8:	89 de                	mov    %ebx,%esi
  800eea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	if(check && ret > 0)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	7e 28                	jle    800f18 <sys_e1000_recieve+0x4b>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef4:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
  800efb:	00 
  800efc:	c7 44 24 08 7f 29 80 	movl   $0x80297f,0x8(%esp)
  800f03:	00 
  800f04:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0b:	00 
  800f0c:	c7 04 24 9c 29 80 00 	movl   $0x80299c,(%esp)
  800f13:	e8 be 12 00 00       	call   8021d6 <_panic>

int 
sys_e1000_recieve(char *data ,int *len)
{
	return (int) syscall (SYS_e1000_recieve,1,(uint32_t)data,(uint32_t)len,0,0,0);
  800f18:	83 c4 2c             	add    $0x2c,%esp
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f23:	8b 45 08             	mov    0x8(%ebp),%eax
  800f26:	05 00 00 00 30       	add    $0x30000000,%eax
  800f2b:	c1 e8 0c             	shr    $0xc,%eax
}
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f33:	8b 45 08             	mov    0x8(%ebp),%eax
  800f36:	05 00 00 00 30       	add    $0x30000000,%eax
}

char*
fd2data(struct Fd *fd)
{
	return INDEX2DATA(fd2num(fd));
  800f3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800f40:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f4d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	c1 ea 16             	shr    $0x16,%edx
  800f57:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f5e:	f6 c2 01             	test   $0x1,%dl
  800f61:	74 11                	je     800f74 <fd_alloc+0x2d>
  800f63:	89 c2                	mov    %eax,%edx
  800f65:	c1 ea 0c             	shr    $0xc,%edx
  800f68:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f6f:	f6 c2 01             	test   $0x1,%dl
  800f72:	75 09                	jne    800f7d <fd_alloc+0x36>
			*fd_store = fd;
  800f74:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f76:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7b:	eb 17                	jmp    800f94 <fd_alloc+0x4d>
  800f7d:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800f82:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f87:	75 c9                	jne    800f52 <fd_alloc+0xb>
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f89:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f8f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
}
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f9c:	83 f8 1f             	cmp    $0x1f,%eax
  800f9f:	77 36                	ja     800fd7 <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800fa1:	c1 e0 0c             	shl    $0xc,%eax
  800fa4:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800fa9:	89 c2                	mov    %eax,%edx
  800fab:	c1 ea 16             	shr    $0x16,%edx
  800fae:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fb5:	f6 c2 01             	test   $0x1,%dl
  800fb8:	74 24                	je     800fde <fd_lookup+0x48>
  800fba:	89 c2                	mov    %eax,%edx
  800fbc:	c1 ea 0c             	shr    $0xc,%edx
  800fbf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800fc6:	f6 c2 01             	test   $0x1,%dl
  800fc9:	74 1a                	je     800fe5 <fd_lookup+0x4f>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fce:	89 02                	mov    %eax,(%edx)
	return 0;
  800fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd5:	eb 13                	jmp    800fea <fd_lookup+0x54>
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fd7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fdc:	eb 0c                	jmp    800fea <fd_lookup+0x54>
	}
	fd = INDEX2FD(fdnum);
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
  800fde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800fe3:	eb 05                	jmp    800fea <fd_lookup+0x54>
  800fe5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	}
	*fd_store = fd;
	return 0;
}
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 18             	sub    $0x18,%esp
  800ff2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++){
  800ff5:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffa:	eb 13                	jmp    80100f <dev_lookup+0x23>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
  800ffc:	39 08                	cmp    %ecx,(%eax)
  800ffe:	75 0c                	jne    80100c <dev_lookup+0x20>
			*dev = devtab[i];
  801000:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801003:	89 01                	mov    %eax,(%ecx)
			return 0;
  801005:	b8 00 00 00 00       	mov    $0x0,%eax
  80100a:	eb 38                	jmp    801044 <dev_lookup+0x58>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++){
  80100c:	83 c2 01             	add    $0x1,%edx
  80100f:	8b 04 95 28 2a 80 00 	mov    0x802a28(,%edx,4),%eax
  801016:	85 c0                	test   %eax,%eax
  801018:	75 e2                	jne    800ffc <dev_lookup+0x10>
		//cprintf("In Fd.c %s \n",devtab[i]->dev_id);
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80101a:	a1 08 40 80 00       	mov    0x804008,%eax
  80101f:	8b 40 48             	mov    0x48(%eax),%eax
  801022:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801026:	89 44 24 04          	mov    %eax,0x4(%esp)
  80102a:	c7 04 24 ac 29 80 00 	movl   $0x8029ac,(%esp)
  801031:	e8 76 f1 ff ff       	call   8001ac <cprintf>
	*dev = 0;
  801036:	8b 45 0c             	mov    0xc(%ebp),%eax
  801039:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80103f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801044:	c9                   	leave  
  801045:	c3                   	ret    

00801046 <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
  801049:	56                   	push   %esi
  80104a:	53                   	push   %ebx
  80104b:	83 ec 20             	sub    $0x20,%esp
  80104e:	8b 75 08             	mov    0x8(%ebp),%esi
  801051:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801054:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801057:	89 44 24 04          	mov    %eax,0x4(%esp)
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80105b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801061:	c1 e8 0c             	shr    $0xc,%eax
fd_close(struct Fd *fd, bool must_exist)
{
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801064:	89 04 24             	mov    %eax,(%esp)
  801067:	e8 2a ff ff ff       	call   800f96 <fd_lookup>
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 05                	js     801075 <fd_close+0x2f>
	    || fd != fd2)
  801070:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801073:	74 0c                	je     801081 <fd_close+0x3b>
		return (must_exist ? r : 0);
  801075:	84 db                	test   %bl,%bl
  801077:	ba 00 00 00 00       	mov    $0x0,%edx
  80107c:	0f 44 c2             	cmove  %edx,%eax
  80107f:	eb 3f                	jmp    8010c0 <fd_close+0x7a>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801081:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801084:	89 44 24 04          	mov    %eax,0x4(%esp)
  801088:	8b 06                	mov    (%esi),%eax
  80108a:	89 04 24             	mov    %eax,(%esp)
  80108d:	e8 5a ff ff ff       	call   800fec <dev_lookup>
  801092:	89 c3                	mov    %eax,%ebx
  801094:	85 c0                	test   %eax,%eax
  801096:	78 16                	js     8010ae <fd_close+0x68>
		if (dev->dev_close)
  801098:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80109b:	8b 40 10             	mov    0x10(%eax),%eax
			r = (*dev->dev_close)(fd);
		else
			r = 0;
  80109e:	bb 00 00 00 00       	mov    $0x0,%ebx
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
	    || fd != fd2)
		return (must_exist ? r : 0);
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
		if (dev->dev_close)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	74 07                	je     8010ae <fd_close+0x68>
			r = (*dev->dev_close)(fd);
  8010a7:	89 34 24             	mov    %esi,(%esp)
  8010aa:	ff d0                	call   *%eax
  8010ac:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8010ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b9:	e8 dc fb ff ff       	call   800c9a <sys_page_unmap>
	return r;
  8010be:	89 d8                	mov    %ebx,%eax
}
  8010c0:	83 c4 20             	add    $0x20,%esp
  8010c3:	5b                   	pop    %ebx
  8010c4:	5e                   	pop    %esi
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	89 04 24             	mov    %eax,(%esp)
  8010da:	e8 b7 fe ff ff       	call   800f96 <fd_lookup>
  8010df:	89 c2                	mov    %eax,%edx
  8010e1:	85 d2                	test   %edx,%edx
  8010e3:	78 13                	js     8010f8 <close+0x31>
		return r;
	else
		return fd_close(fd, 1);
  8010e5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8010ec:	00 
  8010ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f0:	89 04 24             	mov    %eax,(%esp)
  8010f3:	e8 4e ff ff ff       	call   801046 <fd_close>
}
  8010f8:	c9                   	leave  
  8010f9:	c3                   	ret    

008010fa <close_all>:

void
close_all(void)
{
  8010fa:	55                   	push   %ebp
  8010fb:	89 e5                	mov    %esp,%ebp
  8010fd:	53                   	push   %ebx
  8010fe:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801101:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801106:	89 1c 24             	mov    %ebx,(%esp)
  801109:	e8 b9 ff ff ff       	call   8010c7 <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80110e:	83 c3 01             	add    $0x1,%ebx
  801111:	83 fb 20             	cmp    $0x20,%ebx
  801114:	75 f0                	jne    801106 <close_all+0xc>
		close(i);
}
  801116:	83 c4 14             	add    $0x14,%esp
  801119:	5b                   	pop    %ebx
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	57                   	push   %edi
  801120:	56                   	push   %esi
  801121:	53                   	push   %ebx
  801122:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801125:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801128:	89 44 24 04          	mov    %eax,0x4(%esp)
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	89 04 24             	mov    %eax,(%esp)
  801132:	e8 5f fe ff ff       	call   800f96 <fd_lookup>
  801137:	89 c2                	mov    %eax,%edx
  801139:	85 d2                	test   %edx,%edx
  80113b:	0f 88 e1 00 00 00    	js     801222 <dup+0x106>
		return r;
	close(newfdnum);
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	89 04 24             	mov    %eax,(%esp)
  801147:	e8 7b ff ff ff       	call   8010c7 <close>

	newfd = INDEX2FD(newfdnum);
  80114c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80114f:	c1 e3 0c             	shl    $0xc,%ebx
  801152:	81 eb 00 00 00 30    	sub    $0x30000000,%ebx
	ova = fd2data(oldfd);
  801158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80115b:	89 04 24             	mov    %eax,(%esp)
  80115e:	e8 cd fd ff ff       	call   800f30 <fd2data>
  801163:	89 c6                	mov    %eax,%esi
	nva = fd2data(newfd);
  801165:	89 1c 24             	mov    %ebx,(%esp)
  801168:	e8 c3 fd ff ff       	call   800f30 <fd2data>
  80116d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80116f:	89 f0                	mov    %esi,%eax
  801171:	c1 e8 16             	shr    $0x16,%eax
  801174:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80117b:	a8 01                	test   $0x1,%al
  80117d:	74 43                	je     8011c2 <dup+0xa6>
  80117f:	89 f0                	mov    %esi,%eax
  801181:	c1 e8 0c             	shr    $0xc,%eax
  801184:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80118b:	f6 c2 01             	test   $0x1,%dl
  80118e:	74 32                	je     8011c2 <dup+0xa6>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801190:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801197:	25 07 0e 00 00       	and    $0xe07,%eax
  80119c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8011a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011ab:	00 
  8011ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b7:	e8 8b fa ff ff       	call   800c47 <sys_page_map>
  8011bc:	89 c6                	mov    %eax,%esi
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	78 3e                	js     801200 <dup+0xe4>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c5:	89 c2                	mov    %eax,%edx
  8011c7:	c1 ea 0c             	shr    $0xc,%edx
  8011ca:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011d1:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8011d7:	89 54 24 10          	mov    %edx,0x10(%esp)
  8011db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8011df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8011e6:	00 
  8011e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011f2:	e8 50 fa ff ff       	call   800c47 <sys_page_map>
  8011f7:	89 c6                	mov    %eax,%esi
		goto err;

	return newfdnum;
  8011f9:	8b 45 0c             	mov    0xc(%ebp),%eax
	nva = fd2data(newfd);

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8011fc:	85 f6                	test   %esi,%esi
  8011fe:	79 22                	jns    801222 <dup+0x106>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801200:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801204:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80120b:	e8 8a fa ff ff       	call   800c9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801210:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801214:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80121b:	e8 7a fa ff ff       	call   800c9a <sys_page_unmap>
	return r;
  801220:	89 f0                	mov    %esi,%eax
}
  801222:	83 c4 3c             	add    $0x3c,%esp
  801225:	5b                   	pop    %ebx
  801226:	5e                   	pop    %esi
  801227:	5f                   	pop    %edi
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    

0080122a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80122a:	55                   	push   %ebp
  80122b:	89 e5                	mov    %esp,%ebp
  80122d:	53                   	push   %ebx
  80122e:	83 ec 24             	sub    $0x24,%esp
  801231:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801234:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123b:	89 1c 24             	mov    %ebx,(%esp)
  80123e:	e8 53 fd ff ff       	call   800f96 <fd_lookup>
  801243:	89 c2                	mov    %eax,%edx
  801245:	85 d2                	test   %edx,%edx
  801247:	78 6d                	js     8012b6 <read+0x8c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801249:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80124c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801253:	8b 00                	mov    (%eax),%eax
  801255:	89 04 24             	mov    %eax,(%esp)
  801258:	e8 8f fd ff ff       	call   800fec <dev_lookup>
  80125d:	85 c0                	test   %eax,%eax
  80125f:	78 55                	js     8012b6 <read+0x8c>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801264:	8b 50 08             	mov    0x8(%eax),%edx
  801267:	83 e2 03             	and    $0x3,%edx
  80126a:	83 fa 01             	cmp    $0x1,%edx
  80126d:	75 23                	jne    801292 <read+0x68>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80126f:	a1 08 40 80 00       	mov    0x804008,%eax
  801274:	8b 40 48             	mov    0x48(%eax),%eax
  801277:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80127b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80127f:	c7 04 24 ed 29 80 00 	movl   $0x8029ed,(%esp)
  801286:	e8 21 ef ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  80128b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801290:	eb 24                	jmp    8012b6 <read+0x8c>
	}
	if (!dev->dev_read)
  801292:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801295:	8b 52 08             	mov    0x8(%edx),%edx
  801298:	85 d2                	test   %edx,%edx
  80129a:	74 15                	je     8012b1 <read+0x87>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80129c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80129f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	ff d2                	call   *%edx
  8012af:	eb 05                	jmp    8012b6 <read+0x8c>
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
		return -E_NOT_SUPP;
  8012b1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_read)(fd, buf, n);
}
  8012b6:	83 c4 24             	add    $0x24,%esp
  8012b9:	5b                   	pop    %ebx
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	57                   	push   %edi
  8012c0:	56                   	push   %esi
  8012c1:	53                   	push   %ebx
  8012c2:	83 ec 1c             	sub    $0x1c,%esp
  8012c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8012c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d0:	eb 23                	jmp    8012f5 <readn+0x39>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8012d2:	89 f0                	mov    %esi,%eax
  8012d4:	29 d8                	sub    %ebx,%eax
  8012d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012da:	89 d8                	mov    %ebx,%eax
  8012dc:	03 45 0c             	add    0xc(%ebp),%eax
  8012df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e3:	89 3c 24             	mov    %edi,(%esp)
  8012e6:	e8 3f ff ff ff       	call   80122a <read>
		if (m < 0)
  8012eb:	85 c0                	test   %eax,%eax
  8012ed:	78 10                	js     8012ff <readn+0x43>
			return m;
		if (m == 0)
  8012ef:	85 c0                	test   %eax,%eax
  8012f1:	74 0a                	je     8012fd <readn+0x41>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8012f3:	01 c3                	add    %eax,%ebx
  8012f5:	39 f3                	cmp    %esi,%ebx
  8012f7:	72 d9                	jb     8012d2 <readn+0x16>
  8012f9:	89 d8                	mov    %ebx,%eax
  8012fb:	eb 02                	jmp    8012ff <readn+0x43>
  8012fd:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8012ff:	83 c4 1c             	add    $0x1c,%esp
  801302:	5b                   	pop    %ebx
  801303:	5e                   	pop    %esi
  801304:	5f                   	pop    %edi
  801305:	5d                   	pop    %ebp
  801306:	c3                   	ret    

00801307 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	53                   	push   %ebx
  80130b:	83 ec 24             	sub    $0x24,%esp
  80130e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801314:	89 44 24 04          	mov    %eax,0x4(%esp)
  801318:	89 1c 24             	mov    %ebx,(%esp)
  80131b:	e8 76 fc ff ff       	call   800f96 <fd_lookup>
  801320:	89 c2                	mov    %eax,%edx
  801322:	85 d2                	test   %edx,%edx
  801324:	78 68                	js     80138e <write+0x87>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801329:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801330:	8b 00                	mov    (%eax),%eax
  801332:	89 04 24             	mov    %eax,(%esp)
  801335:	e8 b2 fc ff ff       	call   800fec <dev_lookup>
  80133a:	85 c0                	test   %eax,%eax
  80133c:	78 50                	js     80138e <write+0x87>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80133e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801341:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801345:	75 23                	jne    80136a <write+0x63>
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801347:	a1 08 40 80 00       	mov    0x804008,%eax
  80134c:	8b 40 48             	mov    0x48(%eax),%eax
  80134f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801353:	89 44 24 04          	mov    %eax,0x4(%esp)
  801357:	c7 04 24 09 2a 80 00 	movl   $0x802a09,(%esp)
  80135e:	e8 49 ee ff ff       	call   8001ac <cprintf>
		return -E_INVAL;
  801363:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801368:	eb 24                	jmp    80138e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80136a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80136d:	8b 52 0c             	mov    0xc(%edx),%edx
  801370:	85 d2                	test   %edx,%edx
  801372:	74 15                	je     801389 <write+0x82>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801374:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801377:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80137b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801382:	89 04 24             	mov    %eax,(%esp)
  801385:	ff d2                	call   *%edx
  801387:	eb 05                	jmp    80138e <write+0x87>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
		return -E_NOT_SUPP;
  801389:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_write)(fd, buf, n);
}
  80138e:	83 c4 24             	add    $0x24,%esp
  801391:	5b                   	pop    %ebx
  801392:	5d                   	pop    %ebp
  801393:	c3                   	ret    

00801394 <seek>:

int
seek(int fdnum, off_t offset)
{
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80139d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a4:	89 04 24             	mov    %eax,(%esp)
  8013a7:	e8 ea fb ff ff       	call   800f96 <fd_lookup>
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 0e                	js     8013be <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b6:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8013b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013be:	c9                   	leave  
  8013bf:	c3                   	ret    

008013c0 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8013c0:	55                   	push   %ebp
  8013c1:	89 e5                	mov    %esp,%ebp
  8013c3:	53                   	push   %ebx
  8013c4:	83 ec 24             	sub    $0x24,%esp
  8013c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	89 1c 24             	mov    %ebx,(%esp)
  8013d4:	e8 bd fb ff ff       	call   800f96 <fd_lookup>
  8013d9:	89 c2                	mov    %eax,%edx
  8013db:	85 d2                	test   %edx,%edx
  8013dd:	78 61                	js     801440 <ftruncate+0x80>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e9:	8b 00                	mov    (%eax),%eax
  8013eb:	89 04 24             	mov    %eax,(%esp)
  8013ee:	e8 f9 fb ff ff       	call   800fec <dev_lookup>
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	78 49                	js     801440 <ftruncate+0x80>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fa:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013fe:	75 23                	jne    801423 <ftruncate+0x63>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
  801400:	a1 08 40 80 00       	mov    0x804008,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801405:	8b 40 48             	mov    0x48(%eax),%eax
  801408:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80140c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801410:	c7 04 24 cc 29 80 00 	movl   $0x8029cc,(%esp)
  801417:	e8 90 ed ff ff       	call   8001ac <cprintf>
			thisenv->env_id, fdnum);
		return -E_INVAL;
  80141c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801421:	eb 1d                	jmp    801440 <ftruncate+0x80>
	}
	if (!dev->dev_trunc)
  801423:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801426:	8b 52 18             	mov    0x18(%edx),%edx
  801429:	85 d2                	test   %edx,%edx
  80142b:	74 0e                	je     80143b <ftruncate+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80142d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801430:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801434:	89 04 24             	mov    %eax,(%esp)
  801437:	ff d2                	call   *%edx
  801439:	eb 05                	jmp    801440 <ftruncate+0x80>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
		return -E_NOT_SUPP;
  80143b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return (*dev->dev_trunc)(fd, newsize);
}
  801440:	83 c4 24             	add    $0x24,%esp
  801443:	5b                   	pop    %ebx
  801444:	5d                   	pop    %ebp
  801445:	c3                   	ret    

00801446 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801446:	55                   	push   %ebp
  801447:	89 e5                	mov    %esp,%ebp
  801449:	53                   	push   %ebx
  80144a:	83 ec 24             	sub    $0x24,%esp
  80144d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801450:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801453:	89 44 24 04          	mov    %eax,0x4(%esp)
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	89 04 24             	mov    %eax,(%esp)
  80145d:	e8 34 fb ff ff       	call   800f96 <fd_lookup>
  801462:	89 c2                	mov    %eax,%edx
  801464:	85 d2                	test   %edx,%edx
  801466:	78 52                	js     8014ba <fstat+0x74>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801468:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80146f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801472:	8b 00                	mov    (%eax),%eax
  801474:	89 04 24             	mov    %eax,(%esp)
  801477:	e8 70 fb ff ff       	call   800fec <dev_lookup>
  80147c:	85 c0                	test   %eax,%eax
  80147e:	78 3a                	js     8014ba <fstat+0x74>
		return r;
	if (!dev->dev_stat)
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801487:	74 2c                	je     8014b5 <fstat+0x6f>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801489:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80148c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801493:	00 00 00 
	stat->st_isdir = 0;
  801496:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80149d:	00 00 00 
	stat->st_dev = dev;
  8014a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014a6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ad:	89 14 24             	mov    %edx,(%esp)
  8014b0:	ff 50 14             	call   *0x14(%eax)
  8014b3:	eb 05                	jmp    8014ba <fstat+0x74>

	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
		return -E_NOT_SUPP;
  8014b5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	stat->st_name[0] = 0;
	stat->st_size = 0;
	stat->st_isdir = 0;
	stat->st_dev = dev;
	return (*dev->dev_stat)(fd, stat);
}
  8014ba:	83 c4 24             	add    $0x24,%esp
  8014bd:	5b                   	pop    %ebx
  8014be:	5d                   	pop    %ebp
  8014bf:	c3                   	ret    

008014c0 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	56                   	push   %esi
  8014c4:	53                   	push   %ebx
  8014c5:	83 ec 10             	sub    $0x10,%esp
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8014c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014cf:	00 
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	89 04 24             	mov    %eax,(%esp)
  8014d6:	e8 28 02 00 00       	call   801703 <open>
  8014db:	89 c3                	mov    %eax,%ebx
  8014dd:	85 db                	test   %ebx,%ebx
  8014df:	78 1b                	js     8014fc <stat+0x3c>
		return fd;
	r = fstat(fd, stat);
  8014e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e8:	89 1c 24             	mov    %ebx,(%esp)
  8014eb:	e8 56 ff ff ff       	call   801446 <fstat>
  8014f0:	89 c6                	mov    %eax,%esi
	close(fd);
  8014f2:	89 1c 24             	mov    %ebx,(%esp)
  8014f5:	e8 cd fb ff ff       	call   8010c7 <close>
	return r;
  8014fa:	89 f0                	mov    %esi,%eax
}
  8014fc:	83 c4 10             	add    $0x10,%esp
  8014ff:	5b                   	pop    %ebx
  801500:	5e                   	pop    %esi
  801501:	5d                   	pop    %ebp
  801502:	c3                   	ret    

00801503 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	56                   	push   %esi
  801507:	53                   	push   %ebx
  801508:	83 ec 10             	sub    $0x10,%esp
  80150b:	89 c6                	mov    %eax,%esi
  80150d:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80150f:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801516:	75 11                	jne    801529 <fsipc+0x26>
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801518:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80151f:	e8 d0 0d 00 00       	call   8022f4 <ipc_find_env>
  801524:	a3 00 40 80 00       	mov    %eax,0x804000
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801529:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801530:	00 
  801531:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801538:	00 
  801539:	89 74 24 04          	mov    %esi,0x4(%esp)
  80153d:	a1 00 40 80 00       	mov    0x804000,%eax
  801542:	89 04 24             	mov    %eax,(%esp)
  801545:	e8 4c 0d 00 00       	call   802296 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80154a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801551:	00 
  801552:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801556:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155d:	e8 ca 0c 00 00       	call   80222c <ipc_recv>
}
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	5b                   	pop    %ebx
  801566:	5e                   	pop    %esi
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    

00801569 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80156f:	8b 45 08             	mov    0x8(%ebp),%eax
  801572:	8b 40 0c             	mov    0xc(%eax),%eax
  801575:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80157a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157d:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801582:	ba 00 00 00 00       	mov    $0x0,%edx
  801587:	b8 02 00 00 00       	mov    $0x2,%eax
  80158c:	e8 72 ff ff ff       	call   801503 <fsipc>
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
  801596:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	8b 40 0c             	mov    0xc(%eax),%eax
  80159f:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a9:	b8 06 00 00 00       	mov    $0x6,%eax
  8015ae:	e8 50 ff ff ff       	call   801503 <fsipc>
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <devfile_stat>:

}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	53                   	push   %ebx
  8015b9:	83 ec 14             	sub    $0x14,%esp
  8015bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c5:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cf:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d4:	e8 2a ff ff ff       	call   801503 <fsipc>
  8015d9:	89 c2                	mov    %eax,%edx
  8015db:	85 d2                	test   %edx,%edx
  8015dd:	78 2b                	js     80160a <devfile_stat+0x55>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8015df:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8015e6:	00 
  8015e7:	89 1c 24             	mov    %ebx,(%esp)
  8015ea:	e8 e8 f1 ff ff       	call   8007d7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8015ef:	a1 80 50 80 00       	mov    0x805080,%eax
  8015f4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8015fa:	a1 84 50 80 00       	mov    0x805084,%eax
  8015ff:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80160a:	83 c4 14             	add    $0x14,%esp
  80160d:	5b                   	pop    %ebx
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	83 ec 18             	sub    $0x18,%esp
  801616:	8b 45 10             	mov    0x10(%ebp),%eax
  801619:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80161e:	ba f8 0f 00 00       	mov    $0xff8,%edx
  801623:	0f 47 c2             	cmova  %edx,%eax
	// remember that write is always allowed to write *fewer*
	// bytes than requested.

    if(n > (PGSIZE-sizeof(int)-sizeof(size_t)))
    	n = PGSIZE-sizeof(int)-sizeof(size_t);
    fsipcbuf.write.req_n = n;
  801626:	a3 04 50 80 00       	mov    %eax,0x805004
    fsipcbuf.write.req_fileid = fd->fd_file.id;
  80162b:	8b 55 08             	mov    0x8(%ebp),%edx
  80162e:	8b 52 0c             	mov    0xc(%edx),%edx
  801631:	89 15 00 50 80 00    	mov    %edx,0x805000
    memmove(fsipcbuf.write.req_buf,buf,n);
  801637:	89 44 24 08          	mov    %eax,0x8(%esp)
  80163b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801642:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  801649:	e8 26 f3 ff ff       	call   800974 <memmove>
    return fsipc(FSREQ_WRITE,NULL); 
  80164e:	ba 00 00 00 00       	mov    $0x0,%edx
  801653:	b8 04 00 00 00       	mov    $0x4,%eax
  801658:	e8 a6 fe ff ff       	call   801503 <fsipc>
	// LAB 5: Your code here
	//panic("devfile_write not implemented");

}
  80165d:	c9                   	leave  
  80165e:	c3                   	ret    

0080165f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80165f:	55                   	push   %ebp
  801660:	89 e5                	mov    %esp,%ebp
  801662:	56                   	push   %esi
  801663:	53                   	push   %ebx
  801664:	83 ec 10             	sub    $0x10,%esp
  801667:	8b 75 10             	mov    0x10(%ebp),%esi
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	int r;

	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8b 40 0c             	mov    0xc(%eax),%eax
  801670:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801675:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80167b:	ba 00 00 00 00       	mov    $0x0,%edx
  801680:	b8 03 00 00 00       	mov    $0x3,%eax
  801685:	e8 79 fe ff ff       	call   801503 <fsipc>
  80168a:	89 c3                	mov    %eax,%ebx
  80168c:	85 c0                	test   %eax,%eax
  80168e:	78 6a                	js     8016fa <devfile_read+0x9b>
		return r;
	assert(r <= n);
  801690:	39 c6                	cmp    %eax,%esi
  801692:	73 24                	jae    8016b8 <devfile_read+0x59>
  801694:	c7 44 24 0c 3c 2a 80 	movl   $0x802a3c,0xc(%esp)
  80169b:	00 
  80169c:	c7 44 24 08 43 2a 80 	movl   $0x802a43,0x8(%esp)
  8016a3:	00 
  8016a4:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  8016ab:	00 
  8016ac:	c7 04 24 58 2a 80 00 	movl   $0x802a58,(%esp)
  8016b3:	e8 1e 0b 00 00       	call   8021d6 <_panic>
	assert(r <= PGSIZE);
  8016b8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016bd:	7e 24                	jle    8016e3 <devfile_read+0x84>
  8016bf:	c7 44 24 0c 63 2a 80 	movl   $0x802a63,0xc(%esp)
  8016c6:	00 
  8016c7:	c7 44 24 08 43 2a 80 	movl   $0x802a43,0x8(%esp)
  8016ce:	00 
  8016cf:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  8016d6:	00 
  8016d7:	c7 04 24 58 2a 80 00 	movl   $0x802a58,(%esp)
  8016de:	e8 f3 0a 00 00       	call   8021d6 <_panic>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e7:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8016ee:	00 
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	89 04 24             	mov    %eax,(%esp)
  8016f5:	e8 7a f2 ff ff       	call   800974 <memmove>
	return r;
}
  8016fa:	89 d8                	mov    %ebx,%eax
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	5b                   	pop    %ebx
  801700:	5e                   	pop    %esi
  801701:	5d                   	pop    %ebp
  801702:	c3                   	ret    

00801703 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	53                   	push   %ebx
  801707:	83 ec 24             	sub    $0x24,%esp
  80170a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// file descriptor.

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
  80170d:	89 1c 24             	mov    %ebx,(%esp)
  801710:	e8 8b f0 ff ff       	call   8007a0 <strlen>
  801715:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80171a:	7f 60                	jg     80177c <open+0x79>
		return -E_BAD_PATH;

	if ((r = fd_alloc(&fd)) < 0)
  80171c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80171f:	89 04 24             	mov    %eax,(%esp)
  801722:	e8 20 f8 ff ff       	call   800f47 <fd_alloc>
  801727:	89 c2                	mov    %eax,%edx
  801729:	85 d2                	test   %edx,%edx
  80172b:	78 54                	js     801781 <open+0x7e>
		return r;

	strcpy(fsipcbuf.open.req_path, path);
  80172d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801731:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  801738:	e8 9a f0 ff ff       	call   8007d7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80173d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801740:	a3 00 54 80 00       	mov    %eax,0x805400

	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801745:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801748:	b8 01 00 00 00       	mov    $0x1,%eax
  80174d:	e8 b1 fd ff ff       	call   801503 <fsipc>
  801752:	89 c3                	mov    %eax,%ebx
  801754:	85 c0                	test   %eax,%eax
  801756:	79 17                	jns    80176f <open+0x6c>
		fd_close(fd, 0);
  801758:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80175f:	00 
  801760:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801763:	89 04 24             	mov    %eax,(%esp)
  801766:	e8 db f8 ff ff       	call   801046 <fd_close>
		return r;
  80176b:	89 d8                	mov    %ebx,%eax
  80176d:	eb 12                	jmp    801781 <open+0x7e>
	}

	return fd2num(fd);
  80176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801772:	89 04 24             	mov    %eax,(%esp)
  801775:	e8 a6 f7 ff ff       	call   800f20 <fd2num>
  80177a:	eb 05                	jmp    801781 <open+0x7e>

	int r;
	struct Fd *fd;

	if (strlen(path) >= MAXPATHLEN)
		return -E_BAD_PATH;
  80177c:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
		fd_close(fd, 0);
		return r;
	}

	return fd2num(fd);
}
  801781:	83 c4 24             	add    $0x24,%esp
  801784:	5b                   	pop    %ebx
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80178d:	ba 00 00 00 00       	mov    $0x0,%edx
  801792:	b8 08 00 00 00       	mov    $0x8,%eax
  801797:	e8 67 fd ff ff       	call   801503 <fsipc>
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    
  80179e:	66 90                	xchg   %ax,%ax

008017a0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017a0:	55                   	push   %ebp
  8017a1:	89 e5                	mov    %esp,%ebp
  8017a3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8017a6:	c7 44 24 04 6f 2a 80 	movl   $0x802a6f,0x4(%esp)
  8017ad:	00 
  8017ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b1:	89 04 24             	mov    %eax,(%esp)
  8017b4:	e8 1e f0 ff ff       	call   8007d7 <strcpy>
	return 0;
}
  8017b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017be:	c9                   	leave  
  8017bf:	c3                   	ret    

008017c0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 14             	sub    $0x14,%esp
  8017c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017ca:	89 1c 24             	mov    %ebx,(%esp)
  8017cd:	e8 5a 0b 00 00       	call   80232c <pageref>
		return nsipc_close(fd->fd_sock.sockid);
	else
		return 0;
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
}

static int
devsock_close(struct Fd *fd)
{
	if (pageref(fd) == 1)
  8017d7:	83 f8 01             	cmp    $0x1,%eax
  8017da:	75 0d                	jne    8017e9 <devsock_close+0x29>
		return nsipc_close(fd->fd_sock.sockid);
  8017dc:	8b 43 0c             	mov    0xc(%ebx),%eax
  8017df:	89 04 24             	mov    %eax,(%esp)
  8017e2:	e8 29 03 00 00       	call   801b10 <nsipc_close>
  8017e7:	89 c2                	mov    %eax,%edx
	else
		return 0;
}
  8017e9:	89 d0                	mov    %edx,%eax
  8017eb:	83 c4 14             	add    $0x14,%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5d                   	pop    %ebp
  8017f0:	c3                   	ret    

008017f1 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8017f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8017fe:	00 
  8017ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801802:	89 44 24 08          	mov    %eax,0x8(%esp)
  801806:	8b 45 0c             	mov    0xc(%ebp),%eax
  801809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8b 40 0c             	mov    0xc(%eax),%eax
  801813:	89 04 24             	mov    %eax,(%esp)
  801816:	e8 f0 03 00 00       	call   801c0b <nsipc_send>
}
  80181b:	c9                   	leave  
  80181c:	c3                   	ret    

0080181d <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  80181d:	55                   	push   %ebp
  80181e:	89 e5                	mov    %esp,%ebp
  801820:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801823:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80182a:	00 
  80182b:	8b 45 10             	mov    0x10(%ebp),%eax
  80182e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801832:	8b 45 0c             	mov    0xc(%ebp),%eax
  801835:	89 44 24 04          	mov    %eax,0x4(%esp)
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
  80183c:	8b 40 0c             	mov    0xc(%eax),%eax
  80183f:	89 04 24             	mov    %eax,(%esp)
  801842:	e8 44 03 00 00       	call   801b8b <nsipc_recv>
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  80184f:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801852:	89 54 24 04          	mov    %edx,0x4(%esp)
  801856:	89 04 24             	mov    %eax,(%esp)
  801859:	e8 38 f7 ff ff       	call   800f96 <fd_lookup>
  80185e:	85 c0                	test   %eax,%eax
  801860:	78 17                	js     801879 <fd2sockid+0x30>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801865:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80186b:	39 08                	cmp    %ecx,(%eax)
  80186d:	75 05                	jne    801874 <fd2sockid+0x2b>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80186f:	8b 40 0c             	mov    0xc(%eax),%eax
  801872:	eb 05                	jmp    801879 <fd2sockid+0x30>
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
		return -E_NOT_SUPP;
  801874:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
	return sfd->fd_sock.sockid;
}
  801879:	c9                   	leave  
  80187a:	c3                   	ret    

0080187b <alloc_sockfd>:

static int
alloc_sockfd(int sockid)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 20             	sub    $0x20,%esp
  801883:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801885:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801888:	89 04 24             	mov    %eax,(%esp)
  80188b:	e8 b7 f6 ff ff       	call   800f47 <fd_alloc>
  801890:	89 c3                	mov    %eax,%ebx
  801892:	85 c0                	test   %eax,%eax
  801894:	78 21                	js     8018b7 <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801896:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80189d:	00 
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ac:	e8 42 f3 ff ff       	call   800bf3 <sys_page_alloc>
  8018b1:	89 c3                	mov    %eax,%ebx
  8018b3:	85 c0                	test   %eax,%eax
  8018b5:	79 0c                	jns    8018c3 <alloc_sockfd+0x48>
		nsipc_close(sockid);
  8018b7:	89 34 24             	mov    %esi,(%esp)
  8018ba:	e8 51 02 00 00       	call   801b10 <nsipc_close>
		return r;
  8018bf:	89 d8                	mov    %ebx,%eax
  8018c1:	eb 20                	jmp    8018e3 <alloc_sockfd+0x68>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8018c3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018cc:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018d1:	c7 42 08 02 00 00 00 	movl   $0x2,0x8(%edx)
	sfd->fd_sock.sockid = sockid;
  8018d8:	89 72 0c             	mov    %esi,0xc(%edx)
	return fd2num(sfd);
  8018db:	89 14 24             	mov    %edx,(%esp)
  8018de:	e8 3d f6 ff ff       	call   800f20 <fd2num>
}
  8018e3:	83 c4 20             	add    $0x20,%esp
  8018e6:	5b                   	pop    %ebx
  8018e7:	5e                   	pop    %esi
  8018e8:	5d                   	pop    %ebp
  8018e9:	c3                   	ret    

008018ea <accept>:

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	e8 51 ff ff ff       	call   801849 <fd2sockid>
		return r;
  8018f8:	89 c1                	mov    %eax,%ecx

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 23                	js     801921 <accept+0x37>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8018fe:	8b 55 10             	mov    0x10(%ebp),%edx
  801901:	89 54 24 08          	mov    %edx,0x8(%esp)
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	89 54 24 04          	mov    %edx,0x4(%esp)
  80190c:	89 04 24             	mov    %eax,(%esp)
  80190f:	e8 45 01 00 00       	call   801a59 <nsipc_accept>
		return r;
  801914:	89 c1                	mov    %eax,%ecx
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
	int r;
	if ((r = fd2sockid(s)) < 0)
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801916:	85 c0                	test   %eax,%eax
  801918:	78 07                	js     801921 <accept+0x37>
		return r;
	return alloc_sockfd(r);
  80191a:	e8 5c ff ff ff       	call   80187b <alloc_sockfd>
  80191f:	89 c1                	mov    %eax,%ecx
}
  801921:	89 c8                	mov    %ecx,%eax
  801923:	c9                   	leave  
  801924:	c3                   	ret    

00801925 <bind>:

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	e8 16 ff ff ff       	call   801849 <fd2sockid>
  801933:	89 c2                	mov    %eax,%edx
  801935:	85 d2                	test   %edx,%edx
  801937:	78 16                	js     80194f <bind+0x2a>
		return r;
	return nsipc_bind(r, name, namelen);
  801939:	8b 45 10             	mov    0x10(%ebp),%eax
  80193c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801940:	8b 45 0c             	mov    0xc(%ebp),%eax
  801943:	89 44 24 04          	mov    %eax,0x4(%esp)
  801947:	89 14 24             	mov    %edx,(%esp)
  80194a:	e8 60 01 00 00       	call   801aaf <nsipc_bind>
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <shutdown>:

int
shutdown(int s, int how)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	e8 ea fe ff ff       	call   801849 <fd2sockid>
  80195f:	89 c2                	mov    %eax,%edx
  801961:	85 d2                	test   %edx,%edx
  801963:	78 0f                	js     801974 <shutdown+0x23>
		return r;
	return nsipc_shutdown(r, how);
  801965:	8b 45 0c             	mov    0xc(%ebp),%eax
  801968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196c:	89 14 24             	mov    %edx,(%esp)
  80196f:	e8 7a 01 00 00       	call   801aee <nsipc_shutdown>
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <connect>:
		return 0;
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
  801979:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	e8 c5 fe ff ff       	call   801849 <fd2sockid>
  801984:	89 c2                	mov    %eax,%edx
  801986:	85 d2                	test   %edx,%edx
  801988:	78 16                	js     8019a0 <connect+0x2a>
		return r;
	return nsipc_connect(r, name, namelen);
  80198a:	8b 45 10             	mov    0x10(%ebp),%eax
  80198d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801991:	8b 45 0c             	mov    0xc(%ebp),%eax
  801994:	89 44 24 04          	mov    %eax,0x4(%esp)
  801998:	89 14 24             	mov    %edx,(%esp)
  80199b:	e8 8a 01 00 00       	call   801b2a <nsipc_connect>
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <listen>:

int
listen(int s, int backlog)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	e8 99 fe ff ff       	call   801849 <fd2sockid>
  8019b0:	89 c2                	mov    %eax,%edx
  8019b2:	85 d2                	test   %edx,%edx
  8019b4:	78 0f                	js     8019c5 <listen+0x23>
		return r;
	return nsipc_listen(r, backlog);
  8019b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bd:	89 14 24             	mov    %edx,(%esp)
  8019c0:	e8 a4 01 00 00       	call   801b69 <nsipc_listen>
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019db:	8b 45 08             	mov    0x8(%ebp),%eax
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	e8 98 02 00 00       	call   801c7e <nsipc_socket>
  8019e6:	89 c2                	mov    %eax,%edx
  8019e8:	85 d2                	test   %edx,%edx
  8019ea:	78 05                	js     8019f1 <socket+0x2a>
		return r;
	return alloc_sockfd(r);
  8019ec:	e8 8a fe ff ff       	call   80187b <alloc_sockfd>
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	53                   	push   %ebx
  8019f7:	83 ec 14             	sub    $0x14,%esp
  8019fa:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019fc:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a03:	75 11                	jne    801a16 <nsipc+0x23>
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a05:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  801a0c:	e8 e3 08 00 00       	call   8022f4 <ipc_find_env>
  801a11:	a3 04 40 80 00       	mov    %eax,0x804004
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a16:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a1d:	00 
  801a1e:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  801a25:	00 
  801a26:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a2a:	a1 04 40 80 00       	mov    0x804004,%eax
  801a2f:	89 04 24             	mov    %eax,(%esp)
  801a32:	e8 5f 08 00 00       	call   802296 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a3e:	00 
  801a3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a46:	00 
  801a47:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a4e:	e8 d9 07 00 00       	call   80222c <ipc_recv>
}
  801a53:	83 c4 14             	add    $0x14,%esp
  801a56:	5b                   	pop    %ebx
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	56                   	push   %esi
  801a5d:	53                   	push   %ebx
  801a5e:	83 ec 10             	sub    $0x10,%esp
  801a61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a64:	8b 45 08             	mov    0x8(%ebp),%eax
  801a67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a6c:	8b 06                	mov    (%esi),%eax
  801a6e:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a73:	b8 01 00 00 00       	mov    $0x1,%eax
  801a78:	e8 76 ff ff ff       	call   8019f3 <nsipc>
  801a7d:	89 c3                	mov    %eax,%ebx
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	78 23                	js     801aa6 <nsipc_accept+0x4d>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a83:	a1 10 60 80 00       	mov    0x806010,%eax
  801a88:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a93:	00 
  801a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a97:	89 04 24             	mov    %eax,(%esp)
  801a9a:	e8 d5 ee ff ff       	call   800974 <memmove>
		*addrlen = ret->ret_addrlen;
  801a9f:	a1 10 60 80 00       	mov    0x806010,%eax
  801aa4:	89 06                	mov    %eax,(%esi)
	}
	return r;
}
  801aa6:	89 d8                	mov    %ebx,%eax
  801aa8:	83 c4 10             	add    $0x10,%esp
  801aab:	5b                   	pop    %ebx
  801aac:	5e                   	pop    %esi
  801aad:	5d                   	pop    %ebp
  801aae:	c3                   	ret    

00801aaf <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	53                   	push   %ebx
  801ab3:	83 ec 14             	sub    $0x14,%esp
  801ab6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801ac1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acc:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801ad3:	e8 9c ee ff ff       	call   800974 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ad8:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ade:	b8 02 00 00 00       	mov    $0x2,%eax
  801ae3:	e8 0b ff ff ff       	call   8019f3 <nsipc>
}
  801ae8:	83 c4 14             	add    $0x14,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    

00801aee <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801af4:	8b 45 08             	mov    0x8(%ebp),%eax
  801af7:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b04:	b8 03 00 00 00       	mov    $0x3,%eax
  801b09:	e8 e5 fe ff ff       	call   8019f3 <nsipc>
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <nsipc_close>:

int
nsipc_close(int s)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b1e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b23:	e8 cb fe ff ff       	call   8019f3 <nsipc>
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	53                   	push   %ebx
  801b2e:	83 ec 14             	sub    $0x14,%esp
  801b31:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b47:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801b4e:	e8 21 ee ff ff       	call   800974 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b53:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b59:	b8 05 00 00 00       	mov    $0x5,%eax
  801b5e:	e8 90 fe ff ff       	call   8019f3 <nsipc>
}
  801b63:	83 c4 14             	add    $0x14,%esp
  801b66:	5b                   	pop    %ebx
  801b67:	5d                   	pop    %ebp
  801b68:	c3                   	ret    

00801b69 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b7f:	b8 06 00 00 00       	mov    $0x6,%eax
  801b84:	e8 6a fe ff ff       	call   8019f3 <nsipc>
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
  801b8e:	56                   	push   %esi
  801b8f:	53                   	push   %ebx
  801b90:	83 ec 10             	sub    $0x10,%esp
  801b93:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b9e:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801ba4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ba7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bac:	b8 07 00 00 00       	mov    $0x7,%eax
  801bb1:	e8 3d fe ff ff       	call   8019f3 <nsipc>
  801bb6:	89 c3                	mov    %eax,%ebx
  801bb8:	85 c0                	test   %eax,%eax
  801bba:	78 46                	js     801c02 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801bbc:	39 f0                	cmp    %esi,%eax
  801bbe:	7f 07                	jg     801bc7 <nsipc_recv+0x3c>
  801bc0:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bc5:	7e 24                	jle    801beb <nsipc_recv+0x60>
  801bc7:	c7 44 24 0c 7b 2a 80 	movl   $0x802a7b,0xc(%esp)
  801bce:	00 
  801bcf:	c7 44 24 08 43 2a 80 	movl   $0x802a43,0x8(%esp)
  801bd6:	00 
  801bd7:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  801bde:	00 
  801bdf:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  801be6:	e8 eb 05 00 00       	call   8021d6 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801beb:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bef:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801bf6:	00 
  801bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bfa:	89 04 24             	mov    %eax,(%esp)
  801bfd:	e8 72 ed ff ff       	call   800974 <memmove>
	}

	return r;
}
  801c02:	89 d8                	mov    %ebx,%eax
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    

00801c0b <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
  801c0e:	53                   	push   %ebx
  801c0f:	83 ec 14             	sub    $0x14,%esp
  801c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c1d:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c23:	7e 24                	jle    801c49 <nsipc_send+0x3e>
  801c25:	c7 44 24 0c 9c 2a 80 	movl   $0x802a9c,0xc(%esp)
  801c2c:	00 
  801c2d:	c7 44 24 08 43 2a 80 	movl   $0x802a43,0x8(%esp)
  801c34:	00 
  801c35:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  801c3c:	00 
  801c3d:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  801c44:	e8 8d 05 00 00       	call   8021d6 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c49:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c54:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  801c5b:	e8 14 ed ff ff       	call   800974 <memmove>
	nsipcbuf.send.req_size = size;
  801c60:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c66:	8b 45 14             	mov    0x14(%ebp),%eax
  801c69:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c6e:	b8 08 00 00 00       	mov    $0x8,%eax
  801c73:	e8 7b fd ff ff       	call   8019f3 <nsipc>
}
  801c78:	83 c4 14             	add    $0x14,%esp
  801c7b:	5b                   	pop    %ebx
  801c7c:	5d                   	pop    %ebp
  801c7d:	c3                   	ret    

00801c7e <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c84:	8b 45 08             	mov    0x8(%ebp),%eax
  801c87:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8f:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c94:	8b 45 10             	mov    0x10(%ebp),%eax
  801c97:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c9c:	b8 09 00 00 00       	mov    $0x9,%eax
  801ca1:	e8 4d fd ff ff       	call   8019f3 <nsipc>
}
  801ca6:	c9                   	leave  
  801ca7:	c3                   	ret    

00801ca8 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca8:	55                   	push   %ebp
  801ca9:	89 e5                	mov    %esp,%ebp
  801cab:	56                   	push   %esi
  801cac:	53                   	push   %ebx
  801cad:	83 ec 10             	sub    $0x10,%esp
  801cb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb6:	89 04 24             	mov    %eax,(%esp)
  801cb9:	e8 72 f2 ff ff       	call   800f30 <fd2data>
  801cbe:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cc0:	c7 44 24 04 a8 2a 80 	movl   $0x802aa8,0x4(%esp)
  801cc7:	00 
  801cc8:	89 1c 24             	mov    %ebx,(%esp)
  801ccb:	e8 07 eb ff ff       	call   8007d7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cd0:	8b 46 04             	mov    0x4(%esi),%eax
  801cd3:	2b 06                	sub    (%esi),%eax
  801cd5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cdb:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ce2:	00 00 00 
	stat->st_dev = &devpipe;
  801ce5:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cec:	30 80 00 
	return 0;
}
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 14             	sub    $0x14,%esp
  801d02:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d05:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d10:	e8 85 ef ff ff       	call   800c9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d15:	89 1c 24             	mov    %ebx,(%esp)
  801d18:	e8 13 f2 ff ff       	call   800f30 <fd2data>
  801d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d28:	e8 6d ef ff ff       	call   800c9a <sys_page_unmap>
}
  801d2d:	83 c4 14             	add    $0x14,%esp
  801d30:	5b                   	pop    %ebx
  801d31:	5d                   	pop    %ebp
  801d32:	c3                   	ret    

00801d33 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	57                   	push   %edi
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	83 ec 2c             	sub    $0x2c,%esp
  801d3c:	89 c6                	mov    %eax,%esi
  801d3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = thisenv->env_runs;
  801d41:	a1 08 40 80 00       	mov    0x804008,%eax
  801d46:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d49:	89 34 24             	mov    %esi,(%esp)
  801d4c:	e8 db 05 00 00       	call   80232c <pageref>
  801d51:	89 c7                	mov    %eax,%edi
  801d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d56:	89 04 24             	mov    %eax,(%esp)
  801d59:	e8 ce 05 00 00       	call   80232c <pageref>
  801d5e:	39 c7                	cmp    %eax,%edi
  801d60:	0f 94 c2             	sete   %dl
  801d63:	0f b6 c2             	movzbl %dl,%eax
		nn = thisenv->env_runs;
  801d66:	8b 0d 08 40 80 00    	mov    0x804008,%ecx
  801d6c:	8b 79 58             	mov    0x58(%ecx),%edi
		if (n == nn)
  801d6f:	39 fb                	cmp    %edi,%ebx
  801d71:	74 21                	je     801d94 <_pipeisclosed+0x61>
			return ret;
		if (n != nn && ret == 1)
  801d73:	84 d2                	test   %dl,%dl
  801d75:	74 ca                	je     801d41 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d77:	8b 51 58             	mov    0x58(%ecx),%edx
  801d7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7e:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d86:	c7 04 24 af 2a 80 00 	movl   $0x802aaf,(%esp)
  801d8d:	e8 1a e4 ff ff       	call   8001ac <cprintf>
  801d92:	eb ad                	jmp    801d41 <_pipeisclosed+0xe>
	}
}
  801d94:	83 c4 2c             	add    $0x2c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    

00801d9c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801d9c:	55                   	push   %ebp
  801d9d:	89 e5                	mov    %esp,%ebp
  801d9f:	57                   	push   %edi
  801da0:	56                   	push   %esi
  801da1:	53                   	push   %ebx
  801da2:	83 ec 1c             	sub    $0x1c,%esp
  801da5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801da8:	89 34 24             	mov    %esi,(%esp)
  801dab:	e8 80 f1 ff ff       	call   800f30 <fd2data>
  801db0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801db2:	bf 00 00 00 00       	mov    $0x0,%edi
  801db7:	eb 45                	jmp    801dfe <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801db9:	89 da                	mov    %ebx,%edx
  801dbb:	89 f0                	mov    %esi,%eax
  801dbd:	e8 71 ff ff ff       	call   801d33 <_pipeisclosed>
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	75 41                	jne    801e07 <devpipe_write+0x6b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801dc6:	e8 09 ee ff ff       	call   800bd4 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dcb:	8b 43 04             	mov    0x4(%ebx),%eax
  801dce:	8b 0b                	mov    (%ebx),%ecx
  801dd0:	8d 51 20             	lea    0x20(%ecx),%edx
  801dd3:	39 d0                	cmp    %edx,%eax
  801dd5:	73 e2                	jae    801db9 <devpipe_write+0x1d>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dda:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dde:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de1:	99                   	cltd   
  801de2:	c1 ea 1b             	shr    $0x1b,%edx
  801de5:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
  801de8:	83 e1 1f             	and    $0x1f,%ecx
  801deb:	29 d1                	sub    %edx,%ecx
  801ded:	0f b6 55 e7          	movzbl -0x19(%ebp),%edx
  801df1:	88 54 0b 08          	mov    %dl,0x8(%ebx,%ecx,1)
		p->p_wpos++;
  801df5:	83 c0 01             	add    $0x1,%eax
  801df8:	89 43 04             	mov    %eax,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801dfb:	83 c7 01             	add    $0x1,%edi
  801dfe:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e01:	75 c8                	jne    801dcb <devpipe_write+0x2f>
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
  801e03:	89 f8                	mov    %edi,%eax
  801e05:	eb 05                	jmp    801e0c <devpipe_write+0x70>
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e07:	b8 00 00 00 00       	mov    $0x0,%eax
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}

	return i;
}
  801e0c:	83 c4 1c             	add    $0x1c,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    

00801e14 <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	57                   	push   %edi
  801e18:	56                   	push   %esi
  801e19:	53                   	push   %ebx
  801e1a:	83 ec 1c             	sub    $0x1c,%esp
  801e1d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801e20:	89 3c 24             	mov    %edi,(%esp)
  801e23:	e8 08 f1 ff ff       	call   800f30 <fd2data>
  801e28:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e2a:	be 00 00 00 00       	mov    $0x0,%esi
  801e2f:	eb 3d                	jmp    801e6e <devpipe_read+0x5a>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801e31:	85 f6                	test   %esi,%esi
  801e33:	74 04                	je     801e39 <devpipe_read+0x25>
				return i;
  801e35:	89 f0                	mov    %esi,%eax
  801e37:	eb 43                	jmp    801e7c <devpipe_read+0x68>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801e39:	89 da                	mov    %ebx,%edx
  801e3b:	89 f8                	mov    %edi,%eax
  801e3d:	e8 f1 fe ff ff       	call   801d33 <_pipeisclosed>
  801e42:	85 c0                	test   %eax,%eax
  801e44:	75 31                	jne    801e77 <devpipe_read+0x63>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801e46:	e8 89 ed ff ff       	call   800bd4 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801e4b:	8b 03                	mov    (%ebx),%eax
  801e4d:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e50:	74 df                	je     801e31 <devpipe_read+0x1d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e52:	99                   	cltd   
  801e53:	c1 ea 1b             	shr    $0x1b,%edx
  801e56:	01 d0                	add    %edx,%eax
  801e58:	83 e0 1f             	and    $0x1f,%eax
  801e5b:	29 d0                	sub    %edx,%eax
  801e5d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e65:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e68:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			thisenv->env_id, uvpt[PGNUM(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e6b:	83 c6 01             	add    $0x1,%esi
  801e6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e71:	75 d8                	jne    801e4b <devpipe_read+0x37>
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801e73:	89 f0                	mov    %esi,%eax
  801e75:	eb 05                	jmp    801e7c <devpipe_read+0x68>
			// if we got any data, return it
			if (i > 0)
				return i;
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
				return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
}
  801e7c:	83 c4 1c             	add    $0x1c,%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	56                   	push   %esi
  801e88:	53                   	push   %ebx
  801e89:	83 ec 30             	sub    $0x30,%esp
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e8f:	89 04 24             	mov    %eax,(%esp)
  801e92:	e8 b0 f0 ff ff       	call   800f47 <fd_alloc>
  801e97:	89 c2                	mov    %eax,%edx
  801e99:	85 d2                	test   %edx,%edx
  801e9b:	0f 88 4d 01 00 00    	js     801fee <pipe+0x16a>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea1:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ea8:	00 
  801ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eb0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eb7:	e8 37 ed ff ff       	call   800bf3 <sys_page_alloc>
  801ebc:	89 c2                	mov    %eax,%edx
  801ebe:	85 d2                	test   %edx,%edx
  801ec0:	0f 88 28 01 00 00    	js     801fee <pipe+0x16a>
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801ec6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ec9:	89 04 24             	mov    %eax,(%esp)
  801ecc:	e8 76 f0 ff ff       	call   800f47 <fd_alloc>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 88 fe 00 00 00    	js     801fd9 <pipe+0x155>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edb:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ee2:	00 
  801ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef1:	e8 fd ec ff ff       	call   800bf3 <sys_page_alloc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	85 c0                	test   %eax,%eax
  801efa:	0f 88 d9 00 00 00    	js     801fd9 <pipe+0x155>
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f03:	89 04 24             	mov    %eax,(%esp)
  801f06:	e8 25 f0 ff ff       	call   800f30 <fd2data>
  801f0b:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0d:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801f14:	00 
  801f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f20:	e8 ce ec ff ff       	call   800bf3 <sys_page_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	85 c0                	test   %eax,%eax
  801f29:	0f 88 97 00 00 00    	js     801fc6 <pipe+0x142>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	89 04 24             	mov    %eax,(%esp)
  801f35:	e8 f6 ef ff ff       	call   800f30 <fd2data>
  801f3a:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801f41:	00 
  801f42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f4d:	00 
  801f4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f59:	e8 e9 ec ff ff       	call   800c47 <sys_page_map>
  801f5e:	89 c3                	mov    %eax,%ebx
  801f60:	85 c0                	test   %eax,%eax
  801f62:	78 52                	js     801fb6 <pipe+0x132>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801f64:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

	fd1->fd_dev_id = devpipe.dev_id;
  801f79:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f82:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", thisenv->env_id, uvpt[PGNUM(va)]);

	pfd[0] = fd2num(fd0);
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	89 04 24             	mov    %eax,(%esp)
  801f94:	e8 87 ef ff ff       	call   800f20 <fd2num>
  801f99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa1:	89 04 24             	mov    %eax,(%esp)
  801fa4:	e8 77 ef ff ff       	call   800f20 <fd2num>
  801fa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801faf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fb4:	eb 38                	jmp    801fee <pipe+0x16a>

    err3:
	sys_page_unmap(0, va);
  801fb6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc1:	e8 d4 ec ff ff       	call   800c9a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fcd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd4:	e8 c1 ec ff ff       	call   800c9a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fe7:	e8 ae ec ff ff       	call   800c9a <sys_page_unmap>
  801fec:	89 d8                	mov    %ebx,%eax
    err:
	return r;
}
  801fee:	83 c4 30             	add    $0x30,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ffb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802002:	8b 45 08             	mov    0x8(%ebp),%eax
  802005:	89 04 24             	mov    %eax,(%esp)
  802008:	e8 89 ef ff ff       	call   800f96 <fd_lookup>
  80200d:	89 c2                	mov    %eax,%edx
  80200f:	85 d2                	test   %edx,%edx
  802011:	78 15                	js     802028 <pipeisclosed+0x33>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802016:	89 04 24             	mov    %eax,(%esp)
  802019:	e8 12 ef ff ff       	call   800f30 <fd2data>
	return _pipeisclosed(fd, p);
  80201e:	89 c2                	mov    %eax,%edx
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	e8 0b fd ff ff       	call   801d33 <_pipeisclosed>
}
  802028:	c9                   	leave  
  802029:	c3                   	ret    
  80202a:	66 90                	xchg   %ax,%ax
  80202c:	66 90                	xchg   %ax,%ax
  80202e:	66 90                	xchg   %ax,%ax

00802030 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802033:	b8 00 00 00 00       	mov    $0x0,%eax
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    

0080203a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80203a:	55                   	push   %ebp
  80203b:	89 e5                	mov    %esp,%ebp
  80203d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802040:	c7 44 24 04 c7 2a 80 	movl   $0x802ac7,0x4(%esp)
  802047:	00 
  802048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80204b:	89 04 24             	mov    %eax,(%esp)
  80204e:	e8 84 e7 ff ff       	call   8007d7 <strcpy>
	return 0;
}
  802053:	b8 00 00 00 00       	mov    $0x0,%eax
  802058:	c9                   	leave  
  802059:	c3                   	ret    

0080205a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	57                   	push   %edi
  80205e:	56                   	push   %esi
  80205f:	53                   	push   %ebx
  802060:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802066:	bb 00 00 00 00       	mov    $0x0,%ebx
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80206b:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802071:	eb 31                	jmp    8020a4 <devcons_write+0x4a>
		m = n - tot;
  802073:	8b 75 10             	mov    0x10(%ebp),%esi
  802076:	29 de                	sub    %ebx,%esi
		if (m > sizeof(buf) - 1)
  802078:	83 fe 7f             	cmp    $0x7f,%esi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80207b:	ba 7f 00 00 00       	mov    $0x7f,%edx
  802080:	0f 47 f2             	cmova  %edx,%esi
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802083:	89 74 24 08          	mov    %esi,0x8(%esp)
  802087:	03 45 0c             	add    0xc(%ebp),%eax
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	89 3c 24             	mov    %edi,(%esp)
  802091:	e8 de e8 ff ff       	call   800974 <memmove>
		sys_cputs(buf, m);
  802096:	89 74 24 04          	mov    %esi,0x4(%esp)
  80209a:	89 3c 24             	mov    %edi,(%esp)
  80209d:	e8 84 ea ff ff       	call   800b26 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs,
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8020a2:	01 f3                	add    %esi,%ebx
  8020a4:	89 d8                	mov    %ebx,%eax
  8020a6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8020a9:	72 c8                	jb     802073 <devcons_write+0x19>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8020ab:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8020b1:	5b                   	pop    %ebx
  8020b2:	5e                   	pop    %esi
  8020b3:	5f                   	pop    %edi
  8020b4:	5d                   	pop    %ebp
  8020b5:	c3                   	ret    

008020b6 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
		return 0;
  8020bc:	b8 00 00 00 00       	mov    $0x0,%eax
static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
	int c;

	if (n == 0)
  8020c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c5:	75 07                	jne    8020ce <devcons_read+0x18>
  8020c7:	eb 2a                	jmp    8020f3 <devcons_read+0x3d>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8020c9:	e8 06 eb ff ff       	call   800bd4 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8020ce:	66 90                	xchg   %ax,%ax
  8020d0:	e8 6f ea ff ff       	call   800b44 <sys_cgetc>
  8020d5:	85 c0                	test   %eax,%eax
  8020d7:	74 f0                	je     8020c9 <devcons_read+0x13>
		sys_yield();
	if (c < 0)
  8020d9:	85 c0                	test   %eax,%eax
  8020db:	78 16                	js     8020f3 <devcons_read+0x3d>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8020dd:	83 f8 04             	cmp    $0x4,%eax
  8020e0:	74 0c                	je     8020ee <devcons_read+0x38>
		return 0;
	*(char*)vbuf = c;
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	88 02                	mov    %al,(%edx)
	return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ec:	eb 05                	jmp    8020f3 <devcons_read+0x3d>
	while ((c = sys_cgetc()) == 0)
		sys_yield();
	if (c < 0)
		return c;
	if (c == 0x04)	// ctl-d is eof
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
	*(char*)vbuf = c;
	return 1;
}
  8020f3:	c9                   	leave  
  8020f4:	c3                   	ret    

008020f5 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802101:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802108:	00 
  802109:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80210c:	89 04 24             	mov    %eax,(%esp)
  80210f:	e8 12 ea ff ff       	call   800b26 <sys_cputs>
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <getchar>:

int
getchar(void)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80211c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802123:	00 
  802124:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802132:	e8 f3 f0 ff ff       	call   80122a <read>
	if (r < 0)
  802137:	85 c0                	test   %eax,%eax
  802139:	78 0f                	js     80214a <getchar+0x34>
		return r;
	if (r < 1)
  80213b:	85 c0                	test   %eax,%eax
  80213d:	7e 06                	jle    802145 <getchar+0x2f>
		return -E_EOF;
	return c;
  80213f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  802143:	eb 05                	jmp    80214a <getchar+0x34>
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
	if (r < 0)
		return r;
	if (r < 1)
		return -E_EOF;
  802145:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
	return c;
}
  80214a:	c9                   	leave  
  80214b:	c3                   	ret    

0080214c <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  80214c:	55                   	push   %ebp
  80214d:	89 e5                	mov    %esp,%ebp
  80214f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802152:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802155:	89 44 24 04          	mov    %eax,0x4(%esp)
  802159:	8b 45 08             	mov    0x8(%ebp),%eax
  80215c:	89 04 24             	mov    %eax,(%esp)
  80215f:	e8 32 ee ff ff       	call   800f96 <fd_lookup>
  802164:	85 c0                	test   %eax,%eax
  802166:	78 11                	js     802179 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216b:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802171:	39 10                	cmp    %edx,(%eax)
  802173:	0f 94 c0             	sete   %al
  802176:	0f b6 c0             	movzbl %al,%eax
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <opencons>:

int
opencons(void)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802181:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802184:	89 04 24             	mov    %eax,(%esp)
  802187:	e8 bb ed ff ff       	call   800f47 <fd_alloc>
		return r;
  80218c:	89 c2                	mov    %eax,%edx
opencons(void)
{
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  80218e:	85 c0                	test   %eax,%eax
  802190:	78 40                	js     8021d2 <opencons+0x57>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802192:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802199:	00 
  80219a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a8:	e8 46 ea ff ff       	call   800bf3 <sys_page_alloc>
		return r;
  8021ad:	89 c2                	mov    %eax,%edx
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021af:	85 c0                	test   %eax,%eax
  8021b1:	78 1f                	js     8021d2 <opencons+0x57>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8021b3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021c8:	89 04 24             	mov    %eax,(%esp)
  8021cb:	e8 50 ed ff ff       	call   800f20 <fd2num>
  8021d0:	89 c2                	mov    %eax,%edx
}
  8021d2:	89 d0                	mov    %edx,%eax
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	56                   	push   %esi
  8021da:	53                   	push   %ebx
  8021db:	83 ec 20             	sub    $0x20,%esp
	va_list ap;

	va_start(ap, fmt);
  8021de:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021e1:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021e7:	e8 c9 e9 ff ff       	call   800bb5 <sys_getenvid>
  8021ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021ef:	89 54 24 10          	mov    %edx,0x10(%esp)
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021fa:	89 74 24 08          	mov    %esi,0x8(%esp)
  8021fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802202:	c7 04 24 d4 2a 80 00 	movl   $0x802ad4,(%esp)
  802209:	e8 9e df ff ff       	call   8001ac <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80220e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802212:	8b 45 10             	mov    0x10(%ebp),%eax
  802215:	89 04 24             	mov    %eax,(%esp)
  802218:	e8 2e df ff ff       	call   80014b <vcprintf>
	cprintf("\n");
  80221d:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  802224:	e8 83 df ff ff       	call   8001ac <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802229:	cc                   	int3   
  80222a:	eb fd                	jmp    802229 <_panic+0x53>

0080222c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	56                   	push   %esi
  802230:	53                   	push   %ebx
  802231:	83 ec 10             	sub    $0x10,%esp
  802234:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.

	int return_code ;
	//cprintf("in ipc_recv function\n");
	if(pg ==NULL)
  80223d:	85 c0                	test   %eax,%eax
		pg = (void*)0xfffffffff;
  80223f:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  802244:	0f 44 c2             	cmove  %edx,%eax
	if((pg!=NULL))
	{
		if((return_code=sys_ipc_recv(pg))==0)
  802247:	89 04 24             	mov    %eax,(%esp)
  80224a:	e8 ba eb ff ff       	call   800e09 <sys_ipc_recv>
  80224f:	85 c0                	test   %eax,%eax
  802251:	75 1e                	jne    802271 <ipc_recv+0x45>
		{
			if(from_env_store!=NULL)
  802253:	85 db                	test   %ebx,%ebx
  802255:	74 0a                	je     802261 <ipc_recv+0x35>
			*from_env_store = thisenv->env_ipc_from;
  802257:	a1 08 40 80 00       	mov    0x804008,%eax
  80225c:	8b 40 74             	mov    0x74(%eax),%eax
  80225f:	89 03                	mov    %eax,(%ebx)
			if(perm_store!=NULL)
  802261:	85 f6                	test   %esi,%esi
  802263:	74 22                	je     802287 <ipc_recv+0x5b>
			*perm_store = thisenv->env_ipc_perm;
  802265:	a1 08 40 80 00       	mov    0x804008,%eax
  80226a:	8b 40 78             	mov    0x78(%eax),%eax
  80226d:	89 06                	mov    %eax,(%esi)
  80226f:	eb 16                	jmp    802287 <ipc_recv+0x5b>
		}
		else
		{
			if(perm_store!=NULL)
  802271:	85 f6                	test   %esi,%esi
  802273:	74 06                	je     80227b <ipc_recv+0x4f>
				*perm_store = 0;
  802275:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
			if(from_env_store!=NULL)
  80227b:	85 db                	test   %ebx,%ebx
  80227d:	74 10                	je     80228f <ipc_recv+0x63>
				*from_env_store=0;
  80227f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802285:	eb 08                	jmp    80228f <ipc_recv+0x63>
			return return_code;
		}
		
	}
return thisenv->env_ipc_value;
  802287:	a1 08 40 80 00       	mov    0x804008,%eax
  80228c:	8b 40 70             	mov    0x70(%eax),%eax
	//panic("ipc_recv not implemented");
	//return 0;

}
  80228f:	83 c4 10             	add    $0x10,%esp
  802292:	5b                   	pop    %ebx
  802293:	5e                   	pop    %esi
  802294:	5d                   	pop    %ebp
  802295:	c3                   	ret    

00802296 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802296:	55                   	push   %ebp
  802297:	89 e5                	mov    %esp,%ebp
  802299:	57                   	push   %edi
  80229a:	56                   	push   %esi
  80229b:	53                   	push   %ebx
  80229c:	83 ec 1c             	sub    $0x1c,%esp
  80229f:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8022a5:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.

	if(pg ==NULL)
  8022a8:	85 db                	test   %ebx,%ebx
		pg = (void*)KERNBASE;
  8022aa:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
  8022af:	0f 44 d8             	cmove  %eax,%ebx
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8022b2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022b6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	89 04 24             	mov    %eax,(%esp)
  8022c4:	e8 1d eb ff ff       	call   800de6 <sys_ipc_try_send>
	while(return_code == -E_IPC_NOT_RECV)
  8022c9:	eb 1c                	jmp    8022e7 <ipc_send+0x51>
	{
		sys_yield();
  8022cb:	e8 04 e9 ff ff       	call   800bd4 <sys_yield>
		return_code = sys_ipc_try_send(to_env,val,pg,perm);
  8022d0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8022d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	89 04 24             	mov    %eax,(%esp)
  8022e2:	e8 ff ea ff ff       	call   800de6 <sys_ipc_try_send>
	// LAB 4: Your code here.

	if(pg ==NULL)
		pg = (void*)KERNBASE;
	int return_code = sys_ipc_try_send(to_env,val,pg,perm);
	while(return_code == -E_IPC_NOT_RECV)
  8022e7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022ea:	74 df                	je     8022cb <ipc_send+0x35>


	}
	//panic("ipc_send not implemented");

}
  8022ec:	83 c4 1c             	add    $0x1c,%esp
  8022ef:	5b                   	pop    %ebx
  8022f0:	5e                   	pop    %esi
  8022f1:	5f                   	pop    %edi
  8022f2:	5d                   	pop    %ebp
  8022f3:	c3                   	ret    

008022f4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022f4:	55                   	push   %ebp
  8022f5:	89 e5                	mov    %esp,%ebp
  8022f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022ff:	6b d0 7c             	imul   $0x7c,%eax,%edx
  802302:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802308:	8b 52 50             	mov    0x50(%edx),%edx
  80230b:	39 ca                	cmp    %ecx,%edx
  80230d:	75 0d                	jne    80231c <ipc_find_env+0x28>
			return envs[i].env_id;
  80230f:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802312:	05 08 00 c0 ee       	add    $0xeec00008,%eax
  802317:	8b 40 40             	mov    0x40(%eax),%eax
  80231a:	eb 0e                	jmp    80232a <ipc_find_env+0x36>
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
	int i;
	for (i = 0; i < NENV; i++)
  80231c:	83 c0 01             	add    $0x1,%eax
  80231f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802324:	75 d9                	jne    8022ff <ipc_find_env+0xb>
		if (envs[i].env_type == type)
			return envs[i].env_id;
	return 0;
  802326:	66 b8 00 00          	mov    $0x0,%ax
}
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    

0080232c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802332:	89 d0                	mov    %edx,%eax
  802334:	c1 e8 16             	shr    $0x16,%eax
  802337:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  80233e:	b8 00 00 00 00       	mov    $0x0,%eax
int
pageref(void *v)
{
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802343:	f6 c1 01             	test   $0x1,%cl
  802346:	74 1d                	je     802365 <pageref+0x39>
		return 0;
	pte = uvpt[PGNUM(v)];
  802348:	c1 ea 0c             	shr    $0xc,%edx
  80234b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802352:	f6 c2 01             	test   $0x1,%dl
  802355:	74 0e                	je     802365 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802357:	c1 ea 0c             	shr    $0xc,%edx
  80235a:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802361:	ef 
  802362:	0f b7 c0             	movzwl %ax,%eax
}
  802365:	5d                   	pop    %ebp
  802366:	c3                   	ret    
  802367:	66 90                	xchg   %ax,%ax
  802369:	66 90                	xchg   %ax,%ax
  80236b:	66 90                	xchg   %ax,%ax
  80236d:	66 90                	xchg   %ax,%ax
  80236f:	90                   	nop

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	83 ec 0c             	sub    $0xc,%esp
  802376:	8b 44 24 28          	mov    0x28(%esp),%eax
  80237a:	8b 7c 24 1c          	mov    0x1c(%esp),%edi
  80237e:	8b 6c 24 20          	mov    0x20(%esp),%ebp
  802382:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  802386:	85 c0                	test   %eax,%eax
  802388:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80238c:	89 ea                	mov    %ebp,%edx
  80238e:	89 0c 24             	mov    %ecx,(%esp)
  802391:	75 2d                	jne    8023c0 <__udivdi3+0x50>
  802393:	39 e9                	cmp    %ebp,%ecx
  802395:	77 61                	ja     8023f8 <__udivdi3+0x88>
  802397:	85 c9                	test   %ecx,%ecx
  802399:	89 ce                	mov    %ecx,%esi
  80239b:	75 0b                	jne    8023a8 <__udivdi3+0x38>
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	31 d2                	xor    %edx,%edx
  8023a4:	f7 f1                	div    %ecx
  8023a6:	89 c6                	mov    %eax,%esi
  8023a8:	31 d2                	xor    %edx,%edx
  8023aa:	89 e8                	mov    %ebp,%eax
  8023ac:	f7 f6                	div    %esi
  8023ae:	89 c5                	mov    %eax,%ebp
  8023b0:	89 f8                	mov    %edi,%eax
  8023b2:	f7 f6                	div    %esi
  8023b4:	89 ea                	mov    %ebp,%edx
  8023b6:	83 c4 0c             	add    $0xc,%esp
  8023b9:	5e                   	pop    %esi
  8023ba:	5f                   	pop    %edi
  8023bb:	5d                   	pop    %ebp
  8023bc:	c3                   	ret    
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	39 e8                	cmp    %ebp,%eax
  8023c2:	77 24                	ja     8023e8 <__udivdi3+0x78>
  8023c4:	0f bd e8             	bsr    %eax,%ebp
  8023c7:	83 f5 1f             	xor    $0x1f,%ebp
  8023ca:	75 3c                	jne    802408 <__udivdi3+0x98>
  8023cc:	8b 74 24 04          	mov    0x4(%esp),%esi
  8023d0:	39 34 24             	cmp    %esi,(%esp)
  8023d3:	0f 86 9f 00 00 00    	jbe    802478 <__udivdi3+0x108>
  8023d9:	39 d0                	cmp    %edx,%eax
  8023db:	0f 82 97 00 00 00    	jb     802478 <__udivdi3+0x108>
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	31 d2                	xor    %edx,%edx
  8023ea:	31 c0                	xor    %eax,%eax
  8023ec:	83 c4 0c             	add    $0xc,%esp
  8023ef:	5e                   	pop    %esi
  8023f0:	5f                   	pop    %edi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    
  8023f3:	90                   	nop
  8023f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 f8                	mov    %edi,%eax
  8023fa:	f7 f1                	div    %ecx
  8023fc:	31 d2                	xor    %edx,%edx
  8023fe:	83 c4 0c             	add    $0xc,%esp
  802401:	5e                   	pop    %esi
  802402:	5f                   	pop    %edi
  802403:	5d                   	pop    %ebp
  802404:	c3                   	ret    
  802405:	8d 76 00             	lea    0x0(%esi),%esi
  802408:	89 e9                	mov    %ebp,%ecx
  80240a:	8b 3c 24             	mov    (%esp),%edi
  80240d:	d3 e0                	shl    %cl,%eax
  80240f:	89 c6                	mov    %eax,%esi
  802411:	b8 20 00 00 00       	mov    $0x20,%eax
  802416:	29 e8                	sub    %ebp,%eax
  802418:	89 c1                	mov    %eax,%ecx
  80241a:	d3 ef                	shr    %cl,%edi
  80241c:	89 e9                	mov    %ebp,%ecx
  80241e:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802422:	8b 3c 24             	mov    (%esp),%edi
  802425:	09 74 24 08          	or     %esi,0x8(%esp)
  802429:	89 d6                	mov    %edx,%esi
  80242b:	d3 e7                	shl    %cl,%edi
  80242d:	89 c1                	mov    %eax,%ecx
  80242f:	89 3c 24             	mov    %edi,(%esp)
  802432:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802436:	d3 ee                	shr    %cl,%esi
  802438:	89 e9                	mov    %ebp,%ecx
  80243a:	d3 e2                	shl    %cl,%edx
  80243c:	89 c1                	mov    %eax,%ecx
  80243e:	d3 ef                	shr    %cl,%edi
  802440:	09 d7                	or     %edx,%edi
  802442:	89 f2                	mov    %esi,%edx
  802444:	89 f8                	mov    %edi,%eax
  802446:	f7 74 24 08          	divl   0x8(%esp)
  80244a:	89 d6                	mov    %edx,%esi
  80244c:	89 c7                	mov    %eax,%edi
  80244e:	f7 24 24             	mull   (%esp)
  802451:	39 d6                	cmp    %edx,%esi
  802453:	89 14 24             	mov    %edx,(%esp)
  802456:	72 30                	jb     802488 <__udivdi3+0x118>
  802458:	8b 54 24 04          	mov    0x4(%esp),%edx
  80245c:	89 e9                	mov    %ebp,%ecx
  80245e:	d3 e2                	shl    %cl,%edx
  802460:	39 c2                	cmp    %eax,%edx
  802462:	73 05                	jae    802469 <__udivdi3+0xf9>
  802464:	3b 34 24             	cmp    (%esp),%esi
  802467:	74 1f                	je     802488 <__udivdi3+0x118>
  802469:	89 f8                	mov    %edi,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	e9 7a ff ff ff       	jmp    8023ec <__udivdi3+0x7c>
  802472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802478:	31 d2                	xor    %edx,%edx
  80247a:	b8 01 00 00 00       	mov    $0x1,%eax
  80247f:	e9 68 ff ff ff       	jmp    8023ec <__udivdi3+0x7c>
  802484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802488:	8d 47 ff             	lea    -0x1(%edi),%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	83 c4 0c             	add    $0xc,%esp
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    
  802494:	66 90                	xchg   %ax,%ax
  802496:	66 90                	xchg   %ax,%ax
  802498:	66 90                	xchg   %ax,%ax
  80249a:	66 90                	xchg   %ax,%ax
  80249c:	66 90                	xchg   %ax,%ax
  80249e:	66 90                	xchg   %ax,%ax

008024a0 <__umoddi3>:
  8024a0:	55                   	push   %ebp
  8024a1:	57                   	push   %edi
  8024a2:	56                   	push   %esi
  8024a3:	83 ec 14             	sub    $0x14,%esp
  8024a6:	8b 44 24 28          	mov    0x28(%esp),%eax
  8024aa:	8b 4c 24 24          	mov    0x24(%esp),%ecx
  8024ae:	8b 74 24 2c          	mov    0x2c(%esp),%esi
  8024b2:	89 c7                	mov    %eax,%edi
  8024b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b8:	8b 44 24 30          	mov    0x30(%esp),%eax
  8024bc:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8024c0:	89 34 24             	mov    %esi,(%esp)
  8024c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	89 c2                	mov    %eax,%edx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	75 17                	jne    8024e8 <__umoddi3+0x48>
  8024d1:	39 fe                	cmp    %edi,%esi
  8024d3:	76 4b                	jbe    802520 <__umoddi3+0x80>
  8024d5:	89 c8                	mov    %ecx,%eax
  8024d7:	89 fa                	mov    %edi,%edx
  8024d9:	f7 f6                	div    %esi
  8024db:	89 d0                	mov    %edx,%eax
  8024dd:	31 d2                	xor    %edx,%edx
  8024df:	83 c4 14             	add    $0x14,%esp
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	66 90                	xchg   %ax,%ax
  8024e8:	39 f8                	cmp    %edi,%eax
  8024ea:	77 54                	ja     802540 <__umoddi3+0xa0>
  8024ec:	0f bd e8             	bsr    %eax,%ebp
  8024ef:	83 f5 1f             	xor    $0x1f,%ebp
  8024f2:	75 5c                	jne    802550 <__umoddi3+0xb0>
  8024f4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8024f8:	39 3c 24             	cmp    %edi,(%esp)
  8024fb:	0f 87 e7 00 00 00    	ja     8025e8 <__umoddi3+0x148>
  802501:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802505:	29 f1                	sub    %esi,%ecx
  802507:	19 c7                	sbb    %eax,%edi
  802509:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80250d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802511:	8b 44 24 08          	mov    0x8(%esp),%eax
  802515:	8b 54 24 0c          	mov    0xc(%esp),%edx
  802519:	83 c4 14             	add    $0x14,%esp
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    
  802520:	85 f6                	test   %esi,%esi
  802522:	89 f5                	mov    %esi,%ebp
  802524:	75 0b                	jne    802531 <__umoddi3+0x91>
  802526:	b8 01 00 00 00       	mov    $0x1,%eax
  80252b:	31 d2                	xor    %edx,%edx
  80252d:	f7 f6                	div    %esi
  80252f:	89 c5                	mov    %eax,%ebp
  802531:	8b 44 24 04          	mov    0x4(%esp),%eax
  802535:	31 d2                	xor    %edx,%edx
  802537:	f7 f5                	div    %ebp
  802539:	89 c8                	mov    %ecx,%eax
  80253b:	f7 f5                	div    %ebp
  80253d:	eb 9c                	jmp    8024db <__umoddi3+0x3b>
  80253f:	90                   	nop
  802540:	89 c8                	mov    %ecx,%eax
  802542:	89 fa                	mov    %edi,%edx
  802544:	83 c4 14             	add    $0x14,%esp
  802547:	5e                   	pop    %esi
  802548:	5f                   	pop    %edi
  802549:	5d                   	pop    %ebp
  80254a:	c3                   	ret    
  80254b:	90                   	nop
  80254c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802550:	8b 04 24             	mov    (%esp),%eax
  802553:	be 20 00 00 00       	mov    $0x20,%esi
  802558:	89 e9                	mov    %ebp,%ecx
  80255a:	29 ee                	sub    %ebp,%esi
  80255c:	d3 e2                	shl    %cl,%edx
  80255e:	89 f1                	mov    %esi,%ecx
  802560:	d3 e8                	shr    %cl,%eax
  802562:	89 e9                	mov    %ebp,%ecx
  802564:	89 44 24 04          	mov    %eax,0x4(%esp)
  802568:	8b 04 24             	mov    (%esp),%eax
  80256b:	09 54 24 04          	or     %edx,0x4(%esp)
  80256f:	89 fa                	mov    %edi,%edx
  802571:	d3 e0                	shl    %cl,%eax
  802573:	89 f1                	mov    %esi,%ecx
  802575:	89 44 24 08          	mov    %eax,0x8(%esp)
  802579:	8b 44 24 10          	mov    0x10(%esp),%eax
  80257d:	d3 ea                	shr    %cl,%edx
  80257f:	89 e9                	mov    %ebp,%ecx
  802581:	d3 e7                	shl    %cl,%edi
  802583:	89 f1                	mov    %esi,%ecx
  802585:	d3 e8                	shr    %cl,%eax
  802587:	89 e9                	mov    %ebp,%ecx
  802589:	09 f8                	or     %edi,%eax
  80258b:	8b 7c 24 10          	mov    0x10(%esp),%edi
  80258f:	f7 74 24 04          	divl   0x4(%esp)
  802593:	d3 e7                	shl    %cl,%edi
  802595:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802599:	89 d7                	mov    %edx,%edi
  80259b:	f7 64 24 08          	mull   0x8(%esp)
  80259f:	39 d7                	cmp    %edx,%edi
  8025a1:	89 c1                	mov    %eax,%ecx
  8025a3:	89 14 24             	mov    %edx,(%esp)
  8025a6:	72 2c                	jb     8025d4 <__umoddi3+0x134>
  8025a8:	39 44 24 0c          	cmp    %eax,0xc(%esp)
  8025ac:	72 22                	jb     8025d0 <__umoddi3+0x130>
  8025ae:	8b 44 24 0c          	mov    0xc(%esp),%eax
  8025b2:	29 c8                	sub    %ecx,%eax
  8025b4:	19 d7                	sbb    %edx,%edi
  8025b6:	89 e9                	mov    %ebp,%ecx
  8025b8:	89 fa                	mov    %edi,%edx
  8025ba:	d3 e8                	shr    %cl,%eax
  8025bc:	89 f1                	mov    %esi,%ecx
  8025be:	d3 e2                	shl    %cl,%edx
  8025c0:	89 e9                	mov    %ebp,%ecx
  8025c2:	d3 ef                	shr    %cl,%edi
  8025c4:	09 d0                	or     %edx,%eax
  8025c6:	89 fa                	mov    %edi,%edx
  8025c8:	83 c4 14             	add    $0x14,%esp
  8025cb:	5e                   	pop    %esi
  8025cc:	5f                   	pop    %edi
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    
  8025cf:	90                   	nop
  8025d0:	39 d7                	cmp    %edx,%edi
  8025d2:	75 da                	jne    8025ae <__umoddi3+0x10e>
  8025d4:	8b 14 24             	mov    (%esp),%edx
  8025d7:	89 c1                	mov    %eax,%ecx
  8025d9:	2b 4c 24 08          	sub    0x8(%esp),%ecx
  8025dd:	1b 54 24 04          	sbb    0x4(%esp),%edx
  8025e1:	eb cb                	jmp    8025ae <__umoddi3+0x10e>
  8025e3:	90                   	nop
  8025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025e8:	3b 44 24 0c          	cmp    0xc(%esp),%eax
  8025ec:	0f 82 0f ff ff ff    	jb     802501 <__umoddi3+0x61>
  8025f2:	e9 1a ff ff ff       	jmp    802511 <__umoddi3+0x71>
